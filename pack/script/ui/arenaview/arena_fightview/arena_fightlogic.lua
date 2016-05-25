----------------------------------------------------------
-- file:	normallogic.lua
-- Author:	page
-- Time:	2015/11/28 16:18
-- Desc:	竞技场日竞技赛战斗界面管理类
----------------------------------------------------------
require("script/ui/arenaview/arena_fightview/arena_fightlayer")
local TB_STRUCT_ARENA_FIGHT_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_ARENA_FIGHT_LOGIC_TYPE = class("KGC_ARENA_FIGHT_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_ARENA_FIGHT_LOGIC)


function KGC_ARENA_FIGHT_LOGIC_TYPE:getInstance()
	if not KGC_ARENA_FIGHT_LOGIC_TYPE.m_pLogic then
        KGC_ARENA_FIGHT_LOGIC_TYPE.m_pLogic = KGC_ARENA_FIGHT_LOGIC_TYPE.new()
		GameSceneManager:getInstance():insertLogic(KGC_ARENA_FIGHT_LOGIC_TYPE.m_pLogic)
	end
	return KGC_ARENA_FIGHT_LOGIC_TYPE.m_pLogic
end

function KGC_ARENA_FIGHT_LOGIC_TYPE:initLayer(parent,id, tbArgs)
    if self.m_pLayer then
    	return;
    end
	
    self.m_pLayer = KGC_ARENA_FIGHT_LAYER_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_ARENA_FIGHT_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

----------------------------------------------------------------------
--@function: 请求获取奖励
function KGC_ARENA_FIGHT_LOGIC_TYPE:ReqGetReward(nCount)
	local fnCallBack = function(tbArg)
		print("[协议返回]获取奖励")
	end
	
	local tbReqArg = {};
	tbReqArg.boxCount = nCount;
	cclog("[协议发送]获取奖励(boxCount = %s)", tostring(nCount));
	-- g_Core.communicator.loc.getSngBoxReward(tbReqArg, fnCallBack);
end