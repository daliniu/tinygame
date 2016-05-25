require("script/class/class_base_ui/class_base_layer")
require("script/ui/publicview/mainbuttonview")
require("script/core/configmanager/configmanager");
require("script/ui/mapchooseview/mapChooseNormalMap")


local MAP_CHOOSE_LAYER_TB={
    noramlMap =nil;
}


MapChooseLayer = class("MapChooseLayer",function()
	return KGC_UI_BASE_LAYER:create()
end,MAP_CHOOSE_LAYER_TB)

function MapChooseLayer:create()
	self = MapChooseLayer.new();
    self:initAttr();
	return self;
end

function OnExit()

end

function MapChooseLayer:ctor()
	
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapChoose.json")
    self:addChild(self.pWidget)

    self.pLogic = MapChooseLogic:getInstance();

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)
    
    --创建主按钮
    self.m_pMainBtnLayer = MainButtonLayer:create()
    self:AddSubLayer(self.m_pMainBtnLayer);


end



function MapChooseLayer:initAttr()
    self.noramlMap = MapChooseNoramlMap:create();
    local cp = self.pWidget:getChildByName("Panel_cp");
    cp:addChild(self.noramlMap);
end

function MapChooseLayer:updateInfo()
    self.noramlMap = MapChooseNoramlMap:create();
    local cp = self.pWidget:getChildByName("Panel_cp");
    cp:removeAllChildren();
    cp:addChild(self.noramlMap);    
end

