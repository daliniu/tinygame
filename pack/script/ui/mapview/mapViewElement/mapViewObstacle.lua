--障碍物
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/ui/mapview/effect/mapViewElementCommonTips");
require("script/core/configmanager/configmanager");

obstacleFile = mconfig.loadConfig("script/cfg/map/building/obstacle")

local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");

MapViewObstacle = class("MapViewObstacle",function()
	return MapViewElementBase:create()
end)

local TB_MAP_VIEW_OBSTACLE = {
	
}

local ItemConfigFile = mconfig.loadConfig("script/cfg/pick/item");

function MapViewObstacle:create(id)
	self = MapViewObstacle:new();
	self.id = id;
	self:initAttr();
	return self;
end

function MapViewObstacle:ctor()
	-- body
end

function MapViewObstacle:initAttr()

end
--获取返回区域（阻碍运动）
function MapViewObstacle:getEffectedArea()
	local pTab = {}
	if self.pConfig~=nil then 
		for i=0,self.pConfig["Area"][1]-1 do
			for j=0,self.pConfig["Area"][2]-1 do
				local _x = self.indexPos.x-i;
				local _y = self.indexPos.y-j;
				if _x<0 then 
					_x=0;
				end
				if _y<0 then 
					_y=0;
				end
				table.insert(pTab,cc.p(_x,_y))
			end
		end
	else
		
	end
		
	return pTab
end

-- --所指定的点，是否影响到了运动
-- function MapViewObstacle:isEffectIndexPoint(indexPoint)
-- 	if self.pConfig==nil then 
-- 		return false;
-- 	end
-- 	if indexPoint.x <= self.indexPos.x
-- 		and indexPoint.x >= self.indexPos.x-self.pConfig["Area"][1]
-- 		and indexPoint.y <= self.indexPos.y
-- 		and indexPoint.y >= self.indexPos.y+self.pConfig["Area"][2] then
-- 		return true
-- 	end

-- 	return false;
-- end

--所占的格子
function MapViewObstacle:isInPosArea(indexPoint)
	if self.pConfig==nil then 
		if self.indexPos.x ==indexPoint.x and
			self.indexPos.y == indexPoint.y then 
			return true
		else
			return false;
		end
	end
	if indexPoint.x <= self.indexPos.x
		and indexPoint.x > self.indexPos.x-self.pConfig["Area"][1]
		and indexPoint.y <= self.indexPos.y
		and indexPoint.y > self.indexPos.y-self.pConfig["Area"][2] then
		return true
	end

	return false;
end



----------------------------------------------------------------------------------------------
--可移除障碍
MapViewObstacleRemove = class("MapViewObstacleRemove",function()
	return MapViewObstacle.new()
end)

function MapViewObstacleRemove:create(id)
	self = MapViewObstacleRemove:new();
	self.id = id;
	self:initAttr();
	return self;
end

function MapViewObstacleRemove:ctor()
	-- body
end

function MapViewObstacleRemove:initAttr()

	self.firstType = MapViewElementBase.FL_TYPE_OBSTACLE 				--一级类型
	self.subType = MapViewElementBase.TYPE_OBSTACLE_REMOVE 				--次级类型


	local _file = mconfig.loadConfig("script/cfg/exploration/lobstacle")
	self.pConfig = _file[self.id]
	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
end

function MapViewObstacleRemove:getNeedItemName()
	local ToItem = self.pConfig.ToItem;
	local _name = ItemConfigFile[tonumber(ToItem)].itemName
	return _name;
end

function MapViewObstacleRemove:addItemTips()
	local _sName = self:getNeedItemName();
	local _tips = MapViewElementCommonTips:create("可被 ".._sName.." 移除");
	self:addChild(_tips)
end


----------------------------------------------------------------------------------------------
--不可移除障碍
MapViewObstacleUnremove = class("MapViewObstacleUnremove",function()
	return MapViewObstacle.new()
end)


function MapViewObstacleUnremove:create(id)
	self = MapViewObstacleUnremove:new();
	self.id = id;
	self:initAttr();
	return self;
end

function MapViewObstacleUnremove:ctor()
	-- body
end

function MapViewObstacleUnremove:initAttr()

	self.firstType = MapViewElementBase.FL_TYPE_OBSTACLE 				--一级类型
	self.subType = MapViewElementBase.TYPE_OBSTACLE_UNREMOVE 			--次级类型

	print(self.id)
	self.pConfig = obstacleFile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)
end

function MapViewObstacleUnremove:getOffsetPos()
	local pos=cc.p(0,0)
	pos.x = tonumber(self.pConfig.XOffset);
	pos.y = tonumber(self.pConfig.YOffset);
	return pos;
end

function MapViewObstacleUnremove:getVisualEffectedArea()
	local pTab = {}
	if self.pConfig~=nil then
		for i=0,self.pConfig["Area"][1]-1 do
			for j=0,self.pConfig["Area"][2]-1 do
				local _x = self.indexPos.x-i;
				local _y = self.indexPos.y-j;
				if _x<0 then
					_x=0;
				end
				if _y<0 then 
					_y=0;
				end
				table.insert(pTab,cc.p(_x,_y))
			end
		end
	else
		table.insert(pTab,cc.p(self.indexPos.x,self.indexPos.y))	
	end


	return pTab
end