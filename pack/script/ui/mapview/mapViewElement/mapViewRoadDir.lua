--地面道路提示
require("script/ui/mapview/mapViewElement/mapViewElementBase")


local l_tbUIUpdateType = def_GetUIUpdateTypeData();

MapViewRoadDir = class("MapViewRoadDir",function()
	return ccui.Widget:create()
end,TB_MAP_VIEW_ROAD_DIR)


MapViewRoadDir.type_normal 		= 1;		--正常
MapViewRoadDir.type_far    		= 2;		--太远
MapViewRoadDir.type_physical 	= 3;		--体力不够

local TB_MAP_VIEW_ROAD_DIR={
	type,				--类型
	nextIndexPos = nil,		--下一个的位置
	lastIndexPos = nil,		--上一个的位置
	spDisplay    = nil,		    	--显示精灵
	isMapViewRoadDir = true,
	iPhysical = nil,			--体力
	phyNum = nil,
	spLastPoint =nil,
	numBg =nil,
	imgRes=nil,
}


function MapViewRoadDir:create(type,indexPos,nextIndexPos,lastIndexPos,iPhysical)
	-- body
	self = MapViewRoadDir:new()
	self.type = type
	self.indexPos =indexPos;
	self.nextIndexPos = nextIndexPos;
	self.lastIndexPos = lastIndexPos
	self.iPhysical = iPhysical
	self:initAttr()
	return self
end

function MapViewRoadDir:ctor()
	self.isMapViewRoadDir = true
end

function MapViewRoadDir:initAttr()

	--条件不足的时候表现效果一致
	local imgType = self.type
	if self.type~=MapViewRoadDir.type_normal then 
		imgType = MapViewRoadDir.type_far
	end

	--test end
	if self.nextIndexPos ~= nil then
		if imgType ==1 then 
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_path_0a/effect_map_path_0a.ExportJson");
			self.imgRes = ccs.Armature:create("effect_map_path_0a")
			self.imgRes:getAnimation():playWithIndex(0)
		elseif imgType == 2 then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_path_0b/effect_map_path_0b.ExportJson");
			self.imgRes = ccs.Armature:create("effect_map_path_0b")
			self.imgRes:getAnimation():playWithIndex(0)
		end

		self:addChild(self.imgRes);
		self.imgRes:setAnchorPoint(cc.p(0.49,0.22))
		self.imgRes:setPosition(cc.p(100,50))
	end
	
	--最后一个节点上会有一个提示
	if self.nextIndexPos == nil then

		if imgType ==1 then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_pathend_0a/effect_map_pathend_0a.ExportJson");
			self.spLastPoint  = ccs.Armature:create("effect_map_pathend_0a")
			self.spLastPoint:getAnimation():playWithIndex(0)
		elseif imgType ==2 then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_pathend_0b/effect_map_pathend_0b.ExportJson");
			self.spLastPoint  = ccs.Armature:create("effect_map_pathend_0b")
			self.spLastPoint:getAnimation():playWithIndex(0)
		end

		self.spLastPoint:setScale(0.5)
		self.spLastPoint:setPosition(cc.p(100,50))
		self.spLastPoint:setAnchorPoint(cc.p(0.52,0.37))
		self:addChild(self.spLastPoint)


		if self.spDisplay ~= nil then 
			self.spDisplay:removeFromParent()
		end
		--体力提示

		self.numBg = cc.Sprite:create("res/ui/06_exmainUI/06_bg_AP.png")
		self.numBg:setAnchorPoint(cc.p(0.5,1))
		self.numBg:setPosition(cc.p(70,25))
		self:addChild(self.numBg)


		self.phyNum= ccui.Text:create();
     	self.phyNum:setString(self.iPhysical)
     	self.phyNum:setPosition(cc.p(45,8))
     	self.phyNum:setAnchorPoint(cc.p(0,0));
     	self.phyNum:setColor(cc.c3b(240,226,192))
     	self.phyNum:setFontSize(20)
     	self.numBg:addChild(self.phyNum);	end	

end

---更新体力
function MapViewRoadDir:updatePhyNum(pValue)
	if self.phyNum~=nil then 
		local _value = tonumber(self.phyNum:getString()) - pValue;
		self.phyNum:setString(_value)
	end
end

--设置缩放
function MapViewRoadDir:setImgScale(fValue)
	self.spLastPoint:setScale(fValue*0.5);
end
--获取图片缩放
function MapViewRoadDir:getImgScale()
	return self.spLastPoint:getScale();
end

--设置图片位置
function MapViewRoadDir:setImgPos(fPos)
	self.spLastPoint:setPosition(fPos)
	self.numBg:setPosition(cc.p(fPos.x+20,fPos.y))
end

--获取图片位置
function MapViewRoadDir:getImgPos()
	return cc.p(self.spLastPoint:getPosition())
end

--设置所有元素半透明显示
function MapViewRoadDir:setChildOp(fValue)
	if self.imgRes ~= nil then 
		self.imgRes:setOpacity(fValue);
	end
	if self.spLastPoint~=nil then 
		self.spLastPoint:setOpacity(fValue);
	end
end


--拷贝属性
--pNode是MapViewRoadDir的对象指针
function MapViewRoadDir:copyAttrAndCreateNewDir()
	-- local _newDir = MapViewRoadDir:create(self.type,
	-- 									self.indexPos,
	-- 									self.nextIndexPos,
	-- 									self.lastIndexPos,
	-- 									self.iPhysical);
	-- _newDir:setPosition(self:getPosition());
	-- _newDir:setLocalZOrder(self:getLocalZOrder());
	-- if self.spLastPoint~=nil then
	-- 	_newDir:setImgScale(self:getImgScale()*2.0);
	-- end

	-- _newDir:setChildOp(80);
	return self:clone();
end
