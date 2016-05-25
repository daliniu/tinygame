require("script/lib/definefunctions")
require("script/ui/openview/OpenViewLogic")
require("script/ui/mainview/MainViewLogic")
require("script/ui/functionchooseview/FunctionChooseLogic")
require("script/ui/herolistview/herolistlogic")
require("script/ui/fightview/fightlogic");
require("script/ui/loginview/loginlogic");
require("script/ui/mapview/MapViewLogic")
require("script/ui/networkview/NetworkLogic")
require("script/ui/bagview/bagviewlogic")
require("script/ui/tipsview/tipsviewlogic")
require("script/ui/itemcomview/itemcomlogic")
require("script/ui/forgingview/forginglogic")
require("script/ui/statisticsview/statisticslogic")
require("script/ui/upgradeview/upgradelogic")
require("script/ui/progressview/progresslogic")
require("script/ui/chatview/chatlogic")
require("script/ui/rewardview/rewardlogic")
require("script/ui/announcementview/announcementlogic");
require("script/ui/emailview/emaillogic");
require("script/ui/missionview/missionlogic");
require("script/ui/handbookview/handbooklogic");
require("script/ui/heroshopview/heroshoplogic");
require("script/ui/heroshopview/heroshoplogic");
require("script/ui/annountimelyview/annountimelylogic")
require("script/ui/mapchooseview/mapchooselogic");
require("script/audio/audiomanager");
require("script/userguide/userguidelogic")
require("script/core/systemopen/systemopen");
require("script/ui/bulletview/bulletlogic");
require("script/ui/arenaview/arenalogic");
require("script/ui/arenaview/normalview/normallogic");
require("script/ui/arenaview/arena_fightview/arena_fightlogic");
require("script/ui/lineupview/lineuplogic");

local GAME_SCENE_MANAGER_TB={
    currentLayerIndex = nil,
    lastLayerIndex =nil,
}


GameSceneManager = class("GameSceneManager",GAME_SCENE_MANAGER_TB)

GameSceneManager.pGameSceneManager =nil

GameSceneManager.LAYER_ID_OPEN              =   1       --开始界面
GameSceneManager.LAYER_ID_MAIN              =   2       --主界面
GameSceneManager.LAYER_ID_FUNCTIONCHOOSE    =   3       --功能选择界面
GameSceneManager.LAYER_ID_HEROINFO          =   4       --角色信息界面
GameSceneManager.LAYER_ID_EXPLORE           =   5       --探索界面
GameSceneManager.LAYER_ID_FIGHT             =   6       --战斗界面
GameSceneManager.LAYER_ID_MAP               =   7       --地图界面
GameSceneManager.LAYER_ID_LINEUP            =   8       --布阵界面
GameSceneManager.LAYER_ID_LOGIN            	=   9       --登录界面
GameSceneManager.LAYER_ID_NETWORK           =   10      --网络断线对话框
GameSceneManager.LAYER_ID_UPDATE            =   11      --更新界面
GameSceneManager.LAYER_ID_BAG        	    =   12      --背包界面
GameSceneManager.LAYER_ID_ITEMCOM           =   13      --合成界面
GameSceneManager.LAYER_ID_FORGING           =   14      --锻造界面
GameSceneManager.LAYER_ID_AFK_STATISTICS    =   15      --挂机统计界面
GameSceneManager.LAYER_ID_UPGRADE   		=   16      --队伍升级界面
GameSceneManager.LAYER_ID_PROGRESS   		=   17      --进度条过度界面
GameSceneManager.LAYER_ID_CHAT		   		=   18      --聊天界面
GameSceneManager.LAYER_ID_REWARD		   	=   19      --通关奖励界面
GameSceneManager.LAYER_ID_ANNOUNCEMENT      =   20      --公告界面
GameSceneManager.LAYER_ID_EMAIL             =   21      --邮件界面
GameSceneManager.LAYER_ID_MISSION           =   22      --任务面板
GameSceneManager.LAYER_ID_HANDBOOK          =   23      --图鉴面板
GameSceneManager.LAYER_ID_HEROSHOP          =   24      --英雄商店面板
GameSceneManager.LAYER_ID_MAPCHOOSE         =   25      --地图选择界面
GameSceneManager.LAYER_ID_PVP_ARENA         =   26      --竞技场主面板
GameSceneManager.LAYER_ID_PVP_ARENA_NORMAL  =   27      --竞技场日竞技赛战斗面板
GameSceneManager.LAYER_ID_PVP_ARENA_FIGHT	=   28      --竞技场敌我对战面板


function GameSceneManager:create()
    local scene = GameSceneManager:new()
    return scene
end


--单例
function GameSceneManager:getInstance()
    if GameSceneManager.pGameSceneManager==nil then
       GameSceneManager.pGameSceneManager=GameSceneManager:create()
    end
    return GameSceneManager.pGameSceneManager
end


function GameSceneManager:createScene()
	local fnSceneEvent = function(tag)
		if tag == "exit" then
			g_Core:closeNetwork();
		end
	end

   local _scene=cc.Scene:create()
   GameSceneManager:getInstance():initAttr(_scene)

   _scene:registerScriptHandler(fnSceneEvent)
   return _scene
end

function GameSceneManager:initAttr(_scene)

    --逻辑类
    self.logicArray={};
	self.m_tbLogicHash = {};

    --普通界面层控制节点
    self.pLayer=cc.Node:create();
    self.pLayer:setLocalZOrder(1);
    _scene:addChild(self.pLayer);

    --玩家引导层
    self.userGuideNode = cc.Node:create();
    self.userGuideNode:setLocalZOrder(1);
    _scene:addChild(self.userGuideNode);

    --提示消息控制节点
    self.tipsNode = cc.Node:create();
    self.tipsNode:setLocalZOrder(2);
    _scene:addChild(self.tipsNode);

    --公告控制节点
    self.annouNode = cc.Node:create();
    self.annouNode:setLocalZOrder(3);
    _scene:addChild(self.annouNode);

    --弹幕层
    self.bulletNode = cc.Node:create();
    self.bulletNode:setLocalZOrder(4);
    _scene:addChild(self.bulletNode);

    --网络界面控制节点
    self.pNet=cc.Node:create();
    self.pNet:setLocalZOrder(5);
    _scene:addChild(self.pNet)

    self:initControlLayer();

	-- 永不关闭界面管理
	self.m_nLastFID = GameSceneManager.LAYER_ID_MAIN;	-- 保存上一个永不关闭的界面ID;
	self.m_nCurFID = GameSceneManager.LAYER_ID_MAIN;	-- 保存当前永不关闭的界面


	--test
	local onKeyPressed = function(keyCode, event)
		-- self:TestProcessKeyEvent(keyCode, event);
	end
	local listener = cc.EventListenerKeyboard:create();
	listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self.pLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.pLayer);
	--test end
end


function GameSceneManager:initControlLayer()
    NetworkLogic:getInstance():initLayer(self.pNet, id)         --网络层界面
    TipsViewLogic:getInstance():initLayer(self.tipsNode);       --信息提示层
    AnnounTimelyLogic:getInstance():initLayer(self.annouNode)   --及时公告层
    BulletLogic:getInstance():initLayer(self.bulletNode);       --弹幕层


    self:addLayer(GameSceneManager.LAYER_ID_OPEN,0)             ---普通界面


end



--[[=============================层控制==================================]]--

--增加层
function GameSceneManager:addLayer(id,parameters)
	local logic = nil;
    if id==GameSceneManager.LAYER_ID_OPEN then						--开始
		logic = OpenViewLogic:getInstance();
    elseif id==GameSceneManager.LAYER_ID_MAIN then					--主界面
		logic = KGC_MainViewLogic:getInstance();
    elseif id==GameSceneManager.LAYER_ID_FUNCTIONCHOOSE then		--功能选择界面
		logic = FunctionChooseLogic:getInstance();
    elseif id==GameSceneManager.LAYER_ID_HEROINFO then				--角色选择界面
		logic = KGC_HERO_LIST_LOGIC_TYPE:getInstance();
    elseif id==GameSceneManager.LAYER_ID_EXPLORE then				--世界探索界面
    elseif id==GameSceneManager.LAYER_ID_FIGHT then					--战斗界面
		logic = FightViewLogic:getInstance();
    elseif id==GameSceneManager.LAYER_ID_MAP then					--地图界面
		logic = MapViewLogic:getInstance();
	elseif id == GameSceneManager.LAYER_ID_LINEUP then				--布阵界面
		logic = KGC_LINEUP_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_LOGIN then				--登录界面
		logic = LoginViewLogic:getInstance();
    elseif id == GameSceneManager.LAYER_ID_UPDATE then              --更新界面
		logic = UpdateViewLogic:getInstance();
	elseif id == GameSceneManager.LAYER_ID_BAG then					--背包
		logic = KGC_BagViewLogic:getInstance();
    elseif id == GameSceneManager.LAYER_ID_ITEMCOM then             --道具合成
		logic = ItemComLogic:getInstance();
    elseif id == GameSceneManager.LAYER_ID_FORGING   then           --锻造界面
		logic = ForgingLogic:getInstance();
	elseif id == GameSceneManager.LAYER_ID_AFK_STATISTICS   then    --挂机统计界面
		logic = KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_UPGRADE   then    		--队伍升级界面
		logic = KGC_UPGRADE_VIEW_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_PROGRESS   then    		--进度条过度界面
		logic = KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_CHAT   then    			--聊天界面
		logic = KGC_CHAT_VIEW_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_REWARD   then    		--通关奖励界面
		logic = KGC_REWARD_LAYER_LOGIC_TYPE:getInstance();
    elseif id ==GameSceneManager.LAYER_ID_EMAIL then                --邮件界面
		logic = EmailLogic:getInstance();
    elseif id == GameSceneManager.LAYER_ID_MISSION then             --任务面板
		logic = MissionLogic:getInstance();
	elseif id == GameSceneManager.LAYER_ID_HANDBOOK then            --图鉴面板
		logic = KGC_HANDBOOK_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_HEROSHOP then            --英雄商店面板
		logic = KGC_HERO_SHOP_LOGIC_TYPE:getInstance();
    elseif id==GameSceneManager.LAYER_ID_ANNOUNCEMENT then          --公告
		logic = AnnouncementLogic:getInstance();
    elseif id == GameSceneManager.LAYER_ID_MAPCHOOSE then           --地图选择界面
		logic = MapChooseLogic:getInstance();
	elseif id == GameSceneManager.LAYER_ID_PVP_ARENA then           --竞技场主面板
		logic = KGC_ARENA_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_PVP_ARENA_NORMAL then    --竞技场日竞技赛战斗面板
		logic = KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance();
	elseif id == GameSceneManager.LAYER_ID_PVP_ARENA_FIGHT then    	--竞技场敌我对战面板
		logic = KGC_ARENA_FIGHT_LOGIC_TYPE:getInstance();
    end

	if logic then
		logic:initLayer(self.pLayer, id, parameters);
		self.m_tbLogicHash[id] = logic;
	end
    self.lastLayerIndex = self.currentLayerIndex;
    self.currentLayerIndex = id;


end

--@function: 显示某个界面, 其他界面都最小化
function GameSceneManager:ShowLayer(nID)
    for i,var in pairs(self.pLayer:getChildren()) do
        if var.id == nID then
        	var:display();
        else
        	var:hide()
        end
	end

    self.lastLayerIndex = self.currentLayerIndex;
    self.currentLayerIndex = nID;

end

--@function: 隐藏某个界面, 打开上一个关闭的界面
function GameSceneManager:HideLayer(nID)
	-- 就是回到主界面
	local nLastID = GameSceneManager.LAYER_ID_MAIN
    for i,var in pairs(self.pLayer:getChildren()) do
		if var.id == nID then
            var:hide();
		end

		-- 恢复上一个常驻界面
		if var.id == nLastID then
            var:display();
		end
    end

    self.currentLayerIndex = self.lastLayerIndex;
    self.lastLayerIndex = nID;

end

--移除层
function GameSceneManager:removeLayer(id)
    local childArray=self.pLayer:getChildren()
    local _childeCount = table.getn(childArray)
    for i =0,_childeCount-1,1 do
        local _pLayer=childArray[i+1]
        if _pLayer.id==id then
            -- _pLayer:runAction(cc.RemoveSelf:create())
            _pLayer:removeFromParent(true);
            break
        end
    end

    self.currentLayerIndex = self.lastLayerIndex;
    self.lastLayerIndex = id;
end

function GameSceneManager:getCurrentLayerID()
    local childArray=self.pLayer:getChildren()
    local _childeCount = table.getn(childArray)
    for i =_childeCount-1,0,-1 do
        local _pLayer=childArray[i+1]
        if _pLayer:isVisible()==true then
			local logic = self.m_tbLogicHash[_pLayer.id];
            return _pLayer.id, logic;
        end
    end

    return nil;
end

--@function: 删除所有的layer
function GameSceneManager:RemoveAllLayer()
    local childArray=self.pLayer:getChildren()
    local _childeCount = table.getn(childArray)
    for i =0,_childeCount-1,1 do
        local _pLayer=childArray[i+1]
        if _pLayer then
            _pLayer:removeFromParent(true);
        end
    end
end

--
function GameSceneManager:UnInit()
	-- logic 置空
	for _, logic in pairs(self.logicArray or {}) do
		logic:UnInit();
	end

	-- 删掉所有界面
	self:RemoveAllLayer();
end
--[[==============================逻辑类控制==================================]]--

--添加新的逻辑类
function GameSceneManager:insertLogic(logic)
    if logic~=nil then
        table.insert(self.logicArray,logic)
    end

end


--@function: 通过逻辑类更新UI
--@iType：参考ui/define.lua的类型
--@notify: 需要在对应的logic类m_tbUpdateTypes加上类型
function GameSceneManager:updateLayer(iType, tbArg)
	--local tbLogics = self.m_tbLogicHash or {};  -- self.logicArray
    for i,_logic in pairs(self.logicArray) do
		-- print("updateLayer", i, _logic:GetClassName())
    	_logic:updateLayer(iType, tbArg)
    end
end

--------------------------------------------------------------------------
--test
function GameSceneManager:TestProcessKeyEvent(keyCode, event)
	if keyCode == cc.KeyCode.KEY_T then

		-- 测试
		-- self:addLayer(GameSceneManager.LAYER_ID_AFK_STATISTICS);
	elseif keyCode == cc.KeyCode.KEY_L then
		print("reload ... ")
		tst_reload_file();
	end
end
