require("script/class/class_base_ui/class_base_sub_layer")

local EMAIL_SYSTEM_01_TB={
    rewardItme =nil,
    ScrollView_itemList = nil,
    info =nil
}


EmailSystem01 = class("EmailSystem01",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function EmailSystem01:create(info,id)
	self = EmailSystem01.new();
    self.info = info;
    self.mailID = id;
    self:initAttr();
	return self;
end

function EmailSystem01:OnExit()
    self.rewardItme:release();
    self.rewardItme=nil;
end


function EmailSystem01:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/emailInfoSystem01.json")
    self:addChild(self.pWidget)	

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    local function fun_getReward(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            EmailLogic:getInstance():reqReward(self.mailID);
            self:closeLayer();
        end
    end

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)

    local btn_get = self.pWidget:getChildByName("btn_get")
    btn_get:addTouchEventListener(fun_getReward)


    self.rewardItme = self.pWidget:getChildByName("Panel_rewardItem");
    self.rewardItme:retain();
    self.rewardItme:removeFromParent();

    self.ScrollView_itemList = self.pWidget:getChildByName("ScrollView_itemList");

end


function EmailSystem01:initAttr()

    local labTitle =self.pWidget:getChildByName("lab_name");        --标题
    labTitle:setString(self.info.text);


    local labInfo  =self.pWidget:getChildByName("Label_info");      --内容
    labInfo:setString(self.info.text);

    local _num=0;
    local fSpaceX = 80;
    local _size =self.ScrollView_itemList:getInnerContainerSize();
    self.ScrollView_itemList:setInnerContainerSize(cc.size(_num*fSpaceX,_size.height));
    _size =self.ScrollView_itemList:getInnerContainerSize();

    for i=1,_num do
        local _itme = self.rewardItme:clone();
        self.ScrollView_itemList:addChild(_itme);

        --位置
        _itme:setPositionX(i*fSpaceX);
        _itme:setPositionY(0);

        --属性
    end
end