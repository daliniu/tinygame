----------------------------------------------------------
-- file:	fightlogic.lua
-- Author:	page
-- Time:	2015/01/26
-- Desc:	
----------------------------------------------------------
require("script/ui/fightview/fightview")
require("script/ui/fightview/resultlayer")
require("script/class/class_base_ui/class_base_logic")
require("script/core/configmanager/configmanager");

local l_tbUIUpdateType = def_GetUIUpdateTypeData();
local l_tbHeroBox = mconfig.loadConfig("script/cfg/client/herobox");
local l_tbAfkConfig = mconfig.loadConfig("script/cfg/map/afkreward")

local TB_STRUCT_FIGHT_VIEW_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,

	m_nCurStage = 0,				-- 当前战斗阶段(指引用)
}

FightViewLogic = class("FightViewLogic", KGC_UI_BASE_LOGIC, TB_STRUCT_FIGHT_VIEW_LOGIC)

function FightViewLogic:getInstance()
	if FightViewLogic.m_pLogic==nil then
        FightViewLogic.m_pLogic=FightViewLogic:create()
		GameSceneManager:getInstance():insertLogic(FightViewLogic.m_pLogic)
	end
	return FightViewLogic.m_pLogic
end

function FightViewLogic:create()
    local _logic = FightViewLogic:new()
    return _logic
end

function FightViewLogic:initLayer(parent,id, tbArg)
	local tbArg = tbArg or {};
	local bGuide, nHeroBoxID = tbArg[1], tbArg[2];
	if bGuide then
	-----------------------------------------------------
		-- 指引用
		-- 初始化新的战斗界面
		if not self.m_pLayer then
			self.m_pLayer = KG_UIFight.new({bDebug = true});
			self.m_pLayer.id = id
			parent:addChild(self.m_pLayer);
		end
		self:OpenGuideFight(nHeroBoxID);
	else
	-----------------------------------------------------
		-- 挂机用
		if self.m_pLayer ~= nil then
			GameSceneManager:getInstance():ShowLayer(id) 
			self.m_pLayer:RefreshText();
			return
		end
		GameSceneManager:getInstance():ShowLayer(id) 
		
		self.m_pLayer = KG_UIFight.new()
		self.m_pLayer:Init(self.m_EnemyData, self.m_nRewardID)
		self.m_pLayer.id = id

		-- print("战斗结果：", nWinner, self.m_nWinner)
		if true or nWinner == self.m_nWinner then				--测试：直接通过
			--直接给奖励
			parent:addChild(self.m_pLayer)
		else
			print("战斗结果数据错误!")
			--通知界面
		end
	end
end

--@function: 关闭战斗界面
--@bGuide: 是否是指引战斗
function FightViewLogic:closeLayer(bGuide)
	-- 指引战斗直接关闭
	if bGuide then
		if self.m_pLayer then
			GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
			self.m_pLayer = nil;
		end
		
	-- 挂机界面一直存在
	else
		if self.m_pLayer then
			GameSceneManager:getInstance():HideLayer(self.m_pLayer.id)
		end
	end
end

--@function: 更新界面
--@iType: 类型, 参考
function FightViewLogic:OnUpdateLayer(iType, tbArg)
	-- print("[界面更新]OnUpdateLayer", self.m_pLayer, iType, tbArg)
	local tbArg = tbArg or {}
	local nPos = tbArg[1] or 0;
	if self.m_pLayer then
		if iType == l_tbUIUpdateType.EU_LEVELUP then			-- 升级更新
			TipsViewLogic:getInstance():addMessageTips(12000);
			self.m_pLayer:UpdateLevel(nPos)
		elseif iType == l_tbUIUpdateType.EU_AFKERREWARD then	-- 挂机奖励
			if self.m_pLayer.m_pMainBtnLayer then
				local nPercent = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:SetRewardProgress(0, nPercent);
			end
		elseif iType == l_tbUIUpdateType.EU_SEARCH then
			if self.m_pLayer.m_pMainBtnLayer then
				local nSearchT = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:StartSearch(nSearchT);
			end
		elseif iType == l_tbUIUpdateType.EU_FIGHTHP then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local nSelfHp = (tbArg or {})[1] or 0;
	            local nEnemyHp = (tbArg or {})[2] or 0;
	            self.m_pLayer.m_pMainBtnLayer:SetFightHp(nSelfHp, nEnemyHp);
	        end
	    elseif iType == l_tbUIUpdateType.EU_FIGHTRESULT then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local bWin = (tbArg or {})[1] or false;
	            local tReward = (tbArg or {})[2] or {};
	            self.m_pLayer.m_pMainBtnLayer:SetResult(bWin, tReward);
	        end
		end
		self.m_pLayer:UpdateMoneyData()
		if self.m_pLayer.m_pMainBtnLayer then
			self.m_pLayer.m_pMainBtnLayer:initButtonState()
		end
	end
end

function FightViewLogic:SetPlayerInfoVisible(bVisble)
	if self.m_pLayer then
		self.m_pLayer:SetPlayerInfoVisible(bVisble)
	end
end

function FightViewLogic:SetEnemy(data)
	self.m_tbEnemy = data;
end

function FightViewLogic:GetEnemy()
	return self.m_tbEnemy;
end

function FightViewLogic:SetWinner(nWinner, nHPLeftRate)
	self.m_nWinner = nWinner;
	self.m_nHPLeftRate = nHPLeftRate or 0;
end

--@function: 强制结束当前战斗重新开始一场
function FightViewLogic:ForceOver()
	if self.m_pLayer then
		self.m_pLayer:Over(true);
		local nBoxID = me:RandomMonsterBoxID();
		self.m_pLayer:SearchAndFight(os.time(), nBoxID);
	end
end

--@function: pvp战斗
--@playerSelf: 己方对象
--@playerEnemy: 敌方对象
--@nSeed: 随机种子
--@nWinner: 赢的阵营(1: 我方; 2-敌方)
--@tbReward: 奖励
function FightViewLogic:StartPvpFight(playerSelf, playerEnemy, nSeed, nWinner, tbReward)
	print("[Log]StartPVPFight ... ", nSeed, playerSelf, playerEnemy)
	local tbReward = tbReward or {};
	
	local fnFightCallBack = function()
		print("pvp 战斗结束 ... ");
		
		local nDiamond = tbReward.diamand or 0;
		local nMasterScore = tbReward.ticketDay or 0;
		local nTickets = tbReward.ticketWeek or 0;
		local tbItems = tbReward.bagItem;
		-- 构造奖励table
		local tbCurrency = {};
		tbCurrency["rmb"] = nDiamond;
		tbCurrency["masterscore"] = nMasterScore;
		tbCurrency["normalticket"] = nTickets;
		self:OnPvpFightCallBack(nWinner, tbCurrency, tbItems);
	end
	
	local fnCall = function()
	-- 开一场新的
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT);
		if self.m_pLayer then
			self.m_pLayer:Over(true);
			
			self.m_pLayer:StartPvpFight(playerSelf, playerEnemy, nSeed, fnFightCallBack)
			self.m_pLayer:RefreshText();
		end
	end
	
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PROGRESS, {3, fnCall});
	
	-- 进度条自动更新
	KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():AutoUpdate();
	
	return true;
end

--@再封装一层的直接战斗接口
--@nSeed: 随机种子(eg: os.time())
--@nBoxID: 怪物盒子的ID
--@nWinner: 服务器传过来的战斗结果
--@tbReward: 奖励相关数据
--[[
	rewardid =,		-- 奖励ID获取数值类奖励
	cost =,			-- 补给消耗
	bagAdd = ,		-- 道具列表(服务端要随机生成)
]]
function FightViewLogic:StartFightWithMonster(nSeed, nBoxID, nWinner, tbReward)
	print("[Log]StartFightWithMonster ... ", nSeed, nBoxID, nWinner, tbReward)
	tst_print_lua_table(tbReward or {});
	local nRewardID = tbReward.rewardid;
	local nAPCost = tbReward.cost;
	local tbItems = tbReward.bagAdd;
	
	self.m_nSeed = nSeed;				-- 随机种子
	self.m_EnemyData = enemyData;		-- 
	self.m_nWinner = nWinner;
	-- self.m_tbReward = {nRewardID, nAPCost, tbItems}
	self.m_tbReward = tbReward;
	
	local fnCallBack = function()
		self:OnFightCallBack(tbReward);
	end

	-- 进度条回调函数
	local fnCall = function()
	-- 开一场新的
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT);
		if self.m_pLayer then
			self.m_pLayer:RefreshText();
			self.m_pLayer:Over(true);
			self.m_pLayer:SearchAndFight(nSeed, nBoxID, nWinner, nRewardID, true, fnCallBack)
		end
	end
	
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PROGRESS, {3, fnCall});
	
	-- 进度条自动更新
	KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():AutoUpdate();
	-- local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(fnCall));
	-- GameSceneManager:getInstance().pLayer:runAction(action)
	
	return true;
end

function FightViewLogic:OnFightCallBack()
	local tbCurrency = tbCurrency or {};
	local tbReward = tbReward or self.m_tbReward or {};
	local nWinner = nWinner or self.m_nWinner;
	local nHPLeftRate = self.m_nHPLeftRate;
	local nGold, nExp, nExpTeam, nAP, nSign, tbItemAdd
	cclog("FightViewLogic:OnFightCallBack ...");
	tst_print_lua_table(tbReward);

	if nWinner and nWinner > 0 and tbReward then
		-- nGold, nExp, nExpTeam, nAP, nSign = KGC_REWARD_MANAGER_TYPE:getInstance():GetReward(nRewardID)
		-- if not nGold then
			-- cclog("[Error]获取奖励为空，检测配置表@OnFightCallBack");
			-- return false;
		-- end
		
		--战斗胜利才会给奖励
		if nWinner == 1 then
			tbCurrency, tbItemAdd = KGC_REWARD_MANAGER_TYPE:getInstance():AddReward(tbReward)
			nGold = tbCurrency["gold"];
			nExp = tbCurrency["teamexp"];
		end
		-- print("OnFightCallBack", nGold, nExp, tbItemAdd);
		-- local tbItemObjs = {}
		-- for _, tbData in pairs(tbItemAdd or {}) do
			-- local nID, nNum = unpack(tbData);
			-- local item = me:GetBag():GetItemByID(nID);
			-- table.insert(tbItemObjs, item);
		-- end
		self:InsertFightText(nWinner, nGold, nExp, tbItemAdd);
		
		-- clear 
		self.m_nWinner = 0;
		self.m_tbReward = {};
		
		-- 构建结算面板需要的数值类奖励
		-- tbCurrency = {};
		-- tbCurrency["gold"] = nGold;
		-- tbCurrency["heroexp"] = nExp;
		-- tbCurrency["teamexp"] = nExpTeam;
		-- tbCurrency["ap"] = nAP;
	end
	
	-- 显示奖励界面
	if self.m_pLayer then
		local layer = KGC_UI_FIGHT_RESULT_LAYER_TYPE:create(self.m_pLayer, {1});
		-- 每次打开需要用这个名字查找之前的panel, 用于关闭
		layer:setName("pnl_reward")
		layer:UpdateData(nWinner, nHPLeftRate, nSign, {nGold, nExp, nAP, tbItemObjs});
	end
end

--@function: pvp战斗结算
function FightViewLogic:OnPvpFightCallBack(nWinner, tbCurrency, tbItems)
	-- local tbItemObjs = {}
	-- for _, tbData in pairs(tbItems or {}) do
		-- local nID, nNum = unpack(tbData);
		-- local item = me:GetBag():GetItemByID(nID);
		-- table.insert(tbItemObjs, item);
	-- end
	-- self:InsertFightText(nWinner, nGold, nExp, tbItemObjs);
	local nHPLeftRate = self.m_nHPLeftRate;
	
	-- 显示奖励界面
	if self.m_pLayer then
		local layer = KGC_UI_FIGHT_RESULT_LAYER_TYPE:create(self.m_pLayer, {2});
		-- 每次打开需要用这个名字查找之前的panel, 用于关闭
		layer:setName("pnl_reward")
		layer:UpdateDataNew(nWinner, nHPLeftRate, tbCurrency, tbItemObjs);
	end
end

--@function: 请求离线奖励
function FightViewLogic:ReqFightRewardOffLine()
	local fnCallBack = function(tbArg)
		local tbItems = tbArg.bagitem;
		local tbPlayer = tbArg.playerInfo;
		
		-- tst_print_lua_table(tbArg);
		local nRet = tbArg.retCode;	-- 返回结果
		local nTime = tbArg.offTime;
		local nGoldAdd = tbArg.gold;
		local nExpAdd = tbArg.exp;
		local nAp = tbArg.action;
		local szLog = "[离线奖励接受]"
		szLog = szLog .. ", msg = {addgold = " .. tostring(nGoldAdd) .. ", addexp = " .. tostring(nExpAdd) .. ", 行动力 = " .. tostring(nAp) .. "}"
		KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():OnRspAfkStatistics(nGoldAdd, nExpAdd, nAP, nTime, tbPlayer, tbItems)
		cclog( szLog)

		-- 请求离线挂机奖励进度(各个界面显示)
		-- 放在这里的原因：loginlogic会宕掉，在websocket
		FightViewLogic:getInstance():ReqRewardMoreCount();
	end
	print("[离线奖励请求]");
	g_Core.communicator.loc.offlineProfit(fnCallBack);
end

--@function: 发送在线奖励
--@bWin: true-胜; false-败
function FightViewLogic:ReqFightRewardOnLine(bWin, nHeroBoxID)
	local nFPID = 0;
	if nHeroBoxID then
		local tbConfig = l_tbHeroBox[nHeroBoxID] or {};
		nFPID = tbConfig.afkerpoint or 0;
	end
	
	local tbReqArg = {}
	tbReqArg.isWin = 1;
	-- tbReqArg.pointId = nFPID;
	cclog("[发送协议]在线奖励, isWin(%d), pointId(%s - %s)", 1, tostring(nFPID), tostring(type(nFPID)))
	
	if bWin then
		local fnCallBack = function(tbArg)
			local nGoldAdd = tbArg.gold
			local nExpAdd =  tbArg.exp
			local nAp = tbArg.action
			local tbPlayer = tbArg.playerInfo
			local tbItems = tbArg.bagitem
			cclog("[接收在线奖励] gold = %s, nExp = %s, nAP = %s", tostring(nGoldAdd), tostring(nExpAdd), tostring(nAP));
			self:OnRepFightReward(nGoldAdd, nExpAdd, nAp, tbPlayer, tbItems, 1)
		end
		
		g_Core.communicator.loc.onlineProfit(tbReqArg, fnCallBack);
	else
		self:InsertFightText(2, 0, 0);
		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_FIGHTRESULT, {false})
	end
end

--@function: 服务器返回奖励回调
function FightViewLogic:OnRepFightReward(nGoldAdd, nExpAdd, nAPAdd, tbPlayer, tbItems, bRewardType)
	local nGold = tbPlayer.gold
		
	me:SetGold(nGold);
	me:OnAddExp(tbPlayer, {}, nExpAdd)
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

	local nWinner = 1;
	if bRewardType == 1 then				-- 插入到播报
		self:InsertFightText(nWinner, nGoldAdd, nExpAdd, tbObjs);
		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_FIGHTRESULT, {true, {nGoldAdd, nExpAdd, tbObjs}})
	elseif bRewardType == 2 then			-- 弹出通用奖励界面
		KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():UpdateData(nGoldAdd, nExpAdd, nAPAdd, tbItems, nil, false, true)
	end
	
	-- 通知给地图挂机点显示奖励
	local nMapID = me:GetMapID();
	local nFPID = me:GetCurrentAfkPoint();
	local tbReward = {nGoldAdd, nExpAdd, nAPAdd, tbItems};
	MapViewLogic:getInstance():HookFightFinished(nMapID, nFPID, nil, tbReward);
end

--@function: 请求奖励宝箱进度
function FightViewLogic:ReqRewardMoreCount()
	local fnCallBack = function(tbArg)
		local nCount = tbArg.rewardCount;
		local nStep = tbArg.step;
		cclog("[接收协议]返回挂机奖励宝箱进度次数 rewardCount = %s, step = %s", tostring(nCount), tostring(nStep));
		self:OnRspRewardMoreCount(nCount, nStep)
		
		-- 通知所有界面进度
		self:UpdateAfkerRewardMore(nCount, nStep);
	end
	
	cclog("[发送协议]获取挂机奖励宝箱进度次数");
	g_Core.communicator.loc.getRewardTime(fnCallBack);
end

--@function: 服务器返回奖励宝箱进度
function FightViewLogic:OnRspRewardMoreCount(nCount, nStep)
	if self.m_pLayer then
		self.m_pLayer:UpdateRewardMore(nCount, nStep);
	end
end

--@function: 请求获取奖励宝箱内容
function FightViewLogic:ReqGetRewardMore()
	local fnCallBack = function(tbArg)
		local nGoldAdd = tbArg.gold
		local nExpAdd =  tbArg.exp
		local nAp = tbArg.action
		local tbPlayer = tbArg.playerInfo
		local tbItems = tbArg.bagitem
		local nCount = tbArg.rewardCount
		local nStep = tbArg.step
		cclog("[接收协议]获取挂机奖励宝箱奖励 gold = %s, nExp = %s, nAP = %s, nCount = %s, nStep = %s", tostring(nGoldAdd), tostring(nExpAdd), tostring(nAP), tostring(nCount), tostring(nStep));
		-- self:OnRepFightReward(nGoldAdd, nExpAdd, nAp, tbPlayer, tbItems, 2)
		self.m_pLayer:UpdateRewardMore(0, nStep);
		
		-- 通知所有界面进度
		self:UpdateAfkerRewardMore(nCount, nStep);
	end
	
	cclog("[发送协议]获取挂机奖励宝箱奖励");
	g_Core.communicator.loc.getPresent(fnCallBack);
end

function FightViewLogic:UpdateAfkerRewardMore(nCount, nStep)
	-- 通知所有界面进度
	local nAfkerPoint = me:GetCurrentAfkPoint();
	local tbConfig = (l_tbAfkConfig[nAfkerPoint] or {}).Score or {};
	local nNeedMonster = tbConfig[nStep] or 0;
	local nPercent = 0;
	if not tbConfig[nStep] then
		cclog("[Log]阶段奖励已经取完了，不再显示!");
		nPercent = 0;
	else
		if nNeedMonster > 0 then
			nPercent = math.floor(nCount/nNeedMonster * 100);
		end
	end
	if nPercent < 0 then
		nPercent = 0;
	elseif nPercent > 100 then
		nPercent = 100;
	end
	me:SetAfkerRewardPercent(nPercent);
	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_AFKERREWARD, {nPercent});
end

function FightViewLogic:InsertFightText(nWinner, nGoldAdd, nExpAdd, tbObjs)
	
	--增加统计数据
	me:AddAfkStatistics(nGoldAdd, nExpAdd, nAPAdd, tbObjs);

	self.m_pLayer:InsertSystemText(1000, {nWinner, nGoldAdd, nExpAdd})
	
	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY);
	
	print("InsertFightText ... ", nWinner);
end

--@function: 设置第机场指引战斗结束
function FightViewLogic:SetFightGuideStage(nStage)
	self.m_nCurStage = nStage;
end

--@function: 指引获取战斗是否结束
function FightViewLogic:GetFightGuideStage()
	return self.m_nCurStage;
end

--@function: 指引战斗
function FightViewLogic:OpenGuideFight(nHeroBoxID)
	local tbConfig = l_tbHeroBox[nHeroBoxID] or {};
	local nAfkerPoint = tbConfig.afkerpoint;
	local nMonsterBoxID = me:RandomMonsterBoxID(nAfkerPoint);
	local nSeed = os.time();
	print("[Log]StartGuideFight ... ", nSeed, nHeroBoxID, nAfkerPoint, nMonsterBoxID)
	
	-- local data = g_PlayerFactory:TestCreatePlayer(nHeroBoxID)
	self.m_pLayer:Init(data, nil)
	
	local fnCall = function()
		self.m_pLayer:StartGuideFight(nSeed, nHeroBoxID, nMonsterBoxID);
	end
	
	self.m_pLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnCall)));
end

--更新战斗聊天消息
function FightViewLogic:UpdateChatMessage(nCamp, nType, szName, szMsg)
	if self.m_pLayer then
		self.m_pLayer:UpdateChatMessage(nCamp, nType, szName, szMsg)
	end
end
------------------------------------------------------------------------
-- test
function FightViewLogic:TestStartAFight(parent)
	print("[Log]TestStartAFight ... ", nSeed, nBoxID, nWinner, tbReward)
	
	-- 初始化新的战斗界面
	local layout = KG_UIFight.new({bDebug = true});
	parent:addChild(layout);
	-- layout.m_FightHall = KGC_FightHall:getInstance()
	
	layout:Init(data1, data2)
end

--@测试：和服务器验证结果是否正确
function FightViewLogic:TestFightCompareWithServer()
	local nBoxID = 10101;
	local fnCallBack = function(tbArg)
		local nSeed = tbArg.seed;
		gf_SetRandomSeed(nSeed)
		local szLog = string.format("[战斗测试返回]seed(%s)", tostring(nSeed));
		print(szLog);
		for i = 1, 1 do
			-- local nSeed = os.time();
			-- local nBoxID = me:RandomMonsterBoxID();
			local enemy = g_PlayerFactory:CreateMonsterBox(nBoxID)
			local fightHall = KGC_FightHall:getInstance();
			fightHall:Init(me, enemy);
			fightHall:Fight(nSeed);
		end
	end
	
	local tbReqArg = {}
	tbReqArg.monsterid = nBoxID;
	cclog("[战斗测试请求]monsterid(%s)", tostring(tbReqArg.monsterid));
	g_Core.communicator.loc.testfight(tbReqArg, fnCallBack);
end

function FightViewLogic:TestStartFightWithMonster(parent, nBoxID)
	local nSeed = os.time();
	nSeed = 1444895980;
	print("[Log]TestStartFightWithMonster ... ", nSeed, nBoxID)
	
	-- 初始化新的战斗界面
	local layout = KG_UIFight.new({bDebug = true});
	parent:addChild(layout);

	layout:Init()
	layout:UpdateData(enemy)
	
	local fnCall = function()
		layout:StartGuideFight(nSeed, nBoxID);
	end
	
	layout:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(fnCall)));
	return layout;
end

function FightViewLogic:TestStartFightWithMonsterCustom(parent, nHeroBoxID, nMonsterBoxID)
	local nSeed = os.time();
	nSeed = 1444895980;
	print("[Log]TestStartFightWithMonster ... ", nSeed, nHeroBoxID, nMonsterBoxID)
	
	-- 初始化新的战斗界面
	local layout = KG_UIFight.new({bDebug = true});
	parent:addChild(layout);

	layout:Init(data, enemy)
	
	local fnCall = function()
		layout:StartGuideFight(nSeed, nHeroBoxID, nMonsterBoxID);
	end
	
	layout:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(fnCall)));
	return layout;
end

function FightViewLogic:TestStartFightWithMonsterCustom2(layout, nHeroBoxID, nMonsterBoxID)
	local nSeed = os.time();
	print("[Log]TestStartFightWithMonsterCustom2 ... ", nSeed, nHeroBoxID, nMonsterBoxID)
	
	-- 初始化新的战斗界面
	if not layout then
		cclog("[Error]前面一场战斗已经关闭~");
		return;
	end

	layout:Init(data, enemy)
	
	local fnCall = function()
		layout:StartGuideFight(nSeed, nHeroBoxID, nMonsterBoxID);
	end
	
	layout:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnCall)));
	return layout;
end