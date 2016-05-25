--高品质物品在出售和拆分时的对话框
require("script/class/class_base_ui/class_base_sub_layer")

BagViewItemOpDialog = class("BagViewItemOpDialog",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function BagViewItemOpDialog:create(pTab,bagview)
	self = BagViewItemOpDialog.new();
	self.itemList = pTab;
	self.bagView = bagview
	return self;
end

function BagViewItemOpDialog:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/bagviewitemopdialog.json")
    self:addChild(self.pWidget)	



    local function fun_quxiao(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    local function fun_queding(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
        	self.bagView:batchItemOp();
        	self:closeLayer();
        end
    end 


    local btn_quxiao = self.pWidget:getChildByName("btn_quxiao");
    btn_quxiao:addTouchEventListener(fun_quxiao)

   	local btn_queding = self.pWidget:getChildByName("btn_ok")
    btn_queding:addTouchEventListener(fun_queding)
    
end