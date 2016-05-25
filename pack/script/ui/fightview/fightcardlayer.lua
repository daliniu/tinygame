--战斗卡牌层
require "script/class/class_base_ui/class_base_layer"
require "script/ui/fightview/fightcard"
require "script/core/minifight/minidef"

local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
local l_tbResultConfig = mconfig.loadConfig("script/cfg/skills/skillresults")
local FIGHTCARDTYPE = def_GetFightCardType()

local TB_FIGHT_CARD_LAYER_STRUCT = 
{
	m_node = nil,		--json ui基节点
	m_cardList = {},	--卡牌列表 
	m_showList = {},	--展示列表
	m_nowShow = nil,	--当前显示牌下标
	m_layerId = nil,	--层id
	m_tFighter = nil,	--保存玩家数据，用于构建技能卡牌
	m_fCallback = nil,	--回调函数保存
	m_effect = nil,		--牌展示特效
	m_hideList = {},	--隐藏卡牌列表
	m_chooseList = {},	--选择卡牌列表
	m_coverList = {},	--蒙蔽列表
}

FightCardLayer = class("FightCardLayer", KGC_UI_BASE_LAYER, TB_FIGHT_CARD_LAYER_STRUCT)

function FightCardLayer:create(nLayerId)
	local pFightCardLayer = FightCardLayer.new(nLayerId)
	return pFightCardLayer
end

function FightCardLayer:ctor(nLayerId)
	self.m_layerId = nLayerId
	self:initUI()
	self:addEvent()
end

--初始化ui
function FightCardLayer:initUI()
	self.m_node = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_CARD_LAYER_PATH)	
	self:addChild(self.m_node)

	--卡牌面板，卡牌展示面板
	for i = 1, 6 do
		--加载技能ui
		local cardListPanel = ccui.Helper:seekWidgetByName(self.m_node, "pnl_card_" .. i)
		--创建技能卡牌
		self.m_cardList[i] = FightCard:create(i, false)
		cardListPanel:addChild(self.m_cardList[i])
		self.m_cardList[i]:ResetCardSkill()
		self.m_cardList[i]:setScale(cardListPanel:getContentSize().width / self.m_cardList[i]:GetRootNode():getContentSize().width)
		
		--加载展示ui
		local cardShowPanel = ccui.Helper:seekWidgetByName(self.m_node, "pnl_info_" .. i)
		--创建技能展示卡牌
		self.m_showList[i] = FightCard:create(i, true)
		cardShowPanel:addChild(self.m_showList[i])
		self.m_showList[i]:ResetCardSkill()
		self.m_showList[i]:setScale(cardShowPanel:getContentSize().width / self.m_showList[i]:GetRootNode():getContentSize().width)

		--技能选择回缩卡牌（版本紧急，暂时方案，之后直接使用一套卡牌放大缩小使用）
		local smallCardPnl = ccui.Helper:seekWidgetByName(self.m_node, "pnl_card_small_" .. i)
		self.m_hideList[i] = FightCard:create(i, false)
		smallCardPnl:addChild(self.m_hideList[i])
		self.m_hideList[i]:ResetCardSkill()
		self.m_hideList[i]:setScale(smallCardPnl:getContentSize().width / self.m_hideList[i]:GetRootNode():getContentSize().width)
		self.m_coverList[i] = ccui.Helper:seekWidgetByName(smallCardPnl, "pnl_cover")
		self.m_coverList[i]:setVisible(false)

		--技能选择展示卡牌（版本紧急，暂时方案，之后直接使用一套卡牌放大缩小使用）
		local chooseCardPnl = ccui.Helper:seekWidgetByName(self.m_node, "pnl_showcard_" .. i)
		self.m_chooseList[i] = FightCard:create(i, false)
		chooseCardPnl:addChild(self.m_chooseList[i])
		self.m_chooseList[i]:ResetCardSkill()
		self.m_chooseList[i]:setScale(chooseCardPnl:getContentSize().width / self.m_chooseList[i]:GetRootNode():getContentSize().width)
	end
end

--添加触摸事件
function FightCardLayer:addEvent()
	for i = 1, 6 do
		local cardListPanel = ccui.Helper:seekWidgetByName(self.m_node, "pnl_card_" .. i)
		cardListPanel:addTouchEventListener(function(sender,eventType)
			self:onCardTouch(eventType, i)
		end)
	end
end

--卡牌触摸
function FightCardLayer:onCardTouch(eType, nIdx)
	if eType == ccui.TouchEventType.began then
		if not self.m_nowShow then
			self.m_nowShow = nIdx
			self.m_showList[self.m_nowShow]:CopyCard(self.m_cardList[self.m_nowShow]:GetSkillInfo())
		end
	elseif eType == ccui.TouchEventType.ended or eType == ccui.TouchEventType.canceled then
		if self.m_nowShow then
			self.m_showList[self.m_nowShow]:ResetCardSkill()
			self.m_nowShow = nil
		end
	end
end

--重置技能卡牌
function FightCardLayer:resetSkillCard()
	for i, v in ipairs(self.m_cardList) do
		v:ResetCardSkill()
	end
	self.m_node:stopAllActions()
	self.m_fCallback = nil
	if self.m_effect then
		self.m_effect:removeFromParent(true)
		self.m_effect = nil
	end
	for i = 1, 6 do
		self.m_cardList[i]:setVisible(true)
		self.m_chooseList[i]:ResetCardSkill()
		self.m_hideList[i]:ResetCardSkill()
		self.m_coverList[i]:setVisible(false)
	end
end

--重置展示卡牌
function FightCardLayer:resetShowCard()
	for i, v in ipairs(self.m_showList) do
		v:ResetCardSkill()
	end
end

--构造卡牌列表
function FightCardLayer:ConstructCardList(nMaxCost, nRound)
	self:resetSkillCard()	
	--超出7局
	if nRound >= 7 then
		--构建全费技能卡
		for i = 1, 6 do
			self.m_cardList[i]:SetAllCard(i, minidef.SKILL_PRO[0][i])
		end		
	else
		local nSkillPercent = minidef.SKILL_PRO[nMaxCost][nMaxCost]
		local nIdx = 0
		--构建合体技卡
		if self.m_tFighter.combo and self.m_tFighter.combo[nMaxCost] and self.m_tFighter.combo[nMaxCost].skill then			
			local tCombo = self.m_tFighter.combo[nMaxCost]
			for i, v in ipairs(tCombo.skill) do
				nIdx = nIdx + 1
				self.m_cardList[nIdx]:SetSkillCard(v[1], math.floor(nSkillPercent * tCombo.prop[i] / 100), self.m_tFighter[v[2]].id)
				nSkillPercent = nSkillPercent - math.floor(nSkillPercent * tCombo.prop[i] / 100)
			end			
		end

		--构建普通技能卡
		if self.m_tFighter.roundSkill and self.m_tFighter.roundSkill[nMaxCost] and self.m_tFighter.roundSkill[nMaxCost].skill then			
			local tSkill = self.m_tFighter.roundSkill[nMaxCost]
			for i, v in ipairs(tSkill.skill) do
				nIdx = nIdx + 1
				self.m_cardList[nIdx]:SetSkillCard(v[1], math.floor(nSkillPercent * tSkill.prop[i] / 100), self.m_tFighter[v[2]].id)
				nSkillPercent = nSkillPercent - math.floor(nSkillPercent * tSkill.prop[i] / 100)
			end			
		end
		--构建普通攻击卡
		nIdx = nIdx + 1
		self.m_cardList[nIdx]:SetNormalCard(nMaxCost, nSkillPercent)
		--构建全费技能卡
		for i = 1, 2 do
			local nAllCost = nMaxCost - i
			if nAllCost <= 0 then
				break
			end
			nIdx = nIdx + 1
			self.m_cardList[nIdx]:SetAllCard(nAllCost, minidef.SKILL_PRO[nMaxCost][nAllCost])
		end			
		--剩余卡牌重置
		for i = nIdx + 1, 6 do
			self.m_cardList[i]:ResetCardSkill()
		end	
	end	
end

--获取技能卡牌数
function FightCardLayer:getSkillCardNum()
	local nNum = 0
	for i, v in ipairs(self.m_cardList) do
		if v:GetSkillInfo() then
			nNum = nNum + 1
		end
	end
	return nNum
end

--随机技能
function FightCardLayer:RandomSkill(nSkillId, nMaxCost, nRound, nHeroId, fCallBack)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	local tSkillRes = l_tbResultConfig[tSkillInfo.skillresultsid]
	self.m_fCallback = fCallBack
	local nResIdx = 0
	if nRound >= 7 then
		nResIdx = tSkillInfo.cost
	else
		for i, v in ipairs(self.m_cardList) do
			local tCardInfo = v:GetSkillInfo()
			if tCardInfo then
				if tSkillInfo.cost < nMaxCost then
					if tCardInfo.eType == FIGHTCARDTYPE.ALL and tCardInfo.nCost == tSkillInfo.cost then
						nResIdx = i
						break
					end
				elseif tSkillRes.effecttype == minidef.SKILL_EFFECT.COMMON and tCardInfo.eType == FIGHTCARDTYPE.NORMAL then
					nResIdx = i 
					break	
				elseif tCardInfo.nSkillId == nSkillId then
					nResIdx = i 
					break
				end
			end
		end		
	end
	--防止随机到无卡牌的技能，主要防止fighter结构出错
	if nResIdx == 0 then
		print("RandomSkill error, no nSkillId" .. nSkillId .. " card!!!")
		nResIdx = 1
	end

	local tSeq = {}
	local nDelayT = 0.15
	--第一轮，给张卡牌循环一遍
	for i = 1, self:getSkillCardNum() do
		local call = cc.CallFunc:create(function()
			self.m_cardList[i]:SetChooseFrameVisible(true, self.m_layerId)
		end)
		local delay = cc.DelayTime:create(nDelayT)
		local call2 = cc.CallFunc:create(function()
			self.m_cardList[i]:SetChooseFrameVisible(false, self.m_layerId)
		end)
		table.insert(tSeq, call)
		table.insert(tSeq, delay)
		table.insert(tSeq, call2)
	end
	--第二轮寻到那张卡牌
	for i = 1, nResIdx do
		local call = cc.CallFunc:create(function()
			self.m_cardList[i]:SetChooseFrameVisible(true, self.m_layerId)
		end)
		local delay = cc.DelayTime:create(nDelayT)
		local call2 = cc.CallFunc:create(function()
			self.m_cardList[i]:SetChooseFrameVisible(false, self.m_layerId)
		end)
		table.insert(tSeq, call)
		table.insert(tSeq, delay)
		table.insert(tSeq, call2)
	end
	--显示卡牌效果
	local showPanel = ccui.Helper:seekWidgetByName(self.m_node, "pnl_showcard")	
	local call = cc.CallFunc:create(function()
		--显示选择卡牌，隐藏普通卡牌，显示不选中卡牌
		for i = 1, 6 do
			if self.m_cardList[i]:GetSkillInfo() then
				self.m_cardList[i]:setVisible(false)
				if i == nResIdx then
					if self.m_cardList[nResIdx]:GetSkillInfo().eType == FIGHTCARDTYPE.NORMAL then
						self.m_chooseList[nResIdx]:ShowNormalCard(self.m_cardList[nResIdx]:GetSkillInfo(), nHeroId)
					elseif self.m_cardList[nResIdx]:GetSkillInfo().eType == FIGHTCARDTYPE.ALL then
						local nPercent = self.m_cardList[nResIdx]:GetSkillInfo().nPercent
						self.m_chooseList[nResIdx]:SetSkillCard(nSkillId, nPercent, nHeroId)			
					else
						self.m_chooseList[nResIdx]:CopyCard(self.m_cardList[nResIdx]:GetSkillInfo())				
					end
				else
					self.m_coverList[i]:setVisible(true)					
					self.m_hideList[i]:CopyCard(self.m_cardList[i]:GetSkillInfo())
				end
			end
		end		
		--创建选中特效
		self.m_effect = af_GetEffectByID(60088, nil, {nil, nil, self.m_layerId})
		local sizeNode = self.m_chooseList[nResIdx]:GetRootNode():getContentSize()
		local pos = self.m_chooseList[nResIdx]:GetRootNode():convertToWorldSpace(cc.p(sizeNode.width / 2 - 9, sizeNode.height / 2 - 15))
		self.m_effect:setPosition(self.m_node:convertToNodeSpace(pos))
		self.m_node:addChild(self.m_effect)		
		--选中特效效果		
		self.m_effect:getAnimation():setMovementEventCallFunc(function(armatureBack, movementType, movementID)
			if movementType == ccs.MovementEventType.complete then
				self.m_effect:runAction(cc.RemoveSelf:create())
				self.m_effect = nil
				--恢复显示卡牌
				for i = 1, 6 do
					self.m_cardList[i]:setVisible(true)
					self.m_chooseList[i]:ResetCardSkill()
					self.m_hideList[i]:ResetCardSkill()
					self.m_coverList[i]:setVisible(false)
				end
				if self.m_fCallback then
					self.m_fCallback()
					self.m_fCallback = nil
				end
			end
		end)
	end)
	table.insert(tSeq, call)	
	self.m_node:runAction(cc.Sequence:create(tSeq))
end

function FightCardLayer:SetFighter(tFighter)
	self.m_tFighter = tFighter
end