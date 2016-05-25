
require("script/class/class_base_ui/class_base_layer")
require("script/ui/define")
require("script/ui/herolistview/equipview/equiplogic")
require("script/core/item/define")
require("script/ui/bagview/bagextendlayer")
require("script/ui/bagview/bagviewitemopdialog")
require("script/ui/publicview/hero_select_sublayer")
require("script/core/configmanager/configmanager");

local qualityConfigFile = mconfig.loadConfig("script/cfg/client/quality_basic");
local qualityEdgeConfigFile = mconfig.loadConfig("script/cfg/client/quality_edge");
require("script/ui/publicview/mainbuttonview")
----------------------------------------------------------------------------
local TB_ITEM_QUALITY = def_GetQualityType(); 	--品质常亮
local TB_ENUM_EQUIP_ATTRIBUTE_TYPE_DEF,TB_ENUM_EQUIP_ATTRIBUTE_TYPE_NAME_DEF = def_GetAttributeType();

--显示类型
local SHOW_TYPE_ALL 		=	0;		--全部
local SHOW_TYPE_EQU 		=	1;		--装备
local SHOW_TYPE_SOURCE 		=	2;		--素材
local SHOW_TYPE_HERO 		=	3;		--英灵
local SHOW_TYPE_CONS  		= 	4;		--消耗


--道具类型
local ITEM_TYPE_EQU			=	1;		--装备
local ITEM_TYPE_CONS		=	2;		--消耗品
local ITEM_TYPE_SOURCE		=	3;		--合成材料
local ITEM_TYPE_FORM		=	4;		--配方

local BAG_STATE_NORMAL 		=	1;		--普通
local BAG_STATE_SELL		=	2;		--出售
local BAG_STATE_CHAIFEN		=	3;		--拆分


--struct data
local TB_STRUCT_BAG_VIEW ={
	pLogic =nil,		--管理类
	gridItem=nil,		--道具格子item
	Panel_tableBtn,		--标签项父物体
	ScrollView_list,	--滚动层
	bmp_bagcapacity,	--容量空间

	pForgingLayer,		--锻造界面
	pComLayer,			--合成界面

	sellTab={},			--出售我物体集合
	temParentNode =nil,	--临时缓存变量
	iState = 1,			--状态

	panel_bagDate =nil,	--默认状态面板
	panel_sell =nil,	--出售状态面板

	currentItemID = nil,	--当前道具id
	currentItemIndex =nil,	--当前道具index

	selectItemIndex = nil,


	selectEffect =nil;
}

KGC_BagView = class("KGC_BagView", KGC_UI_BASE_LAYER , TB_STRUCT_BAG_VIEW)
------------------------------------------------------------------------------

function KGC_BagView:create()
    local view = KGC_BagView.new()
	view:InitAttr();
	
	return view;
end
 

function KGC_BagView:ctor()
	self.temParentNode = cc.Node:create();
	self:addChild(self.temParentNode);
	self.temParentNode:setScale(0.0001);
	self.temParentNode:setVisible(false);
	self.pLogic = KGC_BagViewLogic:getInstance();

	self.selectEffect =af_GetEffectByID(60039);
	self:addChild(self.selectEffect);
	self.selectEffect:setVisible(false);

	--第一次加载的时候解析json文件
    self:LoadScheme()
end

function KGC_BagView:OnExit()
	self.gridItem:release();
	self.gridItem=nil;
end

function KGC_BagView:LoadScheme()
	--关闭
    local function fun_close(sender,eventType)
    	if eventType==ccui.TouchEventType.ended then
    		self.pLogic:closeLayer();
        end
    end

    --出售 
    local function fun_sell(sender,eventType)
     	if eventType==ccui.TouchEventType.ended then
     		self:gotoSellState();
        end
    end

    --拆分
    local function fun_chaifen(sender,eventType)
    	if eventType==ccui.TouchEventType.ended then
    		self:gotoChaiFenState();
    	end
    end

    --确定
    local function fun_queRen(sender,eventType)
     	if eventType==ccui.TouchEventType.ended then

     		local bIsTips = self:checkIsHaveHeightLv(self.sellTab)

     		if bIsTips == false then 
     			self:batchItemOp();
	    	else
	    		local pDialog = BagViewItemOpDialog:create(self.sellTab,self);
	    		self:addChild(pDialog)
     		end

    	end
    end

    --批量选择
    local function  fun_sellItemWithType(sender,eventType)
    	if eventType==ccui.TouchEventType.ended then
    		local iType = sender.type
    		if not sender.isSelect then
    			self:batchSelectItemWithType(iType,false);
    			self:batchSelectItemWithType(iType,true);
    			sender.isSelect = true;
    			sender:getChildByName("img_select"):setVisible(true);
    		else 
    			self:batchSelectItemWithType(iType,false);
    			sender.isSelect = false;
    			sender:getChildByName("img_select"):setVisible(false);
    		end
    	end
    end

    --扩充背包容量
    local function fun_extendBag(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			local pExtendlayer = BagExtendLayer:create()
			self:addChild(pExtendlayer);
		end
  	end


	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_BAG)
    self:addChild(self.m_pLayout)

    self.Panel_tableBtn = self.m_pLayout:getChildByName("Panel_tableBtn");
    self.ScrollView_list = self.m_pLayout:getChildByName("Panel_itemList"):getChildByName("ScrollView_list")
    self.bmp_bagcapacity = self.m_pLayout:getChildByName("pnl_bagdata"):getChildByName("bmp_bagcapacity")

    local btn_close = self.m_pLayout:getChildByName("pnl_return"):getChildByName("btn_return")
    btn_close:addTouchEventListener(fun_close)

   	local btn_sell = self.m_pLayout:getChildByName("pnl_bagdata"):getChildByName("btn_sell")
   	btn_sell:addTouchEventListener(fun_sell)

   	local btn_chaifen = self.m_pLayout:getChildByName("pnl_bagdata"):getChildByName("btn_chaifen")
   	btn_chaifen:addTouchEventListener(fun_chaifen)

   	local btn_quRenSell = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("btn_sell")
   	btn_quRenSell:addTouchEventListener(fun_queRen)

   	local panel_type01 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_01")
   	panel_type01.type = TB_ITEM_QUALITY.Q_01
   	panel_type01:addTouchEventListener(fun_sellItemWithType)

   	local panel_type02 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_02")
   	panel_type02.type = TB_ITEM_QUALITY.Q_02
   	panel_type02:addTouchEventListener(fun_sellItemWithType)

   	local panel_type03 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_03")
   	panel_type03.type = TB_ITEM_QUALITY.Q_03
   	panel_type03:addTouchEventListener(fun_sellItemWithType)

   	local panel_type04 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_04")
   	panel_type04.type = TB_ITEM_QUALITY.Q_04
   	panel_type04:addTouchEventListener(fun_sellItemWithType)

    --道具格子item
    self.gridItem = self.m_pLayout:getChildByName("Panel_item")
    self.gridItem:retain();
    self.gridItem:removeFromParent();

    --默认隐藏属性信息
    local pnl_iteminfo 		= self.m_pLayout:getChildByName("pnl_iteminfo");
    pnl_iteminfo:setVisible(false);
    --默认提示无道具
    local Panel_itemInfoTips = self.m_pLayout:getChildByName("Panel_itemInfoTips");
    Panel_itemInfoTips:setVisible(true);

    
    self.panel_bagDate =self.m_pLayout:getChildByName("pnl_bagdata")
	self.panel_sell =self.m_pLayout:getChildByName("pnl_sell")

	
	--背包扩容
	local Panel_add = self.panel_bagDate:getChildByName("Panel_add")
	Panel_add:addTouchEventListener(fun_extendBag)
	
end




function KGC_BagView:InitAttr()
	local iMaxSpace = me.m_Bag:GetMaxSize();
	local iLineMax = 5;
	self.ScrollView_list:setInnerContainerSize(cc.size(750,(math.ceil(iMaxSpace/iLineMax)+1)*150))
	
	--标签项
	local function fun_tab(sender,eventType)
    	if eventType==ccui.TouchEventType.ended then
    		local index = sender:getTag();
    		if index ~= self.pLogic.m_currentTabIndex then 
    			self.pLogic.m_currentTabIndex = index;
    			--self:setCurrentTab(self.pLogic.m_currentTabIndex);
    			self:gotoNormalState();
    		end
        end
	end

	--标签页点击事件e
	local childTab = self.Panel_tableBtn:getChildren();
	for i,var in pairs(childTab) do
		var:addTouchEventListener(fun_tab)
	end

	--当前标签项
	self:gotoNormalState();

    --容量
    self:initCap();

    --创建主按钮
    self.m_pMainBtnLayer = MainButtonLayer:create()
    self:AddSubLayer(self.m_pMainBtnLayer)
end

--容量
function KGC_BagView:initCap()
	local iMax = me.m_Bag:GetMaxSize();
	local iCurrent = me.m_Bag:GetUsedSize();
	self.bmp_bagcapacity:setString(iCurrent.."/"..iMax);
end

--刷新
function KGC_BagView:updateSelf()
	if self.iState == BAG_STATE_NORMAL then
		self:setCurrentTab(self.pLogic.m_currentTabIndex);
	end
	self:initCap();
end


--批量操作
function KGC_BagView:batchItemOp()
	local iLast = self.iState;
	self.iState = BAG_STATE_NORMAL;
	--出售
	if iLast == BAG_STATE_SELL then 
		self.pLogic:reqSell(self.sellTab)
	elseif iLast == BAG_STATE_CHAIFEN then
	--拆分
		self.pLogic:reqBatchSplit(self.sellTab)
	end
	self:gotoNormalState();
end


function KGC_BagView:setCurrentTab(iIndex)
	self:setCurrentTabImage(iIndex);		--设置标签栏图片
	self:setCurrentTabItem(iIndex);		--设置内容
end

function KGC_BagView:setCurrentTabImage(iIndex)
	local childTab = self.Panel_tableBtn:getChildren();
	for i,var in pairs(childTab) do
		if var:getTag() == iIndex then 
			var:getChildByName("img_bg"):loadTexture("res/ui/06_bagandrole/06_btn_tap_01a.png");
		else
			var:getChildByName("img_bg"):loadTexture("res/ui/06_bagandrole/06_btn_tap_01.png");
		end

		local img_text = var:getChildByName("img_text");
		local tagID = var:getTag();
		if tagID== SHOW_TYPE_ALL then
			if tagID == iIndex then
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_01a.png");
			else
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_01.png");
			end
		elseif tagID ==SHOW_TYPE_EQU then 
			if tagID == iIndex then
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_02a.png");
			else
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_02.png");
			end
		elseif tagID ==SHOW_TYPE_SOURCE then 
			if tagID == iIndex then
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_03a.png");
			else
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_03.png");
			end
		elseif tagID == SHOW_TYPE_HERO then
			if tagID == iIndex then
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_hero_04a.png");
			else
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_hero_04.png");
			end

		elseif tagID == SHOW_TYPE_CONS then
			if tagID == iIndex then
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_05a.png");
			else
				img_text:loadTexture("res/ui/06_bagandrole/06_txt_equip_05.png");
			end
		end

	end

end


function KGC_BagView:setCurrentTabItem(iIndex)

	local function fun_item(sender,eventType)
		if eventType==ccui.TouchEventType.ended then

			if self.iState == BAG_STATE_NORMAL then
				self:setCurrentItem(sender)
				--sender:setScale(1);
			elseif self.iState == BAG_STATE_SELL then
				self:addCurrentItemOpNum(sender);
				sender:stopAllActions();
			elseif self.iState == BAG_STATE_CHAIFEN then
				self:addCurrentItemOpNum(sender);
				sender:stopAllActions();
			end

		elseif eventType == ccui.TouchEventType.began then 
			if self.iState ~= BAG_STATE_NORMAL then 
				sender:stopAllActions();
				local function fun_callback(pNode,tab)
					self:addOperactionNumWithLoop(pNode,tab)
				end
				local pCallfun = cc.CallFunc:create(fun_callback,{})
				local pAction =cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1),pCallfun))
				sender:runAction(pAction);
			else
				--sender:runAction(cc.ScaleTo:create(0.1,1.1));
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.iState == BAG_STATE_NORMAL then
				--sender:setScale(1);
			elseif self.iState == BAG_STATE_SELL then
				sender:stopAllActions();
			elseif self.iState == BAG_STATE_CHAIFEN then
				sender:stopAllActions();
			end
		end
	end

	--减少所选物体的操作数量
	local function fun_subItemOpNum(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			if self.iState == BAG_STATE_NORMAL then 		--普通

			elseif self.iState == BAG_STATE_SELL then 		--出售
				self:subCurrentItemOpNum(sender:getParent())
			elseif self.iState == BAG_STATE_CHAIFEN then 	--拆分
				self:subCurrentItemOpNum(sender:getParent())
			end
		end
	end

	--背包排序
	local function fun_bagItemOrder(bagTab)

		local equiping = 10000;		--是否已装备
		local quality  = 1000;		--品质

		local function fun_orderLogic(a,b)

			local aValue = 0;
			local bValue = 0;

			if a:IsEquip() then 
				aValue=aValue+equiping;
			end

			if b:IsEquip() then 
				bValue = bValue + equiping;
			end

			if a:GetQuality() > b:GetQuality() then 
				aValue = aValue+ quality;
			elseif a:GetQuality() < b:GetQuality() then
				bValue = bValue+ quality;
			end


			if aValue == bValue then 
				--容错
				if a:GetIndex()>b:GetIndex() then 
					return true;
				else 
					return false;
				end
			end

			if aValue>bValue then 
				return true;
			else
				return false;
			end
		end


		table.sort(bagTab,fun_orderLogic)  

	end


	--缓存之前的物体
	local _exitChildTb = self.ScrollView_list:getChildren();
	for i,v in pairs(_exitChildTb) do
		v:setPosition(cc.p(0,0));
		v:retain();
		v:removeFromParent();
		self.temParentNode:addChild(v);
		v:release();
	end

	-- body
	local bIDisplayCurrentItem=false;  --是否显示当前物体
	--所有背包的物品
	local bgTb = me.m_Bag:GetItems();
	--排序
	fun_bagItemOrder(bgTb);

	local posIndex =0;
	local scorllHeight = self.ScrollView_list:getInnerContainerSize().height;

	local firstItme =nil;
	for i,var in pairs(bgTb) do

		local bDisplay =true;

		--是否符合标签类型
		if var:GetshowType() ~= iIndex and iIndex ~=SHOW_TYPE_ALL then 
			bDisplay=false;
		end

		--出售状态判定
		if self.iState == BAG_STATE_SELL then 
			if var:GetIsAbleSell() ==false then 
				bDisplay=false;
			end
			--如果是装备面板，则要判断装备是否穿在身上
			if iIndex == SHOW_TYPE_EQU then 
				if var:IsEquip() then 
					bDisplay = false;
				end	
			end
		--拆分状态判定
		elseif self.iState == BAG_STATE_CHAIFEN then
			if var:isAbleSplit() == false then 
				bDisplay = false;
			end
			--如果是装备面板，则要判断装备是否穿在身上
			if iIndex == SHOW_TYPE_EQU then 
				if var:IsEquip() then 
					bDisplay = false;
				end	
			end
		end




		if bDisplay then
			local needGird = var:GetGirdSpace();
			local allNum = var:GetNum();
			for i=1,needGird do
				local pItem = nil;
				--先找缓存
				pItem= self.temParentNode:getChildren()[1];
				--找不到就新建
				if pItem == nil then 
					 pItem = self.gridItem:clone();
				end
				pItem.data = var
				pItem:retain();
				if pItem:getParent() then 
					pItem:removeFromParent();
				end
				self.ScrollView_list:addChild(pItem);
				pItem:release();
				pItem:addTouchEventListener(fun_item)  --触摸事件

				pItem.id = var:GetID();
				pItem.idIndex = needGird;

				--位置
				local ibaseX 	= 10
				local ispaceX 	= 148
				local ispaceY 	= 148
				local posX = posIndex%5*ispaceX+ibaseX;
				local posY = scorllHeight-(math.floor(posIndex/5)+1)*ispaceY
				pItem:setPosition(cc.p(posX,posY));

				--已装备tips
				local imgTips = pItem:getChildByName("img_tips")
				if var:IsEquip() then 
					imgTips:setVisible(true)
					-- local _hero = me:GetHeroByEquipSuit(var:GetSuit())
					-- if _hero~=nil then 
					-- 	local _,imgTab = _hero:GetHeadIcon();
					-- 	imgTips:loadTexture(imgTab)
					-- end
				else
					imgTips:setVisible(false)
				end

						--如果是碎片要加遮罩（怎么想的。。。。）
				if var:GetTypeDetail() == 20 then
					pItem:getChildByName("img_mask"):setVisible(true);
				else
					pItem:getChildByName("img_mask"):setVisible(false);
				end		

				--图标
				local imgIcon = pItem:getChildByName("img_icon");
				imgIcon:loadTexture(var:GetIcon());

				--品质
				local imgQuliaty = pItem:getChildByName("img_pinzhi");
				local iQuality = var:GetQuality();
				if var:GetTypeGenre() == ITEM_TYPE_EQU then 
					-- --如果是装备
					local qualityKey = "qualitytype"..iQuality;
					imgQuliaty:loadTexture(qualityEdgeConfigFile[1][qualityKey]);
				else
					--如果是其他物品			
					local qualityKey = "qualitytype"..iQuality;
					imgQuliaty:loadTexture(qualityEdgeConfigFile[2][qualityKey]);	
				end


				--星级
				local panel_Star = pItem:getChildByName("Panel_star")
				if var:GetTypeGenre() == ITEM_TYPE_EQU then 
					panel_Star:setVisible(true)
					local iStar = var:GetStars();
					self:setStarImage(panel_Star,iStar,var:GetQuality())
				else
					panel_Star:setVisible(false);
				end

				--按钮
				local btn_select = pItem:getChildByName("btn_select")
				btn_select:setVisible(false);
				btn_select:setScale(0.0001);
				btn_select:addTouchEventListener(fun_subItemOpNum);


				--选中提示
				local panel_selectTips = pItem:getChildByName("Panel_select")
				panel_selectTips:setVisible(false);

				--数量
				local lab_num = pItem:getChildByName("lab_num")
				if var:GetTypeGenre() == ITEM_TYPE_EQU then 
					lab_num:setVisible(false); --装备类型不显示数量
					pItem.num=1;
				else
					local _num = allNum
					if allNum>var:GetstackMax() then 
						_num = var:GetstackMax();
					end
					lab_num:setString(_num)
					pItem.num=_num;
					lab_num:setVisible(true)
				end


				pItem.opNum =0;  --操作数量

				allNum = allNum - var:GetstackMax();
				posIndex=posIndex+1;		


				--更新当前显示的道具
				if 	pItem.id ==self.currentItemID and
						pItem.idIndex == self.currentItemIndex then
					self:setCurrentItem(pItem);
					bIDisplayCurrentItem = true
				end

				--保存第一个数据
				if firstItme == nil then 
					firstItme = pItem;
				end
			end

		else
			--不显示
		end
	end

	if bIDisplayCurrentItem == false then 
		if firstItme~=nil then  
			self:setCurrentItem(firstItme);
		else
			self.m_pLayout:getChildByName("pnl_iteminfo"):setVisible(false);
			self.m_pLayout:getChildByName("Panel_itemInfoTips"):setVisible(true);
		end
	end	

	self.ScrollView_list:jumpToTop();
end


function KGC_BagView:gotoNormalState()
	self.iState = BAG_STATE_NORMAL;
	self:setCurrentTab(self.pLogic.m_currentTabIndex)

	self.panel_bagDate:setScale(1);
	self.panel_bagDate:setVisible(true);
	self.panel_sell:setScale(0.001);
	self.panel_sell:setVisible(false);

	self:cleanOperationDate();

	self.sellTab={}; --清空	
end

function KGC_BagView:gotoSellState()
	self.iState = BAG_STATE_SELL;
	self:setCurrentTab(self.pLogic.m_currentTabIndex)
	self.sellTab={};
	self.panel_bagDate:setScale(0.001);
	self.panel_bagDate:setVisible(false);
	self.panel_sell:setScale(1);
	self.panel_sell:setVisible(true);

	self.sellTab={}; --清空		
end

function KGC_BagView:gotoChaiFenState()
	self.iState = BAG_STATE_CHAIFEN;
	self:setCurrentTab(self.pLogic.m_currentTabIndex)
	self.sellTab={};
	self.panel_bagDate:setScale(0.001);
	self.panel_bagDate:setVisible(false);
	self.panel_sell:setScale(1);
	self.panel_sell:setVisible(true);	

	self.sellTab={}; --清空	
end

function KGC_BagView:cleanOperationDate()

   	local panel_type01 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_01")
   	panel_type01.isSelect = false;
   	panel_type01:getChildByName("img_select"):setVisible(false);

   	local panel_type02 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_02")
   	panel_type02.isSelect = false;
   	panel_type02:getChildByName("img_select"):setVisible(false);

   	local panel_type03 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_03")
   	panel_type03.isSelect = false;
	panel_type03:getChildByName("img_select"):setVisible(false);

   	local panel_type04 = self.m_pLayout:getChildByName("pnl_sell"):getChildByName("Panel_04")
   	panel_type04.isSelect = false;
	panel_type04:getChildByName("img_select"):setVisible(false);
end

--更新当前显示的道具
function KGC_BagView:updateCurrentItem()



end


--设置当前所选的道具属性显示
function KGC_BagView:setCurrentItem(itemWidget)
	self.selectEffect:setPosition(cc.p(65,65));
	self.selectEffect:retain();
	self.selectEffect:removeFromParent();
	itemWidget:getChildByName("Panel_selectEffect"):addChild(self.selectEffect);
	self.selectEffect:release();
	if self.iState == BAG_STATE_NORMAL then 
		self.selectEffect:setVisible(true);
	else
		self.selectEffect:setVisible(false);
	end
	

	self.currentItemID = itemWidget.id;
	self.currentItemIndex =itemWidget.idIndex;

	local itemDate = itemWidget.data
	local itemWidgetNum = itemWidget.num
	--使用
	local function fun_use(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			self:fun_use(itemDate)
		end
	end


	--拆分
	local function fun_split(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			self:fun_split(itemDate);
		end

	end

	--合成
	local function fun_comp(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			self:fun_comp(itemDate);
		end

	end

	--打造
	local function fun_build(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			self:fun_build(itemDate);
		end
	end

	--强化
	local function fun_streng(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			self:fun_streng(itemDate)
		end

	end

	--来源
	local function fun_source(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			
		end
	end

	--类型
	local iItemType = itemDate:GetTypeGenre();
	local iQuality = itemDate:GetQuality();

	local pnl_iteminfo 		= self.m_pLayout:getChildByName("pnl_iteminfo");
	local Panel_icon 		= pnl_iteminfo:getChildByName("Panel_icon")
	local Panel_info 		= pnl_iteminfo:getChildByName("Panel_info")

	local Panel_item   		= Panel_info:getChildByName("Panel_item")
	local Panel_equ 		= Panel_info:getChildByName("Panel_equ")

	local lab_num 			= Panel_icon:getChildByName("Label_6")					--文字
	local img_itemicon  	= Panel_icon:getChildByName("img_itemicon")				--icon
	local imgQuliaty 		= Panel_icon:getChildByName("img_itemiconbg")			--品质
	local img_tips 			= Panel_icon:getChildByName("img_tips")					--已装备tips
	local Panel_star        = Panel_icon:getChildByName("Panel_star")				--星级

	local la_name 			=	Panel_info:getChildByName("lab_name")				--名字
	local lab_lv 			=	Panel_info:getChildByName("lab_lv")					--等级
	local lab_fight 		=	Panel_info:getChildByName("lab_fight")				--战斗力


	local btn01 = pnl_iteminfo:getChildByName("btn01")						--功能按钮01
	local btn02 = pnl_iteminfo:getChildByName("btn02")						--功能按钮02

	pnl_iteminfo:setVisible(true);
	self.m_pLayout:getChildByName("Panel_itemInfoTips"):setVisible(false);

	lab_num:setString(itemWidgetNum);
	img_itemicon:loadTexture(itemDate:GetIcon());
	la_name:setString(itemDate:GetName());
	la_name:setColor(itemDate:getTextColor())

	lab_num:setVisible(true);
	img_tips:setVisible(true);
	lab_lv:setVisible(true);
	lab_fight:setVisible(true);

	if iItemType == ITEM_TYPE_EQU then
		--如果是装备 
		lab_num:setVisible(false);
		if itemDate:IsEquip() then 
			img_tips:setVisible(true)
		else
			img_tips:setVisible(false)
		end

		Panel_item:setVisible(false);
		Panel_item:setScale(0.0001)
		Panel_equ:setVisible(true);
		Panel_equ:setScale(1)
		Panel_star:setScale(1);
		Panel_star:setVisible(true);

		--团队等级
		lab_lv:setString("(团队等级："..itemDate:GetTeamLvLimit()..")");
		--战斗力
		lab_fight:setString("战斗力："..itemDate:GetFightPoint());

		-- --如果是装备
		local qualityKey = "qualitytype"..iQuality;
		imgQuliaty:loadTexture(qualityEdgeConfigFile[1][qualityKey]);


		local ScrollView_list = Panel_equ:getChildByName("ScrollView_list")
		ScrollView_list:removeAllChildren();

		local Panel_attr_info = Panel_equ:getChildByName("Panel_attr_info")
		local Panel_attr_text = Panel_equ:getChildByName("Panel_attr_text")
		Panel_attr_info:setVisible(false);
		Panel_attr_text:setVisible(false);

		local iStar = itemDate:GetStars();
		self:setStarImage(Panel_star,iStar,itemDate:GetQuality())

		local pAddAttr = itemDate:GetAttributes()
		local scorllHeight =  ScrollView_list:getInnerContainerSize().height;

		--基础属性
		local _attr_NameItem = Panel_attr_info:clone();
		_attr_NameItem:setVisible(true)
		ScrollView_list:addChild(_attr_NameItem)
		_attr_NameItem:setPosition(cc.p(0,scorllHeight-40));
		self:setAttrNameAndValue(_attr_NameItem:getChildByName("lab_name"),
									_attr_NameItem:getChildByName("lab_value"),
									itemDate:GetAttrNameAndValue().type,
									itemDate:GetAttrNameAndValue().num);

		--附加属性
		local posIndex=0;
		for k,v in pairs(pAddAttr) do
			local attr_NameItem = Panel_attr_info:clone();
			attr_NameItem:setVisible(true)
			local ibaseX 	= 0
			local ibaseY    = 80;
			local ispaceX 	= 250
			local ispaceY 	= 40
			local posX = posIndex%2*ispaceX+ibaseX;
			local posY = scorllHeight-(math.floor(posIndex/2))*ispaceY-ibaseY;
			attr_NameItem:setPosition(cc.p(posX,posY));	
			ScrollView_list:addChild(attr_NameItem)

			self:setAttrNameAndValue(attr_NameItem:getChildByName("lab_name"),
										attr_NameItem:getChildByName("lab_value"),
										v[1],
										v[2]);

			posIndex=posIndex+1;		
		end

		--描述
		local pAttr_text = Panel_attr_text:clone();
		pAttr_text:setVisible(true)
		local lab_text = pAttr_text:getChildByName("lab_info")
		lab_text:setString(itemDate:GetText())
		ScrollView_list:addChild(pAttr_text)
		pAttr_text:setPosition(cc.p(0,80))

		ScrollView_list:jumpToTop();
	else 								--如果不是装备
		img_tips:setVisible(false);
		lab_lv:setVisible(false);
		lab_fight:setVisible(false);
		Panel_item:setVisible(true);
		Panel_item:setScale(1)
		Panel_equ:setVisible(false);
		Panel_equ:setScale(0.0001)
		Panel_star:setScale(0.001);
		Panel_star:setVisible(false);

		--如果是其他物品			
		local qualityKey = "qualitytype"..iQuality;
		imgQuliaty:loadTexture(qualityEdgeConfigFile[2][qualityKey]);	

		--说明
		local ScrollView_list 	=	Panel_item:getChildByName("ScrollView_list")
		local lab_info 			=	ScrollView_list:getChildByName("lab_info")
		lab_info:setString(itemDate:GetText())


		ScrollView_list:jumpToTop();
	end


	btn01:setTouchEnabled(true)
	btn01:setVisible(true)
	btn02:setTouchEnabled(true)
	btn02:setVisible(true)

	--如果是碎片要加遮罩（怎么想的。。。。）
	if itemDate:GetTypeDetail() == 20 then 
		Panel_icon:getChildByName("img_mask"):setVisible(true);
	else
		Panel_icon:getChildByName("img_mask"):setVisible(false);
	end

	--根据类型决定功能按钮
	if iItemType == ITEM_TYPE_EQU then
		--装备
		btn01:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_dismantling_01.png");
		btn02:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_upgrade_01.png");
		btn01:addTouchEventListener(fun_split)
		btn02:addTouchEventListener(fun_streng)

		if itemDate:IsAbleSplit() == false then 
			btn01:setVisible(false)
			btn01:setTouchEnabled(false);
		end

	elseif iItemType == ITEM_TYPE_CONS then 
		--消耗品
		btn01:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_use_01.png");
		btn02:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_comefrom_01.png");
		btn01:addTouchEventListener(fun_use)
		btn02:addTouchEventListener(fun_source)

		--如果不能使用
		if itemDate:GetIsAbleUse() ==false then 
			btn01:setVisible(false)
			btn01:setTouchEnabled(false);
		end

	elseif iItemType == ITEM_TYPE_SOURCE then
		--合成材料
		btn01:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_fuse_01.png");
		btn02:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_comefrom_01.png");		
		btn01:addTouchEventListener(fun_comp)
		btn02:addTouchEventListener(fun_source)


		--如果不能合成
		if itemDate:GetComposeTarget() == 0 then 
			btn01:setVisible(false)
			btn01:setTouchEnabled(false);
		end

	elseif iItemType == ITEM_TYPE_FORM then
		--配方
		btn01:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_fuse_01.png");
		btn02:getChildByName("img_btnicon"):loadTexture("res/ui/06_bagandrole/06_txt_forg_01.png");				
		btn01:addTouchEventListener(fun_comp)
		btn02:addTouchEventListener(fun_build)

		--如果不能合成
		if itemDate:GetComposeTarget() == 0 then 
			btn01:setVisible(false)
			btn01:setTouchEnabled(false);
		end

		--如果不能打造
		if itemDate:GetIsAbleMake() == false then 
			btn02:setVisible(false);
			btn02:setTouchEnabled(false);
		end

	end

end

--设定当前道具的操作
function KGC_BagView:addCurrentItemOpNum(itemWidget)
	local sellTips = itemWidget:getChildByName("Panel_select")
	local btn_sub = itemWidget:getChildByName("btn_select")
	local bDisplay = not btn_sub:isVisible()
	local _addNum=1;

	btn_sub:setVisible(true);

	sellTips:setVisible(false);

	if bDisplay ==true then 					--证明是第一次操作
		itemWidget.opNum = 1; --操作数量
		btn_sub:setVisible(true);
		btn_sub:setScale(1);
		itemWidget:getChildByName("lab_num"):setVisible(false);
	else
		itemWidget.opNum = itemWidget.opNum+_addNum; --不是第一次操作
	end

	if itemWidget.opNum > itemWidget.num then
		_addNum=0;
	end

	if itemWidget.opNum >= itemWidget.num then
		sellTips:setVisible(true);
		itemWidget.opNum = itemWidget.num;
	end

	local labNum = btn_sub:getChildByName("lab_num");
	labNum:setString(itemWidget.opNum.."/"..itemWidget.num)

	if self.sellTab[tostring(itemWidget.data:GetIndex())] ~= nil then		
		self.sellTab[tostring(itemWidget.data:GetIndex())] = self.sellTab[tostring(itemWidget.data:GetIndex())]+_addNum	
	else
		self.sellTab[tostring(itemWidget.data:GetIndex())] =1
	end
end

--减少当前装备的草操作数量
function KGC_BagView:subCurrentItemOpNum(itemWidget)
	local sellTips = itemWidget:getChildByName("Panel_select")
	local btn_sub = itemWidget:getChildByName("btn_select")

	itemWidget.opNum = itemWidget.opNum - 1;

	if itemWidget.opNum <= 0 then 
		btn_sub:setVisible(false);
		btn_sub:setScale(0.0001);
		itemWidget:getChildByName("lab_num"):setVisible(true);
	else
		local labNum = btn_sub:getChildByName("lab_num");
		labNum:setString(itemWidget.opNum.."/"..itemWidget.num)
	end

	if self.sellTab[tostring(itemWidget.data:GetIndex())] ~= nil then 
		self.sellTab[tostring(itemWidget.data:GetIndex())] = self.sellTab[tostring(itemWidget.data:GetIndex())]-1;
		if self.sellTab[tostring(itemWidget.data:GetIndex())]<=0 then
			self.sellTab[tostring(itemWidget.data:GetIndex())] = nil
		end
	end
	
	sellTips:setVisible(false);
end

--设置星级显示
function KGC_BagView:setStarImage(pPanel,istar,iQuality)
	local pChildTb = pPanel:getChildren();
	for k,v in pairs(pChildTb) do
		v:setVisible(false);
		if iQuality~=nil then 
			v:loadTexture(qualityConfigFile[iQuality].star)
		end
	end

	for i=1,istar do
		pChildTb[i]:setVisible(true)
	end
end


--批量选择指定类型的道具
function KGC_BagView:batchSelectItemWithType(iType,bRet)
	local allChild= self.ScrollView_list:getChildren();
	for k,itemWidget in pairs(allChild) do
		if itemWidget.data:GetQuality() == iType then
			local sellTips = itemWidget:getChildByName("Panel_select")
			local btn_sub = itemWidget:getChildByName("btn_select")

			if bRet == true then 
			--出售
				btn_sub:setVisible(true);
				btn_sub:setScale(1);
				sellTips:setVisible(true);
				itemWidget:getChildByName("lab_num"):setVisible(false);
				itemWidget.opNum = itemWidget.num

				local labNum = btn_sub:getChildByName("lab_num");
				labNum:setString(itemWidget.opNum.."/"..itemWidget.num)
				local oldValue = self.sellTab[tostring(itemWidget.data:GetIndex())]
				if oldValue == nil then 
					self.sellTab[tostring(itemWidget.data:GetIndex())] = itemWidget.opNum
				else
					self.sellTab[tostring(itemWidget.data:GetIndex())] = itemWidget.opNum + oldValue
				end
				
			else
			--不出售
				btn_sub:setVisible(false);
				btn_sub:setScale(0.0001);
				sellTips:setVisible(false);
				self.sellTab[tostring(itemWidget.data:GetIndex())] =nil
			end
		end
	end
end

--周期性增加所选择的道具
function KGC_BagView:addOperactionNumWithLoop(pNode,tab)
	self:addCurrentItemOpNum(pNode);
end


--设置属性名字和属性值 
function KGC_BagView:setAttrNameAndValue(plabName,plabValue,iType,iValue)
	local _text = TB_ENUM_EQUIP_ATTRIBUTE_TYPE_NAME_DEF[iType]
	plabName:setString(_text..":")
	plabValue:setString(iValue);
end

--检测是否含有紫色品质以上的道具
function KGC_BagView:checkIsHaveHeightLv(pTab)
	for k,v in pairs(pTab) do
		if me.m_Bag:GetItemByIndex(k):GetQuality()>=TB_ITEM_QUALITY.Q_04 then
			return true
		end
	end

	return false;
end


--@function: 打开拆分收益界面
-- function KGC_BagView:OnSplitCallBack(tbItems, nGold)
	-- local layout = KGC_UI_EQUIP_SPLIT_LAYER_TYPE:create(self)
	-- layout:UpdateData(tbItems, nGold)
-- end

--------------------------------------道具功能函数----------------------------------
--使用
function KGC_BagView:fun_use(itemDate)
	KGC_BagViewLogic:getInstance():UseItem(itemDate:GetIndex());
end

--拆分
function KGC_BagView:fun_split(itemDate)
	local tbList = {itemDate:GetIndex()}
	KGC_BagViewLogic:getInstance():reqSplit(tbList);
end

--合成
function KGC_BagView:fun_comp(itemDate)
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_ITEMCOM,itemDate:GetID())
end

--打造
function KGC_BagView:fun_build(itemDate)
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FORGING,itemDate:GetID())
end

--强化
function KGC_BagView:fun_streng(itemDate)
	KGC_EQUIP_LOGIC_TYPE:getInstance():SetSelectedEquip(itemDate)
	KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(2, self)
end

--来源
function KGC_BagView:fun_source()
	-- body
end