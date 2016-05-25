--移动限制tips

local TB_MAP_VIEW_MOVE_LIMITTIPS={
	iType =nil,
}

MapViewMoveLimitTips = class("MapViewMoveLimitTips",function()
	return cc.Node:create()
end,TB_MAP_VIEW_MOVE_LIMITTIPS)

MapViewMoveLimitTips.TYPE_FAR =1;		--太远
MapViewMoveLimitTips.TYPE_PHY =2;		--体力不够


function MapViewMoveLimitTips:create(iType)
	self = MapViewMoveLimitTips:new()
	self.iType = iType
	self:initAttr()
	return self
end

function MapViewMoveLimitTips:ctor()
	-- body

end

function MapViewMoveLimitTips:initAttr()

	self:setPosition(cc.p(400,800))

	local phyNum= ccui.Text:create()
	phyNum:setFontSize(25)
    self:addChild(phyNum)
    if self.iType == MapViewMoveLimitTips.TYPE_PHY then 
    	phyNum:setString("体力不足")
    elseif self.iType == MapViewMoveLimitTips.TYPE_FAR then 
    	phyNum:setString("连续行走不能超过10格")
   	end

    self:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
    								cc.RemoveSelf:create()))
end
