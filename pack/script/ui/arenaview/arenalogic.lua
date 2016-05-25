----------------------------------------------------------
-- file:	arenalogic.lua
-- Author:	page
-- Time:	2015/11/28 16:18
-- Desc:	竞技场界面管理类
----------------------------------------------------------
require("script/ui/arenaview/arenalayer")
local TB_STRUCT_ARENA_LOGIC = {
	-- m_pLogic = nil,
	-- m_pLayer = nil,
}

KGC_ARENA_LOGIC_TYPE=class("KGC_ARENA_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_ARENA_LOGIC)


function KGC_ARENA_LOGIC_TYPE:getInstance()
	if not KGC_ARENA_LOGIC_TYPE.m_pLogic then
        KGC_ARENA_LOGIC_TYPE.m_pLogic = KGC_ARENA_LOGIC_TYPE.new()
		GameSceneManager:getInstance():insertLogic(KGC_ARENA_LOGIC_TYPE.m_pLogic)
	end
	return KGC_ARENA_LOGIC_TYPE.m_pLogic
end

function KGC_ARENA_LOGIC_TYPE:initLayer(parent,id, tbArgs)
    if self.m_pLayer then
    	return;
    end
	
    self.m_pLayer = KGC_ARENA_LAYER_TYPE.new();
	self.m_pLayer:Init(tbArgs);
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_ARENA_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

--------------------------------
-- 日赛
--@function: 请求打开竞技场主面板需要的数据
function KGC_ARENA_LOGIC_TYPE:ReqArenaMain()
	local fnCallBack = function(tbArg)
		print("[协议返回]获取竞技场主面板信息")
		local tbInfoNormal = tbArg.pvpInfo;
		local tbInfoDaily = tbArg.pvpDay;
		local tbInfoWeekly = tbArg.pvpWeek;
		KGC_ARENA_FACTORY_TYPE:getInstance():UnpackData(tbInfoNormal, tbInfoDaily, tbInfoWeekly);
		
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA, {tbInfoNormal, tbInfoDaily, tbInfoWeekly});
	end
	print("[协议发送]获取竞技场主面板信息");
	g_Core.communicator.loc.getPvpMainList(fnCallBack);
end

--@function: 请求报名参加日竞技赛
function KGC_ARENA_LOGIC_TYPE:ReqArenaNormalSignup()
	local fnCallBack = function(tbArg)
		cclog("[协议返回]报名参加日竞技赛: 可以报名的次数(nTimes=%s), 标记(nStartMark=%s), 战斗次数(fightcount=%s)", tostring(tbArg.pvpInfo.ticketN), tostring(tbArg.pvpInfo.startMark), tostring(tbArg.pvpInfo.fightCount))
		KGC_ARENA_FACTORY_TYPE:getInstance():UnpackNormalData(tbArg.pvpInfo);
		
		-- 打开战斗界面
		if self.m_pLayer then
			self.m_pLayer:OpenArenaNormal();
		end
	end
	print("[协议发送]报名参加日竞技赛");
	g_Core.communicator.loc.enrollPvpSng(fnCallBack);
end


--------------------------------
-- 日锦标赛
--@function: 请求日锦标赛战斗数据(筹码赛)
function KGC_ARENA_LOGIC_TYPE:ReqDailyChipsFightInfo()
	local fnCallBack = function(tbArg)
		print("[协议返回]日锦标赛战斗数据(筹码赛)")
		local tbFightInfo = tbArg.fightInfoList;
		-- local nMaxTurn = tbArg.

		-- 保存数据
		KGC_ARENA_FACTORY_TYPE:getInstance():UnpackDailyChipsFightInfo(tbFightInfo);
		
		-- 打开战斗界面
		if self.m_pLayer then
			self.m_pLayer:OpenArenaDailyChips();
		end
	end
	print("[协议发送]日锦标赛战斗数据(筹码赛)");
	-- g_Core.communicator.loc.getPvpDayResult(fnCallBack);
end

--@function: 请求获取日锦标赛战斗数据(八强赛)
function KGC_ARENA_LOGIC_TYPE:ReqDailyEightFightInfo()
	local fnCallBack = function(tbArg)
		local nRank = tbArg.pos;
		local tbFightInfo = tbArg.PvpF8Result;
		print("[协议返回]日锦标赛战斗数据(八强赛)")
		-- 保存数据
		KGC_ARENA_FACTORY_TYPE:getInstance():UnpackDailyEightFightInfo(tbFightInfo, nRank);
	end

	cclog("[协议发送]日锦标赛战斗数据(八强赛)");
	-- test
	KGC_ARENA_FACTORY_TYPE:getInstance():UnpackDailyEightFightInfo({});
	-- 打开战斗界面
	if self.m_pLayer then
		self.m_pLayer:OpenArenaDailyEight();
	end
	-- test end
	-- g_Core.communicator.loc.getPvpDayF8Result(tbReqArg, fnCallBack);
end