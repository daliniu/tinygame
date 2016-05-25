--探索地图前景层

MapViewForegroundLayer = class("MapViewForegroundLayer",KGC_UI_BASE_SUB_LAYER)

function MapViewForegroundLayer:create()
	self = MapViewForegroundLayer.new()
	self:initAttr()
	return self
end

function MapViewForegroundLayer:ctor()
	-- body
	
end

function MapViewForegroundLayer:OnExit()
	if self.animationAction ~=nil then 
		self.animationAction:stop();
	end
end


function MapViewForegroundLayer:initAttr()

   	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapcloudfront.json")
    self:addChild(self.pWidget)

	-- 动画加上
	self.animationAction = ccs.ActionManagerEx:getInstance():playActionByName("mapcloudfront.json", "Animation0")	



end