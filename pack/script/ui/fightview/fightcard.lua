--战斗卡牌类

require "script/class/class_base.lua"
require "script/core/minifight/minidef"

local l_tbSkillCard = mconfig.loadConfig("script/cfg/client/fight_skillcard")
local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
local l_tbResultConfig = mconfig.loadConfig("script/cfg/skills/skillresults")
local l_tbNpcModels = mconfig.loadConfig("script/cfg/client/model")
local l_tbCharacterConfig = mconfig.loadConfig("script/cfg/character/character")
local l_tbMonsterConfig = mconfig.loadConfig("script/cfg/battle/monster")
local FIGHTCARDTYPE = def_GetFightCardType()

local TB_CARD_STRUCT = 
{
	m_node = nil,		--json ui基节点
	m_nIdx = 0,			--牌位置下标
	m_nSkillId = 0,		--技能id
	m_infoPanel = nil,	--信息面板
	m_infoLabel = nil,	--信息标签
	m_cardBg = nil,		--卡牌背景
	m_heroImg = nil,	--英雄图片
	m_costNum = nil,	--费用
	m_qualityBg = nil,	--品质
	m_skillIcon = nil,	--技能
	m_skillName = nil,	--技能名
	m_midSkillName = nil,--居中技能名
	m_probability = nil,--几率
	m_skillType = nil,	--技能类型
	m_frame = nil,		--卡牌选择边框
	m_tSkillInfo = nil,	--技能信息
}

FightCard = class("FightCard",function()
    return cc.Node:create()
end, TB_CARD_STRUCT)

function FightCard:create(idx, bShowInfo)
	local pCard = FightCard.new(idx, bShowInfo)
	return pCard
end

function FightCard:ctor(idx, bShowInfo)
	self.m_nIdx = idx

	self:initUI(bShowInfo)
end

--初始化ui
function FightCard:initUI(bShowInfo)
	self.m_node = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_CARD_PATH)	
	self:addChild(self.m_node)

	local pnlCard = ccui.Helper:seekWidgetByName(self.m_node, "pnl_card")

	--信息面板
	self.m_infoPanel = ccui.Helper:seekWidgetByName(pnlCard, "pnl_skillinfobg")
	self.m_infoLabel = ccui.Helper:seekWidgetByName(self.m_infoPanel, "lbl_skillinfo")

	--卡牌背景
	self.m_cardBg = ccui.Helper:seekWidgetByName(pnlCard, "img_cardbg")

	--英雄图片
	self.m_heroImg = ccui.Helper:seekWidgetByName(pnlCard, "img_hero")

	--费用文字
	self.m_costNum = ccui.Helper:seekWidgetByName(pnlCard, "btn_costnum")

	--品质背景
	self.m_qualityBg = ccui.Helper:seekWidgetByName(pnlCard, "img_qualitybg")

	--技能图标,名字,概率,类型
	self.m_skillIcon = ccui.Helper:seekWidgetByName(pnlCard, "img_skillicon")
	self.m_skillName = ccui.Helper:seekWidgetByName(pnlCard, "lbl_skillname")
	self.m_midSkillName = ccui.Helper:seekWidgetByName(pnlCard, "lbl_allcostname")
	self.m_probability = ccui.Helper:seekWidgetByName(pnlCard, "lbl_percent")
	self.m_skillType = ccui.Helper:seekWidgetByName(pnlCard, "img_skilltype")

	self.m_infoPanel:setVisible(bShowInfo == true)
end

function FightCard:GetRootNode()
	return self.m_node
end

--重置卡牌技能
function FightCard:ResetCardSkill()
	self.m_nSkillId = nil
	self.m_node:setVisible(false)
	self.m_tSkillInfo = nil
	if self.m_frame then
		self.m_frame:removeFromParent(true)
		self.m_frame = nil
	end
end

--通用设置
function FightCard:commonSetCard(nSkillId, nType, nPercent, nCost)
	local tCardInfo = l_tbSkillCard[nType]	
	local nQuality
	if nSkillId then
		local tSkillInfo = l_tbSkillConfig[nSkillId]
		nQuality = tSkillInfo.quality
	else
		nQuality = 1	--全技能类的无品质区分
	end
	if nPercent <= 0 then
		nPercent = 1
	end
	self.m_cardBg:loadTexture(tCardInfo["edge" .. nQuality])
	self.m_qualityBg:loadTexture(tCardInfo["bg" .. nQuality])
	self.m_heroImg:setVisible(tCardInfo.head == 1)
	self.m_skillType:setVisible(tCardInfo.mark == 1)
	self.m_skillIcon:setVisible(tCardInfo.icon == 1)
	self.m_probability:setString(nPercent .. "%")
	self.m_costNum:setString(nCost)	
	self.m_node:setVisible(true)
end

--设置普攻卡牌
function FightCard:SetNormalCard(nCost, nPercent)
	self.m_node:setVisible(true)
	local tCardInfo = l_tbSkillCard[1]
	self.m_skillName:setString("")
	self.m_midSkillName:setString(tCardInfo["name" .. nCost])
	self.m_infoLabel:setString(tCardInfo.allcostinfo)
	self:commonSetCard(nSkillId, 1, nPercent, nCost)
	self.m_tSkillInfo = {nCost = nCost, nPercent = nPercent, eType = FIGHTCARDTYPE.NORMAL}
end

--设置全技能卡牌
function FightCard:SetAllCard(nCost, nPercent)
	self.m_node:setVisible(true)
	local tCardInfo = l_tbSkillCard[2]
	self.m_skillName:setString("")
	self.m_midSkillName:setString(tCardInfo["name" .. nCost])
	self:commonSetCard(nSkillId, 2, nPercent, nCost)
	self.m_tSkillInfo = {nCost = nCost, nPercent = nPercent, eType = FIGHTCARDTYPE.ALL}
end

--设置技能卡牌
function FightCard:SetSkillCard(nSkillId, nPercent, nHeroId)
	self.m_node:setVisible(true)
	local tCardInfo = l_tbSkillCard[3]
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	local tSkillResult = l_tbResultConfig[tSkillInfo.skillresultsid]
	local tModelInfo = l_tbNpcModels[l_tbCharacterConfig[nHeroId].modelid]
	self.m_skillName:setString(tSkillInfo.name)
	self.m_midSkillName:setString("")
	self.m_infoLabel:setString(tSkillInfo.desc)
	if tSkillResult.effecttype == minidef.SKILL_EFFECT.CALL then  --召唤
		self.m_skillType:loadTexture(tCardInfo.summon)
	elseif tSkillInfo.combo and tSkillInfo.combo ~= 0 then	--合体
		self.m_skillType:loadTexture(tCardInfo.unite)
	else  --普通
		self.m_skillType:loadTexture(tCardInfo.skill)
	end
	self.m_heroImg:loadTexture(tModelInfo.img_skillcard)
	self:commonSetCard(nSkillId, 3, nPercent, tSkillInfo.cost)
	self.m_tSkillInfo = {nSkillId = nSkillId, nPercent = nPercent, eType = FIGHTCARDTYPE.SKILL, nHeroId = nHeroId}
end

--通过其他卡牌技能信息复制卡牌
function FightCard:CopyCard(tSkillInfo)
	if tSkillInfo then
		if tSkillInfo.eType == FIGHTCARDTYPE.NORMAL then
			self:SetNormalCard(tSkillInfo.nCost, tSkillInfo.nPercent)
		elseif tSkillInfo.eType == FIGHTCARDTYPE.SKILL then
			self:SetSkillCard(tSkillInfo.nSkillId, tSkillInfo.nPercent, tSkillInfo.nHeroId)
		elseif tSkillInfo.eType == FIGHTCARDTYPE.ALL then
			self:SetAllCard(tSkillInfo.nCost, tSkillInfo.nPercent)
		end
	end
end

--获取modelid
function FightCard:getModelId(nHeroId)
	if l_tbCharacterConfig[nHeroId] then
		return l_tbCharacterConfig[nHeroId].modelid
	elseif l_tbMonsterConfig[nHeroId] then
		return l_tbMonsterConfig[nHeroId].modelid
	end
end

--展示普攻
function FightCard:ShowNormalCard(tSkillInfo, nHeroId)
	local tModelInfo = l_tbNpcModels[self:getModelId(nHeroId)]
	self:CopyCard(tSkillInfo)
	self.m_heroImg:setVisible(true)
	self.m_heroImg:loadTexture(tModelInfo.img_skillcard)
end

--添加特效
function FightCard:addEffect(nEffectId, nLayerId)
	local effect = af_GetEffectByID(nEffectId, nil, {nil, nil, nLayerId})
	local sizeNode = self.m_node:getContentSize()
	local x = sizeNode.width * 0.5
	local y = sizeNode.height * 0.5
	effect:setPosition(cc.p(x, y))
	self.m_node:addChild(effect)
	return effect
end

--设置卡牌选择效果
function FightCard:SetChooseFrameVisible(bVisible, nLayerId)	
	if self.m_tSkillInfo then
		if bVisible then
			self.m_frame = self:addEffect(60087, nLayerId)
		else
			if self.m_frame then
				self.m_frame:removeFromParent(true)
				self.m_frame = nil
			end
		end
	end
end

--获取技能信息
function FightCard:GetSkillInfo()
	return self.m_tSkillInfo
end