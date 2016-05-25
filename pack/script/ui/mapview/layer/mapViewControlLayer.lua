
MapViewDateInfoLua = class("MapViewDateInfoLua")

function MapViewDateInfoLua:create(sFilePath)
	self = MapViewDateInfoLua.new();
	self.pDate = require(sFilePath);
	return self;
end

function MapViewDateInfoLua:getObstacleDate()
	local pLayers = self.pDate.layers;
	for k,v in pairs(pLayers) do
		if v.name == "pobstacle" then 
			return v.data;
		end
	end

	return nil
end


function MapViewDateInfoLua:getLinkDate()
	local pLayers = self.pDate.layers;
	for k,v in pairs(pLayers) do
		if v.name == "linkview" then 
			return v.data;
		end
	end

	return nil
end



--------------------------------------------------------------------------障碍物层


local MAP_VIEW_OBSTACLE_LAYER_TAB={
	dateTab=nil,
	iSize=nil;
}

MapViewObstacleLayer = class("MapViewObstacleLayer");

function MapViewObstacleLayer:create(pTab,iSize)
	self = MapViewObstacleLayer.new();
	self.iSize = iSize;
	self:initAttr(pTab)
	return self;
end

function MapViewObstacleLayer:initAttr(pTab)
	self.dateTab={};
	for i=1,self.iSize.height do
		self.dateTab[i]={};
		for j=1,self.iSize.width do
			self.dateTab[i][j]=0;
		end
	end	

	for i=1,self.iSize.height do
		for j=1,self.iSize.width do
			local index = (i-1)*self.iSize.width+j;
			self.dateTab[i][j]=pTab[index];
		end
	end

end

function MapViewObstacleLayer:getDate(pIndex)
	return self.dateTab[pIndex.y+1][pIndex.x+1]
end



--------------------------------------------------------------------------数据层
local MAP_VIEW_DATE_LAYER_TB={
	layerSize=nil,
	dateTab =nil,
	displayLayer =nil,
}

MapViewDateLayer = class("MapViewDateLayer");

function MapViewDateLayer:create(iSize,displayLayer)
	self = MapViewDateLayer.new();
	self.layerSize = iSize;
	self.displayLayer = displayLayer;
	self:initAttr()
	return self;
end

function MapViewDateLayer:initAttr()
        self.dateTab={};
        for i=1,self.layerSize.height do
            for j=1,self.layerSize.width do
            	local index = (i-1)*self.layerSize.width+j;
                self.dateTab[index]=MapView.MAP_DISABLE_MOVE_ID
            end
        end
end

function MapViewDateLayer:getDate(pIndex)
	local index = (pIndex.y+1-1)*self.layerSize.width+pIndex.x+1;
	return self.dateTab[index];
end

function MapViewDateLayer:setDate(iValue,pIndex)
    local index = (pIndex.y-1+1)*self.layerSize.width+pIndex.x+1;
    self.dateTab[index]=iValue
end

function MapViewDateLayer:getPositionAt(pIndex)
	return self.displayLayer:getPositionAt(pIndex)
end

function MapViewDateLayer:getTab()
	return self.dateTab;
end