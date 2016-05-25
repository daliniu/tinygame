----------------------------------------------------------
-- file:	skill.lua
-- Author:	page
-- Time:	2015/02/02 10:41
-- Desc:	技能管理类，全局
--			
----------------------------------------------------------
require "script/core/head"
require "script/core/skill/special/head"
local l_tbStatus = require("script/cfg/status")
----------------------------------------------------------
local l_tbStateShowType = def_GetStateShowType();

--data struct
local TB_STATE_STRUCT = {
	--config
	------------------------------------
	m_tbSkillsID2Obj = {
		[60001] = KGC_STATE_SHIELD_TYPE,
	}
	------------------------------------
}

KGC_STATE_MANAGER_TYPE = class("KGC_STATE_MANAGER_TYPE", CLASS_BASE_TYPE, TB_STATE_STRUCT)
----------------------------------------
--function
----------------------------------------
function KGC_STATE_MANAGER_TYPE:Init()
end

function KGC_STATE_MANAGER_TYPE:CreateState(nID, npc, skill)
	if not nID or nID <= 0 then
		return nil;
	end
	local skillType = self:GetSkillType(nID);

	local state = skillType.new()
	local tbInfo = self:GetInfoFromConfig(nID)
	-------------------------------------
	state:Init(nID, tbInfo, skill)
	state:SetNpc(npc);
	-------------------------------------
	return state;
end

function KGC_STATE_MANAGER_TYPE:GetInfoFromConfig(nID)
	local tbInfo = l_tbStatus;
	return tbInfo[nID]
end

function KGC_STATE_MANAGER_TYPE:GetSkillType(nID)
	local skillType = self.m_tbSkillsID2Obj[nID]
	print("@GetSkillType", nID, skillType)
	if not skillType then
		skillType = KGC_STATE_BASE_TYPE;
	end
	return skillType;
end
----------------------------------------------------------

--relization
g_StateManager = KGC_STATE_MANAGER_TYPE.new()
----------------------------------------------------------
--test
----------------------------------------------------------
