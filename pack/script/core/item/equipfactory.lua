----------------------------------------------------------
-- file:	equipfactory.lua
-- Author:	page
-- Time:	2015/07/01 15:52 我党生日
-- Desc:	兵工厂：装备操作逻辑(升星、淬炼)
----------------------------------------------------------
require("script/core/configmanager/configmanager");
local l_tbStarConfig = mconfig.loadConfig("script/cfg/equip/eqStar")

--data struct 
local TB_STRUCT_EQUIP_FACTORY = {
	m_Instance = nil;
	----------------------------------
	-- 升星
	m_equipSelected = nil,				-- 需要处理的装备

	m_tbMaterials = {		-- 材料存储
		-- [nIndex]: 这里的index对应升星面板的五个位置
		--[1] = itemid,
		--[2] = itemid,
		--[3] = itemid,
		--[4] = itemid,
		--[5] = itemid,
	},
	
	m_tbMaterialsID = {		-- 材料ID，策划设定：这是固定的，千万注意！！！
		17901, 					-- 一级强化石
		17902, 					-- 二级强化石
		17903, 					-- 三级强化石
		17904,					-- 四级强化石
		17905,					-- 五级强化石
	},
	
	m_tbMaterialsCount = {	-- 统计材料数量(用来显示材料面板以及发送给服务器的数据)
		--[id] = nNum,
	},	
	----------------------------------
	-- 淬炼
	m_equipIndex2 = 0,		-- 被淬炼装备索引
	m_nSelAttr = 0,			-- 选择的属性(点击确定后再清空)
}
--------------------------------)
KGC_EQUIP_FACTORY_TYPE = class("KGC_EQUIP_FACTORY_TYPE", CLASS_BASE_TYPE, TB_STRUCT_EQUIP_FACTORY)
--------------------------------
--function
--------------------------------

function KGC_EQUIP_FACTORY_TYPE:ctor()	
	
end
--------------------------------------------------------------
function KGC_EQUIP_FACTORY_TYPE:Init(tbArg)
	self:ClearData();
end

function KGC_EQUIP_FACTORY_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_EQUIP_FACTORY_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end

function KGC_EQUIP_FACTORY_TYPE:ClearData()
	print("KGC_EQUIP_FACTORY_TYPE:ClearData ... ");
	self.m_tbMaterialsCount = {};
	
	self.m_tbMaterials = {}
end

--@function: 获取某种材料的个数；显示的个数为背包个数减去已经添加的个数
--@nID：强化石ID
function KGC_EQUIP_FACTORY_TYPE:GetMateriasNumInBag()
	-- 获取强化石
	local tbItems = me:GetBag():GetItemsByDetail(17)

	-- 计算背包中的个数
	local tbCount = {};
	local nNum = 0;
	for _, item in pairs(tbItems) do
		if not tbCount[item:GetIndex()] then
			tbCount[item:GetIndex()] = 0;
		end

		tbCount[item:GetIndex()] = tbCount[item:GetIndex()] + item:GetNum();
	end
	
	return tbCount;
end

function KGC_EQUIP_FACTORY_TYPE:SetSelectedEquip(equip)
	self.m_equipSelected = equip;
end

function KGC_EQUIP_FACTORY_TYPE:GetSelectedEquip()
	return self.m_equipSelected;
end
----------------------------------------------------------
-- 升星
----------------------------------------------------------
--@function: 升星
-- function KGC_EQUIP_FACTORY_TYPE:AddEquipStar()

-- end

--@function: 获取升星的材料ID表
function KGC_EQUIP_FACTORY_TYPE:GetMaterialsID()
	return self.m_tbMaterialsID;
end

function KGC_EQUIP_FACTORY_TYPE:GetMaterialsNums()
	return self.m_tbMaterialsCount;
end

function KGC_EQUIP_FACTORY_TYPE:GetMaterialsTotalNums()
	local nCount = 0;
	for k, v in pairs(self.m_tbMaterialsCount) do
		nCount = nCount + v;
	end
	
	return nCount;
end

--@function: 获取材料, 直接是索引(和服务器对接)
function KGC_EQUIP_FACTORY_TYPE:GetMaterialsIndex()
	local tbIndex = {}
	--test
	print("[Log]GetMaterials: ")
	for k, v in pairs(self.m_tbMaterials) do
		cclog("nSlot(%d), nIndex(%d)", k, v)
	end
	--test end
	for k, v in pairs(self.m_tbMaterials) do
		if v and v ~= 0 then
			table.insert(tbIndex, v);
		end
	end
	
	return tbIndex;
end

--@function: 获取材料道具对象
function KGC_EQUIP_FACTORY_TYPE:GetMaterialsItem()
	local tbRet = {}

	for k, v in pairs(self.m_tbMaterials) do
		if v > 0 then
			local item = me:GetBag():GetItemByIndex(v)
			tbRet[k] = item
		end
	end
	
	return tbRet;
end

--@function: 对应位置是否已经添加了材料
function KGC_EQUIP_FACTORY_TYPE:IsAdded(nSlot)
	local nSlot = nSlot or 0;
	local nIndex = self.m_tbMaterials[nSlot] or 0
	--test
	if nIndex ~= 0 then
		cclog("[Log]位置(%d)已经添加材料,索引()", nSlot, nIndex)
	else
		cclog("[Log]位置(%d)没有添加材料", nSlot)
	end
	--test end
	return nIndex ~= 0, nIndex;
end

--@function: 增加一个材料
--@nSlot:	table的索引
--@nIndex:  道具索引
function KGC_EQUIP_FACTORY_TYPE:AddMaterial(nSlot, nIndex)
	cclog("[Log]兵工厂添加材料: 位置(%s), 材料索引(%s)", tostring(nSlot), tostring(nIndex))
	local tbMaterialsCount = self:GetMaterialsNums();
	-- 如果这里本身有材料的话，要去掉并减掉对应的数量
	local nOld = self.m_tbMaterials[nSlot];
	if tbMaterialsCount[nOld] and tbMaterialsCount[nOld] > 0 then
		tbMaterialsCount[nOld] = tbMaterialsCount[nOld] - 1;
	end
	self.m_tbMaterials[nSlot] = nIndex;
	
	if not tbMaterialsCount[nIndex] then
		tbMaterialsCount[nIndex] = 0;
	end
	tbMaterialsCount[nIndex] = tbMaterialsCount[nIndex] + 1;
	
	--test 
	self:TestPrintMatrials();
	--test end
end

--@function: 增加一个材料
--@nSlot:	table的索引
--@nIndex:  道具索引
function KGC_EQUIP_FACTORY_TYPE:SubMaterial(nSlot, nIndex)
	cclog("[Log]兵工厂删除材料: 位置(%s), 材料索引(%s)", tostring(nSlot), tostring(nIndex))
	local tbMaterialsCount = self:GetMaterialsNums();

	self.m_tbMaterials[nSlot] = 0;

	if tbMaterialsCount[nIndex] and tbMaterialsCount[nIndex] > 0 then
		tbMaterialsCount[nIndex] = tbMaterialsCount[nIndex] - 1;
	end

	--test 
	self:TestPrintMatrials();
	--test end
end

--@function: 获取某种材料剩余数量
--@nIndex: 材料索引
function KGC_EQUIP_FACTORY_TYPE:GetLeftMaterials(nIndex)
	local nIndex = nIndex or 0;
	-- 获取背包数量
	local tbBagMaterialsNum = self:GetMateriasNumInBag();
	local nNumInBag = 0
	if nIndex and nIndex ~= 0 then
		nNumInBag = tbBagMaterialsNum[nIndex] or 0;
	end
	-- 已经添加的个数
	local tbMaterialsCount = self:GetMaterialsNums();
	local nNumInFactory = tbMaterialsCount[nIndex] or 0;
	
	return nNumInBag - nNumInFactory;
end

--@function: 一键放入选择材料(从高到低)
function KGC_EQUIP_FACTORY_TYPE:AutoSelectMaterials()
	self:ClearData();
	
	-- 获取强化石
	local tbItems = me:GetBag():GetItemsByDetail(17)
	-- 按品质排序
	local fnCompare = function(a, b)
		return a:GetQuality() > b:GetQuality();
	end
	table.sort(tbItems, fnCompare)
	--test
	print("[Log]按品质排序的结果为：")
	for k, v in ipairs(tbItems) do
		print(k, v:GetID(), v:GetQuality(), v:GetName(), v:GetNum());
	end
	--test end
	
	-- 按照品质选择一个强化石
	local tbNums = {};
	local fnFind = function(tbItems)
		for i=1, 5 do
			if not tbNums[i] then
				tbNums[i] = 0;
			end
			local item = tbItems[i];
			if item then
				local nTotNum = item:GetNum();
				local nLeft = nTotNum - (tbNums[i] or 0);
				if nLeft > 0 then
					tbNums[i] = tbNums[i] + 1;
					return item;
				end
			end
		end
	end
	local tbRet = {};
	-- 放入材料
	for i = 1, 5 do
		local item = fnFind(tbItems)
		if item then
			local nIndex = item:GetIndex()
			self:AddMaterial(i, nIndex)
			tbRet[nIndex] = item;
			-- print(222, i, nIndex, item:GetName(), self:GetStarRate())
			if self:IsRateUp() then
				-- print("[Log]AutoSelectMaterials", self:GetStarRate())
				break;
			end
		end
	end
	
	return tbRet;
end

--@function：获得升星的概率
--@返回：基础概率，增加的概率
function KGC_EQUIP_FACTORY_TYPE:GetStarRate()
	local tbMaterialsCount = self:GetMaterialsNums();
	local nStar = self.m_equipSelected:GetStars() + 1;
	local nRate = 0;
	local nBase = (l_tbStarConfig[nStar] or {}).success or 0;
	cclog("[Log]当前星级(%d), 基础概率(%d)", nStar, nBase)
	for nIndex, nNum in pairs(tbMaterialsCount) do
		local item = me:GetBag():GetItemByIndex(nIndex);
		
		if item then
			if item:GetTypeDetail() == 17 then
				local nLevel = item:GetLevel();
				local nTemp = self:CountStarRate(nLevel)
				nRate = nRate + nTemp * nNum;
			else
				cclog("[Error]不是强化石@GetStarRate")
			end
		else
			cclog("[Error]找不到index(%d)的道具@GetStarRate", nIndex)
		end
	end
	return nBase, nRate;
end

function KGC_EQUIP_FACTORY_TYPE:CountStarRate(nLevel)
	local nLevel = nLevel or 0;
	local nStar = self.m_equipSelected:GetStars() + 1;
	
	local tbRate = {}
	local tbConfig = l_tbStarConfig[nStar] or {}
	tbRate[1] = tbConfig.item1
	tbRate[2] = tbConfig.item2
	tbRate[3] = tbConfig.item3
	tbRate[4] = tbConfig.item4
	tbRate[5] = tbConfig.item5
	
	local nAdd = tbRate[nLevel] or 0;
	return nAdd;
end

function KGC_EQUIP_FACTORY_TYPE:GetRateByArg(nStar, nLevel)
	local tbRate = {}
	local tbConfig = l_tbStarConfig[nStar] or {}
	tbRate[1] = tbConfig.item1
	tbRate[2] = tbConfig.item2
	tbRate[3] = tbConfig.item3
	tbRate[4] = tbConfig.item4
	tbRate[5] = tbConfig.item5
	
	local nRate = tbRate[nLevel] or 0;
	return nRate;
end

--@function: 概率是否上限
function KGC_EQUIP_FACTORY_TYPE:IsRateUp()
	local nBase, nAdd = self:GetStarRate();
	return nBase + nAdd >= 100;
end

--@function: 获取升星消耗
function KGC_EQUIP_FACTORY_TYPE:GetStarCost()
	local nStar = self.m_equipSelected:GetStars() + 1;
	local tbConfig = l_tbStarConfig[nStar] or {}
	local nGold = tbConfig.cost or 0;
	return nGold;
end

function KGC_EQUIP_FACTORY_TYPE:DeleteMaterials()
	local tbMaterials = self:GetMaterialsNums();
	for nIndex, nNum in pairs(tbMaterials) do
		print("[Log]开始删除材料 ... ", nIndex, nNum)
		me:GetBag():SubItem(nIndex, nNum)
	end
end
----------------------------------------------------------
-- 淬炼
----------------------------------------------------------
function KGC_EQUIP_FACTORY_TYPE:SetSplitEquip(nIndex)
	self.m_equipIndex2 = nIndex or 0;
end

function KGC_EQUIP_FACTORY_TYPE:GetSplitEquip()
	return self.m_equipIndex2;
end

function KGC_EQUIP_FACTORY_TYPE:SetSelectedAttribute(nIndex)
	print("[选择淬炼属性]nIndex = ", nIndex)
	self.m_nSelAttr = nIndex or 0;
end

function KGC_EQUIP_FACTORY_TYPE:GetSelectedAttribute()
	return self.m_nSelAttr;
end

function KGC_EQUIP_FACTORY_TYPE:PickCallBack(tbEquip)
	-- 删除被淬炼道具
	if self.m_equipIndex2 ~= 0 then
		me:GetBag():SubItem(self.m_equipIndex2, 1);
		self.m_equipIndex2 = 0;
	end
	
	-- 修改淬炼属性
	local nIndex = tbEquip.index;
	local equip = me:GetBag():GetItemByIndex(nIndex)
	local tbOldAttrs = equip:GetAttributes();
	local nSelIndex = self.m_nSelAttr;
	local nOldID, nOldNum = unpack(tbOldAttrs[nSelIndex])
	
	local tbAttrs = {}
	tbAttrs[1] = {tbEquip.a1, tbEquip.n1}
	tbAttrs[2] = {tbEquip.a2, tbEquip.n2}
	tbAttrs[3] = {tbEquip.a3, tbEquip.n3}
	tbAttrs[4] = {tbEquip.a4, tbEquip.n4}
	equip:SetAttributes(tbAttrs)
	
	-- 得到变化的属性
	local tbResult = {}
	local nNewID, nNewNum = unpack(tbAttrs[nSelIndex])
	tbResult[1] = {nOldID, nOldNum};
	tbResult[2] = {nNewID, nNewNum};
	
	self:ClearData();
	
	return tbResult;
end
----------------------------------------------------------
--test
function KGC_EQUIP_FACTORY_TYPE:TestPrintMatrials()
	print("对应位置存放索引信息：")
	for k, v in pairs(self.m_tbMaterials) do
		cclog("\tnSlot(%d), nIndex(%d)", k, v)
	end
	
	local tbMaterialsCount = self:GetMaterialsNums();
	print("已经放入的材料数量：")
	for k, v in pairs(tbMaterialsCount) do
		cclog("\t索引(%d), 数量(%d)", k, v)
	end
end