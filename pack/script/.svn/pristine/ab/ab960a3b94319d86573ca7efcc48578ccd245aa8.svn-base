----------------------------------------------------------
-- file:	afkstatisticslogic.lua
-- Author:	page
-- Time:	2015/01/27
-- Desc:	统计面板逻辑管理类
----------------------------------------------------------
require("script/ui/statisticsview/statisticsview")
require("script/class/class_base_ui/class_base_logic")

local TB_STRUCT_UI_AFK_STATISTICS_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
	
	m_Afk = nil,
}

KGC_AFK_STATISTICS_LOGIC_TYPE=class("KGC_AFK_STATISTICS_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_UI_AFK_STATISTICS_LOGIC)


function KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance()
	if not KGC_AFK_STATISTICS_LOGIC_TYPE.m_pLogic then
        KGC_AFK_STATISTICS_LOGIC_TYPE.m_pLogic = KGC_AFK_STATISTICS_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_AFK_STATISTICS_LOGIC_TYPE.m_pLogic)
	end
	return KGC_AFK_STATISTICS_LOGIC_TYPE.m_pLogic
end

function KGC_AFK_STATISTICS_LOGIC_TYPE:create()
    local _logic = KGC_AFK_STATISTICS_LOGIC_TYPE.new()
	-- 统计数据类
	_logic.m_Afk = KGC_AFK_STATISTICS_BASE_TYPE.new();
	
    return _logic
end

function KGC_AFK_STATISTICS_LOGIC_TYPE:initLayer(parent,id, tbArg)
    if self.m_pLayer then
    	return;
    end
		
    self.m_pLayer = KGC_AFK_STATISTICS_VIEW_TYPE.new()
	self.m_pLayer:Init(tbArg);
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_AFK_STATISTICS_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function KGC_AFK_STATISTICS_LOGIC_TYPE:updateLayer(iType)

end

--@function: 服务器返回挂机离线奖励
--@nGoldAdd: 增加金币
--@nExpAdd: 经验增加
--@nAPAdd: 行动力增加
--@nOffTime: 离线时间
--@tbPLayer: 玩家数据
--@tbItems: 道具和装备
function KGC_AFK_STATISTICS_LOGIC_TYPE:OnRspAfkStatistics(nGoldAdd, nExpAdd, nAPAdd, nOffTime, tbPLayer, tbItems)
	local nGold = tbPLayer.gold
	local nGoldAdd = nGoldAdd or 0;
	local nExpAdd = nExpAdd or 0;
	local nAPAdd = nAPAdd or 0;
	me:SetGold(nGold);
	me:OnAddExp(tbPLayer, {}, nExpAdd)
	me:AddAP(nAPAdd);
	
	local tbObjs = {};
	for nIndex, tbData in pairs(tbItems.itemList or {}) do
		local item, num = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbObjs, {item, num});
	end
	
	for nIndex, tbData in pairs(tbItems.equipList or {}) do
		local item, num = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbObjs, {item, num});
	end
	print("道具装备总数量: ", #tbObjs)
	
	-- 如果没有奖励就不显示
	if nGoldAdd <= 0 and nExpAdd <= 0 and nAPAdd <= 0 and #tbObjs <= 0 then
		cclog("[Warning]没有离线奖励需要显示！");
		return;
	end
	
	--增加统计数据
	if self.m_Afk then
		self.m_Afk:AddGold(nGoldAdd);
		self.m_Afk:AddExp(nExpAdd);
		self.m_Afk:AddAP(nAPAdd);
		for _, data in pairs(tbObjs) do
			self.m_Afk:AddItem(data)
		end
	end
	
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_AFK_STATISTICS, {true})
	
	if self.m_pLayer then
		self.m_pLayer:UpdateData(nGoldAdd, nExpAdd, nAPAdd, tbObjs);
	end
end

--@function: 更新统计面板
function KGC_AFK_STATISTICS_LOGIC_TYPE:UpdateData(nGold, nExp, nAP, tbItems, nTime, bPlay, bFightCage)
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_AFK_STATISTICS, {bPlay, bFightCage})
	
	self.m_pLayer:UpdateData(nGold, nExp, nAP, tbItems, nTime);
end

function KGC_AFK_STATISTICS_LOGIC_TYPE:GetAfkStatistics()
	if self.m_Afk then
		local nGold = self.m_Afk:GetGold();
		local nExp = self.m_Afk:GetExp();
		local nAP = self.m_Afk:GetAP();
		local tbItems = self.m_Afk:GetItems();
		local tbEquips = self.m_Afk:GetEquips();
		
		return nGold, nAP, nExp, tbItems, tbEquips;
	end
end