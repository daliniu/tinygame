----------------------------------------------------------
-- file:	chatlogic.lua
-- Author:	page
-- Time:	2015/08/14 16:02
-- Desc:	聊天逻辑管理类
----------------------------------------------------------
require("script/ui/chatview/chatview")
require("script/class/class_base_ui/class_base_logic")

local l_tbChannel = def_GetChatCHANNELTYPE();

local TB_STRUCT_CHAT_VIEW_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
	
	-- 聊天信息存储
	m_tbMessages = {
		--[1] = {MESSAGE_TYPE, name, szMsg}
	},
	
	-- 统计
	m_tbCounters = {
		--[MESSAGE_TYPE] = 数量,
	}
}

KGC_CHAT_VIEW_LOGIC_TYPE=class("KGC_CHAT_VIEW_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_CHAT_VIEW_LOGIC)


function KGC_CHAT_VIEW_LOGIC_TYPE:getInstance()
	if not KGC_CHAT_VIEW_LOGIC_TYPE.m_pLogic then
        KGC_CHAT_VIEW_LOGIC_TYPE.m_pLogic = KGC_CHAT_VIEW_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_CHAT_VIEW_LOGIC_TYPE.m_pLogic)
	end
	return KGC_CHAT_VIEW_LOGIC_TYPE.m_pLogic
end

function KGC_CHAT_VIEW_LOGIC_TYPE:create()
    local _logic = KGC_CHAT_VIEW_LOGIC_TYPE.new()
    return _logic
end

function KGC_CHAT_VIEW_LOGIC_TYPE:initLayer(parent,id, tbArgs)
    if self.m_pLayer then
    	return;
    end
	
    self.m_pLayer = KGC_CHAT_VIEW_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)

	-- 设置主界面底部按钮底框可见
	KGC_MainViewLogic:getInstance():ShowMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(true)
end

function KGC_CHAT_VIEW_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
	
	-- 设置主界面底部按钮底框不可见
	KGC_MainViewLogic:getInstance():HideMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(false)
end

-----------------------------------------------
function KGC_CHAT_VIEW_LOGIC_TYPE:RegisterMessageCallBack()
	-- 初始化接受消息协议
	local fnCallBack = function(tbArg)
		self:RecvMessage(tbArg);
	end
	g_Core.communicator.client.recvMsgFromServer(fnCallBack);
end

-- 消息处理部分
function KGC_CHAT_VIEW_LOGIC_TYPE:GetAllMessages()
	if not self.m_tbMessages then
		self.m_tbMessages = {}
	end
	
	return self.m_tbMessages;
end

--@function: 插入一条消息
--@nType: 消息类型
--@szName: 显示是由谁发的
--@szMsg: 消息内容
function KGC_CHAT_VIEW_LOGIC_TYPE:AddMessage(nCamp, nType, szName, szMsg)
	local tbMessages = self:GetAllMessages();
	table.insert(tbMessages, {nCamp, nType, szName, szMsg});
end

function KGC_CHAT_VIEW_LOGIC_TYPE:GetMessagesByType(nType)
	local nType = nType or l_tbChannel.ECC_AREA;
	local tbMessages = self:GetAllMessages();
	local tbRet = {};
	if nType == l_tbChannel.ECC_AREA then
		return tbMessages;
	end
	-- Notify: ipairs
	for _, tbMsg in ipairs(tbMessages) do
		local nCamp, nT, szN, szM = unpack(tbMsg or {});
		if nT == nType then
			table.insert(tbRet, tbMsg);
		end
	end
	
	return tbRet;
end

function KGC_CHAT_VIEW_LOGIC_TYPE:ChangeType()

end
-----------------------------------------------
--@function: 发送消息
function KGC_CHAT_VIEW_LOGIC_TYPE:SendMessage(nType, szName, szMsg)
	-- 添加到数据结构中(1表示别人发送的消息, 2表示自己的)
	self:AddMessage(2, nType, szName, szMsg)
	
	local tbArg = {}
	tbArg.uuid = szName;
	tbArg.area = 1;
	tbArg.groupId = 0;
	tbArg.type = nType or 5;
	tbArg.msg = szMsg or ""; 
	local fnCallBack = function(tbArg)
		print("[协议]SendMessage返回成功", tbArg, tbArg.state)
	end
	print("[network]发送消息：")
	tst_print_lua_table(tbArg)
	g_Core.communicator.chat.sendMsgToServer(tbArg, fnCallBack);
	
	-- 更新界面
	-- local tbMessages = self:GetAllMessages();
	if self.m_pLayer then
		self.m_pLayer:UpdateMessage(2, nType, szName, szMsg);
	end
	FightViewLogic:getInstance():UpdateChatMessage(2, nType, szName, szMsg)
end

function KGC_CHAT_VIEW_LOGIC_TYPE:RecvMessage(tbArg)
	print("[network]接受消息：")
	tst_print_lua_table(tbArg);
	local nType = tonumber(tbArg.type)
	local szName = tbArg.uuid;
	local szMsg = tbArg.msg

	local massageTab={};
	massageTab.type = nType;
	massageTab.name = szName;
	massageTab.msg = szMsg;
	BulletLogic:getInstance():addMassage(massageTab);

	
	if nType ~= l_tbChannel.ECC_PERSONAL and szName == me:GetAccount() then
		return;
	end
	
	self:AddMessage(1, nType, szName, szMsg)
	
	-- 更新界面
	if self.m_pLayer then
		self.m_pLayer:UpdateMessage(1, nType, szName, szMsg);
	end
	FightViewLogic:getInstance():UpdateChatMessage(1, nType, szName, szMsg)	
end