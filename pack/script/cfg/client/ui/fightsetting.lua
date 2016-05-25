----------------------------------------------------------
-- file:	fightsetting.lua
-- Author:	page
-- Time:	2015/12/8 20:00
-- Desc:	战斗下拉菜单配置表(策划用)
----------------------------------------------------------
local TB_CONFIG_FIGHT_ACTION = {
	--下拉菜单按钮的配置
	nOriY = 600,				--移动前y坐标
	nY = 550,					--移动终点的y坐标
	nTime = 0.1,				--移动时间(单位：s)

	--飘血配置
	nFadeInT = 0.1,				--渐入时间
	nBeforeDis = -30,			--前半段移动距离
	nBeforeT = 0.1,				--前半段移动时间（等于变小变大时间和）
	nScaleB = 1.8,				--变大比例
	nScaleBT = 0.05,				--变大时间
	nScaleS = 1.0,				--变小比例
	nScaleST = 0.05,				--变小时间
	nAfterDis = 120,				--后半段移动距离
	nAfterT = 0.6,				--后半段移动时间
	nAfterScale = 2,			--后半段变大
	nZorder = 10,				--渲染位置

	--跳过战斗回合数
	nSkipRound = 3,				
}


return TB_CONFIG_FIGHT_ACTION;