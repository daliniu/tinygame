--打造界面装备提示信息
require("script/class/class_base_ui/class_base_sub_layer")


local TB_STRUCT_SHIP={};

ForgingItemTips = class("ForgingItemTips",function()
	return PropsAttrTips.new()
end)

function ForgingItemTips:create(id)
	self = ForgingItemTips.new();
    self.id = tonumber(id);
    self:initAttr();    
	return self;
end

function ForgingItemTips:ctor()
    self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/tips_equip.json")
    self:addChild(self.pWidget)
end