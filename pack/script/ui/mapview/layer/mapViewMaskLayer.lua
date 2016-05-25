--遮罩层

MapViewMaskLayer = class("MapViewMaskLayer",function()
	return cc.Node:create()
end)

local TB_MAP_VIEW_MASKLAYER={
	fogLayer = nil,
	maskDate = nil,
	mapView = nil,
	iWidth = 0,
	iHeight = 0,
	pMaskSpriteTab =nil;
}

function MapViewMaskLayer:create(mapView)
	self = MapViewMaskLayer:new()
	self.mapView = mapView;
	self:initAttr()
	return self
end

function MapViewMaskLayer:ctor()
	-- body
end

function MapViewMaskLayer:initAttr()
	-- body
	self:initDate();
	-- self.fogLayer=myCustom.ExploreForgNode:createWithAttr("res/shader/FogShader.vsh","res/shader/FogShader.fsh",
	-- 										"res/map/maskTitle.png",
	-- 										3000,2500);
 --    self:addChild(self.fogLayer)
 --    self.fogLayer:initPlayerViewRange(1.0);


    self.pMaskSpriteTab={};
    self:setVisible(false);
 
end

function MapViewMaskLayer:updatePos(pos)
	--self.fogLayer:addPlayerViewPointPos(pos.x,pos.y)
end


function MapViewMaskLayer:initBG(bgMap)
	-- self.iWidth = bgMap:getLayer("bg"):getLayerSize().width;
	-- self.iHeight = bgMap:getLayer("bg"):getLayerSize().height;

	-- for i=0,self.iWidth- 1,1 do
	-- 	for j=0,self.iHeight-1,1 do
	-- 		local tikeSp = bgMap:getLayer("bg"):getTileAt(cc.p(i,j))
	-- 		local sp = cc.Sprite:createWithSpriteFrame(tikeSp:getSpriteFrame())
	-- 		sp:setAnchorPoint(cc.p(0,0));
	-- 		sp:setPosition(cc.p(tikeSp:getPositionX(),tikeSp:getPositionY()))
	-- 		sp.indexPos = cc.p(i,j)
	-- 		sp.isMaks = true;
	-- 		self:addChild(sp);
	-- 		self.fogLayer:setNormalShader(sp);
	-- 		self.pMaskSpriteTab[i*self.iWidth+j] = sp;
	-- 	end
	-- end
end



function MapViewMaskLayer:initDate()
	self.maskDate={};
	local mapSize = self.mapView.layerSize
	for i=0,mapSize.width -1,1 do
	 	self.maskDate[i]={}
	 	for j=0,mapSize.height - 1,1 do
	  		self.maskDate[i][j]=MapView.MASK_ID
	 	end
	end

end

function MapViewMaskLayer:updateDate(posIndex,id,pMaskSpriteTab)
	self.maskDate[posIndex.x][posIndex.y] = id;
	--self:removeMaskSprite(posIndex)
end

function MapViewMaskLayer:setDate(posIndex,iValue)
	self.maskDate[posIndex.x][posIndex.y] = iValue;
end

--获取数据
function MapViewMaskLayer:getDate(posIndex)
	return self.maskDate[posIndex.x][posIndex.y]
end


function MapViewMaskLayer:removeMaskSprite(posIndex)
	-- body
	for i,var in pairs(self.pMaskSpriteTab) do
		if var.indexPos.x == posIndex.x and 
			var.indexPos.y == posIndex.y then 
			var:setVisible(false);
			break;
		end
	end
end

function MapViewMaskLayer:getMaxAndMinPos()

	local mapSize = self.mapView.layerSize

	local 	upPoint 		=	cc.p(0,0);
	local 	downPoint 		=	cc.p(mapSize.width-1,mapSize.height-1);
	local 	leftPoint 		=	cc.p(0,mapSize.height-1);
	local 	rightPoint 		=	cc.p(mapSize.width-1,0);

	local currentUpPoint 		=	nil
	local currentDownPoint 		=	nil
	local currentLeftPoint 		=	nil
	local currentRightPoint 	=	nil


	for i=0,mapSize.width -1,1 do
		for j=0,mapSize.height - 1,1 do
			if self.maskDate[i][j] == MapView.MASK_EMPTY  then 

				local pos = self.mapView.mapDateLayer:getPositionAt(cc.p(i,j))
			
				if currentUpPoint == nil or pos.y>currentUpPoint.y then 
						currentUpPoint = pos
				end

				if currentDownPoint==nil or pos.y<currentDownPoint.y then
						currentDownPoint = pos
				end

				if currentRightPoint==nil or pos.x>currentRightPoint.x then 
						currentRightPoint = pos;
				end

				if currentLeftPoint==nil or pos.x < currentLeftPoint.x then 
						currentLeftPoint = pos;
				end

			end
		end
    end

    local bRet ={};
    bRet[1]=currentUpPoint
    bRet[2]=currentDownPoint
    bRet[3]=currentLeftPoint
    bRet[4]=currentRightPoint

    return bRet;
end


--获取所有已打开区域
function MapViewMaskLayer:getAllView()
	local bRet={}
	local mapSize = self.mapView.layerSize
	for i=0,mapSize.width -1,1 do
    	for j=0,mapSize.height - 1,1 do
	     	if self.maskDate[i][j] == MapView.MASK_EMPTY  then
				table.insert(bRet,cc.p(i,j))
	     	end
     	end
 	end

 	return bRet;
end

