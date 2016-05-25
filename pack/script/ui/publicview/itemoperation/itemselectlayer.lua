--道具选择界面
require("script/class/class_base_ui/class_base_sub_layer")

local TB_ITEM_SELECT_LAYER={
	pTarget=nil
}

ItemSelectLayer = class("ItemSelectLayer",function()
    return KGC_UI_BASE_SUB_LAYER:create()
end,TB_ITEM_SELECT_LAYER)

function ItemSelectLayer:create(pTarget)
	self = ItemSelectLayer.new();
	self.pTarget = pTarget;
	return self;
end

function ItemSelectLayer:ctor()
	--关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer()
        end
    end  

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/itemselectlayer.json")
    self:addChild(self.pWidget)

    local btn_close = self.pWidget:getChildByName("btn_close")  	--关闭按钮
    btn_close:addTouchEventListener(fun_close)
	
end