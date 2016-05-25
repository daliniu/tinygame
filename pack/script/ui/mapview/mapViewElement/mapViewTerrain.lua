--地形
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/core/configmanager/configmanager");

local terrainConfigfile = mconfig.loadConfig("script/cfg/map/building/lsurface")

MapViewTerrain = class("MapViewTerrain",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_TERRAIN)

local TB_MAP_VIEW_TERRAIN={
}

function MapViewTerrain:create(id)
	self = MapViewTerrain:new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewTerrain:ctor()
	-- body
end

function MapViewTerrain:initAttr()

end


--获取返回区域（）地形类不阻碍运动
function MapViewTerrain:getEffectedArea()
	-- body
	local pTab = {}
	return pTab
end
--地形类不阻碍运动
function MapViewTerrain:isEffectIndexArea(indexPoint)
	return false;
end

function MapViewTerrain:getUse(currentInde,pathTab)
	-- body
	return MapView.physicalExertionPer*self.pConfig.APCostTimes;
end

--所指定
function MapViewTerrain:isAddPhysicalExertion(indexPoint)
	if indexPoint.x >= self.indexPos.x
		and indexPoint.x < self.indexPos.x+self.pConfig["Area"][1]
		and indexPoint.y >= self.indexPos.y
		and indexPoint.y < self.indexPos.y+self.pConfig["Area"][2] then
		return true
	end

	return false;
end

--获取移动时间
function MapViewTerrain:getMoveTime()
	return self.pConfig.Speed;
end


------------------------------------------------------------------------------------------------
--沼泽
MapViewTerrainMarsh = class("MapViewTerrainMarsh",function()
	return MapViewTerrain.new()
end)

function MapViewTerrainMarsh:create(id)
	self = MapViewTerrainMarsh:new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewTerrainMarsh:ctor()
	-- body
end

function MapViewTerrainMarsh:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_TERRAIN 				--一级类型
	self.subType = MapViewElementBase.TYPE_MARSH 						--次级类型

	self.pConfig = terrainConfigfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:addBaseEffect();
end


-----------------------------------------------------------------------------------------------------
--大风
MapViewTerrainWind = class("MapViewTerrainWind",function()
	return MapViewTerrain.new()
end)

function MapViewTerrainWind:create(id)
	self = MapViewTerrainWind:new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewTerrainWind:ctor()
	-- body
end

function MapViewTerrainWind:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_TERRAIN 				--一级类型
	self.subType = MapViewElementBase.TYPE_WIND 						--次级类型

	self.pConfig = terrainConfigfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)
end