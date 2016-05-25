--锻造界面
require("script/class/class_base_ui/class_base_layer")
require("script/ui/publicview/itemoperation/itemselectlayer")
require("script/core/item/define")
require("script/ui/forgingview/forgingitemtips")
require("script/core/configmanager/configmanager");

local makeConfigFile = require("script/cfg/equip/make")
local itemConfigFile = mconfig.loadConfig("script/cfg/pick/item")

local TB_ENUM_ITEM_TYPE_GENRE_DEF ,TB_ENUM_ITEM_TYPE_DETAIL_DEF= def_GetItemType();
local TB_ITEM_QUALITY = def_GetQualityType();

local TB_FORGING_LAYER={
    pLogic,
    pPanel_matItem          =   nil,
    pPanel_targetItem       =   nil,
    pScrollView_target      =   nil,
    pScrollView_mat         =   nil,
    pOpTab                  =   nil,

    iEqCount = 0,       --当前打造的装备数量
}

ForgingLayer = class("ForgingLayer",function()
    return KGC_UI_BASE_LAYER:create()
end,TB_FORGING_LAYER)

function ForgingLayer:create()
	self = ForgingLayer.new();
	self:initAttr();
	return self;
end

function ForgingLayer:OnExit()
    self.pPanel_matItem:release();
    self.pPanel_matItem=nil;

    self.pPanel_targetItem:release();
    self.pPanel_targetItem=nil;

end

function ForgingLayer:ctor()
    self.pLogic = ForgingLogic:getInstance();
    self.pOpTab = {};
	--关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/forgingView.json")
    self:addChild(self.pWidget)

    local btn_close = self.pWidget:getChildByName("btn_close")  	--关闭按钮
    btn_close:addTouchEventListener(fun_close)


    self.pPanel_matItem = self.pWidget:getChildByName("Panel_matItem")
    self.pPanel_matItem:retain();
    self.pPanel_matItem:removeFromParent();

    self.pPanel_targetItem = self.pWidget:getChildByName("Panel_targetItem")
    self.pPanel_targetItem:retain();
    self.pPanel_targetItem:removeFromParent();

    self.pScrollView_target      =   self.pWidget:getChildByName("ScrollView_target");
    self.pScrollView_mat         =   self.pWidget:getChildByName("ScrollView_mat");

    --创建主按钮
    self.m_pMainBtnLayer = MainButtonLayer:create()
    self:AddSubLayer(self.m_pMainBtnLayer)
end

--重建更新（待优化）
function ForgingLayer:cleanLayer()
    self.pScrollView_target:removeAllChildren();
    self.pScrollView_mat:removeAllChildren();

    self:initAttr();
end

function ForgingLayer:cleanDate()
    -- body
    self.pOpTab ={};
    self.pLogic.resTab={};
    self.pLogic.bookTab={};
end

function ForgingLayer:initAttr()
	self:cleanDate();
    --锻造
    local function fun_forging(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:forging();
        end
    end

    --自动打造
    local function fun_autoForging(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:autoSelectOp();
        end
    end

    --tips
    local function fun_tips(sender,eventType)
         if eventType==ccui.TouchEventType.ended then
            local pTips = ForgingItemTips:create(sender.id);
            self:addChild(pTips);
        end
    end

    --减少
    local function fun_subCount(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:subOpCount(sender:getParent());
        end
    end

    --增加
    local function fun_addCount(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:addOpCount(sender);
        end
    end

    --排序
    local function fun_order(a,b)
        if makeConfigFile[a].sort >  makeConfigFile[b].sort then 
            return true
        end
        return false;
    end


    local btn_forging =self.pWidget:getChildByName("btn_dazao");
    btn_forging:addTouchEventListener(fun_forging)

    local btn_autoForging = self.pWidget:getChildByName("btn_dazaoAuto")
    btn_autoForging:addTouchEventListener(fun_autoForging);


    local _forgTab ={}
    for k,v in pairs(makeConfigFile) do
        local _var = me.m_Bag:GetItemByID(tonumber(k));
        if _var~=  nil then
            table.insert(_forgTab,k);
        end
    end

    --排序
    table.sort(_forgTab,fun_order) 


    self.pScrollView_target:setInnerContainerSize(cc.size(725,(math.ceil(table.getn(_forgTab)/3))*320+50))

    local posIndex =0;
    local scorllHeight = self.pScrollView_target:getInnerContainerSize().height;    
    for k,v in pairs(_forgTab) do
        local forgingID = v;
        local equID = makeConfigFile[forgingID].eqScroll[1][1];
        local itemInfo = me.m_Bag:GetItemByID(forgingID);
        local _item = self.pPanel_targetItem:clone();
        self.pScrollView_target:addChild(_item);

        local ibaseX    = 20
        local ispaceX   = 235
        local ispaceY   = 320
        local posX = posIndex%3*ispaceX+ibaseX;
        local posY = scorllHeight-(math.floor(posIndex/3)+1)*ispaceY;    
        _item:setPosition(posX,posY);

        --名称
        local labName = _item:getChildByName("lab_name")
        labName:setString(itemInfo:GetName())

        --icon
        local imgIcon = _item:getChildByName("img_icon")
        --品质
        local imgQuliaty = _item:getChildByName("img_pinzhi")

        self:fun_setItemImage(imgIcon,imgQuliaty,equID);

        --操作次数
        local TextBMFont = _item:getChildByName("BitmapLabel_count")
        TextBMFont:setVisible(false);

        --减少按钮
        local btn_subCount = _item:getChildByName("btn_sub")
        btn_subCount:addTouchEventListener(fun_subCount);
        btn_subCount:setVisible(false);
        btn_subCount:setTouchEnabled(false);

        --tips按钮
        local btn_tipsCount = _item:getChildByName("btn_tips")
        btn_tipsCount.id = forgingID;
        btn_tipsCount:addTouchEventListener(fun_tips)

        --增加按钮
        _item:addTouchEventListener(fun_addCount)

        -----------------------------
        --合成卷轴
        local Panel_matitem = _item:getChildByName("Panel_matitem")
        local comImgIcon  = Panel_matitem:getChildByName("img_icon")
        local comImgQuality  = Panel_matitem:getChildByName("img_quality")
        local comTextBMFont = Panel_matitem:getChildByName("BitmapLabel_count")
        comTextBMFont:setString("X"..1)
        self:fun_setItemImage(comImgIcon,comImgQuality,forgingID);
        --需求物品
        for i,var in pairs(makeConfigFile[forgingID].data1) do
            local _mitID = var[1]
            local _mitNum = var[2]
            local _mitItem = Panel_matitem:clone();
            local _mitImgIcon  = _mitItem:getChildByName("img_icon")
            local _mitImgQuality  = _mitItem:getChildByName("img_quality")
            local _mitTextBMFont = _mitItem:getChildByName("BitmapLabel_count")

            _mitTextBMFont:setString("X".._mitNum)
            self:fun_setItemImage(_mitImgIcon,_mitImgQuality,_mitID);

            Panel_matitem:getParent():addChild(_mitItem)
            _mitItem:setPositionX(_mitItem:getPositionX()+i*60)
        end


        --检测所需物品是否足够
        local bEnough = true;   --是否足够
        local iNum = -1;         --可合成的数量
        for i,var in pairs(makeConfigFile[forgingID].data1) do
            local _mitID = var[1]
            local _mitNum = var[2]
            local neeItem = me.m_Bag:GetItemByID(_mitID);
            if neeItem == nil or
                neeItem:GetNum()<_mitNum then 
                bEnough = false;
            else
                if math.floor(neeItem:GetNum()/_mitNum) < iNum 
                       or iNum == -1 then 
                    iNum = math.floor(neeItem:GetNum()/_mitNum);
                end
            end
        end

        if itemInfo:GetNum()<iNum then 
            iNum = itemInfo:GetNum();
        end

        _item.maxNum = iNum;        --可操作的最大的数量       
        _item.currentNum = 0;       --当前操作的数量

        local Panel_mask01 = _item:getChildByName("Panel_mask01");
        local Panel_mask02 = _item:getChildByName("Panel_mask02");
        if bEnough == true then 
            Panel_mask01:setVisible(false);
            Panel_mask02:setVisible(false);
             _item:setTouchEnabled(true);   
        else
            Panel_mask01:setVisible(false);
            Panel_mask02:setVisible(true);
            _item:setTouchEnabled(false);           
        end

        _item.date = itemInfo;
        posIndex=posIndex+1;
    end

end


function ForgingLayer:forging()
    local _num = 0 
    for k,v in pairs(self.pOpTab) do
        _num=_num+1
    end

    if self.pOpTab == nil or _num==0 then
        TipsViewLogic:getInstance():addMessageTips(11009);
        return;
    end

    self.pLogic.bookTab = self.pOpTab;
    local _retTab ={};      --服务端协议需要这个格式，所以这边转一下
    for k,v in pairs(self.pOpTab) do
        for i=1,v do
            table.insert(_retTab,k)
        end
    end

    self.iEqCount =0;
    --请求打造协议
    ForgingLogic:getInstance():reqForging(_retTab);
end


--检测是否可打造指定数量的
function ForgingLayer:checkResIsEnough(forgingID,iNum)

    local function fun_getUseResNum(id)
        for k,v in pairs(self.pLogic.resTab) do
            if k==id then
                return v;
            end
        end

        return 0;
    end


    for i,var in pairs(makeConfigFile[tonumber(forgingID)].data1) do
        local _mitID = var[1]
        local _mitNum = var[2]
        local neeItem = me.m_Bag:GetItemByID(_mitID);
        if neeItem == nil or
            neeItem:GetNum()-fun_getUseResNum(_mitID)<_mitNum then 
            return false;
        end
    end

    return true;
end

function ForgingLayer:updateList()
    local childTab = self.pScrollView_target:getChildren();

    for k,v in pairs(childTab) do
        local forginID = v.date:GetIndex();
        local Panel_mask01 = v:getChildByName("Panel_mask01");
        local Panel_mask02 = v:getChildByName("Panel_mask02");
        if self:checkResIsEnough(forginID,1) then
            Panel_mask02:setVisible(false);
        else
            Panel_mask02:setVisible(true);
        end
    end
end

--自动选择（自动打造）
function ForgingLayer:autoSelectOp()
    local childTab = self.pScrollView_target:getChildren();

    --先清空
    for k,v in pairs(childTab) do
        for i=1,v.maxNum do
            self:subOpCount(v);
        end
    end

    for k,v in pairs(childTab) do
        for i=1,v.maxNum do
            self:addOpCount(v);
            if self.iEqCount>=5 then 
                return;
            end
        end
    end
end


function ForgingLayer:addOpCount(itemWidget)

    if self.iEqCount>=5 then
        TipsViewLogic:getInstance():addMessageTips(14000)
        return;
    end

    --检测资源是否够
    if self:checkResIsEnough(itemWidget.date:GetIndex(),itemWidget.currentNum+1)  == false then 
        return
    end

    --不能超过最大个数
    if itemWidget.currentNum>=itemWidget.maxNum then 
        return;
    end    

    self.iEqCount = self.iEqCount+1;

    local btn_sub = itemWidget:getChildByName("btn_sub")
    btn_sub:setVisible(true);
    btn_sub:setTouchEnabled(true);

    local TextBMFont = itemWidget:getChildByName("BitmapLabel_count")
    TextBMFont:setVisible(true);

    itemWidget.currentNum = itemWidget.currentNum+1;

    if itemWidget.currentNum>itemWidget.maxNum then 
        itemWidget.currentNum=itemWidget.maxNum
    end

    TextBMFont:setString("X"..itemWidget.currentNum)

    local Panel_mask01 = itemWidget:getChildByName("Panel_mask01");
    if itemWidget.currentNum == itemWidget.maxNum then 
        Panel_mask01:setVisible(true)
    else
        Panel_mask01:setVisible(false);
    end
    
    self.pOpTab[itemWidget.date:GetIndex()] = itemWidget.currentNum;

    self:setResExp();
    self:updateList();
end

function ForgingLayer:subOpCount(itemWidget)

    self.iEqCount = self.iEqCount-1;
    if self.iEqCount<0 then 
        self.iEqCount=0;
    end

    local btn_sub = itemWidget:getChildByName("btn_sub")
    local Panel_mask01 = itemWidget:getChildByName("Panel_mask01");
    local TextBMFont = itemWidget:getChildByName("BitmapLabel_count")

    Panel_mask01:setVisible(false);

    itemWidget.currentNum = itemWidget.currentNum-1;

    if itemWidget.currentNum<=0 then 
        itemWidget.currentNum=0;
        btn_sub:setVisible(false);
        btn_sub:setTouchEnabled(false);
        TextBMFont:setVisible(false);
        self.pOpTab[itemWidget.date:GetIndex()] = nil;
    else
        TextBMFont:setString("X"..itemWidget.currentNum)
        self.pOpTab[itemWidget.date:GetIndex()] = itemWidget.currentNum;
    end

    self:setResExp();
    self:updateList();
end

--设置资源消耗
function ForgingLayer:setResExp()

    self.pLogic.resTab={};
    --所需要的资源数量
    for k,v in pairs(self.pOpTab) do
        local data1 = makeConfigFile[tonumber(k)].data1
        for i=1,v do
            for j,var in pairs(data1) do
                local id = var[1]
                local num = var[2]
                if self.pLogic.resTab[id] == nil then 
                    self.pLogic.resTab[id] = num
                else
                    self.pLogic.resTab[id] = num + self.pLogic.resTab[id]
                end
            end
        end
    end

    local childTab = self.pScrollView_mat:getChildren();

    for i=table.getn(childTab),1 ,-1 do
        local bIsHave = false;
        local v = childTab[i]
        for j,var in pairs(self.pLogic.resTab) do
            if v.id == j then 
                bIsHave = true;
            end
        end

        if bIsHave == false then 
            v:removeFromParent();
        end
    end

    --更新宽高
    self.pScrollView_mat:setInnerContainerSize(cc.size(725,(math.ceil(table.getn(childTab)/5+1))*60))

    for k,v in pairs(self.pLogic.resTab) do
        local bIshave = false;
        childTab = self.pScrollView_mat:getChildren();
        for i,var in pairs(childTab) do
            if var.id == k then 
                local lab_num = var:getChildByName("lab_number")
                lab_num:setString(v)
                bIshave = true;
            end
        end


        if bIshave==false then
            local scorllHeight = self.pScrollView_mat:getInnerContainerSize().height;    
            local _item = self.pPanel_matItem:clone();
            _item.id = k
            local ibaseX    = 10
            local ibaseY    = 130
            local ispaceX   = 130
            local ispaceY   = 130
            local posIndex  = table.getn(childTab);
            local posX = posIndex%5*ispaceX+ibaseX;
            local posY = scorllHeight-(math.floor(posIndex/5))*ispaceY-ibaseY;
            _item:setPosition(cc.p(posX,posY))

            self.pScrollView_mat:addChild(_item)

            local img_bg        =   _item:getChildByName("img_bg")
            local img_icon      =   _item:getChildByName("img_icon")
            self:fun_setItemImage(img_icon,img_bg,_item.id)

            local lab_number    =   _item:getChildByName("lab_number")
            lab_number:setString(v)

        end
    end

end


function ForgingLayer:fun_setItemImage(imgIcon,imgQuliaty,id)
    local itemInfo = itemConfigFile[id]
    
    --品质
    local iQuality = itemInfo.itemQuality;
    if itemInfo.itemQuality == ITEM_TYPE_EQU then 
        --如果是装备
        if iQuality == TB_ITEM_QUALITY.Q_01 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_equipment_00.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_02 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_equipment_01.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_03 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_equipment_02.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_04 then    
            imgQuliaty:loadTexture("res/ui/00/00_bg_equipment_03.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_05 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_equipment_04.png");
        end
    else
        --如果是其他物品
        if iQuality == TB_ITEM_QUALITY.Q_01 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_item_00.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_02 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_item_01.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_03 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_item_02.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_04 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_item_03.png");
        elseif iQuality == TB_ITEM_QUALITY.Q_05 then
            imgQuliaty:loadTexture("res/ui/00/00_bg_item_04.png");
        end
    end

    --图标
    imgIcon:loadTexture(itemInfo.itemIcon);

end


function ForgingLayer:getItemPositionTab()
    local childTab = self.pScrollView_target:getChildren();
    local bRet={};
    for k,v in pairs(childTab) do
        if v.currentNum>0 then
            for i=1,v.currentNum do
                local _Point = cc.p(v:getPositionX(),v:getPositionY())
                local pPoint = v:getParent():convertToWorldSpaceAR(_Point)
                local _size = v:getContentSize()
                pPoint.x = pPoint.x+_size.width*0.5;
                pPoint.y = pPoint.y+_size.height*0.5;
                table.insert(bRet,pPoint);
            end
        end
    end

    return bRet;
end