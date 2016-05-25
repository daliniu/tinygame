require("script/ui/emailview/emaillayer");



local EMAIL_LOGIC_TAB={
    emailTab ={},        --邮件数据//
}


EmailLogic = class("EmailLogic", KGC_UI_BASE_LOGIC,EMAIL_LOGIC_TAB);

function EmailLogic:getInstance()
    if EmailLogic.m_pLogic == nil then
        EmailLogic.m_pLogic = EmailLogic:create()
        GameSceneManager:getInstance():insertLogic(EmailLogic.m_pLogic)
    end

    return EmailLogic.m_pLogic
end

function EmailLogic:create()
    local _logic = EmailLogic.new()
    _logic:Init()
    return _logic
end

function EmailLogic:Init()

end

function EmailLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = EmailLayer:create();
    self.m_pLayer.id = id;
	self.m_pLayer.flag = true
    parent:addChild(self.m_pLayer)

	-- 设置主界面底部按钮底框可见
	KGC_MainViewLogic:getInstance():ShowMenuBg();
end


function EmailLogic:closeLayer()
	if self.m_pLayer then
		local nID = self.m_pLayer.id;
		self.m_pLayer:closeLayer();
		
		self.m_pLayer = nil;
	end
	
	-- 设置主界面底部按钮底框不可见
	KGC_MainViewLogic:getInstance():HideMenuBg();
end

function EmailLogic:OnUpdateLayer(iType)
	if self.m_pLayer ==nil then 
		return;
	end

end



function EmailLogic:RegisterMessageCallBack()
    local getEmail = function(tbArg)
        self:getEmail(tbArg);
    end

    local reqFriend =function(tbArg)
        self:reqFriend(tbArg);
    end

    local reqReward = function(tbArg)
        self:reqReward(tbArg);
    end

    g_Core.communicator.client.getEmail(getEmail);

end


--邮件结构
--[[
调用 getMail ，入参的 msg 字段包含邮件结构，如下：
msg = {
id: "11",
sender: "我是天才",
text: "hello",
title:"系统邮件"
attach: {
"gold": "123",
"diamond": "333",
"10001": 5
},
get: 0
}
需要注意的是，结构中 attach 字段的 key 和 value 均是字符串，所以客户端需要自行转换。


]]--


--接受邮件
function EmailLogic:getEmail(tbArg)
    local info={};
    info.id         = tbArg.id;
    info.sender     = tbArg.sender;
    info.text       = tbArg.text;
    info.get        = tbArg.get;
    info.gold       = nil;
    info.diamond    = nil;
    info.reward     = {};
    info.new        = true;
    for k,v in pairs(tbArg.attach) do
        if k == "gold" then 
            info.gold       = v;
        elseif k == "diamond" then 
             info.diamond       = v;
        else
            info.reward[k] = v;
        end
    end

    --存入内存，
    table.insert(self.emailTab,info);

    --存入本地数据

    --存入界面
    if self.m_pLayer ~= nil then 
        self.m_pLayer:addItemAtHead(info)
    end

end


--请求好友消息处理
--好友id
--result，同意或拒绝
function EmailLogic:reqFriend(mailID)



end


--请求奖励
--奖励id
function EmailLogic:reqReward(mailID)
    local funCall = function(tbArg)
        local isOK      =   tbArg.isOK;
        local attack    =   tbArg.attack;


    end
    local tab={};
    tab.mailID=mailID
    g_Core.communicator.loc.getMailAttach(tab,funCall);
end


--请求邮件列表
function EmailLogic:reqEmailList()
    local funCall = function(tbArg)
        tst_print_lua_table(tbArg)
        local list = tbArg.mailList;
        for k,v in pairs(list) do
            self:getEmail(v)
        end
        
    end

    g_Core.communicator.loc.ReceiveMail(funCall);

end

--请求邮件内容
function EmailLogic:reqEmailInfo(mailID)
    local funCall = function(tbArg)
        local stringInfo = {};
        stringInfo.text = tbArg.text;
        self.m_pLayer:addSystemEmailLayer(stringInfo,mailID)
    end

    local tab={};
    tab.mailID=mailID
    g_Core.communicator.loc.getMailText(tab,funCall);
end