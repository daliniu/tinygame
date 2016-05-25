----------------------------------------------------------
-- file:	arenalayer.lua
-- Author:	page
-- Time:	2015/11/28 16:17
-- Desc:	竞技场界面
----------------------------------------------------------
require ("script/ui/resource");
require ("script/ui/publicview/mainbuttonview");
require ("script/core/arena/factory");
require ("script/ui/arenaview/watch_sublayer");
require("script/core/configmanager/configmanager");
----------------------------------------------------------
local l_tbNormalRewardConfig = mconfig.loadConfig("script/cfg/pvp/SportsChest");
--data struct
local TB_STRUCT_UI_ARENA_LAYER = {
	-- config
	m_tbLocalZOrder = {				-- 三个主panel实现旋转的层级配置
		LOW = 0,						-- 最下面两个panel层级
		MIDDLE = 1,						-- 遮挡panel层级
		HIGH = 2,						-- 最前面panel层级
	},
	
	m_tbIndex = {					-- 面板索引(和UI一致)
		NORMAL = 1,
		WEEKLY = 2,
		DAILY = 3,
	},
	
	m_bUpdate = true,				--是否updae
	-----------------------------------------
	m_pLayout = nil,				-- json界面
	
	m_bIsRunning = false,			-- 界面是否正在动画
	m_nCurIndex = 0,				-- 当前是哪个界面在最上面
	m_tbMainPanels = {},			-- 做旋转特效的三个界面存放
	m_tbPanelsOriginal = {},		-- 记录panel开始信息(位置、缩放)
	m_tbPnlSignup = {},				-- 报名面板对应关系
}

KGC_ARENA_LAYER_TYPE = class("KGC_ARENA_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_UI_ARENA_LAYER)
--------------------------------
--ui function
--------------------------------

function KGC_ARENA_LAYER_TYPE:Init(tbArg)
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_PATH);
    self:addChild(self.m_pLayout);
	
	self:LoadScheme();
	
	self:UpdateData();
end

--解析界面文件
function KGC_ARENA_LAYER_TYPE:LoadScheme()
	local btnClose = self.m_pLayout:getChildByName("btn_close");
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_ARENA_LOGIC_TYPE:getInstance():closeLayer()
        end
	end
	btnClose:addTouchEventListener(fnClose);
	
	local pnlSelect = self.m_pLayout:getChildByName("pnl_selectbg");
	-- 三个界面
	local pnlCover = pnlSelect:getChildByName("pnl_cover");				-- 遮罩
	pnlCover:setLocalZOrder(self.m_tbLocalZOrder.MIDDLE);
	
	-- 点击面板响应函数
	local fnCall = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventSelectArena(sender);
		end
	end
	-- 点击报名面板响应函数
	local fnCloseSignup = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			sender:setVisible(false);
		end
	end
	
	for i = 1, 3 do
		local szName = "pnl_arena_" .. i;
		local panel = pnlSelect:getChildByName(szName);
		-- 从0-3好计算循环变换的数值
		local order = i - 1;
		panel._order = order;
		panel.m_index = i;
		panel:addTouchEventListener(fnCall);
		table.insert(self.m_tbMainPanels, panel);
		local x, y = panel:getPosition();
		local nScale = panel:getScale();
		self.m_tbPanelsOriginal[order] = {x, y, nScale};
		
		if order == 0 then
			panel:setLocalZOrder(self.m_tbLocalZOrder.HIGH);
		else
			panel:setLocalZOrder(self.m_tbLocalZOrder.LOW);
		end
		
		-- 报名面板
		local szSignupName = "pnl_signup" .. i;
		local pnlSignup = self.m_pLayout:getChildByName(szSignupName);
		self.m_tbPnlSignup[panel.m_index] = pnlSignup;
		if pnlSignup then
			pnlSignup:setVisible(false);
			pnlSignup:addTouchEventListener(fnCloseSignup);
			
			self:LoadSignupScheme(i, pnlSignup);
		end
	end
	
	local btnLeft = self.m_pLayout:getChildByName("btn_left");
	local btnRight = self.m_pLayout:getChildByName("btn_right");
	local fnTouchChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnLeft then
				self:ChangePanel(-1);
			elseif sender == btnRight then
				self:ChangePanel(1);
			end
		end
	end
	btnLeft:addTouchEventListener(fnTouchChange);
	btnRight:addTouchEventListener(fnTouchChange);
	
	--创建主按钮
    self:AddSubLayer(MainButtonLayer:create());
end

function KGC_ARENA_LAYER_TYPE:LoadSignupScheme(nIndex, pnlSignup)
	if not nIndex or not pnlSignup then
		return;
	end
	
	-- 点击报名按钮响应函数
	local fnSignup = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:Signup(sender);
		end
	end
	-- 点击战报按钮响应函数
	local fnWatchGame = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventWatchGame(sender);
		end
	end
	
	if self.m_tbIndex.NORMAL == nIndex then				-- 常规赛(锦标赛)
		local btnSignup = pnlSignup:getChildByName("btn_signup");
		if btnSignup then
			btnSignup.m_index = nIndex;
			btnSignup:addTouchEventListener(fnSignup);
		end
	elseif self.m_tbIndex.DAILY == nIndex then			-- 日赛
		--- normal 状态
		local pnlNormal = pnlSignup:getChildByName("pnl_normal");
		pnlNormal:setVisible(true);
		local btnSignup = pnlNormal:getChildByName("btn_join");
		if btnSignup then
			btnSignup.m_index = nIndex;
			btnSignup:addTouchEventListener(fnSignup);
		end
		
		-- 战报按钮
		local btnWatch = pnlNormal:getChildByName("btn_fight");
		if btnWatch then
			btnWatch.m_index = nIndex;
			btnWatch:addTouchEventListener(fnWatchGame);
		end
		
		-- 战斗状态
		local pnlFight = pnlSignup:getChildByName("pnl_fight");
		pnlFight:setVisible(false);
	elseif self.m_tbIndex.WEEKLY == nIndex then
	
	end

end

function KGC_ARENA_LAYER_TYPE:Update(dt)
	-- 更新倒计时
	self:UpdateDailyCountDown();
end

--@function: 左右切换面板
--@nChange: left(-1);right(1);
function KGC_ARENA_LAYER_TYPE:ChangePanel(nChange)
	print("左右切换功能面板", nChange)
	if self.m_bIsRunning then
		return;
	end
	self.m_bIsRunning = true;
	
	local fnCall = function(sender, tbArg)
		self.m_bIsRunning = false;
	end
	
	for _, panel in pairs(self.m_tbMainPanels) do
		local oldOrder = panel._order;
		order = (oldOrder + nChange)% #self.m_tbMainPanels;
		panel._order = order;
		
		-- 修改层级关系		
		if order == 0 then
			panel:setLocalZOrder(self.m_tbLocalZOrder.HIGH);
			self.m_nCurIndex = panel.m_index;
		elseif order == 1 or order == 2 then
			panel:setLocalZOrder(self.m_tbLocalZOrder.LOW);
		end		
		
		local x, y, nScale = unpack(self.m_tbPanelsOriginal[order]);
		local moveTo = cc.MoveTo:create(0.5, cc.p(x, y));
		local scaleTo = cc.ScaleTo:create(0.5, nScale);
		local spawn = cc.Spawn:create(moveTo, scaleTo);
		local action = cc.Sequence:create(spawn, cc.CallFunc:create(fnCall, {panel}));
		panel:runAction(action);
	end
end

function KGC_ARENA_LAYER_TYPE:TouchEventSelectArena(widget)
	if not widget then
		return;
	end
	local nIndex = widget.m_index;
	local pnlSignup = self.m_tbPnlSignup[nIndex];
	if nIndex == self.m_tbIndex.NORMAL then			-- 日竞技赛响应事件
		local bIsSignup = KGC_ARENA_FACTORY_TYPE:getInstance():IsArenaNormalSignup();
		print("日常赛：是否报名", bIsSignup);
		if bIsSignup then
			pnlSignup:setVisible(false);
			self:OpenArenaNormal();
		else
			pnlSignup:setVisible(true);
		end
	elseif nIndex == self.m_tbIndex.DAILY then		-- 日锦标赛响应事件
		local bIsSignup = KGC_ARENA_FACTORY_TYPE:getInstance():IsDailySignup();
		--test
		bIsSignup = true;
		--test end
		if bIsSignup then
			pnlSignup:setVisible(false);
			-- 请求即将进入的筹码赛数据
			KGC_ARENA_LOGIC_TYPE:getInstance():ReqDailyChipsFightInfo();
			--test
			self:OpenArenaDailyChips();
			--test end
		else
			pnlSignup:setVisible(true);
		end
	elseif nIndex == self.m_tbIndex.WEEKLY then		-- 周锦标赛响应事件
	
	end
end

--@function: 
function KGC_ARENA_LAYER_TYPE:UpdateData()
	local nTimes = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalTimes();
	local nMasterScore = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaMasterScore();
	local nDailyTickets = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaDailyTickets();

	-- 日竞技赛内容(门票，大师积分)
	self:UpdateNormalData(nTimes, nMasterScore);
	
	-- 日锦标赛
	local tbDailyInfo = {};
	self:UpdateDailyData(nMasterScore);
	
	-- 周锦标赛
	local tbWeeklyInfo = {};
	self:UpdateWeeklyData(nDailyTickets);
end

--@function: 更新日常赛(日竞技赛)数据
function KGC_ARENA_LAYER_TYPE:UpdateNormalData(nTimes, nMasterScore)
	local nTimes = nTimes or 0;
	local nMasterScore = nMasterScore or 0;
	
	local nIndex = self.m_tbIndex.NORMAL;
	local nMaxTimes = 5;
	local panel = self.m_tbMainPanels[nIndex];
	local wgtScore = panel:getChildByName("btn_score");
	local bmpTicket = panel:getChildByName("bmp_ticketnum");
	local bmpScore = wgtScore:getChildByName("bmp_scorenum");
	bmpTicket:setString(nTimes .. "/" .. nMaxTimes);
	bmpScore:setString(nMasterScore);
	-- 红色提醒
	if nTimes <= 0 then
		bmpTicket:setColor(cc.c3b(255, 0, 0));
	else
		bmpTicket:setColor(cc.c3b(255, 255, 255));
	end
	
	-- 报名面板
	local pnlSignup = self.m_tbPnlSignup[nIndex];
	local btnTicket = pnlSignup:getChildByName("btn_ticket");
	local btnScore = pnlSignup:getChildByName("btn_score");
	local bmpTicket = btnTicket:getChildByName("bmp_ticketnum");
	local bmpScore = btnScore:getChildByName("bmp_scorenum");
	local pnlReward = pnlSignup:getChildByName("pnl_reward");
	
	bmpTicket:setString(nTimes .. "/" .. nMaxTimes);
	bmpScore:setString(nMasterScore);
	for i = 1, 3 do
		local szName = "pnl_reward" .. i;
		local pnlTemp = pnlReward:getChildByName(szName);
		local lblGold = pnlTemp:getChildByName("lbl_gold");
		local lblScore = pnlTemp:getChildByName("lbl_score");
		
		local tbData = l_tbNormalRewardConfig[i];
		if tbData then
			local nGold = tbData.Reward2;
			local nScore = tbData.Reward1;
			pnlTemp:setVisible(true);
			lblGold:setString(nGold);
			lblScore:setString(nScore);
		else
			pnlTemp:setVisible(false);
		end
	end
end

--@function: 更新日锦标赛(日全服赛)数据
function KGC_ARENA_LAYER_TYPE:UpdateDailyData(nMasterScore)
	local nMasterScore = nMasterScore or 0;
	local nIndex = self.m_tbIndex.DAILY;
	local panel = self.m_tbMainPanels[nIndex];
	local wgtScore = panel:getChildByName("btn_score");
	local bmpScore = wgtScore:getChildByName("bmp_scorenum");
	bmpScore:setString(nMasterScore);
	
	-- 报名面板
	local pnlSignup = self.m_tbPnlSignup[nIndex];
	local btnScore = pnlSignup:getChildByName("btn_score");
	local bmpSignupScore = btnScore:getChildByName("bmp_scorenum");	-- 大师积分
	bmpSignupScore:setString(nMasterScore);							
	self:UpdateDailyCountDown();
	
end

--@function: 更新周锦标赛(周全服赛)数据
function KGC_ARENA_LAYER_TYPE:UpdateWeeklyData(nTickets)
	local nTickets = nTickets or 0;
	local nIndex = self.m_tbIndex.WEEKLY;
	local panel = self.m_tbMainPanels[nIndex];
	local wgtTicket = panel:getChildByName("btn_ticket");
	local bmpTicket = wgtTicket:getChildByName("bmp_ticketnum");
	bmpTicket:setString(nTickets);
	
	-- 报名面板
	local pnlSignup = self.m_tbPnlSignup[nIndex];
end

--@function: 报名
function KGC_ARENA_LAYER_TYPE:Signup(widget)
	if not widget then
		return;
	end
	
	local nIndex = widget.m_index;
	if nIndex == self.m_tbIndex.NORMAL then			-- 日竞技赛
		local nTimes = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalTimes();
		if nTimes <= 0 then
			TipsViewLogic:getInstance():addMessageTips(12301);
		else
			KGC_ARENA_LOGIC_TYPE:getInstance():ReqArenaNormalSignup();
		end
	elseif nIndex == self.m_tbIndex.DAILY then		-- 日锦标赛

	elseif nIndex == self.m_tbIndex.WEEKLY then		-- 周锦标赛
	
	end
end

--@function: 战报
function KGC_ARENA_LAYER_TYPE:TouchEventWatchGame(widget)
	if not widget then
		return;
	end
	
	-- 打开战报界面
	KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:create(self);
end
-------------------------------------------------------
-- *** 日赛 ***
--@function: 如果报名了打开日竞技赛战斗界面
function KGC_ARENA_LAYER_TYPE:OpenArenaNormal()
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA_NORMAL);
			
	-- 关闭界面
	KGC_ARENA_LOGIC_TYPE:getInstance():closeLayer();
end

-------------------------------------------------------
-- *** 日锦标赛 ***
--@function: 如果报名了打开日竞技赛战斗界面-筹码赛
function KGC_ARENA_LAYER_TYPE:OpenArenaDailyChips()
	local nStage, nStep	= KGC_ARENA_FACTORY_TYPE:getInstance():GetCurrentStage();
	local nTurn, nMaxTurn = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaDailyTurn(1);
	local bIsFight = KGC_ARENA_FACTORY_TYPE:getInstance():IsFight(1, nTurn, nStep);
	-- print("OpenArenaDailyChips: ", nStage, nTurn, nMaxTurn);
	cclog("[log]打开筹码赛界面 ... ");
	cclog("[log]当前状态: %s", tostring(nStage));
	cclog("[log]当前阶段: %s", tostring(nStep));
	cclog("[log]自己场次: %s", tostring(nTurn));
	cclog("[log]总场次: %s", tostring(nMaxTurn));
	-- 还在战斗阶段就打开战斗面板(阶段1 + 自己战斗轮次满足条件)
	if nStage == 1 and bIsFight then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA_FIGHT);
		-- 关闭界面
		KGC_ARENA_LOGIC_TYPE:getInstance():closeLayer();
	elseif nStage == 2 then
		-- 请求八强赛数据
		KGC_ARENA_LOGIC_TYPE:getInstance():ReqDailyEightFightInfo();
	else
		local pnlSignup = self.m_tbPnlSignup[self.m_nCurIndex];
		if pnlSignup then
			pnlSignup:setVisible(true);
		end
	end
	cclog("[log]打开筹码赛界面 end. ");
end

--@function: 更新倒计时
function KGC_ARENA_LAYER_TYPE:UpdateDailyCountDown()
	local pnlSignup = self.m_tbPnlSignup[self.m_tbIndex.DAILY];
	if pnlSignup and pnlSignup:isVisible() then
		local lblCountDown = pnlSignup:getChildByName("lbl_time");	-- 倒计时						
		local szTime = tf_FormatWithTime(22, 0, 0);					-- 晚上22点
		lblCountDown:setString(szTime);
	end
end

--@function: 如果报名了打开日竞技赛战斗界面-八强赛
function KGC_ARENA_LAYER_TYPE:OpenArenaDailyEight()
	local nRank = KGC_ARENA_FACTORY_TYPE:getInstance():GetDailyChipsRank();
	local bInEight = KGC_ARENA_FACTORY_TYPE:getInstance():IsInEight();
	local nStage, nStep	= KGC_ARENA_FACTORY_TYPE:getInstance():GetCurrentStage();
	local nTurn, nMaxTurn = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaDailyTurn(2);
	local bIsFight = KGC_ARENA_FACTORY_TYPE:getInstance():IsFight(2, nTurn, nStep);
	cclog("[log]打开八强赛界面 ... ");
	cclog("[log]筹码赛排名：%d", nRank);
	cclog("[log]当前状态: %s", tostring(nStage));
	cclog("[log]当前阶段: %s", tostring(nStep));
	cclog("[log]自己场次: %s", tostring(nTurn));
	cclog("[log]总场次: %s", tostring(nMaxTurn));
	-- 还在战斗阶段就打开战斗面板(八强 + 阶段2 + 自己战斗轮次)
	if bInEight and nStage == 2 and bIsFight then
		-- 当前是哪一个阶段
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA_FIGHT);
		-- 关闭界面
		KGC_ARENA_LOGIC_TYPE:getInstance():closeLayer();
	else
		local pnlSignup = self.m_tbPnlSignup[self.m_nCurIndex];
		if pnlSignup then
			pnlSignup:setVisible(true);
		end
	end
	cclog("[log]打开八强赛界面 end.");
end