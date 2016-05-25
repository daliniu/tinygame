----------------------------------------------------------
-- file:	uibase.lua
-- Author:	page
-- Time:	2015/05/20 (5.20-->qm ^_^)
-- Desc:	技能表现单独抽出来
--			
----------------------------------------------------------
require ("script/ui/publicview/uiskill/uieffect")
require ("script/lib/actionfunctions")

local l_tbSkillCastRet = def_GetSkillCastRetData();
local l_tbCondID, l_tbCondName = def_GetConditionData();
local l_tbSkillScope, l_tbSSName = def_GetSkillScopeData()
local l_tbEffect = def_GetEffectType();
local l_tbSkillType, l_tbSkillTypeName = def_GetSkillTypeData();

--！！！
--注意：类名还是KGC_SKILL_BASE_TYPE
--！！！

function KGC_SKILL_BASE_TYPE:UpdateHP(nTurn, uiLayer, tbRetDef, fnCallBack)
	-- 回调函数必须调用一次
	local bFlag = false;
	print("UpdateHP ... ", #(tbRetDef or {}));
	for _, defend in pairs(tbRetDef) do
		local nCamp, nDefnedPos = defend:GetKey()
		-- local nCurHP, nMaxHP, nDamage = defend:GetDamage()
		bFlag = true;
		local data = defend:GetData();
		print("[log]更新血量@KGC_SKILL_BASE_TYPE:UpdateHP, data", data);
		if data then
			nTimes, nCurHP, nMaxHP, nDamage = data:GetDamage();
			cclog("UpdateHP:阵营(%d), 位置(%d), 当前血量(%d), 总血量(%d), 伤害(%d)", nCamp, nDefnedPos, nCurHP, nMaxHP, nDamage)

			nDamage = -nDamage;
			
			self:CreateBloodEffect(defend, uiLayer, nDamage)
			--依旧放最后吧，死亡的话，控件也删掉了
			uiLayer:UpdateHP(nCamp, nDefnedPos, nCurHP, nMaxHP, nDamage, nTurn, fnCallBack)
		else
			fnCallBack();
		end
	end

	if not bFlag then
		fnCallBack();
	end
end

function KGC_SKILL_BASE_TYPE:PlayAnimation(tbRetLau, tbRetDef, tbRetState, uiLayer, fnCallBack, nCastRet, nTurn)
	--test
	-- if DEBUG_MEMORY_LEAK then
	if false then
		fnCallBack(uiLayer);
		return;
	end
	--test end
	print("PlayAnimation - nCastRet", nCastRet, #tbRetLau, #tbRetDef)
	local tbArg = {self, tbRetLau, tbRetDef, tbRetState, uiLayer}
	local bMove = false;
	-- local lau = self:GetLauncher();
	local lau = self:GetCaster();
	if lau:GetHeroObj():IsSummon() then
		bMove = true;
	end
	
	local nCount = 0;
	local fnAfterAttack = function()
		nCount = nCount + 1;
		print("fnAfterAttack - nCount", nCount)
		if nCount == 1 then
			self:UIRunAfterAttack(tbRetLau, tbRetDef, uiLayer, fnCallBack);
		else
			self:UIRunAfterAttack(tbRetLau, tbRetDef, uiLayer);
		end
	end
	
	local fnRunDefend = function()
		self:UIRunDefend(nTurn, tbRetLau, tbRetDef, tbRetState, uiLayer, fnAfterAttack)
	end
	
	local fnRunAttack = function(fnMoveBack)
		self:UIRunAttack(tbRetLau, uiLayer, fnRunDefend, fnMoveBack, nCastRet);
		-- self:UIRunAttack(tbRetLau, uiLayer, fnAfterAttack, fnMoveBack, nCastRet);
	end
	
	local fnRunMove = function()
		self:UIRunMove(tbRetLau, tbRetDef, uiLayer, fnRunAttack)
	end
	
	local fnRunAfterStart = function()
		--触发类技能也不需要移动
		if bMove and self:GetCastType() ~= 1 then
			fnRunMove();
		else
			fnRunAttack();
		end
	end

	self:UIStartEffect(nCastRet, tbRetLau, uiLayer, fnRunAfterStart)
end

function KGC_SKILL_BASE_TYPE:OnUIStartEffect(nCastRet, tbRetLau, uiLayer, fnCallBack)
end

function KGC_SKILL_BASE_TYPE:UIStartEffect(nCastRet, tbRetLau, uiLayer, fnCallBack)
	print("[延时]开始特效 ............................ ", self:GetName(), os.time())
	local nLayerID = uiLayer:GetLayerID();		-- for 特效
	local lau = self:GetRetLau(tbRetLau)
	local nCamp, nPos = lau:GetKey()
	local npc = lau:GetNpc()
	
	local nCastRet = nCastRet or 0;
	if npc:GetHeroObj():IsHero() then
		uiLayer:ShowCover(nCamp, nPos);
	end
	
	local szName = "pnl_skillname_" .. nCamp
	local pnlSkillName = ccui.Helper:seekWidgetByName(uiLayer.m_Layout, szName);
	if pnlSkillName then
		local imgSkillIcon = ccui.Helper:seekWidgetByName(pnlSkillName, "img_skillicon");
		local txtSkillName = ccui.Helper:seekWidgetByName(pnlSkillName, "text_skillname");
		local txtSkillDesc = ccui.Helper:seekWidgetByName(pnlSkillName, "text_skillinfo");
		local textSkillCost = ccui.Helper:seekWidgetByName(pnlSkillName, "bmp_skillcost");
		-- print("***技能名字***：", self:GetName())
		if txtSkillName then
			txtSkillName:setString(self:GetName())
		end
		if txtSkillDesc then
			txtSkillDesc:setString(self:GetDesc())
		end

		local szIcon = self:GetIcon()
		if szIcon ~= 0 then
			imgSkillIcon:loadTexture(szIcon)
		end
		
		--cost
		if textSkillCost then
			local szCost = tostring(self:GetCost());
			textSkillCost:setString(szCost);
		end
	end
	
	local fnCallEnd = function()
		print("[log]开始特效播放完毕，回调下一个 ... ")
		if pnlSkillName then
			pnlSkillName:setVisible(true)
		end
		uiLayer:HideCover(nCamp, nPos);
		fnCallBack();
	end
					
	--多重施法要求加速播放
	local nSpeed = uiLayer:GetPlaySpeed();
	cc.Director:getInstance():getScheduler():setTimeScale(nSpeed)
	if nCastRet == l_tbSkillCastRet.RETRY then			--触发连携特效不一样
		print("[延时]触发连携 ............................ ", os.time())
		local src = self:GetSrcInfo()[1];
		
		uiLayer:PlayEffect(1, {nCamp, nPos, src}, fnCallEnd)
		if pnlSkillName then
			pnlSkillName:setVisible(true)
		end
	elseif nCastRet == l_tbSkillCastRet.MAGIC then		--多重施法特效
		cc.Director:getInstance():getScheduler():setTimeScale(nSpeed * 1.5)
		fnCallEnd();
	else
		if self:GetCastType() == 1 then					--触发技能条件ID
			local wtMark = uiLayer:GetMarkWidget(nCamp, nPos)
			af_BindEffect2Node(wtMark, 20001, nil, nil, fnCallEnd, {nil, nil, nLayerID})
		else											--正常技能
			if npc:GetHeroObj():IsHero() then
				local fnCall = function()
					local szAction = "skillname_" .. nCamp
					if pnlSkillName then
						fnCallEnd();
						--技能名字pnlSkillName的特效
						-- ccs.ActionManagerEx:getInstance():playActionByName("fight.json", szAction)
					else
						fnCallEnd();
					end
				end
				--随机特效
				uiLayer:RandomPlaceByPoint(nCamp, nPos, fnCall);
			else
				local _, nodeLau = uiLayer:GetHeroInfo(nCamp, nPos)
				local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(fnCallEnd));
				nodeLau:runAction(action)
			end
		end
	end
end

function KGC_SKILL_BASE_TYPE:MiddleEffect()
end

function KGC_SKILL_BASE_TYPE:EndEffect()
end

function KGC_SKILL_BASE_TYPE:UIRunMove(tbRetLau, tbRetDef, uiLayer, funRunAttack)
	print("[Log]开始移动 UIRunMove ... ")
	local campLau, posLau = tbRetLau[1]:GetKey()
	local campDef, posDef = tbRetDef[1]:GetKey()
	local nodeDef = uiLayer:GetNode(campDef, posDef);
	local nodeLau = uiLayer:GetNode(campLau, posLau);
	local posNodeLau = nodeLau:convertToWorldSpace(cc.p(0,0))
	local posNodeDef = nodeDef:convertToWorldSpace(cc.p(0, 0))
	local sizeLau = nodeLau:getContentSize()
	local sizeDef = nodeDef:getContentSize()
	local distanceX = posNodeDef.x - posNodeLau.x  + sizeLau.width/2
	local distanceY = posNodeDef.y - posNodeLau.y - 50
	local posLauX, posLauY = nodeLau:getPosition();
	local place = cc.Place:create(cc.p(posLauX + distanceX, posLauY + distanceY));
	local scaleOld = nodeLau:getScale();
	local scale = sizeDef.width/sizeLau.width
	local nLayerID = uiLayer:GetLayerID();		-- for 特效
	
	--notify: Place是没有reverse的
	local fnPlace = function()
		nodeLau:setPosition(cc.p(posLauX + distanceX, posLauY + distanceY))
		nodeLau:setScale(scale)
		uiLayer:ChangePanelOrder(campLau)
	end
	local placeReverse = cc.Place:create(cc.p(posLauX, posLauY));
	local fnMoveBack = function()
		nodeLau:setPosition(cc.p(posLauX, posLauY))
		nodeLau:setScale(scaleOld)
	end
	local fnNextStep = function()
		funRunAttack(fnMoveBack);
	end
	
	--增加消失动作(看策划逻辑图)
	local arm = uiLayer:GetArmature(campLau, posLau)
	cclog("[Log]没有骨骼动画....@UIRunMove(campLau:%s, posLau:%s)", tostring(campLau), tostring(posLau))
	local fnCallBack = function()
		nodeLau:setVisible(false)
		
		local fnCall = function()
			local fnSetVisible = function()
				nodeLau:setVisible(true)
			end
			local action = cc.Sequence:create(cc.CallFunc:create(fnPlace), cc.CallFunc:create(fnSetVisible), cc.DelayTime:create(0.5), cc.CallFunc:create(fnNextStep));
			nodeLau:runAction(action)
		end
		local node = uiLayer:GetStillNode(campLau, posLau);
		af_BindEffect2Node(node, 10006, nil, nil, fnCall, {nil, nil, nLayerID});
	end
	
	local szAnimation = "disappear"
	-- local szAnimation = "standby"
	local function fnAnimationEvent(armatureBack,movementType,movementID)
		if movementID ~= szAnimation then
			return;
		end
		if movementType == ccs.MovementEventType.complete then
			arm:getAnimation():play("standby")
			fnCallBack();
		end
	end
	
	local function fnSpineAnimationEvent(event)
		if event.animation == szAnimation then
			arm:addAnimation(0, 'standby', true)
			fnCallBack();			--界面灰层去掉
			-- print("[unregisterSpineEventHandler] 3")
			-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
		end
	end
	
	if arm then
		if arm.getAnimation then
			arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
		else
			print("[registerSpineEventHandler] 1", szAnimation)
			arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
		end

		if arm.getAnimation then
			arm:getAnimation():play(szAnimation)
		else
			arm:setAnimation(0, szAnimation, false)
		end
	end
end

function KGC_SKILL_BASE_TYPE:GetBulletDistanceAndScale(tbArg, nSecond)
	local self, tbLauncher, tbDefend, tbRetState, uiLayer = unpack(tbArg)
	
	local campLau, posLauncher = tbLauncher[1]:GetKey()
	local campDef, posDefend = tbDefend[1]:GetKey()
	--move
	local launcher, widgetLau = uiLayer:GetHeroInfo(campLau, posLauncher)
	local defend, widgetDef = uiLayer:GetHeroInfo(campDef, posDefend)
	local sizeLau = widgetLau:getContentSize()
	local sizeDef = widgetDef:getContentSize()

	local pointLau = widgetLau:convertToWorldSpace(cc.p(0,0))
	local pointDef = widgetDef:convertToWorldSpace(cc.p(0, 0))
	local pointCenter = cc.p(pointDef.x, pointLau.y + (pointDef.y-pointLau.y)/2)
	
	local sizeLau = widgetLau:getContentSize()
	local sizeDef = widgetDef:getContentSize()
	
	--local pointBullet = cc.pAdd(pointCenter, cc.p(sizeLau.width/2, sizeLau.height/2))
	--只是算距离的话，先不需要计算子弹的具体位置(偏移量)
	local pointBullet = pointCenter;
	--pointDef = cc.pAdd(pointDef, cc.p(sizeDef.width/2, sizeDef.height/2))
	local pointDistance = cc.pSub(pointDef, pointBullet)
	pointDistance.x = 0;
	if pointDistance.y > 0 then
		pointDistance.y = pointDistance.y + 100
	elseif pointDistance.y < 0 then
		pointDistance.y = pointDistance.y - 100
	end

	local moveBy = cc.MoveBy:create(nSecond, pointDistance);
	local spaMoveScale = cc.Spawn:create(moveBy)

	return spaMoveScale;
end

function KGC_SKILL_BASE_TYPE:UIRunAttack(tbRetLau, uiLayer, fnAfterAttack, fnMoveBack, nCastRet)
	print("[延时]开始攻击释放动作 ............................ ", os.time())
	local lau = self:GetRetLau(tbRetLau);
	if not lau then
		cclog("[Error]攻击者来源没有找到！@KGC_SKILL_CONTRACT_TYPE.RunAttack")
		return;
	end
	--更新费用
	local nCamp, nPos = lau:GetKey();
	local tbCost = {}
	tbCost[nCamp] = lau:GetCost();

	-- print("[费用]释放结果为:", nCastRet)
	if nCastRet ~= l_tbSkillCastRet.MAGIC then
		uiLayer:UpdateCost(tbCost)
	end
	
	local fnCallBack = function()
		--界面灰层去掉
		uiLayer:HideCover(nCamp, nPos);
		--删掉多重施法脚底特效
		if nCastRet == l_tbSkillCastRet.MAGIC then		--多重施法特效
			self:UIRemoveEffect(20002);
		end
		
		fnAfterAttack();
		-- print("[延时]攻击动作完成 ............................ ", os.time())
	end

	if lau then
		local nCamp, nPos = lau:GetKey()
		local arm = uiLayer:GetArmature(nCamp, nPos)
		-- local lauObj = self:GetLauncher():GetHeroObj()
		local lauObj = self:GetCaster():GetHeroObj()
		local szAnimation = self:UIGetAnimation("attack");
		print("szAnimation = ", szAnimation)
		local function fnAnimationEvent(armatureBack,movementType,movementID)
			-- print("fnAnimationEvent", armatureBack,movementType,movementID, szAnimation)
			if movementID ~= szAnimation then
				return;
			end
			if movementType == ccs.MovementEventType.complete then
				arm:getAnimation():play("standby")
				-- armatureBack:getAnimation():stop()
				if fnMoveBack then
					fnMoveBack()
				end
				armatureBack:getAnimation():setMovementEventCallFunc(function() end)
				-- print("[延时]攻击动作完成 ............................ ", os.time())
			end
		end
		
		local function fnSpineAnimationEvent(event)
			 -- print(tostring(arm), string.format("[spine] %d complete: %d, %s", 
                              -- event.trackIndex, 
                              -- event.loopCount,
							  -- event.animation), os.clock())
			-- print("fnSpineAnimationEvent", tostring(arm), event.animation, event.trackIndex, event.loopCount, os.time(), os.clock())
			if event.animation == szAnimation then
				arm:addAnimation(0, 'standby', true)
				if fnMoveBack then
					fnMoveBack()
				end
				-- print("[unregisterSpineEventHandler] 1")
				-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
				-- print("[延时]攻击动作完成 ............................ ", self:GetName(), os.time())
			end
		end
		
		local fnOnFrameEvent = function( bone,evt,originFrameIndex,currentFrameIndex)
			-- print("fnOnFrameEvent", bone,evt,originFrameIndex,currentFrameIndex)
			if evt == "defend" then
				fnCallBack();
				-- arm:getAnimation():setFrameEventCallFunc(function() end)
			end
		end
		
		local fnSpineFrameEvent = function(event)
			print("fnSpineFrameEvent", event, event.eventData.name, event.eventData.intValue, event.eventData.floatValue, event.eventData.stringValue, os.time(), os.clock())
			if event.eventData.name == "defend" then
				fnCallBack();
				-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_EVENT)
				-- arm:getAnimation():setFrameEventCallFunc(function() end)
			end
		end

		if arm then
			if arm.getAnimation then
				-- print("setFrameEventCallFunc @base ", szAnimation)
				arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
				arm:getAnimation():setFrameEventCallFunc(fnOnFrameEvent)
			else
				print("[registerSpineEventHandler] 2", szAnimation, os.clock())
				arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
				arm:registerSpineEventHandler(fnSpineFrameEvent, sp.EventType.ANIMATION_EVENT)
			end
			
			if arm.getAnimation then
				arm:getAnimation():play(szAnimation)
			else
				-- arm:addAnimation(0, szAnimation, true)
				arm:setAnimation(0, szAnimation, true)
			end
			
			self:PlayEffect(1, arm, uiLayer, nCamp, nPos, tbRetLau);
		end
	end

	-- self:MiddleEffect();
	self:OnUIRunAttack(tbRetLau, uiLayer);
end

--@function: 不同技能的特殊处理
function KGC_SKILL_BASE_TYPE:OnUIRunAttack(tbRetLau, uiLayer, nCastRet, fnCallBack)
	
end

--@function: 不同技能特效的特殊处理
function KGC_SKILL_BASE_TYPE:PlayFrameEventEffect(tbRetLau, uiLayer, nCastRet, fnCallBack)
	-- if fnCallBack then
		-- fnCallBack()
	-- end
	--test
	-- local lau = self:GetLauncher()
	local lau = self:GetCaster()
	local nCamp = lau:GetFightShip():GetCamp();
	local nPos = lau:GetPos();
	local node = uiLayer:GetStillNode(nCamp, nPos);
	
	--拖尾
	local streak = cc.MotionStreak:create(0.5, 15, 25, cc.c3b(255, 255, 255), "res/ui/temp/streak7.png")
	streak:setBlendFunc(gl.ONE, gl.ONE);	--高亮叠加
	node:addChild(streak);
	local srcSize = node:getContentSize();
	local posX, posY = srcSize.width/2, srcSize.height + 100
	streak:setPosition(cc.p(posX, posY))
	--test end
end

function KGC_SKILL_BASE_TYPE:UIRunAfterAttack(tbRetLau, tbRetDef, uiLayer, fnCallBack)
	print("[延时]攻击之后处理开始 ...................", self:GetName(), os.time())
	local lau = self:GetRetLau(tbRetLau);
	if not lau then
		cclog("[Error]攻击者来源没有找到！@KGC_SKILL_CONTRACT_TYPE.UIRunAfterAttack")
		return;
	end
	--更新费用
	local nCamp, nPos = lau:GetKey();
	--技能名字显示世间延长至整个过程
	local szName = "pnl_skillname_" .. nCamp
	local pnlSkillName = ccui.Helper:seekWidgetByName(uiLayer.m_Layout, szName);
	if pnlSkillName then
		pnlSkillName:setVisible(false)
	end
	
	for _, launcher in pairs(tbRetLau) do
		local nCamp, pos = launcher:GetKey()
		local arm = uiLayer:GetArmature(nCamp, pos)
		if arm then
			if arm.getAnimation then
				-- arm:getAnimation():play("standby")
			else
				-- arm:addAnimation(0, "standby", true)
			end
		end
	end
	
	local nCount = 0;				--回调函数只需要执行一次
	--反击
	for _, def in pairs(tbRetDef) do
		-- print("是否反击特效", def:GetCA())
		if def:GetCA() or true then
			local nCamp, nPos = def:GetKey();
			local _, widgetHero = uiLayer:GetHeroInfo(nCamp, nPos)
			if widgetDef then
				nCount = nCount + 1;
				local size = widgetHero:getContentSize()
				local labelBMFont = ccui.TextBMFont:create()
				-- labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_RED)
				labelBMFont:setString("back")
				labelBMFont:setPosition(cc.p(-size.width/2, size.height/2))
					
				widgetHero:addChild(labelBMFont) 
				local call = function()
					labelBMFont:removeFromParent(true)
				end
				local fadeout = cc.FadeOut:create(0.5)
				local call = function()
					if fnCallBack then
						fnCallBack(uiLayer)
					end
				end
				local action = cc.Sequence:create(fadeout, fadeout:reverse(),cc.CallFunc:create(call));
				if nCount == 1 then
					action = cc.Sequence:create(action, cc.CallFunc:create(call))
				end
				labelBMFont:runAction(action);
			end
		end
	end
	print("反击执行次数：", nCount, fnCallBack)
	if nCount == 0 then
		if fnCallBack then
			fnCallBack(uiLayer);
		end
	end
end

function KGC_SKILL_BASE_TYPE:CreateBloodEffect(ret, uiLayer, nDamage)
	print("CreateBloodEffect-nDamage", nDamage);
	nDamage = math.floor(nDamage)
	local nCamp, nPos = ret:GetKey();

	local pnlShip = uiLayer:GetShipPanel(nCamp)
	widgetHero = uiLayer:GetStillNode(nCamp, nPos)
	local size = widgetHero:getContentSize()
	local labelBMFont = ccui.TextBMFont:create()
	if nDamage < 0 then
		labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_RED)
	else
		labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_GREEN)
	end
	labelBMFont:setString(tostring(nDamage))
	
	local pos = widgetHero:convertToWorldSpace(cc.p(size.width / 2, size.height - 30))
	labelBMFont:setPosition(pnlShip:convertToNodeSpace(pos))
		
	pnlShip:addChild(labelBMFont)

	local call = function()
		labelBMFont:removeFromParent(true)
	end
	local action1 = cc.FadeIn:create(1)
	local action2 = cc.MoveBy:create(1, cc.p(0, 80));
	local action3 = cc.Spawn:create(action1, action2);
	local action = cc.Sequence:create(action3,cc.CallFunc:create(call));
	labelBMFont:runAction(action);
end

--@function:　创建miss效果
function KGC_SKILL_BASE_TYPE:CreateMissEffect(defend, uiLayer, fnCallBack)
	local nCamp, nPos = defend:GetKey();
	local widgetHero = uiLayer:GetStillNode(nCamp, nPos)
	local pnlShip = uiLayer:GetShipPanel(nCamp)
	print("CreateMissEffect", nCamp, nPos, widgetHero);
	if widgetHero then
		local size = widgetHero:getContentSize()
		-- local labelBMFont = ccui.TextBMFont:create()
		local labelBMFont = ccui.Text:create();
		-- labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_RED)
		labelBMFont:setColor(cc.c3b(255, 0, 0));
		-- labelBMFont:setFntFile(CUI_PATH_FONT_BLOOD_RED)
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

function KGC_SKILL_BASE_TYPE:UIRunDefend(nTurn, tbLauncher, tbDefend, tbRetState, uiLayer, fnCallBack)
	print("[延时]开始释放被击动作 ............", os.time())
	local tintby1 = cc.TintBy:create(0.1, 0, 200, 255)
	local tintby2 = tintby1:reverse();
	local tintby = cc.Sequence:create(tintby1, tintby2)
	-- 技能效果表现：(1)统一处理：+/1血，费用上限增加；(2)分技能处理：召唤、多重施法
	--Notify: 等特效播放完毕才开始播掉血操作，不然会出现死亡找不到对象的情况
	local fnUpdateResult = function(defend)
		local lau = self:GetRetLau(tbLauncher);
		print("[延时]被击动作完成加血前 ............", os.time())
		-- self:UpdateHP(nTurn, uiLayer, {defend}, fnCallBack)
		self:UICalcResult(nTurn, uiLayer, lau, {defend}, fnCallBack);
		print("[延时]被击动作完成加血后 ............", os.time())
		print("[Log]被击动作完毕, 开始回调下一个 ... ")
	end
	
	--命中条件触发
	if tbRetState then
		cclog("Test: 技能(%s)命中'条件'触发", self:GetName())
		g_CondTrigger:NotifyUI(tbRetState, uiLayer, l_tbCondID.HIT)
		-- g_UICondTrigger:Notify(self, l_tbCondID.HIT)
		
		--受伤
		g_CondTrigger:NotifyUI(tbRetState, uiLayer, l_tbCondID.GET_HURT)
		--释放技能
		local nCastID = self:GetCondIDByCastType() or 0;
		if nCastID > 0 then
			g_CondTrigger:NotifyUI(tbRetState, uiLayer, nCastID)
		end
	end
	
	local nCount = 1;
	local lau = self:GetRetLau(tbLauncher);
	print("[log]被击者个数：", tbDefend, #(tbDefend or {}));
	for _, defend in pairs(tbDefend) do
		local nCamp, nPos = defend:GetKey()
		local nCampLau, nPosLau = lau:GetKey()
		local _, node = uiLayer:GetHeroInfo(nCamp, nPos)
		local arm = uiLayer:GetArmature(nCamp, nPos)

		--播放受击的其他动画(移动、闪烁)
		local szAction = "hitshock" .. nCamp .. "_" .. nPos;
		
		if arm then
			local tbColor = arm:getColor()
			local r, g, b = tbColor.r, tbColor.g, tbColor.b
			local fnTintByCallBack = function()
				arm:setColor(cc.c3b(r, g, b))
			end
			local spa = cc.Sequence:create(tintby, cc.CallFunc:create(fnTintByCallBack))
			
			-- 是否击中
			if defend:GetHit() then
				local szAnimation = self:UIGetAnimation("defend") or "";
				if not(nCamp == nCampLau and nPos == nPosLau) and (type(szAnimation) == "string" and string.len(szAnimation) > 0 ) then
					local function fnAnimationEvent(armatureBack,movementType,movementID)
						if movementID == szAnimation and movementType == ccs.MovementEventType.complete then
							--修复bug：翻眼
							if arm.getAnimation then
								arm:getAnimation():play("standby")
							else
								arm:addAnimation(0, "standby", true)
							end
							
							if armatureBack.getAnimation then
								armatureBack:getAnimation():stop()
								armatureBack:getAnimation():setMovementEventCallFunc(function() end)
							end
							
							fnUpdateResult(defend);	
						end
					end
					
					local function fnSpineAnimationEvent(event)
						if event.animation == szAnimation then
							-- 在fnUpdateHP函数之前，该函数中也有register和对应的unregister
							-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
							arm:addAnimation(0, "standby", true)
							-- print("[unregisterSpineEventHandler] 2", tostring(arm))
							fnUpdateResult(defend);
							-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
						end
					end
					-- print("UIRunDefend - 被击动作名字：", szAnimation, type(szAnimation), string.len(szAnimation))
					if arm.getAnimation then
						arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
						arm:getAnimation():play(szAnimation)
					else
						print("[registerSpineEventHandler] 4", szAnimation)
						arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
						arm:setAnimation(0, szAnimation, false)
					end
					
					-- local tbColor = arm:getColor()
					-- local fnTintByCallBack = function()
						-- arm:setColor(cc.c3b(r, g, b))
					-- end
					-- local spa = cc.Sequence:create(tintby, cc.CallFunc:create(fnTintByCallBack))
					arm:runAction(spa)
				else
					print("[log]不满足播放受击动作条件");
					local fnCall = function()
						fnUpdateResult(defend);
					end

					-- local action = cc.Sequence:create(cc.CallFunc:create(fnCall));
					local action = cc.Spawn:create(cc.CallFunc:create(fnCall), spa)
					arm:runAction(action)
				end
			else
				print("miss ... ");
				local fnCall = function()
					fnUpdateResult(defend);
				end
				self:CreateMissEffect(defend, uiLayer, fnCall);
			end
		end

		--被击特效
		self:PlayEffect(2, arm, uiLayer, nCamp, nPos);
	end
	
	--吸血特效
	for _, lau in pairs(tbLauncher) do
		if lau:GetVam() > 0 then
			local nCamp, nPos = lau:GetKey();
			local _, widgetHero = uiLayer:GetHeroInfo(nCamp, nPos)
			local sp = cc.Sprite:create();
			local ani = self:CreateEffect("main-equip")
			local nodeLauHero = uiLayer:GetNode(nPos)
			widgetHero:addChild(sp);
			local call = function()
				sp:removeFromParent(true)
			end
			local action = cc.Sequence:create(ani,cc.CallFunc:create(call));
			sp:runAction(action);
			
			--下面的用法直接宕掉
			--local ani = self:CreateEffect("main-equip")
			--widgetHero:runAction(ani)
		end
	end
	print("RunDefendAni end")
end

--@function: 技能效果的结果处理
--@objRetLau: 释放技能结果的对象
function KGC_SKILL_BASE_TYPE:UICalcResult(nTurn, uiLayer, objRetLau, tbRetDef, fnCallBack)
	local nEffectType = self:GetEffectType() or 0;
	if nEffectType < l_tbEffect.E_MIN or nEffectType > l_tbEffect.E_MAX then
		nEffectType = l_tbEffect.E_MIN;
	end
	if nEffectType == l_tbEffect.E_ADD then		-- 增加法力上限
		local nCamp, nPos = objRetLau:GetKey();
		local tbCost = {}
		tbCost[nCamp] = objRetLau:GetCost();
		print("[log]增加法力上限", nCamp, nPos, tbCost)
		-- 修改法力上限
		if tbCost[nCamp] then
			local nChange = tbCost[nCamp][5] - tbCost[nCamp][2];
			tbCost[nCamp][2] = tbCost[nCamp][5];
			tbCost[nCamp][4] = nChange;
		end

		uiLayer:UpdateCost(tbCost)
		if fnCallBack then
			fnCallBack();
		end
	else										-- 默认：血量变化
		self:UpdateHP(nTurn, uiLayer, tbRetDef, fnCallBack);
	end
end

function KGC_SKILL_BASE_TYPE:UIRemoveEffect(nID)
	-- print("UIAddEffect remove", nID)
	if not self.m_tbUIEffect or not nID then
		return;
	end
	-- print("UIRemoveEffect", nID, tostring(self.m_tbUIEffect[nID]))
	
	if self.m_tbUIEffect[nID] then
		self.m_tbUIEffect[nID]:removeFromParent(true);
		self.m_tbUIEffect[nID] = nil;
	end
end

function KGC_SKILL_BASE_TYPE:UIAddEffect(nID, effect)
	if not nID then
		return;
	end
	
	if not self.m_tbUIEffect then
		self.m_tbUIEffect = {};
	end
	
	if self.m_tbUIEffect[nID] then
		self.m_tbUIEffect[nID]:removeFromParent(true);
	end
	
	-- print("UIAddEffect", nID, tostring(effect))
	self.m_tbUIEffect[nID] = effect;
end

function KGC_SKILL_BASE_TYPE:InitUIEffectShow(nID)
	self.m_UIEffectInfo = KGC_SKILL_UI_SHOW_BASE_TYPE.new(self)
	self.m_UIEffectInfo:Init(nID)
end

--@function: 获取动作
function KGC_SKILL_BASE_TYPE:UIGetAnimation(szType)
	local szAnimation = ""
	if self.m_UIEffectInfo then
		if szType == "attack" then
			szAnimation = self.m_UIEffectInfo:GetLauncherMoveData()
		elseif szType == "defend" then
			local tbMove = self.m_UIEffectInfo:GetDefendMoveData();
			szAnimation = tbMove.szMov;
		end
	end
	
	return szAnimation;
end

function KGC_SKILL_BASE_TYPE:GetSkillEffectById1(nID, bLoop)
	nID = nID or 0;
	bLoop = bLoop or 1;
	local cache = cc.SpriteFrameCache:getInstance();
	cache:addSpriteFrames(string.format("tiny/fight/Skill/Effect/%d.plist", nID),
		string.format("tiny/fight/Skill/Effect/%d.png", nID));

	local tbTemp = {}
	local index = 1;
	while true do
		-- cclog("INDEX = %d, %d",index, nID);
		local temp = cache:getSpriteFrame(string.format("%d_%d.png",nID, index));
		index = index + 1;
		if temp == nil then
			break;
		else
			table.insert(tbTemp, temp);
		end
	end

	local animation = cc.Animation:createWithSpriteFrames(tbTemp);
	animation:setLoops(bLoop);
	animation:setDelayPerUnit(0.1);
	local ret = cc.Animate:create(animation);
	print("GetSkillEffectById end")
	return ret;
end

function KGC_SKILL_BASE_TYPE:CreateEffect(szName, bLoop, nUnit)
	bLoop = bLoop or 1;
	nUnit = nUnit or 0.1;
	local cache = cc.SpriteFrameCache:getInstance();
	cache:addSpriteFrames(string.format("effects/%s.plist", szName),
		string.format("effects/%s.png", szName));

	local tbTemp = {}
	local index = 1;
	while true do

		local temp = cache:getSpriteFrame(string.format("_%03d.png", index));
		index = index + 1;
		if temp == nil then
			break;
		else
			table.insert(tbTemp, temp);
		end
	end
	
	-- local fnCallBack = function()
		-- local cache = cc.SpriteFrameCache:getInstance();
		-- cache:removeSpriteFramesFromFile(string.format("effects/%s.plist", szName))
	-- end
	local animation = cc.Animation:createWithSpriteFrames(tbTemp);
	animation:setLoops(bLoop);
	animation:setDelayPerUnit(nUnit);
	--local ret = cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(fnCallBack));
	local ret = cc.Animate:create(animation);
	return ret;
end

function KGC_SKILL_BASE_TYPE:CreateBullt(tbArg, szBullt)
	local self, tbLauncher, tbDefend, tbRetState, uiLayer = unpack(tbArg)
	local action = self:GetBulletDistanceAndScale(tbArg, 1)
	local nCampLau, nPosLau = tbLauncher[1]:GetKey();
	local nCampDef, nPosDef = tbDefend[1]:GetKey();
	uiLayer:CreateBullt(szBullt, nCampLau, nPosLau, action, nCampDef, nPosDef);
end

--@function: 获取攻击范围描述
function KGC_SKILL_BASE_TYPE:UIGetSelectRange(tbRetDef)
	local nRangeType = self:GetSelectRangeType();
	local szRange = l_tbSSName[nRangeType];
	local nEffectType = self:GetEffectType() or 0;
	
	local def = tbRetDef[1]:GetNpc();
	if not szRange or nRangeType == l_tbSkillScope.SINGLE then
		szRange = def:GetName();
	end
	
	-- 召唤
	if nEffectType == l_tbEffect.E_CALL then
		szRange = def:GetPos() .. "号位"
	end
	
	return szRange;
end

--@function: 获取伤害
function KGC_SKILL_BASE_TYPE:UIGetDamage(tbRetDef)
	local tbDamage = {};
	for _, defend in pairs(tbRetDef) do
		local nCamp, nDefnedPos = defend:GetKey()
		-- local nCurHP, nMaxHP, nDamage = defend:GetDamage()
		
		local data = defend:GetData();
		-- print("@KGC_SKILL_BASE_TYPE:UpdateHP, data", data);
		if data then
			nTimes, nCurHP, nMaxHP, nDamage = data:GetDamage();
			table.insert(tbDamage, nDamage);
		end
	end
	return tbDamage;
end

--@function: 播放特效
--@nType:	1-攻击者特效; 2-受击者特效
--@arm: 骨骼动画，用来匹配大小
--@uiLayer: 战斗界面
--@nCamp: 特效阵营, 针对特殊位置的特效
--@nPosDef: 特效对应的位置
function KGC_SKILL_BASE_TYPE:PlayEffect(nType, arm, uiLayer, nCamp, nPosDef, tbRetLau)
	local nEffID = self.m_UIEffectInfo:GetEffectIDByIndex(nType)
	local nEffScale = self.m_UIEffectInfo:GetEffectScale(nType)
	-- local tbPos = self.m_UIEffectInfo:GetEffectBone(nType)
	-- 受击特效放在特效层(在人物上面)
	local nodeEffect = uiLayer:GetEffectPanel();
	local nDefaultScale = 1;
	local nLayerID = uiLayer:GetLayerID();		-- for 特效
	local effect = af_BindEffect2Node(nodeEffect, nEffID, nil, nDefaultScale, nil, {nil, nil, nLayerID})

	--设置帧事件
	local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
		-- print("onFrameEvent", bone,evt,originFrameIndex,currentFrameIndex)
		if evt == "magic" then
			-- effect:getAnimation():setFrameEventCallFunc(function () end)
			self:PlayFrameEventEffect(tbRetLau, uiLayer, nCastRet);
		end
		-- print("onFrameEvent end")
	end
	if effect then
		effect:getAnimation():setFrameEventCallFunc(onFrameEvent)
	end
	-- 设置属性
	local ref = self:GetEffectRefPanel(nType, uiLayer, nCamp, nPosDef);		-- 阵营需要传入攻击者阵营
	self:SetEffectProperty(nType, effect, uiLayer, ref, arm);
	
	self:OnUIPlayEffect(nType, arm, uiLayer, nCamp, nPosDef, tbRetLau);
end

function KGC_SKILL_BASE_TYPE:OnUIPlayEffect(nType, arm, uiLayer, nCamp, nPosDef)
end

function KGC_SKILL_BASE_TYPE:SetEffectProperty(nType, effect, uiLayer, ref, arm)
	-- 特效层panel
	local parent = uiLayer:GetEffectPanel();
	self:SetEffectScale(nType, effect, parent, ref, arm)
	self:SetEffectPosition(nType, effect, parent, ref, arm)
end

--@function:　设置特效属性(位置、大小)
--@effect: 特效
--@parent: 特效绑定到的节点
--@ref: 特效参考的节点
--@arm: 骨骼动画
function KGC_SKILL_BASE_TYPE:SetEffectScale(nType, effect, parent, ref, arm)
	print("[Log]特效设置位置和大小")
	local nEffScale = self.m_UIEffectInfo:GetEffectScale(nType)
	
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
function KGC_SKILL_BASE_TYPE:SetEffectPosition(nType, effect, parent, ref, arm)
	local bone = self.m_UIEffectInfo:GetEffectBone(nType)
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

--@function: 获取特效参考的panel
function KGC_SKILL_BASE_TYPE:GetEffectRefPanel(nIndex, uiLayer, nCamp, nPos)
	local nType = self.m_UIEffectInfo:GetEffectPosType(nIndex);
	print("[Log]特效释放位置类型(3-屏幕;4-敌方阵营;5-己方阵营): ", nType, nIndex)
	local ref = nil;
	if nType == 3 then							-- 屏幕正中央
	elseif nType == 4 then						-- 敌方正中
		local nEnemyCamp = 3 - nCamp;
		ref = uiLayer:GetEffectShipPanel(nEnemyCamp)
	elseif nType == 5 then						-- 己方正中
		ref = uiLayer:GetEffectShipPanel(nCamp)
	elseif nType == 6 then						-- 敌方前排
		local nEnemyCamp = 3 - nCamp;
		ref = uiLayer:GetWidgetHero(nEnemyCamp, 2)
	elseif nType == 7 then						-- 敌方后排
		local nEnemyCamp = 3 - nCamp;
		ref = uiLayer:GetWidgetHero(nEnemyCamp, 5)
	elseif nType == 8 then						-- 己方前排
		ref = uiLayer:GetWidgetHero(nCamp, 2)
	elseif nType == 9 then						-- 己方后排
		ref = uiLayer:GetWidgetHero(nCamp, 5)
	else										-- 英雄位置
		ref = uiLayer:GetWidgetHero(nCamp, nPos)
	end
	
	return ref;
end

--@function: 获取技能类型对应的名字-->技能面板
function KGC_SKILL_BASE_TYPE:GetTypeName()
	local nType = self:GetType();
	return l_tbSkillTypeName[nType] or "";
end
----------------------------------------------------------
--test
----------------------------------------------------------
