
local TB_MAP_VIEW_ELEMENT_COMMON_TIPS={
	pString =nil,
}

MapViewElementCommonTips = class("MapViewElementCommonTips",function()
	return cc.Node:create()
end,TB_MAP_VIEW_ELEMENT_COMMON_TIPS)

function MapViewElementCommonTips:create(pString)
	self = MapViewElementCommonTips.new()
	self.pString = pString;
	self:initAttr()
	return self
end

function MapViewElementCommonTips:initAttr()
	local phyNum= ccui.Text:create()
	phyNum:setFontSize(15)
    self:addChild(phyNum)
    phyNum:setString(self.pString)

    self:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
    								cc.RemoveSelf:create()))
end
