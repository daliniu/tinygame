
local TB_MAP_VIEW_NPC={

}

require("script/core/configmanager/configmanager");

local npcConfig = mconfig.loadConfig("script/cfg/map/building/npc");

MapViewNpc = class("MapViewNpc",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_NPC)


function MapViewNpc:create(id)
	-- body
	self = MapViewNpc.new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewNpc:ctor()
	-- body
end

function MapViewNpc:initAttr()
		-- body
	self.firstType = MapViewElementBase.FL_TYPE_NPC 				--一级类型
	self.subType = MapViewElementBase.TYPE_NPC 						--次级类型


	self.pConfig = npcConfig[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
	self:addChild(self.spDisplay)

	self:initState();
	self:initTouchBox();
	self:addBaseEffect();
end

--远处查看层
function MapViewNpc:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	return pLayer;
end

function MapViewNpc:getEnterFunction(functionChooseLayer)
	functionChooseLayer:fun_openNPCDialog(self)
	return pLayer;
end