require("script/class/class_base_ui/class_base_sub_layer")

MissionLayerMission = class("MissionLayerMission",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MissionLayerMission:create()
	self = MissionLayerMission.new();
	return self;
end

function MissionLayerMission:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/missionLayerMission.json")
    self:addChild(self.pWidget)	


end