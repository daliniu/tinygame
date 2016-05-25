----------------------------------------------------------
-- file:	equip.lua
-- Author:	page
-- Time:	2015/06/29
-- Desc:	equip class
----------------------------------------------------------
require "script/core/item/itembase"
require("script/core/configmanager/configmanager");
--------------------------------
local l_tbStarConfig = mconfig.loadConfig("script/cfg/equip/eqStar")

--------------------------------
local l_tbQualityType = def_GetQualityType();

--data struct 
local TB_STRUCT_EQUIP = {
	-- m_bEquip = false;			-- 是否已经装备
	m_tbSlot = {					-- 装备到哪一套装备中
		nPos = 0, 						-- 位置(头，首饰...)
		nIndex = 0,						-- 属于哪一套装备
	},
	
	m_tbAttrs = {				-- 附加属性
		-- [1] = {id, number},
	},
}
--------------------------------)
KGC_EQUIP_TYPE = class("KGC_EQUIP_TYPE", KGC_ITEM_BASE_TYPE, TB_STRUCT_EQUIP)
--------------------------------
--function
--------------------------------

function KGC_EQUIP_TYPE:ctor()
	
end
--------------------------------------------------------------
function KGC_EQUIP_TYPE:Init(nIndex, tbAttrs, nStar)
	self:SetIndex(nIndex);
	self:SetStar(nStar);
	self:SetNum(1);
	self:SetAttributes(tbAttrs)
	
	local nID = self:GetID();
	-- print("[Log]初始化装备，ID = ", nID)
	-- 读配置表
	local tbInfo = self:GetItemConfig(nID)
	if tbInfo then
		self.m_conifg = tbInfo
	end
	
	-- 开始也计算一次, 需要读配置表中的内容
	self:CalcAttribute();
end

--@function: 保存当前装备装备上的信息
--@nIndex: 属于哪一套装备
function KGC_EQUIP_TYPE:SetSuit(nIndex)
	local tbSlot = self:GetSuitTable();
	-- tbSlot.nPos = nSlot or 0;
	tbSlot.nIndex = nIndex or 0;
end

function KGC_EQUIP_TYPE:GetSuit()
	local tbSlot = self:GetSuitTable();
	return tbSlot.nIndex or 0;
end

function KGC_EQUIP_TYPE:GetSuitTable()
	if not self.m_tbSlot then
		self.m_tbSlot = {};
	end
	local tbSlot = self.m_tbSlot;
	return tbSlot;
end

function KGC_EQUIP_TYPE:IsEquip()
	local nIndex = self:GetSuit();
	return nIndex > 0;
end

--@function: 设置装备星级
function KGC_EQUIP_TYPE:SetStar(nStar)
	self.m_nStar = nStar or 0;
end

function KGC_EQUIP_TYPE:GetStars()
	return self.m_nStar or 0;
end

--@function: 根据随机种子生成一条属性
function KGC_EQUIP_TYPE:GenerateAttribute(nSeed)
	local nOld = gf_GetRandomSeed();
	gf_SetRandomSeed(nSeed);
	
	
	gf_SetRandomSeed(nOld);
end

--@function:设置附加属性
function KGC_EQUIP_TYPE:SetAttributes(tbAttrs)
	for index, tbAttr in pairs(tbAttrs or {}) do
		self:SetAttributeByIndex(index, tbAttr)
	end
	-- print("[Log]设置附加属性，总个数：", self:GetAttributesSize())
	
	-- 重新计算一遍属性
	self:CalcAttribute();
end

--@function:根据索引设置某一条属性
function KGC_EQUIP_TYPE:SetAttributeByIndex(nIndex, tbAttr)
	if not nIndex or nIndex <= 0 or nIndex > 4 then
		cclog("[Error]设置属性，数值错误@SetAttributeByIndex(nIndex:%s)", tostring(nIndex))
		return;
	end
	local tbAttrs = self:GetAttributes();
	
	local nID, nAttr = unpack(tbAttr or {})
	-- print("[Log]初始化装备属性", nID, nAttr)
	if nID and nID >= 0 then
		tbAttrs[nIndex] = {nID, nAttr}
	end
end

--@function: 获取属性
function KGC_EQUIP_TYPE:GetAttributes()
	if not self.m_tbAttrs then
		self.m_tbAttrs = {};
	end
	return self.m_tbAttrs;
end

--@function: 获取基础属性和数值(包括星级的提升了)
function KGC_EQUIP_TYPE:GetBaseAttribute()
	local nType, nNum = -1, 0;
	if self.m_conifg then
		nType, nNum = self.m_conifg.auTeyp or -1, self.m_conifg.auNo or 0;
		-- print("基础属性：", nType, nNum)
		if nType > 0 then
			local nPercent = self:CountStarIncrease();
			-- print("星级增加：", self:GetStars(), nPercent, math.floor(nPercent * nNum));
			nNum = nNum + math.floor(nPercent * nNum);
		end
	end
	return nType, nNum;
end

--@function: 计算星级带来的收益比例
function KGC_EQUIP_TYPE:CountStarIncrease()
	local nStar = self:GetStars();
	
	local nAdd = 0;
	for i = 1, nStar do
		local nTemp = l_tbStarConfig[i].increase
		nAdd = nAdd + nTemp;
	end

	return nAdd/100;
end

--@function: 获取属性数量
function KGC_EQUIP_TYPE:GetAttributesSize()
	local tbAttrs = self:GetAttributes();
	return #tbAttrs;
end

--获取战斗力量
function KGC_EQUIP_TYPE:GetFightPoint()
	local nSum = 0;
	local tbAttrValue = self:GetAttributeValueTable();
	for nType, nValue in pairs(tbAttrValue) do
		nSum = nSum + nValue;
	end
	return nSum;
end


--获取是否可拆分
function KGC_EQUIP_TYPE:IsAbleSplit()
	local bsp = self.m_conifg.split 
	if bsp==0 then 
		return false
	end 
	return true;
end

--@function: 计算装备属性
function KGC_EQUIP_TYPE:CalcAttribute()
	-- 每次计算都清空重新计算
	self:ClearAttributeValueTable();
	
	local tbAttrValue = self:GetAttributeValueTable();
	-- 基础属性计算
	local nType, nNum = self:GetBaseAttribute();
	if not tbAttrValue[nType] then
		tbAttrValue[nType] = 0;
	end
	if type(nNum) == "number" then
		tbAttrValue[nType]  = tbAttrValue[nType]  + nNum;
	end
	
	-- 附加属性计算
	local tbAttrs = self:GetAttributes();
	for _, tbData in pairs(tbAttrs) do
		local nType, nNum = unpack(tbData or {});
		if not tbAttrValue[nType] then
			tbAttrValue[nType] = 0;
		end
		if nType > 0 and type(nNum) == "number" then
			tbAttrValue[nType]  = tbAttrValue[nType]  + nNum;
		end
	end
	
	--test
	-- cclog("[log]计算装备(%d)属性为：", self:GetID());
	-- local tbTest = self:GetAttributeValueTable();
	-- tst_print_lua_table(tbTest);
	--test end
end

--@function: 获取装备属性存储表
function KGC_EQUIP_TYPE:GetAttributeValueTable()
	if not self.m_tbAttributeValue then
		self.m_tbAttributeValue = {};
	end
	
	return self.m_tbAttributeValue;
end

--@function: 清空装备属性存储表
function KGC_EQUIP_TYPE:ClearAttributeValueTable()
	self.m_tbAttributeValue = {};
end

--@function：获取装备属性值
--@nType: 属性类型
function KGC_EQUIP_TYPE:GetAttributeValue(nType)
	local nValue = 0;
	local tbAttrValue = self:GetAttributeValueTable();
	local nTemp = tbAttrValue[nType];
	if type(nTemp) == "number" then
		nValue = nTemp;
	end
	
	-- cclog("[log]装备(%s- %d)增加属性(%s): %s", self:GetName(), self:GetID(), tostring(nType), tostring(nValue));
	return nValue;
end
