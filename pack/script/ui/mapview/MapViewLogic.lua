require("script/class/class_base_ui/class_base_logic")
require("script/core/configmanager/configmanager");

require("script/ui/mapview/MapView")
local cjson                 = require('cjson.core')
local signFile              = mconfig.loadConfig("script/cfg/map/sign");
local stringFile            = require("script/cfg/string");
local mapRuleConfigFile     = mconfig.loadConfig("script/cfg/client/map_rule")
local worldmapConfigFile    = mconfig.loadConfig("script/cfg/map/worldmap")

local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local TB_MAP_VIEW_LOGIC={
    pLogic    =nil,
    pLayer    =nil,
    mapDate   =nil,   --地图信息

    startPos = cc.p(0,0),     --玩家在当前地图的其实位置
    currentMapID = 1,         --当前地图ID
    currentNodeID = 1,         --节点id
    lastHookPoint = 0,

    bIsGetMoveRsp =true, --是否获取玩家行走返回
    mapElementStateList = nil,
    signList =nil,

    maxMap =1,     --最大地图

    currentProcess = 0;

    --更新用
    m_tbUpdateTypes = {
        l_tbUIUpdateType.EU_MONEY,
        l_tbUIUpdateType.EU_PROPERTY,
        l_tbUIUpdateType.EU_LEVELUP,
    },
}

MapViewLogic=class("MapViewLogic",function()
    return KGC_UI_BASE_LOGIC:create()
end,TB_MAP_VIEW_LOGIC)



function MapViewLogic:getInstance()
	if MapViewLogic.pLogic==nil then
        MapViewLogic.pLogic=MapViewLogic:create()
		GameSceneManager:getInstance():insertLogic(MapViewLogic.pLogic)
	end
	return MapViewLogic.pLogic
end

function MapViewLogic:initAttr()
    -- body
    local tbTemp = gf_CopyTable(TB_MAP_VIEW_LOGIC)
    for k, v in pairs(tbTemp) do
        self[k] = v;
    end
end

function MapViewLogic:create()
    local _logic = MapViewLogic:new()

    local sValue = me:GetAccount().."maxMap";
    _logic.maxMap = cc.UserDefault:getInstance():getIntegerForKey(sValue,1)

    
    return _logic
end

function MapViewLogic:initLayer(parent,id)
    
    GameSceneManager:getInstance():ShowLayer(id)
    if self.pLayer ~=nil then
    	return
    end

    GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PROGRESS);
    local fnCall = function()
        KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():closeLayer();
        self.pLayer=MapView:create()
        self.pLayer.id=id
        parent:addChild(self.pLayer)
    end
    local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnCall));
    GameSceneManager:getInstance().pLayer:runAction(action)
end



function MapViewLogic:closeLayer()
    if self.pLayer == nil then 
        return;
    end
    self.pLayer:closeLayer()
    self.pLayer=nil

end

function MapViewLogic:hideLayer()
    GameSceneManager:getInstance():HideLayer(self.pLayer.id)
end

function MapViewLogic:openMap(nodeid,info)

    local x = info.x;
    local y = info.y;
    self.mapElementStateList = info.uidList;
    self.currentProcess = info.process;
    local buff = info.buff;
    local ap = info.ap;
    local sign = info.sign;

    local mapid = worldmapConfigFile[nodeid].ResourceID;

    if self.currentMapID == mapid then
        if self.pLayer ~= nil then
            GameSceneManager:getInstance():ShowLayer(GameSceneManager.LAYER_ID_MAP)
            return;
        end
    end

    self:removeTexture();
    self:closeLayer() --关闭之前的    

    MapViewLogic:getInstance().startPos = cc.p(x,y);
    MapViewLogic:getInstance().currentMapID = mapid;
    MapViewLogic:getInstance().currentNodeID = nodeid;
    GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAP)   

end


function MapViewLogic:openCurrentMap()
    MapChooseLogic:getInstance():reqEnterMap(self.currentNodeID);
end

function MapViewLogic:OnUpdateLayer(iType, tbArg)

    if self.pLayer==nil then  
        return  
    end

    if self.pLayer.gui==nil then 
        return
    end
    self.pLayer.gui:initAttr();

	if iType == l_tbUIUpdateType.EU_AFKERREWARD then
		if self.pLayer.gui.m_pMainBtnLayer then
			local nPercent = (tbArg or {})[1] or 0;
			self.pLayer.gui.m_pMainBtnLayer:SetRewardProgress(0, nPercent);
		end
    elseif iType == l_tbUIUpdateType.EU_SEARCH then
        if self.pLayer.m_pMainBtnLayer then
            local nSearchT = (tbArg or {})[1] or 0;
            self.pLayer.gui.m_pMainBtnLayer:StartSearch(nSearchT);
        end
    elseif iType == l_tbUIUpdateType.EU_FIGHTHP then
        if self.pLayer.m_pMainBtnLayer then
            local nSelfHp = (tbArg or {})[1] or 0;
            local nEnemyHp = (tbArg or {})[2] or 0;
            self.pLayer.gui.m_pMainBtnLayer:SetFightHp(nSelfHp, nEnemyHp);
        end
    elseif iType == l_tbUIUpdateType.EU_FIGHTRESULT then
        if self.pLayer.m_pMainBtnLayer then
            local bWin = (tbArg or {})[1] or false;
            local tReward = (tbArg or {})[2] or {};
            self.pLayer.gui.m_pMainBtnLayer:SetResult(bWin, tReward);
        end
	end
end

--初始化地图信息
function MapViewLogic:initMapDate()
    self.mapDate={}
    -- body
    for i=1,10 do
        for j=1,10 do
            self.mapDate[i][j] = 1
        end
    end
end


function MapViewLogic:setMapDateValue(point,value)
    -- body
    self.mapDate[point.x][point.y] = value
end


function MapViewLogic:getBuildingConfig(buildingID)
    -- body
    
end

--体力消耗
function MapViewLogic:physicalExertion(pathTable)
    -- body
    
end

--挂机战斗结束反馈
--@rewardTab = {nGold, nExp, tbItems}
function MapViewLogic:HookFightFinished(mapid,hookpointid,hookpointUID,rewardTab)

end


------------------------------------------------------------------客户端缓存数据
function MapViewLogic:saveDate(mapid,mapDateTab)
    local filePath=cc.FileUtils:getInstance():getWritablePath();
    print(me:GetAccount());
    print(me:GetArea());
    local luaFile = io.open(filePath..me:GetAccount()..me:GetArea().."mapdate"..mapid..".lua", 'w')
    luaFile:write(cjson.encode(mapDateTab))
    luaFile:close()
end



function MapViewLogic:getDate(mapid)
    local filePath=cc.FileUtils:getInstance():getWritablePath();
    local luaFile ,errorString = io.open(filePath..me:GetAccount()..me:GetArea().."mapdate"..mapid..".lua", 'r')
    if luaFile ==nil then
        return nil
    end

    local status,_date = pcall(cjson.decode, luaFile:read());
    luaFile:close()

    if not(status) then
        return nil;
    end


    return _date;
end

function MapViewLogic:setMaxMap(currentMapID)
    if self.maxMap > currentMapID then 
        return;
    end

    self.maxMap = currentMapID;

    local sValue = me:GetAccount().."maxMap";
    cc.UserDefault:getInstance():setIntegerForKey(sValue,self.maxMap)
    cc.UserDefault:getInstance():flush()

end

--体力太少
function MapViewLogic:getIsAddPhylessTips()
    local sValue = me:GetAccount().."phylesstips";
    local ivalue =  cc.UserDefault:getInstance():getIntegerForKey(sValue,0)
    return ivalue;
end

function MapViewLogic:setIsAddPhylessTips()
    local sValue = me:GetAccount().."phylesstips";
    cc.UserDefault:getInstance():setIntegerForKey(sValue,1)
    cc.UserDefault:getInstance():flush()
end

--体力已空
function MapViewLogic:getIsAddPhyZeroTips()
    local sValue = me:GetAccount().."phyzerotips";
    local ivalue =  cc.UserDefault:getInstance():getIntegerForKey(sValue,0)
    return ivalue;
end

function MapViewLogic:setIsAddPhyZeroTips()
    local sValue = me:GetAccount().."phyzerotips";
    cc.UserDefault:getInstance():setIntegerForKey(sValue,1)
    cc.UserDefault:getInstance():flush()
end


--------------------------------------------------------------------------网络协议
--打开地图请求
function MapViewLogic:reqOpenView(mapid)        ---请求打开地图
    -- local fnCallBack = function(tbArg)
    --     self:rspOpenView(tbArg);
    -- end

    -- local tbReqArg = {};
    -- tbReqArg.nodeid = mapid;
    -- g_Core.communicator.loc.enterMap(tbReqArg,fnCallBack);
end

--打开地图返回
--uidlist 两个字段： state args
function MapViewLogic:rspOpenView(date)         --打开地图返回
 
    -- local mapid                     =   date.mapid;
    -- local x                         =   date.x;
    -- local y                         =   date.y;
    -- self.mapElementStateList        =   date.uidList;
    -- self.signList                   =   date.sign;


    -- self.startPos = cc.p(x,y);
    -- self.currentMapID = mapid;

    -- self:closeLayer() --关闭之前的
    -- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAP)
    
    
end

--请求移动
function MapViewLogic:reqMove(nodeid,itemUid,path)  --请求移动
    if table.getn(path) == 0 then
        self.pLayer:moveRole();
        return;
    end

     local fnCallBack = function(tbArg)
        self:rspMove(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.nodeid = nodeid;
    tbReqArg.uid =  itemUid;
    tbReqArg.path = path;

    self.bIsGetMoveRsp = false

    g_Core.communicator.loc.walkPath(tbReqArg,fnCallBack);
end

--请求移动返回
function MapViewLogic:rspMove(date)             --请求移动返回

    self.bIsGetMoveRsp = true

    local mapid     =   date.mapid;
    local x         =   date.x;
    local y         =   date.y;
    local action    =   date.ap;
    local buff      =   date.buff;

    me:SetAP(action);
    self.pLayer:updatePlayerPhysical();
    self.pLayer:updatePathTableLastPoint(x,y);
    self.pLayer:moveRole();
    me:SetMapBuffList(buff)
    self.pLayer.role:updateBuffer(buff);
    self.pLayer.gui:updateBuffer(buff);
end

--捡宝箱请求
function MapViewLogic:reqGetChest(nodeid,uid,nextstate,args)    --捡宝箱
    self:reqElementFunction(uid,nextstate,args)
end

--捡宝箱请求返回
function MapViewLogic:rspGetChest(date)

    local uid               =   date.uid;
    local reward            =   date.reward;

    local tbCurrency,tbObjs = KGC_REWARD_MANAGER_TYPE:getInstance():AddReward(reward)


    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement~= nil then 
        GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency, tbObjs}});
        --self.pLayer.ObjectMaskLayer:rewardEffect(bRwardList)
        self.pLayer:moveRoleWithIndexPos(pElement.indexPos);
        pElement:getReward()
    end

   GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
end


--普通怪战斗请求
function MapViewLogic:reqFightMonster(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end


--普通怪战斗请求返回
function MapViewLogic:rspFightMonster(date)

    local mapid         =   date.mapid;
    local uid           =   date.uid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;
    local seed          =   date.seed;
    local state         =   date.state
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;


    if self.pLayer == nil then
        return;
    end

    if ap ~=nil then 
        me:SetTeamHp(ap);
    end
  
    --建筑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:enemyFight(result);
    end

    --角色
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    --调用战斗函数
    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)
end


--未知建筑请求类型
function MapViewLogic:reqEnterUnkown(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

--未知建筑请求返回
function MapViewLogic:rspEnterUnkown(date)
    local resultID  =   date.randRet;       --类型，3--奖励，2--战斗
    local uid       =   date.uid;

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:unknowBuilding(resultID);
    end
end

--未知建筑请求领取奖励
function MapViewLogic:reqUnkownReward(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

--未知建筑请求奖励返回
function MapViewLogic:rspUnkownReward(date)
    local uid       =   date.uid;           --uid
    local mapid     =   date.mapid;         --地图id
    local reward  =    date.reward;      	--奖励id


    local tbCurrency, tbObjs = KGC_REWARD_MANAGER_TYPE:getInstance():AddReward(reward)


    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement~= nil then
        GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency, tbObjs}});
        pElement:getRewardWin(rewardid);
    end



    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)
end

--未知建筑请求打怪
function MapViewLogic:reqUnkownFight(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end


--未知建筑请求打怪返回
function MapViewLogic:rspUnkownFight(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;      -- 1--胜利  0--失败
    local seed          =   date.seed;
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;


    if self.pLayer == nil then 
        return;
    end

    --功能建筑本身逻辑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:enemyFight(result);
    end

    if ap ~=nil then 
        me:SetTeamHp(ap);
    end

    --角色逻辑
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)
end

--请求瞭望塔
function MapViewLogic:reqWatchTower(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end


--请求瞭望塔返回
function MapViewLogic:rspWatchTower(date)
    local mapid     =   date.mapid;
    local uid       =   date.uid
    local ok        =   date.ok     --0 成功 1--失败
        

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:watchView();
        local pArea={}                          --形象区域
        local square = pElement.pConfig.Square  --影响面积
        table.insert(pArea,pElement.indexPos)
     
        local itype = tonumber(pElement.pConfig.Direction)
        if itype == 0 then
            for i=0,square[1] do
                for j=0,square[2] do
                    local point01 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y+j)
                    local point02 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y-j)
                    local point03 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y+j)
                    local point04 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y-j)
                    table.insert(pArea,point01)
                    table.insert(pArea,point02)
                    table.insert(pArea,point03)
                    table.insert(pArea,point04)
                end
            end
        elseif itype == 1 then
            for i=0,square[1] do
                for j=0,square[2] do
                    local point01 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y+j)
                    local point02 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y-j)
                    table.insert(pArea,point01)
                    table.insert(pArea,point02)
                end 
            end 
        elseif itype == 2 then
            for i=0,square[1] do
                for j=0,square[2] do
                    local point01 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y+j)
                    local point02 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y-j)
                    table.insert(pArea,point01)
                    table.insert(pArea,point02)
                end
            end

        elseif itype == 3 then
            for i=0,square[1] do
                for j=0,square[2] do
                    local point01 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y-j)
                    local point02 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y-j)
                    table.insert(pArea,point01)
                    table.insert(pArea,point02)
                end
            end
        elseif itype == 4 then
            for i=0,square[1] do
                for j=0,square[2] do
                    local point01 = cc.p(pElement.indexPos.x+i,pElement.indexPos.y+j)
                    local point02 = cc.p(pElement.indexPos.x-i,pElement.indexPos.y+j)
                    table.insert(pArea,point01)
                    table.insert(pArea,point02)
                end
            end
        end

        for i,var in pairs(pArea) do
            self.pLayer:updateMaskLayer(var)
        end
    end
end

--请求获取buffer
function MapViewLogic:reqGetBuffer(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

--请求获取buffer返回
function MapViewLogic:rspGetBuffer(date)
    local mapid     =   date.mapid;
    local uid       =   date.uid
    local buffid    =   date.buffid

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:getBuffer();
        self.pLayer.role:addBuffer(buffid)

        --建筑上产生一个动画效果
        local imgRes;
        local function fun_playFinished(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                imgRes:removeFromParent();
            end
        end

		--test
		--test end
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_buff_01/effect_map_buff_01.ExportJson");
        imgRes = ccs.Armature:create("effect_map_buff_01")
        pElement:addChild(imgRes);
        imgRes:setAnchorPoint(cc.p(0.5,0))
        imgRes:getAnimation():setMovementEventCallFunc(fun_playFinished)
        imgRes:getAnimation():playWithIndex(0)

        --GUI层添加一个buffer
        self.pLayer.gui:addBuffer(buffid);
    end
end

--请求商店信息
function MapViewLogic:reqShopInfo(mapid,uid,nextstate,args)

    self:reqElementFunction(uid,nextstate,args)
end

--请求商店信息返回
function MapViewLogic:rspShopInfo(date)
    local mapid         =date.mapid
    local uid           =date.uid;
    local shopInfo      =date.shopInfo;

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:updateItem(shopInfo);
        local pDialog = MapViewDialogFunctionBuilding:create(pElement,self.pLayer.functionChooseLayer)
        self.pLayer.functionChooseLayer.dialogBoxNode:addChild(pDialog)
        pElement.pDalogiBox = pDialog;
    end
end

--请求购买商店物品
function MapViewLogic:reqBuyItem(mapid,uid,key)

    local fnCallBack = function(tbArg)
        self:rspBuyItem(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.mapid = mapid;
    tbReqArg.uid = uid;
    tbReqArg.key = key;
    g_Core.communicator.loc.mapBuy(tbReqArg,fnCallBack);

end

--请求购买商店物体返回
function MapViewLogic:rspBuyItem(date)
   local mapid  = date.mapid;
   local uid    = date.uid;
   local goodsid = tonumber(date.key);

   local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
   local itemID = pElement.itemID
   local iNum   = pElement.iNum;
   --存数据
   me:GetBag():AddItem(itemID,{num = iNum, id = itemID});
   --消耗金币
   local _groupFile =mconfig.loadConfig("script/cfg/exploration/common/sellgroup")
   local _itenNum=_groupFile[goodsid].Num
   local _price = _groupFile[goodsid].Price
   local _needGold = _itenNum*_price
   me:AddGold(_needGold*-1)
   
   --特效
   self.pLayer.role:addBuyItemEffect(itemID,iNum)

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement.functionBuilding();
        pElement:removeRes(goodsid)
        if pElement.pDalogiBox ~= nil then
            pElement.pDalogiBox:updateList();
        end
    end

end

---出口 战斗
function MapViewLogic:reqExitFight(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end
---出口 战斗
function MapViewLogic:rspExitFight(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;      -- 1--胜利  0--失败
    local seed          =   date.seed;
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;


    if self.pLayer == nil then 
        return;
    end
    
    --功能建筑本身逻辑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:enemyFight(result);
    end
    
    if ap ~=nil then 
        me:SetTeamHp(ap);
    end

    --角色逻辑
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    if result ==1 and pElement then
        self.pLayer.functionChooseLayer:addEnterFunction(pElement);
    end

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)
end


--请求出去
function MapViewLogic:reqExit(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

--请求出去返回 
function MapViewLogic:rspExit(date)
    local mapid = date.mapid;
    local uid   = date.uid;
    local state = date.state;
    local nextmap = date.nextmap;
    
    self:setMaxMap(nextmap);
    
    GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE);
    --MapViewLogic:getInstance():openMap(nextmap)

end

--请求使用工具
function MapViewLogic:reqUseTool(mapid,uid,nextstate,args)
     self:reqElementFunction(uid,nextstate,args)
end

--请求使用工具返回
function MapViewLogic:rspUseTool(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local ok            =   date.args.ok
    local costItem      =   date.args.costItem;

    if ok== 0 then 
        TipsViewLogic:getInstance():addMessageTips(12001);
    elseif ok == 1 then 
        --功能建筑本身逻辑
        local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
        if pElement then
            pElement:setBeRemoved();
        end

        --删除道具
        me.m_Bag:SubItem(tostring(costItem),1);
    end

end


--选择性奖励请求
function MapViewLogic:reqChooseReward(mapid,uid,nextstate,args)
     self:reqElementFunction(uid,nextstate,args)
end


--选择性奖励请求返回
function MapViewLogic:rspChooseReward(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local rewardIndex   =   date.index;
    local reward        =   date.reward;

    local bResult
    if reward == nil then 
        bResult = 1;            --失败
    else
        bResult = 0;            --成功
    end
   

    --功能建筑本身逻辑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:chooseReward(rewardIndex,bResult);
        pElement:getRewardItemIDWithIndex(rewardIndex);

        if bResult == 0 then 
            local tbCurrency, tbObjs = KGC_REWARD_MANAGER_TYPE:getInstance():AddReward(reward)

            GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency, tbObjs}});
        end

        if pElement:checkIsAbleRemove() then
            pElement:setBeRemoved()
        end
    end

end


--连续挑战怪请求
function MapViewLogic:reqConsecutiveFight(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

--连续挑战返回
function MapViewLogic:rspConsecutiveFight(date)
    local mapid         =   date.mapid;
    local uid           =   date.uid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;
    local seed          =   date.seed;
    local state         =   date.state
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;



    if self.pLayer == nil then 
        return;
    end

    if ap ~=nil then 
        me:SetTeamHp(ap);
    end

    --建筑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        if pElement.iState == 1 then 
            pElement:consecutiveFight(result);
            self.pLayer.functionChooseLayer:addNewDialogBoxNode(pElement:getEnterFunctionSub(self.pLayer.functionChooseLayer));         

        elseif pElement.iState==2 then 
            self.pLayer.functionChooseLayer.dialogBoxNode:removeAllChildren()
			--page@2015/11/18 修改打开奖励界面接口
            GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {1, reardTab})
        end
        
    end


    --角色
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    --调用战斗函数
    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)


end


--迁移永久挂机点
function MapViewLogic:reqUnlimitHookMove(mapid,uid,nextstate,args)
    self.lastHookPoint = me.m_map:GetFightPointID();
    self:reqElementFunction(uid,nextstate,args)
end


--迁移永久挂机点返回
function MapViewLogic:rspUnlimitHookMove(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local rewardIndex   =   date.index;

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:unlimitHookMove();
        self.pLayer.objectLayer:activeHookPoint(pElement.uid)
    end

    local newID = me.m_map:GetFightPointID();


    if newID~=nil then 
        if self.lastHookPoint==0 then 
            self.lastHookPoint=9006
        end
        local ptips = MapViewDialogChangeHookPoint:create(self.pLayer,self.lastHookPoint,newID);
        self.pLayer.functionChooseLayer:addChild(ptips);
        FightViewLogic:getInstance():ForceOver();  
    end

end

--挑战永久挂机怪
function MapViewLogic:reqUnlimitEnemyFight(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end


--挑战永久挂机怪返回
function MapViewLogic:rspUnlimitEnemyFight(date)
    local mapid         =   date.mapid;
    local uid           =   date.uid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;
    local seed          =   date.seed;
    local state         =   date.state
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;

    if self.pLayer == nil then 
        return;
    end

    if ap ~=nil then 
        me:SetTeamHp(ap);
    end

    --建筑
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
         pElement:unlimitEnemyFight();
    end


    --角色
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    --调用战斗函数
    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)

end


--迁移限时挂机点
function MapViewLogic:reqLimitHookMove(mapid,uid,nextstate,args)
    self.lastHookPoint = me.m_map:GetFightPointID();
    self:reqElementFunction(uid,nextstate,args)
end


--迁移限时挂机点返回
function MapViewLogic:rspLimitHookMove(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local rewardIndex   =   date.index;


    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:limitHookMove();
        self.pLayer.objectLayer:activeHookPoint(pElement.uid)
    end

    local newID = me.m_map:GetFightPointID();
    if newID~=nil then 
        if self.lastHookPoint==0 then 
            self.lastHookPoint=9006
        end
        local ptips = MapViewDialogChangeHookPoint:create(self.pLayer,self.lastHookPoint,newID);
        self.pLayer.functionChooseLayer:addChild(ptips); 
        FightViewLogic:getInstance():ForceOver(); 
    end

end


--挑战限时挂机怪
function MapViewLogic:reqLimitEnemyFight(mapid,uid,nextstate,args)
     self:reqElementFunction(uid,nextstate,args)
end

--迁移限时挂机怪
function MapViewLogic:rspLimitEnemyFight(date)
    local mapid         =   date.mapid;
    local uid           =   date.uid;
    local monsterid     =   date.monsterid;
    local rewardid      =   date.rewardid;
    local result        =   date.result;
    local seed          =   date.seed;
    local state         =   date.state
    local pointx        =   date.x;
    local pointy        =   date.y;
    local ap            =   date.ap;
    local cost          =   date.cost;
    local bagAdd        =   date.bagAdd;

    local reardTab ={};
    reardTab.rewardid =rewardid;
    reardTab.cost = cost;
    reardTab.bagAdd = bagAdd;



    if self.pLayer == nil then 
        return;
    end

    if ap ~=nil then 
        me:SetTeamHp(ap);
    end

    local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
    if pElement then
        pElement:limitEnemyFight();
    end

     --角色
    if pointy~= nil and pointx ~=nil then
        self.pLayer:moveRoleWithIndexPos(cc.p(pointx,pointy))
    end

    --调用战斗函数
    FightViewLogic:getInstance():StartFightWithMonster(seed, monsterid, result, reardTab)

    --界面更新
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_PROPERTY)

end


--请求补给
function MapViewLogic:reqSupply(mapid,uid,nextstate,args)
   self:reqElementFunction(uid,nextstate,args)
end

--请求补给返回
function MapViewLogic:rspSupply(date)
    local uid           =   date.uid;
    local mapid         =   date.mapid;
    local ap            =   date.ap;
    local condition     =   date.condition;
    local ok            =   date.ok;
    me:SetTeamHp(ap);
    if ok==1 then   --返回1证明成功
        local pElement = self.pLayer.objectLayer:getObjectWihtUID(uid);
        if pElement then
            pElement:supply();
        end
        self.pLayer.ObjectMaskLayer:addSupply(pElement.pValue)
    end

    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
end

--请求NPC对话
function MapViewLogic:reqNPC(mapid,uid,nextstate,args)
    self:reqElementFunction(uid,nextstate,args)
end

function MapViewLogic:rspNPC(date)
    local pElement = self.pLayer.objectLayer:getObjectWihtUID(date.uid);
    if pElement ~=nil then 
        local pDialog = MapViewNPCDialog:create(self.pLayer.functionChooseLayer,pElement);
        self.pLayer.functionChooseLayer:addNewDialogBoxNode(pDialog);
    end
end


------------------------------------------------------------------------------

function MapViewLogic:reqElementFunction(uid,state,args)
    local fnCallBack = function(tbArg)
        self:rspElementFunction(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.nodeid = self.currentNodeID;
    tbReqArg.uid = uid;
    tbReqArg.nextstate = state;
    tbReqArg.args = args or {};

    g_Core.communicator.loc.changeState(tbReqArg,fnCallBack);

end

function MapViewLogic:rspElementFunction(pDate)
    local nodeid = pDate.nodeid;
    local uid   = pDate.uid;
    local state = pDate.state;
    local args  = pDate.args
    local mapid =nil;

    local process = args.process;   --探索度
    self.currentProcess = process;
    self.pLayer.gui:setProcess(process);

    local pass = args.pass;         --下一部分节点是否打开
    if pass~=nil and pass== true then 
        --打开下一章节
        me:GetMapInfo():setNodeFinish(nodeid);
        self.pLayer.gui:setOverPanel(true);
    end


    --前置条件
    --没有前置条件限制的话就为nil
    --[[
      condition = {
            pass = {[1] = 10, [2] = 3000, [3] = 1}
            unpass = {[1] = 10}
            }
    ]]--
    local condition  = args.condition;


    --界面已销毁
    if self.pLayer==nil then
        return;
    end

    --前置条件
    if condition~=nil then
        if condition.unpass~= nil then 
            for k,v in pairs(condition.unpass) do
                local iType = tonumber(k);
                local iNum = tonumber(v);
                if iType ==1  then
                    TipsViewLogic:getInstance():addMessageTips(11011);
                elseif iType ==2 then 
                    TipsViewLogic:getInstance():addMessageTips(11012);
                elseif iType ==3 then
                    local sInfo =stringFile[11013]..signFile[iNum].Name
                    TipsViewLogic:getInstance():addMessageTips(sInfo);
                end
            end
            return;
        end
    end

    --找不到物体
    local pObj = self.pLayer.objectLayer:getObjectWihtUID(uid)
    local itype = -1;
    if pObj~= nil then 
        pObj:setState(state);            --状态
        itype = pObj.subType    --类型
    else
        return;
    end

    --根据类型分发功能
    if itype == MapViewElementBase.TYPE_BUILDING_SUPPLY then          --补给建筑
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;
        date.ap             =   args.ap;
        date.condition      =   args.condition;
        date.ok             =   args.ok;

        self:rspSupply(date)

    elseif itype == MapViewElementBase.TYPE_BUILDING_BUFF then        --buff点
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;  
        date.buffid     = args.buffid;

        self:rspGetBuffer(date)

    elseif itype == MapViewElementBase.TYPE_BUILDING_STATION then     --交通站

    elseif itype == MapViewElementBase.TYPE_BUILDING_INTE then        --情报站

    elseif itype == MapViewElementBase.TYPE_BUILDING_SHOP then        --商店
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;  
        date.shopInfo   = args.shopInfo;
        self:rspShopInfo(date)

    elseif itype == MapViewElementBase.TYPE_BUILDING_WATCHTOWER then  --瞭望塔
        local date={};
        date.mapid          = mapid;
        date.uid            = uid;
        date.ok             = args.ok     --0 成功 1--失败

        self:rspWatchTower(date);

    elseif itype == MapViewElementBase.TYPE_RES_NORMAL then           --普通资源
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;  
        date.state      = state;
        date.reward   = args.reward;

        self:rspGetChest(date);

    elseif itype == MapViewElementBase.TYPE_RES_CHOOSE then           --选择性资源
        local date={};
        date.mapid          = mapid;
        date.uid            = uid;  
        date.state          = state;
        date.index     = args.choo;
        date.reward    = args.reward;

        self:rspChooseReward(date);

    elseif itype == MapViewElementBase.TYPE_HOOK_NORMAL then          --普通挂机点

        if args.curAfker ~=nil then --挂机点改变了
            me.m_map.afkObj = args.curAfker;
        end

        local date={};
        if args.monsterid==nil then         --挂机返回
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;
            self:rspUnlimitHookMove(date);
        else                                --挂机怪返回
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;
            date.monsterid      = args.monsterid;
            date.rewardid       = args.rewardid; 
            date.result         = args.result; 
            date.seed           = args.seed;
            date.x              = args.x;
            date.y              = args.y;
            date.ap             = args.ap;
            date.cost           = args.cost;
            date.bagAdd         = args.bagAdd;


            self:rspUnlimitEnemyFight(date);
        end


    elseif itype == MapViewElementBase.TYPE_HOOK_LIMIT then           --限制挂机点

        if args.curAfker ~=nil then --挂机点改变了
            me.m_map.afkObj = args.curAfker;
        end

        local date={};
        date.mapid          = mapid;
        date.uid            = uid;  
        date.state          = state;

        self:rspLimitHookMove(date);
    elseif itype == MapViewElementBase.TYPE_HOOK_AtONCE then          --限时挂机点（立即)

        if args.curAfker ~=nil then --挂机点改变了
            me.m_map.afkObj = args.curAfker;
        end

        local date={};
        if args.monsterid==nil then           --挂机返回
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;

            self:rspLimitHookMove(date);
        else                                 --挂机怪返回
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;
            date.monsterid      = args.monsterid;
            date.rewardid       = args.rewardid; 
            date.result         = args.result; 
            date.seed           = args.seed;
            date.x              = args.x;
            date.y              = args.y;
            date.ap             = args.ap;
            date.cost           = args.cost;
            date.bagAdd         = args.bagAdd;

            self:rspLimitEnemyFight(date);
        end

    elseif itype == MapViewElementBase.TYPE_ENEMY_NORMAL then         --普通怪
        local date={};
        date.mapid          = mapid;
        date.uid            = uid;
        date.state          = state;
        date.monsterid      = args.monsterid;
        date.rewardid       = args.rewardid; 
        date.result         = args.result; 
        date.seed           = args.seed;
        date.x              = args.x;
        date.y              = args.y;
        date.ap             = args.ap;
        date.cost           = args.cost;
        date.bagAdd         = args.bagAdd;

        self:rspFightMonster(date);

    elseif itype == MapViewElementBase.TYPE_ENEMY_CHOOSE then         --选择性挑战怪


    elseif itype == MapViewElementBase.TYPE_ENEMY_CONTINUOUS then     --连续挑战
        local date={};
        date.mapid          = mapid;
        date.uid            = uid;
        date.state          = state;
        date.monsterid      = args.monsterid;
        date.rewardid       = args.rewardid; 
        date.result         = args.result; 
        date.seed           = args.seed;
        date.x              = args.x;
        date.y              = args.y;
        date.ap             = args.ap;
        date.cost           = args.cost;
        date.bagAdd         = args.bagAdd;

        self:rspConsecutiveFight(date);

    elseif itype == MapViewElementBase.TYPE_ENEMY_UNKNOWN then        --未知怪
        if pObj.iType == 0 then 
            --证明没有探明
            local date={};
            date.mapid          = mapid;
            date.uid            = uid; 
            date.randRet        = args.randRet
            self:rspEnterUnkown(date);
        elseif pObj.iType == 3 then 
            --探明是奖励
            local date={};
            date.mapid          = mapid;
            date.uid            = uid;
            date.reward       = args.rewardid;

            self:rspUnkownReward(date);
        elseif pObj.iType == 2 then 
            --探明是怪
            local date={};
            date.mapid          = mapid;
            date.uid            = uid;
            date.monsterid      = args.monsterid;
            date.rewardid       = args.rewardid; 
            date.result         = args.result; 
            date.seed           = args.seed;
            date.x              = args.x;
            date.y              = args.y;
            date.ap             = args.ap;
            date.bagAdd         = args.bagAdd;
            date.cost           = args.cost;

            self:rspUnkownFight(date);
        end


    elseif itype == MapViewElementBase.TYPE_ENEMY_EXIT then           --出口怪

        if pObj.isEnemyClean ==false then
            local date={};
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;
            date.monsterid      = args.monsterid;
            date.rewardid       = args.rewardid; 
            date.result         = args.result; 
            date.seed           = args.seed;
            date.x              = args.x;
            date.y              = args.y;
            date.ap             = args.ap;
            date.cost           = args.cost;
            date.bagAdd         = args.bagAdd;

            self:rspExitFight(date);

        else
            local date={};
            date.mapid          = mapid;
            date.uid            = uid;
            date.state          = state;
            date.nextmap        = args.nextmap;
            self:rspExit(date);
        end


    elseif itype == MapViewElementBase.TYPE_PORTAL_NORMAL then        --传送门


    elseif itype == MapViewElementBase.TYPE_MAILBOX then              --邮筒


    elseif itype ==MapViewElementBase.TYPE_MARSH then                 --沼泽


    elseif itype ==MapViewElementBase.TYPE_WIND then                  --大风


    elseif itype ==MapViewElementBase.TYPE_OBSTACLE_REMOVE then       --可移除障碍
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;
        date.state      = state;
        date.args       = args;

        self:rspUseTool(date);

    elseif itype ==MapViewElementBase.TYPE_OBSTACLE_UNREMOVE then     --不可移除障碍


    elseif itype == MapViewElementBase.TYPE_NPC then                    --NPC
        local date={};
        date.mapid      = mapid;
        date.uid        = uid;
        date.state      = state;
        date.args       = args;
            
        self:rspNPC(date);
    end


    pObj:updateFuncitonWithState();  --功能更新


    self:apZeroMove(args.bChange);
end


--团队体力为0
function MapViewLogic:apZeroMove(bChange)
    if bChange~=1 then 
        return;
    end
    if self.pLayer==nil then
        return;
    end

    local dialogLayer = MVEIL_SmipleDialog:create(self.pLayer.functionChooseLayer,nil)
    dialogLayer:setTextInfo(stringFile[13006]);
    dialogLayer:setButton(nil,"确定");
    self.pLayer.functionChooseLayer:addNewDialogBoxNode(dialogLayer);
    self.pLayer:moveCameraForRoleToScreenCenter();

end

function MapViewLogic:ShowMenuBg()
    if self.pLayer then
        self.pLayer:SetMenuBgVisible(true);
    end
end

function MapViewLogic:HideMenuBg()
    if self.pLayer then
        self.pLayer:SetMenuBgVisible(false);
    end
end




function MapViewLogic:removeTexture()
    -- local animTab={"res/ANI/effect/effect_building_01_01/effect_building_01_01.ExportJson",
    --                 "res/ANI/effect/effect_building_01_02/effect_building_01_02.ExportJson",
    --                 "res/ANI/effect/effect_building_01_03/effect_building_01_03.ExportJson",
    --                 "res/ANI/effect/effect_building_01_04/effect_building_01_04.ExportJson",
    --                 "res/ANI/effect/effect_building_02_01/effect_building_02_01.ExportJson",
    --                 "res/ANI/effect/effect_building_02_02/effect_building_02_02.ExportJson",
    --                 "res/ANI/effect/effect_building_02_03/effect_building_02_03.ExportJson",
    --                 "res/ANI/effect/effect_building_02_05/effect_building_02_05.ExportJson",
    --             "res/ANI/effect/effect_building_03_01/effect_building_03_01.ExportJson",
    --             "res/ANI/effect/effect_building_03_02/effect_building_03_02.ExportJson",
    --             "res/ANI/effect/effect_building_03_03/effect_building_03_03.ExportJson",
    --             "res/ANI/effect/effect_building_03_04/effect_building_03_04.ExportJson",
    --             "res/ANI/effect/effect_building_03_05/effect_building_03_05.ExportJson",                                
    --             "res/ANI/effect/effect_building_03_06/effect_building_03_06.ExportJson",
    --             "res/ANI/effect/effect_building_03_07/effect_building_03_07.ExportJson",
    --             "res/ANI/effect/effect_building_03_08/effect_building_03_08.ExportJson",
    --             "res/ANI/effect/effect_building_03_09/effect_building_03_09.ExportJson",

    --             "res/ANI/effect/effect_building_rewardbox_01/effect_building_rewardbox_01.ExportJson",
    --             "res/ANI/effect/effect_building_rewardbox_02/effect_building_rewardbox_02.ExportJson",
    --             "res/ANI/effect/effect_building_rewardbox_03/effect_building_rewardbox_03.ExportJson",
    --             "res/ANI/effect/effect_building_rewardbox_04/effect_building_rewardbox_04.ExportJson",
    --             "res/ANI/effect/effect_building_rewardbox_05/effect_building_rewardbox_05.ExportJson",

    --             "res/ANI/effect/effect_map_buff_01/effect_map_buff_01.ExportJson",
    --             "res/ANI/effect/effect_map_buff_02/effect_map_buff_02.ExportJson",
    --             "res/ANI/effect/effect_map_buff_03/effect_map_buff_03.ExportJson",
    --             "res/ANI/effect/effect_map_buff_04/effect_map_buff_04.ExportJson",
    --             "res/ANI/effect/effect_map_grid_01/effect_map_grid_01.ExportJson",
    --             "res/ANI/effect/effect_map_guaji_01/effect_map_guaji_01.ExportJson",
    --             "res/ANI/effect/effect_map_hangup_01/effect_map_hangup_01.ExportJson",
    --             "res/ANI/effect/effect_map_hangup_02/effect_map_hangup_02.ExportJson",
    --             "res/ANI/effect/effect_map_npc_01/effect_map_npc_01.ExportJson",
    --             "res/ANI/effect/effect_map_portal_01/effect_map_portal_01.ExportJson",
    --             "res/ANI/effect/effect_map_portal_02/effect_map_portal_02.ExportJson",
    --             "res/ANI/effect/effect_map_swamp_02/effect_map_swamp_02.ExportJson",
    -- }


    -- local texturTab={"res/ANI/effect/effect_building_01_01/effect_building_01_010.png",
    --                 "res/ANI/effect/effect_building_01_02/effect_building_01_020.png",
    --                 "res/ANI/effect/effect_building_01_03/effect_building_01_030.png",
    --                 "res/ANI/effect/effect_building_01_04/effect_building_01_040.png",
    --                 "res/ANI/effect/effect_building_01_04/effect_building_01_041.png",
    --                 "res/ANI/effect/effect_building_02_01/effect_building_02_010.png",
    --                 "res/ANI/effect/effect_building_02_02/effect_building_02_020.png",
    --                 "res/ANI/effect/effect_building_02_02/effect_building_02_021.png",

    --                 "res/ANI/effect/effect_building_02_03/effect_building_02_030.png",
    --                 "res/ANI/effect/effect_building_02_03/effect_building_02_031.png",
    --                 "res/ANI/effect/effect_building_02_03/effect_building_02_032.png",

    --                 "res/ANI/effect/effect_building_02_05/effect_building_02_050.png",

    --             "res/ANI/effect/effect_building_03_01/effect_building_03_010.png",
    --             "res/ANI/effect/effect_building_03_02/effect_building_03_020.png",
    --             "res/ANI/effect/effect_building_03_02/effect_building_03_021.png",

    --             "res/ANI/effect/effect_building_03_03/effect_building_03_030.png",
    --             "res/ANI/effect/effect_building_03_03/effect_building_03_031.png",

    --             "res/ANI/effect/effect_building_03_04/effect_building_03_040.png",
    --             "res/ANI/effect/effect_building_03_04/effect_building_03_041.png",

    --             "res/ANI/effect/effect_building_03_05/effect_building_03_050.png",

    --             "res/ANI/effect/effect_building_03_06/effect_building_03_060.png",
    --             "res/ANI/effect/effect_building_03_06/effect_building_03_061.png",

    --             "res/ANI/effect/effect_building_03_07/effect_building_03_070.png",
    --             "res/ANI/effect/effect_building_03_07/effect_building_03_071.png",

    --             "res/ANI/effect/effect_building_03_08/effect_building_03_080.png",
    --             "res/ANI/effect/effect_building_03_08/effect_building_03_081.png",

    --             "res/ANI/effect/effect_building_03_09/effect_building_03_090.png",

    --             "res/ANI/effect/effect_building_rewardbox_01/effect_building_rewardbox_010.png",
    --             "res/ANI/effect/effect_building_rewardbox_02/effect_building_rewardbox_020.png",
    --             "res/ANI/effect/effect_building_rewardbox_03/effect_building_rewardbox_030.png",
    --             "res/ANI/effect/effect_building_rewardbox_03/effect_building_rewardbox_031.png",
    --             "res/ANI/effect/effect_building_rewardbox_04/effect_building_rewardbox_040.png",
    --             "res/ANI/effect/effect_building_rewardbox_05/effect_building_rewardbox_050.png",


    --             "res/ANI/effect/effect_map_buff_01/effect_map_buff_010.png",
    --             "res/ANI/effect/effect_map_buff_02/effect_map_buff_020.png",
    --             "res/ANI/effect/effect_map_buff_02/effect_map_buff_021.png",

    --             "res/ANI/effect/effect_map_buff_03/effect_map_buff_030.png",
    --             "res/ANI/effect/effect_map_buff_04/effect_map_buff_040.png",
    --             "res/ANI/effect/effect_map_buff_04/effect_map_buff_041.png",

    --             "res/ANI/effect/effect_map_grid_01/effect_map_grid_010.png",


    --             "res/ANI/effect/effect_map_guaji_01/effect_map_guaji_010.png",
    --             "res/ANI/effect/effect_map_guaji_01/effect_map_guaji_011.png",

    --             "res/ANI/effect/effect_map_hangup_01/effect_map_hangup_010.png",
    --             "res/ANI/effect/effect_map_hangup_01/effect_map_hangup_011.png",

    --             "res/ANI/effect/effect_map_hangup_02/effect_map_hangup_020.png",
    --             "res/ANI/effect/effect_map_hangup_02/effect_map_hangup_021.png",

    --             "res/ANI/effect/effect_map_npc_01/effect_map_npc_010.png",

    --             "res/ANI/effect/effect_map_portal_01/effect_map_portal_010.png",
    --             "res/ANI/effect/effect_map_portal_01/effect_map_portal_011.png",

    --             "res/ANI/effect/effect_map_portal_02/effect_map_portal_020.png",
    --             "res/ANI/effect/effect_map_portal_02/effect_map_portal_021.png",

    --             "res/ANI/effect/effect_map_swamp_02/effect_map_swamp_020.png",
    --         }


    --         fun_removeAnimationCache(animTab);
    --         fun_removeTextureAndFrameCache(texturTab); 


end