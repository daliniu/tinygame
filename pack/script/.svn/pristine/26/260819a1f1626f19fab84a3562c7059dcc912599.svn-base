--战斗角色类

require "script/class/class_base.lua"
require "script/core/npc/modelmanager"
require("script/core/configmanager/configmanager");

local l_tbCharacterConfig = mconfig.loadConfig("script/cfg/character/character")
local l_tbMonsterConfig = mconfig.loadConfig("script/cfg/battle/monster")
local l_tbStateResults = mconfig.loadConfig("script/cfg/skills/statusresults")
local l_tbStatesShowout = mconfig.loadConfig ("script/cfg/client/stateshowout")
local l_tbEffectConfig = mconfig.loadConfig ("script/cfg/client/action/magicconfig")
local l_tbMonsterBox = mconfig.loadConfig("script/cfg/battle/monsterbox")
local l_tbConfigShow = mconfig.loadConfig("script/cfg/client/skillshowout")
local l_tbZOrder = mconfig.loadConfig("script/cfg/client/view/localzorder")
local l_tbCamp = def_GetFightCampData();
local l_tbLocalZOrder, l_tbGlobalZOrder = l_tbZOrder.tbLocal, l_tbZOrder.tbGlobal

local TB_CHARACTER_STRUCT = {
	m_node = nil,	
	m_nCamp = 0,	
	m_nPos = 0, 
	m_nHeroId = 0, 
	m_arm = nil, 
	m_buffList = {}, 
	m_summonList = {}, 
}

FightCharacter = class("FightCharacter",function()
    return cc.Node:create()
end, TB_CHARACTER_STRUCT)

function FightCharacter:create(nCamp, nPos)
	print("nCamp, nPos = ", nCamp, nPos)
	if not gf_IsValidPos(nPos) or not self:IsValidCamp(nCamp) then
		return
	end
	local pCharacter = FightCharacter.new(nCamp, nPos)
	return pCharacter
end

function FightCharacter:ctor(nCamp, nPos)	
	self.m_nCamp = nCamp
	self.m_nPos = nPos	

	self.m_node = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_ROLE_TEMPLATE_PATH)	
	self:addChild(self.m_node)

	local pnlNpc = self.m_node:getChildByName("pnl_npc")
	local pnlHP = pnlNpc:getChildByName("pnl_hp")
	pnlHP:setVisible(false)	
end

--获取根节点
function FightCharacter:GetRootNode()
	return self.m_node
end

--获取骨骼
function FightCharacter:GetArm()
	return self.m_arm
end

--获取英雄id
function FightCharacter:GetHeroId()
	return self.m_nHeroId
end

--根据英雄id加载英雄模型
function FightCharacter:LoadHeroById(nHeroId, touchFunc)
	if self.m_nHeroId == nHeroId and self.m_arm then
		return
	end
	if self.m_arm then
		self:RemoveHeroArm()
	end
	self.m_nHeroId = nHeroId
	local pnlNpc = ccui.Helper:seekWidgetByName(self.m_node, "pnl_armature")
	self.m_arm = self:CreateHeroById(nHeroId, pnlNpc)
	local imgHero = nil;
	if self:IsHero(nHeroId) then
		local img_shadow = ccui.Helper:seekWidgetByName(pnlNpc, "img_shadow")
		img_shadow:setVisible(true);
		imgHero = ccui.Helper:seekWidgetByName(pnlNpc, "img_hero")
	else
		imgHero = ccui.Helper:seekWidgetByName(pnlNpc, "img_monster")
	end

	local sizePnlNpc = pnlNpc:getContentSize();
	local x, y = sizePnlNpc.width / 2, 0;
	self.m_arm:setPosition(cc.p(x, y));

	-- 播放出场动画
	local bIsAppear, nEffectID = KGC_MODEL_MANAGER_TYPE:getInstance():IsAppear(self:GetModelIdByHeroId(nHeroId));
	print("[log]是否播放出场动画", bIsAppear, nEffectID);
	if bIsAppear then
		local szAnimation = "appear";
		local fnStand = function(event)
			if event.animation == szAnimation then					
				self:ArmSetAnimation(0, 'standby', true)
			end
		end
		self.m_arm:registerSpineEventHandler(fnStand, sp.EventType.ANIMATION_COMPLETE)
		self:ArmSetAnimation(0, szAnimation, false)
	else
		self:ArmSetAnimation(0, 'standby', true)			
	end
	
	--设置每个npc个人血条
	local barHP = ccui.Helper:seekWidgetByName(self.m_node, "pnl_hp")
	barHP:setVisible(true)
	if barHP and self:IsBloodShare(nPos) then
		barHP:setVisible(false)
	end
	
	if barHP then
		local barMineHP = barHP:getChildByName("bar_hp");
		local barEnemyHP = barHP:getChildByName("bar_enemyhp");
		if barMineHP and barEnemyHP then
			if self.m_nCamp == l_tbCamp.ENEMY then
				barMineHP:setVisible(false);
				barEnemyHP:setVisible(true);
			end
		end
	end
	
	--状态队列初始化
	local btnNode =  ccui.Helper:seekWidgetByName(self.m_node, "pnl_mark")
	local fnTouchEvent = function(sender,eventType)
		if eventType == ccui.TouchEventType.began then			
			if touchFunc and self.m_nPos and self.m_nCamp and self.m_nHeroId then
				print("hero touch ", self.m_nCamp, self.m_nPos, self.m_nHeroId)
				touchFunc(self.m_nCamp, self.m_nPos, self.m_nHeroId)
			end
		end
	end

	if btnNode then
		btnNode:addTouchEventListener(fnTouchEvent);
	end

	--契约生物队列
	local contractQueue = ccui.Helper:seekWidgetByName(self.m_node, "scv_monsterview")
	for i = 1, 3 do
		local szName = "pnl_showmonster" .. i
		local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
		local imgNon = pnlMonster:getChildByName("img_nomonstericon")
		local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
		imgNon:setVisible(true)
		imgMonster:setVisible(false)
	end
	if self:IsBloodShare(nPos) then
		contractQueue:setVisible(false)
	end
	
	--触发技能标记
	local szNormaMark = "img_statemark";
	local widget = ccui.Helper:seekWidgetByName(self.m_node, szNormaMark)
	--summons才具有，其中的conskillid
	if not self:IsBloodShare(nPos) then
		widget:setVisible(true)
	else
		widget:setVisible(false)
	end

	return bIsAppear, nEffectID
end

--是否有英雄骨骼
function FightCharacter:HasHero()
	if self.m_arm then
		return true
	end
	return false
end

--升级特效
function FightCharacter:UpdateLevel(nLayerID)
	local tbEffectConfig = af_GetEffectModifyInfo(1001) or {};
	if tbEffectConfig then
		local nEffectID, tbPos, nScale = unpack(tbEffectConfig);
		af_BindEffect2Node(self.m_arm, nEffectID, {{0.5, 0}}, nScale, nil, {nil, 0, nLayerID})
	end
end

--更新血量
function FightCharacter:UpdateHp(nHp, nMaxHp)
	if self.m_arm and not self:IsBloodShare() then
		local proHP
		if self.m_nCamp == l_tbCamp.MINE then
			proHP = ccui.Helper:seekWidgetByName(self.m_node, "bar_hp")
		else
			proHP = ccui.Helper:seekWidgetByName(self.m_node, "bar_enemyhp")
		end
		local nPercent = nHp / nMaxHp * 100;
		if nPercent < 0 then
			nPercent = 0;
		elseif nPercent > 100 then
			nPercent = 100;
		end
		proHP:setPercent(nPercent)
	end
end

--英雄攻击动画播放
function FightCharacter:Attack(nSkillId, fCallBack)
	if self.m_arm then
		local szAnimation = l_tbConfigShow[nSkillId].selfmove
		print("szAnimation = ", szAnimation)
		
		local function fnSpineAnimationEvent(event)
			if event.animation == szAnimation then
				-- self.m_arm:addAnimation(0, 'standby', true)
				self:ArmSetAnimation(0, 'standby', true)
			end
		end
		
		local fnSpineFrameEvent = function(event)
			print("fnSpineFrameEvent", event, event.eventData.name, event.eventData.intValue, event.eventData.floatValue, event.eventData.stringValue, os.time(), os.clock())
			if event.eventData.name == "defend" then
				if fCallBack then
					fCallBack()
				end
			end
		end

		print("[registerSpineEventHandler] 2", szAnimation, os.clock())
		self.m_arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
		self.m_arm:registerSpineEventHandler(fnSpineFrameEvent, sp.EventType.ANIMATION_EVENT)
		
		self:ArmSetAnimation(0, szAnimation, true)
	end
end

--英雄播放消失动画
function FightCharacter:Dispear(fCallBack)	
	if self.m_arm then
		--怪物消失动画结束后调用fnCallBack移动怪物
		local szAnimation = "disappear"
		-- local szAnimation = "standby"
		local function fnAnimationEvent(armatureBack, movementType, movementID)
			if movementID ~= szAnimation then
				return
			end
			if movementType == ccs.MovementEventType.complete then
				self.m_arm:getAnimation():play("standby")
				if fCallBack then
					fCallBack()
				end
			end
		end
		
		local function fnSpineAnimationEvent(event)
			if event.animation == szAnimation then
				self.m_arm:addAnimation(0, 'standby', true)
				if fCallBack then
					fCallBack()
				end
			end
		end
		
		--播放怪物消失动画
		if self.m_arm.getAnimation then
			self.m_arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
		else
			print("[registerSpineEventHandler] 1", szAnimation)
			self.m_arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
		end

		if self.m_arm.getAnimation then
			self.m_arm:getAnimation():play(szAnimation)
		else
			self:ArmSetAnimation(0, szAnimation, false)
		end
	end
end

--英雄合作技
function FightCharacter:Combo(nSkillId)
	if self.m_arm then
		local szAnimation = l_tbConfigShow[nSkillId].selfmove
		self:ArmSetAnimation(0, szAnimation, true)
		self.m_arm:registerSpineEventHandler(function(event)
			self.m_arm:addAnimation(0, 'standby', true)
		end, sp.EventType.ANIMATION_COMPLETE)
	end
end

--英雄防守动画播放
function FightCharacter:Defense(nSkillId, fCallBack)
	if self.m_arm then
		local tintby1 = cc.TintBy:create(0.1, 0, 200, 255)
		local tintby2 = tintby1:reverse();
		local tintby = cc.Sequence:create(tintby1, tintby2)
		local tbColor = self.m_arm:getColor()
		local r, g, b = tbColor.r, tbColor.g, tbColor.b
		local fnTintByCallBack = function()
			self.m_arm:setColor(cc.c3b(r, g, b))
		end
		local spa = cc.Sequence:create(tintby, cc.CallFunc:create(fnTintByCallBack))
		
		local szAnimation = l_tbConfigShow[nSkillId].targetmove or "";
		if (type(szAnimation) == "string" and string.len(szAnimation) > 0 ) then
			local function fnAnimationEvent(armatureBack, movementType, movementID)
				if movementID == szAnimation and movementType == ccs.MovementEventType.complete then
					--修复bug：翻眼
					if self.m_arm.getAnimation then
						self.m_arm:getAnimation():play("standby")
					else
						self.m_arm:addAnimation(0, "standby", true)
					end
					
					if armatureBack.getAnimation then
						armatureBack:getAnimation():stop()
						armatureBack:getAnimation():setMovementEventCallFunc(function() end)
					end
					
					if fCallBack then
						fCallBack()
					end
				end
			end
			
			local function fnSpineAnimationEvent(event)
				if event.animation == szAnimation then
					-- 在fnUpdateHP函数之前，该函数中也有register和对应的unregister
					self.m_arm:addAnimation(0, "standby", true)
					if fCallBack then
						fCallBack()
					end
				end
			end
			if self.m_arm.getAnimation then
				self.m_arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
				self.m_arm:getAnimation():play(szAnimation)
			else
				print("[registerSpineEventHandler] 4", szAnimation)
				self.m_arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
				self:ArmSetAnimation(0, szAnimation, false)
			end
			
			self.m_arm:runAction(spa)
		else
			print("[log]不满足播放受击动作条件");
			local fnCall = function()
				if fCallBack then
					fCallBack()
				end
			end

			local action = cc.Spawn:create(cc.CallFunc:create(fnCall), spa)
			self.m_arm:runAction(action)
		end			
	end
end

--召唤
function FightCharacter:Summon(nSummonId, bSuc, bInQueue, fCallBack, touchFunc)
	if not nSummonId then
		return
	end
	table.insert(self.m_summonList, nSummonId)		
	if bSuc or #self.m_summonList == 1 then
		--召唤
		self:SummonEffect(nSummonId, false, fCallBack, touchFunc)
	else
		if bInQueue then
			--插入队列
			local contractQueue = ccui.Helper:seekWidgetByName(self.m_node, "scv_monsterview")			
			for i = 1, 3 do
				local szName = "pnl_showmonster" .. i
				local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
				local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
				if i < #self.m_summonList then
					imgMonster:setVisible(true);
				else
					imgMonster:setVisible(false);
				end
			end
			self:SummonEffect(nSummonId, true, fCallBack, touchFunc)
		end
	end
end

--英雄复制
function FightCharacter:Copy(nSummonId, fCallBack, touchFunc)
	if not nSummonId or #self.m_summonList ~= 0 then
		return
	end
	table.insert(self.m_summonList, nSummonId)
	self:SummonEffect(nSummonId, false, fCallBack, touchFunc)
end

--召唤效果
function FightCharacter:SummonEffect(nHeroId, bCombo, fCallBack, touchFunc)
	--增加生物的一个动作				
	if self.m_node then
		local pnlNpc = ccui.Helper:seekWidgetByName(self.m_node, "pnl_armature")
		local armature = self:CreateHeroById(nHeroId, pnlNpc);
		local sizePnlNpc = pnlNpc:getContentSize();
		local x, y = sizePnlNpc.width / 2, 0;
		armature:setPosition(cc.p(x, y));
		
		armature:setLocalZOrder(l_tbLocalZOrder.ARMATURE_COMBO)	
		local szAnimation = "summon"	--召唤，默认
		if bCombo then
			szAnimation = "combo"	--连携，即此处本来有怪物
		end
		local function fnSpineAnimationEvent(event)
			if event.animation == szAnimation then
				-- page@2015/07/06 切记spine的回调函数中不能删除spine节点对象
				armature:runAction(cc.RemoveSelf:create())
				if not bCombo then
					self:LoadHeroById(nHeroId, touchFunc)					
				end
				--此处一般是回调去指令处理函数进入下一条指令				
				if fCallBack then					
					fCallBack()
				end
			end
		end
		
		print("[registerSpineEventHandler] fightview 2", szAnimation)
		armature:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)

		armature:setToSetupPose()
		armature:setAnimation(0, szAnimation, false)
	end
end

--召唤死亡
function FightCharacter:SummonDeath(nNewSummonId, fNextMove, touchFunc)
	if self.m_arm then
		local fnCall = function()
			if #self.m_summonList == 1 then
				self:RemoveHeroArm()
				if fNextMove then
					fNextMove()
				end
			else
				self.m_arm:runAction(cc.RemoveSelf:create())
				self.m_arm = nil
				
				local nNextSummonId = nNewSummonId or self.m_summonList[1]
				if nNextSummonId then
					self:SummonEffect(nNextSummonId, false, fNextMove, touchFunc)
					--重算队列怪物标记
					local contractQueue = ccui.Helper:seekWidgetByName(self.m_node, "scv_monsterview")			
					for i = 1, 3 do
						local szName = "pnl_showmonster" .. i
						local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
						local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
						if i < #self.m_summonList then
							imgMonster:setVisible(true);
						else
							imgMonster:setVisible(false);
						end
					end
				else
					if fNextMove then
						fNextMove()
					end
				end				
			end
		end
		
		local szAnimation = "death"
		cclog("[Log]生物死亡界面更新, arm(%s)", tostring(self.m_arm))
		local function fnSpineAnimationEvent(event)
			if event.animation == szAnimation then
				fnCall();
			end
		end

		print("[registerSpineEventHandler] fightview 1", szAnimation)
		self.m_arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)

		self:ArmSetAnimation(0, szAnimation, false)
	end
end

--重置队列标志
function FightCharacter:ResetSummonState()
	--隐藏队列
	local contractQueue = ccui.Helper:seekWidgetByName(self.m_node, "scv_monsterview")			
	for i = 1, 3 do
		local szName = "pnl_showmonster" .. i
		local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
		local imgNon = pnlMonster:getChildByName("img_nomonstericon")
		local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
		imgNon:setVisible(false)
		imgMonster:setVisible(false);
	end

	--隐藏summon标志
	local szNormaMark = "img_statemark";
	local widget = ccui.Helper:seekWidgetByName(self.m_node, szNormaMark)
	widget:setVisible(false)

	--血条隐藏
	local barHP = ccui.Helper:seekWidgetByName(self.m_node, "pnl_hp")
	barHP:setVisible(false)

	--情况召唤列表
	self.m_summonList = {}
end

--移除英雄骨骼
function FightCharacter:RemoveHeroArm()
	if self.m_arm then
		self.m_arm:runAction(cc.RemoveSelf:create())
		self.m_arm = nil
	end
	
	self:ClearBuff()
	self:ResetSummonState()
end

--不移除骨骼，只重置状态
function FightCharacter:ResetState()
	if self.m_arm then
		self:ArmSetAnimation(0, "standby", true)
		self.m_arm:registerSpineEventHandler(function( ... ) end,  sp.EventType.ANIMATION_COMPLETE)
		self.m_arm:registerSpineEventHandler(function( ... ) end,  sp.EventType.ANIMATION_EVENT)
	end
	self:ClearBuff()
end

--增加buff
function FightCharacter:AddBuff(nBuffId, nLayerID)
	local tBuffInfo = l_tbStatesShowout[nBuffId]
	print("nBuffId = " .. nBuffId)
	local nZOrder = tBuffInfo.zorder
	local nScale = tBuffInfo.scale
	local tbPro = tBuffInfo.position2

	if self.m_arm then
		local bone = nil
		if self.m_arm.getBone then
			self.m_arm:getBone(tBuffInfo.position)
		end
		self.m_tHeroNode[nCamp][nPos].tEffect = self.m_tHeroNode[nCamp][nPos].tEffect or {}
		bone = nil;
		if not self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId] then
			if bone then
				local effect = af_GetEffectByID(nBuffId)
				self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId]  = ccs.Bone:create("state_effect")
				self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId]:addDisplay(effect, 0)
				--设置是否跟随骨骼一起移动
				self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId]:setIgnoreMovementBoneData(true)
				--显示骨骼上绑定的内容(这里是粒子特效，换装也是同样的接口)
				self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId]:changeDisplayWithIndex(0, true)
				--设置层级关系
				self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId]:setLocalZOrder(1)
				-- Layer22为骨骼动画中想绑定的骨骼，设置为该骨骼为粒子特效所在骨骼的父骨骼
				self.m_arm:addBone(self.m_tHeroNode[nCamp][nPos].tEffect[nBuffId], tBuffInfo.position)
			else
				local effectPnl = self.m_node:getChildByName("Panel_93")
				local effect = af_BindEffect2Node(effectPnl, tBuffInfo.effectid, {tbPro, nZOrder}, nScale, nil, {nil, -1, nLayerID})
				self.m_buffList[nBuffId] = effect
			end
		end
	end
end

function FightCharacter:AddBuffWithoutCreate(nBuffId, oEffect)
	self.m_buffList[nBuffId] = oEffect
end

function FightCharacter:RemoveBuff(nBuffId)
	if self.m_buffList[nBuffId] then
		self.m_buffList[nBuffId]:removeFromParent(true)
		self.m_buffList[nBuffId] = nil
	end
end

function FightCharacter:ClearBuff()
	for k, v in pairs(self.m_buffList) do
		v:removeFromParent(true)
	end
	self.m_buffList = {}
end

--根据英雄id获取模型id
function FightCharacter:GetModelIdByHeroId(nHeroId)
	local nModelID
	if l_tbCharacterConfig[nHeroId] then
		nModelID = l_tbCharacterConfig[nHeroId].modelid
	elseif l_tbMonsterConfig[nHeroId] then
		nModelID = l_tbMonsterConfig[nHeroId].modelid
	end
	return nModelID
end

--判断是否是英雄
function FightCharacter:IsHero(nId)
	if l_tbCharacterConfig[nId] then
		return true
	else
		return false
	end
end

--根据英雄id创建英雄骨骼
function FightCharacter:CreateHeroById(nHeroId, pnlHero)
	local nModelID = self:GetModelIdByHeroId(nHeroId)	

	local armature = KGC_MODEL_MANAGER_TYPE:getInstance():CreateNpc(nModelID);
	if pnlHero and armature then
		pnlHero:addChild(armature, 1)
	end
	if not armature then
		print("create hero armture wrong, nHeroId, nModelID = ", nHeroId, nModelID)
	end
	
	return armature;
end

--设置骨骼动画统一接口
function FightCharacter:ArmSetAnimation(nTrackIndex, szAnimation, bLoop)
	if self.m_arm then
		self.m_arm:setToSetupPose()
		self.m_arm:setAnimation(nTrackIndex, szAnimation, bLoop)
	end
end

--是否违法阵营
function FightCharacter:IsValidCamp(nCamp)
	if nCamp == l_tbCamp.MINE or nCamp == l_tbCamp.ENEMY then
		return true;
	end
	
	cclog("[Error]camp(%d) is not valid!@IsValidCamp!", nCamp or 0)
	return false;
end

--是否共享血量
function FightCharacter:IsBloodShare()
	if self.m_nPos >= 1 and self.m_nPos <= 3 then
		return false
	else
		return true
	end
end