----------------------------------------------------------
-- file:	definefunctions.lua
-- Author:	page
-- Time:	2015/03/11 10:33
-- Desc:	所有定义文件内容获取的函数
----------------------------------------------------------
if not _SERVER then
require ("script/ui/define")
require ("script/core/sdk/define")
end

require ("script/core/define")
require ("script/core/npc/define")
require ("script/core/skill/define")
require ("script/core/item/define")
--function
----------------------------------------------------------
--npc/define.lua
--获取NPC类型表
function def_GetNpcType()
	return TB_ENUM_NPC_TYPE_DEF;
end

--获取职业类型表
function def_GetOccType()
	return TB_ENUM_OCCUPATION_TYPE_DEF;
end

-- 获取英雄品质
-- def_GetHeroQualityType()	
-- 获取英雄类型
-- def_GetHeroType
---------------------------
--skill/define.lua
-- function def_GetHitTypeData()
	-- return TB_ENUM_SKILL_HIT_TYPE_DEF;
-- end

function def_GetSkillBaseConfigData()
	return TB_SKILL_BASE_CONFIG_DATA;
end

-- function def_GetSkillTypeData()
	-- return TB_ENUM_SKILL_TYPE_DEF;
-- end

function def_GetSkillCastRetData()
	return TB_ENUM_SKILL_CAST_RESULT_DEF;
end

function def_GetTargetSelectMethondDATA()
	return TB_ENUM_TARGET_SELECT_METHOD_DEF, TB_ENUM_TARGET_SELECT_METHOD_NAME_DEF;
end

function def_GetSkillScopeData()
	return TB_ENUM_SKILL_SCOPE_TYPE_DEF, TB_ENUM_SKILL_SCOPE_TYPE_NAME_DEF;
end

--def_GetEffectType
---------------------------
--ui/define.lua
--def_GetUIUpdateTypeData
--def_GetChatCHANNELTYPE


---------------------------
--item/define.lua
-- def_GetItemType
-- def_GetPlayerEquipPos
-- def_GetAttributeType