require("script/core/configmanager/configmanager");
require("script/ui/mapview/mapViewElement/mapViewElementBase")

local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");
local shopfile = mconfig.loadConfig("script/cfg/map/building/shop")
local supplyfile = mconfig.loadConfig("script/cfg/map/building/supply")
local buffstationfile = mconfig.loadConfig("script/cfg/map/building/buffstation")
--local transportfile = mconfig.loadConfig("script/cfg/map/building/transport")
--local intelligencefile = mconfig.loadConfig("script/cfg/map/building/intelligence")
local watchtowerfile = mconfig.loadConfig("script/cfg/map/building/watchtower")

MapViewBuilding = class("MapViewBuilding",function()
	return MapViewElementBase:create()
end,TB_MAP_VIEW_BUILDING)

local TB_MAP_VIEW_BUILDING={
	isActivity = false,
}


function MapViewBuilding:create(id)
	-- body
	self = MapViewBuilding:new()
	self.id = id
	self:initAttr()
	return self
end

function MapViewBuilding:ctor()
	
end

function MapViewBuilding:initAttr()

end

--激活
function MapViewBuilding:makeActivity()

	if self.isActivity ==true then
		return;
	end

	if self:isVisible()==true then 
		return;
	end

	self.isActivity = true
	-- body
	self.spDisplay:setVisible(true)
	self.spDisplay:setScale(0)

	local endPos = cc.p(self.spDisplay:getPositionX(),self.spDisplay:getPositionY())
	local fTime = 0.3
	self.spDisplay:setPositionY(endPos.y+100)

	local pAction = cc.Spawn:create(cc.ScaleTo:create(fTime*0.4,1),
									cc.EaseSineIn:create(cc.MoveTo:create(fTime,endPos)))
	self.spDisplay:runAction(pAction)
end

--获取返回区域
function MapViewBuilding:getEffectedArea()
	-- body
	local pTab = {}
	for i=0,self.pConfig["Area"][1]-1 do
		for j=0,self.pConfig["Area"][2]-1 do
			table.insert(pTab,cc.p(self.indexPos.x+i,self.indexPos.y+j))
		end
	end

	return pTab
end

--远处查看层
function MapViewBuilding:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	return pLayer;
end




---------------------------------------------------------------------------------------------------------------------
--补给站
MV_building_supply = class("MV_building_supply",function()
	return MapViewBuilding.new()
end)

local TB_MV_BUILDING_SUPPLY={
	pValue=nil,
}

function MV_building_supply:create(id)
	self = MV_building_supply:new()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_supply:initAttr()
	self.pValue = me:GetTeamHp();
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 		--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_SUPPLY 		--次级类型



	self.pConfig = supplyfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end

function MV_building_supply:supply()

end

function MV_building_supply:setSupplyValue(iValue)
	self.pValue = iValue
end

--根据状态更新功能
function MV_building_supply:updateFuncitonWithState()
	-- body
end

function MV_building_supply:getEnterFunction(functionChooseLayer)
	local pLayer = MapViewDialogSupply:create(self,functionChooseLayer);
	return pLayer;
end

function MV_building_supply:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	return pLayer;
end

-----------------------------------------------------------------------------------------------------------------------------
--buff点
MV_building_buff = class("MV_building_buff",function()
	return MapViewBuilding.new()
end)

function MV_building_buff:create(id)
	self = MV_building_buff:new()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_buff:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 		--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_BUFF 		--次级类型


	self.pConfig = buffstationfile[self.id]

	
	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)


    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end

--获取buff
function MV_building_buff:getBuffer()

end

--获取文案信息
function MV_building_buff:getDesInfo()
	if self.iState ==MapViewElementBase.STATE_01 then 
		return self.pConfig.Desc1;
	elseif self.iState == MapViewElementBase.STATE_02 then
		return self.pConfig.Desc2;
	end 
	return self.pConfig.Desc1;
end

--根据状态更新功能
function MV_building_buff:updateFuncitonWithState()
	-- body
end

function MV_building_buff:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)

	if self.iState ==MapViewElementBase.STATE_01 then 
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案	
	elseif self.iState == MapViewElementBase.STATE_02 then
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,1))		--文案
	end 
	
	
	return pLayer;
end

function MV_building_buff:getEnterFunction(functionChooseLayer)
	if self.iState ==MapViewElementBase.STATE_01 then 
		functionChooseLayer:fun_getBuffer(self)
	elseif self.iState == MapViewElementBase.STATE_02 then
		local pLayer = MVEIL_Normal:create(functionChooseLayer)
		pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
		pLayer:setButtones(nil)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,2))		--文案
		return pLayer;
	end
	
end

--------------------------------------------------------------------------------------------------------------------------------

--交通站
MV_building_transport = class("MV_building_transport",function()
	return MapViewBuilding.new()
end)


function MV_building_transport:create(id)
	self = MV_building_transport:new()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_transport:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 			--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_STATION 		--次级类型


	self.pConfig = transportfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)
end

function MV_building_transport:functionBuilding()
	
end


---------------------------------------------------------------------------------------------------------------------------

--情报站
MV_building_inte = class("MV_building_inte",function()
	return MapViewBuilding.new()
end)

function MV_building_inte:create(id)
	self = MV_building_inte:new()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_inte:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 			--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_INTE 			--次级类型


	self.pConfig = intelligencefile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)
end

function MV_building_inte:functionBuilding()
	
end

---------------------------------------------------------------------------------------------------------------------------

--商店 
MV_building_shop = class("MV_building_shop",function()
	return MapViewBuilding.new()
end)

function MV_building_shop:initVar()
	self.itemID = 0;		---所选道具ID
	self.iNum =0;			--所选道具数量
	self.goodsid =0;		--goodsid为购买物品的sellgroup配置表id
	self.resList=nil;
	self.pDalogiBox =nil	--对话框
end

function MV_building_shop:create(id)
	self = MV_building_shop:new()
	self:initVar()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_shop:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 			--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_SHOP 			--次级类型

	self.pConfig = shopfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end

function MV_building_shop:functionBuilding()
	--self.functionManager:fun_functionBuilding(self)
end

function MV_building_shop:updateItem(pDate)
	if self.resList==nil then 
		self.resList={}
	end
	for i,v in pairs(pDate) do
		if (i)~=0 then 
			self.resList[i]=v;
		end
	end
end


function MV_building_shop:removeRes(id)
	for i,var in pairs(self.resList) do
		if (i) == (id) then
			self.resList[i]=nil;
		end
	end
end

-- 对于商店，当 state 为 2 的时候代表随机出来了，这个时候 uid 的内容如下：
-- uid : {
--   [state] = 2,
--   [args] = {
--     [shopInfo] = {
--       [sellgroup里面的key] = 数量，
--       [sellgroup里面的key] = 数量，
--     },
--   },
-- }

function MV_building_shop:setArgs(args)
	local shopInfo = args.shopInfo;
	if shopInfo==nil then
		return;
	end
	self:updateItem(shopInfo)
end

function MV_building_shop:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	return pLayer;
end


function MV_building_shop:getEnterFunction(functionChooseLayer)
	if self.resList ==nil then
		self.functionManager:fun_functionBuilding(self)
		return;
	end

	local pLayer= MapViewDialogFunctionBuilding:create(self,functionChooseLayer);
	--pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,2))		--文案
	self.pDalogiBox = pLayer;
	return pLayer;
end

---------------------------------------------------------------------------------------------------------------------------
--瞭望塔
MV_building_watchTower = class("MV_building_watchTower",function()
	return MapViewBuilding.new()
end)

function MV_building_watchTower:create(id)
	self = MV_building_watchTower:new()
	self.id = id;
	self:initAttr()
	return self;
end

function MV_building_watchTower:initAttr()
	-- body
	self.firstType = MapViewElementBase.FL_TYPE_BUILDING 			--一级类型
	self.subType = MapViewElementBase.TYPE_BUILDING_WATCHTOWER 			--次级类型


	self.pConfig = watchtowerfile[self.id]

	self.indexPos=cc.p(0,0)
	self:setImgRes({self.pConfig.Pic1})
	self.spDisplay:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.spDisplay)

    self:initState();
    self:initTouchBox();
    self:addBaseEffect();
end

--打开视野
function MV_building_watchTower:watchView()

end

function MV_building_watchTower:getInfoFunction(functionChooseLayer)
	local pLayer = MapViewFunctionInfo:create(functionChooseLayer)
	pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
	pLayer:setButtones(nil)
	if self.iState ==MapViewElementBase.STATE_01 then 
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc1,1))		--文案
	else
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,2))		--文案
	end
	
	return pLayer;
end

function MV_building_watchTower:getEnterFunction(functionChooseLayer)
	if self.iState ==MapViewElementBase.STATE_01 then 
		functionChooseLayer:fun_watchView(self)
	else
		local pLayer = MVEIL_Normal:create(functionChooseLayer)
		pLayer:setInfo(self,MapViewElementBase.INFO_PANEL_TYPE03)
		pLayer:setButtones(nil)
		pLayer:setTextInfo(self:getInfoString(self.pConfig.Desc2,2))		--文案
		return pLayer;
	end

end
