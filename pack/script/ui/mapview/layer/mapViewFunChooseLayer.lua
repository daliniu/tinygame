--功能选择层
require("script/ui/mapview/dialogBox/mapViewDialogDetailInfo");
require("script/ui/mapview/dialogBox/mapViewElementInfoLayer");
require("script/ui/mapview/dialogBox/mapViewNPCDialog");

local TB_MAP_VIEW_FUN_CHOOSE_LAYER = {
	mapView 	= nil,

	bDisplay 	= nil,
	dialogBoxNode 	=	nil,
	myupdate 		= 	nil,				--定时器
	pLogic 			=   nil,
}

MapViewFunChooseLayer = class("MapViewFunChooseLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end,TB_MAP_VIEW_FUN_CHOOSE_LAYER)



MapViewFunChooseLayer.FUN_TYPE_INFO					=	1;  --详情
MapViewFunChooseLayer.FUN_TYPE_GET_REWARD			=	2;	--获取奖励
MapViewFunChooseLayer.FUN_TYPE_CHOOSE_REWARD		=	3;	--选择奖励
MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE	=	4;	--迁移永久挂机
MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_ENEMY_FIGHT	=	5;	--挑战挂机怪永久
MapViewFunChooseLayer.FUN_TYPE_LIMIT_HOOK_MOVE 		= 	6;	--迁移限时挂机
MapViewFunChooseLayer.FUN_TYPE_LIMIT_ENEMY_FIGHT    =	7;	--挑战限时挂机怪
MapViewFunChooseLayer.FUN_TYPE_ENEMY_FIGHT 			=	8;	--挑战怪
MapViewFunChooseLayer.FUN_TYPE_CHOOSE_ENEMY_FIGHT	=	9;	--选择性挑战怪
MapViewFunChooseLayer.FUN_TYPE_CONSECUTIVE_FIGHT	=	10;	--连续战斗
MapViewFunChooseLayer.FUN_TYPE_UNKNOWN_BUILDING		=	11;	--进入未知建筑
MapViewFunChooseLayer.FUN_TYPE_FUNCTION_BUILDING	=	12;	--进入功能建筑
MapViewFunChooseLayer.FUN_TYPE_SUPPLY_BUILDING		=	13;	--进入补给站
MapViewFunChooseLayer.FUN_TYPE_OPEN_WATCH_VIEW		=	14;	--打开视野
MapViewFunChooseLayer.FUN_TYPE_DELIVER				=	15;	--传送
MapViewFunChooseLayer.FUN_TYPE_GETBUFF				= 	16;	--获取buff
MapViewFunChooseLayer.FUN_TYPE_GET_REWARD_WIN		=	17;	--获取奖励(弹窗)
MapViewFunChooseLayer.FUN_TYPE_NPC 					=	18;	--NPC窗口
MapViewFunChooseLayer.FUN_TYPE_WORLDMAP 			=	19;	--NPC窗口
MapViewFunChooseLayer.FUN_TYPE_OPEN_NEW_DIALOG 		=	1001;	--打开新的对话框


MapViewFunChooseLayer.moveDir 	= 	400;
MapViewFunChooseLayer.moveTime	= 	0.15;

local l_tbUIUpdateType = def_GetUIUpdateTypeData();


function MapViewFunChooseLayer:create(mapView)
	self = MapViewFunChooseLayer.new()
	self.mapView = mapView;
	self:initAttr()

	return self
end

function MapViewFunChooseLayer:OnExit()
	if self.myupdate ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.myupdate)
		self.myupdate=nil
	end
end

function MapViewFunChooseLayer:ctor()
	self.pLogic = MapViewLogic:getInstance();



    self.dialogBoxNode = cc.Node:create()
    self:addChild(self.dialogBoxNode)

    self:addPhy();	--增加体力

end

function MapViewFunChooseLayer:initAttr()
	self:initPos() 
end

function MapViewFunChooseLayer:initPos()

end

--移除功能选择按钮
function MapViewFunChooseLayer:removeAllFunction()
	self.dialogBoxNode:removeAllChildren()
end

function MapViewFunChooseLayer:addNewDialogBoxNode(pNode)
	self.dialogBoxNode:removeAllChildren()
	if pNode~=nil then 
		self.dialogBoxNode:addChild(pNode);
	end
end

function MapViewFunChooseLayer:addNewDialogBoxNodeWithNotClean(pNode)
	self.dialogBoxNode:addChild(pNode);
end

--添加信息功能选择按钮
function MapViewFunChooseLayer:addInfoFunction(objTab)
	
	--不管点到哪，先移除各个物体的功能面板
	self.dialogBoxNode:removeAllChildren()
	self.mapView.ObjectMaskLayer:removeAllFunctionInfoPanel();

	local obj = objTab[1]
	if obj ==nil then 
		return;
	end

	if obj.firstType == MapViewElementBase.FL_TYPE_TERRAIN then           --地形不做按钮
		return;
	end

	local moveTime = self.mapView:moveCamWithObjToScreenCenter(obj)
	local pLayer = obj:getInfoFunction(self);
	if pLayer ~=nil then
		--透明动画
		pLayer:addFadeAnimation(moveTime);
		--位置
		local orgPos = self.mapView.mapDateLayer:getPositionAt(obj.indexPos)
		orgPos.y = orgPos.y;
		orgPos.x = orgPos.x+50;
		pLayer:setPosition(orgPos)
		
		---初始缩放//
		--pLayer.targeScale = 0.54;
		--pLayer:setScale(0.54);
		--pLayer:runAction(cc.ScaleTo:create(0.1,pLayer.targeScale));
		
		self.mapView.ObjectMaskLayer:addFunctionInfoPanel(pLayer);
	end

end

--添加进入功能按钮
function MapViewFunChooseLayer:addEnterFunction(element)
	--不管点到哪，先移除各个物体的功能面板
	self.dialogBoxNode:removeAllChildren()

	if element.firstType == MapViewElementBase.FL_TYPE_TERRAIN then           --地形不做按钮
		return;
	end

	local pLayer = element:getEnterFunction(self);
	if pLayer~= nil then 
		local targetPoint = element.indexPos
		self:addNewDialogBoxNode(pLayer)
		if targetPoint~=nil then
			--移动屏幕
			self.mapView:moveCamWithObjToScreenCenter(element)
		end
	end
end



function MapViewFunChooseLayer:moveMapView(iDir)
	-- if iDir>0 then 
	-- 	iDir = 1
	-- else
	-- 	iDir = -1
	-- end
	-- self.mapView.mapParent:runAction(cc.MoveBy:create(MapViewFunChooseLayer.moveTime,
	-- 														cc.p(0,MapViewFunChooseLayer.moveDir*iDir)))
end

--/===================================================================================================================


--根据类型获取相应的函数名
-- function MapViewFunChooseLayer:getFunctionNameWithType(iType)
-- 	local functionName = nil;
-- 	if iType == MapViewFunChooseLayer.FUN_TYPE_INFO						then
-- 		functionName = self.addExplain
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_GET_REWARD			then
-- 		functionName = self.getReward
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CHOOSE_REWARD		then
-- 		functionName = self.chooseReward
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE	then
-- 		functionName = self.unlimitHookMove
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_ENEMY_FIGHT	then
-- 		functionName = self.unlimitEnemyFight
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_LIMIT_HOOK_MOVE 		then
-- 		functionName = self.limitHookMove
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_LIMIT_ENEMY_FIGHT    then
-- 		functionName = self.limitEnemyFight
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_ENEMY_FIGHT 			then
-- 		functionName = self.enemyFight
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CHOOSE_ENEMY_FIGHT	then
-- 		functionName = self.chooseEnemyFight
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CONSECUTIVE_FIGHT	then
-- 		functionName = self.consecutiveFight
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNKNOWN_BUILDING		then
-- 		functionName = self.unknowBuilding
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_FUNCTION_BUILDING	then
-- 		functionName = self.functionBuilding
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_SUPPLY_BUILDING		then
-- 		functionName = self.supply
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_OPEN_WATCH_VIEW		then
-- 		functionName = self.watchView
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_DELIVER				then
-- 		functionName = self.deliver
-- 	elseif iType ==MapViewFunChooseLayer.FUN_TYPE_GETBUFF				then 
-- 		functionName = self.getBuffer
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_GET_REWARD_WIN		then
-- 		functionName = self.getRewardWin
-- 	elseif iType == MapViewFunChooseLayer.FUN_TYPE_OPEN_NEW_DIALOG		then

-- 	end
-- 	return functionName
-- end


-- --说明
-- function MapViewFunChooseLayer:addExplain(pElement)
-- 	self:addInfoFunction({pElement})
-- end

-- --获取奖励
-- function MapViewFunChooseLayer:getReward(pElement)
-- 	self:fun_getReward(pElement)
-- end

-- --选择奖励
-- function MapViewFunChooseLayer:chooseReward(pElement)
-- 	local pDialog  = MapViewDialogChooseRew:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end

-- --迁移永久挂机
-- function MapViewFunChooseLayer:unlimitHookMove(pElement)
-- 	local pDialog = MapViewDialogUnlimitHookMove:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end


-- --挑战挂机怪永久
-- function MapViewFunChooseLayer:unlimitEnemyFight(pElement)
-- 	local pDialog = MapViewDialogUnlimitEnemyFight:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end


-- --迁移限时挂机
-- function MapViewFunChooseLayer:limitHookMove(pElement)
-- 	local pDialog = MapViewDialogLimitHookMove:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end


-- --挑战限时挂机怪
-- function MapViewFunChooseLayer:limitEnemyFight(pElement)
-- 	local pDialog = MapViewDialogLimitEnemyFight:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end

-- --挑战怪
-- function MapViewFunChooseLayer:enemyFight(pElement)
-- 	local pDialog = MapViewDialogEnemyFight:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end

-- --选择性挑战怪
-- function MapViewFunChooseLayer:chooseEnemyFight(pElement)
-- 	local pDialog = MapViewDialogChooseEnemyFight:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end

-- --连续战斗
-- function MapViewFunChooseLayer:consecutiveFight(pElement)
-- 	--local pDialog = MapViewDialogConsecutiveFight:create(pElement,self)
-- 	--self:addNewDialogBoxNode(pDialog)
-- end

-- --未知建筑
-- function MapViewFunChooseLayer:unknowBuilding(pElement)
-- 	local pDialog = MapViewDialogUnknowBuilding:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end

-- --功能建筑
-- function MapViewFunChooseLayer:functionBuilding(pElement)
-- 	--判定建筑是否已经被开启,如果没开启，发请求，如果开启了读取本地数据
-- 	if pElement.resList ==nil then 
-- 		MapViewLogic:getInstance():reqShopInfo(self.pLogic.currentMapID,
-- 													pElement.uid,
-- 													pElement:getNextStateID(),
-- 													nil);
-- 	else
--         pElement:updateItem(pElement.resList);
--         local pDialog = MapViewDialogFunctionBuilding:create(pElement,self)
--         self:addNewDialogBoxNode(pDialog)
--         pElement.pDalogiBox = pDialog;
-- 	end

-- end

-- --进入补给站
-- function MapViewFunChooseLayer:supply(pElement)
-- 	TipsViewLogic:getInstance():addMessageTips(30000);
-- 	-- local pDialog = MapViewDialogSupply:create(pElement,self)
-- 	-- self:addNewDialogBoxNode(pDialog)
-- end

-- --打开视野
-- function MapViewFunChooseLayer:watchView(pElement)
-- 	self:fun_watchView(pElement);
-- end

-- --传送
-- function MapViewFunChooseLayer:deliver(pElement)
-- 	-- body
-- 	self:fun_deliver(pElement)
-- end

-- --获取buff
-- function MapViewFunChooseLayer:getBuffer(pElement)
-- 	self:fun_getBuffer(pElement)
-- end

-- --获取奖励（弹窗）
-- function MapViewFunChooseLayer:getRewardWin(pElement)
-- 	local pDialog = MapViewDialogGetRewardWin:create(pElement,self)
-- 	self:addNewDialogBoxNode(pDialog)
-- end



-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function MapViewFunChooseLayer:getFunctionWithType(iType)
	local functionName = nil;
	if iType == MapViewFunChooseLayer.FUN_TYPE_INFO						then
		functionName = self.fun_addExplain
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_GET_REWARD			then
		functionName = self.fun_getReward
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CHOOSE_REWARD		then
		functionName = self.fun_chooseReward
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_HOOK_MOVE	then
		functionName = self.fun_unlimitHookMove
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNLIMIT_ENEMY_FIGHT	then
		functionName = self.fun_unlimitEnemyFight
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_LIMIT_HOOK_MOVE 		then
		functionName = self.fun_limitHookMove
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_LIMIT_ENEMY_FIGHT    then
		functionName = self.fun_limitEnemyFight
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_ENEMY_FIGHT 			then
		functionName = self.fun_enemyFight
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CHOOSE_ENEMY_FIGHT	then
		functionName = self.fun_chooseEnemyFight
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_CONSECUTIVE_FIGHT	then
		functionName = self.fun_consecutiveFight
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_UNKNOWN_BUILDING		then
		functionName = self.fun_unknowBuilding
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_FUNCTION_BUILDING	then
		functionName = self.fun_functionBuilding
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_SUPPLY_BUILDING		then
		functionName = self.fun_supply
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_OPEN_WATCH_VIEW		then
		functionName = self.fun_watchView
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_DELIVER				then
		functionName = self.fun_deliver
	elseif iType ==MapViewFunChooseLayer.FUN_TYPE_GETBUFF				then 
		functionName = self.fun_getBuffer
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_GET_REWARD_WIN		then
		functionName = self.fun_getRewardWin
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_OPEN_NEW_DIALOG  	then
		functionName = self.fun_openNewDialog
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_NPC 					then
		functionName = self.fun_openNPCDialog
	elseif iType == MapViewFunChooseLayer.FUN_TYPE_WORLDMAP				then
		functionName = self.fun_openWorldMap;
	end
	return functionName
end

--获取奖励
function MapViewFunChooseLayer:fun_getReward(pElement)
	if pElement.subType == MapViewElementBase.TYPE_RES_NORMAL then 			--普通资源
			MapViewLogic:getInstance():reqGetChest(self.pLogic.currentNodeID,
										pElement.uid,
										pElement:getNextStateID(),
										nil);

	end
end

--选择奖励
function MapViewFunChooseLayer:fun_chooseReward(pElement,chooseID)
	local args={};
	args.choo = chooseID;
	MapViewLogic:getInstance():reqChooseReward(self.pLogic.currentMapID,
										pElement.uid,
										pElement:getNextStateID(),
										args);

end

--迁移永久挂机
function MapViewFunChooseLayer:fun_unlimitHookMove(pElement)

	MapViewLogic:getInstance():reqUnlimitHookMove(self.pLogic.currentMapID,
										pElement.uid,
										1,
										nil);

	-- pElement:unlimitHookMove();
	-- self.mapView.objectLayer:activeHookPoint(pElement.uid)
end


--挑战挂机怪永久
function MapViewFunChooseLayer:fun_unlimitEnemyFight(pElement)

	MapViewLogic:getInstance():reqUnlimitEnemyFight(self.pLogic.currentMapID,
										pElement.uid,
										2,
										nil);
end


--迁移限时挂机
function MapViewFunChooseLayer:fun_limitHookMove(pElement)
	MapViewLogic:getInstance():reqLimitHookMove(self.pLogic.currentMapID,
										pElement.uid,
										1,
										nil);

	--self.mapView.objectLayer:activeHookPoint(pElement.uid)
end


--挑战限时挂机怪
function MapViewFunChooseLayer:fun_limitEnemyFight(pElement)
	MapViewLogic:getInstance():reqLimitEnemyFight(self.pLogic.currentMapID,
										pElement.uid,
										2,
										nil);
end

--挑战怪
function MapViewFunChooseLayer:fun_enemyFight(pElement)

	if pElement.subType ==MapViewElementBase.TYPE_ENEMY_NORMAL then 				--普通怪
		MapViewLogic:getInstance():reqFightMonster(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);

	elseif pElement.subType ==MapViewElementBase.TYPE_ENEMY_UNKNOWN then
		--未知建筑怪
		MapViewLogic:getInstance():reqUnkownFight(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);
		
	elseif pElement.subType == MapViewElementBase.TYPE_ENEMY_EXIT then 
		--出口怪
		MapViewLogic:getInstance():reqExitFight(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);	
	end

end

--选择性挑战怪
function MapViewFunChooseLayer:fun_chooseEnemyFight(pElement)

end

--连续战斗
function MapViewFunChooseLayer:fun_consecutiveFight(pElement)
	local args={};
	args.floor = pElement.floorIndex;
	MapViewLogic:getInstance():reqConsecutiveFight(self.pLogic.currentMapID,
												pElement.uid,
												pElement:getNextStateID(),
												args);	
end

--未知建筑
function MapViewFunChooseLayer:fun_unknowBuilding(pElement)
	MapViewLogic:getInstance():reqEnterUnkown(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);
end

--功能建筑
function MapViewFunChooseLayer:fun_functionBuilding(pElement)
	--判定建筑是否已经被开启,如果没开启，发请求，如果开启了读取本地数据
	if pElement.resList ==nil then 
		MapViewLogic:getInstance():reqShopInfo(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);
	else
		local itemID = pElement.itemID  --所要购买的物品ID
		local iNum =pElement.iNum
		
		MapViewLogic:getInstance():reqBuyItem(self.pLogic.currentMapID,
														pElement.uid,
														pElement.goodsid,
														nil);
	end


end

--进入补给站
function MapViewFunChooseLayer:fun_supply(pElement)
	local args={};
	args.point = pElement.pValue
	MapViewLogic:getInstance():reqSupply(self.pLogic.currentMapID,
														pElement.uid,
														pElement:getNextStateID(),
														args)
end

--打开视野
function MapViewFunChooseLayer:fun_watchView(pElement)

	MapViewLogic:getInstance():reqWatchTower(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);

end

--传送
function MapViewFunChooseLayer:fun_deliver(pElement)
	MapViewLogic:getInstance():reqExit(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);	
end

--获取buff
function MapViewFunChooseLayer:fun_getBuffer(pElement)
	MapViewLogic:getInstance():reqGetBuffer(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil);
	
end

--获取奖励（弹窗）
function MapViewFunChooseLayer:fun_getRewardWin(pElement)
	MapViewLogic:getInstance():reqUnkownReward(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil
													);
end


--使用工具
function MapViewFunChooseLayer:fun_useTool(pElement)
	MapViewLogic:getInstance():reqUseTool(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil
													);

end


--打开新的对话框
function MapViewFunChooseLayer:fun_openNewDialog(pElement)
	
end


--打开NPC对话框
function MapViewFunChooseLayer:fun_openNPCDialog(pElement)
	MapViewLogic:getInstance():reqNPC(self.pLogic.currentMapID,
													pElement.uid,
													pElement:getNextStateID(),
													nil
													);
end


--打开世界地图
function MapViewFunChooseLayer:fun_openWorldMap(pElement)


end


-------------------------临时增加体力的方式
function MapViewFunChooseLayer:addPhy()

    -- local scheduler
   
    -- local function update(dt)
    -- 	--暂时写在这里
    -- 	if me:GetAP()<1000 then
	   --  	me:AddAP(5);
	   --  	self.mapView.role.physical = me:GetAP();
	   --  	--GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
    -- 	end
    -- end
 
    -- scheduler = cc.Director:getInstance():getScheduler()
    -- self.myupdate = scheduler:scheduleScriptFunc(update, 10, false)
end