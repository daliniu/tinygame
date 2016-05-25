require("script/class/class_base_ui/class_base_sub_layer")

BulletLayer = class("BulletLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function BulletLayer:create()
	self = BulletLayer.new();
    self:initAttr();
	return self;
end

function BulletLayer:ctor()
	

end

function BulletLayer:initAttr()
	-- body
end

function BulletLayer:addMassage(massage)
    local sbird = cc.Node:create();
    self:addChild(sbird);
    sbird:setPositionX(0);
    sbird:setPositionY(math.random(600)+500);
    local fTime = math.random(3)+6;
    sbird:runAction(cc.Sequence:create(cc.MoveBy:create(fTime,cc.p(1500,0)),cc.RemoveSelf:create()));

    local pText = ccui.Text:create()
    pText:setString(massage.name..":"..massage.msg);
    sbird:addChild(pText)
    pText:setFontSize(math.random(20)+25);
    pText:setColor(cc.c3b(math.random(255),math.random(255),math.random(255)))
    pText:setAnchorPoint(1,0.5);
    pText:setPositionX(-50)
end