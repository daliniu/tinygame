require("script/class/class_base_ui/class_base_layer")
require "script/cocos2dx/Opengl"
require "script/cocos2dx/OpenglConstants"
require("script/lib/stringfunctions")
require("script/ui/mapview/layer/mapViewObjectLayer")
require("script/ui/mapview/layer/mapViewMaskLayer")
require("script/ui/mapview/layer/mapViewFunChooseLayer")
require("script/ui/mapview/layer/mapViewGUI")
require("script/ui/mapview/layer/mapViewBackgroundLayer")
require("script/ui/mapview/layer/mapViewForegroundLayer")
require("script/ui/mapview/layer/mapViewObjectMaskLayer")
require("script/ui/mapview/role/mapViewRole")
require("script/ui/mapview/effect/mapViewMoveLimitTips")
require("script/ui/mapview/dialogBox/mapViewDialogTips")
require("script/ui/mapview/layer/mapViewControlLayer")
require("script/ui/mapview/dialogBox/mapViewFunctionInfo")
require("script/core/configmanager/configmanager");

local ruleConfig = mconfig.loadConfig("script/cfg/client/map_rule")
local mapinfofile = mconfig.loadConfig("script/cfg/map/mapinfo")

local TB_MAP_VIEW={
    pLogic                  = nil,
    map                     = nil,
    mapDateLua              = nil,
    mapParent               = nil,
    positionLast01          = nil,              --多点触摸计算
    positionLast02          = nil,              --多点触摸计算
    positionCurrent01       = nil,              --多点触摸计算
    positionCurrent02       = nil,              --多点触摸计算
    moveDistance            = 0,
    mapDateLayer            = nil,          --底部地图数据
    mapDateTab              = nil,          --数据


    objectLayer             = nil,          --物体显示层
    objectLayerDown         = nil,          --物体显示层（下层）
    ObjectMaskLayer         = nil,          --物体遮罩层

    maskLayer               = nil,          --迷雾层

    functionChooseLayer     = nil,          --功能选择层
    obstacleDateLayer       = nil,          --障碍物数据层
    backgroundMap           = nil,          --背景层
    foregroundMap           = nil,          --前景层
    role                    = nil,          --角色
    pathTable               = nil,          --移动路径
    lastTouchPoint          = nil,          --玩家点击位置
    lastSelectObj           = nil,          --上一次玩家所选择的物体
    bIsReadyMove            = nil,          --是否准备移动(在准备状态下，点击同一目标点就移动角色)
    pathPhysicals           = nil,          --当前路径所需体力消耗
    pathSteps               = nil,           --当前路径的移动步数
    gui                     = nil,           --gui界面
    touchNum                = nil,           --是否是多点触摸
    
    transNodeUp       =nil,     --变换控制节点_上节点
    transNodeDown     =nil,     --变换控制节点_下节点
    transNodeLeft     =nil,     --变换控制节点_左节点
    transNodeRight    =nil,     --变换控制节点_右节点

    mapUpNode          =nil,    --地图tiled最上面的点上放置一个节点

    layerSize          =nil,        --地图尺寸
    tileSize           =nil,        --title大小

    currentState       =nil,        --当前状态

    loadingLayer        =nil,       --加载层

    beTouchBegin        = false;

    objectLayerZorder  = nil;         --物体层zorder
}

MapView = class("MapView",function()
    return KGC_UI_BASE_LAYER:create()
end,TB_MAP_VIEW)

MapView.physicalExertionPer = 10;        --每一步的默认体力消耗

MapView.MASK_ID                 = 3   --迷雾层，迷雾部分ID
MapView.MASK_EMPTY              = 0   --迷雾层，空
MapView.MAP_ABLE_MOVE_ID        = 1   --寻路层,可通过区域id
MapView.MAP_DISABLE_MOVE_ID     = 2   --寻路层，不可通过区域ID
MapView.OBJ_DISABLE_MOVE_ID     = 2   --物体层，不可通过区域ID
MapView.OBJ_EMPTY               = 0   --物体层，空

MapView.ST_NROMAL  =1;
MapView.ST_TOOL    =2;

MapView.ACTION_TAG_FOLlOW_ROLE= 100;

function MapView:create()
    local _layer= MapView.new()
    _layer:initAttr()
    return _layer
end

function MapView:ctor()
    self.pLogic=MapViewLogic:getInstance();
end

function MapView:playBackgroundMusic()
    AudioManager:getInstance():playBackground("res/audio/background/audio_bg_map_01");
end

function MapView:initAttr()
    self.moveDistance=0;
    self.touchNum =0;
    self.pathTable = {};
    self:initMap()
    self:initObjLayer()
    self:initTouchEvent()
    self.currentState = MapView.ST_NROMAL;

    self.backgroundMap =MapViewBackgroundLayer:create()
    self.backgroundMap:setLocalZOrder(-1);
    self:addChild(self.backgroundMap)

    self.foregroundMap = MapViewForegroundLayer:create();
    self:addChild(self.foregroundMap)

    --根据地图设置步耗
    local mapinfoConfig = mapinfofile[self.pLogic.currentMapID]
    MapView.physicalExertionPer = mapinfoConfig.AP;

    --初始化角色位置
    self:initRole();
    --根据角色的初始位置，设置地图的位置
    self:initMapPos();
    --根据角色，初始化地图信息
    self:initMapInfoWihtPlayer();

    for k,v in pairs(self.mapDateTab) do
        local stringTab = sf_split(k,",");
        local _point =cc.p(tonumber(stringTab[1]),tonumber(stringTab[2]))
        if v == MapView.MASK_EMPTY then
            self:updateMaskLayer(_point)
        end
    end

    self:updateMoveMapRange();

    --数据保存
    self.pLogic:saveDate(self.pLogic.currentMapID,self.mapDateTab);

    --音效
    self:playBackgroundMusic();

end


--初始化角色信息
function MapView:initRole()
    --角色物体
    --获取地图初始位置信息
    local _startPos = self.pLogic.startPos
    self.role = MapViewRole:create()
    self.role:setLocalZOrder(10)
    self.role:setPositionWithTitle(_startPos,
                                    self.mapDateLayer:getPositionAt(_startPos),
                                    self.tileSize)
    self.objectLayer:addPlayerRole(self.role)

    local pObjTb = self.objectLayer:getObject(_startPos)
    local pObj = nil
    for k,v in pairs(pObjTb) do
        pObj= pObjTb[1]
    end

    if pObj ~= nil then
        pObj:playerRoleGetIn(self.role)
    end

    --buffer信息
    local _buffer  = me:getMapBuffList()
    self.role:updateBuffer(_buffer)


end

--根据角色的初始位置，设置地图的位置
function MapView:initMapPos()
    local locPos = cc.p(self.role:getPositionX()-500,self.role:getPositionY()-500)
    self:moveMap(locPos.x*-1,locPos.y*-1)
    local _centerPos = self.role:getParent():convertToWorldSpaceAR(cc.p(self.role:getPosition()))
    local fDirX = _centerPos.x - self.mapParent:getPositionX();
    local fDirY = _centerPos.y - self.mapParent:getPositionY();
    self.mapParent:setPosition(_centerPos)
    self.map:setPositionX(self.map:getPositionX()-fDirX)
    self.map:setPositionY(self.map:getPositionY()-fDirY)
    self.maskLayer:setPositionX(self.maskLayer:getPositionX()-fDirX)
    self.maskLayer:setPositionY(self.maskLayer:getPositionY()-fDirY)
    --self.mapParent:setScale(1.85);

end

function MapView:initMapInfoWihtPlayer()
    self.maskLayer:updatePos(cc.p(self.role:getPositionX(),self.role:getPositionY()))

    --遮罩
    self:updateMaskLayerWithPlayer()
    --gui层
    self.gui = MapViewGUI:create(self)
    self:addChild(self.gui)
end

function MapView:initMap()
    self.mapParent =cc.Node:create()
    self:addChild(self.mapParent)

    local bRes = mapinfofile[self.pLogic.currentMapID].ResPath;

    --数据信息titl
    print("ccc")
    print(bRes)
    self.map = cc.TMXTiledMap:create(bRes..".tmx");
    self.mapDateLua = MapViewDateInfoLua:create(bRes..".lua");
    self.mapParent:addChild(self.map)

    local pland01 = self.map:getLayer("landedge")
    local pland02 = self.map:getLayer("land")
    local pGrid   = self.map:getLayer("grid");

    pland01:setPositionY(pland01:getPositionY()-20)
    pland02:setPositionY(pland02:getPositionY()-20)

    --记录地图尺寸
    self.layerSize = pland01:getLayerSize();
    self.tileSize= pland01:getMapTileSize();

    self.objectLayerZorder = pland01:getLocalZOrder()+1;

    --map层
    self.mapDateLayer = MapViewDateLayer:create(self.layerSize,pland02); 

    --背景层

    --数据
    local _oldDate =  self.pLogic:getDate(self.pLogic.currentMapID);
    if _oldDate ~=nil then 
        self.mapDateTab=_oldDate;
    else
        self.mapDateTab={};
        for i=0,self.layerSize.width-1 do
            for j=0,self.layerSize.height-1 do
                self.mapDateTab[i..","..j]=MapView.MASK_ID
            end
        end
    end


    --障碍数据层
    self.obstacleDateLayer = MapViewObstacleLayer:create(self.mapDateLua:getObstacleDate(),self.layerSize);

    --物体显示层
    self.objectLayer = MapViewObjectLayer:create(pland01,self)
    self.objectLayer:setLocalZOrder(self.objectLayerZorder)
    self.map:addChild(self.objectLayer)
    self.objectLayer:initLinkLayer(self.mapDateLua:getLinkDate())
    self.objectLayer:addBgPlane(pland01);
    self.objectLayer:addBgPlane(pland02);
    if pGrid~=nil then
        --self.objectLayer:addBgPlane(pGrid);
    end


    --物体遮罩显示层
    self.ObjectMaskLayer = MapViewObjectMaskLayer:create(self);
    self.ObjectMaskLayer:setLocalZOrder(self.objectLayerZorder+1)
    self.map:addChild(self.ObjectMaskLayer);


    --物体显示层（底层）
    self.objectLayerDown = cc.Node:create();
    self.objectLayerDown:setLocalZOrder(-1);
    self.map:addChild(self.objectLayerDown);

    --迷雾层
    self.maskLayer = MapViewMaskLayer:create(self)
    self.maskLayer:setLocalZOrder(10)
    self.mapParent:addChild(self.maskLayer)

    --功能选择层
    self.functionChooseLayer = MapViewFunChooseLayer:create(self)
    self:addChild(self.functionChooseLayer)
    self.functionChooseLayer:setLocalZOrder(1);


    self.mapUpNode = cc.Node:create();
    self.map:addChild(self.mapUpNode)
    local _mapPosUp = self.layerSize.width*self.tileSize.height;
    self.mapUpNode:setPosition(cc.p(_mapPosUp,_mapPosUp))

    --变换控制节点(用来检测地图缩放平移的位置)
    self.transNodeUp = cc.Node:create();
    self.map:addChild(self.transNodeUp)
    local _posUp =self.layerSize.width*self.tileSize.height;
    self.transNodeUp:setPosition(cc.p(_posUp,_posUp))


    self.transNodeDown = cc.Node:create();
    self.map:addChild(self.transNodeDown);
    local _posDown = self.layerSize.width*self.tileSize.height;
    self.transNodeDown:setPosition(cc.p(_posDown,0))


    self.transNodeRight = cc.Node:create();
    self.map:addChild(self.transNodeRight);
    local _posRight_x=  self.layerSize.width*self.tileSize.width;
    local _posRight_y = self.layerSize.height*self.tileSize.height*0.5;
    self.transNodeRight:setPosition(cc.p(_posRight_x,_posRight_y))


    self.transNodeLeft = cc.Node:create();
    self.map:addChild(self.transNodeLeft);
    local _posLeft_y = self.layerSize.height*self.tileSize.height*0.5;
    self.transNodeLeft:setPosition(cc.p(0,_posLeft_y))


end


function MapView:initObjLayer()
    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("up"):getObjects(),2)
    
    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("obstacle"):getObjects(),1)
    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("building"):getObjects(),1)

    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("nsurfaced"):getObjects(),-1)
    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("nsurface"):getObjects(),-1)
    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("surface"):getObjects(),-1)

    self.objectLayer:addObjectWithTB(self.map:getObjectGroup("down"):getObjects(),-2)
end


function MapView:initTouchEvent()

    --单点点击
    local function fun_toucBegan(touch, event)
        self.positionCurrent01 = touch:getLocation()
        self.positionLast01 = touch:getLocation()
    end
    
    --单点移动
    local function fun_touchMoved(touch, event)
        self.positionLast01 = self.positionCurrent01
        self.positionCurrent01 = touch:getLocation()
        
        self:moveMap(self.positionCurrent01.x- self.positionLast01.x,
                        self.positionCurrent01.y- self.positionLast01.y)
    end
    
    --单点取消
    local function fun_touchEnd(touch,event)

        if self.beTouchBegin == false then
            return;
        end

        self.beTouchBegin=false;

        --如果角色正在移动，则操作直接跳出
        if self.role.isMoving == true then
            return
        end

        --多点时跳出
        if self.touchNum >0 then
            return
        end


        local touchPoint = cc.p(-1,-1);
        -- --滑动状态下屏蔽点击事件
        local bIsTouchMap = true;
        if self.moveDistance<15 then
            local mapSize = self.layerSize
            local _localPos =self.mapUpNode:convertTouchToNodeSpaceAR(touch);
            if _localPos.y>=0 then
                bIsTouchMap=false;
            end
            _localPos.y=math.abs(_localPos.y)
            touchPoint.x = math.floor(_localPos.x/self.tileSize.width+_localPos.y/self.tileSize.height)
            touchPoint.y = math.floor(_localPos.y/self.tileSize.height-_localPos.x/self.tileSize.width)
            --整张地图的菱形区域之内
            if touchPoint.x <0
                    or touchPoint.y <0
                    or touchPoint.x>=mapSize.width
                    or touchPoint.y>=mapSize.height then
                bIsTouchMap = false;
            end

        else
            bIsTouchMap=false;
        end


        local function fun_normalSTTouchEnd(touch,event)
            if bIsTouchMap==true then
               self:touchIndexPos(touchPoint,touch,event)
            else --点击到了无效的地方

            end
        end

        local function fun_toolSTTouchEnd(touch,event)
            if bIsTouchMap==true then
                --检测是否点击到了可移除障碍
                local ableRemoveObstacle = self.objectLayer:checkRemoveObstacleWithIndexPos(touchPoint);
                if ableRemoveObstacle ~= nil then
                   self.functionChooseLayer:fun_useTool(ableRemoveObstacle)
                end
            end
        end

        if self.currentState == MapView.ST_NROMAL then 

            fun_normalSTTouchEnd(touch,event)
        elseif self.currentState == MapView.ST_TOOL then 
            fun_toolSTTouchEnd(touch,event)
        end


       
    end

    --多点点击
    local function onTouchesBegan(touches, event)
        self.beTouchBegin = true;
        if table.getn(touches)<2 then
            fun_toucBegan(touches[1],event)
            return
        end
        self.touchNum = 2;
        self.positionLast01 = touches[1]:getLocation()
        self.positionLast02 = touches[2]:getLocation()
        return true
    end
    
    --多点移动
    local function onTouchesMoved(touches, event)
        --移动距离
        self.moveDistance = self.moveDistance+cc.pGetDistance(touches[1]:getLocation(),self.positionLast01)
        if table.getn(touches)<2 then
            fun_touchMoved(touches[1],event)
            return
        end
        self.touchNum = 2;
        self.positionLast01 = self.positionCurrent01;
        self.positionLast02 = self.positionCurrent02;
        
        self.positionCurrent01 = touches[1]:getLocation()
        self.positionCurrent02 = touches[2]:getLocation()
        
        if self.positionLast01==nil or self.positionLast02 ==nil then
            self.positionLast01 = self.positionCurrent01
            self.positionLast02 = self.positionCurrent02
        end
        
        local fDisOrg = cc.pGetDistance(self.positionLast01,self.positionLast02)      
        local fDisCurrent = cc.pGetDistance(self.positionCurrent01,self.positionCurrent02)       
        local fRange = (fDisCurrent-fDisOrg)*0.001
        local center  = cc.pMidpoint(self.positionCurrent01,self.positionCurrent02);
        self:scaleMap(center,fRange)
    end
    
    --多点取消
    local function onTouchesEnded(touches,event)
        if table.getn(touches)<2 then
            fun_touchEnd(touches[1],event)
            if table.getn(touches) ==1 then
                self.touchNum = self.touchNum-1
            end
        end
        self.positionLast01 = nil
        self.positionCurrent01 = nil
        self.positionLast02 = nil
        self.positionCurrent02 = nil
        self.moveDistance = 0
    end
    
    local listener = cc.EventListenerTouchAllAtOnce:create()    
    listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN )
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED )
    listener:registerScriptHandler(onTouchesEnded,cc.Handler.EVENT_TOUCHES_ENDED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


function MapView:touchIndexPos(touchPoint,touch,event)

    --添加无效提示
    --如果在地形范围之内点击的地方无法找到路径，则认为操作无效，此时给提示效果
    local function fun_addInvalidTips()
        self.bIsReadyMove = false;

        if touch==nil then 
            return;
        end
        
        local _pLocPos= touch:getLocation()
        local _sp = cc.Sprite:create("res/ui/06_exmainUI/06_bg_forbid_01.png")
        _sp:setLocalZOrder(10)
        _sp:setPosition(_pLocPos)
        self:addChild(_sp)
        local pAction = cc.Sequence:create(cc.FadeTo:create(1.0,0),cc.RemoveSelf:create())
        _sp:runAction(pAction)
    end

    --添加功能选择按钮
    local function fun_addFunctionChoose(objTab)
        self.functionChooseLayer:addInfoFunction(objTab)
    end


     --检测是否点击到了可移除障碍
    local ableRemoveObstacle = self.objectLayer:checkRemoveObstacleWithIndexPos(touchPoint);
    if ableRemoveObstacle ~= nil then 
        ableRemoveObstacle:addItemTips();
        return;
    end

    --起始点物体
    local startObjTab = self.objectLayer:checkElementWithIndexPos(self.role:getPosIndex())

    --点击的物体
    local endObjTab =self.objectLayer:checkElementWithIndexPos(touchPoint)
    if #endObjTab == 0 then 
        local _obj = self.objectLayer:checkElementWithTouchPos(touch);
        if _obj ~=nil then
            table.insert(endObjTab,_obj);
        end
    end

    --移除所有的功能按钮 
    self.functionChooseLayer:removeAllFunction();
    if self.bIsReadyMove ==true then

        local bSamePoint = false;
        if self.lastTouchPoint.x == touchPoint.x and
            self.lastTouchPoint.y == touchPoint.y then
            bSamePoint = true;
        end

        local bSameObject = false;
        if self.lastSelectObj~=nil and 
            self.lastSelectObj[1]~=nil and 
            endObjTab[1]~=nil and
            self.lastSelectObj[1]==endObjTab[1] then

            bSameObject = true;
        end

        if bSamePoint== true or
            bSameObject== true then
            --如果玩家点击位置和上一次的位置一致,则直接移动
            if self.role.maxPerStep<self.pathSteps then
                local pTips = MapViewMoveLimitTips:create(MapViewMoveLimitTips.TYPE_FAR)
                self:addChild(pTips)
                return
            end

            local _startObj = startObjTab[1]
            if _startObj==nil then      --如果起始位置没有建筑
                self.pLogic:reqMove(self.pLogic.currentNodeID,
                                                    -1,
                                                    self.pathTable);
            else                        --如果起始位置有建筑
                self.pLogic:reqMove(self.pLogic.currentNodeID,
                                                _startObj.uid,
                                                self.pathTable);
            end

            --如果角色在屏幕之外移动镜头到主角位置
            if self.role:isInScreen() == false then 
                self:moveCameraForRoleToScreenCenter();
            end

            return;
        else
            --如果不一致，重新计算
            self.objectLayer:removeAllRoadDirection();
            self.ObjectMaskLayer:removeAllRoadDirection();
        end
    end

    --存储玩家点击点
    self.lastTouchPoint = touchPoint;
    if endObjTab[1]~=nil then 
        self.lastTouchPoint = endObjTab[1].indexPos;
    end
   --玩家点击到了有方格内的点
   --判断当前格子的状态(迷雾，障碍物，怪物，道具)
   --判断是否点到了迷雾
   local _gid = self.maskLayer:getDate(self.lastTouchPoint)
   if _gid == MapView.MASK_ID then
        print("1111111111")
        fun_addInvalidTips();--无效提示
        return; --如果点击的是迷雾，直接跳出
   end

    --障碍物数据层

    local obstacleID = self.obstacleDateLayer:getDate(self.lastTouchPoint)
    if obstacleID~=0 then
         print(self.lastTouchPoint.x,self.lastTouchPoint.y,obstacleID,"2222222222")
        fun_addInvalidTips();--无效提示
        return;--如果点击的是障碍物，直接跳出
    end


    --检测是否点击到玩家已经进入的建筑
    for i,var in pairs(endObjTab) do
        if var.spPlayerRoleHead~=nil then 
            -- --添加功能选择按钮
            self.functionChooseLayer:addEnterFunction(var);
            return;
        end
    end

   --暂时把点击的那个元素部分临时变成可通过类型
   for i,var in pairs(endObjTab) do
       local _pointTab = var:getEffectedArea();
       for j,_var in pairs(_pointTab) do
           self.mapDateLayer:setDate(MapView.MAP_ABLE_MOVE_ID,_var)
       end
   end

   --暂时把起始点物体变为可通行
   for i,var in pairs(startObjTab) do
    local _pointTab = var:getEffectedArea();
       for j,_var in pairs(_pointTab) do
           self.mapDateLayer:setDate(MapView.MAP_ABLE_MOVE_ID,_var)
       end
   end

   --暂时把玩家所在的位置变为可通行
   local playerPos = self.role:getPosIndex();
   local _playerPosLocalValue = self.mapDateLayer:getDate(playerPos)
   self.mapDateLayer:setDate(MapView.MAP_ABLE_MOVE_ID,playerPos)


    --如果点到了正常部分，算路径
    local aStarPathFinding = myCustom.AStarPathFinding:create(self.mapDateLayer:getTab(),
                                                                self.layerSize.width,
                                                                self.layerSize.height)
    aStarPathFinding:setStartAndEndPoint(self.role:getPosIndex(),self.lastTouchPoint,4) --4代表4方向寻路
    local targetIndexTabel = aStarPathFinding:getPathDate();

    --恢复不可通过的属性
    for i,var in pairs(endObjTab) do
       local _pointTab = var:getEffectedArea();
       for j,_var in pairs(_pointTab) do
           self.mapDateLayer:setDate(MapView.MAP_DISABLE_MOVE_ID,_var)
       end
   end
   self.mapDateLayer:setDate(_playerPosLocalValue,playerPos)
    for i,var in pairs(startObjTab) do
       local _pointTab = var:getEffectedArea();
       for j,_var in pairs(_pointTab) do
           self.mapDateLayer:setDate(MapView.MAP_DISABLE_MOVE_ID,_var)
       end
   end

   --检测结果
    if table.getn(targetIndexTabel) ==  0 then
        print("3333333333333333")
        fun_addInvalidTips();--无效提示
        return; --没有得到路径，则直接跳出
    end

    --删除路径table中原有的所有节点
    for i=table.getn(self.pathTable),1,-1 do
        table.remove(self.pathTable,i);
    end
    --更新路径table
    for i=table.getn(targetIndexTabel),1,-2 do
        table.insert(self.pathTable,cc.p(targetIndexTabel[i-1],targetIndexTabel[i]))
    end

    --如果起点是在建筑内，则移除与建筑重合的点
    for i,var in pairs(startObjTab) do
        local _pointArea = var:getEffectedArea();
        local _pathSize = table.getn(self.pathTable);
        for k=_pathSize,1,-1 do
            v = self.pathTable[k]
            for j,_var in pairs(_pointArea) do
                if _var.x == v.x and
                    _var.y == v.y then
                    table.remove(self.pathTable,k);
                end
            end
        end
    end


    --如果终点是功能建筑，则移除多余的与功能建筑重合的点,但是保留最后一个
    --但是如果策划要求终点不可踩上去的类型，则不能踩上去
    local borderPoint =nil
    for i,var in pairs(endObjTab) do
        local _pointArea = var:getEffectedArea();
        local _pathSize = table.getn(self.pathTable)
        local _areaSize = table.getn(_pointArea);
        for j=_pathSize,1,-1 do
            local _var = self.pathTable[j]
            for z,_point in pairs(_pointArea) do
                if _var.x ==_point.x and
                        _var.y == _point.y then
                    borderPoint = cc.p(_var.x,_var.y);
                    table.remove(self.pathTable,j);
                    break;
                end
            end
        end
    end
    if borderPoint~=nil then
        table.insert(self.pathTable,borderPoint);
    end

    --计算所需体力
    local phyTab=nil;
    self.pathPhysicals , phyTab= self:getNeedPhysical(self.pathTable)

    --所需步骤
    self.pathSteps   = table.getn(self.pathTable)

    --给出了路线指引
    self.objectLayer:addRoadDirction(self.pathTable,self.pathPhysicals,phyTab) 

    --添加功能选择按钮
    fun_addFunctionChoose(endObjTab);

    --根据障碍物情况判定是否需要去掉最后一个格子的移动
    for i,var in pairs(endObjTab) do
        if var:isObstacle() == true then
            table.remove(self.pathTable,table.getn(self.pathTable))
        end
    end

    self.lastSelectObj = endObjTab;         --上一次所选择的物体

    --准备移动
    self.bIsReadyMove = true;
end



--更新玩家路径的最后一个点的位置（目的是和服务器保持一致）
function MapView:updatePathTableLastPoint(x,y)
    local _size = table.getn(self.pathTable)   
    self.pathTable[_size].x = x;
    self.pathTable[_size].y = y;
end

--更新玩家体力（和服务器保持一致）
function MapView:subPlayerPhy(iValue)
    -- body
end

--平移地图
function MapView:moveMap(x,y)

    local centerX = 300;    --x轴向中心
    local centerY = 650;    --Y轴向中心

    --控制移动范围
    if x>0 then 
        if self.transNodeLeft:getParent():convertToWorldSpaceAR(cc.p(self.transNodeLeft:getPosition())).x>centerX then
            return;
        end
    else
        if self.transNodeRight:getParent():convertToWorldSpaceAR(cc.p(self.transNodeRight:getPosition())).x<centerX then 
            return;
        end
    end

    if y>0 then 
        if self.transNodeDown:getParent():convertToWorldSpaceAR(cc.p(self.transNodeDown:getPosition())).y>centerY then 
            return;
        end
    else
        if self.transNodeUp:getParent():convertToWorldSpaceAR(cc.p(self.transNodeUp:getPosition())).y<centerY then 
            return;
        end
    end

    self.mapParent:setPositionX(self.mapParent:getPositionX()+x)
    self.mapParent:setPositionY(self.mapParent:getPositionY()+y)

    self.backgroundMap:move(x,y)
end

--缩放地图
function MapView:scaleMap(center,fValue)
    if fValue == 0 then 
        return 
    end
    --最大缩放
    if self.mapParent:getScale()>=1.6 and fValue>0 then 
        return 
    end
    --最小缩放
    if self.mapParent:getScale()<=0.6 and fValue<0 then
        return
    end
    
    local movePoint  = cc.p(self.mapParent:getPositionX()-center.x,self.mapParent:getPositionY()-center.y) 
    self.mapParent:setPosition(center)
    self.mapParent:setScale(self.mapParent:getScale()+self.mapParent:getScale()*fValue)
    
    self.map:setPositionX(self.map:getPositionX()+movePoint.x/self.mapParent:getScale())
    self.map:setPositionY(self.map:getPositionY()+movePoint.y/self.mapParent:getScale())
    
    self.maskLayer:setPositionX(self.maskLayer:getPositionX()+movePoint.x/self.mapParent:getScale())
    self.maskLayer:setPositionY(self.maskLayer:getPositionY()+movePoint.y/self.mapParent:getScale())

end

--移动角色
function MapView:moveRole()

    self.role:updateLastPos();

    --预先计算沿途需要激活的物体
    local mapSize = self.layerSize;
    for i=0,mapSize.width -1,1 do
        for j=0,mapSize.height - 1,1 do
            if math.abs(i - self.role:getPosIndex().x)<=self.role.visionField and
                math.abs(j - self.role:getPosIndex().y)<=self.role.visionField and
                (math.abs(j - self.role:getPosIndex().y)+math.abs(i - self.role:getPosIndex().x)) <self.role.visionField*2 then
                self.objectLayer:makeBuildingActive(cc.p(i,j))
            end
        end
    end


    self.role:setMoveBegin(#self.pathTable)
    self.bIsReadyMove = false;
    local actionTable = {}

    --单个格子移动开始
    local function fun_stepMoveBegin(node,pTab)
        local moveTime = pTab[1];
        local playTime = ruleConfig.MOVE_TIME/moveTime;

        self.role:setAnimationSpeed(playTime);
    end


    --单个格子移动完成回调函数
    local function fun_stepMoveFinish(node,pTab)
        local indexPos = pTab[1];
        local nextIndex = pTab[2];
        --改变角色方向
        if nextIndex~=nil then
            if nextIndex.x>indexPos.x or 
                nextIndex.y<self.role:getPosIndex().y then 
                self.role:setDirection(-1)
            else
                self.role:setDirection(1)
            end
        end

        self.role:setCurrentPosIndex(indexPos)                              --角色当前位置
        self.objectLayer:updatePlayerRole(self.role)                        --角色本身
        self:updateMaskLayerWithPlayer()                                    --更新遮罩层信息
        self.objectLayer:removeRoadDirection(indexPos)                      --移除路径指引
        self.ObjectMaskLayer:removeRoadDirection(indexPos)                  --移除路径指引
        --self.objectLayer:reduceLimitCount(1)                              --减少限时类建筑的次数
        --self:moveCameraForRoleToScreenCenter();
    end

    --所有格子移动完成回调函数
    local function fun_allMoveFinish(node,indexPos)
        self:eventTriggerWithPos(self.lastTouchPoint)                           --看点击的位置是否有物体需要出发事件
        self.objectLayer:removeAllRoadDirection()                               --强制移除所有路径
        self.ObjectMaskLayer:removeAllRoadDirection()                           --强制移除所有路径
        self.ObjectMaskLayer:removeAllFunctionInfoPanel()                       --移除所有详情面板
        self.role:setMoveFinish()                                               --角色移动完成更新
        --self.objectLayer:setObjectAlphaValueWithPos(self.role:getPosIndex());   --根据玩家的位置设置环境半透明
        self.pLogic:saveDate(self.pLogic.currentMapID,self.mapDateTab);         --数据保存
        --self:addPhyTips();                                                      --体力不足的时候给提示
        self.mapParent:stopActionByTag(MapView.ACTION_TAG_FOLlOW_ROLE);         --停止屏幕移动//
    end

    local fAllMoveTime = 0;
    local targetPos =nil

    for i,var in pairs(self.pathTable) do
        local pos = self.mapDateLayer:getPositionAt(var)
        local size = self.tileSize
        pos.x = pos.x+size.width*0.5;
        pos.y = pos.y+size.height*0.5;
        local _fMoveTime = ruleConfig.MOVE_TIME;
        --沼泽地形移动减慢
        local terrainObj =  self.objectLayer:getTerrain(var)
        if terrainObj~=nil then
            _fMoveTime = terrainObj:getMoveTime();
        end
        _fMoveTime = self.role:getMoveTimeEffectByBuff(i,_fMoveTime);
        if _fMoveTime <=0 then
            _fMoveTime = ruleConfig.MOVE_TIME;
        end

        local pCallBging  = cc.CallFunc:create(fun_stepMoveBegin,{_fMoveTime});
        local pMoveAction = cc.MoveTo:create(_fMoveTime,pos)
        local pCallAction = cc.CallFunc:create(fun_stepMoveFinish,{var,self.pathTable[i+1]})
        local pSqueAction = cc.Sequence:create(pCallBging,pMoveAction,pCallAction)
        table.insert(actionTable,pSqueAction)
        fAllMoveTime=fAllMoveTime+_fMoveTime;
        targetPos = pos;
    end
    
    local pAllMoveFinished =  cc.CallFunc:create(fun_allMoveFinish,{}) 
    table.insert(actionTable,pAllMoveFinished)
    local pAction = cc.Sequence:create(actionTable);
    self.role:runAction(pAction)
    
    --如果玩家刚才是在建筑里
    local pBuilding = self.objectLayer:getObjectWihtUID(self.role.lastGetInBuildingUID)
    if pBuilding ~= nil then
        pBuilding:playerRoleGetOut(self.role)
    end 

    --角色图片的方向
    local nextIndex = self.pathTable[1]
    if nextIndex~=nil then 
        if nextIndex.x >self.role:getPosIndex().x or 
            nextIndex.y<self.role:getPosIndex().y then 
            self.role:setDirection(-1);
        else
            self.role:setDirection(1);
        end
    end

    --摄像机跟随玩家移动
    if self.role:isInScreen() == true then 
        fAllMoveTime = fAllMoveTime*2;
    end
    self:moveCameraWithPlayerMotion(fAllMoveTime,targetPos);

end



--移动角色到指定位置
function MapView:moveRoleWithIndexPos(indexPos)
    local fMoveSpeed = 0.1

    local pos = self.mapDateLayer:getPositionAt(indexPos)
    local size = self.tileSize
    pos.x = pos.x+size.width*0.5;
    pos.y = pos.y+size.height*0.5
    self.role:setPosition(cc.p(pos.x,pos.y));

    self.role:setCurrentPosIndex(indexPos)

    local pObjTb = self.objectLayer:getObject(indexPos)
    local pObj = nil
    for k,v in pairs(pObjTb) do
        pObj= pObjTb[1]
    end

    if pObj ~= nil then 
        pObj:playerRoleGetIn(self.role);
    end
end

--设置角色到指定位置
function MapView:setRolePosWithIndexPos(indexPos)
    local pos = self.mapDateLayer:getPositionAt(indexPos)
    local size = self.tileSize
    pos.x = pos.x+size.width*0.5;
    pos.y = pos.y+size.height*0.5
    self.role:setPosition(pos)

    self.role:setCurrentPosIndex(indexPos)

    local pObjTb = self.objectLayer:getObject(indexPos)
    local pObj = nil 
    for k,v in pairs(pObjTb) do
        pObj= pObjTb[1]
    end

    if pObj ~= nil then
        pObj:playerRoleGetIn(self.role);
    end

end



--计算所需要的体力数
function MapView:getNeedPhysical(pathTable)
    local bRet = 0
    local bTab =nil;
    local bpathPhy ={};
    --地形所需
    for i,var in pairs(pathTable) do
        local pTerrain  = self.objectLayer:getTerrain(var)
        local _value = 0
        if pTerrain == nil  then
            _value =MapView.physicalExertionPer
        else
            _value =pTerrain:getUse(var,pathTable);
        end 
        _value=0;
        _value = math.floor(_value)
        table.insert(bpathPhy,_value);
    end
    --buff所需
    bRet ,bTab = self.role:physicalComputing(bpathPhy)
	bRet = #pathTable
    return bRet ,bTab;
end

--根据位置减少体力
function MapView:reducePlayerPhysicalWithPos(posIndex)


end
--更新玩家体力
function MapView:updatePlayerPhysical()
    --更新体力
    self.role:updatePhysical();
    --更新界面
    self.gui:setPhysical(self.role.physical);

end

--体力不足的时候给提示
function MapView:addPhyTips()

    if self.role.physical <= ruleConfig.PHY_ZERO_TIPS then
        if self.pLogic:getIsAddPhyZeroTips() == 1 then 
            return;
        end
        self.pLogic:setIsAddPhyZeroTips()

        local tips = MapViewDialogTipsPhysicalZero:create(self);
        self:addChild(tips);      


    elseif self.role.physical<=ruleConfig.PHY_TIPS then
        if self.pLogic:getIsAddPhylessTips() == 1 then 
            return;
        end
        self.pLogic:setIsAddPhylessTips()

        local tips = MapViewDialogTipsPhysical:create(self);
        self:addChild(tips);
    end

end


--移动角色过程中的事件触发 posIndex--位置index
function MapView:eventTriggerWithPos(posIndex)
    -- body
    local pElementTab = self.lastSelectObj

    --如果最后一元素是事件物体，则需要消耗一次体力
    if table.getn(pElementTab)>0 then 
        self:reducePlayerPhysicalWithPos(posIndex)
    end


    for i,var in pairs(pElementTab) do
        self.functionChooseLayer:addEnterFunction(var)
        if var.isBeRemoved ==nil then 
            --如果有必要，则进入到建筑中
            var:playerRoleGetIn(self.role)
        end
    end
end


--为object层添加object
function MapView:addObjectOnObjLayer(id,posIndex)
    -- body
    self.objectLayer:addObject(id,posIndex)
end


--更新mask层数据
function MapView:updateMaskLayerWithPlayer()
    --body
    --根据角色的位置设置mask层
    local mapSize = self.layerSize
    for i=0,mapSize.width -1,1 do
        for j=0,mapSize.height - 1,1 do
            --物体显示
            if math.abs(i - self.role:getPosIndex().x)<=self.role.visionField and
                math.abs(j - self.role:getPosIndex().y)<=self.role.visionField and
                (math.abs(j - self.role:getPosIndex().y)+math.abs(i - self.role:getPosIndex().x)) <self.role.visionField*2 then
                    --正常激活部分
                    local bRet = self:updateMaskLayer(cc.p(i,j));
                    --联动层部分
                    if bRet==true then
                        self:updateLinkLayer(cc.p(i,j));
                    end
            end
        end
    end

    --重新指定地图可移动范围
    self:updateMoveMapRange();
end

--联动层部分
function MapView:updateLinkLayer(pIndex)
    local linkTab = self.objectLayer:getLinkDate(pIndex);
    if linkTab ~=nil then
        for k,v in pairs(linkTab) do
            self:updateMaskLayer(v);
        end

        for k,v in pairs(linkTab) do
            self.objectLayer:setLinkLayerDate(v,0);
        end
    end

end

--更新mask数据
function MapView:updateMaskLayer(indexPos)
    if indexPos.x>self.layerSize.width-1 or 
        indexPos.y>self.layerSize.height-1 or
        indexPos.x<0 or
        indexPos.y<0 then
        return false;
    end
    --遮罩层
    if self.maskLayer:getDate(indexPos) == MapView.MASK_EMPTY then
        return false;
    end

    self:displayObject(indexPos)
    local bRet = self:removeMaskArea(indexPos)
    if bRet then
        self:mappingDate(indexPos)
    end

    return true;

end

--移除指定区域的遮罩
function MapView:removeMaskArea(indexPos)
    -- body
    if self.maskLayer:getDate(indexPos) == MapView.MASK_EMPTY then 
        return false;
    end
    self.maskLayer:updateDate(indexPos,MapView.MASK_EMPTY,nil)
    self.mapDateTab[indexPos.x..","..indexPos.y]=MapView.MASK_EMPTY;
    return true;
end

--激活物体
function MapView:displayObject(indexPos)
    --控制物体层显示
    self.objectLayer:setBGVisible(indexPos,true);
    self.objectLayer:setObjectVisible(indexPos,true);
end


--更新objectLayer层数据
function MapView:updateObjectLayer()
    -- body
end

--为objectDate层添加数据信息
function MapView:addInfoForObjectDateLayer(indexPos,pTable)
    -- body
    if indexPos.x>=self.layerSize.width or 
        indexPos.y >= self.layerSize.height or
        indexPos.x< 0 or
        indexPos.y< 0 then 
        return;
    end
    self.objectLayer:updateDate(indexPos,MapView.OBJ_DISABLE_MOVE_ID,pTable);
    self:mappingDate(indexPos)
end

--删除objectDate层数据信息
function MapView:removeInfoForObjectDateLayer(indexPos,pTable)
    -- body
     self.objectLayer:updateDate(indexPos,MapView.OBJ_EMPTY,pTable);
     self:mappingDate(indexPos)
end

--数据映射
function MapView:mappingDate(posIndex)
    local maskID = self.maskLayer:getDate(posIndex)
    local objID  = self.objectLayer:getDate(posIndex)
    local obstacleID = self.obstacleDateLayer:getDate(posIndex)
    if maskID == MapView.MASK_ID or 
        objID == MapView.OBJ_DISABLE_MOVE_ID or
        obstacleID ~= 0 then
        self.mapDateLayer:setDate(MapView.MAP_DISABLE_MOVE_ID,posIndex)
    else
        self.mapDateLayer:setDate(MapView.MAP_ABLE_MOVE_ID,posIndex)
    end

end


--移动镜头是相应物体到屏幕中心
function MapView:moveCamWithObjToScreenCenter(pElement)
    local fMoveTime = 0.5
    local objWorldPos = pElement:getParent():convertToWorldSpaceAR(cc.p(pElement:getPosition()))
    local centerPos = cc.p(375,650)
    local dir = cc.p(centerPos.x - objWorldPos.x,centerPos.y - objWorldPos.y)

    local spx = centerPos.x - objWorldPos.x;
    local spy = centerPos.y - objWorldPos.y;
    local distance = spx*spx+spy*spy;
    
    --距离太小就不做运动//
    if distance < 10 then
        return 0.01;
    end

    fMoveTime = fMoveTime*(distance/140625);
    if fMoveTime<0.3 then
        fMoveTime = 0.3;
    end

    local pAction = cc.EaseSineInOut:create(cc.MoveBy:create(fMoveTime,dir))
    self.mapParent:runAction(pAction) 

    return fMoveTime;
end


--根据玩家的前进方向移动镜头
function MapView:moveCameraWithPlayerMotion(fMoveTime,targetPos)
    if targetPos==nil then 
        return;
    end

    local objWorldPos = cc.p(self.role:getPosition())
    local centerPos = targetPos;
    local dir = cc.p( objWorldPos.x - centerPos.x, objWorldPos.y-centerPos.y)
    if fMoveTime ==nil then 
        fMoveTime=0.5;
    end
    local pAction = cc.EaseSineInOut:create(cc.MoveBy:create(fMoveTime,dir))
    pAction:setTag(MapView.ACTION_TAG_FOLlOW_ROLE);
    self.mapParent:runAction(pAction)
end

--移动摄像机，使玩家尽量出于屏幕中间
function MapView:moveCameraForRoleToScreenCenter()
    local objWorldPos = self.role:getParent():convertToWorldSpaceAR(cc.p(self.role:getPosition()))
    local centerPos = cc.p(375,650)

    local x = centerPos.x - objWorldPos.x;
    local y = centerPos.y - objWorldPos.y;

    local fMoveTime = 0.3
    local pAction = cc.EaseSineInOut:create(cc.MoveBy:create(fMoveTime,cc.p(x,y)))
    self.mapParent:runAction(pAction)

    for k,v in pairs(self.objectLayer.functionElementTab) do
        v:playerRoleGetOut(self.role);
    end

end



--把玩家移动到最近的永久挂机点
function MapView:moveRoleToNearstHookPoint()
    local hookPointTb = self.objectLayer:getAllHookPoint(); --获取所有挂机点

    --找到最近的挂机点
    local pHookPoint = hookPointTb[1];
    if pHookPoint == nil then
        return;
    end
    local currentPos = cc.p(self.role:getPositionX(),self.role:getPositionY())
    self.role:setPositionWithTitle(pHookPoint.indexPos,
                                    self.mapDateLayer:getPositionAt(pHookPoint.indexPos),
                                    self.tileSize)
    local locPos = cc.p(self.role:getPositionX()-currentPos.x,self.role:getPositionY()-currentPos.y)
    self:moveMap(locPos.x*-1,locPos.y*-1)
    self.role:addSupply(100);

    pHookPoint:playerRoleGetIn(self.role);
end

--更新玩家可拖动地图的最大范围
function MapView:updateMoveMapRange()
    --获取masklayer的最大最小位置
    local bRet = self.maskLayer:getMaxAndMinPos();
    
    self.transNodeUp:setPosition(bRet[1]);
    self.transNodeDown:setPosition(bRet[2]);
    self.transNodeLeft:setPosition(bRet[3]);
    self.transNodeRight:setPosition(bRet[4]);
end






--状态切换
function MapView:setCurrentState(istate)
    self.currentState = istate;
end

function MapView:setStateNormal()
    self.currentState = MapView.ST_NROMAL;
end

function MapView:setStateTool()
    self.currentState = MapView.ST_TOOL
end

--@function: 设置底部按钮底框是否显示
function MapView:SetMenuBgVisible(bVisible)
    self.gui:SetMenuBgVisible(bVisible)
end