----------------------------------------------------------
-- file:	__init__.lua
-- Author:	page
-- Time:	2015/01/31	14:13
-- Desc:	基本定义()
----------------------------------------------------------

--战斗状态数组索引
TB_ENUM_FIGHT_STATE_ARR_INDEX_DEF = {
	ERROR				= 0,
	ATTACKABLE 			= 1,	--是否可攻击
	LIFE				= 2,	--生命状态(活着，死亡)
	JOIN				= 3,	--是否上场
	SUM					= 100
}

--战斗状态
TB_ENUM_FIGHT_STATE_DEF = {
	[TB_ENUM_FIGHT_STATE_ARR_INDEX_DEF.LIFE] = {
		ERROR  			= 0,		--错误状态
		ALIVE 			= 1,		--正常状态
		DEAD 			= 2,		--死亡
	},
}
	
TB_ENUM_FIGHT_CAMP_DEF = {
	MINE 					= 1, 		--我方
	ENEMY					= 2,		--敌方
}

--位置定义
TB_ENUM_POSITION_DEF = {
	POS_1					= 1,
	POS_2					= 2,
	POS_3					= 3,
	POS_4					= 4,
	POS_5					= 5,
	POS_6					= 6,
}
TB_ENUM_POSITION_DEF.POS_MIN = TB_ENUM_POSITION_DEF.POS_1;
TB_ENUM_POSITION_DEF.POS_MAX = TB_ENUM_POSITION_DEF.POS_6;

--条件优先级定义
TB_ENUM_CONDITION_LEVEL_DEF = {
	ENEMY_HERO				= 1,		--敌方英雄
	MINE_HERO				= 2,		--我方英雄
	ENEMY_NPC				= 3,		--地方怪物
	MINE_NPC				= 4,		--我方怪物
}

MAX_COST = 6 		--最大费用