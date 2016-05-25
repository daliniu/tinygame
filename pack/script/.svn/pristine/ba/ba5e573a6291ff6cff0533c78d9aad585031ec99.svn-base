require("script/ui/mapchooseview/mapchooselayer");
require("script/ui/mapview/dialogBox/mapViewDialogTips");

local l_tbUIUpdateType = def_GetUIUpdateTypeData();
local MAP_CHOOSE_LOGIC_TB={
    currentMapType = 1;
}

local worldmapConfigFile = mconfig.loadConfig("script/cfg/map/worldmap")

MapChooseLogic = class("MapChooseLogic", KGC_UI_BASE_LOGIC,MAP_CHOOSE_LOGIC_TB);

MapChooseLogic.MAP_TYPE_NORAML = 1; --普通类型;
MapChooseLogic.MAP_TYPE_ELITE  = 2; --精英

function MapChooseLogic:getInstance()
    if MapChooseLogic.m_pLogic == nil then
        MapChooseLogic.m_pLogic = MapChooseLogic:create()
        GameSceneManager:getInstance():insertLogic(MapChooseLogic.m_pLogic)
    end
	
    return MapChooseLogic.m_pLogic
end

function MapChooseLogic:create()
    local _logic = MapChooseLogic.new()
    _logic:Init()
    return _logic
end

function MapChooseLogic:Init()
    currentMapType = MapChooseLogic.MAP_TYPE_NORAM;     --默认普通类型
end

function MapChooseLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = MapChooseLayer:create();
    self.m_pLayer.id = id;
    self.m_pLayer.flag = true
    parent:addChild(self.m_pLayer)

    -- 设置主界面底部按钮底框可见
    KGC_MainViewLogic:getInstance():ShowMenuBg();
    MapViewLogic:getInstance():ShowMenuBg();
    FightViewLogic:getInstance():SetPlayerInfoVisible(true);
end



function MapChooseLogic:closeLayer()
	if self.m_pLayer then
		local nID = self.m_pLayer.id
		self.m_pLayer:closeLayer();
		self.m_pLayer = nil;
	end

    -- 设置主界面底部按钮底框不可见
    KGC_MainViewLogic:getInstance():HideMenuBg();
    MapViewLogic:getInstance():HideMenuBg();
    FightViewLogic:getInstance():SetPlayerInfoVisible(false);
end

function MapChooseLogic:OnUpdateLayer(iType)
	if self.m_pLayer ==nil then 
		return;
	end

	-- if iType == l_tbUIUpdateType.EU_AFKERREWARD then
	-- 	if self.m_pLayer.m_pMainBtnLayer then
	-- 		local nPercent = (tbArg or {})[1] or 0;
	-- 		self.m_pLayer.m_pMainBtnLayer:SetRewardProg ress(0, nPercent);
	-- 	end
	-- end
end


function MapChooseLogic:openMapChoose()
    self:reqMapInfo();
    
end

-----------------===============================----------------协议

--请求地图信息
function MapChooseLogic:reqMapInfo()
    local fnCallBack = function(tbArg)
        self:rspMapInfo(tbArg);
    end
    
    g_Core.communicator.loc.getGlobalMapInfo(fnCallBack);
end


--请求地图信息返回
function MapChooseLogic:rspMapInfo(info)
--[[--
    [curNode] = 123 // 当前节点id
    [openNode] = {
        [123] = {
            [process] = 98,     // 当前节点进度
            [compAward] = 0,    // 节点通关宝箱是否领取 0--没有领，1--领了
        }
    }
    [timeNode] = {
        [234] = 100,剩余时间(s)
    }
--]]--


    me:GetMapInfo():SetCurrentNoramlNodeID(info.curNode);       --当前所在的节点
    me:GetMapInfo():SetNoramlOpenNode(info.openNode);
    me:GetMapInfo():SetTimeingNormalNode(info.timeNode);
    
    GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE)
end


---=================================================================
--请求进入地图
function MapChooseLogic:reqEnterMap(id)
    local fnCallBack = function(tbArg)
        self:rspEnterMap(tbArg,id);
    end
    local tbReqArg = {};
    tbReqArg.nodeid = id;
    g_Core.communicator.loc.enterMap(tbReqArg,fnCallBack);    
end

--请求进入地图返回
function MapChooseLogic:rspEnterMap(info,id)
--[[
    [x] = 3,
    [y] = 6,
    [uidlist] = {
        [12334] = 3,
    }
    buff = {
        [213] = 23,
    }
    ap = 10,      
    sign = {
        [234] = 1,
    }
]]--


    self:closeLayer();
    MapViewLogic:getInstance():openMap(id,info);

end

---=================================================================
---请求挂机点
function MapChooseLogic:reqEnterAFK(id)
    local fnCallBack = function(tbArg)
        self:rspEnterAFK(id);
    end
    
    self.lastHookPoint = me.m_map:GetFightPointID();

    local tbReqArg = {};
    tbReqArg.nodeid = id;
    g_Core.communicator.loc.changeAfk(tbReqArg,fnCallBack);  
end

--请求挂机点返回
function MapChooseLogic:rspEnterAFK(id)
    me:GetMapInfo():setNodeFinish(id);


    if self.m_pLayer~=nil then
        self.m_pLayer:updateInfo();
    end

    local newID = worldmapConfigFile[id].ResourceID;

    if self.lastHookPoint == newID then 
        return;
    end

     me.m_map:SetFightPointID(tonumber(newID));
    if newID~=nil then 
        if self.lastHookPoint==0 or self.lastHookPoint==nil then 
            self.lastHookPoint=9006
        end

        local ptips = MapViewDialogChangeHookPoint:create(self.m_pLayer,self.lastHookPoint,newID);
        self.m_pLayer:addChild(ptips);
        FightViewLogic:getInstance():ForceOver();
    end

end