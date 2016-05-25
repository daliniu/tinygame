----------------------------------------------------------
-- file:	define.lua
-- Author:	page
-- Time:	2015/03/12
-- Desc:	技能相关数据定义
----------------------------------------------------------

----------------------------------------------------------
--命中类型
local TB_ENUM_SKILL_HIT_TYPE_DEF = {
	MISS_DIFF 		= 1,		--命中闪避级差公式
	HIT_DIFF 		= 2,		--命中级差公式
	HIT				= 3, 		--命中
}
function def_GetHitTypeData()
	return TB_ENUM_SKILL_HIT_TYPE_DEF;
end

--技能基本配置表
TB_SKILL_BASE_CONFIG_DATA = {
	CRIT_DOUBLE = 2,			--暴击倍数
}

--技能类型ID
local TB_ENUM_SKILL_TYPE_DEF = {
	NORMAL_0		= 0,		--普通攻击(0)
	NORMAL			= 1,		--法术技能
	CONTRACT		= 2,		--契约技能(CON)
	COMBO			= 3,		--合作技能(COM)
	MAGIC			= 4,		--多重施法
	
	CON_CLOUD_PLAIN = 1001,		--云原空卫
}

local TB_ENUM_SKILL_TYPE_NAME_DEF = {
	[TB_ENUM_SKILL_TYPE_DEF.NORMAL_0]		= "普通",
	[TB_ENUM_SKILL_TYPE_DEF.NORMAL]			= "法术",
	[TB_ENUM_SKILL_TYPE_DEF.CONTRACT]		= "契约",
	[TB_ENUM_SKILL_TYPE_DEF.COMBO]			= "合作",
	[TB_ENUM_SKILL_TYPE_DEF.MAGIC]			= "多重",
}

function def_GetSkillTypeData()
	return TB_ENUM_SKILL_TYPE_DEF, TB_ENUM_SKILL_TYPE_NAME_DEF;
end

--技能释放结果
TB_ENUM_SKILL_CAST_RESULT_DEF = {
	SUCCESS			= 1,		--释放成功
	FAILED			= 2,		--释放失败
	RETRY			= 3,		--重新释放
	MAGIC			= 4,		--多重施法
}


--目标筛选方式(notif：注意同步MIN和MAX)
TB_ENUM_TARGET_SELECT_METHOD_DEF = {
	M_DEFAULT			= 1,		--默认方式
	M_POS				= 2,		--位置目标
	M_SELF				= 3,		--自身
	M_SINGLE			= 4,		--单体
	M_MAXCOST			= 5,		--最高费生物
	M_MINCOST			= 6,		--最低费生物
	M_UPCOST			= 7,		--<目标生物>以上的生物
	M_DOWNCOST			= 8,		--<目标生物>以下的生物
	M_RANDOM			= 9,		--随机目标
	M_MINLEFTHP			= 10,		--剩余HP百分比最少
	M_POSITION			= 11,		--对位英雄
}

TB_ENUM_TARGET_SELECT_METHOD_DEF.M_MIN = TB_ENUM_TARGET_SELECT_METHOD_DEF.M_DEFAULT
TB_ENUM_TARGET_SELECT_METHOD_DEF.M_MAX = TB_ENUM_TARGET_SELECT_METHOD_DEF.M_POSITION

TB_ENUM_TARGET_SELECT_METHOD_NAME_DEF = {
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_DEFAULT]		= "默认方式",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_POS]			= "位置目标",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_SELF]			= "自身",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_SINGLE]			= "对位单体生物",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_MAXCOST]		= "最高费生物",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_MINCOST]		= "最低费生物",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_UPCOST]			= "<目标生物>以上的生物",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_DOWNCOST]		= "<目标生物>以下的生物",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_RANDOM]			= "随机目标",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_MINLEFTHP]		= "剩余HP百分比最少",
	[TB_ENUM_TARGET_SELECT_METHOD_DEF.M_POSITION]		= "对位英雄",
}

--技能范围类型
TB_ENUM_SKILL_SCOPE_TYPE_DEF = {
	ALL					= 3,		--全体
	ROW					= 1,		--横排
	COL					= 2,		--竖列
	CROSS				= 4,		--十字
	SINGLE				= 0,		--单体
}

--技能范围类型
TB_ENUM_SKILL_SCOPE_TYPE_NAME_DEF = {
	[TB_ENUM_SKILL_SCOPE_TYPE_DEF.ALL]					= "全体",
	[TB_ENUM_SKILL_SCOPE_TYPE_DEF.ROW]					= "横排",
	[TB_ENUM_SKILL_SCOPE_TYPE_DEF.COL]					= "竖列",
	[TB_ENUM_SKILL_SCOPE_TYPE_DEF.CROSS]				= "十字",
	[TB_ENUM_SKILL_SCOPE_TYPE_DEF.SINGLE]				= "单体",
}

--技能效果类型
local TB_EFFECT_TYPE_DEF = {
	E_NONE					= 0,		--
	E_ATK					= 1,		--攻击
	E_CURE					= 2,		--治疗
	E_MUL					= 3,		--多重施法
	E_KILL					= 4,		--杀生物
	E_ADD					= 5,		--增加法力上限
	E_CALL					= 6,		--召唤
	E_COPY					= 7,		--复制
	E_COMMON				= 8,		--普攻
}
TB_EFFECT_TYPE_DEF.E_MIN = TB_EFFECT_TYPE_DEF.E_NONE
TB_EFFECT_TYPE_DEF.E_MAX = TB_EFFECT_TYPE_DEF.E_COPY

function def_GetEffectType()
	return TB_EFFECT_TYPE_DEF;
end
