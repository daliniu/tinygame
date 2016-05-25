--道具
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/core/configmanager/configmanager");

local rewardConfigFile  = 	mconfig.loadConfig("script/cfg/pick/drop")
local itemConfigFile 	= 	mconfig.loadConfig("script/cfg/pick/item")
local stringConfigFile  =	require("script/cfg/string")
local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local chestchoofile = mconfig.loadConfig("script/cfg/map/building/chestchoo")
local chestfile = mconfig.loadConfig("script/cfg/map/building/chest")


MapViewProps = class("MapViewProps",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_PROPS)


local TB_MAP_VIEW_PROPS={
	functionManager = nil
}


function MapViewProps:create(id)
	self = MapViewProps.new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewProps:ctor()
	-- body
end

function MapViewProps:initAttr()

end


function MapViewProps:addImageAnimation()
	if self.spDisplay ==nil then 
		return;
	end

	local pAnimUp = cc.EaseSineInOut:create(cc.MoveBy:create(1.0,cc.p(0,10)));
	local pAnimDown =cc.EaseSineInOut:create(cc.MoveBy:create(1.0,cc.p(0,-10)));
	local pAction = cc.RepeatForever:create(cc.Sequence:create(pAnimUp,pAnimDown));

	self.spDisplay:runAction(pAction);
end

function MapViewProps:addShadowAnim()
	local pAnimUp = cc.EaseSineInOut:create(cc.ScaleTo:create(1.0,0.5));
	local pAnimDown =cc.EaseSineInOut:create(cc.ScaleTo:create(1.0,1.0));
	local pAction = cc.RepeatForever:create(cc.Sequence:create(pAnimUp,pAnimDown));
	self.shadow:runAction(pAction);
end

function MapViewProps:addShadow()
	local imgShadow = cc.Sprite:create("res/map/shadow.png");
	imgShadow:setPositionY(15);
	self:addChild(imgShadow);
	self.shadow = imgShadow;

end

function MapViewProps:setImageSize(pPoint)
	self.imageSize = pPoint;
	local orgSize = self.spDisplay:getContentSize();
	orgSize.width = pPoint.x/orgSize.width;
	orgSize.height = pPoint.y/orgSize.height;

	self.spDisplay:setScaleX(orgSize.width);
	self.spDisplay:setScaleY(orgSize.height);

end



--------------------------------------------------------------------------------------------
--普通资源、宝箱
MV_props_noraml = class("MV_props_noraml",function()
	return MapViewProps.new()
end)

function MV_props_noraml:create(id)
	self = MV_props_noraml.new()
	self.id = id
	self:initAttr()
	return self
end

function MV_props_noraml:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_RES 				--一级类型
	self.subType = MapViewElementBase.TYPE_RES_NORMAL 				--次级类型

	self.pConfig = chestfile[self.id]
	
	self:addShadow();

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    if self.pConfig.IfFloat ==1 then 
	    self:addImageAnimation();
	    self:addShadowAnim();
    end

    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end


function MV_props_noraml:getReward()
	local bRemove = false;
	if tonumber(self.pConfig["PickupLived"]) == 0 then
		bRemove =true;
	end

	--检测捡完是否消失
	if bRemove==true then
		self:setBeRemoved()
	else

	end
end


--获取文案信息
function MV_props_noraml:getDesInfo()
	if self.iState == MapViewElementBase.STATE_01 then 
		return self.pConfig.Desc1;
	elseif self.iState == MapViewElementBase.STATE_02 then
		return self.pConfig.Desc2;
	end
	return self.pConfig.Desc1;
end

--远处查看层
function MV_props_noraml:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	return pLayer;
end

function MV_props_noraml:getEnterFunction(functionChooseLayer)
	-- local smallgame = TurntableLayer:create();
	-- functionChooseLayer:addChild(smallgame);

	functionChooseLayer:fun_getReward(self)
	return nil
end

--------------------------------------------------------------------------------------------
--选择型
MV_props_choose = class("MV_props_choose",function()
	return MapViewProps.new()
end)

function MV_props_choose:create(id)
	self = MV_props_choose.new()
	self.id = id
	self:initVar();
	self:initAttr()
	return self
end

function MV_props_choose:initVar()
	self.chooseIndex 	= -1;	-- -1表示没选 ,1第一个，2第二个
	self.chooseResult	= -1;	-- -1表示没结果 ，0表示成功，1表示失败
end

function MV_props_choose:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_RES 				--一级类型
	self.subType = MapViewElementBase.TYPE_RES_CHOOSE 				--次级类型


	self.pConfig = chestchoofile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end

function MV_props_choose:chooseReward(index,result)

	self.chooseIndex = index;
	self.chooseResult = result;

	local pLayer = MVEIL_GetRewardLayer:create(self.functionManager,
												self,
												self:getRewardItemIDWithIndex(index),
												nil)

	if self.chooseIndex==1 then 
		if self.chooseResult == 0 then 
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,3))		--文案
		elseif self.chooseResult ==1 then 
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,4))		--文案
			pLayer:setItemVisiable(false);
		end
	elseif self.chooseIndex==2 then 
		if self.chooseResult == 0 then 
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,5))		--文案
		elseif self.chooseResult ==1 then 
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,6))		--文案
			pLayer:setItemVisiable(false);
		end
	end

	self.functionManager:addNewDialogBoxNode(pLayer)
end


function MV_props_choose:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)

	if self.iState == MapViewElementBase.STATE_01 then
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	elseif self.iState == MapViewElementBase.STATE_02 then
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,1))		--文案
	end
	
	return pLayer;
end

function MV_props_choose:getEnterFunction(functionChooseLayer)
	local pLayer = nil

	if self.iState == MapViewElementBase.STATE_01 then
		pLayer = MapViewDialogChooseRew:create(self,functionChooseLayer)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,2))		--文案
	elseif self.iState == MapViewElementBase.STATE_02 then
		pLayer = MVEIL_Normal:create(functionChooseLayer)
		pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,2))
		pLayer:setButtones(nil)
	end

	return pLayer;
end


function MV_props_choose:getRewardItemIDWithIndex(index)
	if index == 1 then 
		return rewardConfigFile[self.pConfig.Reward1].Showitem[1]
	else
		return rewardConfigFile[self.pConfig.Reward2].Showitem[1]
	end
end