----------------------------------------------------------
-- file:	attributechange.lua
-- Author:	page
-- Time:	2015/12/11
-- Desc:	属性变化表现方式的配置表
----------------------------------------------------------
--[[
说明：属性变化的动画包括四个部分，动作的target就是属性条
(1)出现：属性条先显示放大，然后变成正常大小
(2)延迟：就是等待时间，正常大小的属性条在出现的地方等待的时间
(3)计数器：这个时间段是属性条的属性数值跳动的一个过程，具体包括两个部分t = (t1 + t2)
* 属性条一直往上移动，时间为t，等于总时间
* 过程中t1的时间为属性变化的数值跳动，t1由跳动次数决定
* 剩下的t2时间属性条继续往上移动
(4)消失：属性消失的时间，变大和渐隐
]]
local TB_CONFIG_ATTRIBUTE_CHANGE = {
	nTimeIn = 0.2,				-- 出现时间
	nTimeDelay = 0.8,			-- 延迟等待时间
	nTimeTick = 2,			-- 计数器时间
	nTimeOut = 0.3,				-- 消失时间
	
	nMaxJumpTimes = 15,			-- 计数器跳动最大次数
	
	szTextureAttribute = "res/ui/00/00_add_bg_01.png",	-- 属性条底板资源
	szTextureArrow = "res/ui/08_melting/00_btn_exe_01.png",		-- 属性条上的数值之间的箭头资源
	tbImage = {
		[1] = "res/ui/00/00_arrow_up.png",		-- 上升图片资源
		[2] = "res/ui/00/00_arrow_down.png",	-- 下降图片资源
	},
	
	nHeightInterval  = 75,						-- 两个提示条之间的距离
	-------------- 属性框的配置 --------------
	-- (1)属性条
	tbStartPos = {385,640},						-- 初始位置(x,y)
	tbCapInsets = {40, 48, 1, 1},				-- 九宫格切割
	tbContentSize = {380, 96},					-- 大小(宽高)
	nOpacity = 200,								-- 透明度(0-255)
	-- (2)属性名
	nHeadFontSize = 26,							-- 字体大小
	tbHeadColor = {255, 129, 1},				-- 颜色
	tbHeadPos = {73, 47},						-- 位置
	-- (3)变化前数值
	nBeforeFontSize = 26,						-- 字体大小
	tbBeforeColor = {240, 226, 192},			-- 颜色
	tbBeforePos = {170, 47},					-- 位置
	-- (4)中间的白色箭头
	tbArrowPos = {230, 45},						-- 位置
	nArrowScale = 0.3,							-- 缩放
	-- (5)变化后数值
	nAfterFontSize = 26,						-- 字体大小
	tbAfterColor = {							-- 字体颜色
		[1] = {184, 255, 0},						-- 胜利(绿色)
		[2] = {237, 62, 66},						-- 失败(红色)
	},
	tbAfterPos = {290, 47},						-- 位置
	-- (6) 上升或者下降箭头
	nUpDownScale = 0.5,							-- 缩放
	tbUpDownPos = {345, 47},					-- 位置
}

return TB_CONFIG_ATTRIBUTE_CHANGE;