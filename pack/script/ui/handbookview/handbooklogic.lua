----------------------------------------------------------
-- file:	handbooklogic.lua
-- Author:	page
-- Time:	2015/09/14 14:42
-- Desc:	图鉴面板逻辑管理类
----------------------------------------------------------
require("script/ui/handbookview/handbooklayer")
require("script/class/class_base_ui/class_base_logic")

local TB_STRUCT_UI_HANDBOOK_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_HANDBOOK_LOGIC_TYPE=class("KGC_HANDBOOK_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_UI_HANDBOOK_LOGIC)


function KGC_HANDBOOK_LOGIC_TYPE:getInstance()
	if not KGC_HANDBOOK_LOGIC_TYPE.m_pLogic then
        KGC_HANDBOOK_LOGIC_TYPE.m_pLogic = KGC_HANDBOOK_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_HANDBOOK_LOGIC_TYPE.m_pLogic)
	end
	return KGC_HANDBOOK_LOGIC_TYPE.m_pLogic
end

function KGC_HANDBOOK_LOGIC_TYPE:create()
    local _logic = KGC_HANDBOOK_LOGIC_TYPE.new()
    return _logic
end

function KGC_HANDBOOK_LOGIC_TYPE:initLayer(parent, id, tbArg)
    if self.m_pLayer then
    	return;
    end
		
    self.m_pLayer = KGC_HANDBOOK_LAYER_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
	
	local nHeroID1, nHeroID2, nHeroID3, nTimes = unpack(tbArg or {});
	self.m_pLayer:UpdateData({nHeroID1, nHeroID2, nHeroID3}, nTimes);
end

function KGC_HANDBOOK_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function KGC_HANDBOOK_LOGIC_TYPE:updateLayer(iType)

end

function KGC_HANDBOOK_LOGIC_TYPE:GetAllHeros()
	return g_PlayerFactory:GetAllHeros();
end

---------------------------------------------------
--@function: 发送召唤英雄请求
--@nID：英雄ID
function KGC_HANDBOOK_LOGIC_TYPE:ReqRollHero(nID)
	local fnCallBack = function(tbArg)
		local tbHeroInfo = tbArg.heroInfo
		print("[接受服务器数据]协议-召唤英雄")
		tst_print_lua_table(tbArg);
		local hero = me:AddHeroToAll(tbHeroInfo.heroId, tbHeroInfo);
		
		-- 更新界面
		local tbBookInfo = tbArg.heroBookInfo;
		local nHeroID1 = tonumber(tbBookInfo.heroId1);
		local nHeroID2 = tonumber(tbBookInfo.heroId2);
		local nHeroID3 = tonumber(tbBookInfo.heroId3);
		local nTimes = tonumber(tbBookInfo.summomNums);
		
		self.m_pLayer:SummonResult(tbHeroInfo.heroId, {nHeroID1, nHeroID2, nHeroID3}, nTimes);
		self.m_pLayer:LoadAllHeros();
	end
	local tbInArg = {};
	tbInArg.heroId = nID or 0;
	cclog("[发送请求]协议-召唤英雄(heroId = %d)", tbInArg.heroId);
	g_Core.communicator.loc.rollHero(tbInArg, fnCallBack);
end