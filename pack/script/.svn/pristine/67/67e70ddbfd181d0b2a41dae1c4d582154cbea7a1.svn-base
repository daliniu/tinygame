----------------------------------------------------------
-- file:	define.lua
-- Author:	page
-- Time:	2015/06/30 19:31
-- Desc:	数据定义
----------------------------------------------------------

-- 道具类型(大类)
local TB_ENUM_ITEM_TYPE_GENRE_DEF = {
	G_EQUIP 				= 1,		-- 装备
	G_USE	 				= 2,		-- 消耗品
	G_MATERIAL 				= 3,		-- 合成材料
	G_RECIPE 				= 4,		-- 配方
	G_MAP_TOOL 				= 5,		-- 地图工具
}

-- 道具类型(小类)
local TB_ENUM_ITEM_TYPE_DETAIL_DEF = {
	D_WEAPON 				= 1, 		-- 武器
	D_HEAD					= 2, 		-- 头
	D_CLOTH					= 3,		-- 衣服
	D_SHOES					= 4,		-- 鞋
	D_RING					= 5,		-- 戒指
	D_NECKLACE				= 6,		-- 项链
	D_MONEYBOX				= 7,		-- 游戏币宝箱
	D_DIAMONDBOX			= 8,		-- 钻石宝箱
	D_TICKET				= 9,		-- 门票
	D_APITEM				= 10,		-- 体力道具
	D_EXPITEM				= 11,		-- 经验道具
	D_BUFFITEM				= 12,		-- Buff道具
	D_SKILLITEM				= 13,		-- 技能道具
	D_AWARDBOX				= 14,		-- 宝箱
	D_SCENEITEM				= 16,		-- 场景物品
	D_STONE					= 17,		-- 强化石
	D_TEAM_EXP				= 18,		-- 团队经验物品
	D_MAP_TOOL				= 19,		-- 地图工具
	D_HERO_FRAGMENT			= 20,		-- 英雄碎片
}

function def_GetItemType()
	return TB_ENUM_ITEM_TYPE_GENRE_DEF, TB_ENUM_ITEM_TYPE_DETAIL_DEF;
end

-- 装备在身上对应的位置
local TB_ENUM_PLAYER_EQUIP_POS_DEF = {
	P_WEAPON 				= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_WEAPON,		-- 武器
	P_HEAD 					= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_HEAD,			-- 头
	P_CLOTH 				= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_CLOTH,			-- 衣服
	P_SHOES 				= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_SHOES,			-- 鞋子
	P_RING 					= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_RING,			-- 戒指
	P_NECKLACE 				= TB_ENUM_ITEM_TYPE_DETAIL_DEF.D_NECKLACE,		-- 项链
	
	P_MAX = 6,																-- 装备总个数
}
function def_GetPlayerEquipPos()
	return TB_ENUM_PLAYER_EQUIP_POS_DEF;
end 

-- 装备附加属性类型
local TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF = {
	T_NUL			= 0,					-- 空
	T_STR			= 1,					-- 力量
	T_DEX			= 2,					-- 敏捷
	T_INT			= 3,					-- 智力
	T_AP			= 4,					-- 行动力
	T_HP			= 5,					-- HP
	T_ATK			= 6,					-- 攻击力
	T_DEF			= 7,					-- 防御力
	T_PAR			= 8,					-- 格挡
	T_PEN			= 9,					-- 穿刺
	T_NODAM			= 10,					-- 免伤
	
	T_HIT			= 900,					-- 会心一击(3倍暴击伤害)
	T_CRIT			= 901,					-- 恩赐解脱(10倍暴击伤害)
}

local TB_ENUM_EQUIP_ATTRIBUTE_TYPE_NAME_DEF = {
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_NUL]	= "空",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_STR]	= "力量",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_DEX]	= "敏捷",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_INT]	= "智力",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_AP]		= "行动力",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_HP]		= "生命值",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_ATK]	= "攻击力",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_DEF]	= "防御力",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_PAR]	= "格挡",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_PEN]	= "穿刺",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_NODAM]	= "免伤",
	
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_HIT]	= "会心一击(3倍暴击伤害)",
	[TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF.T_CRIT]	= "恩赐解脱(10倍暴击伤害)",
}

function def_GetAttributeType()
	return TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF, TB_ENUM_EQUIP_ATTRIBUTE_TYPE_NAME_DEF
end


--品质
local TB_ITEM_QUALITY ={
	Q_01 =1,		--白色
	Q_02 =2,		--绿
	Q_03 =3,		--蓝
	Q_04 =4,		--紫
	Q_05 =5,		--橙
}

function def_GetQualityType()
	return TB_ITEM_QUALITY;
end