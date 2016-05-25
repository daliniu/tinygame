------------------------------------------------------------------道具/装备,提示
require("script/core/configmanager/configmanager");
require("script/class/class_base_ui/class_base_sub_layer")

local itemFile = mconfig.loadConfig("script/cfg/pick/item");

local PROPS_ATTR_TIPS_TB={
	id,
}

PropsAttrTips = class("PropsAttrTips",function()
	return cc.Layer:create();
end,PROPS_ATTR_TIPS_TB);


function PropsAttrTips:create(id)
	self = PropsAttrTips.new();
	self.id = tonumber(id);
	self:initAttr();
	return self;
end

function PropsAttrTips:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/tips_equip.json")
	self:addChild(self.pWidget)
end


function PropsAttrTips:closeSelf()
	local function fun_close(sender,event)
		if event == ccui.TouchEventType.ended then
			self:removeFromParent();
		end
	end


	self:setScale(0.001);
	self:runAction(cc.ScaleTo:create(0.2,1));
	self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.RemoveSelf:create()));

	self.pWidget:addTouchEventListener(fun_close);
end

function PropsAttrTips:initAttr()
	--关闭
	self:closeSelf();

	local itemConfig = itemFile[self.id]
	if itemConfig ==nil then 
		return;
	end

	local lbl_itemname = self.pWidget:getChildByName("lbl_itemname");
	lbl_itemname:setString(itemConfig.itemName);

	local Panel_icon = self.pWidget:getChildByName("Panel_icon");
	local img_icon = Panel_icon:getChildByName("img_icon")
	img_icon:loadTexture(itemConfig.itemIcon);


	local Panel_dis = self.pWidget:getChildByName("Panel_dis");
	local lab_dec = Panel_dis:getChildByName("lbl_info");
	lab_dec:setString(itemConfig.itemTxt);

end