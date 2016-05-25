require("script/ui/mapview/role/mapViewRole")



local TB_MAP_VIEW_OBJECT_MASK_LAYER={
	mapView = nil,
	role = nil,
	roadDirTab=nil,
	functionInfoLayer =nil,
}

MapViewObjectMaskLayer = class("MapViewObjectMaskLayer",function()
	return cc.Node:create()
end,TB_MAP_VIEW_OBJECT_MASK_LAYER)


function MapViewObjectMaskLayer:create(mapView)
	self = MapViewObjectMaskLayer.new();
	self.mapView = mapView;
	self:initAttr();
	return self;
end

function MapViewObjectMaskLayer:ctor()
	self.roadDirTab = {};
end

function MapViewObjectMaskLayer:initAttr()

	local function fun_update(float)
		self:updatePlayer();
	end

	self.functionInfoLayer = cc.Node:create();
	self:addChild(self.functionInfoLayer);
	self.functionInfoLayer:setLocalZOrder(10);
	
	self:scheduleUpdateWithPriorityLua(fun_update,0);
end


function MapViewObjectMaskLayer:updatePlayer()

	if true then 
		return;
	end

	if self.mapView.role  == nil then 
		return
	end

	if self.role == nil then
		self.role = cc.Sprite:create("res/map/maprole_mask.png");
		self.role:setAnchorPoint(cc.p(0.5,0.0))
		self:addChild(self.role);
	else
		self.role:setPosition(self.mapView.role:getPositionX(),self.mapView.role:getPositionY());
		if self.mapView.role:isVisible() == false then 
			self.role:setVisible(false)
		end
	end
end


function MapViewObjectMaskLayer:setRoleDispaly(bValue)
	self.role:setVisible(bValue)
end


function MapViewObjectMaskLayer:addRoadDirction(pNode)
	self:addChild(pNode)
	table.insert(self.roadDirTab,pNode);	--加入到集合
end

--移除道路指引
function MapViewObjectMaskLayer:removeRoadDirection(indexPos)
	-- body
	for i,var in pairs(self.roadDirTab) do
		if var.isMapViewRoadDir== true and
			var.indexPos.x==indexPos.x and
			var.indexPos.y==indexPos.y then
			 	var:removeFromParent()
			 	table.remove(self.roadDirTab,i)
		break;
		end
	end
end

--移除所有的道路指引
function MapViewObjectMaskLayer:removeAllRoadDirection()
	-- body
	local iSize = table.getn(self.roadDirTab)
	for i=iSize,1,-1 do
		self.roadDirTab[i]:removeFromParent()
		table.remove(self.roadDirTab,i)
	end
end


--添加特效奖励
function MapViewObjectMaskLayer:rewardEffect(bRwardList)
    local pEffect = MapViewGetResTips:create(bRwardList)
    pEffect:setPosition(cc.p(self.mapView.role:getPositionX(),self.mapView.role:getPositionY()))
    self:addChild(pEffect)
end

--补给特效
function MapViewObjectMaskLayer:addSupply(num)
    num = tonumber(num)

    local pEffect = MapViewSupplyEffect:create(num)
    pEffect:setPosition(cc.p(self.mapView.role:getPositionX(),self.mapView.role:getPositionY()))
    self:addChild(pEffect)

end


--添加功能建筑u详情面板
function MapViewObjectMaskLayer:addFunctionInfoPanel(panel)
	self.functionInfoLayer:addChild(panel);
end

--移除所有功能建筑详情面板
function MapViewObjectMaskLayer:removeAllFunctionInfoPanel()
	self.functionInfoLayer:removeAllChildren();
end