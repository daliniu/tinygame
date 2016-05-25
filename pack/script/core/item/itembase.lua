----------------------------------------------------------
-- file:	itembase.lua
-- Author:	page
-- Time:	2015/06/02
-- Desc:	base class of item
----------------------------------------------------------
require("script/core/configmanager/configmanager");
local l_tbItems = {};
l_tbItems[1] = mconfig.loadConfig("script/cfg/pick/item");
local l_tbQualityType = def_GetQualityType();
local l_tbItemTypeGenre, l_tbItemTypeDetail = def_GetItemType();

local makeConfigFile = mconfig.loadConfig("script/cfg/equip/make")
local l_tbQualityIcon = mconfig.loadConfig("script/cfg/client/quality_edge");
--data struct 
local TB_STRUCT_ITEM_BASE = {
	m_nID = 0,					--id
	m_nNum = 0,					--数量
	m_nIndex = 0,				--道具索引(唯一)
	m_nQuality = 0,				-- 道具品质
	m_nStar = 0,				-- 星级

	m_conifg =nil,				--配置表
}
--------------------------------)
KGC_ITEM_BASE_TYPE = class("KGC_ITEM_BASE_TYPE", CLASS_BASE_TYPE, TB_STRUCT_ITEM_BASE)
--------------------------------
--function
--------------------------------

function KGC_ITEM_BASE_TYPE:ctor(nID)
	self.m_nID = tonumber(nID) or 0;
end

function KGC_ITEM_BASE_TYPE:Init(nIndex, nNum)
	self:SetIndex(nIndex)
	self:SetNum(nNum)

	local nID = self:GetID();
	----读配置表
	local tbInfo = self:GetItemConfig(nID)
	if tbInfo then
		self.m_conifg = tbInfo
	else
		cclog("[Error]错误的道具ID(%s)", tostring(nID));
	end
end


function KGC_ITEM_BASE_TYPE:SetNum(nNum)
	if type(nNum) ~= "number" then
		cclog("[Error]错误的数据类型@SetNum");
		return;
	end
	
	self.m_nNum = nNum;
end

function KGC_ITEM_BASE_TYPE:GetNum()
	return self.m_nNum;
end

--@function: 增加数量
function KGC_ITEM_BASE_TYPE:AddNum(nNum)
	if type(nNum) ~= "number" then
		cclog("[Error]错误的数据类型@SetNum");
		return;
	end
	local nOld = self:GetNum();
	self:SetNum(nOld + nNum)
end

function KGC_ITEM_BASE_TYPE:GetName()
	return self.m_conifg.itemName;
end


function KGC_ITEM_BASE_TYPE:GetIcon()
	return self.m_conifg.itemIcon;
end

--@function: 设置装备ID(配置表)
function KGC_ITEM_BASE_TYPE:SetID(nID)
	self.m_nID = nID or 0;
end

function KGC_ITEM_BASE_TYPE:GetID()
	return self.m_nID;
end

--@function: 设置装备index
function KGC_ITEM_BASE_TYPE:SetIndex(nIndex)
	self.m_nIndex = nIndex or 0;
end

function KGC_ITEM_BASE_TYPE:GetIndex()
	return self.m_nIndex;
end

--@function: 设置装备品质
function KGC_ITEM_BASE_TYPE:SetQuality(nQuality)
	self.m_nQuality = nQuality or 0;
end

function KGC_ITEM_BASE_TYPE:GetQuality()
	return self.m_conifg.itemQuality;
end

if not _SERVER then
--@function: 获取品质对应的颜色
function KGC_ITEM_BASE_TYPE:GetQualityIcon()
	local tbIcons = {
		[l_tbQualityType.Q_01] = CUI_PATH_ITEM_QUALITY_0,
		[l_tbQualityType.Q_02] = CUI_PATH_ITEM_QUALITY_1,
		[l_tbQualityType.Q_03] = CUI_PATH_ITEM_QUALITY_2,
		[l_tbQualityType.Q_04] = CUI_PATH_ITEM_QUALITY_3,
		[l_tbQualityType.Q_05] = CUI_PATH_ITEM_QUALITY_4,
	}
	local nQuality = self:GetQuality();
	local nShowType = self:GetshowType();
	local tbConfig = l_tbQualityIcon[nShowType];
	if tbConfig then
		tbIcons[l_tbQualityType.Q_01] = tbConfig.qualitytype1;
		tbIcons[l_tbQualityType.Q_02] = tbConfig.qualitytype2;
		tbIcons[l_tbQualityType.Q_03] = tbConfig.qualitytype3;
		tbIcons[l_tbQualityType.Q_04] = tbConfig.qualitytype4;
		tbIcons[l_tbQualityType.Q_05] = tbConfig.qualitytype5;
	end
	return tbIcons[nQuality]
end

end

--道具显示类型
function KGC_ITEM_BASE_TYPE:GetshowType()
	return self.m_conifg.showTepy;
end

--@function：获取道具的类型2(副类型)
function KGC_ITEM_BASE_TYPE:GetTypeDetail()
	return self.m_conifg.itemTepy2;
end

--@function：获取道具的类型(主类型)
function KGC_ITEM_BASE_TYPE:GetTypeGenre()
	return self.m_conifg.itemTepy;
end

function KGC_ITEM_BASE_TYPE:GetLevel()
	local nLevel = 0;
 
	if type(self.m_conifg.itemLv) == "number" then
		nLevel = self.m_conifg.itemLv
	end
	return nLevel;
end

--获取团队等级限制
function KGC_ITEM_BASE_TYPE:GetTeamLvLimit()
	return self.m_conifg.teamLv;
end

--合成目标
function KGC_ITEM_BASE_TYPE:GetComposeTarget()
	return self.m_conifg.compose
end

--是否可锻造
function KGC_ITEM_BASE_TYPE:GetIsAbleMake()
	if makeConfigFile[self.m_nID] == nil then 
		return false;
	end

	return true;
end

--是否可以出售
function KGC_ITEM_BASE_TYPE:GetIsAbleSell()
	if self.m_conifg.sell==1 then 
		return true;
	end

	return false;
end

--是否可以使用
function KGC_ITEM_BASE_TYPE:GetIsAbleUse()
	if self.m_conifg.userTeyp == nil then 
		return false;
	end
	return true;
end

--返回所占格子数量
function KGC_ITEM_BASE_TYPE:GetGirdSpace()
	return math.ceil(self:GetNum()/self:GetstackMax())
end

--返回最大叠加数量
function KGC_ITEM_BASE_TYPE:GetstackMax( ... )
	return self.m_conifg.stackMax;
end


function KGC_ITEM_BASE_TYPE:GetItemConfig(nID)
	nID = tonumber(nID)
	local tbInfo = nil;
	for _, tbConfig in pairs(l_tbItems) do
		if tbConfig[nID] then
			tbInfo = tbConfig[nID]
		end
	end
	
	return tbInfo;
end

--@function: 减少道具数量
function KGC_ITEM_BASE_TYPE:SubNum(nNum)
	local nTotal = self:GetNum();
	local nNum = nNum or 0;
	if nTotal < nNum and nNum <= 0 then
		cclog("[Warning]减少的数量不足！@SubNum")
		return;
	end
	local nLeft = nTotal - nNum;
	self:SetNum(nLeft)
	return nLeft;
end

--@function: 删除道具
function KGC_ITEM_BASE_TYPE:Delete()
	print("[Log]道具删除自身")
	self = nil;
end

function KGC_ITEM_BASE_TYPE:IsEquip()
	return false;
end

--获取战斗力量
function KGC_ITEM_BASE_TYPE:GetFightPoint()
	return -1;
end

--是否可拆分
function KGC_ITEM_BASE_TYPE:isAbleSplit()
	local iRet =self.m_conifg.split;
	if iRet == 1  then 
		return true;
	end

	return false;
end

--获取描述
function KGC_ITEM_BASE_TYPE:GetText()
	return self.m_conifg.itemTxt;
end

--获取属性类型和属性值
function KGC_ITEM_BASE_TYPE:GetAttrNameAndValue()
	local pTab={};
	pTab.type = self.m_conifg.auTeyp
	pTab.num  = self.m_conifg.auNo;
	return pTab;
end

function KGC_ITEM_BASE_TYPE:getTextColor()
	local iQuality = self:GetQuality();

	if iQuality == 1 then 
		return cc.c3b(246,246,222);
	elseif iQuality ==2 then 
		return cc.c3b(170,253,58);
	elseif iQuality == 3  then 
		return cc.c3b(0,203,253);
	elseif iQuality == 4 then 
		return cc.c3b(204,70,245);
	elseif iQuality == 5 then 
		return cc.c3b(253,231,1);
	end

	return cc.c3b(246,246,222);
end

--@function: 是否是个人经验道具
function KGC_ITEM_BASE_TYPE:IsExpItem()
	local nType = self:GetTypeDetail();
	if nType == l_tbItemTypeDetail.D_EXPITEM then
		return true;
	end
	
	return false;
end