--战斗播报层
require "script/class/class_base_ui/class_base_layer"
require "script/ui/chatview/chatview"

local l_tbFightTextConfig = mconfig.loadConfig("script/cfg/client/action/fighttext");
local l_tbChannel, l_tbChannelName = def_GetChatCHANNELTYPE();

local TB_FIGHT_CHAT_LAYER_STRUCT = 
{
	m_imgBg = nil,		--气泡
	m_tfInput = nil,	--输入
	m_pnlShowText = nil,--显示面板
	m_showText = nil,	--显示文本
	m_btnHead = nil,	--头像
	m_lblNpcName = nil,	--名字
	m_pnlCommunication = nil,	--联系面板	
	m_bUpdate = true,						-- 刷新界面
	
	m_nCurChannel = 0,						-- 当前显示聊天频道
	m_tbChannels = {},
	
	m_tbSelectedHead = {					-- 选中的头像相关信息
	},					
	
	m_nWidth = l_tbFightTextConfig.nWidth,	-- 气泡的宽度限制
	
	m_tbTime = {							-- 时间限制
		--[nChannel] = time,
	},
}

FightChatLayer = class("FightChatLayer", KGC_CHAT_VIEW_TYPE, TB_FIGHT_CHAT_LAYER_STRUCT)

function FightChatLayer:create()
	local pChat= FightChatLayer.new()
	return pChat
end

function FightChatLayer:ctor()
	self:initUI()

	self:ChangeChannel(l_tbChannel.ECC_AREA);
	-- 打开聊天界面更新一次
	local tbMessages = KGC_CHAT_VIEW_LOGIC_TYPE:getInstance():GetAllMessages();
	self:UpdateText(tbMessages)
end

function FightChatLayer:initUI()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_CHAT_PATH)	
	self:addChild(self.m_Layout)

	local pnlChat = self.m_Layout:getChildByName("pnl_chat")
	-- 聊天气泡底图
	self.m_imgBg = pnlChat:getChildByName("img_background")

	local imgInput = pnlChat:getChildByName("img_inputbg")
	self.m_tfInput = imgInput:getChildByName("tf_input")
	self:RegisterEventListener(self.m_tfInput)

	
	local btnSend = imgInput:getChildByName("btn_send")
	local fnSend = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:SendMessage(sender);
		end
	end
	btnSend:addTouchEventListener(fnSend)
	
	-- 名字
	self.m_btnHead = pnlChat:getChildByName("btn_head")
	self.m_lblNpcName = self.m_btnHead:getChildByName("lbl_npc_name")
	self.m_pnlCommunication = pnlChat:getChildByName("pnl_communication")
	self.m_pnlCommunication:setVisible(false);
	self.m_pnlCommunication:setLocalZOrder(1);
	local btnCommPrivateChat = self.m_pnlCommunication:getChildByName("btn_private_chat")
	local btnCommCheckInfo = self.m_pnlCommunication:getChildByName("btn_check_info")
	local btnCommAddFriend = self.m_pnlCommunication:getChildByName("btn_add_friend")
	local fnCommunication = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventCommunication(sender);
		end
	end

	local fnTouchSvText = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventSvText(sender);
		end
	end
	local svText = pnlChat:getChildByName("scv_publicchat")
	if svText then
		svText:addTouchEventListener(fnTouchSvText)
	end

	self.m_nCurChannel = l_tbChannel.ECC_AREA
	self.m_tbChannels[l_tbChannel.ECC_AREA] = {"btnchat", svText}
end

--战斗聊天没channel切换，屏蔽父类该方法
function FightChatLayer:ChangeChannel(nChannel)
	
end