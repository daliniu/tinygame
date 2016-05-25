----------------------------------------------------------
-- file:	attack.lua
-- Author:	page
-- Time:	2015/04/02
-- Desc:	攻击效果
----------------------------------------------------------
require "script/core/skill/effect/effect_base"

--effect data

--data struct
local TB_ED_ATTACK_STRUCT = {
	nTimes = 0,			--攻击次数
	nCurHP = 0,			--当前血量
	nTotHP = 0,			--总血量
	nDamage = 0,		--伤害
}

KGC_ED_ATTACk_TYPE = class("KGC_ED_ATTACk_TYPE", KGC_EFFECT_DATA_BASE_TYPE, TB_ED_ATTACK_STRUCT)

function KGC_ED_ATTACk_TYPE:ctor()
end

function KGC_ED_ATTACk_TYPE:Init(nTimes, nCurHP, nTotHP, nDamage)
	self:SetDamage(nTimes, nCurHP, nTotHP, nDamage)
end

function KGC_ED_ATTACk_TYPE:SetDamage(nTimes, nCurHP, nTotHP, nDamage)
	print("SetDamage", nTimes, nCurHP, nTotHP, nDamage)
	self.nTimes = nTimes or 0;
	self.nCurHP = nCurHP or 0;
	self.nTotHP = nTotHP or 0;
	self.nDamage = nDamage or 0;
end

function KGC_ED_ATTACk_TYPE:GetDamage()	
	print("GetDamage", self.nTimes, self.nCurHP, self.nTotHP, self.nDamage);
	return self.nTimes, self.nCurHP, self.nTotHP, self.nDamage;
end

function KGC_ED_ATTACk_TYPE:OnUpdateEffect()
	self:UpdateHP();
end

function KGC_ED_ATTACk_TYPE:UpdateHP()
end