
require("script/core/configmanager/configmanager");
local rewardConfigFile  = 	mconfig.loadConfig("script/cfg/pick/drop")
local itemConfigFile 	= 	mconfig.loadConfig("script/cfg/pick/item")
local stringConfigFile  =	require("script/cfg/string")

require("script/ui/publicview/EquipInfoTips");

local MVEIL_NORMAL_TAB={
	
}

MVEIL_Normal = class("MVEIL_Normal",function()
	return MapViewDialogDetailInfo.new()
end,MVEIL_NORMAL_TAB)


function MVEIL_Normal:create(functionChooseLayer)
	self = MVEIL_Normal.new();
	self.functionChooseLayer = functionChooseLayer;
	self:initBaseAttr();
	return self;
end

------------------------------------------------------------------------打开新的面板

local MVEIL_OPEN_NEW_LAYER_TAB={
	
}

MVEIL_openNewLayer = class("MVEIL_openNewLayer",function()
	return MapViewDialogDetailInfo.new()
end,MVEIL_OPEN_NEW_LAYER_TAB)

function MVEIL_openNewLayer:create(functionChooseLayer)
	self = MVEIL_openNewLayer.new();
	self.functionChooseLayer = functionChooseLayer;
	self:initBaseAttr();
	return self;
end

function MVEIL_openNewLayer:addNewViewButton(string)

	local function function_ok(sender,event)
	    if event == ccui.TouchEventType.ended then
	    	local pLayer = self.element:getEnterFunctionSub(self.functionChooseLayer)
	    	if pLayer ~= nil then
	    		self.functionChooseLayer:addNewDialogBoxNodeWithNotClean(pLayer)
	    		self:closeLayer();
	    	end
        end
    end

    local btn = self.pButtonItem:clone()
	self.panel_button:addChild(btn)
	--位置
	btn:setPositionX(btn:getPositionX()+(1-1)*150)
	--点击事件
	btn:addTouchEventListener(function_ok)
	if string~=nil then 
		btn:setTitleText(string)
	end
	
end


-----------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--选择奖励对话框
MapViewDialogChooseRew = class("MapViewDialogChooseRew",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MapViewDialogChooseRew:create(element,functionChooseLayer)
	self = MapViewDialogChooseRew.new()
	self.pElement = element;
	self.functionChooseLayer = functionChooseLayer;
	self:initAttr()
	return self
end

function MapViewDialogChooseRew:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewChooseReward.json")
    self:addChild(self.pWidget)

    self.chooseID = 0;
end

function MapViewDialogChooseRew:OnExit()

end

function MapViewDialogChooseRew:initAttr()


	local function fun_cancle(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local function fun_choose(sender,event)
		if event == ccui.TouchEventType.ended then
			self.chooseID = sender.rewardID;
			self.functionChooseLayer:fun_chooseReward(self.pElement,self.chooseID);
        end
	end


	--按钮
	local btn_cancle = self.pWidget:getChildByName("btn_cancle");
	btn_cancle:addTouchEventListener(fun_cancle)

	local Panel_rewardItem1 = self.pWidget:getChildByName("Panel_rewardItem1");
	local btn_01 = Panel_rewardItem1:getChildByName("btn_quding")
	btn_01:addTouchEventListener(fun_choose)
	btn_01.rewardID = 1;

	local Panel_rewardItem2 = self.pWidget:getChildByName("Panel_rewardItem2");
	local btn_02 = Panel_rewardItem2:getChildByName("btn_quding")
	btn_02:addTouchEventListener(fun_choose)
	btn_02.rewardID = 2;


	--名称
	self.pWidget:getChildByName("lab_name"):setString(self.pElement:getNameString())

	--道具显示
	self:setItemInfo(Panel_rewardItem1,
						self.pElement.pConfig.Reward1,
						self.pElement.pConfig.Probability1,
						self.pElement.pConfig.Show1,
						self.pElement.pConfig.Color1)
	self:setItemInfo(Panel_rewardItem2,
						self.pElement.pConfig.Reward2,
						self.pElement.pConfig.Probability2,
						self.pElement.pConfig.Show2,
						self.pElement.pConfig.Color2)
	
end

function MapViewDialogChooseRew:setTextInfo(sInfo)
	self.textInfo = sInfo;
	self:setText();
end

function MapViewDialogChooseRew:setText()
	if self.textInfo==nil then 
		self.textInfo=""
	end
	local lab_info = self.pWidget:getChildByName("lab_info")
	lab_info:setString(self.textInfo)
end


function MapViewDialogChooseRew:setItemInfo(panel,itemid,prob,show,color)
	local lab_name  = panel:getChildByName("lab_name");					--名字
	local img_bg	= panel:getChildByName("img_bg");					--背景
	local img_icon  = panel:getChildByName("img_icon");					--图标
	local lab_num   = panel:getChildByName("lab_num");					--数量
	local lab_pr 	= panel:getChildByName("lab_pr");					--概率
	local rConfig 		= 	rewardConfigFile[itemid]
	local itemConfig 	=	itemConfigFile[rConfig.Showitem[1]]

	lab_num:setVisible(false)			---策划又说不要在这里显示
	lab_name:setString(rConfig.Name)
	img_icon:loadTexture(itemConfig.itemIcon)

	--概率
	if show == 1 then 
		lab_pr:setString(prob..stringConfigFile[13000])
	else
		lab_pr:setVisible(false)
	end
	
end



---------------------------------------------------------------------------------------------------------------------
--进入补给站
MapViewDialogSupply = class("MapViewDialogSupply",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MapViewDialogSupply:create(element,functionChooseLayer)
	self = MapViewDialogSupply.new()
	self.pElement = element;
	self.functionChooseLayer = functionChooseLayer
	self:initAttr()
	return self
end

function MapViewDialogSupply:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewDialogSupply.json")
    self:addChild(self.pWidget)


end

function MapViewDialogSupply:OnExit()
	
end

function MapViewDialogSupply:initAttr()
	local function  fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
		 	self.pElement.pValue = self.pElement.pValue -  me:GetTeamHp();
			self.functionChooseLayer:fun_supply(self.pElement);
			self:closeLayer()
        end
	end

	local function fun_quxiao(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end
	
	self.pElement.pValue = me:GetTeamHp();

	local btn_cancle = self.pWidget:getChildByName("btn_quxiao")
	btn_cancle:addTouchEventListener(fun_quxiao)

	local btn_ok = self.pWidget:getChildByName("btn_quding")
	btn_ok:addTouchEventListener(fun_queding)

	--名称
	self.pWidget:getChildByName("lab_name"):setString(self.pElement:getNameString())	

	self:initSlider()
end

function MapViewDialogSupply:initSlider()

	local lab_pay = self.pWidget:getChildByName("Label_pay")	--花费
	local lab_current = self.pWidget:getChildByName("label_current");	--当前补给量
	local slider = self.pWidget:getChildByName("Slider_jindu");

	local function fun_slider(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			local pValue = sender:getPercent();
			self.pElement.pValue = pValue;
			if pValue < me:GetTeamHp() then
				self.pElement.pValue = me:GetTeamHp();
				slider:setPercent(me:GetTeamHp())
				return;
			end
			self.pElement:setSupplyValue(pValue);
			lab_pay:setString((pValue-me:GetTeamHp())*self.pElement.pConfig.Price);
			lab_current:setString(pValue);
		end
	end

	slider:addEventListener(fun_slider)

	local iHp = me:GetTeamHp();
	slider:setPercent(iHp)
	lab_current:setString(iHp)
	
end


---------------------------------------------------------------------------------------------------------------------
--进入功能建筑（商店）
MapViewDialogFunctionBuilding = class("MapViewDialogFunctionBuilding",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)


function MapViewDialogFunctionBuilding:initVar()
	self.pDialog = nil;
	self.itemID = 0;
	self.iNum =0;
	self.goodsid = 0;
end


function MapViewDialogFunctionBuilding:create(element,functionChooseLayer)
	self = MapViewDialogFunctionBuilding.new()
	self.pElement = element;
	self.functionChooseLayer = functionChooseLayer
	self:initAttr()
	return self
end

function MapViewDialogFunctionBuilding:ctor()
	self:initVar();

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewDialogFunctionBuilding.json")
    self:addChild(self.pWidget)


    self.pDialog = self.pWidget:getChildByName("Panel_quren")
    self.pDialog:setScale(0.001)

    self.pItem = self.pWidget:getChildByName("Panel_item")
    self.pItem:retain()
    self.pItem:removeFromParent()

end

function MapViewDialogFunctionBuilding:OnExit()
	self.pItem:release()
	self.pItem=nil
end

function MapViewDialogFunctionBuilding:initAttr()
	local function  fun_queding(sender,event)
		if event == ccui.TouchEventType.ended then
			self.pElement.itemID = self.itemID
			self.pElement.iNum = self.iNum
			self.pElement.goodsid = self.goodsid;
			self.functionChooseLayer:fun_functionBuilding(self.pElement);
			self.pDialog:setScale(0.001)
        end
	end

	local function fun_quxiao(sender,event)
		if event == ccui.TouchEventType.ended then
			self.pDialog:setScale(0.001)
        end
	end


	local function fun_tuichu(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local btn_cancle = self.pDialog:getChildByName("btn_cancle")
	btn_cancle:addTouchEventListener(fun_quxiao)

	local btn_ok = self.pDialog:getChildByName("btn_quren")
	btn_ok:addTouchEventListener(fun_queding)

	local btn_tuichu = self.pWidget:getChildByName("btn_tuichu")
	btn_tuichu:addTouchEventListener(fun_tuichu)

	--名称
	self.pWidget:getChildByName("lab_name"):setString(self.pElement:getNameString())	

	self:updateList()
end

function MapViewDialogFunctionBuilding:updateList()
	local function fun_item(sender,event)
		if event == ccui.TouchEventType.ended then
			self.itemID = sender.item.config.itemId
			self.iNum = sender.item.num
			self.goodsid= sender.item.goodsid;
			self:setDialogInfo(sender.item)
			self.pDialog:setScale(1)
        end
	end


	local function fun_ItemInfo(sender,event)
		if event == ccui.TouchEventType.ended then
			local id =sender.goodsid;
			local propTips = PropsAttrTips:create(id);
			self:addChild(propTips);
		end
	end

	--初始化道具信息
	local pPanelList = self.pWidget:getChildByName("Panel_itemList");
	pPanelList:removeAllChildren()
	local iRewItemNum = 0;
	for i,v in pairs(self.pElement.resList) do
		iRewItemNum=iRewItemNum+1
	end
	local _index=0;
	for i,var in pairs(self.pElement.resList) do
		local iId = (i)
		local _groupFile =mconfig.loadConfig("script/cfg/exploration/common/sellgroup");
		local _sellGroupConfig = _groupFile[iId]
		local _config = itemConfigFile[_sellGroupConfig.ItemID]
		local iNum =(_sellGroupConfig.Num)
		local price = (_sellGroupConfig.Price)

		local _item = self.pItem:clone()
		pPanelList:addChild(_item)
		local fSpace = 200;
		_item:setPositionX(290+_index*fSpace-(iRewItemNum-1)*0.5*fSpace)
		
		_item.goodsid = iId;
		local btn_buy = _item:getChildByName("btn_buy")
		btn_buy.item = _item;
		btn_buy:addTouchEventListener(fun_item)
		_item:addTouchEventListener(fun_ItemInfo);

		_item.config = _config
		_item.num = iNum


		local lab_name 		= _item:getChildByName("lab_name")
		local img_icon 		= _item:getChildByName("img_icon")
		local lab_needNum 	= _item:getChildByName("Label_10")
		local lab_num 		= _item:getChildByName("lab_num")

		lab_name:setString(_config.itemName)
		img_icon:loadTexture(_config.itemIcon)
		lab_num:setString(iNum)
		lab_needNum:setString(price)

		_index=_index+1;
	end

end


--设置对话框信息
function MapViewDialogFunctionBuilding:setDialogInfo(node)
	local lab_num = self.pDialog:getChildByName("lb_num")
	local img_icon	= self.pDialog:getChildByName("img_icon")

	lab_num:setString(node.num)
	img_icon:loadTexture(node.config.itemIcon)
	
end


------------------------------------------------------------------------------------
--连续挑战
local MVEIL_ENEMY_CON_TAB={
	
}

MVEIL_Enemy_Con_Normal = class("MVEIL_Enemy_Con_Normal",function()
	return MapViewDialogDetailInfo.new()
end,MVEIL_ENEMY_CON_TAB)

function MVEIL_Enemy_Con_Normal:ctor()

end

function MVEIL_Enemy_Con_Normal:OnExit()
	
end


function MVEIL_Enemy_Con_Normal:create(functionChooseLayer)
	self = MVEIL_Enemy_Con_Normal.new();
	self.functionChooseLayer = functionChooseLayer;
	self:initBaseAttr();
	return self;
end

function MVEIL_Enemy_Con_Normal:initAttr()
	--名称
	local _name = self.element:getNameString().."(第"..self.element.floorIndex.."层)"
	self.pLab_name:setString(_name);


	--图片
	self.pWidget:setLocalZOrder(1);
	local sp = cc.Sprite:create("res/ui/01_battleselectcha/01_bg_scene_03.png")
	self:addChild(sp);
	sp:setAnchorPoint(cc.p(0,0));
	sp:setPosition(cc.p(0,0));
	


end

-------------------------------------------------------------------------
--获取奖励提示
MVEIL_GetRewardLayer = class("MVEIL_GetRewardLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function MVEIL_GetRewardLayer:create(functionChooseLayer,element,itemID,itemNum)
	if itemID==nil then 
		return nil;
	end
	self = MVEIL_GetRewardLayer.new();
	self.functionChooseLayer = functionChooseLayer;
	self.element = element;
	self.itemID = itemID;
	self.itemNum = itemNum;
	self:initAttr();
	return self;
end

function MVEIL_GetRewardLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewGetReward.json")
    self:addChild(self.pWidget)
end

function MVEIL_GetRewardLayer:OnExit()
	-- body
end

function MVEIL_GetRewardLayer:setTextInfo(sInfo)
	self.textInfo = sInfo;
	self:setText();
end

function MVEIL_GetRewardLayer:setText()
	if self.textInfo==nil then 
		self.textInfo=""
	end
	local lab_info = self.pWidget:getChildByName("Panel_text"):getChildByName("lab_info")
	lab_info:setString(self.textInfo)
end

function MVEIL_GetRewardLayer:initAttr()

	local function fun_tuichu(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local btn_close = self.pWidget:getChildByName("btn_close")
	btn_close:addTouchEventListener(fun_tuichu)


	local lab_name = self.pWidget:getChildByName("lab_name")


	lab_name:setString(self.element:getNameString())


	local Panel_item = self.pWidget:getChildByName("Panel_item");
	local img_icon = Panel_item:getChildByName("img_icon")
	local lab_num = Panel_item:getChildByName("lab_num")
	local img_name = Panel_item:getChildByName("lab_name")

	local itemConfig = itemConfigFile[self.itemID]

	img_icon:loadTexture(itemConfig.itemIcon)
	img_name:setString(itemConfig.itemName)
	if self.itemNum == nil then 
		lab_num:setVisible(false)
	else
		lab_num:setString(self.itemNum)
	end

end

function MVEIL_GetRewardLayer:setItemVisiable(bRet)
	local Panel_item = self.pWidget:getChildByName("Panel_item");
	if bRet == false then
		Panel_item:setVisible(false);
	else
		Panel_item:setVisible(true);
	end
end


------------------------简单对话框
MVEIL_SmipleDialog = class("MVEIL_SmipleDialog",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)


function MVEIL_SmipleDialog:create(functionChooseLayer,element)
	self = MVEIL_SmipleDialog.new();
	self.functionChooseLayer = functionChooseLayer;
	self.element = element;
	self:initAttr();
	return self;
end

function MVEIL_SmipleDialog:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewSmipleDialog.json")
    self:addChild(self.pWidget)
end

function MVEIL_SmipleDialog:initAttr()
	
	local function fun_tuichu(sender,event)
		if event == ccui.TouchEventType.ended then
			self:closeLayer()
        end
	end

	local btn_close = self.pWidget:getChildByName("btn_close")
	btn_close:addTouchEventListener(fun_tuichu)


end

function MVEIL_SmipleDialog:setTextInfo(sInfo)
	self.textInfo = sInfo;
	self:setText();
end

function MVEIL_SmipleDialog:setText()
	if self.textInfo==nil then 
		self.textInfo=""
	end
	local lab_info = self.pWidget:getChildByName("lab_info")
	lab_info:setString(self.textInfo)
end

function MVEIL_SmipleDialog:setButton(funName,btnName)

	local function function_ok(sender,event)
	    if event == ccui.TouchEventType.ended then
	    	if funName~=nil then
	    		functionName(self.functionChooseLayer,sender.element)
	    	end
        	self:closeLayer()
        end
    end

    local btn_ok = self.pWidget:getChildByName("btn_ok");

    --点击事件
	btn_ok:addTouchEventListener(function_ok)
	btn_ok.element = self.element;
	if funName~=nil then 
		functionName = self.functionChooseLayer:getFunctionWithType(funName) ---函数名
	end

	if btnName~=nil then 
		btn_ok:setTitleText(btnName)
	end


end