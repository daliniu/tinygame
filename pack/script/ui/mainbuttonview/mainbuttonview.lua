--主按钮界面类

require("script/class/class_base_ui/class_base_layer")

MAIN_BUTTON_EVENT_PRIORITY = -2

local TB_STRUCT_MAIN_BUTTON_LAYER = {
	m_pLogic = nil, 
	m_pLayout = nil, 
	m_btnMain 	=	nil,			--主界面
	m_btnTeam 	=	nil,			--队伍
	m_btnMap	=	nil,			--地图界面
	m_btnBag	=	nil,			--背包界面
	m_btnAfker	=	nil,			--挂机界面
	m_btnEventListener = nil,		--按钮事件响应
	m_curTouchBtn = nil,			--当前点击按钮
	m_isInMap	=	false,			--是否在地图内
	m_isInFight = 	false,			--是否在战斗内
	m_rewardBg	= 	nil,			--奖励背景
	m_bar 		= 	nil,			--进度条
	m_effectBg	= 	nil,			--奖励特效背景
	m_effect 	=	nil,			--奖励特效
	m_upEffect	= 	nil,			--向上特效
	m_dir		=	nil,			--按钮状态,1为上，-1为下
	m_btnPnl	=	nil,			--按钮层
	m_pnlBg		=	nil,			--背景层
}

MainButtonLayer = class("MainButtonLayer", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_MAIN_BUTTON_LAYER)

function MainButtonLayer:create(isInMap, isInFight)
	local pLayer = MainButtonLayer.new(isInMap, isInFight)
	return pLayer
end

function MainButtonLayer:ctor(isInMap, isInFight)
	self.m_isInMap = isInMap or false
	self.m_isInFight = isInFight or false

	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_MAIN_BUTTON_PATH)
	self:addChild(self.m_pLayout)
	self:initUI()
end

function MainButtonLayer:initUI()
	--主界面
    self.m_btnMain = ccui.Helper:seekWidgetByName(self.m_pLayout, "btn_mainui")
   
    --队伍    
    self.m_btnTeam = ccui.Helper:seekWidgetByName(self.m_pLayout, "btn_team")

    --世界探索界面    
   	self.m_btnMap = ccui.Helper:seekWidgetByName(self.m_pLayout, "btn_adventure")
	
	--背包按钮
    self.m_btnBag = ccui.Helper:seekWidgetByName(self.m_pLayout, "btn_bag")
	
	-- 挂机战斗按钮
    self.m_btnAfker = ccui.Helper:seekWidgetByName(self.m_pLayout, "btn_onhook")   

    --奖励面板
    self.m_rewardBg = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_rewardbg") 

    --进度条
    local sprite = cc.Sprite:create("res/ui/05_mainUI/05_reward_bg_02.png")
    self.m_bar = cc.ProgressTimer:create(sprite)
    self.m_bar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.m_bar:setPosition(cc.p(sprite:getContentSize().width / 2 + 11, sprite:getContentSize().height / 2 - 18))  
    self.m_bar:setRotation(-90)  
    self.m_bar:setMidpoint(cc.p(1 / 16, 0.5))
	self.m_rewardBg:addChild(self.m_bar)	  

    --奖励特效
    self.m_effectBg = ccui.Helper:seekWidgetByName(self.m_rewardBg, "pnl_effect")

    --向上特效
    self.m_upEffect = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_arrow")

    --按钮层
    self.m_btnPnl = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_mainbutton")

    --背景层
    self.m_pnlBg = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_bg")

    --初始化按钮状态
    self:initButtonState()
    --添加按钮事件
    self:addButtonEvent()
end

function MainButtonLayer:addButtonEvent()
	--处理前一界面关闭问题
    local function removeLastView(curLayerId)
		local _, curLayerLogic = GameSceneManager:getInstance():getCurrentLayerID();
		if curLayerId == GameSceneManager.LAYER_ID_MAIN then
		elseif curLayerId == GameSceneManager.LAYER_ID_HEROINFO then
			KGC_HERO_LIST_LOGIC_TYPE:getInstance():closeLayer()
		elseif curLayerId == GameSceneManager.LAYER_ID_MAPCHOOSE then
			MapChooseLogic:getInstance():closeLayer()
		elseif curLayerId == GameSceneManager.LAYER_ID_BAG then
			KGC_BagViewLogic:getInstance():closeLayer()
		elseif curLayerId == GameSceneManager.LAYER_ID_FIGHT then
		elseif curLayerId == GameSceneManager.LAYER_ID_FORGING then
			ForgingLogic:getInstance():closeLayer()
		else
			if curLayerLogic then
				curLayerLogic:closeLayer();
			end
		end
    end
	
    local function btnMainEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
    		if curLayerId ~= GameSceneManager.LAYER_ID_MAIN then
    			if self.m_isInMap then
    				MapViewLogic:getInstance():hideLayer()
    			else
    				removeLastView(curLayerId)
    			end    			
    			GameSceneManager:getInstance():ShowLayer(GameSceneManager.LAYER_ID_MAIN)
    		end
    	end
    end
    self.m_btnMain:addTouchEventListener(btnMainEvent)
    local function btnTeamEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
    		if curLayerId ~= GameSceneManager.LAYER_ID_HEROINFO then
    			if self.m_isInMap then
    			else
    				removeLastView(curLayerId)
    			end    			
    			if not DEBUG_CLOSED_NETWORK then
					KGC_MainViewLogic:getInstance():ReqHeroList();
				else
					KGC_MainViewLogic:getInstance():RspHeroList();
				end
    		end
    	end
    end
    self.m_btnTeam:addTouchEventListener(btnTeamEvent)
    local function btnMapEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
			if self.m_isInMap then
			else
				removeLastView(curLayerId)
			end 
			if me:GetLevel()<3 then
        		TipsViewLogic:getInstance():addMessageTips(30001);
        		return;
        	end
           MapViewLogic:getInstance():openCurrentMap();
    	end
    end
    self.m_btnMap:addTouchEventListener(btnMapEvent)
    local function btnBagEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
    		if curLayerId ~= GameSceneManager.LAYER_ID_BAG then
    			if self.m_isInMap then
    			else
    				removeLastView(curLayerId)
    			end 
    			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_BAG)
    		end
    	end
    end
    self.m_btnBag:addTouchEventListener(btnBagEvent)
    local function btnAfkerEvent(sender, type)
    	if type == ccui.TouchEventType.ended then    
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();	
			if self.m_isInMap then
			else
				removeLastView(curLayerId)
			end   			
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)    			    			
    	end
    end
    self.m_btnAfker:addTouchEventListener(btnAfkerEvent)

    if self.m_isInFight then
    	local effect = af_GetEffectByID(60083)
    	effect:setPosition(cc.p(self.m_upEffect:getContentSize().width / 2, self.m_upEffect:getContentSize().height / 2))
		self.m_upEffect:addChild(effect)		
    	self.m_upEffect:setVisible(false)
    	self.m_dir = 1
    	local function btnUpEvent(sender, type)
    		if type == ccui.TouchEventType.ended then
    			self:SwitchButtonState(1)
    		end
    	end
    	self.m_upEffect:addTouchEventListener(btnUpEvent)
    	--初始先显示2秒，然后下落
    	self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
    		self:SwitchButtonState(-1) 
    	end)))
    end   
end

--添加底部按钮点击事件
-- function MainButtonLayer:addButtonEvent()
-- 	if self.m_btnEventListener then
-- 		return
-- 	end

-- 	--判断是否在点击范围
-- 	local function hitTest(node, point)
-- 		local pos = node:convertToNodeSpace(point)
-- 		local size = node:getContentSize()
-- 		return cc.rectContainsPoint(cc.rect(0, 0, size.width, size.height), pos)
-- 	end

-- 	local function onTouchBegan(touch, event)
-- 		--判断是否有sublayer类的2级界面，有的话不捕捉触摸
-- 		if GameSceneManager:getInstance():getCurrentLayer() and #GameSceneManager:getInstance():getCurrentLayer():GetSubLayers() ~= 0 then
-- 			return false
-- 		end
-- 		self.m_curTouchBtn = nil
-- 		local point = touch:getLocation()
-- 		if hitTest(self.m_btnMain, point) then
-- 			self.m_curTouchBtn = self.m_btnMain			
-- 		elseif hitTest(self.m_btnTeam, point) then
-- 			self.m_curTouchBtn = self.m_btnTeam
-- 		elseif hitTest(self.m_btnMap, point) then
-- 			self.m_curTouchBtn = self.m_btnMap
-- 		elseif hitTest(self.m_btnBag, point) then
-- 			self.m_curTouchBtn = self.m_btnBag
-- 		elseif hitTest(self.m_btnAfker, point) then
-- 			self.m_curTouchBtn = self.m_btnAfker
-- 		end
-- 		if self.m_curTouchBtn then
-- 			self.m_curTouchBtn:setHighlighted(true)
-- 			return true
-- 		end
-- 		return false
--     end
--     local function onTouchMoved(touch, event)
--     	local point = touch:getLocation()
-- 		if self.m_curTouchBtn and not hitTest(self.m_curTouchBtn, point) then
-- 			self.m_curTouchBtn:setHighlighted(false)
-- 		end
-- 	end
-- 	local function onTouchCancelled(touch, event)
-- 		if self.m_curTouchBtn then
-- 			self.m_curTouchBtn:setHighlighted(false)
-- 			self.m_curTouchBtn = nil
-- 		end
-- 	end
-- 	local function onTouchEnded(touch, event)
-- 		local point = touch:getLocation()
-- 		if self.m_curTouchBtn and hitTest(self.m_curTouchBtn, point) then
-- 			local curLayerId = GameSceneManager:getInstance().currentLayerIndex					
-- 			--处理前一界面关闭问题
-- 			if curLayerId == GameSceneManager.LAYER_ID_MAIN and self.m_curTouchBtn ~= self.m_btnMain then
-- 			elseif curLayerId == GameSceneManager.LAYER_ID_HEROINFO and self.m_curTouchBtn ~= self.m_btnTeam then
-- 				KGC_HERO_LIST_LOGIC_TYPE:getInstance():closeLayer()
-- 			elseif curLayerId == GameSceneManager.LAYER_ID_MAPCHOOSE and self.m_curTouchBtn ~= self.m_btnMap then
-- 				MapChooseLogic:getInstance():closeLayer()
-- 			elseif curLayerId == GameSceneManager.LAYER_ID_BAG and self.m_curTouchBtn ~= self.m_btnBag then
-- 				KGC_BagViewLogic:getInstance():closeLayer()
-- 			elseif curLayerId == GameSceneManager.LAYER_ID_FIGHT and self.m_curTouchBtn ~= self.m_btnAfker then
-- 			end
-- 			if self.m_curTouchBtn == self.m_btnMain and curLayerId ~= GameSceneManager.LAYER_ID_MAIN then
-- 				GameSceneManager:getInstance():ShowLayer(GameSceneManager.LAYER_ID_MAIN);
-- 			elseif self.m_curTouchBtn == self.m_btnTeam and curLayerId ~= GameSceneManager.LAYER_ID_HEROINFO then
-- 				if not DEBUG_CLOSED_NETWORK then
-- 					KGC_MainViewLogic:getInstance():ReqHeroList();
-- 				else
-- 					KGC_MainViewLogic:getInstance():RspHeroList();
-- 				end
-- 			elseif self.m_curTouchBtn == self.m_btnMap and curLayerId ~= GameSceneManager.LAYER_ID_MAPCHOOSE then
-- 				if me:GetLevel()<3 then
-- 	        		TipsViewLogic:getInstance():addMessageTips(30001);
-- 	        		return;
-- 	        	end
-- 	           	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE)
-- 			elseif self.m_curTouchBtn == self.m_btnBag and curLayerId ~= GameSceneManager.LAYER_ID_BAG then
-- 		        GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_BAG)
-- 			elseif self.m_curTouchBtn == self.m_btnAfker and curLayerId ~= GameSceneManager.LAYER_ID_FIGHT then
-- 				GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
-- 			end			
-- 			self.m_curTouchBtn:setHighlighted(false)
-- 			self.m_curTouchBtn = nil
-- 		end
-- 	end
-- 	self.m_btnEventListener = cc.EventListenerTouchOneByOne:create();
-- 	self.m_btnEventListener:setSwallowTouches(true)
-- 	self.m_btnEventListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
--     self.m_btnEventListener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
--     self.m_btnEventListener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
--     local eventDispatcher = self:getEventDispatcher()
--     eventDispatcher:addEventListenerWithFixedPriority(self.m_btnEventListener, MAIN_BUTTON_EVENT_PRIORITY)
-- end

function MainButtonLayer:removeButtonEvent()
	if self.m_btnEventListener then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.m_btnEventListener)
		self.m_btnEventListener = nil
	end
end

function MainButtonLayer:showView()
	self:setVisible(true)
	self:addButtonEvent()
end

function MainButtonLayer:hideView()
	self:setVisible(false)
	self:removeButtonEvent()
end

function MainButtonLayer:initButtonState()
	--队伍系统
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_TEAM) then 
		self.m_btnTeam:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_btnTeam,true,2);
	else
		self.m_btnTeam:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_btnTeam,false,2);
	end


	--探索系统
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_MAP) then 
		self.m_btnMap:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_btnMap,true,2);
	else
		self.m_btnMap:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_btnMap,false,2);
	end


	--背包系统
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_BAG) then 
		self.m_btnBag:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_btnBag,true,2);
	else
		self.m_btnBag:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_btnBag,false,2);
	end

	--挂机系统
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_AFK) then 
		self.m_btnAfker:setTouchEnabled(true);
		SystemOpen:getInstance():fun_updateLock(self.m_btnAfker,true,2);
	else
		self.m_btnAfker:setTouchEnabled(false);
		SystemOpen:getInstance():fun_updateLock(self.m_btnAfker,false,2);
	end
end

--设置奖励进度
--nTime：动作时间
--nToPercent：结束百分比
function MainButtonLayer:SetRewardProgress(nTime, nToPercent)	
	if self.m_effect then
		self.m_effect:setVisible(false)
	end
	self.m_bar:stopAllActions()
	--注意：由于图片问题，此处要将0~100除以2作处理，50已是最大百分比
    self.m_bar:runAction(cc.Sequence:create(cc.ProgressTo:create(nTime, nToPercent / 2), cc.CallFunc:create(function()
    	if nToPercent == 100 then
    		if not self.m_effect then
    			self.m_effect = af_GetEffectByID(60067)
    			self.m_effect:setPosition(cc.p(33, 33))
    			self.m_effectBg:addChild(self.m_effect)
    		else
    			self.m_effect:setVisible(true)
    		end
    	else
    		if self.m_effect then
	    		self.m_effect:removeFromParent(true)
	    		self.m_effect = nil
	    	end
    	end
    end)))
end

--切换按钮状态

function MainButtonLayer:SwitchButtonState(nDir, bForce)
	if self.m_dir == nDir then
		if bForce then
			self:stopAllActions()
		end
		return
	end
	self.m_dir = nDir
	if nDir == 1 then 			--向上
		self.m_btnPnl:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0, 0)), cc.CallFunc:create(function()
			--3秒后重新下落
			if not bForce then
				self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
					self:SwitchButtonState(-1)
				end)))
			end
		end)))
		self.m_pnlBg:runAction(cc.MoveTo:create(0.2, cc.p(0, 0)))
		self.m_upEffect:runAction(cc.Sequence:create(cc.FadeOut:create(0.2), cc.Hide:create()))
	elseif nDir == -1 then 		--向下
		self.m_btnPnl:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0, -120)), cc.CallFunc:create(function()
			self.m_upEffect:setVisible(true)
			self.m_upEffect:setOpacity(0)
			self.m_upEffect:runAction(cc.FadeIn:create(0.2))
		end)))
		self.m_pnlBg:runAction(cc.MoveTo:create(0.2, cc.p(0, -60)))
	end
end