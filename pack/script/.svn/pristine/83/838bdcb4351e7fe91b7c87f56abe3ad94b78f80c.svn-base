--道具合成层
require("script/class/class_base_ui/class_base_layer")
require("script/core/configmanager/configmanager");

local comConfigFile     =   mconfig.loadConfig("script/cfg/equip/compose")
local itemConfigFile    =   mconfig.loadConfig("script/cfg/pick/item")

local TB_ITEM_COM_LAYER={
    pLogic = nil,
	itemID,
    composeid,
    srcItemWidget =nil,
    iMaxNum =0,         --可合成的最大数量
}

ItemComLayer = class("ItemComLayer",function()
    return KGC_UI_BASE_LAYER:create()
end,TB_ITEM_COM_LAYER)

function ItemComLayer:create(id)
	self = ItemComLayer.new();
	self.itemID = id;
	self:initAttr();
	return self;
end

function ItemComLayer:OnExit()
    -- body
    self.srcItemWidget:release();
    self.srcItemWidget=nil
end

function ItemComLayer:ctor()
    self.pLogic = ItemComLogic:getInstance();

	--关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

    --合成
    local function fun_com(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:fun_com(self.itemID,self.composeid)
        end
    end

    --全部合成
    local function fun_comAll(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:fun_comAll(self.itemID,self.composeid)
        end
    end

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/itemComLayer.json")
    self:addChild(self.pWidget)

    local btn_close = self.pWidget:getChildByName("btn_close")  	--关闭按钮
    btn_close:addTouchEventListener(fun_close)

    self.srcItemWidget = self.pWidget:getChildByName("Panel_src")
    self.srcItemWidget:retain();
    self.srcItemWidget:removeFromParent();


    local btn_com = self.pWidget:getChildByName("btn_com")
    btn_com:addTouchEventListener(fun_com)

    local btn_comAll = self.pWidget:getChildByName("btn_comAll")
    btn_comAll:addTouchEventListener(fun_comAll)

end

function ItemComLayer:initAttr()

    local srcDate = me.m_Bag:GetItemByID(self.itemID);
    if srcDate ==nil then 
        return;
    end

    self.composeid = tonumber(srcDate:GetComposeTarget())
    local comConfig = comConfigFile[self.composeid]
    local pTargetID = comConfig.itemId
    local resTab = comConfig.demandItemId
    local pTargetCoinfg = itemConfigFile[tonumber(pTargetID)]
	
    --目标物体属性相关
    local Panel_target = self.pWidget:getChildByName("Panel_target");
    local targetIcon = Panel_target:getChildByName("img_icon")
    local targetNum = Panel_target:getChildByName("lab_num")
    targetIcon:loadTexture(pTargetCoinfg.itemIcon)
    targetNum:setVisible(false);


    --当前物体属性相关
    for i,v in pairs(resTab) do
        local pScr = self.srcItemWidget:clone();
        self.pWidget:addChild(pScr);

        local rseId = v[1];
        local resNum = v[2];
        local resHaveNum =0;
        local _itemAttr = me.m_Bag:GetItemByID(rseId);
        if _itemAttr~=nil then
            resHaveNum = _itemAttr:GetNum();
        end

        self.iMaxNum = math.floor(resHaveNum/resNum)

        local targetIcon = pScr:getChildByName("img_icon")
        local targetNum = pScr:getChildByName("lab_num")

        local pSrcConfig = itemConfigFile[tonumber(rseId)]
        
        targetNum:setString(resHaveNum.."/"..resNum);
        targetIcon:loadTexture(pSrcConfig.itemIcon);
    end



end


function ItemComLayer:fun_com(itemID,composeid)
    ItemComLogic:getInstance():reqCom(itemID,composeid,1);
end

function ItemComLayer:fun_comAll(itemID,composeid)
    ItemComLogic:getInstance():reqCom(itemID,composeid,self.iMaxNum);
end
