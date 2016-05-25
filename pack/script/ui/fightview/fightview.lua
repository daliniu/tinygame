----------------------------------------------------------
-- file:	uifight.lua
-- Author:	page
-- Time:	2015/01/26
-- Desc:	All ui operation about fight
----------------------------------------------------------
require "script/lib/basefunctions"
require "script/lib/debugfunctions"
require "script/lib/definefunctions"
require "script/core/core"
require "script/ui/resource"
require "script/ui/visiblerect"
require "script/core/reward/rewardmanager"
require "script/core/npc/modelmanager"
require "script/class/class_base_ui/class_base_layer"
require "script/ui/fightview/fightparser"
require "script/ui/fightview/fightcagelayer"
require "script/core/minifight/minifight"
require "script/core/minifight/fighter"
require "script/ui/fightview/fightcharacter"
require "script/core/minifight/minidef"
require "script/core/configmanager/configmanager"
require "script/ui/fightview/fightcardlayer"
require "script/ui/fightview/fightrecordlayer"
require "script/ui/fightview/fightchatlayer"
require "script/core/minifight/minifunc"

local l_tbZOrder = mconfig.loadConfig("script/cfg/client/view/localzorder")
local l_tbLocalZOrder, l_tbGlobalZOrder = l_tbZOrder.tbLocal, l_tbZOrder.tbGlobal
local l_tbNpcModels = mconfig.loadConfig("script/cfg/client/model")
local l_tbString = mconfig.loadConfig "script/cfg/string"
local l_tbEffectDecoration = mconfig.loadConfig("script/cfg/client/decorationeffect")
local l_tbAfkConfig = mconfig.loadConfig("script/cfg/map/afkreward")
local l_tbBgImageConfig = mconfig.loadConfig("script/cfg/map/picgroup")
local l_tbHeroBox = mconfig.loadConfig("script/cfg/client/herobox")
local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
local l_tbSkillResultConfig = mconfig.loadConfig("script/cfg/skills/skillresults")
local l_tbConfigShow = mconfig.loadConfig("script/cfg/client/skillshowout")
local l_tbCharacterConfig = mconfig.loadConfig("script/cfg/character/character")
local l_tbMonsterConfig = mconfig.loadConfig("script/cfg/battle/monster")
local l_tbStateResults = mconfig.loadConfig("script/cfg/skills/statusresults")
local l_tbStatesShowout = mconfig.loadConfig ("script/cfg/client/stateshowout")
local l_tbEffectConfig = mconfig.loadConfig ("script/cfg/client/action/magicconfig")
local l_tbMonsterBox = mconfig.loadConfig("script/cfg/battle/monsterbox")
local l_tbExplorTalk = mconfig.loadConfig("script/cfg/client/explortalk")
local l_tbFightSetting = mconfig.loadConfig("script/cfg/client/ui/fightsetting")
----------------------------------------------------------
local l_tbCamp = def_GetFightCampData()
local l_tbPos = def_GetPosData()
local l_tbSkillCastRet = def_GetSkillCastRetData()
local l_tbUIUpdateType = def_GetUIUpdateTypeData()
local l_tbEffect = def_GetEffectType()
local l_tbFightType = {
	T_USERGUIDE = 1,	-- 指引战斗
	T_CUSTOM = 2,		-- 指定打的战斗(地图上的怪, pvp等)
	T_AFKER = 3,		-- 挂机战斗
}

local nGuildHeroBox = {105006, 105007, 105008, 105009}		--新手英雄box对应

local TABTYPE = {
	CHAT = 1, 		--聊天
	CARD = 2,		--卡牌
	RECORD = 3,		--记录
}

--data struct
local TB_UI_FIGHT = {
	--config
	m_szHeroHP = "bar_hp",					--字段：角色血条
	m_szHeroCost = "list_cost",				--字段：费用条
	m_szCostItem = "cost",					--字段：单个费用
	m_szPnlModel = "pnl_npc_armature",		--字段：角色panel
	
	m_bUpdate = true;
	------------------------------------------------------------
	--界面
	m_Layout = false,					--保存界面结构root
	m_pRecord = nil,					-- 战斗播报界面
	m_pnlSearch = nil,					-- 探索界面
	m_pnlEffect = nil,					-- 特效层
	
	--奖励界面									
	m_pnlRound = nil,					--回合开始的面板
	m_bmpRound = nil,					--每回合要显示的回合数
					
	m_tbHeros = {},						--角色表
	m_FightHall = nil,					--战斗系统
	btn_double = nil,					--加速按钮
	m_bPaused = false,					--暂停按钮状态	
	m_layerUp = nil,					--最上层界面(要调整位置)
	m_layerDown = nil,					--最下层界面(要调整界面)
	m_pnlState = nil,					--状态控件
	m_tbNode2Npc = {},					--保存节点对应npc
	m_widgetCostItem = nil,				--费用的item
	m_nItemDistance = 0,				--费用之间的距离(移动特效用)
	
	m_nCurrentSpeed = 1,                    --当前播放速度

	m_nFightType = nil,					-- 当前战斗类型(挂机战斗、指引战斗、地图上怪物、pvp)
	
	m_nHeroBoxID = nil,					-- 英雄盒子ID
	m_nMonsterID = nil,					--怪物盒子ID

	m_tCommand = nil,					-- 战斗指令

	m_tHeroNode = {},					-- 保存英雄ui节点

	m_tBeforeMove = {},					-- 保存召唤物移动前信息

	m_BmpStep = nil,					--步数
	
	m_BmpGold = nil,					--金币数
	
	m_BmpDiamond = nil,					--砖石数
	
	m_BmpLevel = nil,					--玩家等级
	m_BarExp = nil,						--经验条
	m_BmpExp = nil,						--经验
	
	m_BmpFightPoint = nil,				--战力
	m_BmpVIP = nil,						--vip等级

	m_searchMsg = nil,					--搜索信息
	
	m_countDown = nil,					--倒计时

	m_setting = nil,					--设置下拉菜单

	m_btnList = nil,					--下拉菜单按钮列表

	m_canGetReward = false,				--是否可以获取奖励
	
	m_pMainBtnLayer = nil,					--按钮层
	
	m_searchAction = nil,				--搜索动作
	
	m_rewardBar = nil,					--奖励bar

	m_rewardLabel = nil,				--奖励label
	
	m_bReseting = false,				--正在重置中

	m_pParser = nil,					--战斗指令解析器

	m_nWinner = 0,						--胜者

	m_protectAct = nil,					--保护action

	m_searchScheduler = nil,			--搜索时间

	m_cardLayer = nil,					--牌层

	m_chatLayer = nil,					--聊天层

	m_leftBtn = nil,					--左按钮
	m_rightBtn = nil,					--右按钮
	m_markChat = nil,					--聊天标记
	m_markCard = nil,					--卡牌标记
	m_markTxt = nil,					--记录标记
	m_pnlTab = nil,						--切换页面面板
	m_tabShow = nil,					--当前显示
	m_tabRunning = false,				--切换页面动作标记

	m_skipBtn = nil,					--跳过战斗按钮

	m_tDefenseEffect = {},			--防御效果回调

	m_testEffectPnl = nil,			--测试特效面板
}

KG_UIFight = class("KG_UIFight", KGC_UI_BASE_LAYER, TB_UI_FIGHT)
------------------------------------------------------------------
--指令id对应函数，函数名，定义在最后
local tCommand2Func = {}
------------------------------------------------------------------

----------------------------------------
--function
----------------------------------------
function KG_UIFight:ctor(tbArg)
	print("KG_UIFight ctor ... ", tbArg)
	if tbArg then
		self.m_bDebug = tbArg.bDebug
	end

	self:LoadScheme();
end

--init
function KG_UIFight:Init(tbMine, tbEnemy)
	-- self.m_FightHall = KGC_FightHall:getInstance()
	
	-- 开始搜索
	if not self.m_bDebug then
		print("this start fight!!!!!!!!!!!!!!")
		local nBoxID = me:RandomMonsterBoxID();
		self:SearchAndFight(os.time(), nBoxID);
	end

	self:playBackgroundMusic();

	-- 请求当前挂机点的进度
	FightViewLogic:getInstance():ReqRewardMoreCount();

	self:UpdateMoneyData()

	self.m_pParser = FightParser:new()	
end

-- 背景音乐
function KG_UIFight:playBackgroundMusic()
	AudioManager:getInstance():setBackgroundMusicVolume(0.5)	
	AudioManager:getInstance():playBackground("res/audio/background/audio_bg_fight_01");
end

function KG_UIFight:LoadScheme()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_PATH)
	self:addChild(self.m_Layout)
	
	local pnlControl = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_control")
	self.m_pnlSearch = pnlControl;
	self.m_pnlSearch:setVisible(false);

	self.m_searchMsg = ccui.Helper:seekWidgetByName(self.m_pnlSearch, "Label_11")
	
	self.m_countDown = ccui.Helper:seekWidgetByName(self.m_pnlSearch, "lbl_countdown")
	
	-- 回合开始显示
	self.m_pnlRound = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_round")
	self.m_pnlRound:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_ROUND)
	self.m_pnlRound:setVisible(false)
	self.m_bmpRound =self.m_pnlRound:getChildByName("bmp_turn");

	-- 上下血条
	self.m_layerUp = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_ui_2");
	self.m_layerDown = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_ui_1");
	self.m_layerUp:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_HP)
	self.m_layerDown:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_HP)
	
	-- 特效层panel
	self.m_pnlEffect = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_effect");
	self.m_pnlEffect:setLocalZOrder(l_tbLocalZOrder.PNL_EFFECT);
	self.m_pnlCombo = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_unite");
	self.m_pnlCombo:setVisible(false);

	--基本信息
	local pnlPlayerInfo = self.m_Layout:getChildByName("pnl_playerinfo")
	local btnStep = pnlPlayerInfo:getChildByName("btn_move")
	self.m_BmpStep = btnStep:getChildByName("bmp_movenum")
	
	local btnGold = pnlPlayerInfo:getChildByName("btn_money")
	self.m_BmpGold = btnGold:getChildByName("bmp_moneynum")
	
	local btnGold = pnlPlayerInfo:getChildByName("btn_diamond")
	self.m_BmpDiamond = btnGold:getChildByName("bmp_diamondnum")
	
	local imgLevel = pnlPlayerInfo:getChildByName("img_playerlevel");
	self.m_BmpLevel = imgLevel:getChildByName("bmp_playerlevel");
	self.m_BarExp = imgLevel:getChildByName("bar_exp")
	self.m_BmpExp = imgLevel:getChildByName("bmp_expnum")
	
	self.m_BmpFightPoint = ccui.Helper:seekWidgetByName(pnlPlayerInfo, "bmp_playerbattlescore");
	self.m_BmpVIP = ccui.Helper:seekWidgetByName(pnlPlayerInfo, "bmp_viplevel");	

	--test
	--暂停
	local fnCall = function (sender)
		print("fnCall")
		if not self.m_bPaused then
			print("暂停 ... ")
			self.m_bPaused = true;
			cc.Director:getInstance():pause();
		else
			print("重新开始 ... ")
			self.m_bPaused = false;
			cc.Director:getInstance():resume();
		end
	end
	local pauseBtnItem = cc.MenuItemImage:create(CUI_PATH_PAUSE,CUI_PATH_PAUSE);
	pauseBtnItem:registerScriptTapHandler(fnCall)
	local  menu = cc.Menu:create()
	menu:setVisible(false);
	local point = VisibleRect:top()
	menu:setPosition(VisibleRect:left())
	menu:addChild(pauseBtnItem)
	self:addChild(menu)

	--状态栏点击空白处取消
	local pnlState = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_state");
	local svState = pnlState:getChildByName("scrollview_stateinfo")
	local imgStateBg = pnlState:getChildByName("img_statebg")
	local pnlCoverState = pnlState:getChildByName("pnl_cover_state");
	pnlState:setVisible(true);
	imgStateBg:setVisible(false);
	svState:setVisible(false);
	pnlCoverState:setVisible(false);
	
	local fnTouchEvent = function(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			print("touch empty")
			imgStateBg:setVisible(false)
			svState:setVisible(false)
			pnlCoverState:setVisible(false)
		end
	end
	--点击空白处状态界面消失
	if pnlCoverState then
		pnlCoverState:addTouchEventListener(fnTouchEvent)
	end	

	local pnlTestFight = ccui.Helper:seekWidgetByName(self.m_Layout, "Panel_23")
	local TestFightBtn = ccui.Helper:seekWidgetByName(pnlTestFight, "btn_send")
	TestFightBtn:addTouchEventListener(function()
		self:TestFight()
	end)	
	
	local onKeyPressed = function(keyCode, event)
		print("event", event, keyCode, cc.KeyCodeKey[138], cc.KeyCode.KEY_R)
		if keyCode == 138 then		-- 'r'
			for i = 1, 2 do			--camp
				for j = 1, 6 do		--pos
					local node = self:GetStillNode(i, j)
					local n = node:getBackGroundColorOpacity()
					local btnState = ccui.Helper:seekWidgetByName(node, "btn_state")
					if n > 0 then
						menu:setVisible(false);
						node:setBackGroundColorOpacity(0)
						if btnState then
							btnState:setOpacity(0)
						end
					else
						menu:setVisible(true);
						node:setBackGroundColorOpacity(50)
						if btnState then
							btnState:setOpacity(50)
						end
					end
				end
			end
		end
		if keyCode == cc.KeyCode.KEY_E then		-- 'e'
			for i = 1, 2 do			--camp
				local szName = "pnl_ship_effect_" .. i;
				local pnlShip = self.m_pnlEffect:getChildByName(szName);
				
				local n = pnlShip:getBackGroundColorOpacity()
				if n > 0 then
					pnlShip:setBackGroundColorOpacity(0)
				else
					pnlShip:setBackGroundColorOpacity(50)
				end
			end
		end
		if keyCode == cc.KeyCode.KEY_F then 	-- 'f'
			pnlTestFight:setVisible(not pnlTestFight:isVisible())
			pnlTestFight:getChildByName("img_inputbg_0"):getChildByName("tf_input"):setText("")
			pnlTestFight:getChildByName("img_inputbg_1"):getChildByName("tf_input"):setText("")		
		end
		if keyCode == cc.KeyCode.KEY_F1 then
			ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_id"):getChildByName("txt_id"):setText("")
		end
		if keyCode == cc.KeyCode.KEY_F2 then
			ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_position"):getChildByName("txt_id"):setText("")
		end
		if keyCode == cc.KeyCode.KEY_F3 then
			ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_scale"):getChildByName("txt_id"):setText("")			
		end
		if keyCode == cc.KeyCode.KEY_F4 then
			ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_start"):getChildByName("txt_id"):setText("")
		end
		if keyCode == cc.KeyCode.KEY_F5 then
			ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_bones"):getChildByName("txt_id"):setText("")
		end
		if keyCode == cc.KeyCode.KEY_F6 then
			if self.m_testEffectPnl:isVisible() then
				self.m_testEffectPnl:setVisible(false)
				self.m_pnlTab:setVisible(true)		
				self:Over()		
				local nBoxID = me:RandomMonsterBoxID();
				self:SearchAndFight(os.time(), nBoxID);				
			else				
				self.m_testEffectPnl:setVisible(true)
				self.m_pnlTab:setVisible(false)
				self:Over()
				self.m_pnlSearch:setVisible(false)
				self:LoadNpc(fighter.createFromMonsterBox(10300101), l_tbCamp.ENEMY)
			end
		end
		if keyCode == cc.KeyCode.KEY_C then
			if self.m_testEffectPnl:isVisible() then
				ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_id"):getChildByName("txt_id"):setText("")
				ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_scale"):getChildByName("txt_id"):setText("")
				ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_position"):getChildByName("txt_id"):setText("")			
				ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_start"):getChildByName("txt_id"):setText("")
				ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_bones"):getChildByName("txt_id"):setText("")
			end
		end
	end
	local listener = cc.EventListenerKeyboard:create();
	listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	--test end
	
	--cost
	self.m_widgetCostItem = ccui.Helper:seekWidgetByName(self.m_Layout, self.m_szCostItem);
	self.m_widgetCostItem:setVisible(false);
	
	-- 按钮：首页
	local btn2Main = self.m_layerDown:getChildByName("btn_main")
	btn2Main:setGlobalZOrder(l_tbGlobalZOrder.TOUCH_BUTTON_SPEED)
	local fn2Main = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("btn main ... ");
			-- 指引战斗没有走logic管理
			local nFightType = self:GetFightType();
			if nFightType == l_tbFightType.T_USERGUIDE then
				self:runAction(cc.RemoveSelf:create());
			else
				FightViewLogic:getInstance():closeLayer();
			end
		end
	end
	btn2Main:addTouchEventListener(fn2Main);

	--下拉菜单
	self.m_setting = self.m_Layout:getChildByName("btn_setting")
	self.m_btnList = ccui.Helper:seekWidgetByName(self.m_setting, "pnl_btnlist")
	local settingEvent = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then		
			self.m_setting:setTouchEnabled(false)
			local tAction = {}
			if self.m_btnList:getPositionY() == l_tbFightSetting.nOriY then
				table.insert(tAction, cc.MoveTo:create(l_tbFightSetting.nTime, cc.p(self.m_btnList:getPositionX(), l_tbFightSetting.nY)))
			else
				table.insert(tAction, cc.MoveTo:create(l_tbFightSetting.nTime, cc.p(self.m_btnList:getPositionX(), l_tbFightSetting.nOriY)))
			end
			table.insert(tAction, cc.CallFunc:create(function()
				self.m_setting:setTouchEnabled(true)
			end))
			self.m_btnList:runAction(cc.Sequence:create(tAction))
		end
	end
	self.m_setting:addTouchEventListener(settingEvent)
	-- 按钮：战斗统计
	local btnStatistics = self.m_btnList:getChildByName("btn_mail")
	btnStatistics:setGlobalZOrder(l_tbGlobalZOrder.TOUCH_BUTTON_SPEED);
	local fnStatistics = function(sender, eventType) 
		if eventType == ccui.TouchEventType.ended then
			local nGold, nExp, nAP, tbItems, tbEquips = me:GetAfkStatistics();
			KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():UpdateData(nGold, nExp, nAP, tbItems, tbEquips);
		end
	end
	btnStatistics:addTouchEventListener(fnStatistics)
	
	-- 增加奖励进度@2015/11/11
	local pnlRewardMore = self.m_Layout:getChildByName("pnl_reward_more");
	self.m_rewardBar = ccui.Helper:seekWidgetByName(pnlRewardMore, "bar_progess")
	self.m_rewardLabel = ccui.Helper:seekWidgetByName(pnlRewardMore, "lbl_reward")
	-- pnlRewardMore:setTouchEnabled(false);
	pnlRewardMore:setLocalZOrder(l_tbLocalZOrder.PNL_REWARD_MORE);
	local fnGetReward = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.m_canGetReward then
				--获取奖励
				self:GetRewardMore();	
			else
				--弹出奖励tips
				self:setStateCheckZOrder(true)
				self:AddSubLayer(FightCageLayer.new(me:GetCurrentAfkPoint()))				
			end			
		end
	end
	pnlRewardMore:addTouchEventListener(fnGetReward);
	
	-- 第一次加载
	self:LoadHeroPanel()

	--创建主按钮
    self.m_pMainBtnLayer = MainButtonLayer:create(false, true)
	self:AddSubLayer(self.m_pMainBtnLayer)

	--切换相关ui
	local pnlFightText = self.m_Layout:getChildByName("pnl_fight_text")
	pnlFightText:setLocalZOrder(l_tbLocalZOrder.PNL_TAB)
	self.m_leftBtn = pnlFightText:getChildByName("btn_left")
	self.m_leftBtn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:switchTab(-1)	
		end		
	end)
	self.m_rightBtn = pnlFightText:getChildByName("btn_right")
	self.m_rightBtn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:switchTab(1)	
		end
	end)
	local function tabEvent(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local nNextTab = 0
			if sender == self.m_markChat then
				nNextTab = TABTYPE.CHAT
			elseif sender == self.m_markCard then
				nNextTab = TABTYPE.CARD
			elseif sender == self.m_markTxt then
				nNextTab = TABTYPE.RECORD
			end
			local nDir = nNextTab - self.m_tabShow
			if nDir < -1 then
				nDir = 1
			elseif nDir > 1 then
				nDir = -1
			end
			self:switchTab(nDir)
		end
	end
	self.m_markChat = pnlFightText:getChildByName("pnl_chat")
	self.m_markChat:addTouchEventListener(tabEvent)
	self.m_markCard = pnlFightText:getChildByName("pnl_card")
	self.m_markCard:addTouchEventListener(tabEvent)
	self.m_markTxt = pnlFightText:getChildByName("pnl_txt")
	self.m_markTxt:addTouchEventListener(tabEvent)
	self.m_pnlTab = pnlFightText:getChildByName("pnl_ui")	

	--创建聊天层
	self.m_chatLayer = FightChatLayer:create()
	self.m_chatLayer:setPositionX(-self.m_pnlTab:getContentSize().width)
	self.m_chatLayer:setPositionY(-152)
	self.m_pnlTab:addChild(self.m_chatLayer)
	self.m_chatLayer:setVisible(false)

	--创建牌层
	self.m_cardLayer = FightCardLayer:create(self:GetLayerID())
	self.m_cardLayer:setPositionY(-152)
	self.m_pnlTab:addChild(self.m_cardLayer)	

	--创建信息层
	self.m_pRecord = FightRecordLayer:create()
	self.m_pRecord:setPositionX(-self.m_pnlTab:getContentSize().width)
	self.m_pRecord:setPositionY(-152)
	self.m_pnlTab:addChild(self.m_pRecord)	
	self.m_pRecord:setVisible(false)

	self.m_tabShow = TABTYPE.CARD
	self:ShowMark()

	self.m_skipBtn = ccui.Helper:seekWidgetByName(self.m_Layout, "btn_skip")
	self.m_skipBtn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:Over()		
			local nBoxID = me:RandomMonsterBoxID();
			-- 接下来一场
			self:SearchAndFight(os.time(), nBoxID);
		end
	end)

	self.m_testEffectPnl = ccs.GUIReader:getInstance():widgetFromJsonFile("res/fight_effect.json")
	self:addChild(self.m_testEffectPnl)
	self.m_testEffectPnl:setLocalZOrder(1000)
	self.m_testEffectPnl:setVisible(false)
	function testEffect(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local nEffID = tonumber(ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_id"):getChildByName("txt_id"):getStringValue())
			local nEffectScale = tonumber(ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_scale"):getChildByName("txt_id"):getStringValue())
			local nEffectPosType = tonumber(ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_position"):getChildByName("txt_id"):getStringValue())			
			local nType = tonumber(ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_start"):getChildByName("txt_id"):getStringValue())
			local nEffectBone = ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "lbl_bones"):getChildByName("txt_id"):getStringValue()
			local arm = self:GetUIHeroInfo(nType, 5).pCharacter:GetArm()
			-- 受击特效放在特效层(在人物上面)
			local nodeEffect = self:GetEffectPanel();
			local nDefaultScale = 1;
			local nLayerID = self:GetLayerID();		-- for 特效
			local effect = af_BindEffect2Node(nodeEffect, nEffID, nil, nDefaultScale, nil, {nil, nil, nLayerID})
			local function onMoveEvent(armatureBack, movementType, movementID)
				if movementType == ccs.MovementEventType.complete then
					effect:runAction(cc.RemoveSelf:create())
				end
			end
			if effect then
				effect:getAnimation():setMovementEventCallFunc(onMoveEvent)
			end
			-- 设置属性	
			local ref = self:GetEffectRefPanel(nType, nType, 5, nEffectPosType)
			local parent = self:GetEffectPanel();
			self:SetEffectScale(nType, effect, parent, ref, arm, nEffectScale)
			self:SetEffectPosition(nType, effect, parent, ref, arm, nEffectBone)	
		end
	end
	ccui.Helper:seekWidgetByName(self.m_testEffectPnl, "btn_test"):addTouchEventListener(testEffect)
	
	return self;
end

--切换页面
--nDir：-1，向左；1，向右
function KG_UIFight:switchTab(nDir)	
	if self.m_tabRunning then
		return
	end
	local function getTabLayer(eShowType)
		if eShowType == TABTYPE.CHAT then
			return self.m_chatLayer
		elseif eShowType == TABTYPE.CARD then
			return self.m_cardLayer
		elseif eShowType == TABTYPE.RECORD then
			return self.m_pRecord
		end
	end
	local nowLayer = getTabLayer(self.m_tabShow)
	self.m_tabShow = self.m_tabShow + nDir
	if self.m_tabShow <= 0 then
		self.m_tabShow = TABTYPE.RECORD
	elseif self.m_tabShow >= 4 then
		self.m_tabShow = TABTYPE.CHAT
	end
	local nextLayer = getTabLayer(self.m_tabShow)	
	local nWidth = self.m_pnlTab:getContentSize().width
	local nMoveT = 0.2
	nextLayer:setPositionX(nWidth * -nDir)
	nextLayer:setVisible(true)
	self.m_tabRunning = true	
	nowLayer:runAction(cc.Sequence:create(cc.MoveBy:create(nMoveT, cc.p(nWidth * nDir, 0)), cc.Hide:create()))
	nextLayer:runAction(cc.Sequence:create(cc.MoveBy:create(nMoveT, cc.p(nWidth * nDir, 0)), 
		cc.CallFunc:create(function()
			self.m_tabRunning = false
			self:ShowMark()
			if self.m_tabShow == TABTYPE.RECORD then
				self.m_pRecord:RefreshText()
			end
		end)))
end

--显示标记
function KG_UIFight:ShowMark()
	local upChat = self.m_markChat:getChildByName("img_up")
	upChat:setVisible(false)
	local downChat = self.m_markChat:getChildByName("img_down")
	downChat:setVisible(true)
	local upCard = self.m_markCard:getChildByName("img_up")
	upCard:setVisible(false)
	local downCard = self.m_markCard:getChildByName("img_down")
	downCard:setVisible(true)
	local upTxt = self.m_markTxt:getChildByName("img_up")
	upTxt:setVisible(false)
	local downTxt = self.m_markTxt:getChildByName("img_down")
	downTxt:setVisible(true)
	if self.m_tabShow == TABTYPE.CHAT then
		upChat:setVisible(true)
		downChat:setVisible(false)
	elseif self.m_tabShow == TABTYPE.CARD then
		upCard:setVisible(true)
		downCard:setVisible(false)
	elseif self.m_tabShow == TABTYPE.RECORD then
		upTxt:setVisible(true)
		downTxt:setVisible(false)
	end
end

--@function: 把角色UI先加载进来
--@注意：studio的控件引用计数是2, 最后没有释放掉内存
function KG_UIFight:LoadHeroPanel()		
	for nCamp = 1, 2 do
		local szPanel = "pnl_ship_" .. nCamp
		local pnlShip = ccui.Helper:seekWidgetByName(self.m_Layout, szPanel)
		if not pnlShip then
			cclog("[Error]没有找到pnl_ship_(%s)控件@LoadHeroPanel", szPanel)
			return;
		end
		for nPos = 1, 6 do						
			local szPnlHero = "pnl_hero_" .. nPos
			local pnlNode = pnlShip:getChildByName(szPnlHero)
			pnlHero = pnlNode:getChildByName("anipnl")
			
			if pnlHero then
				pnlHero:setVisible(true);
			end
			local pCharacter = FightCharacter:create(nCamp, nPos)
			pnlHero:addChild(pCharacter);

			--战斗界面角色面板比例调整
			local nodeSize = pCharacter:GetRootNode():getContentSize();
			local pnlHeroSize = pnlHero:getContentSize();
			local scale = pnlHeroSize.width/nodeSize.width;
			pCharacter:setScale(scale)
					
			-- 保存所有英雄节点的初始位置和大小
			local x, y = pnlHero:getPosition();
			local nScale = pnlHero:getScale();

			self:SetUIHeroInfo(nCamp, nPos, {x, y, nScale}, pCharacter)
		end
	end	
end

--@function: 获取当前战斗类型
function KG_UIFight:GetFightType()
	return self.m_nFightType;
end

function KG_UIFight:SetFightType(nType)
	-- 默认是挂机战斗
	self.m_nFightType = nType or l_tbFightType.T_AFKER;
end
---------------------------------------------------------------------------------------
--获取ui节点、数据函数
--@function: 获取战斗面板上某个位置挂载的英雄面板(role_ui.json对应的)
--@nCamp和nPos: 阵营和位置决定了唯一的位置
--@使用：和GetWidgetHero比较
function KG_UIFight:GetWidgetHero(nCamp, nPos)
	if self:IsValidCamp(nCamp) then
		local pnlHero = self:GetCharacterNode(nCamp, nPos):GetRootNode()	
		return pnlHero;
	else
		cclog("[Error]camp(%d) is not valid!@GetWidgetHero!", nCamp or 0)
	end
end

--@function: 获取战斗面板某个位置的panel
--@nCamp和nPos: 两个值决定了唯一的位置
--@使用：和GetWidgetHero比较
function KG_UIFight:GetNode(nCamp, nPos)
	nPos = nPos or 0
	if self:IsValidCamp(nCamp) then
		local pnlHero = self:GetStillNode(nCamp, nPos)
		if pnlHero then
			local nodeHero = ccui.Helper:seekWidgetByName(pnlHero, "anipnl")
			return nodeHero;
		end
		return pnlHero;
	end
end

function KG_UIFight:GetShipPanel(nCamp)
	if self:IsValidCamp(nCamp) then
		local szPanel = "pnl_ship_" .. nCamp
		local pnlShip = ccui.Helper:seekWidgetByName(self.m_Layout, szPanel)
		return pnlShip;
	end
end

--@function: 不动的那个panel, 用于静止坐标点的获取
function KG_UIFight:GetStillNode(nCamp, nPos)
	nPos = nPos or 0
	if self:IsValidCamp(nCamp) then
		local szPanel = "pnl_ship_" .. nCamp
		local pnlShip = ccui.Helper:seekWidgetByName(self.m_Layout, szPanel)
		if pnlShip then
			local szPnlHero = "pnl_hero_" .. nPos
			local pnlHero = ccui.Helper:seekWidgetByName(pnlShip, szPnlHero)
			return pnlHero;
		end
	end
end

function KG_UIFight:GetHeroId(nCamp, nPos)
	return self:GetCharacterNode(nCamp, nPos):GetHeroId()
end

--@function: 获取触发技能Mark的表示的widget(默认选择"img_statemark"的image)
function KG_UIFight:GetMarkWidget(nCamp, nPos)
	local pnlHero = self:GetWidgetHero(nCamp, nPos)
	if pnlHero then
		local widget = ccui.Helper:seekWidgetByName(pnlHero, "img_statemark")
		if widget then
			return widget;
		end
	end
end

function KG_UIFight:SetArmature(nCamp, nPos, arm)
	if not self:IsValidCamp(nCamp) then
		cclog("[Error]camp is invalid!")
		return false;
	end
	if not self.m_tHeroNode[nCamp] then
		self.m_tHeroNode[nCamp] = {}
	end
	if not gf_IsValidPos(nPos) then
		cclog("[Error]position is invalid!@SetArmature")
		return false;
	end
	
	-- 旧的删掉
	local old = self.m_tHeroNode[nCamp][nPos].armature
	if old then
		print("删除旧的骨骼...")
		old:runAction(cc.RemoveSelf:create())
	end
	self.m_tHeroNode[nCamp][nPos].armature = arm;
end

function KG_UIFight:GetEffectPanel()
	return self.m_pnlEffect;
end

function KG_UIFight:GetEffectShipPanel(nCamp)
	print("[Log]GetEffectShipPanel", nCamp);
	if self:IsValidCamp(nCamp) then
		local panel = self:GetEffectPanel()
		if panel then
			local szName = "pnl_ship_effect_" .. nCamp;
			local pnlShip = panel:getChildByName(szName)
			return pnlShip
		end
	end
end
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--ui控制类函数
--更新聊天
function KG_UIFight:UpdateChatMessage(nCamp, nType, szName, szMsg)
	if self.m_chatLayer then
		self.m_chatLayer:UpdateMessage(nCamp, nType, szName, szMsg)
	end
end

function KG_UIFight:ChangePanelOrder(nCamp)
	local nCamp = nCamp or l_tbCamp.MINE;
	local pnlShip = self:GetShipPanel(nCamp)
	local pnlShip2 = self:GetShipPanel( 3 - nCamp)
	if pnlShip and pnlShip2 then
		pnlShip:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_HIGHER)
		pnlShip2:setLocalZOrder(l_tbLocalZOrder.DEFAULT)
	end
end

function KG_UIFight:IsValidCamp(nCamp)
	if nCamp == l_tbCamp.MINE or nCamp == l_tbCamp.ENEMY then
		return true;
	end
	
	cclog("[Error]camp(%d) is not valid!@IsValidCamp!", nCamp or 0)
	return false;
end

--重置状态按钮的GlobalZOrder，防止2级界面上的点击被屏蔽
function KG_UIFight:setStateCheckZOrder(bReset)		
	if self.m_tbNode2Npc then
		self.m_bReseting = bReset
		local pnlState = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_state")
		for btnNode, _ in pairs(self.m_tbNode2Npc) do
			if bReset then
				btnNode:setGlobalZOrder(0)
				pnlState:setGlobalZOrder(0)
			else
				btnNode:setGlobalZOrder(l_tbGlobalZOrder.TOUCH_BUTTON_NPC)
				pnlState:setGlobalZOrder(l_tbGlobalZOrder.TOUCH_BUTTON_NPC)
			end
		end
	end
end

--@function: 设置战斗界面中离开事件是否启用
function KG_UIFight:SetLeaveTouchEnabled(bEnable)
	print("[log]设置退出战斗界面按钮是否可用", bEnable);
	local bEnable = bEnable or false;	
	
	-- 首页
	local btn2Main = self.m_layerDown:getChildByName("btn_main")
	btn2Main:setEnabled(bEnable);

	self.m_pMainBtnLayer:SetCanLeave(bEnable)
end

--@function: 随机战斗背景图
function KG_UIFight:RandomBgImage(nBoxID)
	local tbPics = KGC_PLAYER_FACTORY_TYPE:getInstance():GetFightBg(nBoxID);
	if not tbPics then
		return;
	end	
	local nRandom = math.random(#tbPics);
	local nPicID = tbPics[nRandom] or 102;
	local szImage1, szImage2, szImage3 = l_tbBgImageConfig[nPicID].Pic1, l_tbBgImageConfig[nPicID].Pic2, l_tbBgImageConfig[nPicID].Pic3
	print("[log]随机战斗背景", nPicID);
	local pnlBg = self.m_Layout:getChildByName("pnl_bg");
	local img1 = pnlBg:getChildByName("img_1");
	img1:loadTexture(szImage1);
	local img2 = pnlBg:getChildByName("img_2");
	img2:loadTexture(szImage2);
	local img3 = pnlBg:getChildByName("img_3");
	img3:loadTexture(szImage3);
end

--@function: 处理战斗界面功能按钮状态
function KG_UIFight:ProcessButtonState()
	local pnlRewardMore = self.m_Layout:getChildByName("pnl_reward_more");
	local nFightType = self:GetFightType();
	if nFightType ~= l_tbFightType.T_AFKER then
		self:SetLeaveTouchEnabled(false);
		pnlRewardMore:setVisible(false);
		return;
	end
	self:SetLeaveTouchEnabled(true);
	
	-- 等级控制
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_MAIN) then
		self:SetLeaveTouchEnabled(true);
	else
		self:SetLeaveTouchEnabled(false);
	end	
end

--@function: 更新进度奖励
function KG_UIFight:UpdateRewardMore(nCount, nStep)
	local nCount = nCount or 0;
	local nStep = nStep or 1;
	local pnlRewardMore = self.m_Layout:getChildByName("pnl_reward_more");
	local pnlMonsterInfo = pnlRewardMore:getChildByName("pnl_monster_info");
	-- local lblNum = pnlMonsterInfo:getChildByName("lbl_reward");
	
	-- 非挂机战斗不显示进度宝箱
	local nFightType = self:GetFightType();
	if nFightType ~= l_tbFightType.T_AFKER then
		pnlRewardMore:setVisible(false);
		return;
	end
	
	local nAfkerPoint = me:GetCurrentAfkPoint();
	local tbConfig = (l_tbAfkConfig[nAfkerPoint] or {}).Score or {};
	local nNeedMonster = tbConfig[nStep] or 0;
	if not tbConfig[nStep] then
		cclog("[Log]阶段奖励已经取完了，不再显示!");
		pnlRewardMore:setVisible(false);
		return;
	end
	pnlRewardMore:setVisible(true);
	
	--设置进度
	self.m_rewardBar:setPercent(nCount * 100 / nNeedMonster)
	-- self.m_rewardLabel:setString(string.format("%d/%d", nCount, nNeedMonster))
	
	local nLeft = (nNeedMonster - nCount) > 0 and (nNeedMonster - nCount) or 0;
	print("UpdateRewardMore", l_tbAfkConfig[nAfkerPoint], nAfkerPoint, nCount, nStep, nNeedMonster, nLeft);
	self.m_rewardLabel:setString(nLeft);
	if nLeft <= 0 then
		-- pnlRewardMore:setTouchEnabled(true);
		self.m_canGetReward = true
		-- pnlMonsterInfo:setVisible(false);
		self.m_actionRewardMore = self:PlayUIAction("fight.json", "rewardcage");
		-- 最后一个参数保证循环播放
		if not self.m_effectRewardMore then
			local nLayerID = self:GetLayerID();		-- for 特效
			self.m_effectRewardMore = af_BindEffect2Node(pnlRewardMore, 60067, {nil, -1}, 1, nil, {nil, 1, nLayerID});
		end
	else
		-- pnlRewardMore:setTouchEnabled(false);
		self.m_canGetReward = false
		pnlMonsterInfo:setVisible(true);
		
		if self.m_actionRewardMore then
			self.m_actionRewardMore:stop();
		end
		
		if self.m_effectRewardMore then
			self.m_effectRewardMore:removeFromParent(true);
			self.m_effectRewardMore = nil;
		end
	end
end

--@function: 播放奖励动画
function KG_UIFight:PlayRewardAnimation(fnCallBack)
	local sprite = cc.Sprite:create("res/ui/05_mainUI/05_ico_main_btn_02.png");
	sprite:setPosition(cc.p(400, 1000));
	self:addChild(sprite);
	local moveBy = cc.MoveBy:create(1, cc.p(500, 100));
	local scaleBy = cc.ScaleTo:create(1, 0.3);
	local spawn = cc.Spawn:create(moveBy, scaleBy);
	local fnCall = function()
		sprite:removeFromParent();
		if fnCallBack then
			fnCallBack();
		end
	end
	local action = cc.Sequence:create(spawn, cc.CallFunc:create(fnCall));
	sprite:runAction(action);
end

function KG_UIFight:SetPlayerInfoVisible(bVisble)
	self.m_Layout:getChildByName("pnl_playerinfo"):setVisible(bVisble)
	self:setStateCheckZOrder(bVisble)
	--设置血条层级
	if bVisble then
		self.m_layerUp:setLocalZOrder(0)
		self.m_layerDown:setLocalZOrder(0)
	else
		self.m_layerUp:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_HP)
		self.m_layerDown:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_HP)
	end
end

function KG_UIFight:UpdateMoneyData()
	local nAP = me:GetAP();
	local nGold = me:GetGold();
	local nDiamond = me:GetDiamond();
	local nLevel = me:GetLevel();
	local nVIP = me:GetVIP();
	local nExp = me:GetExp()
	local nLevelUpExp = me:GetLevelUpExp();
	local szExp = nExp .. "/" .. nLevelUpExp;
	local nPercent = nExp / nLevelUpExp * 100;
	local nFightPoint = me:GetFightPoint();

	if nPercent < 0 then
		nPercent = 0;
	elseif nPercent > 100 then
		nPercent = 100;
	end
	
	if nPercent ~= self.m_BarExp:getPercent() then 
		local EffectNode1 = af_GetEffectByID(60044);
		self.m_BarExp:addChild(EffectNode1);
	end

	if nGold ~= tonumber(self.m_BmpGold:getString()) then 
		local EffectNode1 = af_GetEffectByID(60042);
		EffectNode1:setPositionY(25)
		EffectNode1:setPositionX(0)
		self.m_BmpGold:addChild(EffectNode1);
	end
	
	self.m_BmpStep:setString(tostring(nAP))
	self.m_BmpLevel:setString(tostring(nLevel))
	self.m_BmpVIP:setString(tostring(nVIP))
	self.m_BmpDiamond:setString(tostring(nDiamond));
	self.m_BmpExp:setString(szExp)
	self.m_BarExp:setPercent(nPercent);
	self.m_BmpFightPoint:setString(nFightPoint);

	lableNumAnimation(self.m_BmpGold,nil,nGold,1);
end
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--英雄、怪物创建加载相关函数
function KG_UIFight:SetUIHeroInfo(nCamp, nPos, tPosData, pCharacter)
	self.m_tHeroNode = self.m_tHeroNode or {}
	self.m_tHeroNode[nCamp] = self.m_tHeroNode[nCamp] or {}
	self.m_tHeroNode[nCamp][nPos] = {["tPosData"] = tPosData, ["pCharacter"] = pCharacter}
end

function KG_UIFight:GetUIHeroInfo(nCamp, nPos)
	return self.m_tHeroNode[nCamp][nPos]
end

function KG_UIFight:GetCharacterNode(nCamp, nPos)
	return self:GetUIHeroInfo(nCamp, nPos).pCharacter
end

--加载NPC模型包括英雄和怪物
--@fighter: fighter创建的战斗需要的对象
function KG_UIFight:LoadNpc(fighter, nCamp)
	-- 用战斗数据解析
	if not fighter then
		cclog("[Error]战斗数据错误!@LoadNpc");
		return;
	end

	-- 出场位置
	local tPlayId = {}	--记录玩家id
	for i = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT do
		local npc = fighter[i];
		if npc then
			table.insert(tPlayId, npc.id)
			local nPos = i;
			local nHeroId = npc.id;
			self:LoadHeroById(nHeroId, nCamp, nPos)
		else
			self:GetCharacterNode(nCamp, i):RemoveHeroArm()
		end
	end
		
	--加载玩家图片，血条显示
	local pnlRole
	if nCamp == l_tbCamp.MINE then
		pnlRole = self.m_layerDown:getChildByName("pnl_role")
		pnlRole:setVisible(true)
		self.m_selfCurHp = fighter.MaxHP
	else
		self.m_layerUp:getChildByName("pnl_role1"):setVisible(false)
		self.m_layerUp:getChildByName("pnl_role2"):setVisible(false)
		if #tPlayId == 1 then 	--怪物只有一只时候才显示单条			
			pnlRole = self.m_layerUp:getChildByName("pnl_role2")
		else
			pnlRole = self.m_layerUp:getChildByName("pnl_role1")
		end
		pnlRole:setVisible(true)
		self.m_enemyCurHp = fighter.MaxHP
	end
	for i = 1, 3 do
		local playerImgBg = ccui.Helper:seekWidgetByName(pnlRole, "img_headback" .. i)
		if playerImgBg then
			local playerImg = ccui.Helper:seekWidgetByName(playerImgBg, "img_head")
			if tPlayId[i] then			
				playerImg:setVisible(true)
				if l_tbMonsterConfig[tPlayId[i]] then
					playerImg:loadTexture(l_tbNpcModels[l_tbMonsterConfig[tPlayId[i]].modelid].img_fight)
				elseif l_tbCharacterConfig[tPlayId[i]] then
					playerImg:loadTexture(l_tbNpcModels[l_tbCharacterConfig[tPlayId[i]].modelid].img_fight)
				end
			else
				playerImg:setVisible(false)
			end
		end
	end
	local HPLabel = ccui.Helper:seekWidgetByName(pnlRole, "lbl_hpnum")	
	local proHP = ccui.Helper:seekWidgetByName(pnlRole, "health_full")
	local proHP2 = ccui.Helper:seekWidgetByName(pnlRole, "health_empty")
	HPLabel:setString(fighter.MaxHP .. "/" .. fighter.MaxHP)
	proHP:setPercent(100)
	proHP2:stopAllActions()
	proHP2:setPercent(100)

	self.m_selfCurHp = self.m_selfCurHp or 0
	self.m_enemyCurHp = self.m_enemyCurHp or 0
	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_FIGHTHP, {self.m_selfCurHp, self.m_enemyCurHp})
end

function KG_UIFight:touchFunc(nCamp, nPos, nHeroId)
	local pnlState = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_state");
	local svState = pnlState:getChildByName("scrollview_stateinfo")
	local imgStateBg = pnlState:getChildByName("img_statebg")
	local pnlCoverState = pnlState:getChildByName("pnl_cover_state");
	imgStateBg:setVisible(true)
	svState:setVisible(true)
	pnlCoverState:setVisible(true)
	--page@2016/01/22 隐藏
	pnlState:setVisible(false);
	pnlState:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_STATE)
end

--根据英雄id加载英雄模型
function KG_UIFight:LoadHeroById(nHeroId, nCamp, nPos)			
	local pCharacter = self:GetCharacterNode(nCamp, nPos) 
	local bIsAppear, nEffectID = pCharacter:LoadHeroById(nHeroId, handler(self, self.touchFunc))	
	if bIsAppear then
		local pnlNode = self:GetStillNode(nCamp, nPos)
		pnlHero = ccui.Helper:seekWidgetByName(pnlNode, "anipnl")
		local effect = af_BindEffect2Node(pnlHero, nEffectID, nil, nil, nil, {nil, nil, self:GetLayerID()})
	end		
end

function KG_UIFight:ResetHero()
	for nCamp = 1, 2 do
		for nPos = 1, 6 do
			-- 恢复anipnl的初始位置和大小
			local nodeInfo = self:GetUIHeroInfo(nCamp, nPos)
			local pnlHero = nodeInfo.pCharacter:getParent();
			local tbData = nodeInfo.tPosData or {};
			local x, y, nScale = unpack(tbData);
			if pnlHero and x and y and nScale then
				pnlHero:setPosition(cc.p(x, y));
				pnlHero:setScale(nScale);
			end	
			if nCamp == 1 and nPos >= 4 and nPos <= 6 then
				--暂时不清楚己方英雄
				if nodeInfo then
					nodeInfo.pCharacter:ResetState()
				end
			else				
				if nodeInfo then													
					nodeInfo.pCharacter:RemoveHeroArm()
				end				
			end			
		end
	end	
end

function KG_UIFight:IsBloodShare(nPos)
	if gf_IsValidPos(nPos) then
		if nPos >= 1 and nPos <= 3 then
			return false
		else
			return true
		end
	else
		cclog("[Error]position is invalid!")
	end
end
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--配置表获取相关函数
function KG_UIFight:IsHero(nId)
	if l_tbCharacterConfig[nId] then
		return true
	else
		return false
	end
end

function KG_UIFight:GetNameById(nId)
	if l_tbCharacterConfig[nId] then
		return l_tbCharacterConfig[nId].name
	elseif l_tbMonsterConfig[nId] then
		return l_tbMonsterConfig[nId].name
	end
end

function KG_UIFight:GetEffectTypeById(nSkillId)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	if tSkillInfo then
		local tSkillResultInfo = l_tbSkillResultConfig[tSkillInfo.skillresultsid]
		if tSkillResultInfo then
			return tSkillResultInfo.effecttype
		end
	end
end
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--ui辅助类函数
--@function: 插入一个播报到战斗界面中
--@szHead: 头标识
--@tbTexts: 播报内容
--@nCamp: 阵营-头标识显示在左边还是右边
--@bFlag: 是否显示头(长度还是根据前面szHead确定), 默认显示
function KG_UIFight:InsertText(szHead, tbTexts, nCamp, bFlag)
	self.m_pRecord:InsertText(szHead, tbTexts, nCamp, bFlag)
end

function KG_UIFight:RefreshText()
	self.m_pRecord:RefreshText()
end

--@function: 插入系统播报
--@nType: 区分不同的播报类型, eg: 1000-奖励
function KG_UIFight:InsertSystemText(nType, tbArg)
	self.m_pRecord:InsertSystemText(nType, tbArg)
end

function KG_UIFight:setPlaySpeed()
	local img_icon = self.btn_double:getChildByName("doubleicon")
	if self.m_nCurrentSpeed ==1 then
		cc.Director:getInstance():getScheduler():setTimeScale(2)
		self.m_nCurrentSpeed =   2
		img_icon:loadTexture(CUI_PATH_SPEED_2)
	elseif self.m_nCurrentSpeed ==2 then
		cc.Director:getInstance():getScheduler():setTimeScale(1)
		self.m_nCurrentSpeed = 1
		img_icon:loadTexture(CUI_PATH_SPEED_1)
	end
end

function KG_UIFight:GetPlaySpeed()
	return self.m_nCurrentSpeed;
end

--显示遮罩
function KG_UIFight:ShowCover(nCamp, nPos)
	local nZOrder = l_tbLocalZOrder.PNL_SHIP_MASK;
	local nZOrder1 = l_tbLocalZOrder.PNL_SHIP_NPC;
	local pnlShip = self:GetShipPanel(nCamp)
	
	--先把ship panel的层级关系调整一下
	self:ChangePanelOrder(nCamp);
	
	if pnlShip then
		local pnlCover = pnlShip:getChildByName("pnl_cover")
		if pnlCover then
			pnlCover:setVisible(true)
			--直接pnlShip:getChildByName()会好点，但是接口就乱了
			local pnlHero = self:GetStillNode(nCamp, nPos);
			pnlCover:setLocalZOrder(nZOrder)
			
			if pnlHero then
				pnlHero:setLocalZOrder(nZOrder1)
			end
			
			local szName = "pnl_skillname_" .. nCamp
			local pnlSkill = pnlShip:getChildByName(szName)
			if pnlSkill then
				pnlSkill:setLocalZOrder(nZOrder1)
			end
		end
	else
		--显示全部遮罩
		for nCamp in pairs(l_tbCamp) do
			local pnlShip = self:GetShipPanel(l_tbCamp.MINE)
			if pnlShip then
				local pnlCover = pnlShip:getChildByName("pnl_cover")
				pnlCover:setVisible(true)
				pnlCover:setLocalZOrder(nZOrder)
			end
		end
	end
end

function KG_UIFight:HideCover(nCamp, nPos)
	local nZOrder = 0;
	local pnlShip = self:GetShipPanel(nCamp)
	if pnlShip then
		local pnlCover = pnlShip:getChildByName("pnl_cover")
		if pnlCover then
			pnlCover:setVisible(false)
			--直接pnlShip:getChildByName()会好点，但是接口就乱了
			local pnlHero = self:GetStillNode(nCamp, nPos);
			pnlHero:setLocalZOrder(nZOrder)
			
			local szName = "pnl_skillname_" .. nCamp
			local pnlSkill = pnlShip:getChildByName(szName)
			if pnlSkill then
				pnlSkill:setLocalZOrder(nZOrder)
			end
		end
	end
end

function KG_UIFight:RandomPlaceByPoint(nCamp, nPos, fnCall)
	local nZOrder = l_tbLocalZOrder.PNL_SHIP_NPC;
	--配置表
	local tbConfig = mconfig.loadConfig("script/cfg/client/action/skillrandom")
	
	--根据panel的大小设置随机图的大小
	local fnSetScale = function(node1, node2)
		local size1 = node1:getContentSize();
		local size2 = node2:getContentSize();
		local nScale = size1.width / size2.width;
		if size2.width == 0 then
			nScale = 1;
		end
		node2:setScale(nScale * 1.2)
	end
	local sprite = cc.Sprite:create(CUI_PATH_EFFECT_SKILL_RANDOM);
	local nSrc, nDst = unpack(tbConfig.tbRandomAlpha)
	sprite:setBlendFunc(nSrc, nDst);	--gl.BLEND_SRC_ALPHA
	sprite:setVisible(false)
	local target = self:GetStillNode(nCamp, nPos)
	fnSetScale(target, sprite)

	--需求：开始之前所有英雄都要亮起来
	local tbNodes = {}
	local tbSprites = {}
	for i = l_tbPos.POS_4, l_tbPos.POS_6 do
		local node = self:GetStillNode(nCamp, i)
		if node then
			local spriteAlpha = cc.Sprite:create(CUI_PATH_EFFECT_SKILL_RANDOM);
			local size = node:getContentSize();
			spriteAlpha:setPosition(cc.p(size.width/2, size.height/2))
			fnSetScale(node, spriteAlpha)
			local nSrc, nDst = unpack(tbConfig.tbStartAlpha)
			spriteAlpha:setBlendFunc(nSrc, nDst);
			table.insert(tbSprites, spriteAlpha)
			node:addChild(spriteAlpha)
			node:setLocalZOrder(nZOrder + 1)
	
			table.insert(tbNodes, node);
		end
	end
	if #tbNodes <= 0 then
		return false;
	end
	
	local pnlShip = self:GetShipPanel(nCamp)
	pnlShip:addChild(sprite)
	
	--开始随机之后删除全部都亮的精灵
	local callAlphaRemove = function()
		sprite:setVisible(true)
		for k, v in pairs(tbSprites) do
			v:removeFromParent(true)
		end

	end
	
	--随机完之后删除
	local call = function()
		-- print("[延时]随机特效播放完毕 ..........................")
		sprite:removeFromParent(true);
		fnCall();
	end
	
	--随机完之后，在随机到的英雄身上加亮光，持续一段时间
	local callAlphaFind = function()
		for k, v in pairs(tbNodes) do
			v:setLocalZOrder(0)
		end
		
		local posTarX, posTarY = target:getPosition();
		local sizeTar = target:getContentSize();
		fnSetScale(target, sprite)
		sprite:setPosition(posTarX + sizeTar.width/2, posTarY + sizeTar.height/2)
		local nSrc, nDst = unpack(tbConfig.tbEndAlpha)
		sprite:setBlendFunc(nSrc, nDst)
		target:setLocalZOrder(nZOrder + 1)
	end

	local action = cc.EaseExponentialOut:create(cc.PlaceByPoint:create(tbConfig.nDuration, tbNodes, nPos-3, tbConfig.nPeroid))
	sprite:runAction(cc.Sequence:create(cc.DelayTime:create(tbConfig.nDelayTimeStart), 
		cc.CallFunc:create(callAlphaRemove),
		action, 
		cc.CallFunc:create(callAlphaFind),
		cc.DelayTime:create(tbConfig.nDelayTimeEnd),
		cc.CallFunc:create(call)))
end

--@function:
--@src: 上一个技能的相关信息
function KG_UIFight:PlayEffect(nID, tbArg, fnCallBack)
	local nLayerID = self:GetLayerID();			-- for 特效
	
	if nID == 1 then			--连携
		local nCamp, nPos, tHeroId, nLastPos = unpack(tbArg)
		if not nCamp or not nPos then
			return
		end
		local fnCombo = function() 
			local pnlCombo = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_combo")
			pnlCombo:setVisible(true)
			pnlCombo:setLocalZOrder(l_tbLocalZOrder.PNL_SHIP_NPC)	--在遮罩上面
			
			-- 眼睛资源换掉
			local imgDstEye = pnlCombo:getChildByName("img_selfeye")
			local imgSrcEye = pnlCombo:getChildByName("img_comboeye")
			local nSrcHeroId, nDstHeroId = tHeroId[1], tHeroId[2]	
			imgSrcEye:loadTexture(l_tbNpcModels[l_tbCharacterConfig[nSrcHeroId].modelid].icon_parallelogram)		
			imgDstEye:loadTexture(l_tbNpcModels[l_tbCharacterConfig[nDstHeroId].modelid].icon_parallelogram)
			
			local fnCall = function()
				pnlCombo:setVisible(false)
				pnlCombo:setLocalZOrder(l_tbLocalZOrder.DEFAULT)
				
				if fnCallBack then
					fnCallBack()
				end
				
				local node = self:GetStillNode(nCamp, nPos)
				af_BindEffect2Node(node, 60005, {nil, 1}, 1, nil, {nil, nil, nLayerID});
			end
			self:PlayUIAction("fight.json", "combo_eyes", cc.CallFunc:create(fnCall))
			--连携特效
			local node = self:GetStillNode(nCamp, nPos)
			local effect = af_BindEffect2Node(self.m_Layout, 60004, {nil, 100}, 1, nil, {nil, nil, nLayerID})
			local tbPos = l_tbEffectDecoration[1000].position
			effect:setPosition(cc.p(unpack(tbPos)))
		end
		
		--连携触发英雄
		nodeSrc = self:GetStillNode(nCamp, nLastPos)
		if nodeSrc then
			af_BindEffect2Node(nodeSrc, 60005, {nil, 1}, 1, nil, {nil, nil, nLayerID})
			fnCombo()
		else
			fnCombo()
		end
	elseif nID == 2 then		-- 合作技能
		local tbRes = tbArg;
		local imgHero1 = self.m_pnlCombo:getChildByName("img_unite01")
		local imgHero2 = self.m_pnlCombo:getChildByName("img_unite02")
		imgHero1:loadTexture(tbRes[1])
		imgHero2:loadTexture(tbRes[2])
		self.m_pnlCombo:setVisible(true)
		self.m_pnlCombo:setLocalZOrder(1)
		local fnCall = function()
			self.m_pnlCombo:setVisible(false)
		end
		self:PlayUIAction("fight.json", "untest", cc.CallFunc:create(fnCall))
	else
		if fnCallBack then
			fnCallBack()
		end
	end
end

function KG_UIFight:StartSpeed()
	TipsViewLogic:getInstance():addMessageTips(30000);
end

function KG_UIFight:OpenChat()
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_CHAT);
end

function KG_UIFight:OpenAfkPoint()
	TipsViewLogic:getInstance():addMessageTips(30000);
end

--@function: 英雄升级
function KG_UIFight:UpdateLevel(nPos)
	-- 升级玩家角色
	self:GetUIHeroInfo(l_tbCamp.MINE, nPos).pCharacter:UpdateLevel(self:GetLayerID())
end

------------------------------------------------------------------------------
--战斗开始结束控制类函数
--@function: 战斗结束
--@bFoceOver: 是否是强制结束
function KG_UIFight:Over(bForceOver)
	self:ShowCover();

	self.m_layerUp:setVisible(false)
	self.m_layerDown:setVisible(false)	
	self.m_skipBtn:setVisible(false)

	--情况防守动画
	for i, v in ipairs(self.m_tDefenseEffect) do
		v:removeFromParent(true)
	end
	self.m_tDefenseEffect = {}

	self.m_cardLayer:resetSkillCard()
	
	self.m_bPVP = false
	self.m_tCommand = nil
	if self.m_protectAct then
		self:stopAction(self.m_protectAct)
		self.m_protectAct = nil
	end

	-- 关闭动画
	self:stopAllActions();
	self.m_searchMsg:stopAllActions()
	if self.m_searchScheduler then
		local scheduler = cc.Director:getInstance():getScheduler()
		scheduler:unscheduleScriptEntry(self.m_searchScheduler)
		self.m_searchScheduler = nil
	end
	
	-- 1. 处理探索界面
	local nFightType = self:GetFightType();
	if nFightType ~= l_tbFightType.T_USERGUIDE then
		self.m_pnlSearch:setVisible(true);		
	end
	
	--重置英雄,英雄骨骼置nil，位置重设
	self:ResetHero()
	
	-- 2. 处理回调函数
	if nFightType == l_tbFightType.T_CUSTOM then
		if type(self.m_fnFightOverCallBack) == "function" then
			self.m_fnFightOverCallBack();
		end
	else
		-- 挂机战斗才向服务器请求奖励(注：如果是被中断的不发送请求)
		if not bForceOver then
			FightViewLogic:getInstance():ReqFightRewardOnLine(self.m_nWinner == l_tbCamp.MINE, self.m_nHeroBoxID);
			self.m_nWinner = 0
		end
	end
	
	-- 3. 需要再动画播放完毕之后再做的事情
	local fnCallBack = function()
		if self.m_nHeroBoxID then
			FightViewLogic:getInstance():SetFightGuideStage(self.m_nHeroBoxID);
		end
	end
	
	if nFightType == l_tbFightType.T_USERGUIDE then
		self:PlayRewardAnimation(fnCallBack);
	end
	
	self:ProcessButtonState();

	-- 4. 请求当前挂机点的进度
	if nFightType == l_tbFightType.T_AFKER then
		FightViewLogic:getInstance():ReqRewardMoreCount();
	end
end

--@function: 一场战斗结束
function KG_UIFight:EndAnimation()
	local fnCallBack = function()
		self:Over()
		
		local nFightType = self:GetFightType();
		-- 非指引战斗接下来都开始挂机战斗
		if nFightType ~= l_tbFightType.T_USERGUIDE then
			local nBoxID = me:RandomMonsterBoxID();
			-- 接下来一场
			self:SearchAndFight(os.time(), nBoxID);
		end
	end
	
	local action = cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(fnCallBack));
	self:runAction(action);
end

--@function: 指引战斗
function KG_UIFight:StartGuideFight(nSeed, nHeronBoxID, nBoxID, nWinner, nRewardID, bFlag)
	print("/************************************************/")
	print("/*******************StartGuideFight*****************/")
	print("/************************************************/")

	self:SetFightType(l_tbFightType.T_USERGUIDE);
	if nHeronBoxID == 1 then
	elseif nHeronBoxID == 2 then
		self:StartSearch();
	elseif nHeronBoxID == 3 then
		self:StartSearch();
	end
	self.m_nHeroBoxID = nHeronBoxID;
	
	local tHero = fighter.createFromMonsterBox(nGuildHeroBox[self.m_nHeroBoxID])
	local tMonster = fighter.createFromMonsterBox(nBoxID)
	self.m_nMonsterID = nBoxID
	self:TestWrite(nSeed, nBoxID)
	self:StartFight(nSeed, tHero, tMonster, nWinner, nRewardID, bFlag);
end

--@function: pvp战斗
--@bFlag: 是否搜索: false-搜索(默认); true-不搜索
function KG_UIFight:StartPvpFight(playerSelf, playerEnemy, nSeed, fnCallBack)
	if not playerSelf or not playerEnemy then
		return;
	end
	
	-- 设置战斗类型
	self:SetFightType(l_tbFightType.T_CUSTOM);
	
	cclog("StartPvpFight: %s vs %s, nseed: %s", tostring(playerSelf:GetUuid()), tostring(playerEnemy:GetUuid()), tostring(nSeed));
	local nSeed = nSeed or os.time();
	self.m_fnFightOverCallBack = fnCallBack;
	self.m_bPVP = true

	local tbHero = fighter.createFromPlayer(playerSelf:GetHerosFightInfo())
	local tbEnemy = fighter.createFromPlayer(playerEnemy:GetHerosFightInfo())
	self:StartFight(nSeed, tbHero, tbEnemy, nWinner);
end

--@function: 搜索和战斗
--@bFlag: 是否搜索: false-搜索(默认); true-不搜索
function KG_UIFight:SearchAndFight(nSeed, nBoxID, nWinner, nRewardID, bFlag, fnCallBack)
	-- nBoxID = 240001
	self.m_nHeroBoxID = nil;
	self:RandomBgImage(nBoxID);
	self.m_fnFightOverCallBack = fnCallBack;
	
	if bFlag then
		self:SetFightType(l_tbFightType.T_CUSTOM);
	else
		self:SetFightType(l_tbFightType.T_AFKER);
	end
	
	local tHero = fighter.createFromPlayer(me:GetHerosFightInfo())
	local tMonster = fighter.createFromMonsterBox(nBoxID)
	self.m_nMonsterID = nBoxID
	self:TestWrite(nSeed, nBoxID)
	self:StartFight(nSeed, tHero, tMonster, nWinner, nRewardID, bFlag);
end

--@function: 搜索
function KG_UIFight:StartSearch(nTime)
	print("[Log]==========================开始搜索===========================")
	--隐藏血条费用头像面板
	self.m_layerUp:setVisible(false)
	self.m_layerDown:setVisible(false)	
	self.m_pnlSearch:setVisible(true)
	local nCount = nTime
	local nUpdateT = nCount - 2
	if nTime then
		nTime = math.floor(nTime)
		local tAction = {}
		while true do
			math.randomseed(os.time())
			local nRanT = math.random(2, 3)
			if nRanT > nTime and nTime <= 2 then
				table.insert(tAction, cc.CallFunc:create(function()
					self.m_searchMsg:setString(l_tbExplorTalk[1].talk)
				end))
				break
			else
				if nTime > 2 then
					nRanT = 2
				end
				table.insert(tAction, cc.CallFunc:create(function()
					self.m_searchMsg:setString(l_tbExplorTalk[math.random(2, #l_tbExplorTalk)].talk)
				end))
				table.insert(tAction, cc.DelayTime:create(nRanT))
				nTime = nTime - nRanT
			end		
		end
		self.m_searchMsg:runAction(cc.Sequence:create(tAction))
		if nCount > 0 then
			self.m_searchScheduler = nil			
			local scheduler = cc.Director:getInstance():getScheduler()
			function countdown( ... )
				nCount = nCount - 1
				self.m_countDown:setString(nCount)
				if nCount <= 0 then
					scheduler:unscheduleScriptEntry(self.m_searchScheduler)
					self.m_searchScheduler = nil
				end
				if nCount == nUpdateT then
					GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_SEARCH, {nUpdateT})
				end
			end
			self.m_countDown:setString(nCount)
			self.m_searchScheduler = scheduler:scheduleScriptFunc(countdown, 1, false)			
		end
	end

	self:PlayUIAction("fight.json", "explor");
end

--@function: 战斗前处理
function KG_UIFight:BeforeStartFight(bFlag)
	if bFlag then
		local pnlReward = self:getChildByName("pnl_reward")
		if pnlReward then
			pnlReward:closeLayer();
		end
	end
	
	self:ProcessButtonState();
end

--@function: 逻辑上开始战斗计算
function KG_UIFight:StartFight(nSeed, tHero, tMonster, nWinner, nRewardID, bFlag)
	self:BeforeStartFight(bFlag);		
	
	-- 准备战斗数据
	self.m_nRewardID = nRewardID;	
	
	local nLeftRate = 0
	local tFightdata = {}
	local tCommand = {}
	local nFightType = self:GetFightType();
	local fighterSelf = gf_CopyTable(tHero);
	local fighterEnemy = gf_CopyTable(tMonster);

	--设置卡牌层玩家信息
	self.m_cardLayer:SetFighter(gf_CopyTable(tHero))
			
	local fnFight = function()
		print("fight ... ");
		-- 指引战斗数据不一样	
		tFightdata, self.m_nWinner, nLeftRate = minifight.startFight(tHero, tMonster, nSeed)
		tCommand = self.m_pParser:Parse(tFightdata)	
		self.m_nWinner = nWinner or self.m_nWinner
		if bFlag then
			KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():OnCallBack();
		end
		FightViewLogic:getInstance():SetWinner(self.m_nWinner, nLeftRate)
	
		-- 搜索之后播放
		local fnCall = function()
			-- 加载己方英雄
			self:LoadNpc(fighterSelf, l_tbCamp.MINE)
			
			-- 加载敌方英雄(pvp也是加载英雄)
			self:LoadNpc(fighterEnemy, l_tbCamp.ENEMY)

			self:UIFightProcess(tCommand)
		end
		
		-- 播放战斗动画先播放对话
		local fnDialog = function()
			self.m_pnlSearch:setVisible(false);
			-- self:UpdateDialog(fnCall);
			--page@2015/10/24 策划不需要这种对话
			fnCall();
		end
		
		-- 搜索时间
		local nID = me:GetCurrentAfkPoint();
		local tbAfkConfig = l_tbAfkConfig[nID] or {};
		local nTime = (tbAfkConfig.searchtime or 3000)/1000;	-- 配置表是毫秒
		if bFlag then
			nTime = 0;
		end

		print("search time: ", nTime);

		local action = cc.Sequence:create(cc.DelayTime:create(nTime), cc.CallFunc:create(fnDialog));
		self:runAction(action);

		if self.m_nFightType ~= l_tbFightType.T_CUSTOM then
			self:StartSearch(nTime);
		end
	end
	
	-- 计算也是延后0.5秒, 进度条显示： 下一帧开始处理
	local ac = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnFight));
	self:runAction(ac);
end

function KG_UIFight:OnExit()
	print("KG_UIFight OnExit ... ")
	-- ccs.ActionManagerEx:destroyInstance();
	
	local scheduler = cc.Director:getInstance():getScheduler()
	if g_shedule_particle_contract then
		scheduler:unscheduleScriptEntry(g_shedule_particle_contract)
	end
	
	--恢复初始速度
	cc.Director:getInstance():getScheduler():setTimeScale(1)
	self.m_nCurrentSpeed = 1;
end
------------------------------------------------------------------------------
--@function: 获取进度奖励
function KG_UIFight:GetRewardMore()
	FightViewLogic:getInstance():ReqGetRewardMore();
	
	local pnlRewardMore = self.m_Layout:getChildByName("pnl_reward_more");
	local nLayerID = self:GetLayerID();		-- for 特效
	af_BindEffect2Node(pnlRewardMore, 60068, nil, 1, nil, {nil, 0, nLayerID}); -- 60068
	print("11111", self.m_actionRewardMore, self.m_effectRewardMore)
	if self.m_actionRewardMore then
		self.m_actionRewardMore:stop();
	end
	
	if self.m_effectRewardMore then
		self.m_effectRewardMore:removeFromParent(true);
		self.m_effectRewardMore = nil;
	end
	
end

----------------------------------------------------------------------

---------------------------------------------------------------
--指令函数

--指令错误导致无法继续跑下去的保护机制,超5s后重新再跑下一条指令
function KG_UIFight:UIFIghtErrorProtect()
	if self.m_protectAct then
		self:stopAction(self.m_protectAct)				
	end
	self.m_protectAct = self:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(function()
		table.remove(self.m_tCommand, 1)
		self.m_protectAct = nil
		self:UIFightProcess()
	end)))
end

--战斗ui处理函数，传入所须展现的ui指令列表
function KG_UIFight:UIFightProcess(tCommand)
	--初始化时传入指令列表，后续回调直接使用记录值
	self.m_tCommand = tCommand or self.m_tCommand	

	if not self.m_tCommand or type(self.m_tCommand) ~= "table" then
		print("error no command!!!!!!", self.m_tCommand)
		return
	end

	if self.m_tCommand and #self.m_tCommand ~= 0 then
		local command = table.remove(self.m_tCommand, 1)		
		if command.processcommand and tCommand2Func[command.processcommand] and type(tCommand2Func[command.processcommand][1]) == "function" then
			print("command id, process func = ", command.processcommand, tCommand2Func[command.processcommand][2])
			tCommand2Func[command.processcommand][1](self, command.tArg)		
			self:UIFIghtErrorProtect()	
		else
			print("error haven't register a command process function ", command.processcommand)			
		end		
	end
end

--延时nDelayTime然后重新执行下一条指令
function KG_UIFight:DelayBackToProcess(nDelayTime)
	nDelayTime = nDelayTime or 0.8
	local seqAni = cc.Sequence:create(cc.DelayTime:create(nDelayTime), cc.CallFunc:create(function()
		self:UIFightProcess()
	end))
	self:runAction(seqAni);
end

--战斗开始
function KG_UIFight:FightStart()
	--隐藏搜索面板
	self.m_pnlSearch:setVisible(false)
	--指令执行结束
	self:UIFightProcess()

	--显示血条费用头像面板
	self.m_layerUp:setVisible(true)
	self.m_layerDown:setVisible(true)
end

--每轮开始
function KG_UIFight:RoundStart(tArg)	

	local nRound = tArg.round
	print("/********************************第" .. nRound .. "轮 ********************************/")
	--page@2015/11/20 先关掉
	self.m_pnlRound:setVisible(false)
	
	self.m_bmpRound:setString(nRound)
	local fnCall = function()
		self.m_pnlRound:setVisible(false);
		self:UIFightProcess()
	end
	
	--暂时屏蔽round展示效果
	local action = cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(fnCall));
	self:runAction(action);
	
	-- 插入round x记录
	self.m_pRecord:InsertRoundStart(nRound)

	--显示跳过按钮
	if self:GetFightType() == l_tbFightType.T_CUSTOM and nRound == l_tbFightSetting.nSkipRound then
		self.m_skipBtn:setVisible(true)
	end
end

--更新费用
--@function: 水晶更新
--@tbCost参数说明
--[[
--@nCur:		当前的可以用的费用
--@nMax:		当前的最大费用
--@nBefore:		之前的可以使用的费用
--@nChange:		最大费用的变化量，费用扣除不需要这个变量
]]
function KG_UIFight:UpdateCost(tArg)
	local nLayerID = self:GetLayerID();		-- for 特效
	local nCur, nMax, nBefore, nChange, nCamp = tArg.nCur, tArg.nMax, tArg.nBefore, tArg.nChange, tArg.nCamp
	cclog("[log]Updatecost: nCur(%s), nMax(%s), nBefore(%s), nChange(%s), nCamp(%s)", tostring(nCur), tostring(nMax), tostring(nBefore), tostring(nChange), tostring(nCamp))
	local tbModelName = {
		[l_tbCamp.MINE] = "listview_cost_2",
		[l_tbCamp.ENEMY] = "listview_cost_1",
	}
	local listCost = ccui.Helper:seekWidgetByName(self.m_Layout, tbModelName[nCamp]);
	if listCost and nCur ~= nBefore then	-- 水晶发生变化了
		local items = listCost:getItems()
		if nCur < nMax then					
			if nChange == 0 then	-- 费用扣除表现
				for i = nCur+1, nMax do
					local item = listCost:getItem(i-1)
					if item then
						local widgetCost = ccui.Helper:seekWidgetByName(item, "cost_full")
						if widgetCost then
							widgetCost:setVisible(false)
							
							local wtCostEmpty = ccui.Helper:seekWidgetByName(item, "cost_empty")
							local effect = af_GetEffectByID(60002);
							if effect then
								local size = wtCostEmpty:getContentSize();								
								effect:setPosition(cc.p(size.width/2, size.height/2));
								wtCostEmpty:addChild(effect)
							end
						end
					end
				end
			else								-- 增加水晶上限
				--逻辑上先补充完整
				local item = self.m_widgetCostItem;
				item:setVisible(true)
				listCost:setItemModel(item)
				local widgetCostEmpty = ccui.Helper:seekWidgetByName(item, "cost_empty")
				local widgetCostFull = ccui.Helper:seekWidgetByName(item, "cost_full")
				widgetCostEmpty:setVisible(true);
				widgetCostFull:setVisible(false);
				for i=1, nChange do
					listCost:pushBackDefaultItem();
				end
			end
		else								-- 增加水晶表现
			--逻辑上先补充完整
			local item = self.m_widgetCostItem;
			item:setVisible(false)
			listCost:setItemModel(item)
			for i=1, nChange do
				listCost:pushBackDefaultItem();
			end
			item:setVisible(false)
			
			local call = function ()
				--移动回来设置前面要增加的为不可见
				for i=1, nMax do
					local item = listCost:getItem(i-1);
					if not item then
						return;
					end
					if i <= nChange then
						item:setVisible(false)
					else
						item:setVisible(true);
					end
				end

				--增加特效
				for i=1, nChange do
					local item = listCost:getItem(i-1);
					if item then
						item:setVisible(true)
						local widgetCostEmpty = ccui.Helper:seekWidgetByName(item, "cost_empty")
						local widgetCostFull = ccui.Helper:seekWidgetByName(item, "cost_full")
						if widgetCostEmpty and widgetCostFull then
							widgetCostEmpty:setVisible(false)
							widgetCostFull:setVisible(false)
						end
						
						--增加特效播放完之后再设置可见
						local node = cc.Node:create();
						node:setPosition(widgetCostEmpty:getPosition())
						item:addChild(node, 1);
						
						local fnShow = function()
							node:removeFromParent(true)
							item:setVisible(true)
							widgetCostEmpty:setVisible(true)
							widgetCostFull:setVisible(true)
						end
						
						af_BindEffect2Node(node, 60001, nil, widgetCostFull:getScaleX(), fnShow, {nil, nil, nLayerID})
					end
				end
			end
			--填满之后移动
			local items = listCost:getItems()
			local fnMove = function ()
				local nMove = nMax - nChange 
				if nMove > 0 then
					for i=1, nMove do
						local item = listCost:getItem(i-1);
						if not item then
							return;
						end
						-- local itemRight = listCost:getItem(i);
						local posX, posY = item:getPosition();
						local action1 = cc.MoveBy:create(0.5, cc.p(self.m_nItemDistance * nChange, 0));
						-- local fnCall = function()
							-- item:setVisible(false)
							-- itemRight:setVisible(true);
						-- end
						local action2 = cc.Place:create(cc.p(posX, posY))
						local action = cc.Sequence:create(action1, action2)
						if i == 1 then
							action = cc.Sequence:create(action1, action2, cc.CallFunc:create(call));
						end
						item:runAction(action)
					end
				else
					call();
				end
			end
			--先填满
			local nFull = nCur - nChange;
			if nBefore < nFull then
				for i = nBefore, nFull-1 do
					local item = listCost:getItem(i)		--注意索引是从0开始的
					if not item then
						return;
					end
					item:setVisible(true)
					local wtCostEmpty = ccui.Helper:seekWidgetByName(item, "cost_empty")
					local wtCostFull = ccui.Helper:seekWidgetByName(item, "cost_full")

					-- 移动用这种方式只触发一次
					if i == nBefore then
						local fnCall = function()
							if wtCostFull then wtCostFull:setVisible(true) end
							if fnMove then
								fnMove();
							end
						end
						af_BindEffect2Node(wtCostEmpty, 60003, nil, 1, fnCall, {nil, nil, nLayerID})
					else
						local fnCall = function()
							if wtCostFull then wtCostFull:setVisible(true) end
						end
						af_BindEffect2Node(wtCostEmpty, 60003, nil, 1, fnCall, {nil, nil, nLayerID})
					end
				end
			else
				fnMove();
			end
		end
	else
		if listCost then
			--第一次清空
			if nMax == 0 then
				--保存两个水晶之间的距离
				local item0 = listCost:getItem(0)
				local item1 = listCost:getItem(1)
				if item0 and item1 then
					local x0, y0 = item0:getPosition();
					local x1, y1 = item1:getPosition();
					self.m_nItemDistance =  x1 - x0;
					-- print("两个item之间的距离为,", x1, y1, x0, y0, x1 - x0)
				else
					local size = self.m_widgetCostItem:getContentSize();
					self.m_nItemDistance = size.width;
				end
				listCost:removeAllItems()
			end
		end
	end
	
	--数字标签
	local widgetHP = nil;
	if nCamp == l_tbCamp.MINE then
		widgetHP = self.m_layerDown
	else
		widgetHP = self.m_layerUp;
	end
	

	if widgetHP then
		local textCost = ccui.Helper:seekWidgetByName(widgetHP, "text_crystal");
		if textCost then
			textCost:setString(nCur .. "/" .. nMax)
		end
	end

	--指令结束回调
	self:DelayBackToProcess(0.1)
end

function KG_UIFight:HPEffect(hpEffect, nPercent, nDPercent)	
	--首次需要计算每次减少血量值
	if not nDPercent then
		if hpEffect:getPercent() - nPercent >= 50 then
			nDPercent = 4
		else
			nDPercent = 8
		end
	end
	local nNextPercent = hpEffect:getPercent() - nDPercent
	if nNextPercent < 0 then
		nNextPercent = 0
	end
	if nPercent and nNextPercent < nPercent then
		nNextPercent = nPercent
	end
	hpEffect:setPercent(nNextPercent)
	if nNextPercent > nPercent and nNextPercent > 0 then
		hpEffect:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function()
			self:HPEffect(hpEffect, nPercent, nDPercent)
		end)))
	end
end

--更新血量
function KG_UIFight:UpdateHP(tArg)	
	local nCurHP, nMaxHP, nCamp, nPos, bShare = tArg.nCurHP, tArg.nMaxHP, tArg.nCamp, tArg.nPos, tArg.bShare
	print("KG_UIFight:UpdateHP", nCurHP, nMaxHP, nCamp, nPos)
	if nCurHP < 0 then
		nCurHP = 0
	end
	if nCamp == l_tbCamp.MINE then
		self.m_selfCurHp = nCurHP
	else
		self.m_enemyCurHp = nCurHP
	end
	local pnlHero = self:GetWidgetHero(nCamp, nPos)
	-- fnCallBack要调用一次
	if pnlHero then
		local proHP, proHP2, HPLabel = nil, nil, nil
		if not bShare then
			self:GetCharacterNode(nCamp, nPos):UpdateHp(nCurHP, nMaxHP)
		else
			local parent = pnlHero:getParent():getParent()
			proHP = ccui.Helper:seekWidgetByName(parent, "health_full")
			proHP2 = ccui.Helper:seekWidgetByName(parent, "health_empty")
			
			if nCamp == l_tbCamp.MINE then
				proHP = ccui.Helper:seekWidgetByName(self.m_layerDown, "health_full")
				proHP2 = ccui.Helper:seekWidgetByName(self.m_layerDown, "health_empty")
				HPLabel = ccui.Helper:seekWidgetByName(self.m_layerDown, "lbl_hpnum")
			else
				local pnlHP
				if self.m_layerUp:getChildByName("pnl_role1"):isVisible() then
					pnlHP = self.m_layerUp:getChildByName("pnl_role1")
				else
					pnlHP = self.m_layerUp:getChildByName("pnl_role2")
				end
				proHP = ccui.Helper:seekWidgetByName(pnlHP, "health_full")
				proHP2 = ccui.Helper:seekWidgetByName(pnlHP, "health_empty")
				HPLabel = ccui.Helper:seekWidgetByName(pnlHP, "lbl_hpnum")			
			end
			print("proHP", proHP, proHP2, self.m_layerUp, self.m_layerDown)
			local nPercent = nCurHP / nMaxHP * 100;
			cclog("界面血量更新(伤害：%s): 阵营(%d)-当前血量/总血量(%d/%d)-->%d/%%", tostring(nDamage), nCamp, nCurHP, nMaxHP, nPercent)
			if nPercent < 0 then
				nPercent = 0;
			elseif nPercent > 100 then
				nPercent = 100;
			end
			proHP:setPercent(nPercent)
			-- proHP2:setPercent(nPercent);
			proHP2:stopAllActions()
			proHP2:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
				self:HPEffect(proHP2, nPercent)
			end)))
			HPLabel:setString(nCurHP .. "/" .. nMaxHP)
		end		
		
		self.m_selfCurHp = self.m_selfCurHp or 0
		self.m_enemyCurHp = self.m_enemyCurHp or 0
		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_FIGHTHP, {self.m_selfCurHp, self.m_enemyCurHp})
		self:DelayBackToProcess(0.001)
	end	
end

--更新战斗记录
function KG_UIFight:UpdateFightRecord(tArg)
	local nCamp, nPos, nSkillId, nCost, tTarget = tArg.nCamp, tArg.nPos, tArg.nSkillId, tArg.nCost, tArg.tTarget
	local nHeroId = self:GetHeroId(nCamp, nPos)
	local sHeroName = self:GetNameById(nHeroId)
	for pos, target in pairs(tTarget) do
		target.sHeroName = self:GetNameById(self:GetHeroId(target.tcamp, pos))
	end
	self.m_pRecord:UpdateFightRecord(nCamp, nPos, nSkillId, nCost, tTarget, nHeroId, sHeroName)
	self:UIFightProcess()
end

--防守特效
function KG_UIFight:CharacterDefenseEffect(tArg)
	local tTarget, nSkillId = tArg.tTarget, tArg.nSkillId
	for nDePos, target in pairs(tTarget) do
		--被击特效
		self:PlaySkillEffect(nSkillId, 2, target.tcamp, nDePos);
	end
end

--英雄、怪物防御
function KG_UIFight:CharacterDefense(tArg)
	local tTarget, nSkillId, nCamp = tArg.tTarget, tArg.nSkillId, tArg.nCamp
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	
	-- 技能效果表现：(1)统一处理：+/1血，费用上限增加；(2)分技能处理：召唤、多重施法
	--Notify: 等特效播放完毕才开始播掉血操作，不然会出现死亡找不到对象的情况
	local fnUpdateResult = function()
		local nEffectType = self:GetEffectTypeById() or 0;
		if nEffectType < l_tbEffect.E_MIN or nEffectType > l_tbEffect.E_MAX then
			nEffectType = l_tbEffect.E_MIN;
		end
		if nEffectType == l_tbEffect.E_ADD then		
			-- 增加法力上限			
		else		
			for nDePos, target in pairs(tTarget) do
				if target.bingo and not target.bimmu and target.damage then
					self:CreateBloodEffect(target.tcamp, nDePos, -target.damage)
				end
			end						
			--更新血条
		end
		self:DelayBackToProcess(0.5)
	end	
	
	local bCallBack = false
	for nDePos, target in pairs(tTarget) do
		local nDeCamp = target.tcamp
		local pCharacter = self:GetUIHeroInfo(nDeCamp, nDePos).pCharacter		
		if pCharacter:HasHero() then
			if target.bingo then
				if bCallBack then
					pCharacter:Defense(nSkillId)
				else
					bCallBack = true
					pCharacter:Defense(nSkillId, fnUpdateResult)					
				end				
				self:ScreenFlash()
			else
				local fnCall = function()
					fnUpdateResult();
				end
				self:CreateMissEffect(nDeCamp, nDePos, fnCall)
			end
		end
	end
end

function KG_UIFight:CreateBloodEffect(nCamp, nPos, nDamage)
	print("CreateBloodEffect-nDamage", nDamage);
	nDamage = math.floor(nDamage)

	local nodeEffect = self:GetEffectPanel();
	widgetHero = self:GetStillNode(nCamp, nPos)
	local size = widgetHero:getContentSize()
	local labelBMFont = ccui.TextBMFont:create()
	if nDamage < 0 or nDamage == -0 then
		labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_RED)
	else
		labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_GREEN)
	end
	labelBMFont:setString(tostring(nDamage))
	
	local pos = widgetHero:convertToWorldSpace(cc.p(size.width / 2, size.height - 30))
	labelBMFont:setPosition(nodeEffect:convertToNodeSpace(pos))
		
	nodeEffect:addChild(labelBMFont)

	local call = function()
		labelBMFont:removeFromParent(true)
	end
	local action1 = cc.FadeIn:create(l_tbFightSetting.nFadeInT)
	local action2 = cc.MoveBy:create(l_tbFightSetting.nBeforeT, cc.p(0, l_tbFightSetting.nBeforeDis));
	local action3 = cc.ScaleTo:create(l_tbFightSetting.nScaleBT, l_tbFightSetting.nScaleB)	
	local action4 = cc.ScaleTo:create(l_tbFightSetting.nScaleST, l_tbFightSetting.nScaleS)	
	local action5 = cc.Sequence:create(action3, action4)
	local action6 = cc.Spawn:create(action2, action5);	
	local action7 = cc.FadeOut:create(l_tbFightSetting.nAfterT)
	local action8 = cc.MoveBy:create(l_tbFightSetting.nAfterT, cc.p(0, l_tbFightSetting.nAfterDis));
	local action9 = cc.ScaleTo:create(l_tbFightSetting.nAfterT, l_tbFightSetting.nAfterScale)		
	local action10 = cc.Spawn:create(action7, action8, action9);
	local action = cc.Sequence:create(action1, action6, action10, cc.CallFunc:create(call));
	labelBMFont:runAction(action);
	labelBMFont:setLocalZOrder(l_tbFightSetting.nZorder)
end

--@function:　创建miss效果
function KG_UIFight:CreateMissEffect(nCamp, nPos, fnCallBack)
	local widgetHero = self:GetStillNode(nCamp, nPos)
	local pnlShip = self:GetShipPanel(nCamp)
	print("CreateMissEffect", nCamp, nPos, widgetHero);
	if widgetHero then
		local size = widgetHero:getContentSize()
		local labelBMFont = ccui.Text:create();
		labelBMFont:setColor(cc.c3b(255, 0, 0));
		labelBMFont:setString("MISS");
		labelBMFont:setScale(3);
		
		local pos = widgetHero:convertToWorldSpace(cc.p(size.width / 2, size.height - 30))
		labelBMFont:setPosition(pnlShip:convertToNodeSpace(pos))
		labelBMFont:setPosition(pnlShip:convertToNodeSpace(pos))				
		pnlShip:addChild(labelBMFont) 
		local fnCall = function()
			labelBMFont:removeFromParent(true)
			print("删除节点，回调", fnCallBack);
			if fnCallBack then
				fnCallBack()
			end
		end
		local fadeout = cc.FadeIn:create(1)
		local moveBy = cc.MoveBy:create(1, cc.p(-50, 80));
		local spawn = cc.Spawn:create(fadeout, moveBy);
		local action = cc.Sequence:create(spawn,cc.CallFunc:create(fnCall));
		labelBMFont:runAction(action);
	end
end

--英雄、怪物攻击
function KG_UIFight:CharacterAttack(tArg)
	print("[延时]开始攻击释放动作 ............................ ", os.time())
	local nPos, nSkillId, nCamp, tmultiple, tcombo = tArg.nPos, tArg.nSkillId, tArg.nCamp, tArg.tmultiple, tArg.tcombo
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	local nDeCamp = l_tbCamp.MINE
	if nCamp == nDeCamp then
		nDeCamp = l_tbCamp.ENEMY
	end

	--更新费用
	local tbCost = {}
	tbCost[nCamp] = tSkillInfo.cost
	
	local fnCallBack = function()
		--界面灰层去掉
		self:HideCover(nCamp, nPos);
		--删掉多重施法脚底特效
		self:GetCharacterNode(nCamp, nPos):RemoveBuff(20002)
		--指令结束回调，下一指令防守
		self:UIFightProcess()
	end

	local pCharacter = self:GetCharacterNode(nCamp, nPos)
	if pCharacter:HasHero() then
		pCharacter:Attack(nSkillId, fnCallBack)		
		self:PlaySkillEffect(nSkillId, 1, nCamp, nPos, tbRetLau, tmultiple, tcombo);
	end

	--如果有合体技，马上执行下一条合体技指令
	if tcombo then
		self:UIFightProcess()
	end
end

--@function: 播放特效
--@nType:	1-攻击者特效; 2-受击者特效
--@arm: 骨骼动画，用来匹配大小
--@uiLayer: 战斗界面
--@nCamp: 特效阵营, 针对特殊位置的特效
--@nPosDef: 特效对应的位置
function KG_UIFight:PlaySkillEffect(nSkillId, nType, nCamp, nPosDef, tbRetLau, tmultiple, tcombo, fDefense)
	local arm = self:GetUIHeroInfo(nCamp, nPosDef).pCharacter:GetArm()
	local tSkillShow = l_tbConfigShow[nSkillId]
	local nEffID = tSkillShow["effectid" .. nType]
	local nEffScale = tSkillShow["eff" .. nType .. "_scale"]
	local nEffectPosType = tSkillShow["eff" .. nType .. "_onwho"]
	local nEffectScale = tSkillShow["eff" .. nType .. "_scale"]
	local nEffectBone = tSkillShow["eff" .. nType .. "_onwhere"]
	-- 受击特效放在特效层(在人物上面)
	local nodeEffect = self:GetEffectPanel();
	local nDefaultScale = 1;
	local nLayerID = self:GetLayerID();		-- for 特效
	local effect = af_BindEffect2Node(nodeEffect, nEffID, nil, nDefaultScale, nil, {nil, nil, nLayerID})
	--设置帧事件
	local function onFrameEvent(bone, evt, originFrameIndex, currentFrameIndex)
		if evt == "magic" then
			self:PlayFrameEventEffect(nCamp, nPosDef, tmultiple)	
		elseif nType == 2 and evt == "action" then
			if #self.m_tDefenseEffect == 1 then
				self:UIFightProcess()
			end
		end
	end
	local function onMoveEvent(armatureBack, movementType, movementID)
		if movementType == ccs.MovementEventType.complete then
			for i, v in ipairs(self.m_tDefenseEffect) do
				if v == effect then
					table.remove(self.m_tDefenseEffect, i)
					effect:runAction(cc.RemoveSelf:create())
					break
				end
			end
		end
	end
	if effect then
		effect:getAnimation():setFrameEventCallFunc(onFrameEvent)
		if nType == 2 then
			effect:getAnimation():setMovementEventCallFunc(onMoveEvent)
			self.m_tDefenseEffect = self.m_tDefenseEffect or {}
			table.insert(self.m_tDefenseEffect, effect)
		end
	end
	-- 设置属性	
	local ref = self:GetEffectRefPanel(nType, nCamp, nPosDef, nEffectPosType)		-- 阵营需要传入攻击者阵营
	local parent = self:GetEffectPanel();
	self:SetEffectScale(nType, effect, parent, ref, arm, nEffectScale)
	self:SetEffectPosition(nType, effect, parent, ref, arm, nEffectBone)	
end

--@function:　设置特效属性(位置、大小)
--@effect: 特效
--@parent: 特效绑定到的节点
--@ref: 特效参考的节点
--@arm: 骨骼动画
function KG_UIFight:SetEffectScale(nType, effect, parent, ref, arm, nEffScale)
	print("[Log]特效设置位置和大小")
	-- 默认就是参考父节点
	local ref = ref or parent;
	if effect then
		-- 大小调整
		local sizeRef = ref:getContentSize();
		local sizeEffect = effect:getContentSize();
		local nScale = sizeRef.width/sizeEffect.width;
		local nEffectScaleH = sizeRef.height/sizeEffect.height;
		if nScale < nEffectScaleH then
			nScale = nEffectScaleH;
		end
		if nEffScale then
			print("受击特效比例", nEffScale, nScale, nEffScale * nScale)
			effect:setScale(nEffScale * nScale)
		end
	end
end

--@function: 获取特效坐标点
function KG_UIFight:SetEffectPosition(nType, effect, parent, ref, arm, bone)
	local ref = ref or parent;
	if effect then									
		local posWorld = nil;
		if type(bone) == "string" then
			if arm then
				local pos = arm:getBonePosition(bone)
				posWorld = arm:convertToWorldSpace(pos)
			end
		else	
			local sizeRef = ref:getContentSize();
			local nProX, nProY = unpack(bone or {0.5, 0.5});
			local posX, posY = sizeRef.width*nProX, sizeRef.height*nProY;
			posWorld = ref:convertToWorldSpace(cc.p(posX, posY))
		end
		if posWorld then
			local posNew = parent:convertToNodeSpace(posWorld)
			effect:setPosition(posNew)
		end
	end
end

function KG_UIFight:GetEffectRefPanel(nIndex, nCamp, nPos, nType)
	print("[Log]特效释放位置类型(3-屏幕;4-敌方阵营;5-己方阵营): ", nType, nIndex)
	local ref = nil;
	if nType == 3 then							-- 屏幕正中央
	elseif nType == 4 then						-- 敌方正中
		local nEnemyCamp = 3 - nCamp;
		ref = self:GetEffectShipPanel(nEnemyCamp)
	elseif nType == 5 then						-- 己方正中
		ref = self:GetEffectShipPanel(nCamp)
	elseif nType == 6 then						-- 敌方前排
		local nEnemyCamp = 3 - nCamp;
		ref = self:GetWidgetHero(nEnemyCamp, 2)
	elseif nType == 7 then						-- 敌方后排
		local nEnemyCamp = 3 - nCamp;
		ref = self:GetWidgetHero(nEnemyCamp, 5)
	elseif nType == 8 then						-- 己方前排
		ref = self:GetWidgetHero(nCamp, 2)
	elseif nType == 9 then						-- 己方后排
		ref = self:GetWidgetHero(nCamp, 5)
	else										-- 英雄位置
		ref = self:GetWidgetHero(nCamp, nPos)
	end
	
	return ref;
end

function KG_UIFight:PlayFrameEventEffect(nCamp, nPos, tmultiple)	
	if tmultiple then
		--多重施法
		local nodeSrc = self:GetStillNode(nCamp, nPos);
		local nLayerID = self:GetLayerID();		-- for 特效
		
		if not nodeSrc then
			return;
		end
		
		local srcX, srcY = nodeSrc:getPosition();
		
		--config
		local nFade = l_tbEffectConfig.nFade or 0.5
		local nMinSeg = l_tbEffectConfig.nMinSeg or 15
		local nStroke = l_tbEffectConfig.nStroke or 25
		local r, g, b = unpack(l_tbEffectConfig.tbColor)
		local nTime = l_tbEffectConfig.nTime
		local tbPos = l_tbEffectConfig.tbPos or {0.5, 0.2};
		local tbPosStart = l_tbEffectConfig.tbPosStart
		local tbPosEnd = l_tbEffectConfig.tbPosEnd
		
		for _, nHeroId in ipairs(tmultiple) do
			local nPos = self:GetHeroPosById(nCamp, nHeroId)
			local node = self:GetStillNode(nCamp, nPos);
			--拖尾("res/ui/temp/streak7.png")
			local streak = cc.MotionStreak:create(nFade, nMinSeg, nStroke, cc.c3b(r, g, b), CUI_PATH_MAGIC_STREAK)
			streak:setBlendFunc(gl.ONE, gl.ONE);	--高亮叠加
			nodeSrc:addChild(streak);
			local srcSize = nodeSrc:getContentSize();
			local posX, posY = srcSize.width * (tbPosStart[1] or 0.5), srcSize.height * (tbPosStart[2] or 1.1)
			streak:setPosition(cc.p(posX, posY))
			
			if node then
				local nodeX, nodeY = node:getPosition();
				local nodeSize = node:getContentSize();
				local x = (nodeX + nodeSize.width * (tbPosEnd[1])) - (srcX + posX) 
				local y = (nodeY + nodeSize.height * (tbPosEnd[2])) - (srcY + posY);
				local fnCall = function()
					streak:removeFromParent(true)
					
					--增加脚底特效
					local effect = af_BindEffect2Node(node, 20002, {tbPos, -1}, nil, nil, {nil, nil, nLayerID})
					self:GetCharacterNode(nCamp, nPos):AddBuffWithoutCreate(20002, effect)
				end
				
				local fnHit = function()
					local effect = af_BindEffect2Node(node, 40005, nil, nil, nil, {nil, nil, nLayerID})
				end
				
				local move = cc.MoveBy:create(nTime, cc.p(x, y))
				local action = cc.Sequence:create(move, cc.CallFunc:create(fnCall))
				local spa = cc.Spawn:create(action, cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnHit)))
				streak:runAction(spa);
			end
		end		
	else
		--其他技能释放
		local node = self:GetStillNode(nCamp, nPos);
		--拖尾
		local streak = cc.MotionStreak:create(0.5, 15, 25, cc.c3b(255, 255, 255), "res/ui/temp/streak7.png")
		streak:setBlendFunc(gl.ONE, gl.ONE);	--高亮叠加
		node:addChild(streak);
		local srcSize = node:getContentSize();
		local posX, posY = srcSize.width/2, srcSize.height + 100
		streak:setPosition(cc.p(posX, posY))
	end	
end

--召唤生物攻击
function KG_UIFight:SummonAttackMove(tArg)	
	print("[Log]开始移动 UIRunMove ... ")
	local nSkillId, nCamp, nPos, nDePos = tArg.nSkillId, tArg.nCamp,  tArg.nPos, tArg.nDePos
	local nDeCamp = l_tbCamp.MINE
	if nCamp == nDeCamp then
		nDeCamp = l_tbCamp.ENEMY
	end

	local posLau = nPos
	local posDef = nDePos
	local nodeDef = self:GetNode(nDeCamp, posDef);
	local nodeLau = self:GetNode(nCamp, posLau);
	local posNodeLau = nodeLau:convertToWorldSpace(cc.p(0,0))
	local posNodeDef = nodeDef:convertToWorldSpace(cc.p(0, 0))
	local sizeLau = nodeLau:getContentSize()
	local sizeDef = nodeDef:getContentSize()
	local distanceX = posNodeDef.x - posNodeLau.x  + sizeLau.width/2
	local distanceY = posNodeDef.y - posNodeLau.y - 50
	local posLauX, posLauY = nodeLau:getPosition();
	local place = cc.Place:create(cc.p(posLauX + distanceX, posLauY + distanceY));
	local nScaleOld = nodeLau:getScale();	
	local scale = sizeDef.width/sizeLau.width
	local nLayerID = self:GetLayerID();		-- for 特效

	--保存移动前信息
	self.m_tBeforeMove.nScaleOld = nScaleOld
	self.m_tBeforeMove.nPosX = posLauX
	self.m_tBeforeMove.nPosY = posLauY
	
	local fnPlace = function()
		nodeLau:setPosition(cc.p(posLauX + distanceX, posLauY + distanceY))
		nodeLau:setScale(scale)
		self:ChangePanelOrder(nCamp)
	end
	local fnNextStep = function()
		--指令结束回调，下一指令攻击
		self:UIFightProcess()
	end
	
	--增加消失动作(看策划逻辑图)
	cclog("[Log]没有骨骼动画....@UIRunMove(nCamp:%s, posLau:%s)", tostring(nCamp), tostring(posLau))
	local fnCallBack = function()
		nodeLau:setVisible(false)
		
		local fnCall = function()
			local fnSetVisible = function()
				nodeLau:setVisible(true)
			end
			local action = cc.Sequence:create(cc.CallFunc:create(fnPlace), cc.CallFunc:create(fnSetVisible), cc.DelayTime:create(0.5), cc.CallFunc:create(fnNextStep));
			nodeLau:runAction(action)
		end
		local node = self:GetStillNode(nCamp, posLau);
		af_BindEffect2Node(node, 10006, nil, nil, fnCall, {nil, nil, nLayerID});
	end
	
	--怪物消失动画结束后调用fnCallBack移动怪物
	self:GetCharacterNode(nCamp, posLau):Dispear(fnCallBack)
end

--召唤生物攻击移动返回
function KG_UIFight:SummonAttackMoveBack(tArg)
	local nCamp, nPos = tArg.nCamp, tArg.nPos
	local nodeLau = self:GetNode(nCamp, nPos);
	if self.m_tBeforeMove and self.m_tBeforeMove.nScaleOld and self.m_tBeforeMove.nPosX and self.m_tBeforeMove.nPosY then
		nodeLau:setPosition(cc.p(self.m_tBeforeMove.nPosX, self.m_tBeforeMove.nPosY))
		nodeLau:setScale(self.m_tBeforeMove.nScaleOld)
	else
		print("can't move back!!!!!!!!!!!!!!")
		tst_print_lua_table(self.m_tBeforeMove)
	end
	self:DelayBackToProcess(0.5)
end

--正常动画
function KG_UIFight:NormalAttackEffect(tArg)
	local nCamp, nSkillId, nPos = tArg.nCamp, tArg.nSkillId, tArg.nPos
	local nHeroId = self:GetHeroId(nCamp, nPos)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	if not tSkillInfo then
		print("skill id is wrong " .. nSkillId)
		return
	end
	local fnCallEnd = function()
		print("[log]开始特效播放完毕，回调下一个 ... ")
		local szName = "pnl_skillname_" .. nCamp
		local pnlSkillName = ccui.Helper:seekWidgetByName(self.m_Layout, szName);		
		if pnlSkillName then
			pnlSkillName:setVisible(true)
		end
		self:HideCover(nCamp, nPos);
		
		--触发技能延时
		if tSkillInfo.casttype == 1 then
			self:DelayBackToProcess(0.6)
		else
			self:DelayBackToProcess(0.2)
		end
	end
	if tSkillInfo.casttype == 1 then					--触发技能条件ID
		local wtMark = self:GetMarkWidget(nCamp, nPos)
		af_BindEffect2Node(wtMark, 20001, nil, nil, fnCallEnd, {nil, nil, nLayerID})
	else											--正常技能
		if self:IsHero(nHeroId) then			
			--选人随机特效
			-- self:RandomPlaceByPoint(nCamp, nPos, fnCallEnd);
			fnCallEnd()
		else
			local nodeLau = self:GetWidgetHero(nCamp, nPos)
			local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(fnCallEnd));
			nodeLau:runAction(action)
		end
	end
end

--连携动画(第一次攻击结束，第二个释放技能时候才显示)
function KG_UIFight:BindAttackEffect(tArg)	
	local nCamp, tBind = tArg.nCamp, tArg.tBind
	local nSpeed = self:GetPlaySpeed();
	cc.Director:getInstance():getScheduler():setTimeScale(nSpeed)
	print("[延时]触发连携 ............................ ", os.time())
	local tHeroId = {}
	for _, tInfo in ipairs(tBind) do
		tHeroId = tInfo.nHeroId
	end	

	self:PlayEffect(1, {nCamp, tBind[2].nPos, tHeroId, tBind[1].nPos}, handler(self, self.DelayBackToProcess, 1))
	if pnlSkillName then
		pnlSkillName:setVisible(true)
	end
end

--多重动画
function KG_UIFight:MultiAttackEffect(tArg)
	--多重施法要求加速播放	
	local fnCallEnd = function()
		print("[log]开始特效播放完毕，回调下一个 ... ")
		local szName = "pnl_skillname_" .. nCamp
		local pnlSkillName = ccui.Helper:seekWidgetByName(self.m_Layout, szName);
		if pnlSkillName then
			pnlSkillName:setVisible(true)
		end
		self:HideCover(nCamp, nPos);
		
		self:UIFightProcess()
	end
	local nSpeed = self:GetPlaySpeed();
	cc.Director:getInstance():getScheduler():setTimeScale(nSpeed * 1.5)
	fnCallEnd();
end

--合击动画
function KG_UIFight:ComboAttackEffect(tArg)
	local nSkillId, nCamp, tcombo, nPos = tArg.nSkillId, tArg.nCamp, tArg.tcombo, tArg.nPos
	local nType = 1 	--攻击特效
	local tSkillShow = l_tbConfigShow[nSkillId]
	local nEffID = tSkillShow["effectid" .. nType]
	local nEffScale = tSkillShow["eff" .. nType .. "_scale"]
	local nEffectPosType = tSkillShow["eff" .. nType .. "_onwho"]
	local nEffectScale = tSkillShow["eff" .. nType .. "_scale"]
	local nEffectBone = tSkillShow["eff" .. nType .. "_onwhere"]

	--合击同伴执行合击动作
	self:GetUIHeroInfo(nCamp, tcombo[2].nPos).pCharacter:Combo(nSkillId)

	-- 合作技能上面一层特效
	local armEffect = self:GetCharacterNode(nCamp, nPos):GetArm()
	local nodeEffect = self:GetEffectPanel();
	local nLayerID = self:GetLayerID();		-- for 特效
	local effect = af_BindEffect2Node(nodeEffect, 60040, {nil, 2}, 1, nil, {nil, nil, nLayerID})
	-- 设置属性
	local parent = self:GetEffectPanel();
	local ref = self:GetEffectRefPanel(nType, nCamp, nPos, nEffectPosType);		-- 阵营需要传入攻击者阵营
	self:SetEffectScale(nType, effect, parent, ref, armeffect, nEffectScale)
	self:SetEffectPosition(nType, effect, parent, ref, armeffect, nEffectBone)	
	-- 播放UI上的动画
	local tbRes = {}
	for _, tInfo in ipairs(tcombo) do
		local tHeroInfo = l_tbCharacterConfig[tInfo.nHero]
		if tHeroInfo then
			local tModel = l_tbNpcModels[tHeroInfo.modelid]
			if tModel then
				table.insert(tbRes, tModel.img_cha)
			end
		end
	end
	self:PlayEffect(2, tbRes, handler(self, self.DelayBackToProcess, 1));
end

function KG_UIFight:Copy(tArg)
	local tTarget, nSkillId = tArg.tTarget, tArg.nSkillId
	for _, target in pairs(tTarget) do
		local nPos = target.copypos
		local nCamp = target.copycamp
		local nSummonId = target.summonid
		if target.bingo and nPos and nCamp and nSummonId then	
			self:GetCharacterNode(nCamp, nPos):Copy(nSummonId, 
				handler(self, self.DelayBackToProcess, 1), 
				handler(self, self.touchFunc))					
		end
	end	
end

function KG_UIFight:Summon(tArg)
	local tTarget, nSkillId = tArg.tTarget, tArg.nSkillId
	local bCallBack = false
	for nPos, target in pairs(tTarget) do
		if target.bingo then
			if bCallBack then
				self:GetCharacterNode(target.tcamp, nPos):Summon(
					target.summonid, target.bSuc, target.bInQueue, nil, 
					handler(self, self.touchFunc))	
			else
				bCallBack = true
				self:GetCharacterNode(target.tcamp, nPos):Summon(
					target.summonid, target.bSuc, target.bInQueue, 
					handler(self, self.DelayBackToProcess, 1), 
					handler(self, self.touchFunc))			
			end
		end
	end	
end

function KG_UIFight:UISummomDeath(tArg)
	local nCamp, nPos, nNewSummonId = tArg.nCamp, tArg.nPos, tArg.nNewSummonId
	self:GetCharacterNode(nCamp, nPos):SummonDeath(
		nNewSummonId,  
		handler(self, self.DelayBackToProcess, 1), 
		handler(self, self.touchFunc))
end

--buff清除
function KG_UIFight:RemoveBuff(tArg)
	--清除buff
	local nCamp, nPos, nBuffId = tArg.nCamp, tArg.nPos, tArg.nBuffId
	self:GetCharacterNode(nCamp, nPos):RemoveBuff(nBuffId)
	self:UIFightProcess()
end

--buff添加
function KG_UIFight:AddBuff(tArg)
	--添加buff
	local nCamp, nPos, nBuffId = tArg.nCamp, tArg.nPos, tArg.nBuffId
	self:GetCharacterNode(nCamp, nPos):AddBuff(nBuffId, self:GetLayerID())
	self:UIFightProcess()
end

--buff持续伤害
function KG_UIFight:BuffSustain(tArg)
	local nCamp, nPos, nBuffId, nValue = tArg.nCamp, tArg.nPos, tArg.nBuffId, tArg.nValue
	self:CreateBloodEffect(nCamp, nPos, -nValue)
	self:UIFightProcess()
end

--治疗效果
function KG_UIFight:CurlEffect(tArg)
	local nCamp, nPos, nSkillId, nValue, nDePos = tArg.nCamp, tArg.nPos, tArg.nSkillId, tArg.nValue, tArg.nDePos
	self:CreateBloodEffect(nCamp, nDePos, nValue)
	self:UIFightProcess()
end

--闪屏，震屏
function KG_UIFight:ScreenFlash()
	cc.Director:getInstance():getScheduler():setTimeScale(2)
	local flash = ccui.Helper:seekWidgetByName(self.m_Layout, "img_flashblack")
	flash:setVisible(true)
	flash:setOpacity(20)
	flash:setColor(cc.c3b(255, 255, 255))
	local function turnBlack()
		flash:setColor(cc.c3b(0, 0, 0))
	end
	local function flashend()
		flash:setVisible(false)
		flash:setColor(cc.c3b(255, 255, 255))
		self:PlayUIAction("fight.json", "shock", cc.CallFunc:create(function()
					--闪屏
					cc.Director:getInstance():getScheduler():setTimeScale(1)					
				end))
	end

	flash:runAction(
		cc.Sequence:create(
			cc.CallFunc:create(turnBlack), 
			cc.CallFunc:create(flashend)))
end

--设置卡牌
function KG_UIFight:SetSkillCard(tArg)
	local nRound, nMaxCost = tArg.nRound, tArg.nMaxCost
	self.m_cardLayer:ConstructCardList(nMaxCost, nRound)
	self:UIFightProcess()
end

--随机技能
function KG_UIFight:RandomSkillCard(tArg)
	local nRound, nMaxCost, nSkillId, nPos = tArg.nRound, tArg.nMaxCost, tArg.nSkillId, tArg.nPos	
	self.m_cardLayer:RandomSkill(nSkillId, nMaxCost, nRound, self:GetHeroId(l_tbCamp.MINE, nPos), handler(self, self.UIFightProcess))
end

--每轮结束
function KG_UIFight:RoundEnd()
	--每轮结束清除卡牌
	self.m_cardLayer:resetSkillCard()
	self:UIFightProcess()
end

--战斗结束
function KG_UIFight:FightEnd()
	--结束动画
	self:EndAnimation()
end

-------------------------------------------------------------------------
--测试相关函数
function KG_UIFight:TestEffect()
	local pnlTest = self.m_Layout:getChildByName("pnl_test")
	pnlTest:setVisible(true);
	local btnEffect = pnlTest:getChildByName("btn_effect")
	local lvEffect = pnlTest:getChildByName("lv_effect")
	-- 回到首页
	local btnMain = pnlTest:getChildByName("btn_test_main")
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:runAction(cc.RemoveSelf:create())
		end
	end
	btnMain:addTouchEventListener(fnClose);
	
	-- 打印内存
	local btnPrint = pnlTest:getChildByName("btn_test_print");
	local fnPrint = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			tst_print_textures_cache();
			-- local nBoxID = me:RandomMonsterBoxID();
			-- self:StartFight(os.time(), nBoxID)
			cc.SpriteFrameCache:getInstance():removeSpriteFrames();
		end
	end
	btnPrint:addTouchEventListener(fnPrint);
	
	local tbArmatures = mconfig.loadConfig("script/cfg/client/effect")
	lvEffect:removeAllItems();
	local fnTouch = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.m_testCurEffect then
				self.m_testCurEffect:removeFromParent(true);
			end
			local node = self:GetNode(1, 2);
			local nID = sender.__effectid;
			local nLayerID = self:GetLayerID();		-- for 特效
			local effect = af_BindEffect2Node(node, nID, nil, nil, nil, {nil, 1, nLayerID});
			self.m_testCurEffect = effect;
			if effect then
				local sizeNode = node:getContentSize();
				local sizeEffect = effect:getContentSize();
				local nScale = sizeNode.width/sizeEffect.width;
				local nEffectScaleH = sizeNode.height/sizeEffect.height;
				if nScale < nEffectScaleH then
					nScale = nEffectScaleH;
				end
				if nEffScale then
					print("受击特效比例", nEffScale, nScale, nEffScale * nScale)
					effect:setScale(nEffScale * nScale)
				end
			end
		end
	end
	
	-- 按照ID排序
	local tbHashIDs = {}
	for nID, tbData in pairs(tbArmatures) do
		table.insert(tbHashIDs, nID);
	end
	local fnCompare = function(a, b)
		return a.effectid > b.effectid;
	end
	table.sort(tbHashIDs)
	
	-- 设置特效长度
	local btnSize = btnEffect:getContentSize();
	local nWidth = btnSize.width + 1;
	local nTotal = #(tbHashIDs or {});
	local size = lvEffect:getInnerContainerSize();
	lvEffect:setInnerContainerSize(cc.size(nTotal * nWidth, size.height));
	for _, nID in ipairs(tbHashIDs) do
		local tbModel = tbArmatures[nID]
		local item = btnEffect:clone();
		item.__effectid = nID;
		item:setVisible(true);
		item:setTitleText(nID);
		lvEffect:pushBackCustomItem(item);
		item:addTouchEventListener(fnTouch);
	end
end

function KG_UIFight:TestModel()
	local pnlTest = self.m_Layout:getChildByName("pnl_test")
	pnlTest:setVisible(true);
	local btnModel = pnlTest:getChildByName("btn_effect")
	local lvModel = pnlTest:getChildByName("lv_model")
	
	local tbArmatures = mconfig.loadConfig("script/cfg/client/model")
	lvModel:removeAllItems();
	local fnTouch = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local node = self:GetNode(1, 5);
			local nID = sender.__modelid;
			--UpdateHero
			local tbShips = self.m_FightHall:GetShips();
			local hero = tbShips[1]:GetHeroByPos(5);
			hero:GetHeroObj():SetModelID(nID);
			self:UpdateHero(hero)
		end
	end
	
	-- 按照ID排序
	local tbHashIDs = {}
	for nID, tbData in pairs(tbArmatures) do
		table.insert(tbHashIDs, nID);
	end
	local fnCompare = function(a, b)
		return a.modelid > b.modelid;
	end
	table.sort(tbHashIDs)
	for _, nID in ipairs(tbHashIDs) do
		local tbModel = tbArmatures[nID]
		local item = btnModel:clone();
		item.__modelid = nID;
		item:setVisible(true);
		item:setTitleText(nID);
		lvModel:pushBackCustomItem(item);
		item:addTouchEventListener(fnTouch);
	end
end

function KG_UIFight:TestTouchHero()
	local tbAnimations = KGC_MODEL_MANAGER_TYPE:getInstance():GetAnimation();
	local szAnimation = tbAnimations[math.random(#tbAnimations)]
	
	local arm = self:GetArmature(1, 5)
	if arm then
		if arm._is_using then
			return
		end
		
		-- 标记正在动作
		arm._is_using = true
		
		arm:registerSpineEventHandler(function (event)
			if event.animation == szAnimation then
				self:ArmSetAnimation(arm, 0, "standby", true)
				arm._is_using = nil;
			end
		end, sp.EventType.ANIMATION_COMPLETE)
  
		self:ArmSetAnimation(arm, 0, szAnimation, false)
	end
end

function KG_UIFight:TestFight()
	local pnlTestFight = ccui.Helper:seekWidgetByName(self.m_Layout, "Panel_23")
	local theroList = sf_split(pnlTestFight:getChildByName("img_inputbg_0"):getChildByName("tf_input"):getStringValue(), ",")
	local tMonsterList = sf_split(pnlTestFight:getChildByName("img_inputbg_1"):getChildByName("tf_input"):getStringValue(), ",")
	
end

function KG_UIFight:TestWrite(nSeed, nBoxID)
	print("@StartFight...............")
	print("[StartFight]随机种子：", nSeed)
	print("[StartFight]怪物盒子：", nBoxID)
	--测试阶段：重现bug
	if DEBUG_VERSION_PC then
		local f = io.open("seed.txt", "a+")
		f:write("seed:" .. nSeed .. ", " .. nBoxID .. "\n")
		f:close();
	else
		cc.UserDefault:getInstance():setIntegerForKey("seed",nSeed)
		cc.UserDefault:getInstance():setIntegerForKey("boxid",nBoxID)
	end
	-- 记录随机种子和服务器调试保持一致or查错用
	if DEBUG_SEED then
		local szLog = "seed:" .. nSeed .. ", " .. nBoxID .. "\n";
		tst_write_file("tst_seed.txt", szLog);
	end
	--测试阶段：重现bug
end

tCommand2Func = 
{
	[PARSERCOMMAND.FIGHTSTART] = {KG_UIFight.FightStart, "FightStart"}, 
	[PARSERCOMMAND.UPDATECOST] = {KG_UIFight.UpdateCost, "UpdateCost"}, 
	[PARSERCOMMAND.UPDATEHP] = {KG_UIFight.UpdateHP, "UpdateHP"}, 
	[PARSERCOMMAND.ROUNDSTART] = {KG_UIFight.RoundStart, "ROUNDSTART"}, 
	[PARSERCOMMAND.DELAYBACKTOPROCESS] = {KG_UIFight.DelayBackToProcess, "DelayBackToProcess"}, 
	[PARSERCOMMAND.REMOVEBUFF] = {KG_UIFight.RemoveBuff, "RemoveBuff"}, 
	[PARSERCOMMAND.ADDBUFF] = {KG_UIFight.AddBuff, "AddBuff"}, 
	[PARSERCOMMAND.NORMALATTACKEFFECT] = {KG_UIFight.NormalAttackEffect, "NormalAttackEffect"}, 
	[PARSERCOMMAND.SUMMONATTACKMOVE] = {KG_UIFight.SummonAttackMove, "SummonAttackMove"}, 
	[PARSERCOMMAND.CHARACTERATTACK] = {KG_UIFight.CharacterAttack, "CharacterAttack"}, 
	[PARSERCOMMAND.COMBOATTACKEFFECT] = {KG_UIFight.ComboAttackEffect, "ComboAttackEffect"}, 
	[PARSERCOMMAND.UPDATEFIGHTRECORD] = {KG_UIFight.UpdateFightRecord, "UpdateFightRecord"}, 
	[PARSERCOMMAND.SUMMON] = {KG_UIFight.Summon, "Summon"}, 
	[PARSERCOMMAND.COPY] = {KG_UIFight.Copy, "Copy"}, 
	[PARSERCOMMAND.CURLEFFECT] = {KG_UIFight.CurlEffect, "CurlEffect"}, 
	[PARSERCOMMAND.MULTIATTACKEFFECT] = {KG_UIFight.MultiAttackEffect, "MultiAttackEffect"}, 
	[PARSERCOMMAND.CHARACTERDEFENSE] = {KG_UIFight.CharacterDefense, "CharacterDefense"}, 
	[PARSERCOMMAND.UISUMMONDEATH] = {KG_UIFight.UISummomDeath, "UISummomDeath"}, 
	[PARSERCOMMAND.SUMMONATTACKMOVEBACK] = {KG_UIFight.SummonAttackMoveBack, "SummonAttackMoveBack"}, 
	[PARSERCOMMAND.BINDATTACKEFFECT] = {KG_UIFight.BindAttackEffect, "BindAttackEffect"}, 
	[PARSERCOMMAND.CHARACTERDEFENSEEFFECT] = {KG_UIFight.CharacterDefenseEffect, "CharacterDefenseEffect"}, 
	[PARSERCOMMAND.ROUNDEND] = {KG_UIFight.RoundEnd, "RoundEnd"}, 
	[PARSERCOMMAND.FIGHTEND] = {KG_UIFight.FightEnd, "FightEnd"}, 
	[PARSERCOMMAND.SETSKILLCARD] = {KG_UIFight.SetSkillCard, "SetSkillCard"}, 
	[PARSERCOMMAND.RANDOMSKILLCARD] = {KG_UIFight.RandomSkillCard, "RandomSkillCard"}, 
}