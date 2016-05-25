----------------------------------------------------------
-- file:	statistics.lua
-- Author:	page
-- Time:	2015/07/21 16:24
-- Desc: 	挂机统计数据
----------------------------------------------------------
require "script/class/class_base"

local l_tbItemTypeGenre, l_tbItemTypeDetail = def_GetItemType();
--struct
local TB_STRUCT_AFK_STATISTICS = {
	m_tbStatistics = {				--存储结构
		nExp = 0,					-- 经验
		nGold = 0,					-- 金币
		nAP = 0,					-- 行动力
		
		-- nQPurpleItems = 0,				-- 紫色道具
		-- nQBlueItems = 0,				-- 蓝色道具
		-- nQGreenItems = 0,				-- 绿色道具
		tbItems = {						-- 道具
			--[品质] = nNum,				-- 数量
		},
		
		tbEquips = {						-- 装备
			--[品质] = nNum,				-- 数量
		},
		-- nQPurpleEquips = 0,				-- 紫色装备
		-- nQBlueEquips = 0,				-- 蓝色装备
		-- nQGreenEquips = 0,				-- 绿色装备
		
		nMoney = 0,						-- 分解后获得的金钱
	},
}

KGC_AFK_STATISTICS_BASE_TYPE = class("KGC_AFK_STATISTICS_BASE_TYPE", CLASS_BASE_TYPE, TB_STRUCT_AFK_STATISTICS)

function KGC_AFK_STATISTICS_BASE_TYPE:ctor()

end

--@function: 增加统计经验
function KGC_AFK_STATISTICS_BASE_TYPE:AddExp(nExp)
	print("[挂机统计]增加经验：", nExp)
	local nExp = nExp or 0;
	local tbStatistics = self:GetStatistics();
	tbStatistics.nExp = tbStatistics.nExp + nExp;
end

--@function 增加统计金币
function KGC_AFK_STATISTICS_BASE_TYPE:AddGold(nGold)
	print("[挂机统计]增加金币：", nGold)
	local nGold = nGold or 0;
	local tbStatistics = self:GetStatistics();
	tbStatistics.nGold = tbStatistics.nGold + nGold;
end

--@function: 增加行动力
function KGC_AFK_STATISTICS_BASE_TYPE:AddAP(nAP)
	print("[挂机统计]增加行动力：", nAP)
	local nAP = nAP or 0;
	local tbStatistics = self:GetStatistics();
	tbStatistics.nAP = tbStatistics.nAP + nAP;
end

--@function: 增加道具统计
function KGC_AFK_STATISTICS_BASE_TYPE:AddItem(tbData)
	local item, num = unpack(tbData or {});
	if item then
		print("[挂机统计]增加道具", item:GetName(), item:GetTypeGenre())
		if item:GetTypeGenre() == l_tbItemTypeGenre.G_EQUIP then
			self:AddItemByQuality(item:GetQuality(), num)
		else
			self:AddEquipByQuality(item:GetQuality(), num)
		end
	end
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetGold()
	local tbStatistics = self:GetStatistics();
	return tbStatistics.nGold
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetExp()
	local tbStatistics = self:GetStatistics();
	return tbStatistics.nExp
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetAP()
	local tbStatistics = self:GetStatistics();
	return tbStatistics.nAP;
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetItems()
	local tbStatistics = self:GetStatistics();
	if not tbStatistics.tbItems then
		tbStatistics.tbItems = {};
	end
	
	return tbStatistics.tbItems;
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetEquips()
	local tbStatistics = self:GetStatistics();
	if not tbStatistics.tbEquips then
		tbStatistics.tbEquips = {};
	end
	
	return tbStatistics.tbEquips;
end

--@function: 增加道具某品质数量
function KGC_AFK_STATISTICS_BASE_TYPE:AddItemByQuality(nQuality, nNum)
	local nQuality = nQuality or 0;
	local nNum = nNum or 0;
	
	local tbItems = self:GetItems();
	if not tbItems[nQuality] then
		tbItems[nQuality] = 0;
	end
	
	tbItems[nQuality] = tbItems[nQuality] + nNum;
	
	--test
	-- local tbItems = self:GetItems();
	-- for k, v in pairs(tbItems) do
		-- print(222, k, v);
	-- end
	--test end
end

--@function: 增加装备某品质数量
function KGC_AFK_STATISTICS_BASE_TYPE:AddEquipByQuality(nQuality, nNum)
	local nQuality = nQuality or 0;
	local nNum = nNum or 0;
	
	local tbEquips = self:GetEquips();
	if not tbEquips[nQuality] then
		tbEquips[nQuality] = 0;
	end
	
	tbEquips[nQuality] = tbEquips[nQuality] + nNum;
end

function KGC_AFK_STATISTICS_BASE_TYPE:GetStatistics()
	if not self.m_tbStatistics then
		self.m_tbStatistics = {};
	end
	return self.m_tbStatistics;
end
---------------------------------------------------------------------------------