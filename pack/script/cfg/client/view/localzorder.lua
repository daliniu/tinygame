----------------------------------------------------------
-- file:	localzorder.lua
-- Author:	page
-- Time:	2015/05/21	11:26  
-- Desc:	战斗界面层级关系设定
--			(1)同一个节点下面，层级关系越大的就显示在上面
----------------------------------------------------------
local tb_UI_CONFIG_FIGHT_Z_ORDER = {
	--local 
	tbLocal = {
		DEFAULT					= 0,			--默认层级为0
		
		--pnl_ship_x层级
		ARMATURE_COMBO 			= 1,			--生物进入队列特效层级关系(在英雄默认为0之上)
		PNL_SHIP_MASK 			= 99,			--黑幕遮罩层级
		PNL_SHIP_NPC 			= 100,			--遮罩高亮NPC的层级
		
		
		--Panel_434(pnl_ship_x的父panel)下面的层级
		PNL_SHIP_HIGHER			= 1,			--两个ship panel更高的一个层级(更低的是0)
		
		PNL_EFFECT				= 50,			-- 特效在人物层上
		PNL_SHIP_HP				= 100,			-- 血条特效和人物上面
		PNL_TAB					= 120,			--切换页层级
		PNL_SHIP_STATE			= 150,			--状态的遮罩
		PNL_SHIP_ROUND			= 200,			--每一轮开始显示层级
		PNL_REWARD_MORE			= 200,			--挂机阶段奖励
		PNL_AFK_STATISTICS		= 201,			--战斗统计界面
	},
	--global
	tbGlobal = {
		DEFAULT = 0,							--默认层级为0
		
		--触摸层级关系
		TOUCH_BUTTON_NPC = 1,						--NCP可点击的层级关系
		TOUCH_PNL_STATE = 1,						--状态的遮罩层级关系
		TOUCH_BUTTON_SPEED = 2,						--加速按钮
		TOUCH_BUTTON_OVER = 3,						-- 战斗结束按钮层级关系
	},
}

return tb_UI_CONFIG_FIGHT_Z_ORDER;