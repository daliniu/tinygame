require("script/class/class_base_ui/class_base_layer")
require("script/ui/emailview/emailaddfriend");
require("script/ui/emailview/emailsystem01");


local EMAIL_LAYER_TB={
    emailItem   =nil,
    scrollList  =nil,
    itemIndex = 0;
}


EmailLayer = class("EmailLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function EmailLayer:create()
	self = EmailLayer.new();
    self:initAttr();
	return self;
end

function EmailLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/emaillayer.json")
    self:addChild(self.pWidget)

    self.pLogic = EmailLogic:getInstance();

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)

    
    self.emailItem = self.pWidget:getChildByName("Panel_emailItem")
    self.emailItem:retain();
    self.emailItem:removeFromParent();

    self.scrollList =self.pWidget:getChildByName("ScrollView_list");
end

function EmailLayer:OnExit()
    self.emailItem:release();
    self.emailItem=nil;
end



function EmailLayer:initAttr()
    local _num = #self.pLogic.emailTab;
    for i=1,_num do
        local info =self.pLogic.emailTab[i]
        self:addEmailItem(info,i);
    end

    self.scrollList:jumpToTop();
end

function EmailLayer:addEmailItem(info,index)
    local function fun_item(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            if sender.iType ==1 then 
               
            else
                EmailLogic:getInstance():reqEmailInfo(info.id)
            end
        end
    end

    local _num = #self.pLogic.emailTab;
    local fSpaceY = 95

    local _size =self.scrollList:getInnerContainerSize();
    self.scrollList:setInnerContainerSize(cc.size(_size.width,_num*fSpaceY));
    _size =self.scrollList:getInnerContainerSize();

    local _email = self.emailItem:clone();
    self.scrollList:addChild(_email);
    _email:addTouchEventListener(fun_item);

    --位置
    _email:setPositionX(0);
    _email:setPositionY(_size.height-index*fSpaceY);

    _email.info = info;

    --属性
    _email.iType = 2;

    local img_new           = _email:getChildByName("img_new")
    local lbl_mailtype      = _email:getChildByName("lbl_mailtype")
    local lab_info          = _email:getChildByName("lab_info")

    lab_info:setString(info.text);

    if info.new ~= true then
        img_new:setVisible(false)
    end
end

function EmailLayer:addItemAtHead(info)
    local fSpaceY = 95;
    local childTb = self.scrollList:getChildren();

    local _num = #self.pLogic.emailTab;
    local fDir = _num*fSpaceY - 800


    for k,v in pairs(childTb) do
        if fDir>0 then
            if fDir > fSpaceY then 
                v:setPositionY(v:getPositionY()+fSpaceY);
            else
                v:setPositionY(v:getPositionY()+fDir);
            end
            
        end
        
        v:runAction(cc.MoveBy:create(0.2,cc.p(0,fSpaceY*-1)))
    end

    self:addEmailItem(info,1);
end


function EmailLayer:addSystemEmailLayer(info,id)
    self:addChild(EmailSystem01:create(info,id));
end

function EmailLayer:addFriendEmailLayer(info)
    self:addChild(EmailAddFriend:create());
end


