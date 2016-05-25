--地图信息

require("script/class/class_base_ui/class_base_layer")

local MAP_CHOOSE_MAP_INFO_TB={
	nodeID=nil,
}

MapChooseMapInfo = class("MapChooseMapInfo",KGC_UI_BASE_SUB_LAYER,MAP_CHOOSE_MAP_INFO_TB)

function MapChooseMapInfo:create(nodeID)
	self = MapChooseMapInfo.new();
	self.nodeID = nodeID;
	self:initAttr();
	return self;
end

function MapChooseMapInfo:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui_map_explor.json")
    self:addChild(self.pWidget)
end

function MapChooseMapInfo:initAttr()
	local function fun_ok(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            MapChooseLogic:getInstance():reqEnterMap(self.nodeID);
            self:removeFromParent(); 
        end
	end

	local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
        	self:closeLayer();
        end		-- body
	end	


	local btn_ok = self.pWidget:getChildByName("btn_move");
	btn_ok:addTouchEventListener(fun_ok);

	local btn_close = self.pWidget:getChildByName("btn_close");
	btn_close:addTouchEventListener(fun_close)

end

