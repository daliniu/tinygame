--探索地图背景层


MapViewBackgroundLayer = class("MapViewBackgroundLayer",KGC_UI_BASE_SUB_LAYER)

function MapViewBackgroundLayer:create()
	self = MapViewBackgroundLayer.new()
	self:initAttr()
	return self
end

function MapViewBackgroundLayer:ctor()
	-- body
	
end



function MapViewBackgroundLayer:OnExit()
	if self.animationAction ~=nil then 
		self.animationAction:stop();
	end
end

function MapViewBackgroundLayer:initAttr()
    self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapcloudback.json")
    self:addChild(self.pWidget)

	self:initUpdate();

	-- 动画加上
	self.animationAction = ccs.ActionManagerEx:getInstance():playActionByName("mapcloudback.json", "Animation0")	
	
end

function MapViewBackgroundLayer:initUpdate()

end


function MapViewBackgroundLayer:move()
	
end