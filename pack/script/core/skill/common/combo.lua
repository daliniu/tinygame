----------------------------------------------------------
-- file:	combo.lua
-- Author:	page
-- Time:	2015/02/09 16:36
-- Desc:	组合技能
--			
----------------------------------------------------------
require "script/core/skill/common/base"
----------------------------------------------------------
local l_tbHitType = def_GetHitTypeData();
local l_tbSkillCastRet = def_GetSkillCastRetData();

--data
local TB_DATA_SKILL_COMBO = {
	--config
	------------------------------------
	m_szName = "合作技",
	------------------------------------
	m_tbPartner = {},				--合作者的ID
}

KGC_SKILL_COMBO_TYPE = class("KGC_SKILL_COMBO_TYPE", KGC_SKILL_BASE_TYPE, TB_DATA_SKILL_COMBO)

----------------------------------------
--function
----------------------------------------
function KGC_SKILL_COMBO_TYPE:ctor()

end

function KGC_SKILL_COMBO_TYPE:OnInit(tbInfo)
	if type(tbInfo) == "table" then
		self:SetPartner(tbInfo.combo);
	end
	print("合体技能初始化OnInit完毕.");
end
--

function KGC_SKILL_COMBO_TYPE:SpecialSkill(launcher, defend)
	local tbFightShip = launcher:GetFightShip();

	return bRet, data;
end

--@function: 增加合体技能合作伙伴
function KGC_SKILL_COMBO_TYPE:AddPartner(nHeroID)
	local tbPartner = self:GetPartner();
	table.insert(tbPartner, nHeroID);
end

function KGC_SKILL_COMBO_TYPE:GetPartner()
	if not self.m_tbPartner then
		self.m_tbPartner = {};
	end
	return self.m_tbPartner;
end

function KGC_SKILL_COMBO_TYPE:SetPartner(tbConfig)
	local tbConfig = tbConfig or {};
	for _, nHeroID in pairs(tbConfig) do
		self:AddPartner(nHeroID);
	end
	
	-- test
	print("合体技能的合作伙伴为：");
	local tbPartner = self:GetPartner();
	for _, nHeroID in pairs(tbPartner) do
		print("\t", nHeroID);
	end
	-- test end
end

function KGC_SKILL_COMBO_TYPE:GetPartnersFromRet(tbRetLaus)
	tbRetLaus = tbRetLaus or {}
	local tbPartner = self:GetPartner()

	local tbHash = {}
	for _, retLau in pairs(tbRetLaus) do
		local npc = retLau:GetNpc();
		local id = npc:GetHeroObj():GetID()
		tbHash[id] = retLau;
	end
	
	local tbRet = {}
	for _, id in pairs(tbPartner) do
		local npc = tbHash[id]
		if npc then
			table.insert(tbRet, npc);
		end
	end
	
	-- 报存一份
	self.m_tbRetPartner = tbRet;
	
	return tbRet;
end

function KGC_SKILL_COMBO_TYPE:IsCombo()
	return true;
end
-------------------------------------------------------------------------
--ui
if not _SERVER then

--@function: 不同技能的特殊处理
function KGC_SKILL_COMBO_TYPE:OnUIRunAttack(tbRetLau, uiLayer)
	local tbPartner = self:GetPartnersFromRet(tbRetLau)
	print("OnUIRunAttack", #tbRetLau, #tbPartner)
	-- local lau = self:GetCaster();
	local lau = self:GetRetLau(tbRetLau);
	local nCamp, nPos = lau:GetKey()
	for k, v in ipairs(tbPartner) do
		if v ~= lau then
			local nCamp, nPos = v:GetKey()
			local arm = uiLayer:GetArmature(nCamp, nPos)
			local szAnimation = self:UIGetAnimation("attack");
			if arm then
				arm:setAnimation(0, szAnimation, true)
			end
		end
	end
end

function KGC_SKILL_COMBO_TYPE:OnUIPlayEffect(nType, arm, uiLayer, nCamp, nPosDef, tbRetLau)
	if nType == 1 then				-- 攻击特效(三个特效组成)
		-- 合作技能上面一层特效
		local nodeEffect = uiLayer:GetEffectPanel();
		local nLayerID = uiLayer:GetLayerID();		-- for 特效
		local effect = af_BindEffect2Node(nodeEffect, 60040, {nil, 2}, 1, nil, {nil, nil, nLayerID})
		-- 设置属性
		local ref = self:GetEffectRefPanel(nType, uiLayer, nCamp, nPosDef);		-- 阵营需要传入攻击者阵营
		self:SetEffectProperty(nType, effect, uiLayer, ref, arm);
		-- 播放UI上的动画
		if uiLayer then
			local tbRes = self:GetHeroResource(tbRetLau);
			uiLayer:PlayEffect(2, tbRes);
		end
	end
end

function KGC_SKILL_COMBO_TYPE:GetHeroResource(tbRetLau)
	local tbRes = {};
	local tbPartner = self:GetPartnersFromRet(tbRetLau)
	for k, v in pairs(tbPartner) do
		local npc = v:GetNpc();
		local _, _, _, sz4, szCharacter = npc:GetHeroObj():GetHeadIcon();
		table.insert(tbRes, szCharacter);
	end
	return tbRes;
end

end

----------------------------------------------------------

----------------------------------------------------------
--test
----------------------------------------------------------
