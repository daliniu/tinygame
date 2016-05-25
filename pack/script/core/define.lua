----------------------------------------------------------
-- file:	__init__.lua
-- Author:	page
-- Time:	2015/01/31	14:13
-- Desc:	基本定义()
----------------------------------------------------------

-- 阵营定义
local TB_ENUM_FIGHT_CAMP_DEF = {
	MINE 					= 1, 		--我方
	ENEMY					= 2,		--敌方
}
function def_GetFightCampData()
	return TB_ENUM_FIGHT_CAMP_DEF;
end

--位置定义
local TB_ENUM_POSITION_DEF = {
	POS_1					= 1,
	POS_2					= 2,
	POS_3					= 3,
	POS_4					= 4,
	POS_5					= 5,
	POS_6					= 6,
}
TB_ENUM_POSITION_DEF.POS_MIN = TB_ENUM_POSITION_DEF.POS_1;
TB_ENUM_POSITION_DEF.POS_MAX = TB_ENUM_POSITION_DEF.POS_6;

function def_GetPosData()
	return TB_ENUM_POSITION_DEF;
end

MAX_COST = 6 		--最大费用

-- 游戏状态
local TB_ENUM_GAME_STATE = {
	TS_NOLOGIN		= 0,		-- 未登录
	TS_LOGINING		= 1,		-- 登录中
	TS_LOGINED		= 2,		-- 已登录
}
function def_GetGameState()
	return TB_ENUM_GAME_STATE;
end