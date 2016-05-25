require("script/class/class_base_ui/class_base_sub_layer")

MissionLayerLetter = class("MissionLayerLetter",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MissionLayerLetter:create()
	self = MissionLayerLetter.new();
	return self;
end

function MissionLayerLetter:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/missionLayerLetter.json")
    self:addChild(self.pWidget)	


end