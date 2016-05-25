require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/configmanager/configmanager");

local afkRewardFile = mconfig.loadConfig("script/cfg/map/afkreward");
local itemFile = mconfig.loadConfig("script/cfg/pick/item");
local iconFile = mconfig.loadConfig("script/cfg/client/icon");
local guajiConfigFile = mconfig.loadConfig("script/cfg/map/afkreward");
local stringConfigFile = require("script/cfg/string");
local resFileConfig = mconfig.loadConfig("script/cfg/map/picture")
---------------------------------------------------------------------------------------------
--体力提示对话框
MapViewDialogTipsPhysical = class("MapViewDialogTipsPhysical",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MapViewDialogTipsPhysical:create(mapView)
	self = MapViewDialogTipsPhysical.new()
	self.mapView = mapView
	self:initAttr()
	return self;
end

function MapViewDialogTipsPhysical:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewDialogTipsPhysical.json")
    self:addChild(self.pWidget)
end

function MapViewDialogTipsPhysical:initAttr()

	local function fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local btn_ok = self.pWidget:getChildByName("btn_queding")
	btn_ok:addTouchEventListener(fun_queding)

	local lab_info=self.pWidget:getChildByName("lab_info")
	lab_info:setString(stringConfigFile[13007])

end




--------------------------------------------------------------------------------------
--体力已空
MapViewDialogTipsPhysicalZero = class("MapViewDialogTipsPhysicalZero",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end);

function MapViewDialogTipsPhysicalZero:create(mapView)
	self = MapViewDialogTipsPhysicalZero.new();
	self.mapView = mapView;
	self:initAttr();
	return self;
end

function MapViewDialogTipsPhysicalZero:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewDialogTipsPhysical.json")
    self:addChild(self.pWidget)
end

function MapViewDialogTipsPhysicalZero:initAttr()
	local function fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
			--GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_BAG,0)
			self:closeLayer()
        end
	end

	local btn_ok = self.pWidget:getChildByName("btn_queding")
	btn_ok:addTouchEventListener(fun_queding)

	local lab_info=self.pWidget:getChildByName("lab_info")
	lab_info:setString(stringConfigFile[13008])

end

------------------------------------------------------------------------------------------------
--迁移挂机点提示
MapViewDialogChangeHookPoint = class("MapViewDialogChangeHookPoint",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MapViewDialogChangeHookPoint:create(mapView,oldID,newID)
	self = MapViewDialogChangeHookPoint.new();
	self.mapView = mapView;
	self.oldID = oldID;
	self.newID = newID;
	self:initAttr();
	return self;
end

function MapViewDialogChangeHookPoint:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui_changebase.json")
    self:addChild(self.pWidget)
end

function MapViewDialogChangeHookPoint:initAttr()

	local function fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	self.pWidget:addTouchEventListener(fun_queding)


	local pnl_rewards = self.pWidget:getChildByName("pnl_rewards");
	pnl_rewards:setPositionX(-750);


	self:initIcon();
	self:initNumInfo();

end

function MapViewDialogChangeHookPoint:initNumInfo()
	local oldRew = afkRewardFile[self.oldID];
	local newRew = afkRewardFile[self.newID];

	local numInfoPanel = self.pWidget:getChildByName("Panel_numInfo")
	local expPanel = numInfoPanel:getChildByName("Panel_exp");
	local goldPanel = numInfoPanel:getChildByName("Panel_gold");
	local apPanel = numInfoPanel:getChildByName("Panel_ap");

	local oldExp = expPanel:getChildByName("bmp_oldexp")
	local newExp = expPanel:getChildByName("bmp_newexp")

	local bmp_oldmoney	=	goldPanel:getChildByName("bmp_oldmoney");
	local bmp_newmoney	=	goldPanel:getChildByName("bmp_newmoney");

	local bmp_oldstep	=	apPanel:getChildByName("bmp_oldstep");
	local bmp_newstep	=	apPanel:getChildByName("bmp_newstep")


	oldExp:setString(oldRew.onlineexp);
	newExp:setString(newRew.onlineexp);

	bmp_oldmoney:setString(oldRew.onlinegold);
	bmp_newmoney:setString(newRew.onlinegold);

	bmp_oldstep:setString(oldRew.onlineap);
	bmp_newstep:setString(newRew.onlineap);


	--------------动画
	--经验
	local expRow = expPanel:getChildByName("img_row");
	if oldRew.onlineexp < newRew.onlineexp then 

	elseif oldRew.onlineexp  > newRew.onlineexp then 
		expRow:loadTexture("res/ui/00/00_arrow_down.png");
	else
		expRow:setVisible(false);
	end

	--钱
	local goldRow = goldPanel:getChildByName("img_row");
	if oldRew.onlinegold < newRew.onlinegold then 

	elseif oldRew.onlinegold  > newRew.onlinegold then
		goldRow:loadTexture("res/ui/00/00_arrow_down.png");
	else
		goldRow:setVisible(false);
	end

	--行动力
	local apRow = apPanel:getChildByName("img_row");
	if oldRew.onlineap < newRew.onlineap then 

	elseif oldRew.onlineap  > newRew.onlineap then
		apRow:loadTexture("res/ui/00/00_arrow_down.png");
	else
		apRow:setVisible(false);
	end		


end


function MapViewDialogChangeHookPoint:initIcon()

	local oldConfig = guajiConfigFile[self.oldID];
	local newConfig = guajiConfigFile[self.newID];


	local Panel_icon  	= 	self.pWidget:getChildByName("Panel_icon")
	local imgRow 		=	Panel_icon:getChildByName("Image_50");
	local lbl_newname	=	Panel_icon:getChildByName("Panel_new"):getChildByName("lab_name");
	lbl_newname:setString(newConfig.Name)

	local oldIcon = Panel_icon:getChildByName("Panel_old"):getChildByName("img_icon");
	local newIcon = Panel_icon:getChildByName("Panel_new"):getChildByName("img_icon");


	local oldPath = resFileConfig[oldConfig.Pic1].Path;
	local newPath = resFileConfig[newConfig.Pic1].Path;

	oldIcon:loadTexture(oldPath);
	newIcon:loadTexture(newPath);
	oldIcon:setScale(0.25);
	newIcon:setScale(0.5);

	local function fun_callReward(node,pTable)
		self:initReward();
	end	

	local function fun_moveIn(node,pTable)
		newIcon:stopAllActions();
		newIcon:setScale(0.5);
		local scaleAction = cc.EaseElasticOut:create(cc.ScaleTo:create(2.0,0.6))
		newIcon:runAction(scaleAction);
	end

	local function fun_moveFinished(node,pTable)
		local newPanel = Panel_icon:getChildByName("Panel_new");
		local moveAction = cc.MoveTo:create(0.5,cc.p(360,newPanel:getPositionY()));
		newPanel:runAction(cc.Sequence:create(moveAction,cc.CallFunc:create(fun_callReward)));
	end

	local function fun_glow(node,pTable)
		local imgGlow = self.pWidget:getChildByName("img_bgeffect");
		imgGlow:runAction(cc.RepeatForever:create(cc.RotateBy:create(5.0,360)));
	end


	-------小人移动
	local iCharNum = #(me:GetHeros());

	for i=1,iCharNum do
		local spaceTime = 1.0;
		local pNode = cc.Node:create();
		pNode:setVisible(false)
		pNode:setPosition(cc.p(200,imgRow:getPositionY()));
		Panel_icon:addChild(pNode);
		local delayAction  = cc.DelayTime:create((i-1)*spaceTime);
		local moveAction = cc.MoveBy:create(1.0,cc.p(350,0));
		local funAction;
		if i == iCharNum  then 
			 funAction = cc.CallFunc:create(fun_moveFinished)
		else
			 funAction = cc.CallFunc:create(fun_moveIn)
		end

		pNode:runAction(cc.Sequence:create(delayAction,cc.Show:create(),moveAction,funAction,cc.RemoveSelf:create()));


		local pChar = sp.SkeletonAnimation:create("res/ANI/model/hero/action_hero_01/action_hero_01.json", 
                                                    "res/ANI/model/hero/action_hero_01/action_hero_01.atlas", 1);
		pChar:setAnimation(0, "run", true)
		pChar:setScaleX(-1);
		pNode:addChild(pChar);
	end


	--原始消失
	oldIcon:runAction(cc.FadeOut:create(1.0*iCharNum));

	--背景光线
	fun_glow();
end


function MapViewDialogChangeHookPoint:initReward()

	local fMoveTime = 0.5;
	
	local 	itemRewardItem 	= self.pWidget:getChildByName("pnl_rewards"):getChildByName("img_item1")
	self.pWidget:getChildByName("pnl_rewards"):runAction(cc.MoveTo:create(fMoveTime,cc.p(0,0)));

	local showItmeConfig = afkRewardFile[self.newID].ShowItem;
	local showValueConfig = afkRewardFile[self.newID].ShowValue;

	--道具
	local iNum = 1;
	local iMaxX = 4;
	local spaceX = 152;
	local spaceY = 152;
	local basePosX = itemRewardItem:getPositionX();
	local basePosY = itemRewardItem:getPositionY();

	local rewardNode = cc.Node:create();
	rewardNode:setLocalZOrder(10);
	self.pWidget:getChildByName("pnl_rewards"):addChild(rewardNode);

	for k,v in pairs(showItmeConfig) do
		local item = itemRewardItem:clone();
		rewardNode:addChild(item);
		item:setPositionX(basePosX+(iNum-1)%iMaxX*spaceX);
		item:setPositionY(basePosY -math.floor((iNum-1)/iMaxX)*spaceY);

		local bml_num 	= 	item:getChildByName("bml_num");
		local img_icon 	= 	item:getChildByName("img_icon");

		bml_num:setString(v[2]);
		img_icon:loadTexture(itemFile[v[1]].itemIcon);

		iNum=iNum+1;
	end

	--数值
	for k,v in pairs(showValueConfig) do
		local item = itemRewardItem:clone();
		rewardNode:addChild(item);
		item:setPositionX(basePosX+(iNum-1)%iMaxX*spaceX);
		item:setPositionY(basePosY -math.floor(( iNum-1)/iMaxX)*spaceY);

		local lbl_content = item:getChildByName("bml_num")
		local img_icon	  = item:getChildByName("img_icon")

		lbl_content:setString(v[2]);
		img_icon:loadTexture(iconFile[v[1]].iconpath);

		iNum=iNum+1;
	end

	local childTab = rewardNode:getChildren();
	for k,v in pairs(childTab) do
		v:setVisible(false);
		v:setScale(3);
		local acitonDelay = cc.DelayTime:create((k-1)*0.1+fMoveTime);
		local actionShow = cc.Show:create();
		local actionScale = cc.ScaleTo:create(1.0,1);
		v:runAction(cc.Sequence:create(acitonDelay,actionShow,actionScale));
	end


	itemRewardItem:removeFromParent();
end


-----------------------------------------------------------------------------
--奖励提示对话框

MapViewDialogRewardTips = class("MapViewDialogRewardTips",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)


function MapViewDialogRewardTips:create(mapView)
	self = MapViewDialogRewardTips.new();
	self.mapView = mapView;
	self:initAttr();
	
	return self;
end

function MapViewDialogRewardTips:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewDialogTipsPhysical.json")
    self:addChild(self.pWidget)
end

function MapViewDialogRewardTips:initAttr()

	local function fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local btn_ok = self.pWidget:getChildByName("btn_queding")
	btn_ok:addTouchEventListener(fun_queding)


end