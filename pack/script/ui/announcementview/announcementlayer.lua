require("script/class/class_base_ui/class_base_sub_layer")


local ANNOUNCEMENT_LAYER_TAB={
    pScrollview =nil,
    panelItem=nil,
    pImgPanel = nil,
}



AnnouncementLayer = class("AnnouncementLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end,ANNOUNCEMENT_LAYER_TAB)

function AnnouncementLayer:create()
	self = AnnouncementLayer.new();
    self:initAttr();
	return self;
end

function AnnouncementLayer:ctor()
	
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/announcementlayer.json")
    self:addChild(self.pWidget)

    self.pLogic = AnnouncementLogic:getInstance();

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)

    self.pScrollview = self.pWidget:getChildByName("ScrollView_list")

    self.panelItem = self.pWidget:getChildByName("Panel_item")
    self.panelItem:retain();
    self.panelItem:removeFromParent();

    self.pImgPanel = self.pWidget:getChildByName("Panel_img")
    self.pImgPanel:setVisible(false)
end

function AnnouncementLayer:OnExit()
    self.panelItem:release()
    self.panelItem=nil;
end


function AnnouncementLayer:initAttr()
    if self.pLogic.annDateTab.type == 1 then 
        self:initTextAnnounce();
    elseif self.pLogic.annDateTab.type == 2 then 
        self:initImgAnnounce();
    end
    

end


function AnnouncementLayer:initTextAnnounce()

    local function fun_updatPos(iOffsetY)
        for k,v in pairs(self.pScrollview:getChildren()) do
            v:setPositionY(v:getPositionY()+math.abs(iOffsetY))
        end
    end


    local dateTab =self.pLogic.annDateTab.info;

    local lastPosY  =   0;
    local iHeight   =   self.pScrollview:getInnerContainerSize().height;
    local iSize     =   self.pScrollview:getInnerContainerSize()

    for k,v in pairs(dateTab) do
        local panel = self.panelItem:clone();

        local lab_name =panel:getChildByName("lab_name")
        lab_name:setString(v.title)

        local panelHeight = 150;        --基础高度
        local Panel_tiem = panel:getChildByName("Panel_tiem")
        Panel_tiem:removeFromParent();
        Panel_tiem:retain()
        for i=1,1 do
            local itemBaseHeight = 50;        --基础高度
            local textPanelItem = Panel_tiem:clone()
            panel:addChild(textPanelItem)
            local lab_title = textPanelItem:getChildByName("lab_title")
            lab_title:setString(v.text)
            local lab_text = textPanelItem:getChildByName("lab_info")
            lab_text:setString(v.info)

            local _offset = (itemBaseHeight+lab_text:getContentSize().height)*(i-1)

            panelHeight= panelHeight+_offset;

            textPanelItem:setPositionY(textPanelItem:getPositionY()-_offset)
        end

        local iOffsetY = iHeight - lastPosY

        if iOffsetY<0 then
            fun_updatPos(iOffsetY)
            iSize.height = iSize.height+math.abs(iOffsetY);
            panel:setPositionY(0);
            lastPosY=iHeight
        else
            panel:setPositionY(iOffsetY)
        end
        panel:setPositionX(0)
        self.pScrollview:addChild(panel)

        Panel_tiem:release()
        lastPosY = lastPosY+panelHeight;
    end

    self.pScrollview:setInnerContainerSize(cc.size(iSize.width,iSize.height))

end


function AnnouncementLayer:initImgAnnounce()
    self.pImgPanel:setVisible(true)

end