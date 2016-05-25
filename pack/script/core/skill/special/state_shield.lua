----------------------------------------------------------
-- file:	state_shield.lua
-- Author:	page
-- Time:	2015/05/04 11:07
-- Desc:	护盾
----------------------------------------------------------
require "script/core/skill/special/state_base"

local l_tbCondID = def_GetConditionData();
local l_tbStateShowType = def_GetStateShowType();

--data struct
local TB_STATE_SHIELD_STRUCT = {
	
	m_nShieldDamage = 0,			--已经抵挡的伤害
}

KGC_STATE_SHIELD_TYPE = class("KGC_STATE_SHIELD_TYPE", KGC_STATE_BASE_TYPE, TB_STATE_SHIELD_STRUCT)

function KGC_STATE_SHIELD_TYPE:ctor()
	self.m_tbCondID = {l_tbCondID.HIT, l_tbCondID.ROUND_END, l_tbCondID.ROUND_START, l_tbCondID.GET_HURT};
end

function KGC_STATE_SHIELD_TYPE:GetSubDamage()
	local nSubDamage = 0;
	local tbArgs = self:GetShowArgs();
	local nArg1 = tbArgs[1] or 0;
	local nArg2 = tbArgs[2] or 0;
	local nArg3 = tbArgs[3] or 1;
	local nArg4 = tbArgs[4] or 1;
	if nArg3 ==0 then
		nArg3 = 1;
	end
	if nArg4 == 0 then
		nArg4 = 1;
	end
	print("@GetSubDamage护盾减伤计算：", self:GetName(), self:GetID(), self:GetShowType(), l_tbStateShowType.SHIELD)
	if self:GetShowType() == l_tbStateShowType.SHIELD then
		--技能等级默认为1
		local nLevel = 1;
		local skill = self:GetTrigger();
		if skill and skill.IsSkill then
			nLevel = skill:GetLevel() or 1;
		end
		local nTest1 = 0;	--待定属性1
		-- local nTest3 = 1;	--待定属性3
		nSubDamage = (nArg1 * nLevel + nArg2 + nTest1/nArg3) / nArg4;
		-- print(111, nSubDamage, nArg1, nArg2, nArg3, nArg4, nLevel, nTest1, nTest3)
		cclog("已经减伤:%d， 剩余：%d", self.m_nShieldDamage, nSubDamage - self.m_nShieldDamage)
		nSubDamage = nSubDamage - self.m_nShieldDamage;
		if nSubDamage <= 0 then
			nSubDamage = 0;
		end
	end
	
	return nSubDamage;
end

function KGC_STATE_SHIELD_TYPE:Work(nDamage, nSubDamage)
	cclog("状态(%s)起作用了 ... nSubDamage(%d), 已经抵消伤害为(%d)", self:GetName(), nSubDamage, self.m_nShieldDamage)
	local nDamage = nDamage or 0;
	local nSubDamage = nSubDamage or 0;
	
	local nAdd = nSubDamage
	if nSubDamage > nDamage then
		nAdd = nDamage;
	end
	--记录抵挡的伤害
	self.m_nShieldDamage = self.m_nShieldDamage + nAdd;
	cclog("伤害为：%d, 可以抵消伤害为：%d, 最终抵消伤害为：%d, 已经抵消的总伤害为(%d/%d)", nDamage, nSubDamage, nAdd, self.m_nShieldDamage, nSubDamage);
	
	local nLeft = nSubDamage - self.m_nShieldDamage;
	local bRet, data = false, nil;
	if nLeft <= 0 then
		bRet, data = self:Disappear();
	end
	
	return bRet, data;
end