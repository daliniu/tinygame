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
	m_canLeave  = 	true,			--是否可退出，默认可以
	m_fightPnl	=	nil,			--战斗面板
	m_selfHpBar	=	nil,			--自己血条
	m_enemyHpBar=	nil,			--对方血条
	m_losePnl	=	nil,			--失败界面
	m_winPnl	=	nil,			--胜利界面
	m_rewardPnl = 	nil,			--奖励面板
	m_rewardEffectPnl = nil,		--奖励特效面板
	m_rewardList = 	nil,			--奖励list
	m_rewardItem=	nil,			--奖励item
	m_explorPnl = 	nil,			--探索面板
	m_countLbl 	=	nil,			--探索标签
	m_coverPnl	=	nil,			--蒙蔽面板
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
	
	-- 初始进度调
	local nPercent = me:GetAfkerRewardPercent() or 0;
	self:SetRewardProgress(0, nPercent);
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
    -- self.m_rewardBg = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_rewardbg") 

    --进度条
 --    local sprite = cc.Sprite:create("res/ui/05_mainUI/05_reward_bg_02.png")
 --    self.m_bar = cc.ProgressTimer:create(sprite)
 --    self.m_bar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
 --    self.m_bar:setPosition(cc.p(sprite:getContentSize().width / 2 + 11, sprite:getContentSize().height / 2 - 18))  
 --    self.m_bar:setRotation(-90)  
 --    self.m_bar:setMidpoint(cc.p(1 / 16, 0.5))
	-- self.m_rewardBg:addChild(self.m_bar)	  

    --奖励特效
    -- self.m_effectBg = ccui.Helper:seekWidgetByName(self.m_rewardBg, "pnl_effect")

    --向上特效
    self.m_upEffect = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_arrow")

    --按钮层
    self.m_btnPnl = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_mainbutton")

    --背景层
    self.m_pnlBg = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_bg")

    --战斗面板,自己血条,对方血条,失败界面,胜利界面
   	self.m_fightPnl	= ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_fighting")	
	self.m_selfHpBar = ccui.Helper:seekWidgetByName(self.m_fightPnl, "bar_myblood")		
	self.m_enemyHpBar =	ccui.Helper:seekWidgetByName(self.m_fightPnl, "bar_enemyblood")		
	self.m_losePnl = ccui.Helper:seekWidgetByName(self.m_fightPnl, "img_lose")	
	self.m_losePnl:setVisible(false)		
	self.m_winPnl =	ccui.Helper:seekWidgetByName(self.m_fightPnl, "img_win")		
	self.m_winPnl:setVisible(false)		
	self.m_fightPnl:setVisible(false)

	--奖励面板,奖励特效面板,奖励list,奖励item
	self.m_rewardPnl = 	ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_reward")		
	self.m_rewardEffectPnl = ccui.Helper:seekWidgetByName(self.m_rewardPnl, "pnl_effect")	
	self.m_rewardList = ccui.Helper:seekWidgetByName(self.m_rewardPnl, "list_reward")	
	self.m_rewardListOriY = self.m_rewardList:getPositionY()	
	self.m_rewardItem =	ccui.Helper:seekWidgetByName(self.m_rewardPnl, "img_reward")	
	self.m_rewardItem:setVisible(false)		
	self.m_rewardPnl:setVisible(false)

	--探索面板,探索标签
	self.m_explorPnl = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_explor")		
	self.m_countLbl = ccui.Helper:seekWidgetByName(self.m_explorPnl, "lbl_countdown")	
	self.m_explorPnl:setVisible(false)	

	--蒙蔽面板
	self.m_coverPnl = ccui.Helper:seekWidgetByName(self.m_pLayout, "pnl_cover")

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
		
		-- 切界面清资源
		-- cc.Director:getInstance():getTextureCache():removeUnusedTextures();
		-- print("****************************************2222");
		-- tst_print_textures_cache();
		-- print("****************************************2222");
    end
	
    local function btnMainEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		--在必须看完的战斗中无法退出
    		if self.m_isInFight and not self.m_canLeave then    			
    			TipsViewLogic:getInstance():addMessageTips(10002)
    			return
    		end
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
    		--在必须看完的战斗中无法退出
    		if self.m_isInFight and not self.m_canLeave then    			
    			TipsViewLogic:getInstance():addMessageTips(10002)
    			return
    		end
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
    		if curLayerId ~= GameSceneManager.LAYER_ID_HEROINFO then
    			if self.m_isInMap then
    			else
    				removeLastView(curLayerId)
    			end    			

				KGC_MainViewLogic:getInstance():ReqHeroList(1);
    		end
    	end
    end
    self.m_btnTeam:addTouchEventListener(btnTeamEvent)
    local function btnMapEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		--在必须看完的战斗中无法退出
    		if self.m_isInFight and not self.m_canLeave then    			
    			TipsViewLogic:getInstance():addMessageTips(10002)
    			return
    		end
    		local curLayerId = GameSceneManager:getInstance():getCurrentLayerID();
			if self.m_isInMap then
			else
				removeLastView(curLayerId)
			end 
			-- if me:GetLevel()<3 then
   --      		TipsViewLogic:getInstance():addMessageTips(30001);
   --      		return;
   --      	end
           --MapViewLogic:getInstance():openCurrentMap();
           MapChooseLogic:getInstance():reqMapInfo();
           --GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE)
    	end
    end
    self.m_btnMap:addTouchEventListener(btnMapEvent)
    local function btnBagEvent(sender, type)
    	if type == ccui.TouchEventType.ended then
    		--在必须看完的战斗中无法退出
    		if self.m_isInFight and not self.m_canLeave then    			
    			TipsViewLogic:getInstance():addMessageTips(10002)
    			return
    		end
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
    		--在必须看完的战斗中无法退出
    		if self.m_isInFight and not self.m_canLeave then    			
    			TipsViewLogic:getInstance():addMessageTips(10002)
    			return
    		end  
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
		if me:GetLevel() < 3 then
			self.m_upEffect:setVisible(false)
	    	self.m_dir = -1
	  --   	self.m_btnPnl:setPosition(cc.p(cc.p(0, -120)))
			-- self.m_pnlBg:setPosition(cc.p(0, -60))
			self.m_coverPnl:setVisible(true)
		else
			self.m_upEffect:setVisible(false)
	    	self.m_dir = 1	    	
	    	--初始先显示2秒，然后下落
	    	self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
	    		self:SwitchButtonState(-1) 
	    	end)))
		end		    	
		local function btnUpEvent(sender, type)
    		if type == ccui.TouchEventType.ended then
    			--在必须看完的战斗中无法退出
	    		if self.m_isInFight and not self.m_canLeave then    			
	    			TipsViewLogic:getInstance():addMessageTips(10002)
	    			return
	    		end
    			self:SwitchButtonState(1)
    		end
    	end
    	self.m_upEffect:addTouchEventListener(btnUpEvent)
    end   
end

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
	-- cclog("[SetRewardProgress]nTime(%s), nToPercent(%s)", tostring(nTime), tostring(nToPercent));
	-- if self.m_effect then
	-- 	self.m_effect:setVisible(false)
	-- end
	-- self.m_bar:stopAllActions()
	-- --注意：由于图片问题，此处要将0~100除以2作处理，50已是最大百分比
 --    self.m_bar:runAction(cc.Sequence:create(cc.ProgressTo:create(nTime, nToPercent / 2), cc.CallFunc:create(function()
 --    	if nToPercent == 100 then
 --    		if not self.m_effect then
 --    			self.m_effect = af_GetEffectByID(60067)
 --    			self.m_effect:setPosition(cc.p(33, 33))
 --    			self.m_effectBg:addChild(self.m_effect)
 --    		else
 --    			self.m_effect:setVisible(true)
 --    		end
 --    	else
 --    		if self.m_effect then
	--     		self.m_effect:removeFromParent(true)
	--     		self.m_effect = nil
	--     	end
 --    	end
 --    end)))
end

--切换向上按钮显示状态
function MainButtonLayer:SetUpBtnVisible(bVisible)
	-- self.m_upEffect:setVisible(bVisible)
end

function MainButtonLayer:SetCanLeave(bCanLeave)
	self.m_canLeave = bCanLeave
	if bCanLeave then
		-- self.m_btnPnl:setPosition(cc.p(cc.p(0, 0)))
		-- self.m_pnlBg:setPosition(cc.p(0, 0))
		self.m_coverPnl:setVisible(false)
	else
		-- self.m_btnPnl:setPosition(cc.p(cc.p(0, -120)))
		-- self.m_pnlBg:setPosition(cc.p(0, -60))
		self.m_coverPnl:setVisible(true)
	end
end

--切换按钮状态
function MainButtonLayer:SwitchButtonState(nDir, bForce)
	-- if self.m_dir == nDir then
	-- 	if bForce then
	-- 		self:stopAllActions()
	-- 	end
	-- 	return
	-- end
	-- self.m_dir = nDir
	-- if nDir == 1 then 			--向上
	-- 	self.m_btnPnl:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0, 0)), cc.CallFunc:create(function()
	-- 		--3秒后重新下落
	-- 		if not bForce then
	-- 			self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
	-- 				self:SwitchButtonState(-1)
	-- 			end)))
	-- 		end
	-- 	end)))
	-- 	self.m_pnlBg:runAction(cc.MoveTo:create(0.2, cc.p(0, 0)))
	-- 	self.m_upEffect:runAction(cc.Sequence:create(cc.FadeOut:create(0.2), cc.Hide:create()))
	-- elseif nDir == -1 then 		--向下
	-- 	self.m_btnPnl:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0, -120)), cc.CallFunc:create(function()
	-- 		self.m_upEffect:setVisible(true)
	-- 		self.m_upEffect:setOpacity(0)
	-- 		self.m_upEffect:runAction(cc.FadeIn:create(0.2))
	-- 	end)))
	-- 	self.m_pnlBg:runAction(cc.MoveTo:create(0.2, cc.p(0, -60)))
	-- end
	if bForce then
		-- self.m_btnPnl:setPosition(cc.p(cc.p(0, 0)))
		-- self.m_pnlBg:setPosition(cc.p(0, 0))
		self.m_coverPnl:setVisible(false)
	end
end

--@function: 更新提示
function MainButtonLayer:UpdateRemind()
	local pnlMain = self.m_btnPnl;
	if not pnlMain then
		return;
	end
	
	-- 队伍
	if self.m_btnTeam then
		local imgTeamRemind = self.m_btnTeam:getChildByName("img_redpoint");
		if me:IsRemindTeam() then
			imgTeamRemind:setVisible(true);
		else
			imgTeamRemind:setVisible(false);
		end
	end
end

function MainButtonLayer:StartSearch(nSearchT)
	self.m_fightPnl:setVisible(false)
	self.m_explorPnl:setVisible(true)
	self.m_rewardPnl:setVisible(false)
	self.m_countLbl:setString(nSearchT)
	local tAction = {}
	for i = nSearchT, 1, -1 do
		table.insert(tAction, cc.DelayTime:create(1))
		table.insert(tAction, cc.CallFunc:create(function()
			self.m_countLbl:setString(i - 1)
		end))
	end
	table.insert(tAction, cc.CallFunc:create(function()
		self.m_explorPnl:setVisible(false)
		self.m_winPnl:setVisible(false)
		self.m_losePnl:setVisible(false)
	end))
	self.m_countLbl:runAction(cc.Sequence:create(tAction))
end

function MainButtonLayer:SetFightHp(nSelfHp, nEnemyHp)
	self.m_fightPnl:setVisible(true)
	self.m_explorPnl:setVisible(false)
	self.m_rewardPnl:setVisible(false)
	local nTotal = nSelfHp + nEnemyHp
	self.m_selfHpBar:setPercent(math.floor(nSelfHp / nTotal * 100))
	self.m_enemyHpBar:setPercent(100 - math.floor(nSelfHp / nTotal * 100))
end

function MainButtonLayer:SetResult(bWin, tReward)
	self.m_fightPnl:setVisible(true)
	self.m_explorPnl:setVisible(false)
	self.m_rewardPnl:setVisible(true)
	if bWin then
		self.m_winPnl:setVisible(true)
		self.m_losePnl:setVisible(false)
	else
		self.m_winPnl:setVisible(false)
		self.m_losePnl:setVisible(true)
	end	
	self.m_rewardList:removeAllChildren()
	self.m_rewardList:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
		self.m_winPnl:setVisible(false)
		self.m_losePnl:setVisible(false)		
		if tReward then			
			local nGoldAdd = tReward[1] or 0;
			local nExpAdd = tReward[2] or 0;
			local tbObjs = tReward[3] or {};
			local nItem = 0
			if nGoldAdd and nGoldAdd > 0 then
				local item = self.m_rewardItem:clone()
				item:setVisible(true)
				local itemName = item:getChildByName("lbl_itemname")
				local itemNum = item:getChildByName("lbl_itemnum")
				itemName:setString("金币")
				itemNum:setString(nGoldAdd)
				self.m_rewardList:pushBackCustomItem(item)
				nItem = nItem + 1
			end
			if nExpAdd and nExpAdd > 0 then
				local item = self.m_rewardItem:clone()
				item:setVisible(true)
				local itemName = item:getChildByName("lbl_itemname")
				local itemNum = item:getChildByName("lbl_itemnum")
				itemName:setString("经验")
				itemNum:setString(nExpAdd)
				self.m_rewardList:pushBackCustomItem(item)
				nItem = nItem + 1
			end
			local l_tbItems = mconfig.loadConfig("script/cfg/pick/item")
			for i, v in ipairs(tbObjs) do
				local item = self.m_rewardItem:clone()
				item:setVisible(true)
				local itemName = item:getChildByName("lbl_itemname")
				local itemNum = item:getChildByName("lbl_itemnum")
				itemName:setString(l_tbItems[v[1]:GetID()].itemName)
				itemNum:setString(v[2])
				self.m_rewardList:pushBackCustomItem(item)
				nItem = nItem + 1
			end
			self.m_rewardList:setPositionY(self.m_rewardListOriY - (self.m_rewardList:getContentSize().height - nItem * self.m_rewardItem:getContentSize().height))
		end
	end)))	
end

----------------------------------------------
return MainButtonLayer;