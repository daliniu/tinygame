----------------------------------------------------------
-- file:	rewardsublayer.lua
-- Author:	page
-- Time:	2015/12/09 11:34:26
-- Desc:	竞技场战斗结算奖励
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
local TB_STRUCT_ARENA_REWARD_SUBLAYER = {
	m_pLayout = nil,
	
	m_nCurHero = 1,						-- 当前英雄索引
	m_tbEquipsPos2Widget = {},			-- 保存装备控件
}

KGC_UI_ARENA_REWARD_SUBLAYER_TYPE = class("KGC_UI_ARENA_REWARD_SUBLAYER_TYPE", 
	KGC_UI_BASE_SUB_LAYER, 
	TB_STRUCT_ARENA_REWARD_SUBLAYER)

function KGC_UI_ARENA_REWARD_SUBLAYER_TYPE:OnExit()
    
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_UI_ARENA_REWARD_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {};
	self:LoadScheme();
end

function KGC_UI_ARENA_REWARD_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_REWARD_PATH)
	self:addChild(self.m_pLayout)
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	self.m_pLayout:addTouchEventListener(fnClose);
end