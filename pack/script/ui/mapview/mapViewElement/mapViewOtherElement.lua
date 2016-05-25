--其余元素物体
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/core/configmanager/configmanager");

local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");
--local postboxfile = require("script/cfg/map/building/postbox")

--------------------------------------------------------------
--邮箱

MapViewMailBox = class("MapViewMailBox",function()
	return MapViewElementBase:create()
end)


function MapViewMailBox:create(id)
	self = MapViewMailBox.new()
	self.id = id
	self:initAttr()
	return self
end


function MapViewMailBox:ctor()
	-- body
end


function MapViewMailBox:initAttr()
	
	self.firstType = MapViewElementBase.FL_TYPE_OTHER 				--一级类型
	self.subType = MapViewElementBase.TYPE_MAILBOX 					--次级类型


	self.pConfig = postboxfile[self.id]
	
	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
	self:addChild(self.spDisplay)

end


function MapViewMailBox:getReward()
	-- body
end