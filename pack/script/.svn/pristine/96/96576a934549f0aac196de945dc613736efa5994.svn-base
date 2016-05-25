--挂机点
require("script/ui/mapview/mapViewElement/mapViewElementBase")
require("script/core/configmanager/configmanager");

local effectFile = mconfig.loadConfig("script/cfg/client/effect");
local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");
local desConfigFile = mconfig.loadConfig("script/cfg/map/elementdesc");
local afkRewardFile = mconfig.loadConfig("script/cfg/map/afkreward");
--local guajiFile = mconfig.loadConfig("script/cfg/exploration/guaji");

local l_tbUIUpdateType = def_GetUIUpdateTypeData();

MapViewOnHookPoint = class("MapViewOnHookPoint",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_ON_HOOK_POINT)

local TB_MAP_VIEW_ON_HOOK_POINT={
	myupdate,
	pAnim,
	bIsOnHooking = false,
}


function MapViewOnHookPoint:create(id)
	self = MapViewOnHookPoint.new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewOnHookPoint:ctor()
	-- body
end

function MapViewOnHookPoint:initAttr()

end

function MapViewOnHookPoint:effectTips(pString,pTime,gold,exp)
    local scheduler
    local timer = 0
     
    local function update(dt)
    	-- scheduler:unscheduleScriptEntry(self.myupdate)   -- 取消定时器
    	local phyNum= ccui.Text:create()
    	self:addChild(phyNum)
		phyNum:setFontSize(25)
    	phyNum:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
    								cc.RemoveSelf:create()))
    	phyNum:setString(pString)

    	--暂时写在这里
    	me:AddGold(gold)
    	me:AddExp(exp)
    	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
    end
 
    scheduler = cc.Director:getInstance():getScheduler()
    self.myupdate = scheduler:scheduleScriptFunc(update, pTime, false)

end

function MapViewOnHookPoint:OnExit()
	self:stopOnHook()
end

--开始挂机
function MapViewOnHookPoint:beginOnHook()

	local pAction = cc.Sequence:create(cc.ScaleTo:create(0.05,0.6),
										cc.EaseElasticOut:create(cc.ScaleTo:create(1.0,1)))
	self:runAction(pAction)

	self:addEffect();
	self.bIsOnHooking = true;
end

--结束挂机
function MapViewOnHookPoint:stopOnHook()
	-- if self.myupdate ~= nil then 
	-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.myupdate)
	-- 	self.myupdate=nil
	-- 	self:removeEffect();
	-- 	self.bIsOnHooking = false;
	-- end
	self.bIsOnHooking = false;
	self:removeEffect();
end

--获取特效资源
function MapViewOnHookPoint:getEffectID()
	return self.pConfig.Effect3;
end


--添加特效表现
function MapViewOnHookPoint:addEffect(id)
	if self.pAnim==nil then

		local effectID = self:getEffectID()[1]
		if effectID == nil then
			return;
		end



   		self.pAnim = af_GetEffectByID(effectID)
   		self:addChild(self.pAnim);
   		self.pAnim:setAnchorPoint(cc.p(0.5,0))
   		self.pAnim:setLocalZOrder(10);
	end

end


--移除特效表现
function MapViewOnHookPoint:removeEffect()
	if self.pAnim~=nil then
		self.pAnim:removeFromParent();
		self.pAnim =nil
	end
end

function MapViewOnHookPoint:initAttrWithPlayerHookPointDate()
	if self.uid == me.m_map.afkObj.uid and 
		MapViewLogic:getInstance().currentMapID == me.m_map.afkObj.mapid then 
		self.bIsOnHooking=true;
		self:addEffect();
	end
end

function MapViewOnHookPoint:updateFuncitonWithState()

	local mapID 	= 	me.m_map:GetMapID();
	local uid 		= 	me.m_map:GetFightPointUID();
	local id 		= 	me.m_map:GetFightPointID();

	if MapViewLogic:getInstance().currentMapID == mapID and 
		self.uid == uid  and
		self.id == id then 
		self:beginOnHook();
	else
		self:stopOnHook();
	end
	
end


--------------------------------------------------------------------------------------------

--普通挂机点
MV_onHook_noraml = class("MV_onHook_noraml",function()
	return MapViewOnHookPoint.new()
end)


function MV_onHook_noraml:create(id)
	self = MV_onHook_noraml.new()
	self.id = id
	print("=========================")
	print(self.id)
	self:initAttr()
	return self
end

function MV_onHook_noraml:initAttr()

	self.bIsOnHooking = false;

	-- body
	self.firstType = MapViewElementBase.FL_TYPE_HOOKPOINT 				--一级类型
	self.subType = MapViewElementBase.TYPE_HOOK_NORMAL 					--次级类型

	self.iState = 1; --状态1

	self.pConfig = guajiFile[self.id]


	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)
    self:initState();
    self:initTouchBox();

    self:addBaseEffect();
end

function MV_onHook_noraml:unlimitHookMove()

end

function MV_onHook_noraml:unlimitEnemyFight()

end


--获取文案信息
function MV_onHook_noraml:getDesInfo()
	if self.iState ==MapViewElementBase.STATE_01 then 
		if self.bIsOnHooking == false then 
			return self.pConfig.Desc1[1]
		else
			return self.pConfig.Desc1[2]
		end
	elseif self.iState ==MapViewElementBase.STATE_02 then 
		if self.bIsOnHooking == false then 
			return self.pConfig.Desc2[1]
		else
			return self.pConfig.Desc2[2]
		end
	end
	return nil
end



--远处查看层
function MV_onHook_noraml:getInfoFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],1))		--文案
			return pLayer;
		else
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE02)
			pLayer:addNewViewButton(stringConfigFile[13002])
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],1))		--文案
			pLayer:setDate(true,"挂机中",false,nil)
			pLayer:setNeedDisplay(false);
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		if self.bIsOnHooking == false then
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],1))		--文案
			pLayer:setDate(false,nil,true,"+"..afkRewardFile[self.id].bonuses.."%")
			return pLayer;
		else
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[2],1))		--文案
			pLayer:setDate(true,"挂机中",true,"+"..afkRewardFile[self.id].bonuses.."%")
			return pLayer;
		end

	elseif self.iState == MapViewElementBase.STATE_03 then

	elseif self.iState == MapViewElementBase.STATE_04 then

	end

	return nil
end

--进入触发层
function MV_onHook_noraml:getEnterFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01,nil)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE},{stringConfigFile[13001]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],2))			--文案
			return pLayer;
		else
			local pLayer = MVEIL_openNewLayer:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:addNewViewButton(stringConfigFile[13002])
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],2))			--文案
			pLayer:setDate(true,"挂机中",false,nil)
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		if self.bIsOnHooking == false then 
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE},{stringConfigFile[13001]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],2))				--文案
			pLayer:setDate(false,nil,true,"+"..afkRewardFile[self.id].bonuses.."%")
			return pLayer;
		else
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[2],2))				--文案
			pLayer:setDate(true,"挂机中",true,"+"..afkRewardFile[self.id].bonuses.."%")
			return pLayer;
		end

	elseif self.iState == MapViewElementBase.STATE_03 then


	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end

--子触发层
function MV_onHook_noraml:getEnterFunctionSub(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == true then 
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE02)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_ENEMY_FIGHT},{stringConfigFile[13002]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],3))				--文案
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 


	elseif self.iState == MapViewElementBase.STATE_03 then

	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end


---------------------------------------------------------------------------------------

--限时挂机点
MV_onHook_limitDelay = class("MV_onHook_limitDelay",function()
	return MapViewOnHookPoint.new()
end)

function MV_onHook_limitDelay:create(id)
	self = MV_onHook_limitDelay.new()
	self.id = id
	self:initAttr()
	return self
end

function MV_onHook_limitDelay:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_HOOKPOINT 				--一级类型
	self.subType = MapViewElementBase.TYPE_HOOK_LIMIT 					--次级类型

	self.bIsOnHooking = false;

	self.pConfig = guajiFile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
 	self:addBaseEffect();   
end

function MV_onHook_limitDelay:limitHookMove()

end

function MV_onHook_limitDelay:limitEnemyFight()

end

--获取文案信息
function MV_onHook_limitDelay:getDesInfo()
	if self.iState ==1 then 
		if self.bIsOnHooking == false then 
			return self.pConfig.Desc1[1]
		else 
			return self.pConfig.Desc1[2]
		end
	elseif self.iState ==2 then 
		return self.pConfig.Desc2[1];
	end
	return self.pConfig.Desc1[1];
end

--远处查看层
function MV_onHook_limitDelay:getInfoFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then 
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],1))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		else
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],1))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
		pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],1))				--文案
		return pLayer;

	elseif self.iState == MapViewElementBase.STATE_03 then

	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end

--进入触发层
function MV_onHook_limitDelay:getEnterFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01,nil)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE},{stringConfigFile[13001]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],2))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		else
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],2))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		local pLayer = MVEIL_Normal:create(functionChooseLayer)
		pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],1))				--文案
		pLayer:setDate(true,"05:00",false,nil)
		return pLayer;

	elseif self.iState == MapViewElementBase.STATE_03 then


	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end


-----------------------------------------------------------------------------

--限时挂机点(2)
MV_onHook_limitAtOnce = class("MV_onHook_limitAtOnce",function()
	return MapViewOnHookPoint.new()
end)

function MV_onHook_limitAtOnce:create(id)
	self = MV_onHook_limitAtOnce.new()
	self.id = id
	self:initAttr()
	return self
end

function MV_onHook_limitAtOnce:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_HOOKPOINT 				--一级类型
	self.subType = MapViewElementBase.TYPE_HOOK_AtONCE 					--次级类型

	self.iState=1
	self.bIsOnHooking = false;

	self.pConfig = guajiFile[self.id]


	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1});
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();	
    self:initTouchBox();
    self:addBaseEffect();
end

function MV_onHook_limitAtOnce:limitHookMove()

	if self.pConfig.BossLimit~= nil then 
		

	end
end


function MV_onHook_limitAtOnce:limitEnemyFight()


end

function MV_onHook_limitAtOnce:getInfoFunButtons()
	return nil
end

--获取文案信息
function MV_onHook_limitAtOnce:getDesInfo()
	if self.iState ==1 then 
		if self.bIsOnHooking == false then 
			return self.pConfig.Desc1[1]
		else 
			return self.pConfig.Desc1[2]
		end
	elseif self.iState ==2 then 
		return self.pConfig.Desc2[1];
	end
	return self.pConfig.Desc1[1];
end

--远处查看层
function MV_onHook_limitAtOnce:getInfoFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then 
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],1))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		else
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:addNewViewButton(stringConfigFile[13002])
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],1))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			pLayer:setNeedDisplay(false);
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		if self.bIsOnHooking == false then 
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],1))				--文案
			return pLayer;
		else
			local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setButtones(nil)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[2],1))				--文案
			return pLayer;
		end

	elseif self.iState == MapViewElementBase.STATE_03 then

	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end

--进入触发层
function MV_onHook_limitAtOnce:getEnterFunction(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == false then
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01,nil)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE},{stringConfigFile[13001]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[1],2))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		else
			local pLayer = MVEIL_openNewLayer:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:addNewViewButton(stringConfigFile[13002])
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],2))				--文案
			pLayer:setDate(true,"05:00",false,nil)
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 
		if self.bIsOnHooking == false then
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE},{stringConfigFile[13001]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[1],2))				--文案
			return pLayer;
		else
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE01)
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2[2],2))				--文案
			pLayer:setButtones(nil)
			return pLayer;
		end

	elseif self.iState == MapViewElementBase.STATE_03 then


	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end

--子触发层
function MV_onHook_limitAtOnce:getEnterFunctionSub(functionChooseLayer)
	if self.iState == MapViewElementBase.STATE_01 then
		if self.bIsOnHooking == true then 
			local pLayer = MVEIL_Normal:create(functionChooseLayer)
			pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE02,nil)
			pLayer:setButtones({MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_ENEMY_FIGHT},{stringConfigFile[13002]})
			pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1[2],3))				--文案
			return pLayer;
		end

	elseif self.iState ==MapViewElementBase.STATE_02 then 


	elseif self.iState == MapViewElementBase.STATE_03 then

	elseif self.iState == MapViewElementBase.STATE_04 then	

	end

	return nil
end