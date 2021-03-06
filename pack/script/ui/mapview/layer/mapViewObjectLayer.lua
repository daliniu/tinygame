--物体显示层
require("script/ui/mapview/mapViewElement/mapViewBuilding")
require("script/ui/mapview/mapViewElement/mapViewRoadDir")
require("script/ui/mapview/mapViewElement/mapViewEnemy")
require("script/ui/mapview/mapViewElement/mapViewOnHookPoint")
require("script/ui/mapview/mapViewElement/mapViewProps")
require("script/ui/mapview/mapViewElement/mapViewPortal")
require("script/ui/mapview/mapViewElement/mapViewTerrain")
require("script/ui/mapview/mapViewElement/mapViewObstacle")
require("script/ui/mapview/mapViewElement/mapViewOtherElement")
require("script/ui/mapview/mapViewElement/mapViewNpc")
require("script/ui/mapview/effect/mapViewElementEffect")

local TB_MAP_VIEW_OBJECT_LAYER={
	objDateLayer 	= 	nil,
	mapView 		=	nil,
	objectDate 		= 	nil,
	layerSize 		= 	nil,
	titleSize 		= 	nil,
	uidIndex 		=	nil,
	functionElementTab 	=	nil,				--功能元素tab
	roadDirTab			=	nil,				--道路指引tab
	backgroundTab 		=	nil,				--地面背景
	obstacleTab 		=	nil,				--障碍物tab

	linkDate            = nil,          --联动层   

	--控制节点
	groundLayerSecond = nil,	--负二层 
	groundLayerNode = nil,		--负一层
	firstLayerNode  = nil,		--第一节点
	secondLayerNode = nil,		--第二节点
}


MapViewObjectLayer = class("MapViewObjectLayer",function()
	return cc.Node:create()
end,TB_MAP_VIEW_OBJECT_LAYER)

MapViewObjectLayer.ZORDER_GROUND = -2500;
MapViewObjectLayer.ZORDER_ITEM   = 1;
MapViewObjectLayer.ZORDER_TOP    = 2;


function MapViewObjectLayer:create(objDateLayer,mapView)
	self = MapViewObjectLayer:new()
	self.objDateLayer = objDateLayer;
	self.mapView = mapView;
	self:initAttr()
	return self
end

function MapViewObjectLayer:ctor()
	-- body
	self.uidIndex=1;
	self.functionElementTab={};
	self.roadDirTab ={};
	self.backgroundTab={};
	self.obstacleTab={};

	self.groundLayerSecond = cc.Node:create();
	self:addChild(self.groundLayerSecond);

	self.groundLayerNode = cc.Node:create();
	self:addChild(self.groundLayerNode);
	self.firstLayerNode = cc.Node:create();
	self:addChild(self.firstLayerNode);
	self.secondLayerNode = cc.Node:create();
	self:addChild(self.secondLayerNode);

end

function MapViewObjectLayer:initAttr()
	self.layerSize = self.mapView.layerSize
	self.titleSize = self.mapView.tileSize
	self:initDate(); --数据,(把数据信息从titl层映射到这里)
end

function MapViewObjectLayer:initDate()
	self.objectDate={};
	local mapSize = self.mapView.layerSize
	for i=0,mapSize.width -1,1 do
		self.objectDate[i]={}
		for j=0,mapSize.height - 1,1 do
			self.objectDate[i][j]=0
		end
	end

	for i=0,mapSize.width -1,1 do
		for j=0,mapSize.height - 1,1 do
			self.objectDate[i][j]=0
		end
	end
end


function MapViewObjectLayer:addObjectWithTB(tbObj,order)
	for i,var in pairs(tbObj) do
		local varID = var.name;
		local subType = tonumber(var.type)
		local indexPos = nil;
		indexPos = cc.p(tonumber(var.gridx),tonumber(var.gridy));
		local widthAndHeight = cc.p(tonumber(var.width),tonumber(var.height));
		local pos = cc.p(var.x,self.layerSize.height*self.titleSize.height-var.y);
		local pObject = nil
		local uid = var.userid
		--self.uidIndex=self.uidIndex+1

		if subType == MapViewElementBase.TYPE_BUILDING_SUPPLY then			--补给建筑
			pObject = MV_building_supply:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_BUILDING_BUFF then		--buff点
			pObject = MV_building_buff:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_BUILDING_STATION then		--交通站
			pObject = MV_building_transport:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_BUILDING_INTE then		--情报站
			pObject = MV_building_inte:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_BUILDING_SHOP then		--商店
			pObject = MV_building_shop:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_BUILDING_WATCHTOWER then	--瞭望塔
			pObject = MV_building_watchTower:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_RES_NORMAL then			--普通资源
			pObject = MV_props_noraml:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_RES_CHOOSE then			--选择性资源
			pObject = MV_props_choose:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_HOOK_NORMAL then			--普通挂机点
			pObject = MV_onHook_noraml:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_HOOK_LIMIT then			--限制挂机点
			pObject = MV_onHook_limitDelay:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_HOOK_AtONCE then			--限时挂机点（立即)
			pObject = MV_onHook_limitAtOnce:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_ENEMY_NORMAL then			--普通怪
			pObject = MV_enemy_moraml:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_ENEMY_CHOOSE then			--选择性
			pObject = MV_enemy_choose:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_ENEMY_CONTINUOUS then		--连续挑战
			pObject = MV_enemy_consecutive:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_ENEMY_UNKNOWN then		--未知怪
			pObject = MV_enemy_unknown:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)			

		elseif subType == MapViewElementBase.TYPE_ENEMY_EXIT then			--出口怪
			pObject = MV_enemy_exit:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_PORTAL_NORMAL then		--传送门
			pObject = MapViewPortal:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType == MapViewElementBase.TYPE_MAILBOX then				--邮筒
			pObject = MapViewMailBox:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType ==MapViewElementBase.TYPE_MARSH then					--沼泽
			pObject = MapViewTerrainMarsh:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_GROUND)

		elseif subType ==MapViewElementBase.TYPE_WIND then					--大风
			pObject = MapViewTerrainWind:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType ==MapViewElementBase.TYPE_OBSTACLE_REMOVE then		--可移除障碍
			pObject = MapViewObstacleRemove:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		elseif subType ==MapViewElementBase.TYPE_OBSTACLE_UNREMOVE then		--不可移除障碍
			pObject = MapViewObstacleUnremove:create((varID))
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)
		elseif subType ==MapViewElementBase.TYPE_NPC then 					--NPC
			pObject = MapViewNpc:create((varID));
			pObject:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)
		end

		if pObject ~= nil  then
			if order ==1 then
				self.firstLayerNode:addChild(pObject)
			elseif order ==2 then
				self.secondLayerNode:addChild(pObject)
			elseif order == -1 then
				self.groundLayerNode:addChild(pObject);
			elseif order == -2 then
				self.mapView.objectLayerDown:addChild(pObject);
			end

			--管理器
			pObject.controlManager = self;
			--功能管理
			pObject.functionManager = self.mapView.functionChooseLayer

			--位置
			pObject:setIndexPos(indexPos)

			--图片尺寸
			pObject:setImageSize(widthAndHeight);

			--pos.x =pos.x-widthAndHeight.x*0.5
			pos.y =pos.y-widthAndHeight.y
			local _realPos=self:transformPosition(pos)
			-- _realPos.x=_realPos.x+indexPos.x 				--注意：tile内部会根据图片宽高数值做位置偏移
			-- _realPos.y=_realPos.y+indexPos.y
			pObject:setPosition(_realPos)

			--uid
			pObject.uid = uid;
			
			if subType ~=MapViewElementBase.TYPE_OBSTACLE_UNREMOVE then 
				table.insert(self.functionElementTab,pObject);	--障碍物不加入物体集合
				--影响区域
				local pEffectArea = pObject:getEffectedArea()
				for _i,_var in pairs(pEffectArea) do
					self.mapView:addInfoForObjectDateLayer(_var,nil)
				end
			else
				local offsetPos = pObject:getOffsetPos();
				pos.x =pos.x + offsetPos.x;
				pos.y =pos.y - offsetPos.y;
				local _ideX = math.floor(pos.x*(1/(self.titleSize.width*0.5)));		--障碍物需要重新指定index
				local _ideY = math.floor(pos.y*(1/(self.titleSize.width*0.5)));
				if _ideX>=self.layerSize.width then 
					_ideX=self.layerSize.width-1
				end
				if _ideY >=self.layerSize.height then 
					_ideY=self.layerSize.height-1
				end

				pObject:setIndexPos(cc.p(_ideX,_ideY));
				table.insert(self.obstacleTab,pObject);		--障碍物单独的集合
			end

			
			--默认不显示
			pObject:setVisible(false);


			--设置zorder
			local outLine=cc.p(0,0)
			local pVisualArea = pObject:getVisualEffectedArea()
			for _i,_var in pairs(pVisualArea) do
				if _var.x>=outLine.x then 
					outLine.x = _var.x
				end
				if _var.y>=outLine.y then 
					outLine.y = _var.y
				end	
			end
			self:setObjectZorder(pObject,outLine,0);

			--读取服务器数据
			if MapViewLogic:getInstance().mapElementStateList ~= nil then
				local _currentState = MapViewLogic:getInstance().mapElementStateList[tostring(uid)]
				if _currentState~= nil then
					pObject:setState(_currentState);				--状态
					--pObject:setArgs(_currentState.args);			--附加参数
					pObject:initAttrWithPlayerHookPointDate();	
					pObject:updateFuncitonWithState();				--根据状态更新功能
					if pObject:checkIsAbleRemove() == true then 	--如果物体是一脸要被干掉的样子
						pObject:setBeRemoved();						--干掉
					end

				end
			end
  
		end 

	end

end


function MapViewObjectLayer:setObjectZorder(pObj,outIndex,baseZorder)
	if pObj==nil then 
		return;
	end
	if baseZorder ==nil then 
		return;
	end

	if outIndex==nil or outIndex.x==nil or outIndex.y ==nil then 
		return;
	end

	local iz = outIndex.y*300+outIndex.x*300+baseZorder;
	pObj:setLocalZOrder(iz)
end

--------------------------------------------------------
--删除物体数据(只删除元素物体)
function MapViewObjectLayer:removeElementObjectDate(pObject)
	--影响区域
	local pEffectArea = pObject:getEffectedArea()
	for i,var in pairs(pEffectArea) do
		self.mapView:removeInfoForObjectDateLayer(var,nil)
	end
end

--删除功能元素
function MapViewObjectLayer:removeFunctionElementObject(pObject)
	for i,v in ipairs(self.functionElementTab) do
		if v == pObject  then 
			table.remove(self.functionElementTab,i)
			return
		end
	end
end


--位置变换
function MapViewObjectLayer:transformPosition(pos)
	local _x = self.titleSize.width*pos.x/(2*self.titleSize.height)
				- self.titleSize.width*pos.y/(2*self.titleSize.height)
	local _y = pos.x/2+pos.y/2

	local _pos = cc.p(self.layerSize.width*0.5*self.titleSize.width+_x,
						self.layerSize.height*self.titleSize.height-_y)
	return _pos
end


--更新数据
function MapViewObjectLayer:updateDate(posIndex,id,pTab)
	self.objectDate[posIndex.x][posIndex.y] = id
end

--获取数据
function MapViewObjectLayer:getDate(posIndex)
	return self.objectDate[posIndex.x][posIndex.y]
end

--获取物体(不包含地形)
function MapViewObjectLayer:getObject(posIndex)
	local pTab = {};
	for i,var in pairs(self.functionElementTab) do 
		if var.indexPos ~= nil and 
			var.firstType ~= MapViewElementBase.FL_TYPE_TERRAIN then 
			if var:isEffectIndexPoint(posIndex) then 
				table.insert(pTab,var)
			end
		end
	end
	return pTab
end

--设置物体显示
function MapViewObjectLayer:setObjectVisible(indexPos,bValue)
	--物体动画
	local function fun_addAnim(var)
		if var:isVisible()==false then
			local fDelayTime = 0.2 + gf_Random()*0.2
			var:setVisible(true)
			if var.subType == MapViewElementBase.TYPE_OBSTACLE_UNREMOVE then		--障碍物
				var:setScale(0);
				local pAction =cc.Sequence:create(cc.DelayTime:create(fDelayTime),cc.ScaleTo:create(0.4,1))
				var:runAction(pAction);
			elseif var.subType ==MapViewElementBase.TYPE_MARSH  then				--沼泽
				var:setScale(0)
				local pAction =cc.Sequence:create(cc.DelayTime:create(fDelayTime),cc.ScaleTo:create(0.4,1))
				var:runAction(pAction);
			else 																	--其他物体
				var:setPositionY(var:getPositionY()+1000)
				local pAction =cc.Sequence:create(cc.DelayTime:create(fDelayTime),cc.MoveBy:create(0.5,cc.p(0,-1000)))
				var:runAction(pAction);				
			end
		end
	end


	--记录本次被激活的所有区域
	local tempAreaTab ={};

	local function fun_isAdd(pIndex)
		for k,v in pairs(tempAreaTab) do
			if v.x == pIndex.x and
				v.y == pIndex.y then
				return true
			end
		end
		return false;

	end


	if fun_isAdd(indexPos) == false then
		table.insert(tempAreaTab,indexPos)
	end
	 
	--障碍物
	for i,var in pairs(self.obstacleTab) do
		if var:isInPosArea(indexPos) then
			fun_addAnim(var);
		end
	end

	--功能元素
	for i,var in pairs(self.functionElementTab) do
		if var:isInPosArea(indexPos) then
			fun_addAnim(var);
		end
	end

	--保证功能类建筑被激活
	for k,v in pairs(tempAreaTab) do
		for i,var in pairs(self.functionElementTab) do 
			if var:isInPosArea(v) then
				fun_addAnim(var);
			end
		end
	end

end

--联动激活物体
function MapViewObjectLayer:linkActiveObject(indexPos)
	local linkTab = self:getLinkDate(indexPos);
	if linkTab ~=nil then 
		for k,v in pairs(linkTab) do
			self:setBGVisible(v,true)
			self:setObjectVisible(v,true);
		end
	end
end


--设置物体半透明
function MapViewObjectLayer:setObjectAlphaValueWithPos(indexPos)

	-- for i,var in pairs(self.obstacleTab) do
	-- 	if var:isNeedtranslucent(indexPos) then 
	-- 		var:setImgOpacity(100)
	-- 	else
	-- 		var:setImgOpacity(255)
	-- 	end
	-- end

	-- for i,var in pairs(self.functionElementTab) do
	-- 	if var:isNeedtranslucent(indexPos) then 
	-- 		var:setImgOpacity(100)
	-- 	else
	-- 		var:setImgOpacity(255)
	-- 	end
	-- end

	local bValue = false;
	for i,var in pairs(self.obstacleTab) do
		if var:isNeedtranslucent(indexPos) then 
			bValue = true;
		else
			
		end
	end

	for i,var in pairs(self.functionElementTab) do
		if var:isNeedtranslucent(indexPos) then 
			bValue = true;
		else
			
		end
	end	

	self.mapView.ObjectMaskLayer:setRoleDispaly(bValue);

end


--根绝UID获取物体
function MapViewObjectLayer:getObjectWihtUID(uid)
	if uid ==nil then 
		return nil
	end

	for i,var in pairs(self.functionElementTab) do 
		if var.uid == uid then
			return var
		end
	end
	return nil
end



-- 角色
--------------------------------------------------------
function MapViewObjectLayer:addPlayerRole(role)
	self.firstLayerNode:addChild(role)
	self:updatePlayerRole(role)
end

function MapViewObjectLayer:updatePlayerRole(role)
	self:setObjectZorder(role,role:getPosIndex(),0)
end


-----------------------------------------------------敌人--------------------------------------------------------
--移除敌人
function MapViewObjectLayer:removeEnemy(indexPos)
	
end


-----------------------------------------------------道路指引---------------------------------------------------------

--添加道路指引
function MapViewObjectLayer:addRoadDirction(pTable,iPhysical,phyTab)
	-- body
	local iphy =0;
	for i=1,table.getn(pTable) do
		local lastPos=nil
		local nextPos=nil
		local currentPos = pTable[i]
		if pTable[i-1] ~=nil then
			lastPos = pTable[i-1]
		end

		if pTable[i+1] ~=nil then
			nextPos = pTable[i+1]
		end

		local iPathType = MapViewRoadDir.type_normal
		iphy = iphy+phyTab[i];
		
		if self.mapView.role.physical<iphy then
			--判断体力是否足够
			--iPathType = MapViewRoadDir.type_physical
		elseif self.mapView.role.maxPerStep<i then
			--步骤是否太远
			iPathType = MapViewRoadDir.type_far
		end

		local _road = MapViewRoadDir:create(iPathType,currentPos,nextPos,lastPos,iPhysical)
		local _pos = self.objDateLayer:getPositionAt(currentPos)
		_road:setPosition(_pos)
		_road:setLocalZOrder(MapViewObjectLayer.ZORDER_ITEM)

		--根据建筑决定最后一个指示点大小
		if nextPos == nil then
			local _obj = self:getObject(currentPos)[1];
			if _obj ~=nil then 
				local _area = _obj.pConfig.Area;
				if _area ~= nil then 
					local _targetPos = self.objDateLayer:getPositionAt(_obj.indexPos)
					_targetPos.x = _targetPos.x+self.titleSize.height;
					_targetPos.y = _targetPos.y+self.titleSize.height;
					_road:setPosition(_targetPos);
					_road:setImgScale(_area[1]);
					local _targetPos = cc.p(0,_area[1]*0.5*self.titleSize.height*-1);
					_road:setImgPos(_targetPos);
				end
			end
		end

		self.firstLayerNode:addChild(_road)
		table.insert(self.roadDirTab,_road);	--加入到集合

		--遮罩层
		--local _newDir = _road:copyAttrAndCreateNewDir();
		--self.mapView.ObjectMaskLayer:addRoadDirction(_road);		
	end
end

--移除道路指引
function MapViewObjectLayer:removeRoadDirection(indexPos)
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
function MapViewObjectLayer:removeAllRoadDirection()
	-- body
	local iSize = table.getn(self.roadDirTab)
	for i=iSize,1,-1 do
		self.roadDirTab[i]:removeFromParent()
		table.remove(self.roadDirTab,i)
	end
end

--获取道路指引
function MapViewObjectLayer:getAllRoadDirection()
	local pTab ={};
	for i,var in pairs(self.roadDirTab) do
		if var.isMapViewRoadDir== true  then
			table.insert(pTab,var)
		end
	end
	return pTab
end


-----------------------------------------------------地形---------------------------------------------------------

--获取地形
function MapViewObjectLayer:getTerrain(indexPos)
	for i,var in pairs(self.functionElementTab) do
		if var.firstType == MapViewElementBase.FL_TYPE_TERRAIN  and 
			var:isAddPhysicalExertion(indexPos)  then 
			return var;
		end
	end
	return nil;
end



-----------------------------------------------------建筑---------------------------------------------------------
--激活建筑
function MapViewObjectLayer:makeBuildingActive(indexPos)
	-- body
	for i,var in pairs(self.functionElementTab) do
		local pTab = var:getEffectedArea()
		local isDisplay = false;
		for j,pvar in pairs(pTab) do
			--检测当前格子上的迷雾是否已经散开
			local ivar = self.mapView.layerSize;
			if ivar == MapView.MASK_EMPTY then
				isDisplay = true
				break;
			end
		end
		if isDisplay then
			var:makeActivity()
			--移除建筑区域的遮罩
			for j,pvar in pairs(pTab) do
				self.mapView:updateMaskLayer(pvar)
			end
		end
	end
end

--移除建筑
function MapViewObjectLayer:removeBuilding(indexPos)
	
end

-----------------------------------------------------挂机点---------------------------------------------------------

--移除挂机点
function MapViewObjectLayer:removeHookPoint(indexPos)
	-- body
end

--激活指定挂机点，关闭其他挂机点
function MapViewObjectLayer:activeHookPoint(uid)
	for i,var in pairs(self.functionElementTab) do
		if var.firstType == MapViewElementBase.FL_TYPE_HOOKPOINT  then
			if var.uid == uid then
				var:beginOnHook()
			else
				var:stopOnHook()
			end
		end
	end
end

--获取所有挂机点
function MapViewObjectLayer:getAllHookPoint()
	local hookPointTab = {};
	for i,var in pairs(self.functionElementTab) do
		if var.subType == MapViewElementBase.TYPE_HOOK_NORMAL  then
			table.insert(hookPointTab,var);
		end
	end
	return hookPointTab;
end


-----------------------------------------------------资源---------------------------------------------------------
--移除道具
function MapViewObjectLayer:removeProps(indexPos)
	-- body
	for i,var in pairs(self.functionElementTab) do
		--道具
		if var.isMapViewProps == true then
			if var:isEffectIndexPoint(indexPos) then
				var:removeFromParent()
			end
		end
	end
end

--获取道具
function MapViewObjectLayer:getProps(indexPos)
	local pTab = {};
	for i,var in pairs(self.functionElementTab) do 
		if var.subType ==MapViewElementBase.TYPE_RES_NORMAL then 
			if var:isEffectIndexPoint(indexPos) then 
				table.insert(pTab,var)
			end
		end
	end
	return pTab
end

-----------------------------------------------------传送门---------------------------------------------------------

--移除传送门
function MapViewObjectLayer:removeProtal(indexPos)
	
end



--------------------------------------------背景控制---------------------------------------------------------
function MapViewObjectLayer:addBgPlane(pLayer)
	if pLayer==nil then 
		return;
	end
	table.insert(self.backgroundTab,pLayer);

	local mapSize = self.mapView.layerSize
	for i=0,mapSize.width -1,1 do
		for j=0,mapSize.height - 1,1 do
			local sp = pLayer:getTileAt(cc.p(i,j))
			if sp~= nil then 
				sp:setVisible(false);
				sp:setAnchorPoint(cc.p(0.5,0.5));
				local _size = sp:getBoundingBox();
				sp:setPositionX(sp:getPositionX()+_size.width*0.5);
				sp:setPositionY(sp:getPositionY()+_size.height*0.5);
			end
		end
	end

end

--背景显示
function MapViewObjectLayer:setBGVisible(indexPos,bValue)
	local fTime =0.5;
	local fDir = 100;
	if bValue ==true then 
		--显示
		for i,var in pairs(self.backgroundTab) do
			local sp = var:getTileAt(indexPos);
			if sp~=nil and 
					sp:isVisible()==false then
				local fDtime = gf_Random()*0.1;
				--sp:setPositionY(sp:getPositionY()-fDir);
				sp:setScale(0.001);
				local pAction =cc.Spawn:create(--cc.MoveBy:create(fTime,cc.p(0,fDir)),
												cc.ScaleTo:create(fTime*1.0,1))
				local pAction01 =cc.Sequence:create(cc.DelayTime:create(fDtime),cc.Show:create(),pAction);
				sp:runAction(pAction01);

			end
		end

	else

	end
end

------------------------------------------------------------------------------------------------------------------

--检测某一个坐标点上有哪些事件元素(建筑，怪)
function MapViewObjectLayer:checkElementWithIndexPos(indexPos)
	local pRetTab = {}
	if indexPos==nil then 
		return pRetTab;
	end
	for i,var in pairs(self.functionElementTab) do
		--建筑
		if var.firstType == MapViewElementBase.FL_TYPE_BUILDING then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end
		--怪物
		elseif var.firstType == MapViewElementBase.FL_TYPE_ENEMY then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end

		--挂机点
		elseif var.firstType == MapViewElementBase.FL_TYPE_HOOKPOINT then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end

		--道具
		elseif var.firstType == MapViewElementBase.FL_TYPE_RES then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end
		--传送门
		elseif var.firstType == MapViewElementBase.FL_TYPE_PORTAL then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end	
		--其他类型
		elseif var.firstType == MapViewElementBase.FL_TYPE_OTHER then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end	
		--NPC
		elseif var.firstType == MapViewElementBase.FL_TYPE_NPC then
			if var:isEffectIndexPoint(indexPos) then
				table.insert(pRetTab,var)
			end	
		end

	end

	return pRetTab
end

--检测玩家是否点击到了某一个可移除障碍物
function MapViewObjectLayer:checkRemoveObstacleWithIndexPos(indexPos)
	for i,var in pairs(self.functionElementTab) do
		if var.subType == MapViewElementBase.TYPE_OBSTACLE_REMOVE and 
			var:isEffectIndexPoint(indexPos) then 
			return var;
		end
	end
	return nil;
end


--检测是否点击点到了功能物体
function MapViewObjectLayer:checkElementWithTouchPos(touch)
	if touch ==nil then 
		return nil;
	end
	
	for i,var in pairs(self.functionElementTab) do
		if var:isBeTouched(touch) then
			return var;
		end
	end

	return nil

end

--减少限时类的次数
function MapViewObjectLayer:reduceLimitCount(iValue)
	for i,var in pairs(self.functionElementTab) do
		if var.bLimit == true then
			var:reduceLimitCount(iValue)
		end
	end
end


--初始化联动层数据
function MapViewObjectLayer:initLinkLayer(pDate)
	if pDate == nil then 
		return;
	end
    self.linkDate={}

	for i=1,self.layerSize.height do
		for j=1,self.layerSize.width do
			local index = (i-1)*self.layerSize.width+j;
			self.linkDate[i..","..j]=pDate[index];
		end
	end
end

--获取联动层值
function MapViewObjectLayer:getLinkLayerDateWithIndex(pIndex)
	return self.linkDate[(pIndex.y+1)..","..(pIndex.x+1)]
end

--设置联动层值
function MapViewObjectLayer:setLinkLayerDate(pIndex,iValue)
	self.linkDate[(pIndex.y+1)..","..(pIndex.x+1)] = iValue;
end


--获取指定点带动的联动层
function MapViewObjectLayer:getLinkDate(indexPos)

	if self.linkDate == nil then 
		return nil;
	end
	local gid = self:getLinkLayerDateWithIndex(indexPos);
	if gid == 0 then 
		return nil;
	end

	local dateTab ={};

	function fun_getDate(point)

		for k,v in pairs(dateTab) do
			if v.x == point.x and 
				v.y == point.y then
				return;
			end
		end

		if point.x>=self.layerSize.width or
			point.y>=self.layerSize.height or
			point.x<0 or
			point.y<0 then
			return;
		end

		if self:getLinkLayerDateWithIndex(point) == 0 or
			self:getLinkLayerDateWithIndex(point)~= self:getLinkLayerDateWithIndex(indexPos) then
			return;
		end

		table.insert(dateTab,point)

		fun_getDate(cc.p(point.x+1,point.y));
		fun_getDate(cc.p(point.x-1,point.y));
		fun_getDate(cc.p(point.x,point.y+1));
		fun_getDate(cc.p(point.x,point.y-1));

	end

	fun_getDate(indexPos);

	return dateTab;
end