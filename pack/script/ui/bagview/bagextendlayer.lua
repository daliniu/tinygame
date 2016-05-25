--背包扩展面板
require("script/class/class_base_ui/class_base_sub_layer")

BagExtendLayer = class("BagExtendLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function BagExtendLayer:create()
	self = BagExtendLayer.new();
	return self;
end

function BagExtendLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/extandBag.json")
    self:addChild(self.pWidget)	

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    local function fun_quxiao(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    local function fun_queding(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            KGC_BagViewLogic:getInstance():reqExtendBag();
            self:closeLayer();
        end
    end 


    local btn_quxiao = self.pWidget:getChildByName("btn_quxiao");
    btn_quxiao:addTouchEventListener(fun_quxiao)

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)

   	local btn_queding = self.pWidget:getChildByName("btn_queding")
    btn_queding:addTouchEventListener(fun_queding)

end