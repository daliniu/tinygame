----------------------------------------------------------
-- file:	normallogic.lua
-- Author:	page
-- Time:	2015/11/28 16:18
-- Desc:	竞技场日竞技赛战斗界面管理类
----------------------------------------------------------
require("script/ui/arenaview/normalview/normallayer")
local TB_STRUCT_ARENA_NROMAL_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_ARENA_NORMAL_LOGIC_TYPE = class("KGC_ARENA_NORMAL_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_ARENA_NROMAL_LOGIC)


function KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance()
	if not KGC_ARENA_NORMAL_LOGIC_TYPE.m_pLogic then
        KGC_ARENA_NORMAL_LOGIC_TYPE.m_pLogic = KGC_ARENA_NORMAL_LOGIC_TYPE.new()
		GameSceneManager:getInstance():insertLogic(KGC_ARENA_NORMAL_LOGIC_TYPE.m_pLogic)
	end
	return KGC_ARENA_NORMAL_LOGIC_TYPE.m_pLogic
end

function KGC_ARENA_NORMAL_LOGIC_TYPE:initLayer(parent,id, tbArgs)
	print("KGC_ARENA_NORMAL_LOGIC_TYPE:initLayer", self.m_pLayer);
    if self.m_pLayer then
    	return;
    end
	
    self.m_pLayer = KGC_ARENA_NORMAL_LAYER_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_ARENA_NORMAL_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		print("KGC_ARENA_NORMAL_LOGIC_TYPE：closeLayer", self.m_pLayer)
		self.m_pLayer = nil
		print("KGC_ARENA_NORMAL_LOGIC_TYPE：closeLayer", self.m_pLayer)
	end
end

----------------------------------------------------------------------
--@function: 请求获取奖励
function KGC_ARENA_NORMAL_LOGIC_TYPE:ReqGetReward(nCount)
	local fnCallBack = function(tbArg)
		cclog("[协议返回]获取奖励, 结果(%s)", tostring(tbArg.retCode))
		tst_print_lua_table(tbArg);
		local nMasterScore = tonumber(tbArg.ticketDay);
		local tbItems = tbArg.bagItem;

		if tonumber(tbArg.retCode) == 0 then
			local g_reward = KGC_REWARD_MANAGER_TYPE:getInstance();
			-- 加数据到客户端
			local tbObjs = g_reward:AddItem(tbItems);
		
			-- 构造奖励table
			local tbCurrency = {};
			local szScore, nMasterScore = g_reward:AddMasterScore(nMasterScore);
			tbCurrency[szScore] = nMasterScore;

			-- 加到数据中心
			KGC_ARENA_FACTORY_TYPE:getInstance():AddArenaMasterScore(nMasterScore);
			KGC_ARENA_FACTORY_TYPE:getInstance():SetArenaNormalRewardFlagByIndex(nCount, 1);
			-- 显示奖励界面
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency, tbObjs}})
			
			if self.m_pLayer then
				self.m_pLayer:UpdateReward();
			end
		end
	end
	
	local tbReqArg = {};
	tbReqArg.boxCount = nCount;
	cclog("[协议发送]获取奖励(boxCount = %s)", tostring(nCount));
	g_Core.communicator.loc.getSngBoxReward(tbReqArg, fnCallBack);
end

--@function: 请求开战
function KGC_ARENA_NORMAL_LOGIC_TYPE:ReqStartFight(nIndex, player)

	local fnCallBack = function(tbArg)
		print("[协议返回]日赛开战")
		tst_print_lua_table(tbArg);
		local tbReward = tbArg.fightReward or {};
		local nWinner = tbArg.result;
		local nSeed = tbArg.seed;
		
		-- 更新数据(如果胜利的话)
		if nWinner == 1 then
			KGC_ARENA_FACTORY_TYPE:getInstance():UpdateNormalFightInfo(nIndex, nWinner);
			local nMasterScore = tonumber(tbReward.ticketDay or 0);
			KGC_ARENA_FACTORY_TYPE:getInstance():AddArenaMasterScore(nMasterScore);
		end
		
		-- 刷新界面
		FightViewLogic:getInstance():StartPvpFight(me, player, nSeed, nWinner, tbReward);
		
		-- 关闭这个界面
		KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance():closeLayer();
	end
	
	local tbReqArg = {};
	tbReqArg.enemyType = nIndex;
	cclog("[协议发送]日赛开战(enemyType = %s)", tostring(nIndex));
	g_Core.communicator.loc.getSngReward(tbReqArg, fnCallBack);
end

--@function: 请求退出战斗
function KGC_ARENA_NORMAL_LOGIC_TYPE:ReqQuitFight()
	local fnCallBack = function(tbArg)
		print("[协议返回]退出战斗")
		tst_print_lua_table(tbArg);
		local nStartMark = tonumber(tbArg.startMark);		-- 是否报名标记
		local nMasterScore = tonumber(tbArg.ticketDay);		-- 大师积分
		KGC_ARENA_FACTORY_TYPE:getInstance():SetArenaNormalSignup(nStartMark);
		KGC_ARENA_FACTORY_TYPE:getInstance():AddArenaMasterScore(nMasterScore);
		-- 打开竞技场主面板
		-- KGC_ARENA_LOGIC_TYPE:getInstance():ReqArenaMain();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA);
		
		-- 关闭当前界面
		self:closeLayer();
	end
	
	cclog("[协议发送]退出战斗");
	g_Core.communicator.loc.exitPvpSng(fnCallBack);
end