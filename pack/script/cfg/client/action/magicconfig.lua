----------------------------------------------------------
-- file:	magicconfig.lua
-- Author:	page
-- Time:	2015/06/09
-- Desc:	多重施法特效配置表
----------------------------------------------------------
local TB_CONFIG_SKILL_MAGIC_EFFECT = {
	nFade = 0.2,				--渐隐消失时间(单位：s)
	nMinSeg = 40,				--最小渐隐距离
	nStroke = 20,				--渐隐宽度
	
	tbColor = {255, 100, 0},	--颜色
	
	nTime = 0.4,					--拖尾持续时间
	
    tbPosStart = {0.5, 1.5},		--拖尾效果开始位置
	tbPosEnd = {0.5, 0},		--拖尾效果终止位置
	
	tbPos = {0.5, 0.2},			--脚底特效位置
}




return TB_CONFIG_SKILL_MAGIC_EFFECT;