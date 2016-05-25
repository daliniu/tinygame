----------------------------------------------------------
-- file:	define.lua
-- Author:	page
-- Time:	2015/01/27
-- Desc:	all ui class need
----------------------------------------------------------

-- 更新类型
local TB_DEFINE_ENUM_UI_UPDATE_TYPE = {
	EU_MONEY = 1,						-- 金币
	EU_PROPERTY =2,						-- 角色属性
	EU_BAG =3,							-- 背包
	EU_LEVELUP = 4,						-- 升级
	EU_ARMATURE = 5,					-- 英雄骨骼动画(布阵变化)
	EU_AFKERREWARD = 6,					-- 挂机奖励更新进度条
	EU_REMIND = 7,						-- 更新提示(红点等)
	EU_SEARCH = 8,						-- 更新挂机时间
	EU_FIGHTHP = 9,						-- 更新血量
	EU_FIGHTRESULT = 10,				-- 更新战斗结果
}

function def_GetUIUpdateTypeData()
	return TB_DEFINE_ENUM_UI_UPDATE_TYPE;
end

-- 频道类型
local TB_ENUM_CHAT_CHANNEL_TYPE = {
	ECC_PERSONAL = 1,					-- 私人聊天
	ECC_ROOM = 2,						-- 房间聊天
	ECC_TONG = 3,						-- 帮会聊天
	ECC_AREA = 4,						-- 区服聊天
	ECC_WORLD = 5,						-- 世界聊天
	ECC_ANNOUNCE = 6,					-- 公告
}
TB_ENUM_CHAT_CHANNEL_TYPE.ECC_MIN = 1;
TB_ENUM_CHAT_CHANNEL_TYPE.ECC_MAX = 6;

local TB_ENUM_CHAT_CHANNEL_TYPE_NAME = {
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_PERSONAL] = "私聊",
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_ROOM] = "房间",
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_TONG] = "帮会",
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_AREA] = "区服",
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_WORLD] = "世界",
	[TB_ENUM_CHAT_CHANNEL_TYPE.ECC_ANNOUNCE] = "公告",
}

function def_GetChatCHANNELTYPE()
	return TB_ENUM_CHAT_CHANNEL_TYPE, TB_ENUM_CHAT_CHANNEL_TYPE_NAME;
end

-- 英雄列表子界面
local TB_ENUM_HERO_SUBLAYER_TYPE = {
	LT_LINEUP 	= 1,				-- 布阵界面
	LT_STAR 	= 2,				-- 升星界面
	LT_QUALITY 	= 3,				-- 升品界面
	LT_REFRESH 	= 4,				-- 套装属性洗练界面
	LT_SKILL 	= 5,				-- 技能界面
}

function def_GetHeroSublayerType()
	return TB_ENUM_HERO_SUBLAYER_TYPE;
end

local FIGHTCARDTYPE = 
{
	NORMAL = 1,	--普通攻击
	SKILL = 2,	--技能
	ALL = 3,	--全费
	NONE = 4,	--默认无
}

function def_GetFightCardType()
	return FIGHTCARDTYPE
end