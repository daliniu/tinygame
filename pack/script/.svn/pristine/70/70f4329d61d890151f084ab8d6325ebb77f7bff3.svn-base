require("script/class/class_base_ui/class_base_layer")
require("script/ui/publicview/gmview")
require("script/ui/publicview/mainbuttonview")
require("script/core/configmanager/configmanager");
----------------------------------------------------------------------------
local l_tbConfigMenu = mconfig.loadConfig("script/cfg/client/ui/mainsetting")

--struct data
local TB_STRUCT_MAIN_VIEW ={
	-- config
	m_szJsonFile = CUI_JSON_MAIN,
	------------------------------------------
	--ui widget
	m_BmpStep = nil,		--行动力
	m_BmpGold = nil, 		--金币
	m_BmpDiamond = nil,		--钻石
	m_BmpLevel = nil,		--等级
	m_BarExp = nil,			--经验条
	m_BmpExp = nil,			--经验数值
	m_BmpFightPoint = nil,	--战斗力
	m_BmpVIP = nil,			--VIP等级
	
	m_BtnMenu = nil,		--菜单按钮
	m_Btnblacksmith =nil,	--打造界面
	m_BtnHandbook =nil,		--召唤
	m_BtnShop =nil,			--商店

	m_TextPlayerName = nil,	 --用户名

	
	m_PnlHeros = nil,		--角色面板
	
	--
	m_tbRightButtons = {},	--右边一排按钮table
	m_tbMenuButtons = {},	--菜单下面的按钮
	m_tbHeroPanels = {		--英雄panel
		--[pos] = panel;
	},
	m_tbArmatures = {},		-- 英雄模型
	---------------------------------------
	--英雄旋转相关变量
	m_bHRInValid = false,		--触摸点无效(起始点无效, 后续都无效)
	m_bHRValid = false,			--触摸有效(起始点有效, 后续才有效)
	m_tbPosHeros = {},			--英雄坐标
	m_tbEllipse = {				--椭圆轨迹相关数据
		a = 0,						--椭圆长半径(水平方向, 两个椭圆共用)
		bd = 0,						--下椭圆短半径
		bu = 0,						--上椭圆半径
		cx = 0,						--椭圆中心X坐标
		cy = 0,						--椭圆中心Y坐标
	},
	---------------------------------------
	--cocostudio英雄所在的panel
	m_tbConfigTag = {
		P_TOP = "pnl_role1",			--Top
		P_LEFT = "pnl_role2",			--Left
		P_RIGHT = "pnl_role3",			--Right
	},
	
	m_pMainBtnLayer = nil,	--主按钮界面
}

KGC_MainView = class("KGC_MainView", KGC_UI_BASE_LAYER, TB_STRUCT_MAIN_VIEW)
------------------------------------------------------------------------------
function KGC_MainView:ctor()
    self:LoadScheme()
	
	self:inintButtonState();
	self:UpdateData();
	self:UpdateHeros();

	--经验特效
    af_expLoopEffectAnimation(self.m_BarExp)
end

-- 背景音乐
function KGC_MainView:playBackgroundMusic()
    AudioManager:getInstance():setBackgroundMusicVolume(0.6)	
    AudioManager:getInstance():playBackground("res/audio/background/audio_bg_main_01");
end

function KGC_MainView:inintButtonState()
	
	--商店
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_SHOP) then 
		self.m_BtnShop:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_BtnShop,true,2);
	else
		self.m_BtnShop:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_BtnShop,false,2);
	end

	--召唤新英雄
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_HANDBOOK) then 
		self.m_BtnHandbook:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_BtnHandbook,true,2);
	else
		self.m_BtnHandbook:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_BtnHandbook,false,2);
	end

	--打造系统
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_FORING) then 
		self.m_Btnblacksmith:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_Btnblacksmith,true,2);
	else
		self.m_Btnblacksmith:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_Btnblacksmith,false,2);
	end
end

function KGC_MainView:LoadScheme()	
	if not self.m_pLayout then
		cclog("[Error]主界面json界面没有加载成功！");
		return;
	end
	--英雄旋转	
	-----------------------------------------------------------------------
	--基本信息
	local pnlPlayerInfo = self.m_pLayout:getChildByName("pnl_playerinfo")
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

	self.m_TextPlayerName = ccui.Helper:seekWidgetByName(pnlPlayerInfo, "text_playername");
	self.m_TextPlayerName:setString(me:GetName());
	
	local fnTouchHead = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("Touch head ....................")
			-- TipsViewLogic:getInstance():addMessageTips(30000);
			dbf_SwitchFlag();
		end
	end
	pnlPlayerInfo:addTouchEventListener(fnTouchHead); 
	-----------------------------------------------------------------------
	--目标、活动、菜单、聊天
	--目标函数
	local fnTarget = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MISSION);
		end
	end
	
	local fnHandbook = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_MainViewLogic:getInstance():ReqHeroList(2);
		end
	end
	
	local fnShop = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_HERO_SHOP_LOGIC_TYPE:getInstance():ReqHeroShop(0);
		end
	end

	local fnActivity = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			-- TipsViewLogic:getInstance():addMessageTips(30000);
			local gm = GMView:create();
			self:addChild(gm);
		end
	end
	
	local fnTouch = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:SetRightButton(sender)
		end
	end

	local function fnChat(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_CHAT);
		end
	end

	local function fnBlacksmith(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FORGING)
		end
	end

	local function fnArena(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_ARENA_LOGIC_TYPE:getInstance():ReqArenaMain();
		end
	end

	local pnlRightButton = self.m_pLayout:getChildByName("pnl_rightbutton")
	self.m_BtnShop = pnlRightButton:getChildByName("btn_shop")				-- 商店面板
	self.m_BtnHandbook = pnlRightButton:getChildByName("btn_handbook")		-- 召唤英雄面板
	self.m_Btnblacksmith = pnlRightButton:getChildByName("btn_blacksmith")	-- 打造面板
	local btnArena = pnlRightButton:getChildByName("btn_arena")				-- 竞技场
	self.m_BtnMenu = pnlRightButton:getChildByName("btn_menu")				-- 菜单
	local pnlMenu = pnlRightButton:getChildByName("pnl_menulist");
	self.m_pnlMenuBtnList = pnlMenu:getChildByName("pnl_btnlist");
	
	self.m_BtnShop:addTouchEventListener(fnShop);
	self.m_BtnHandbook:addTouchEventListener(fnHandbook)
	self.m_Btnblacksmith:addTouchEventListener(fnBlacksmith)
	self.m_BtnMenu:addTouchEventListener(fnTouch);
	btnArena:addTouchEventListener(fnArena);
	
	-- 设置菜单下面所有按钮默认状态为收缩
	self.m_tbRightButtons[self.m_BtnMenu] = 1;
	-- local tbMenuTables = self:GetMenuTable(self.m_BtnMenu)
	--菜单下面的按钮
	local tbConfigMenus = l_tbConfigMenu.tbMenus;
	--注意：是ipairs
	for _, tbMenu in ipairs(tbConfigMenus) do
		local menu = self.m_pnlMenuBtnList:getChildByName(tbMenu[1])
		local fnMenu = function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				self:TouchMenu(sender)
			end
		end
		if menu then
			-- table.insert(tbMenuTables, menu)
			menu:addTouchEventListener(fnMenu);
		end
	end

	local pnlLeftButton = self.m_pLayout:getChildByName("pnl_leftbutton")
	local btnChat = pnlLeftButton:getChildByName("btn_chat")
	btnChat:addTouchEventListener(fnChat)
	-----------------------------------------------------------------------
	--英雄
	self.m_tbHeroPanels = {}
	local panelHeros = self.m_pLayout:getChildByName("pnl_role")
	self.m_PnlHeros = panelHeros;
	for i = 1, 3 do 
		local szName = "pnl_role" .. i
		local panel = panelHeros:getChildByName(szName)
		if panel then
			panel:setVisible(false);
			local nPos = i + 3;
			self.m_tbHeroPanels[nPos] = panel;
			local x, y = panel:getPosition();
			table.insert(self.m_tbPosHeros, cc.p(x, y));
			
			local fnTouchHero = function(sender, eventType)
				if eventType == ccui.TouchEventType.began then
					self:TouchHero(sender);
				end
			end
			panel:addTouchEventListener(fnTouchHero)
		end
	end
	
	self.m_tbPosDown = self.m_tbPosHeros[1]			--下面的英雄坐标
	self.m_tbPosLeft = self.m_tbPosHeros[2]			--左边英雄坐标
	self.m_tbPosRight = self.m_tbPosHeros[3]		--右边英雄坐标
	local tbData = self:GetEllipseData();
	tbData.a = self.m_tbPosDown.x - self.m_tbPosLeft.x
	tbData.bd = self.m_tbPosLeft.y - self.m_tbPosDown.y
	tbData.bu = 10
	tbData.cx = self.m_tbPosDown.x
	tbData.cy = self.m_tbPosLeft.y;
	
	local function onTouchBegan(touch, event)
        self:HeroTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
		self:HeroTouchMoved(touch, event)
	end
	
	local function onTouchEnded(touch, event)
		self:HeroTouchEnded(touch, event)
	end
	--英雄旋转
	-- local listener = cc.EventListenerTouchOneByOne:create();
	-- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    -- local eventDispatcher = self:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithFixedPriority(listener, -1)
	------------------------------------------------------------------------
	--test
	local onKeyPressed = function(keyCode, event)
		self:TestProcessKeyEvent(keyCode, event);
	end
	local listener = cc.EventListenerKeyboard:create();
	listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	
	-- 动画加上
	self:PlayUIAction("main.json", "starrolling")
	self:PlayUIAction("main.json", "cloudoverstar")
	self:PlayUIAction("main.json", "shiprolling")
	
	self:playBackgroundMusic();
    
    --创建主按钮
    self:AddMainButton();
end

function KGC_MainView:UpdateData()
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
	
	self:addExpEffect(self.m_BarExp,nPercent,self.m_BmpExp,nExp);
	self:addGoldEffect(self.m_BmpGold,nGold);
	
	self.m_BmpStep:setString(tostring(nAP))
	--self.m_BmpGold:setString(tostring(nGold))
	self.m_BmpLevel:setString(tostring(nLevel))
	self.m_BmpVIP:setString(tostring(nVIP))
	self.m_BmpDiamond:setString(tostring(nDiamond));
	self.m_BmpExp:setString(szExp)
	self.m_BarExp:setPercent(nPercent);
	self.m_BmpFightPoint:setString(nFightPoint);

	lableNumAnimation(self.m_BmpGold,nil,nGold,1);

	-- 更新提示
	self:UpdateRemind();
end

function KGC_MainView:UpdateHeros()
	--说明：这里直接从me对象拿出来的hero对象, 有区别战斗系统临时hero对象
	local tbHeros = me:GetHeros();
	print("UpdateHeros", #tbHeros)
	if #tbHeros <= 0 then
		cclog("[Warning]上阵英雄个数<=0, 检查pos字段是否无效");
		
		return;
	end
	-- for i, hero in ipairs(tbHeros) do
	for i = 1, 3 do
		local hero = tbHeros[i];
		local nPos = i + 3;
		-- local nPos = hero:GetPos();
		local panel = self.m_tbHeroPanels[nPos]
		if panel then
			if hero then
				panel:setVisible(true);
				panel:removeAllChildren(true);
				local armature = self:LoadHero(hero, panel)
				self:SetArmature(panel, armature)
			else
				panel:setVisible(false);
			end
		end
	end
end

function KGC_MainView:SetRightButton(widget)
	local nDistance = l_tbConfigMenu.nMainDistance
	local nTime = l_tbConfigMenu.nMainTime;
	
	if self.m_tbRightButtons[widget] == 1 then
		widget:setTouchEnabled(false)
		local call = function()
			widget:setTouchEnabled(true)
			self.m_tbRightButtons[widget] = 2
			--左移
			-- self:RunMenuAction(widget, l_tbConfigMenu.nTime, -1)
		end
		-- local moveBy = cc.MoveBy:create(nTime, cc.p(-1 * nDistance, 0))
		-- local action = cc.Sequence:create(moveBy, cc.CallFunc:create(call))
		-- widget:runAction(action)
		
		-- 下移
		local moveBy = cc.MoveBy:create(nTime, cc.p(0, -1 * nDistance));
		local action = cc.Sequence:create(moveBy, cc.CallFunc:create(call))
		self.m_pnlMenuBtnList:runAction(action);
		
	elseif self.m_tbRightButtons[widget] == 2 then
		widget:setTouchEnabled(false)
		local call = function()
			widget:setTouchEnabled(true)
			self.m_tbRightButtons[widget] = 1
			--右移
			-- self:RunMenuAction(widget, l_tbConfigMenu.nTime, 1)
		end
		-- local moveBy = cc.MoveBy:create(nTime, cc.p(nDistance, 0))
		-- local action = cc.Sequence:create(moveBy, cc.CallFunc:create(call))
		-- widget:runAction(action)
		
		-- 上移
		local moveBy = cc.MoveBy:create(nTime, cc.p(0, nDistance))
		local action = cc.Sequence:create(moveBy, cc.CallFunc:create(call))
		self.m_pnlMenuBtnList:runAction(action)
	end
end

--@function: 获取属于菜单下面的所有控件
function KGC_MainView:GetMenuTable(widget)
	if not self.m_tbMenuButtons then
		self.m_tbMenuButtons = {}
	end
	
	if not self.m_tbMenuButtons[widget] then
		self.m_tbMenuButtons[widget] = {};
	end
	
	return self.m_tbMenuButtons[widget];
end

--@function: 播放菜单下面按钮的动作
--@widget：菜单按钮对象
--@nTime：播放动作总体时间
--@nDir:方向(1-右;-1左)
function KGC_MainView:RunMenuAction(widget, nTime, nDir)
	local nDir = nDir or 1;
	local tbMenuTables = self:GetMenuTable(widget)
	if #tbMenuTables > 0 then
		local nTime = nTime or l_tbConfigMenu.nTime;
		local nInterval = nTime/#tbMenuTables;
		for i, w in ipairs(tbMenuTables) do
			w:setTouchEnabled(false)
			w:setVisible(true)
			local call = function()
				w:setTouchEnabled(true)
				if nDir == 1 then
					w:setVisible(false)
				end
			end
			local delay = cc.DelayTime:create((i-1) * nInterval)
			local moveBy = cc.MoveBy:create(nInterval, cc.p(l_tbConfigMenu.nDistance * nDir, 0))
			local action = cc.Sequence:create(delay, moveBy, cc.CallFunc:create(call))
			w:runAction(action)
		end
	end
end

function KGC_MainView:LoadHero(hero, pnlHero)
	local nModelID = hero:GetModelID();
	local armature = KGC_MODEL_MANAGER_TYPE:getInstance():CreateNpc(nModelID);
	
	if pnlHero and armature then
		--按比例缩放
		local armSize = armature:getContentSize();
		local pnlHeroSize = pnlHero:getContentSize();
		local rect = armature:getBoundingBox();
		local nScaleX = pnlHeroSize.width/rect.width;
		local scaleY = pnlHeroSize.height/rect.height;
		local nScale = nScaleX
		if scaleY > nScale then
			nScale = scaleY;
		end
		-- armature:setScale(nScale)
		-- page@2015/09/17 中间的要大一点
		local nPos = hero:GetPos();
		local nScale1, nScale2 = unpack(l_tbConfigMenu.tbScale or {1.8, 1.5});
		if nPos == 5 then
			armature:setScale(nScale1)
		else
			armature:setScale(nScale2)
		end
		pnlHero:addChild(armature, 1)
		
		armature:setPosition(cc.p(pnlHeroSize.width/2, 0));
	end
	
	if hero:IsHero() then
		armature:setAnimation(0, 'standby', true)
	end
	
	return armature;
end

--@function: 获取主界面的骨骼动画
function KGC_MainView:GetArmatures()
	if not self.m_tbArmatures then
		self.m_tbArmatures = {};
	end
	
	return self.m_tbArmatures;
end

--@function: 设置骨骼动画
function KGC_MainView:SetArmature(panel, armature)
	local tbArmatures = self:GetArmatures();
	tbArmatures[panel] = armature;
end

--@function: 设置骨骼动画
function KGC_MainView:GetArmature(panel)
	local tbArmatures = self:GetArmatures();
	return tbArmatures[panel]
end

function KGC_MainView:HeroTouchBegan(touch, event)
	self.m_tbHeroBeganPos = touch:getLocation();
	-- print("Began", self.m_tbHeroBeganPos)
end

function KGC_MainView:HeroTouchMoved(touch, event)
	local movPos = touch:getLocation();
	-- local judgePos = self:convertToNodeSpace(movPos)
	--以英雄面板作为滑动的区域
	local x, y = self.m_PnlHeros:getPosition();
	local size = self.m_PnlHeros:getContentSize();
	local rect = cc.rect(x, y, size.width, size.height);
	-- print(222, x, y, size.width, size.height, cc.rectContainsPoint(rect, movPos))
	if not cc.rectContainsPoint(rect, movPos) then
		if not self.m_bHRValid then
			self.m_bHRInValid = true;
		end
		return;
	end
	
	if not self.m_bHRInValid then
		self.m_bHRValid = true;
	else
		return;
	end
	
	--根据方向滑动
	local ratio = math.abs(movPos.x - self.m_tbHeroBeganPos.x) * 2 / size.width;
	if ratio >= 1 then
		--超出屏幕
		return;
	end
	-- self:RunSlideAt(bIsLeft, nRatio, judgeDistance)
end

function KGC_MainView:HeroTouchEnded(touch, event)
	
end

function KGC_MainView:RunSlideAt(bIsLeft, nRatio, judgeDistance)
	local pnlTop = self.m_PnlHeros:getChildByName(self.m_tbConfigTag.P_TOP)
	local pnlLeft = self.m_PnlHeros:getChildByName(self.m_tbConfigTag.P_LEFT)
	local pnlRight = self.m_PnlHeros:getChildByName(self.m_tbConfigTag.P_RIGHT)
	local size = self.m_PnlHeros:getContentSize();
	
	local tbPosDeltDown = self.m_tbPosLeft - self.m_tbPosDown;
	
	if judgeDistance > size.width/4 then
		pnlTop:setLocalZOrder(3);
		pnlLeft:setLocalZOrder((bIsLeft and 3) or 2);
		pnlRight:setLocalZOrder((bIsLeft and 2) or 3);
	end
	
	local x = (bIsLeft and (self.m_tbPosDown.x - nRatio * tbPosDeltDown.x)) or (self.m_tbPosDown.x + nRatio * tbPosDeltDown.x);
end

function KGC_MainView:GetEllipseData()
	if not self.m_tbEllipse then
		self.m_tbEllipse = {}
	end
	
	return self.m_tbEllipse;
end

--@function: 英雄升级
function KGC_MainView:UpdateLevel(nPos)
	local tbEffectConfig = af_GetEffectModifyInfo(1001) or {};
	local node = self.m_tbHeroPanels[nPos]
	if node and tbEffectConfig then
		local nEffectID, tbPos, nScale = unpack(tbEffectConfig);
		af_BindEffect2Node(node, nEffectID, {{0.5, 0}}, nScale, nil, {nil, 0})
	end
end

--@function: 设置底部按钮底框是否显示
function KGC_MainView:SetMenuBgVisible(bVisible)
	local bVisible = bVisible or false;
	local pnlMainButton = self.m_pLayout:getChildByName("pnl_mainbutton");
	local pnlBg = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_bg");
	if pnlBg then
		pnlBg:setVisible(bVisible);
	end
end

function KGC_MainView:TouchHero(widget)
	local tbAnimations = KGC_MODEL_MANAGER_TYPE:getInstance():GetAnimation();
	local szAnimation = tbAnimations[math.random(#tbAnimations)]
	
	local arm = self:GetArmature(widget)
	if arm then
		if arm._is_using then
			return;
		end
		
		-- 标记正在动作
		arm._is_using = true
		
		arm:registerSpineEventHandler(function (event)
			if event.animation == szAnimation then
				arm:setAnimation(0, "standby", true);
				arm._is_using = nil;
			end
		end, sp.EventType.ANIMATION_COMPLETE)
  
		arm:setAnimation(0, szAnimation, false)
	end
end

function KGC_MainView:TouchMenu(widget)
	if not widget then
		return;
	end
	local szName = widget:getName();
	if szName == "btn_mail" then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_EMAIL)
	end
end

---------------------------------------------------
-- *** 提示相关 ***

--@function: 重载父类函数
function KGC_MainView:OnUpdateRemind()
	-- 是否可以锻造
	if me:IsAbleForge() then
	
	else
	
	end
end
----------------------------------------------------------------------
--test
function KGC_MainView:TestEffect()
	-- if not self._testLayoutFight then
		local layout = KG_UIFight.new({bDebug = true});
		layout.m_FightHall = KGC_FightHall:getInstance()
		layout:LoadScheme();
		layout:TestEffect();
		layout:TestModel();
		local tbData = {
			{1, me},
			{2, nil},
		};
		layout:UpdateData(tbData);
		layout:UpdateView({1});
		self:addChild(layout)
		self._testLayoutFight = layout;
	-- else
		-- self._testLayoutFight:removeFromParent(true);
	-- end
end

function KGC_MainView:TestChangeHero()
	self:UpdateHeros();
	tst_print_textures_cache();
end

function KGC_MainView:TestOpenTestUI()
	 local layout = ccs.GUIReader:getInstance():widgetFromJsonFile("res/test_leak.json")
    self:addChild(layout)
	local btnClose = layout:getChildByName("btn_close");
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			layout:runAction(cc.RemoveSelf:create());
		end
	end
	btnClose:addTouchEventListener(fnClose);
	
	-- blend test
	local imgTest = layout:getChildByName("Image_24");
	imgTest:setVisible(false);
	local x, y = imgTest:getPosition();
	local sprite = cc.Sprite:create("res/ui/11_team/001_ob_03_1.png")
	layout:addChild(sprite);
	sprite:setPosition(cc.p(x+50, y));
	-- sprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	sprite:setBlendFunc(gl.ONE, gl.GL_ONE_MINUS_DST_COLOR)
	-- 特效
end

function KGC_MainView:TestTemp()
	-- 测试奖励界面
	-- local nRewardID = 10018;
	-- local nHPLeftRate = math.random(50)/100;
	-- local nGold, nExp, nExpTeam, nAP, nSign, nDropID  = KGC_REWARD_MANAGER_TYPE:getInstance():GetReward(nRewardID)
	-- local layer = KGC_UI_FIGHT_RESULT_LAYER_TYPE:create(self);
	-- layer:UpdateData(nWinner, nHPLeftRate, nSign, {nGold, nExp, nAP, tbItemObjs});
	
	-- 测试通关奖励界面
	-- local tbTestArg = {
		-- rewardid = 10018,
	-- }
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {1, tbTestArg})
	
	-- 通用奖励界面
	-- local tbCurrency = {
		-- ["gold"] = math.random(100);
		-- ["heroexp"] = math.random(100);
		-- ["masterscore"] = math.random(100);
	-- };
	-- print("1111111111111111111", KGC_REWARD_MANAGER_TYPE:getInstance().AddItem);
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency}});
	
	-- 新手boss
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 4})
	
	-- 召唤显示指定英雄
	-- KGC_MainViewLogic:getInstance():ReqHeroListNew({10013});
	
	-- 竞技场主面板
	-- local tbInfoNormal = {};
	-- local tbInfoDaily = {};
	-- local tbInfoWeekly = {};
	-- KGC_ARENA_FACTORY_TYPE:getInstance():UnpackData(tbInfoNormal, tbInfoDaily, tbInfoWeekly);
	
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA, {tbInfoNormal, tbInfoDaily, tbInfoWeekly});
	-- KGC_ARENA_LOGIC_TYPE:getInstance():ReqArenaMain();
	
	-- 属性变化
	-- TipsViewLogic:getInstance():addMessageDataChange({{}, {}, {}});
	
	-- 离线挂机奖励动画
	-- local tbItems = {};
	-- local tbItemIDs = {15205, 15206, 15501, 16001, 16002, 16003};
	-- for i = 1, math.random(15) do
		-- local nRand = math.random(#tbItemIDs);
		-- local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(tbItemIDs[nRand]);
		-- table.insert(tbItems, {item, math.random(999)});
	-- end
	-- KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():UpdateData(100, 200, 300, tbItems, 1000, true);
	
	-- 打印战斗需要的数据
	-- me:GetHerosFightInfo();
	
	-- 提示相关
	-- me:IsRemindTeam();
	
	-- 站前布阵界面
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP);
end

function KGC_MainView:addGoldEffect(pWidget,iNum)
	if iNum ~= tonumber(self.m_BmpGold:getString()) then 
		local EffectNode1 = af_GetEffectByID(60042);
		EffectNode1:setPositionY(25)
		EffectNode1:setPositionX(0)
		self.m_BmpGold:addChild(EffectNode1);
	end
end


function KGC_MainView:addExpEffect(m_BarExp,nPercent,pLable,nValue)
	if nPercent~= self.m_BarExp:getPercent() then 
		local EffectNode1 = af_GetEffectByID(60044);
		m_BarExp:addChild(EffectNode1);

		-- local EffectNode2 = af_GetEffectByID(60043);
		-- m_BarExp:addChild(EffectNode2);
	end
end

function KGC_MainView:TestProcessKeyEvent(keyCode, event)
	if keyCode == 138 then
		for _, panel in pairs(self.m_tbHeroPanels) do
			local n = panel:getBackGroundColorOpacity()
			if n > 0 then
				panel:setBackGroundColorOpacity(0)
			else
				panel:setBackGroundColorOpacity(50)
				-- getDebugBonesEnabled
				-- setDebugBonesEnabled
			end
			local armature = self:GetArmature(panel)
			if armature then
				if not armature:getDebugBonesEnabled() then
					armature:setDebugBonesEnabled(true)
					armature:setDebugSlotsEnabled(true)
					-- armature:setColor(cc.c3b(255, 0, 0))
				else
					armature:setDebugBonesEnabled(false)
					armature:setDebugSlotsEnabled(false)
					-- armature:setColor(cc.c3b(255, 255, 255))
				end
			end
		end
	elseif keyCode == cc.KeyCode.KEY_T then
		-- 测试
		print("test ... ")
		-- self:TestOpenTestUI();
		self:TestTemp();
	elseif keyCode == cc.KeyCode.KEY_DELETE then
		--self:TestEffect();
		local gm = GMView:create();
		self:addChild(gm);
	elseif keyCode == cc.KeyCode.KEY_F then

	elseif keyCode == cc.KeyCode.KEY_Q then
		g_Core:LoginOut();
	end
end