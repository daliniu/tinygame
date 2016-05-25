require("script/class/class_base_ui/class_base_sub_layer")


local EMAIL_ADD_FRIEND_TB={
    pLogic=nil,
}

EmailAddFriend = class("EmailAddFriend",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function EmailAddFriend:create()
	self = EmailAddFriend.new();
    self:initAttr();
	return self;
end

function EmailAddFriend:ctor()
    self.pLogic = EmailLogic:getInstance();

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/emailInfoAddFriend.json")
    self:addChild(self.pWidget)	

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    local function fun_agree(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
            self.pLogic:reqFriend();
        end
    end

    local function fun_refuse(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
            self.pLogic:reqFriend();
        end
    end


    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)

    local btn_agree = self.pWidget:getChildByName("btn_js");
    btn_agree:addTouchEventListener(fun_agree);

    local btn_refuse = self.pWidget:getChildByName("btn_jj");
    btn_refuse:addTouchEventListener(fun_refuse)

end

function EmailAddFriend:initAttr()
    
    local Panel_info = self.pWidget:getChildByName("Panel_info");

    local lab_info01    =   Panel_info:getChildByName("lab_info01");        --标题
    local img_icon      =   Panel_info:getChildByName("img_icon");          --头像
    local lab_name      =   Panel_info:getChildByName("lab_name");          --名字
    local lab_lv        =   Panel_info:getChildByName("lab_lv");            --等级
    local lab_fight     =   Panel_info:getChildByName("lab_text01_2");      --战斗力

end