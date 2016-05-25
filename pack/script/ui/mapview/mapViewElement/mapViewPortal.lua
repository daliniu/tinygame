--传送门
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/core/configmanager/configmanager");

local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");
local portalfile = mconfig.loadConfig("script/cfg/map/building/portal")

MapViewPortal = class("MapViewPortal",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_PORTAL)

local TB_MAP_VIEW_PORTAL={
	id=0,
	spDisplay = nil,
	isMapViewPortal = true,
}


function MapViewPortal:create(id)
	self = MapViewPortal.new()
	self.id = id
	self:initAttr()
	return self
end


function MapViewPortal:ctor()
	-- body
end


function MapViewPortal:initAttr()
	
	self.firstType = MapViewElementBase.FL_TYPE_PORTAL 				--一级类型
	self.subType = MapViewElementBase.TYPE_PORTAL_NORMAL 			--次级类型



	self.pConfig = portalfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:addBaseEffect();
end



function MapViewPortal:deliver()
	-- body
end