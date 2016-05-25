--新手介绍层类

require("script/class/class_base_ui/class_base_layer")

local TB_STRUCT_INTRODUCE_LAYER = {
	m_pLayout = nil,	--底层json layer
}

IntroduceLayer = class("IntroduceLayer", KGC_UI_BASE_LAYER, TB_STRUCT_INTRODUCE_LAYER)

function IntroduceLayer:create(fCloseCallback)
	local pIntroduceLayer = IntroduceLayer.new(fCloseCallback)
	return pIntroduceLayer
end

function IntroduceLayer:ctor(fCloseCallback)
	self:initUI()
	self:addEvent(fCloseCallback)
end

function IntroduceLayer:initUI()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_INTRODUCE_LAYER_PATH)
	self:addChild(self.m_pLayout)
end

function IntroduceLayer:addEvent(fCloseCallback)
	self.m_pLayout:setGlobalZOrder(1001)
	self.m_pLayout:addTouchEventListener(function(sender, type)
		if type == ccui.TouchEventType.ended then
			if fCloseCallback then
				fCloseCallback()
				self:removeFromParent(true)
			end
		end
	end)
end