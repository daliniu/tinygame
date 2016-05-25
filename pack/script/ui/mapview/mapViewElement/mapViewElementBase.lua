--元素状态配置文件
require("script/core/configmanager/configmanager");
local elementTypeFile =  mconfig.loadConfig("script/cfg/map/elementtype")
local stringConfigFile = require("script/cfg/string");
local desConfigFile = mconfig.loadConfig("script/cfg/map/elementdesc");
local resFileConfig = mconfig.loadConfig("script/cfg/map/picture")

local TB_MAP_VIEW_ELEMENT_BASE={
	uid					=0,			--uid
	id     				=0,			--id
	spDisplay			=nil,		--显示
	indexPos 			=nil,		--位置
	bLimit				=nil,		--是否限时
	iLimitCount			=nil,		--剩余限制次数
	iLimitText			=nil,		--限时的显示
	firsType			=nil,		--主类型
	subType				=nil,		--次级类型
	iState			 	=nil,		--状态
	pConfig				=nil,		--配置表
	pResConfig			=nil,		--图片资源配置信息
	spPlayerRoleHead 	=nil,		--角色头像
	isLive				=nil,		--是否还存在（如果false就删除）
	controlManager		=nil,		--控制管理器(mapView中的objectLayer)
	currentInfoDocId 	=nil,		--当前文案ID
	isBeRemoved			=nil,		--是否要被移除

	iStateIndex 		=nil,		--状态index(从配置表里读取状态编号用)
	stateTabConfig		=nil,		--状态列表

	imageSize 			=nil,		--图片尺寸大小

	baseEffectNode 		=	nil,	--基础特效
	stateEffectNode		=	nil,	--状态特效
	opEffectNode		=	nil,	--操作特效
	exploredTipsNode 	=	nil,	--是否探索过

	touchBoxTab  =nil;				--点击矩形.
}


--地图元素基类
MapViewElementBase = class("MapViewElementBase",function()
	return cc.Node:create()
end,TB_MAP_VIEW_ELEMENT_BASE)


MapViewElementBase.FL_TYPE_RES			= 1			--资源
MapViewElementBase.FL_TYPE_HOOKPOINT 	= 2			--挂机点
MapViewElementBase.FL_TYPE_ENEMY    	= 3			--敌人
MapViewElementBase.FL_TYPE_BUILDING 	= 4			--建筑
MapViewElementBase.FL_TYPE_PORTAL		= 5			--传送门
MapViewElementBase.FL_TYPE_OTHER		= 6			--其他
MapViewElementBase.FL_TYPE_NPC 			= 7			--NPC
MapViewElementBase.FL_TYPE_TERRAIN		= 10		--地形
MapViewElementBase.FL_TYPE_OBSTACLE 	= 11		--障碍物


-------------------------------------------------------------------------------

MapViewElementBase.TYPE_RES_NORMAL			= 	1;			--普通资源
MapViewElementBase.TYPE_RES_CHOOSE			= 	2;			--选择性资源
MapViewElementBase.TYPE_HOOK_NORMAL			= 	3;			--普通挂机点
MapViewElementBase.TYPE_HOOK_LIMIT			=	4;			--限时挂机点
MapViewElementBase.TYPE_HOOK_AtONCE			=	5;			--限时挂机点（立即)
MapViewElementBase.TYPE_ENEMY_NORMAL		=	6;			--普通怪
MapViewElementBase.TYPE_ENEMY_CHOOSE		=	7;			--选择型
MapViewElementBase.TYPE_ENEMY_CONTINUOUS	=	8;			--连续挑战
MapViewElementBase.TYPE_ENEMY_UNKNOWN		=	9;			--未知怪
MapViewElementBase.TYPE_ENEMY_EXIT			=	10;			--出口怪
MapViewElementBase.TYPE_BUILDING_SUPPLY		=	11;			--补给建筑
MapViewElementBase.TYPE_BUILDING_BUFF		=	12;			--BUFF点
MapViewElementBase.TYPE_BUILDING_STATION	=	13;			--交通站
MapViewElementBase.TYPE_BUILDING_INTE		=	14;			--情报站
MapViewElementBase.TYPE_BUILDING_SHOP		=	15;			--商店
MapViewElementBase.TYPE_BUILDING_WATCHTOWER	=	16;			--瞭望塔
MapViewElementBase.TYPE_PORTAL_NORMAL		=	17;			--传送门
MapViewElementBase.TYPE_MAILBOX				=	18;			--邮筒
MapViewElementBase.TYPE_NPC 				=	19;			--NPC
MapViewElementBase.TYPE_MARSH				=	30;			--沼泽
MapViewElementBase.TYPE_WIND				=	31;			--大风
MapViewElementBase.TYPE_OBSTACLE_REMOVE		=	32;			--可移除
MapViewElementBase.TYPE_OBSTACLE_UNREMOVE	=	33;			--不可移除障碍


--状态
MapViewElementBase.STATE_01			=		1;
MapViewElementBase.STATE_02			=		2;
MapViewElementBase.STATE_03			=		3;
MapViewElementBase.STATE_04			=		4;


--详情信息面板类型
MapViewElementBase.INFO_PANEL_TYPE01 =1;		--显示奖励的	
MapViewElementBase.INFO_PANEL_TYPE02 =2;		--显示怪的
MapViewElementBase.INFO_PANEL_TYPE03 =3;		--只显示文字
MapViewElementBase.INFO_PANEL_TYPE04 =4;		--只显示文字

function MapViewElementBase:create()
	-- body
	self = MapViewElementBase:new()
	return self
end


function MapViewElementBase:ctor()
	self.iStateIndex = 1;
	self.isLive = true;
	self.currentInfoDocId="Desc1"


	local function fnUpdate(dt)
		self:Update(dt);
	end

	if self.m_bUpdate then
		self:scheduleUpdateWithPriorityLua(fnUpdate, 0)
	end
	
	local fnNodeEvent = function(tag)
		if tag == "exit" then
			self:OnExit();
		end
	end
	self:registerScriptHandler(fnNodeEvent)

end


function MapViewElementBase:OnExit()
	-- body
end

function MapViewElementBase:initAttr()
	-- body
end

function MapViewElementBase:initTouchBox()
	local spH =10;
	local spW =10;

	if self.touchBoxTab ==nil then
		self.touchBoxTab = cc.Node:create();
		self:addChild(self.touchBoxTab);
	end

	if self.pConfig ==nil then 
		return;
	end

	local tab =self.pConfig.PicClickArea;
	if tab ==nil then 
		return;
	end
	for k,v in pairs(tab) do
		local sp = cc.Sprite:create("res/map/touchBox.png");
		sp:setAnchorPoint(cc.p(0,0));
		sp:setPositionY(v[1]);
		sp:setPositionX(v[2]);
		sp:setScaleX(math.abs(v[3]-v[2])/spW);
		sp:setScaleY(math.abs(v[4]-v[1])/spH);
		sp:setVisible(false);
		self.touchBoxTab:addChild(sp);
	end

end

--默认状态--务必调用
function MapViewElementBase:initState()
	self.stateTabConfig =elementTypeFile[self.subType].State
	if self.stateTabConfig ~= nil then 
		self.iState =self.stateTabConfig[self.iStateIndex];
	else
		self.stateTabConfig={1}
		self.iState=1;
	end
	self:setState(self.iState)
end

--设置状态
function MapViewElementBase:setState(iState)
	--设置状态
	self.iState = iState;
	--设置状态index
	for k,v in pairs(self.stateTabConfig) do
		if v == self.iState then
			self.iStateIndex = k;
		end
	end

	self:setEffectWithState();
	--self:addExploreTips();
end




--激活
function MapViewElementBase:makeActivity()

end

--获取返回区域（阻碍运动）
function MapViewElementBase:getEffectedArea()
	local pTab = {}
	if self.pConfig~=nil then 
		for i=0,self.pConfig["Area"][1]-1 do
			for j=0,self.pConfig["Area"][2]-1 do
				local _x = self.indexPos.x+i;
				local _y = self.indexPos.y+j;
				if _x>self.controlManager.layerSize.width-1 then 
					_x=self.controlManager.layerSize.width-1
				end
				if _y>self.controlManager.layerSize.height-1 then 
					_y=self.controlManager.layerSize.height-1
				end				
				table.insert(pTab,cc.p(self.indexPos.x+i,self.indexPos.y+j))
			end
		end
	else
		
	end

	return pTab
end

--所指定的点，是否影响到了运动
function MapViewElementBase:isEffectIndexPoint(indexPoint)
	if self.pConfig==nil then 
		return false;
	end
	if indexPoint.x >= self.indexPos.x
		and indexPoint.x < self.indexPos.x+self.pConfig["Area"][1]
		and indexPoint.y >= self.indexPos.y
		and indexPoint.y < self.indexPos.y+self.pConfig["Area"][2] then
		return true
	end

	return false;
end

--所占的格子
function MapViewElementBase:isInPosArea(indexPoint)
	if self.pConfig==nil then 
		if self.indexPos.x ==indexPoint.x and
			self.indexPos.y == indexPoint.y then
			return true
		else
			return false;
		end
	end

	if indexPoint.x >= self.indexPos.x
		and indexPoint.x < self.indexPos.x+self.pConfig["Area"][1]
		and indexPoint.y >= self.indexPos.y
		and indexPoint.y < self.indexPos.y+self.pConfig["Area"][2] then

		return true
	end

	return false;
end

--因为障碍物是没有配置的，所以这边临时给数据
--视觉上所占的格子（仅仅是为了显示，数据有可能不准确）
function MapViewElementBase:getVisualEffectedArea()
	local pTab = {}
	if self.pConfig~=nil then 
		for i=0,self.pConfig["Area"][1]-1 do
			for j=0,self.pConfig["Area"][2]-1 do
				local _x = self.indexPos.x+i;
				local _y = self.indexPos.y+j;
				if _x>self.controlManager.layerSize.width-1 then
					_x=self.controlManager.layerSize.width-1
				end
				if _y>self.controlManager.layerSize.height-1 then 
					_y=self.controlManager.layerSize.height-1
				end
				table.insert(pTab,cc.p(self.indexPos.x+i,self.indexPos.y+j))
			end
		end
	else
		table.insert(pTab,cc.p(self.indexPos.x,self.indexPos.y))	
	end


	return pTab
end


--是否需要变透明
function MapViewElementBase:isNeedtranslucent(index) 
	if self.pResConfig == nil or self.pResConfig.MaskArea == nil then 
		return false;
	end

	local maskArea = self.pResConfig.MaskArea
	for k,v in pairs(maskArea) do
		if self.indexPos.x - v[1] == index.x and 
			self.indexPos.y - v[2] == index.y then 
			return true;
		end
	end

	return false;
end


--设置indexpos
function MapViewElementBase:setIndexPos(indexPoint)
	-- body
	self.indexPos = indexPoint
end

--设置限制次数
function MapViewElementBase:setLimitCount(iCount)
	self.iLimitCount = iCount
	self.bLimit = true;   --限制类
	self.iLimitText= ccui.Text:create();
	self.iLimitText:setString(iCount)
	self.iLimitText:setFontSize(30)
	self.iLimitText:setLocalZOrder(1)
	self:addChild(self.iLimitText)
end

--减少剩余的限制次数
function MapViewElementBase:reduceLimitCount(iCount)
	if self.bLimit ~=true then 
		return
	end
	self.iLimitCount = self.iLimitCount - iCount
	if self.iLimitCount <= 0 then 
		self.iLimitCount = 0
	end

	self.iLimitText:setString(self.iLimitCount)

end

function MapViewElementBase:getInfoFunButton()
	return nil
end

--获取走上去之后的功能按钮
function MapViewElementBase:getFunctionFunButtons()
	return nil
end

--获取名字
function MapViewElementBase:getNameString()
	return self.pConfig["Name"]
end


--玩家进入
function MapViewElementBase:playerRoleGetIn(role)
	if self.pConfig["GetInto"] == 1 then
		role.lastGetInBuildingUID = self.uid
		role:setVisible(false)
		self.spPlayerRoleHead = cc.Node:create();

		local _sp01 = cc.Sprite:create("res/ui/06_exmainUI/06_bg_head.png")
		_sp01:setAnchorPoint(cc.p(0.5,0))
		self.spPlayerRoleHead:addChild(_sp01)

		local _sp02 = cc.Sprite:create("res/ui/picture/00_pic_role_adven_03.png")
		_sp02:setAnchorPoint(cc.p(0.5,0))
		_sp02:setPositionY(20)
		self.spPlayerRoleHead:addChild(_sp02)
		self:addChild(self.spPlayerRoleHead)

		--位置
		self.spPlayerRoleHead:setPositionY(self.spDisplay:getBoundingBox().height*0.7)

	end
end
--玩家离开
function MapViewElementBase:playerRoleGetOut(role)
	role:setVisible(true)
    role.lastGetInBuildingUID = nil
    if self.spPlayerRoleHead ~= nil then
    	self.spPlayerRoleHead:removeFromParent()
    	self.spPlayerRoleHead =nil
    end
end

--被移除
function MapViewElementBase:setBeRemoved()
	--移除数据
	if self.controlManager~=nil then
		self.controlManager:removeElementObjectDate(self)
		-- 删除自身
		self.controlManager:removeFunctionElementObject(self);
		self:runAction(cc.RemoveSelf:create())
		self.isBeRemoved=true;
	end
end

--设置图片资源
function MapViewElementBase:setImgRes(idTab)
	for i,var in pairs(idTab) do
		local id = var
		self.pResConfig = resFileConfig[id]
		self.spDisplay = cc.Sprite:create(self.pResConfig.Path)
	end
	if self.spDisplay==nil then
		self.spDisplay = cc.Sprite:create();
	end
end

--获取下一状态
function MapViewElementBase:getNextStateID()
	if self.stateTabConfig[self.iStateIndex+1] ~= nil then 
		return self.stateTabConfig[self.iStateIndex+1]
	end
	return self.iState;
end


--设置图片透明度
function MapViewElementBase:setImgOpacity(fValue)
	self.spDisplay:stopAllActions();
	local fTime =0.2
	self.spDisplay:runAction(cc.FadeTo:create(fTime,fValue));
end




--检测是否应该被删除
function MapViewElementBase:checkIsAbleRemove()
	--如果是最后一个状态，
	if self.iStateIndex ~= table.getn(self.stateTabConfig) then 
		return false
	end

	--并且配置中是需要消失的属性
	if self.pConfig.PickupLived ~= 0 then 
		return false
	end

	return true;

end

--是否可以踩上去
function MapViewElementBase:isObstacle()
	if self.pConfig.Obstacle == 0 then 
		return false
	end

	return true;
end

--获取信息
function MapViewElementBase:getInfoString(desID,index)
	local pString =nil

	local _config = desConfigFile[desID]
	pString = _config.Words
	if index==1 then
		pString = _config.Word1
	elseif index ==2 then
		pString = _config.Word2
	elseif index ==3 then
		pString = _config.Word3
	elseif index ==4 then
		pString = _config.Word4
	elseif index ==5 then
		pString = _config.Word5
	elseif index ==6 then
		pString = _config.Word6
	elseif index ==7 then
		pString = _config.Word7
	elseif index ==8 then
		pString = _config.Word8
	elseif index ==9 then
		pString = _config.Word9
	elseif index ==10 then
		pString = _config.Word10
	elseif index ==11 then
		pString = _config.Word11
	end

	if pString ==nil then 
		pString=""
	end
	return pString
end

--服务端发来的附加信息
function MapViewElementBase:setArgs(args)
	-- body
end

--根据状态更新功能
function MapViewElementBase:updateFuncitonWithState()
	-- body
end


--判定是否符合开启的前置条件
--判定当前元素功能是否开启
--返回的tab里是没有开启的原因列表，如果tab size为0 证明没有未达标的条件。则此时功能正常开启
function MapViewElementBase:isAbleOpen()
	local tab_resulat={};


	return tab_resulat;
end


function MapViewElementBase:initAttrWithPlayerHookPointDate()
	-- body
end



--远处查看层
function MapViewElementBase:getInfoFunction(functionChooseLayer)
	return nil
end

--进入触发层
function MapViewElementBase:getEnterFunction(functionChooseLayer)
	return nil
end

--子触发层
function MapViewElementBase:getEnterFunctionSub(functionChooseLayer)
	return nil
end


--获取特效资源
function MapViewElementBase:getEffectID()
	return nil;
end


--设置图片尺寸
function MapViewElementBase:setImageSize(pSize)
	self.imageSize = pSize;
end


--根据状态设置特效表现
function MapViewElementBase:setEffectWithState()
	self:addStateEffect(self.iState)
end


--增加基础特效
function MapViewElementBase:addBaseEffect()
	if self.baseEffectNode==nil then
		self.baseEffectNode = cc.Node:create();
		self:addChild(self.baseEffectNode)
		self.baseEffectNode:setLocalZOrder(1);
	end

	if self.pConfig.Effect1~=nil then
		local pEffect = MapViewElementEffect:create(self.pConfig.Effect1)
		if pEffect~=nil then
			self.baseEffectNode:addChild(pEffect);
		end
	end
end

--增加状态特效
function MapViewElementBase:addStateEffect(iState)
	if self.stateEffectNode ==nil then 
		self.stateEffectNode = cc.Node:create();
		self:addChild(self.stateEffectNode);
		self.stateEffectNode:setLocalZOrder(2);
	end

	for k,v in pairs(self.stateEffectNode:getChildren()) do
		if v.iState ~=iState then 
			v:removeFromParent();
		else
			return;
		end
	end

	local effectTab = self.pConfig.Effect2
	if effectTab~=nil then
		local pCfg =nil;
		for k,v in pairs(effectTab) do
			if v[5] == iState then 
				pCfg = v;
			end
		end
		local pEffect = MapViewElementEffect:create(pCfg)
		if pEffect~=nil then
			pEffect.iState = iState;
			self.stateEffectNode:addChild(pEffect);
		end
	end

end

--操作特效
function MapViewElementBase:addComStateEffect(iType)
	if self.opEffectNode ==nil then 
		self.opEffectNode = cc.Node:create();
		self:addChild(self.opEffectNode);
		self.opEffectNode:setLocalZOrder(3);
	end

	local effectTab = self.pConfig.Effect3;
	if effectTab ~=nil then 
		if effectTab[5] == iType then
			local pEffect = MapViewElementEffect:create(effectTab)
			if pEffect~=nil then
				self.opEffectNode:addChild(pEffect);
			end
		end
	end
end


function MapViewElementBase:addExploreTips()

	if self.pConfig.Pic2 ==nil then 
		return;
	end

	local imgID = self.pConfig.Pic2[1];
	local posx =self.pConfig.Pic2[2];
	local posy = self.pConfig.Pic2[3];
	local stateid = self.pConfig.Pic2[4];


	--添加未探索过提示
	function addUnExploredEffect()
		if self.exploredTipsNode ==nil then 
			self.exploredTipsNode = cc.Node:create();
			self:addChild(self.exploredTipsNode);
			self.exploredTipsNode:setLocalZOrder(3);
		end

		self.exploredTipsNode:removeAllChildren();

		local sp = cc.Sprite:create(resFileConfig[imgID].Path)
		sp:setPosition(cc.p(posx,posy));
		self.exploredTipsNode:addChild(sp);
	end

	--已探索过的提示效果
	function addExploredEffect()
		if self.exploredTipsNode ==nil then 
			self.exploredTipsNode = cc.Node:create();
			self:addChild(self.exploredTipsNode);
			self.exploredTipsNode:setLocalZOrder(3);
		end

		self.exploredTipsNode:removeAllChildren();

		local sp = cc.Sprite:create("res/map/icon/00.png")
		sp:setPosition(cc.p(posx,posy));
		self.exploredTipsNode:addChild(sp);
	end

	if stateid == 0 then 
		addUnExploredEffect();
	else
		if stateid == self.iState then 
			addExploredEffect();
		else
			addUnExploredEffect();
		end
	end
end


function MapViewElementBase:isBeTouched(touch)

	if self.touchBoxTab ==nil then
		return false;
	end
	local boxTab = self.touchBoxTab:getChildren();

	for k,v in pairs(boxTab) do
		local localPos =v:getParent():convertTouchToNodeSpace(touch);
		local boundingBox = v:getBoundingBox();

		print(localPos.x,localPos.y)

		print(boundingBox.x,boundingBox.y)
		print(boundingBox.x+boundingBox.width,boundingBox.y+boundingBox.height)

		if localPos.x >= boundingBox.x and
			localPos.x<= boundingBox.x + boundingBox.width and 
			localPos.y>= boundingBox.y and 
			localPos.y <= boundingBox.y+boundingBox.height then
			return true;
		end
	end

	return false;

end