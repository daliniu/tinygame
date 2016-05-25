----------------------------------------------------------
-- file:	con_define.lua
-- Author:	page
-- Time:	2015/03/19
-- Desc:	条件定义
----------------------------------------------------------
-- local tbConditions = require("script/cfg/condition")

--条件ID
TB_ENUM_CONDITION_DEF = {
	HIT 				= 9001,	--tbConditions[9001].id,	--技能命中
	DEAD				= 9002,	--tbConditions[9002].id,	--死亡
	ROUND_START			= 9003,	--tbConditions[9003].id,	--每回合开始
	ROUND_END			= 9004,	--tbConditions[9004].id,	--每回合结束
	GET_HURT			= 9005,	--tbConditions[9005].id,	--受伤
	CAUSE_HURT			= 9006,	--tbConditions[9006].id,	--造成伤害
	GET_CRIT			= 7,	--受到暴击
	CAUSE_CRIT			= 8,	--造成暴击
	MISS				= 9,	--闪避成功
	BACK				= 10,					--反击成功
	ENTER				= 9007,	--tbConditions[9007].id,	--进场时
	
	CAST_1				= 9008,	--tbConditions[9008].id,	--角色释放<1>ID时触发
	CAST_2				= 9009,	--tbConditions[9009].id,	--角色释放<2>ID时触发
	CAST_3				= 9010,	--tbConditions[9010].id,	--角色释放<3>ID时触发
	CAST_4				= 9011,	--tbConditions[9011].id,	--角色释放<4>ID时触发
	
	FAITH				= 9012,	-- 信念
}

--状态ID
TB_ENUM_STATE_ID_DEF = {
	TAUNT				= 1,		--嘲讽
	AIR_SHIELD			= 60001,	--大气护盾
}

--状态效果类型
local TB_ENUM_STATE_SHOW_TYPE_DEF = {
	FLY					= 1,		--飞行
	SHIELD				= 2,		--吸收护盾
	TAUNT				= 3,		--嘲讽
	DEXTERITY			= 4,		--敏捷
	ADDPROPERTY			= 5,		--增加属性
	IMMUNE				= 6,		--免疫一次伤害
	EXILE				= 7,		--放逐
	STUN				= 8,		--晕眩
	SUBPROPERTY			= 9,		--减少属性
	FLAG				= 10,		--标记
}
function def_GetStateShowType()
	return TB_ENUM_STATE_SHOW_TYPE_DEF;
end

--状态效果检测类型
local TB_ENUM_STATE_CHECK_TYPE_DEF = {
	FLY					= 1,		--飞行
	SHIELD				= 2,		--伤害吸收
	TAUNT				= 3,		--嘲讽
	DEXTERITY			= 4,		--敏捷
	IMMUNE				= 5,		--免疫一次伤害
	EXILE				= 6,		--放逐
	STUN				= 7,		--晕眩
	FLAG				= 8,		--标记
	ATTACK				= 9,		--攻击力
	DEFEND				= 10,		--防御力
}

--test
local TB_ENUM_STATE_CHECK_NAME_DEF = {
	[TB_ENUM_STATE_CHECK_TYPE_DEF.FLY]			= "飞行",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.SHIELD]		= "伤害吸收",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.TAUNT]		= "嘲讽",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.DEXTERITY]	= "敏捷",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.IMMUNE]		= "免疫一次伤害",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.EXILE]		= "放逐",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.STUN]			= "晕眩",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.FLAG]			= "标记",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.ATTACK]		= "攻击力",
	[TB_ENUM_STATE_CHECK_TYPE_DEF.DEFEND]		= "防御力",
}

function def_GetStateCheckType()
	return TB_ENUM_STATE_CHECK_TYPE_DEF, TB_ENUM_STATE_CHECK_NAME_DEF;
end

--test
TB_ENUM_CONDITION_NAME_DEF = {
	[TB_ENUM_CONDITION_DEF.HIT] 		= "技能命中",
	[TB_ENUM_CONDITION_DEF.DEAD]		= "死亡",
	[TB_ENUM_CONDITION_DEF.ROUND_START] = "每回合开始",
	[TB_ENUM_CONDITION_DEF.ROUND_END] 	= "每回合结束",
	[TB_ENUM_CONDITION_DEF.GET_HURT] 	= "受伤",
	[TB_ENUM_CONDITION_DEF.CAUSE_HURT] 	= "造成伤害",
	[TB_ENUM_CONDITION_DEF.GET_CRIT] 	= "受到暴击",
	[TB_ENUM_CONDITION_DEF.CAUSE_CRIT] 	= "造成暴击",
	[TB_ENUM_CONDITION_DEF.MISS] 		= "闪避成功",
	[TB_ENUM_CONDITION_DEF.BACK] 		= "反击成功",
	[TB_ENUM_CONDITION_DEF.ENTER] 		= "进场时",
	[TB_ENUM_CONDITION_DEF.CAST_1] 	= "角色释放<普通攻击>ID时触发",
	[TB_ENUM_CONDITION_DEF.CAST_2] 	= "角色释放<法术攻击>ID时触发",
	[TB_ENUM_CONDITION_DEF.CAST_3] 	= "角色释放<契约技能>ID时触发",
	[TB_ENUM_CONDITION_DEF.CAST_4] 	= "角色释放<合击技能>ID时触发",
	[TB_ENUM_CONDITION_DEF.FAITH] 	= "信念",
}

TB_ENUM_STATE_NAME_DEF = {
	[TB_ENUM_STATE_ID_DEF.TAUNT]			= "嘲讽", 
	[TB_ENUM_STATE_ID_DEF.AIR_SHIELD]		= "大气护盾", 
}