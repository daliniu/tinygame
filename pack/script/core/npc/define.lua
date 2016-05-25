----------------------------------------------------------
-- file:	define.lua
-- Author:	page
-- Time:	2015/01/27
-- Desc:	npc模块提供的对外数据
----------------------------------------------------------
--require "script/core/npc/hero"
--require "script/core/npc/contracthero"
--require "script/core/npc/monster"
----------------------------------------------------------
--npc类型
TB_ENUM_NPC_TYPE_DEF = {
	HERO 		= 1,		--英雄
	CONTRACT 	= 2,		--契约生物
}

-- 类型
TB_ENUM_OCCUPATION_TYPE_DEF = {
	WAR = 1,				--战士
	MAG = 2,				--法师
	BOW = 3,				--弓箭手
}

-- 英雄类型
local TB_ENUM_HERO_TYPE_DEF = {
	ET_FAST = 1,				-- 快攻
	ET_MEDIUM = 2,				-- 中速
	ET_CONTROL = 3,				-- 控制
}
function def_GetHeroType()
	return TB_ENUM_HERO_TYPE_DEF;
end

local TB_ENUM_HERO_QUALITY_TYPE = {
	ET_G				= 1,			-- 绿
	ET_G1				= 2,			-- 绿+1
	ET_B				= 3,			-- 蓝
	ET_B1				= 4,			-- 蓝+1
	ET_B2				= 5,			-- 蓝+2
	ET_B3				= 6,			-- 蓝+3
	ET_P				= 7,			-- 紫
	ET_P1				= 8,			-- 紫+1
	ET_P2				= 9,			-- 紫+2
	ET_P3				= 10,			-- 紫+3
	ET_P4				= 11,			-- 紫+4
	ET_P5				= 12,			-- 紫+5
	ET_O				= 13,			-- 橙
}

function def_GetHeroQualityType()
	return TB_ENUM_HERO_QUALITY_TYPE;
end

-- 套装属性类型
local TB_ENUM_HERO_SUIT_ATTRIBUTE_TYPE_DEF = {
	ESAT_EFFECT_ADD = 1,				-- 特定技能效果增加百分比
	ESAT_CAST_SUB 	= 2,				-- 特定技能释放消耗降低
	ESAT_ATTACK_ADD = 3,				-- 伤害提升百分比
	ESAT_DEFEND_ADD = 4,				-- 防御提升百分比
	ESAT_TARGET_ADD = 5,				-- 特定技能目标增加
}
function def_GetSuitAttribute()
	return TB_ENUM_HERO_SUIT_ATTRIBUTE_TYPE_DEF;
end