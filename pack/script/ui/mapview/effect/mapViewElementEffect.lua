--元素特效

MapViewElementEffect = class("MapViewElementBase",function()
	return cc.Node:create()
end)

MapViewElementEffect.iType01 = 1;	--一直播放
MapViewElementEffect.iType02 = 2;
MapViewElementEffect.iType03 = 3;
MapViewElementEffect.iType04 = 4;
MapViewElementEffect.iType05 = 5;
MapViewElementEffect.iType06 = 6;


function MapViewElementEffect:create(pConfigTab)
	-- body
	if pConfigTab==nil then 
		return nil;
	end
	
	self = MapViewElementEffect:new()
	self.pConfigTab = pConfigTab;
	self:initAttr();
	return self
end

function MapViewElementEffect:initAttr()

	local effectID = self.pConfigTab[1]
	local pAnim = af_GetEffectByID((effectID))
	self:addChild(pAnim);

	local fScale = self.pConfigTab[2]
	local posX = self.pConfigTab[3]
	local posY = self.pConfigTab[4];

	pAnim:setScale(fScale*0.01);
	pAnim:setPositionX(posX);
	pAnim:setPositionY(posY);


end
