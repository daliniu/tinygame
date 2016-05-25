----------------------------------------------------------
-- file:	equiplogic.lua
-- Author:	page
-- Time:	2015/07/09 15:17
-- Desc:	管理多个装备相关界面的logic，解决不同入口调入问题
----------------------------------------------------------
require("script/class/class_base_ui/class_base_logic")
require("script/ui/herolistview/equipview/changelayer")
require("script/ui/herolistview/equipview/equipsplitlayer")
require("script/ui/herolistview/equipview/reinforcelayer")
require("script/ui/herolistview/equipview/starandpickuplayer")

local cjson = require("cjson.core")
local l_tbUIUpdateType = def_GetUIUpdateTypeData();
local l_tbAttrType, l_tbAttrTypeName  = def_GetAttributeType();

local l_tbEquipLayerType = {
	[1] = KGC_UI_EQUIP_CHANGE_LAYER_TYPE,			-- 更换装备
	[2] = KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE,	-- 装备强化主界面
	[3] = KGC_UI_EQUIP_SPLIT_LAYER_TYPE,			-- 装备拆分
	[4] = KGC_UI_EQUIP_REINFORCE_LAYER_TYPE,		-- 升星、淬炼
}

local TB_STRUCT_EQUIP_LOGIC ={
	m_tbLayer = {
		--[1] = 
		--[2] = 
		--[3] = 
		--[4] = 
	},
    m_pLogic = nil,
	m_tbParent = {},					-- 通知父类相关操作
	
	-- m_nCurType = 0,						-- 当前界面ID
	
	m_tbTempEquipChange = {},			-- 换装备时候临时数据
	m_nSelectedEquipIndex = 0,			-- 被选中的装备索引
	m_tbBatchEquips = {},				-- 被选中的装备索引(批量拆分)
	m_nMinQuality = 0,					-- changelayer显示的最低品质
}

KGC_EQUIP_LOGIC_TYPE = class("KGC_EQUIP_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_EQUIP_LOGIC)


function KGC_EQUIP_LOGIC_TYPE:getInstance()
    if KGC_EQUIP_LOGIC_TYPE.m_pLogic == nil then
        KGC_EQUIP_LOGIC_TYPE.m_pLogic = KGC_EQUIP_LOGIC_TYPE.new()
        KGC_EQUIP_LOGIC_TYPE.m_pLogic:initAttr()
    end
    return KGC_EQUIP_LOGIC_TYPE.m_pLogic
end

function KGC_EQUIP_LOGIC_TYPE:initAttr()
    
end


function KGC_EQUIP_LOGIC_TYPE:initLayer(nType, parent, tbArg)
    if self.m_tbLayer[nType] then
        return
    end
	self:closeLayer();

	self.m_tbParent[nType] = parent;
	
	local layerType = l_tbEquipLayerType[nType]
    local layer = layerType:create(parent)
	self.m_tbLayer[nType] = layer

	return self.m_tbLayer[nType];
end

function KGC_EQUIP_LOGIC_TYPE:closeLayer(nType)
    if self.m_tbLayer[nType] then
		self.m_tbLayer[nType]:closeLayer();
		self.m_tbLayer[nType] = nil;
		
		self.m_tbParent[nType] = nil;
	end
end

--@function: 保存选择的一些信息, 因为当前位置有可能有装备, 也可能没有装备
--@equip: 选择的装备
--@nType: 装备的部位
--@nSuit: 哪一套装备
function KGC_EQUIP_LOGIC_TYPE:SetSelectedEquip(equip, nType, nSuit)
	cclog("[Log]选择装备的相关信息：装备(%s), 部位(%s), 第几套(%s)", tostring(equip), tostring(nType), tostring(nSuit))
	if equip then
		cclog("[Log]当前选择的装备索引为(Set)：索引(%d), %s, 部位(%d), 第几套(%d)", equip:GetIndex(), equip:GetName(), equip:GetTypeDetail(), equip:GetSuit())
		self.m_nSelectedEquipIndex = equip:GetIndex();
	else
		self.m_nSelectedEquipIndex = 0;
	end
	
	self:SetEquipType(nType)
	self:SetEquipSuit(nSuit)
end

function KGC_EQUIP_LOGIC_TYPE:GetSelectedEquip()
	local equip = me:GetBag():GetItemByIndex(self.m_nSelectedEquipIndex)
	if not self.m_tbSuitInfo then
		self.m_tbSuitInfo = {};
	end

	if equip then
		cclog("[Log]当前选择的装备索引为(Get)：索引(%d), %s, 部位(%d), 第几套(%d)", self.m_nSelectedEquipIndex, equip:GetName(), equip:GetTypeDetail(), equip:GetSuit())
	else
		print("[Log]当前选择的装备索引为(Get)：", self.m_nSelectedEquipIndex, self.m_tbSuitInfo.nType, self.m_tbSuitInfo.nSuit)
	end

	return equip, self.m_tbSuitInfo.nType, self.m_tbSuitInfo.nSuit;
end

function KGC_EQUIP_LOGIC_TYPE:SetEquipType(nType)
	if not self.m_tbSuitInfo then
		self.m_tbSuitInfo = {};
	end
	self.m_tbSuitInfo.nType = nType;
end

function KGC_EQUIP_LOGIC_TYPE:SetEquipSuit(nSuit)
	if not self.m_tbSuitInfo then
		self.m_tbSuitInfo = {};
	end
	self.m_tbSuitInfo.nSuit = nSuit;
end


--@function: 获取批量装备：拆分
function KGC_EQUIP_LOGIC_TYPE:GetBatchEquips()
	if not self.m_tbBatchEquips then
		self.m_tbBatchEquips = {};
	end
	return self.m_tbBatchEquips;
end

--@function: 保存装备界面保存的装备信息
--@nSlot: 当前装备部位
--@hero：当前装备的英雄, 和sSlot可以计算当前的装备是什么
--@selectedequip: 选中的装备索引
--@equipNew: 新装备
function KGC_EQUIP_LOGIC_TYPE:SetEquipChangeTempData1(nSlot, hero, nIndex, equipNew)
	-- print(333, nSlot, hero, equip)
	if not self.m_tbTempEquipChange then
		self.m_tbTempEquipChange = {}
	end
	if nSlot then
		self.m_tbTempEquipChange.nSlot = nSlot
	end
	
	if hero then
		self.m_tbTempEquipChange.hero = hero
	end
	
	if nIndex then
		self.m_tbTempEquipChange.nIndex = nIndex
	end
	
	if equipNew then
		self.m_tbTempEquipChange.equipNew = equipNew
	end
end

--@function: 设置changlayer显示最低品质
function KGC_EQUIP_LOGIC_TYPE:SetMinQuality(nQuality)
	self.m_nMinQuality = nQuality or 0;
	-- print("(set)最低品质为：", self.m_nMinQuality, nQuality)
end

function KGC_EQUIP_LOGIC_TYPE:GetMinQuality()
	-- print("(get)最低品质为：", self.m_nMinQuality)
	return self.m_nMinQuality;
end

--@function: 打开拆分收益界面
function KGC_EQUIP_LOGIC_TYPE:OnSplitCallBack(tbItems, nGold, pParent)
	local layout = self:initLayer(3, pParent)
	layout:UpdateData(tbItems, nGold)
end

--@function: 显示属性变化tip
function KGC_EQUIP_LOGIC_TYPE:ConstructAttrDiff(tbDiff)
	local tbData = {};
	for nType, tbValue in pairs(tbDiff or {}) do
		local szHead = l_tbAttrTypeName[nType] .. ":";
		local nAfter = tbValue[1] or 0;
		local nBefore = tbValue[2] or 0;
		-- 没有变化的不需要
		if nAfter - nBefore ~= 0 then
			-- table.insert(tbData, {szHead, nBefore, nAfter});
			TipsViewLogic:getInstance():addMessageDataChange({szHead, nBefore, nAfter});
		end
	end
	-- return tbData;
end

--@function: 显示属性变化tip
function KGC_EQUIP_LOGIC_TYPE:AddEquipAttrDiffTips(tbBefore, nSuit)
	local tbAttrsAfter = me:GetEquipAllAttributeBySuit(nSuit);
	local tbDiff = me:GetEquipAttributeDiff(tbAttrsAfter, tbBefore);
	local tbData = self:ConstructAttrDiff(tbDiff);
	-- TipsViewLogic:getInstance():addMessageDataChange(tbData);
end

--@function: 请求更换装备服务器返回
function KGC_EQUIP_LOGIC_TYPE:ReqChangeEquicp(tbData)
	-- 保存换装之前的属性
	local nSuit = (tbData or {}).seq;
	local tbAttrs = me:GetEquipAllAttributeBySuit(nSuit);
	
	local fnCallBack = function(tbArg)
		local tbEquips = tbArg.equipList;
		cclog("[协议接收]更换装备：tbEquips(%s)", tostring(tbEquips));
		self:OnRspChangeEquicpCallBack(tbEquips);
		
		-- 属性变化
		local layer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		self:AddEquipAttrDiffTips(tbAttrs, nSuit);
	end
	
	local tbArgReq = tbData;
	cclog("[协议发送]更换装备：");
	for k, v in pairs(tbData or {}) do
		cclog("\t%s = %s", tostring(k), tostring(v));
	end
	g_Core.communicator.loc.changeEquip(tbArgReq, fnCallBack);
end

--@function: 更换装备服务器返回
function KGC_EQUIP_LOGIC_TYPE:OnRspChangeEquicpCallBack(tbEquips)
	cclog("[Log]更换装备结果: %s", (tbEquips and "成功") or "失败")
	if not tbEquips then
		return;
	end

	me:InitEquips(tbEquips)
	local layer = self.m_tbParent[1]
	print("OnRspChangeEquicpCallBack", layer, layer and layer.UpdateHeros);
	if layer then
		if layer.UpdateHeros then
			layer:UpdateHeros();-- 更新界面
		else
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG)
		end
	else
		KGC_HERO_LIST_LOGIC_TYPE:getInstance():OnRspChangeEquicpCallBack();
	end
	
	-- 清空
	self.m_tbTempEquipSlected = {};
	self.m_tbSuitInfo = {};
	
	-- 属性变化
	-- self:AddEquipAttrDiffTips(tbAttrs, nSuit);
end

--@function: 请求升星
function KGC_EQUIP_LOGIC_TYPE:ReqEquicpStar(tbData)
	-- 保存之前的属性
	local nSuit = (tbData or {}).seq;
	local tbAttrs = me:GetEquipAllAttributeBySuit(nSuit);
	
	local fnCallBack = function(tbArg)
		local tbEquips = tbArg.equip;
		local nIndex = tonumber(tbEquips.index);
		local nStar = tonumber(tbEquips.star);
		cclog("[协议接收]装备升星：tbEquips(%s)", tostring(tbEquips));
		tst_print_lua_table(tbArg);
		self:OnRspEquicpStar(nIndex, nStar);
		
		-- 属性变化
		-- self:AddEquipAttrDiffTips(tbAttrs, nSuit);
	end
	
	local tbArgReq = tbData;
	cclog("[协议发送]装备升星：");
	tst_print_lua_table(tbArgReq);
	g_Core.communicator.loc.upgradeEquipStar(tbArgReq, fnCallBack);
end

--@function: 升星服务器回调
function KGC_EQUIP_LOGIC_TYPE:OnRspEquicpStar(nIndex, nStar)
	print("[Log]升星回调...")
	local layer = self.m_tbLayer[4]
	if layer then
		layer:StarResult(nIndex, nStar)
	end
end

--@function: 淬炼
function KGC_EQUIP_LOGIC_TYPE:reqAttrPick(nIndex1, nIndex2, nAttrIndex)
	local nSuit = (tbData or {}).seq;
	local tbAttrs = me:GetEquipAllAttributeBySuit(nSuit);
	
	local fnCallBack = function(tbArg)
		local tbEquip = tbArg.equip;
		local tbItems = tbArg.splitList;
		local nGold = tonumber(tbArg.gold);

		cclog("[协议接收]装备淬炼：tbEquips(%s)", tostring(tbEquip));
		tst_print_lua_table(tbArg);
		self:OnRspAttrPick(tbEquip, tbItems, nGold);
		
		-- 属性变化
		-- self:AddEquipAttrDiffTips(tbAttrs, nSuit);
	end
	
	local tbArgReq = {};
	tbArgReq.lequipId = nIndex1;
	tbArgReq.requipId = nIndex2;
	tbArgReq.attr = nAttrIndex;
	cclog("[协议发送]装备淬炼：");
	tst_print_lua_table(tbArgReq);
	g_Core.communicator.loc.meltingEquip(tbArgReq, fnCallBack);
end

--@function: 淬炼服务器回调
function KGC_EQUIP_LOGIC_TYPE:OnRspAttrPick(tbEquip, tbItems, nGold)
	local nIndex = tbEquip.index;
	local tbRet = KGC_EQUIP_FACTORY_TYPE:getInstance():PickCallBack(tbEquip)
	
	-- 增加拆分的道具
	local tbItemObjs = {}
	for nIndex, tbData in pairs(tbItems) do
		local item = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbItemObjs, item);
	end
	
	-- 增加金钱
	me:AddGold(nGold)
	
	-- 更新界面通知
	local layer = self.m_tbLayer[4]
	if layer then
		layer:AttrPickResult(tbRet, tbItemObjs);
	end
	
	--更新背包界面
	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG)
end

--@function：请求拆分
function KGC_EQUIP_LOGIC_TYPE:reqSplit(tbList, fnCall)
	local fnCallBack = function(tbArg)
		local tbItems = tbArg.splitList;
		local nGold = tonumber(tbArg.gold);

		cclog("[协议接收]装备拆分：tbEquips(%s)", tostring(tbEquip));
		tst_print_lua_table(tbArg);
		-- self:OnRspSplit(tbItems, nGold);
		if fnCall then
			fnCall(tbItems, nGold);
		end
	end
	
	local tbList = tbList or {}
	local tbBatch = self:GetBatchEquips();
	for _, index in pairs(tbList) do
		table.insert(tbBatch, index);
	end
	
	local szList = cjson.encode(tbList)
	local tbArgReq = {};
	tbArgReq.equipIdList = szList;
	cclog("[协议发送]装备拆分：");
	tst_print_lua_table(tbArgReq);
	g_Core.communicator.loc.splitEquip(tbArgReq, fnCallBack);
end

function KGC_EQUIP_LOGIC_TYPE:OnRspSplit(tbItems, nGold, parent)
	local tbItemObjs = {}
	print("拆分返回：")
	tst_print_lua_table(tbItems or {});
	for nIndex, tbData in pairs(tbItems) do
		local item = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbItemObjs, item);
	end
	
	-- 删除拆分道具
	local tbBatch = self:GetBatchEquips();
	for _, index in pairs(tbBatch) do
		me:GetBag():SubItem(index, 1)
	end
	
	-- 更新界面
	self:OnSplitCallBack(tbItemObjs, nGold, parent)
end

--@function: 请求还原淬炼结果
function KGC_EQUIP_LOGIC_TYPE:reqPickRecover(nIndex)
	local fnCallBack = function(tbArg)
		local tbEquip = tbArg.equip;
		cclog("[协议接收]还原淬炼结果：tbEquips(%s)", tostring(tbEquip));
		tst_print_lua_table(tbArg);
		self:OnRspPickRecover(tbEquip);
	end
	
	local tbArgReq = {};
	tbArgReq.equipId = nIndex;
	tbArgReq.diamond = 5;
	cclog("[协议发送]还原淬炼结果：");
	tst_print_lua_table(tbArgReq);
	g_Core.communicator.loc.rvmeltingEquip(tbArgReq, fnCallBack);
end

--@function: 服务器返回还原淬炼结果
function KGC_EQUIP_LOGIC_TYPE:OnRspPickRecover(tbEquip)
	local nIndex = tbEquip.index;
	local tbRet = KGC_EQUIP_FACTORY_TYPE:getInstance():PickCallBack(tbEquip)
	
	-- 更新界面通知
	local layer = self.m_tbLayer[4]
	if layer then
		layer:UpdateAttributes(1, nIndex);
	end
end