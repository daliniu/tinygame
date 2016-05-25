----------------------------------------------------------
-- file:	chatview.lua
-- Author:	page
-- Time:	2015/08/14 16:02
-- Desc:	聊天面板
----------------------------------------------------------
require "script/ui/resource"
----------------------------------------------------------
require("script/core/configmanager/configmanager");
local l_tbFightTextConfig = mconfig.loadConfig("script/cfg/client/action/fighttext");
local l_tbChatConfig = mconfig.loadConfig("script/cfg/commons/chat");

local l_tbChannel, l_tbChannelName = def_GetChatCHANNELTYPE();

--data struct
local TB_STRUCT_UI_CHAT_VIEW_VIEW = {
	--config
	m_szFile = CUI_JSON_CHAT,				--界面文件路径
	m_tbSuffix = {							-- 按钮和聊天框共用后缀名
		[l_tbChannel.ECC_AREA] = "_publicchat",
		[l_tbChannel.ECC_ROOM] = "_roomchat",
		[l_tbChannel.ECC_PERSONAL] = "_personalchat",
	},
	
	--界面
	m_Layout = nil,							--保存界面结构root
	
	-- 一条消息的模版
	m_imgBg = nil,							-- 汽包背景模版
	m_lblNpcName = nil,						-- 名字模版
	m_btnHead = nil,						-- 头像模版
	
	m_bUpdate = true,						-- 刷新界面
	
	m_nCurChannel = 0,						-- 当前显示聊天频道
	m_tbChannels = {},
	
	m_tbSelectedHead = {					-- 选中的头像相关信息
	},					
	
	m_nWidth = l_tbFightTextConfig.nWidth,	-- 气泡的宽度限制
	
	m_tbTime = {							-- 时间限制
		--[nChannel] = time,
	},

	m_pnlShowText = nil,					--显示层
	m_showText = nil,						--显示文本
}

KGC_CHAT_VIEW_TYPE = class("KGC_CHAT_VIEW_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_UI_CHAT_VIEW_VIEW)
--------------------------------
--ui function
--------------------------------

function KGC_CHAT_VIEW_TYPE:Init()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(self.m_szFile)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	self:LoadScheme()
	
	self:ChangeChannel(l_tbChannel.ECC_AREA);
	-- 打开聊天界面更新一次
	local tbMessages = KGC_CHAT_VIEW_LOGIC_TYPE:getInstance():GetAllMessages();
	self:UpdateText(tbMessages)
end

--解析界面文件
function KGC_CHAT_VIEW_TYPE:LoadScheme()
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_CHAT_VIEW_LOGIC_TYPE:getInstance():closeLayer();
		end
	end
	local btnClose = self.m_Layout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose);
	
	local pnlMain = self.m_Layout:getChildByName("pnl_main")
	local pnlChat = pnlMain:getChildByName("pnl_chat")
	-- 聊天气泡底图
	self.m_imgBg = pnlChat:getChildByName("img_background")
	
	-- 标签页按钮
	local fnChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventChangeChannel(sender)
		end
	end
	
	local fnTouchSvText = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventSvText(sender);
		end
	end
	
	for k, v in pairs(self.m_tbSuffix) do
		local szBtnName = "pnl" .. v
		local szSvName = "scv" .. v;
		local btnChat = pnlMain:getChildByName(szBtnName)
		local svText = pnlChat:getChildByName(szSvName)
		if btnChat and svText then
			btnChat._button_index = k;
			btnChat:addTouchEventListener(fnChange)
			self.m_tbChannels[k] = {btnChat, svText}
			svText:addTouchEventListener(fnTouchSvText)
		end
	end	

	local imgInput = pnlChat:getChildByName("img_inputbg")
	self.m_tfInput = imgInput:getChildByName("tf_input")
	self.m_pnlShowText = self.m_Layout:getChildByName("img_inputbg")
	self.m_showText = self.m_pnlShowText:getChildByName("pnl_cover"):getChildByName("Label_58")
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
	btnCommPrivateChat:addTouchEventListener(fnCommunication)
	btnCommCheckInfo:addTouchEventListener(fnCommunication)
	btnCommAddFriend:addTouchEventListener(fnCommunication)
end

function KGC_CHAT_VIEW_TYPE:TouchEventChangeChannel(widget)
	local index = widget._button_index or 1;
	self:ChangeChannel(index)
end

function KGC_CHAT_VIEW_TYPE:TouchEventSvText(widget)
	print("TouchEventSvText", widget:getName(), widget:getTag());
	if self.m_pnlCommunication then
		self.m_pnlCommunication:setVisible(false);
	end
end

function KGC_CHAT_VIEW_TYPE:ChangeChannel(nChannel)
	if nChannel and nChannel ~= self.m_nCurChannel then
		local btnChat, svText = unpack(self.m_tbChannels[nChannel])
		if svText then
			svText:setVisible(true)
			svText:setLocalZOrder(1)
			self:SetButtonVisible(btnChat, true)
			-- 显示当前页，其他的隐藏
			for k, v in pairs(self.m_tbChannels) do
				local btn, sv = unpack(v)
				if sv ~= svText then
					sv:setVisible(false)
					self:SetButtonVisible(btn, false)
					svText:setLocalZOrder(0)
				end
			end
			self.m_nCurChannel = nChannel;
			
			-- 刷新界面
			self:RefreshText();
		end
	end
end

function KGC_CHAT_VIEW_TYPE:SetButtonVisible(button, bIsVisible)
	if not button then
		return;
	end
	local imgSelected = button:getChildByName("img_selected")
	local imgNotSelected = button:getChildByName("img_notselect")
	if bIsVisible then			
		imgSelected:setVisible(true)
		imgNotSelected:setVisible(false)
	else
		imgSelected:setVisible(false)
		imgNotSelected:setVisible(true)
	end
end

--@function:注册监听事件
function KGC_CHAT_VIEW_TYPE:RegisterEventListener(tfInput)
	local MAX_LENGTH = 540;
	if not tfInput then
		return;
	end

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	local function SetShowTextVisible(bVisible)
		if (cc.PLATFORM_OS_WINDOWS ~= targetPlatform) then
			self.m_pnlShowText:setVisible(bVisible)
		end
	end
	local function SetShowText(sStr)
		if (cc.PLATFORM_OS_WINDOWS ~= targetPlatform) and self.m_showText then
			self.m_showText:setString(sStr)
		end
	end

	local nPosX = tfInput:getPositionX();
	
	local cursor = cc.Sprite:create("res/ui/17_loadingsence/17_bar_loading_ar.png");
	cursor:setVisible(false);
	cursor:setScaleY(0.5);
	local size = tfInput:getContentSize();
	tfInput:setTouchSize(size);
	tfInput:setTouchAreaEnabled(true);
	tfInput:setColor(cc.c3b(255, 0, 0))
	cursor:setPositionY(size.height/2);
	local action = cc.RepeatForever:create(cc.Blink:create(1, 1));
	cursor:runAction(action);
	local cursorNode = cc.Node:create();
	cursorNode:addChild(cursor);
	cursorNode:setVisible(false);
	tfInput:addChild(cursorNode)
	tfInput:ignoreContentAdaptWithSize(true)
	local fnInput = function(sender, eventType)
		-- print(333, tfInput:getPlaceHolder(), tfInput:getMaxLength());
		local x = 0;
		 if eventType == ccui.TextFiledEventType.attach_with_ime then
			local size = tfInput:getContentSize();
			local nLength = tfInput:getStringLength();
			local szValue = tfInput:getStringValue();
			local x = size.width;
			if string.len(szValue) == 0 then
				x = 0;
			end
			
            print("attach with IME", x, nLength)
			cursorNode:setVisible(true);
			cursor:setPositionX(x);
			SetShowText(self.m_tfInput:getStringValue())
			SetShowTextVisible(true)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            print("detach with IME", size.width)
			cursorNode:setVisible(false);
			local size = tfInput:getContentSize();
			cursor:setPositionX(size.width);
			SetShowTextVisible(false)
			SetShowText("")
        elseif eventType == ccui.TextFiledEventType.insert_text then
            print("insert words", size.width)
			local size = tfInput:getContentSize();
			cursor:setPositionX(size.width);
			SetShowText(self.m_tfInput:getStringValue())
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            print("delete word", size.width)
			local size = tfInput:getContentSize();
			cursor:setPositionX(size.width);
			SetShowText(self.m_tfInput:getStringValue())
        end
		local fnCall = function()
			local size = tfInput:getContentSize();
			local x = size.width
			local szValue = tfInput:getStringValue();
			if string.len(szValue) == 0 then
				x = 0;
			end
			-- 超过最大长度，文字左移
			local nInputX = nPosX;
			if x > MAX_LENGTH then
				nInputX = nPosX - (x - MAX_LENGTH)			
				-- x = MAX_LENGTH;
			end
			tfInput:setPositionX(nInputX)
			-- 动态调整光标位置
			cursor:setPositionX(x);
			print("tfinput: x, nPosX", x, nPosX, nInputX);
		end
		local ac = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnCall));
		cursor:runAction(ac);

	end
	tfInput:addEventListener(fnInput);
	
	local function onKeyReleased(keyCode, event)
		if not tfInput then
			return;
		end
		if keyCode == cc.KeyCode.KEY_BACKSPACE then
			local str = tfInput:getStringValue();
			-- 先置空，不然下面一句会报错
			tfInput:setText("")
			tfInput:setText(string.sub(str, 0, string.len(str) - 1))
			SetShowText(self.m_tfInput:getStringValue())
		end
		
		local fnCall = function()
			local size = tfInput:getContentSize();
			local x = size.width
			local szValue = tfInput:getStringValue();
			if string.len(szValue) == 0 then
				x = 0;
			end
			
			local nInputX = nPosX;
			if x > MAX_LENGTH then
				nInputX = nPosX - (x - MAX_LENGTH)	
				-- x = MAX_LENGTH;
			end
			-- 超过最大长度，文字左移
			tfInput:setPositionX(nInputX)
			-- 动态调整光标位置
			cursor:setPositionX(x);
		end
		local ac = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnCall));
		cursor:runAction(ac);
	end
	local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

--@function:发送消息
function KGC_CHAT_VIEW_TYPE:SendMessage(widget)
	if not widget then
		return;
	end
	
	-- 检查时间
	local bRet, nLeftTime = self:CheckTime(self.m_nCurChannel, os.time())
	if not bRet then
		TipsViewLogic:getInstance():addMessageTipsEx(12102, nLeftTime);
		return;
	end
	self:SetTime(self.m_nCurChannel, os.time());
	
	-- local szMsg = self.m_tfInput:getStringValue();getText
	local szMsg = self.m_tfInput:getStringValue();
	local szHead = me:GetAccount()
	if self.m_nCurChannel == l_tbChannel.ECC_PERSONAL then
		szHead, szMsg = string.match(szMsg, "%s*【(.*)】%s*(.*)");
		if not szHead or not szMsg then
			TipsViewLogic:getInstance():addMessageTips(12101);
			return;
		end
	end
	if string.len(szMsg) > 0 then
		KGC_CHAT_VIEW_LOGIC_TYPE:getInstance():SendMessage(self.m_nCurChannel, szHead, szMsg);
	else
		TipsViewLogic:getInstance():addMessageTips(12100);
	end
end

function KGC_CHAT_VIEW_TYPE:ConstructText(nType, content)
	local tbRet = {};
	local r, g, b = 255, 255, 255
	
	tbRet[1] = nType or 1;
	tbRet[2] = {r, g, b}
	tbRet[3] = 255
	tbRet[4] = content
	tbRet[5] = "Helvetica"
	tbRet[6] = 26
	return tbRet;
end

function KGC_CHAT_VIEW_TYPE:ParseText(szText)
	local tbTexts = {};
	local i = 0;
	-- 特殊符号处理
	local szMod = "[\\#]"
	while(true) do
		local nStart, nEnd = string.find(szText, szMod, i);
		--处理前面一段
		local nPreEnd = (nStart or 0) - 1;
		local szPre = string.sub(szText, i, nPreEnd);
		local text = self:ConstructText(1, szText)
		table.insert(tbTexts, text);
		
		-- 处理特殊字符一段
		if nStart then
			if szText[nStart] == '\\' then
				-- 特殊字符占3个
				local szNum = string.sub(szText, nStart+1, 3);
				local text = self:ConstructText(1, szNum)
				table.insert(tbTexts, text);
				i = nStart + 4;
			else
				i = nStart + 1;
			end
			
		else
			break;
		end
	end
	return tbTexts;
end

function KGC_CHAT_VIEW_TYPE:UpdateText(tbMessages)
	print("[Log]更新聊天信息 ... ")
	local _, svText = unpack(self.m_tbChannels[self.m_nCurChannel])
	
	for _, node in pairs(self.m_tbRichTexts or {}) do
		svText:removeChild(node, true);
	end
	self.m_tbRichTexts = {};
	
	--Notify: 按照顺序显示
	for _, tbMsg in ipairs(tbMessages) do
		local nCamp, nType, szName, szMsg = unpack(tbMsg or {})
		if szMsg then
			-- print(111, nCamp, nType, szName, szMsg);
			print("[聊天]插入频道：", nType)
			local text = self:ParseText(szMsg);
			self:InsertText(nType, szName, text, nCamp)
		end
	end
	
	-- 清空输入框内容
	-- self.m_tfInput:setText("")
	
	print("[Log]更新聊天信息 end ... ")
end

--@function：根据类型获取频道
function KGC_CHAT_VIEW_TYPE:GetChannel(nType)
	local tbChannels = {};
	table.insert(tbChannels, l_tbChannel.ECC_AREA);
	if nType >= l_tbChannel.ECC_MIN and nType <= l_tbChannel.ECC_MAX then
		if nType ~= l_tbChannel.ECC_AREA then
			table.insert(tbChannels, nType);
		end
	else
		cclog("[Error]频道类型错误！@GetPannel(%s)", tostring(nType))
	end
	
	return tbChannels;
end

function KGC_CHAT_VIEW_TYPE:UpdateMessage(nCamp, nType, szName, szMsg)
	print("[Log]更新聊天信息 ... ")
	print("nCamp, nType, szName, szMsg", nCamp, nType, szName, szMsg)
	
	local tbChannels = self:GetChannel(nType)
	for _, nChannel in pairs(tbChannels) do
		if szMsg then
			local text = self:ParseText(szMsg);
			self:InsertText(nChannel, szName, text, nCamp, nType)
		end
	end
	
	-- 清空输入框内容和触发inserttextevent事件更新光标
	self.m_tfInput:setText("")
	-- self.m_tfInput:setInsertText(true);
	
	print("[Log]更新聊天信息 end ... ")
end

function KGC_CHAT_VIEW_TYPE:GetRichText(nType)
	if not self.m_tbRichTexts then
		self.m_tbRichTexts = {}
	end
	
	if not self.m_tbRichTexts[nType] then
		self.m_tbRichTexts[nType] = {};
	end
	
	return self.m_tbRichTexts[nType];
end

--@function: 插入一个聊天信息到聊天界面
--@nType: 插入的频道
--@szHead: 头标识
--@tbTexts: 聊天内容
--@nCamp: 阵营-头标识显示在左边还是右边
--@nSelfChannel: 该条消息自己所属的频道
function KGC_CHAT_VIEW_TYPE:InsertText(nType, szHead, tbTexts, nCamp, nSelfChannel)
	local _, svText = unpack(self.m_tbChannels[nType] or {});
	if not svText then
		return;
	end
	local tbRichText = self:GetRichText(nType)
	
	local nCamp = nCamp or 2;
	if nCamp ~= 1 then
		nCamp = 2;
	end
	-- local width = l_tbFightTextConfig.nWidth or 500; 		-- 固定宽度为500
	local width = self.m_nWidth;
	local height = 100;		-- 初始化高度为100
	
	local backGround = nil;
	-- 不增加新的节点
	local nMax = l_tbFightTextConfig.nMaxNums or 8;			-- 最大显示的战斗数据
	
	local nTotal = #tbRichText;
	if nTotal >= nMax then
		local nIndex = nTotal - nMax + 1;
		backGround = table.remove(tbRichText, nIndex)
		self:UpdateRichText(nType, backGround, szHead, tbTexts, nCamp, nSelfChannel)
	else
		backGround = self:CreateMessageBg(nCamp, szHead);
		self:UpdateRichText(nType, backGround, szHead, tbTexts, nCamp, nSelfChannel);
		svText:addChild(backGround);
	end
	
	-- 保存当前阵营, 更新在下一帧
	backGround._camp = nCamp;
	table.insert(tbRichText, backGround);
	
	self:RefreshText();
end

--@function: 创建一条消息的背景信息
function KGC_CHAT_VIEW_TYPE:CreateMessageBg(nCamp, szHead)
	local tbPics = {
		[1] = l_tbFightTextConfig.szPath1,
		[2] = l_tbFightTextConfig.szPath2,
	}
	-- local width = l_tbFightTextConfig.nWidth or 500; 		-- 固定宽度为500
	local height = 100;		-- 初始化高度为100
	local rx, ry, rw, rh = unpack(l_tbFightTextConfig.tbCapInsets or {10, 10, 5, 22})
	
	local backGround = nil;
	if self.m_imgBg then
		backGround = self.m_imgBg:clone();
		backGround:setVisible(true);
		backGround:loadTexture(tbPics[nCamp])
		local size = backGround:getContentSize();
		self.m_nWidth = size.width;
	else
		backGround = ccui.ImageView:create(tbPics[nCamp]);
		self.m_nWidth = l_tbFightTextConfig.nWidth or 500
	end
	local width = self.m_nWidth;
	
	backGround:ignoreContentAdaptWithSize(false);
	backGround:setScale9Enabled(true);
	backGround:setCapInsets(cc.rect(rx, ry, rw, rh));
	backGround:setContentSize(cc.size(width, height))

	-- local lblNpcName = self.m_lblNpcName:clone();
	local btnHead = self.m_btnHead:clone();
	btnHead:setEnabled(true)
	btnHead:setName("btn_head")
	btnHead:setVisible(true);
	backGround:addChild(btnHead);
	local fnTouchHead = function(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:ShowCommunication(sender);
			
			self:SetSelectedHead(nCamp, szHead);
		end
	end
	btnHead:addTouchEventListener(fnTouchHead);
	return backGround;
end

--@function: 增加一条消息
function KGC_CHAT_VIEW_TYPE:UpdateRichText(nType, backGround, szHead, tbTexts, nCamp, nSelfChannel)
	if not backGround then
		return;
	end
	local _, svText = unpack(self.m_tbChannels[nType])
	if not svText then
		return;
	end
	local tbPics = {
		[1] = l_tbFightTextConfig.szPath1,
		[2] = l_tbFightTextConfig.szPath2,
	}
	backGround:loadTexture(tbPics[nCamp])
	-- 头像
	local btnHead = backGround:getChildByName("btn_head")
	-- 名字(头像-->名字)
	local lblNpcName = btnHead:getChildByName("lbl_npc_name")
	local szNpcName = "【" .. szHead .. "】"
	lblNpcName:setString(szNpcName);
	-- 气泡背景
	local imgTimeBg = backGround:getChildByName("img_time_bg")
	imgTimeBg:setLocalZOrder(-1);
	-- 时间(气泡背景-->时间)
	local lblTime = imgTimeBg:getChildByName("lbl_time")
	local szTime = os.date("%H:%M", os.time());
	lblTime:setString(szTime);
	-- 频道(头像-->频道)
	local imgChannel = btnHead:getChildByName("img_channel")
	local lblChannel = imgChannel:getChildByName("lbl_channel")
	if nSelfChannel then
		local szChannel = l_tbChannelName[nSelfChannel]
		if szChannel then
			lblChannel:setString(szChannel);
		end
	end
	--test
	local nScale1 = backGround:getScaleX();
	local nScale2 = btnHead:getScaleX();
	local nScale3 = lblNpcName:getScaleX();
	-- print(111, nScale1, nScale2, nScale3)
	--test end
	backGround:setScaleX(1);
	btnHead:setScaleX(1);
	lblNpcName:setScaleX(1);
	lblTime:setScaleX(1);

	-- !重要：每一个聊天气泡从(0.5, 0)这个地方放置, 更方便计算
	backGround:setAnchorPoint(cc.p(0.5, 0))
	
	local sizeSvText = svText:getContentSize();
	-- local width = l_tbFightTextConfig.nWidth or 500; 		-- 固定宽度为500
	local width = self.m_nWidth;
	local height = 100;		-- 初始化高度为100
	local sizeHead = btnHead:getContentSize()
	local sizeBg = backGround:getContentSize();
	local x2 = sizeHead.width + sizeBg.width/2;				-- 靠左(默认)
	if nCamp == 1 then				--颜色(蓝)
		local r, g, b = unpack(l_tbFightTextConfig.tbColorBlue or {0, 153, 255})
		lblNpcName:setColor(cc.c3b(r, g, b));
	elseif nCamp == 2 then			--颜色(红)
		local r, g, b = unpack(l_tbFightTextConfig.tbColorRed or {255, 110, 0})
		lblNpcName:setColor(cc.c3b(r, g, b));
		x2 = sizeSvText.width - x2;	-- 靠右
	else
		-- lblNpcName:setColor(cc.c3b(255, 0, 255));
	end
	local x1 = sizeBg.width + sizeHead.width/2;
	
	btnHead:setPosition(cc.p(x1, sizeBg.height/2))
	backGround:setPosition(cc.p(x2, -30));
	
	if nCamp == 1 then
		backGround:setScaleX(-1);
		-- btnHead:setScaleX(-1);
		lblTime:setScaleX(-1);
	end
	btnHead:setScaleX(-1)
	if nCamp == 2 then
		lblNpcName:setScaleX(-1);
		lblChannel:setScaleX(-1);
	end
	
	-- 更新text
	local richText = backGround:getChildByName("richtext")
	if richText then
		richText:setName(os.time())
		richText:removeFromParent(true);
	end
	richText = ccui.RichText:create()
	richText:setVisible(false);
	richText:ignoreContentAdaptWithSize(true)
	local nWidthModify = l_tbFightTextConfig.nWidthModify or 25;
	richText:setContentSize(cc.size(width - nWidthModify, height))
	local size = backGround:getContentSize();
	richText:setPosition(cc.p(size.width/2, size.height/2))
	richText:setName("richtext")
			
	if nCamp == 1 then
		richText:setScaleX(-1)
	end
	backGround:addChild(richText)
	-- notify: 必须从小到大顺序填写
	for tag, tbItems in ipairs(tbTexts or {}) do
		local item = nil;
		local nType = tbItems[1];
		local r, g, b = unpack(tbItems[2])
		local nOpacity = tbItems[3]
		local szText = tbItems[4];
		local nFontSize = tbItems[6]
		if nType == 1 then
			item = ccui.RichElementText:create(tag, cc.c3b(r, g, b), nOpacity, szText, "Helvetica", nFontSize)
		elseif nType == 3 then		-- 自定义节点
			item = ccui.RichElementCustomNode:create(tag, cc.c3b(r, g, b), nOpacity, szText)
		end
		if item then
			richText:pushBackElement(item);
		end
	end
	
	-- 现在下一帧把最大长度调整一下
	local fnUpdate = function()
		local sizeRichText = richText:getVirtualRendererSize();
		local nWidthNew = sizeRichText.width + nWidthModify;
		if nWidthNew > width then
			richText:setContentSize(cc.size(width - nWidthModify, sizeRichText.height))
			richText:ignoreContentAdaptWithSize(false)
		end
	end
	
	richText:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnUpdate)))
end

--@function：刷新界面, 更新大小
function KGC_CHAT_VIEW_TYPE:RefreshText()
	print("RefreshText start ...")
	local height = 100;		-- 初始化高度为100
	local nWidthModify = l_tbFightTextConfig.nWidthModify or 25;
	local width = self.m_nWidth;
	local tbRichText = self:GetRichText(self.m_nCurChannel)
	if not tbRichText then
		return;
	end
	
	-- 先在下一帧把最大长度调整一下
	for i= #tbRichText, 1, -1 do
		local node = tbRichText[i]
		local richText = node:getChildByName("richtext");
		local fnUpdate = function()
			local sizeRichText = richText:getVirtualRendererSize();
			local nWidthNew = sizeRichText.width + nWidthModify;
			if nWidthNew > width then
				richText:setContentSize(cc.size(width - nWidthModify, sizeRichText.height))
				richText:ignoreContentAdaptWithSize(false)
			end
		end
		
		richText:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnUpdate)))
	end
		
		
	local _, svText = unpack(self.m_tbChannels[self.m_nCurChannel])
	if not svText then
		return;
	end
	local fnMove = function()
		local nTotal = #tbRichText;
		if nTotal <= 0 then
			return;
		end
		local posYS = l_tbFightTextConfig.nStartHeight or 30;	-- 起始高度
		local nInterval = l_tbFightTextConfig.nSpace or 5;		-- 间隔
		local nMax = l_tbFightTextConfig.nMaxNums or 8;			-- 最大显示的战斗数据
		
		-- 先放在最下面，再整体向上移动
		local node = tbRichText[nTotal]
		node:setPositionY(posYS)
		
		local fnModify = function(node)
			local btnHead = node:getChildByName("btn_head")
			local lblNpcName = btnHead:getChildByName("lbl_npc_name")
			local nNameX, nNameY = lblNpcName:getPosition();
			local sizeName = lblNpcName:getContentSize();
			local sizeHead = btnHead:getContentSize()
			
			local nCamp = node._camp or 2;
			local richtextPre = node:getChildByName("richtext");
			richtextPre:setVisible(true);
			local sizeRichText = richtextPre:getVirtualRendererSize();
			local nWidthNew = sizeRichText.width + nWidthModify;
			
			local nRichH = sizeRichText.height;
			if nRichH <= 0 then
				nRichH = height;
			end
			
			local nHeightModify = l_tbFightTextConfig.nHeightModify or 25;
			local nMove = nRichH + nHeightModify;
			
			node:setContentSize(cc.size(nWidthNew, nMove))
			-- print("[聊天]新的大小, nMove, height", nMove, sizeRichText.height, sizeRichText.width, tostring(node))
			richtextPre:setPosition(cc.p(nWidthNew/2, nMove/2))
			
			local xTest = nWidthNew - (nNameY - sizeName.height/2)
			local x0 = nWidthNew + sizeHead.width/2;
			-- 从studio得到的坐标还是相对原点的, 这是个bug
			local nNameY = nNameY - sizeHead.height/2
			-- 公式：y = 节点高度 + 名字高度/2 - 名字y坐标
			local y0 = nMove - (nNameY - sizeName.height/2)
			if y0 < 0 then
				y0 = nMove/2;
			end
			-- print(y0, nMove, nNameY, sizeName.height);
			btnHead:setPosition(cc.p(x0, y0));
			
			local sizeSvText = svText:getContentSize();
			local x2 = sizeHead.width + nWidthNew/2
			if nCamp == 2 then
				x2 = sizeSvText.width - x2;
			end
			-- print("x2 = ", x2, tostring(node), nCamp);
			node:setPositionX(x2)
			-- 计算多出来的一部分：头像高度/2 - 名字Y坐标 + 名字高度/2
			local nAddInterval = sizeHead.height/2 - nNameY + sizeName.height/2;
			return nMove + nInterval + nAddInterval;
		end
		-- local nNewHeight = fnModify(node)
		
		--所有都重新调整大小(渲染getVirtualRendererSize才会得到真正的大小)
		local nYAdd = 0;
		for i= nTotal, 1, -1 do
			local node = tbRichText[i]
			if i > nTotal - nMax then	
				local h = fnModify(node)
				local posX, posY = node:getPosition();
				posY = posYS + nYAdd;
				node:setPosition(cc.p(posX, posY));
				nYAdd = nYAdd + h;
			else
				-- 需要用这个接口，而不是removeFromParent(看c++代码_innerContainer)
				svText:removeChild(node, true);
			end
		end

		for i = nTotal, 1, -1 do
			if i <= nTotal - nMax then
				table.remove(tbRichText, i);
			end
		end
		
		-- 第一个参数为时间, 为0的话会有问题, c++代码除以这个time
		svText:scrollToBottom(0.01, false);
	end
	
	-- 注意：延时getVirtualRendererSize的值才会刷新
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnMove)))
	print("RefreshText end ...")
end

function KGC_CHAT_VIEW_TYPE:ShowCommunication(widget)
	self.m_pnlCommunication:setVisible(true);
	local x, y = widget:getPosition();
end

--@function: 点击头像弹出来交互相关按钮点击事件处理
function KGC_CHAT_VIEW_TYPE:TouchEventCommunication(widget)
	local szName = widget:getName();
	if szName == "btn_private_chat" then				-- 私聊
		self:ChangeChannel(l_tbChannel.ECC_PERSONAL)
		self.m_pnlCommunication:setVisible(false);
		local tbSelectedHead = self:GetSelectedHead();
		local nCamp = tbSelectedHead.nCamp or 0;
		local szName = tbSelectedHead.szName or "";
		local szText = "【" .. szName .. "】"
		self.m_tfInput:setText(szText)
	elseif szName == "btn_check_info" then				-- 查看详细
	
	elseif szName == "btn_add_friend" then				-- 加好友
	
	end
end

function KGC_CHAT_VIEW_TYPE:GetSelectedHead()
	if not self.m_tbSelectedHead then
		self.m_tbSelectedHead = {};
	end
	return self.m_tbSelectedHead;
end

function KGC_CHAT_VIEW_TYPE:SetSelectedHead(nCamp, szName)
	local tbHead = self:GetSelectedHead();
	tbHead.nCamp = nCamp;					-- 阵营：自己说的还是其他人说的
	tbHead.szName = szName;					-- 名字：显示的玩家名字或者ID以标识
end

--@function: 
function KGC_CHAT_VIEW_TYPE:GetAllTime()
	if not self.m_tbTime then
		self.m_tbTime = {};
	end
	
	return self.m_tbTime;
end

--@function: 获取某个频道上一次发送的时间
function KGC_CHAT_VIEW_TYPE:GetTime(nChannel)
	local tbTime = self:GetAllTime();
	local nTime = tbTime[nChannel] or 0;
	return nTime;
end

--@function: 设置某个频道发送消息的时间
function KGC_CHAT_VIEW_TYPE:SetTime(nChannel, nTime)
	local tbTime = self:GetAllTime();
	tbTime[nChannel] = nTime;
end

--@function: 检查某个频道是否在可发送消息的时间内
function KGC_CHAT_VIEW_TYPE:CheckTime(nChannel, nTime)
	local nLastTime = self:GetTime(nChannel);
	local nTime = nTime or 0;
	local tbConfig = l_tbChatConfig[nChannel] or {};
	local nInterval = tbConfig.time or 0;
	local nPassTime = nTime - nLastTime;
	
	if nPassTime > nInterval then
		return true;
	end
	local nLeftTime = nInterval - nPassTime;
	return false, nLeftTime;
end

function KGC_CHAT_VIEW_TYPE:OnExit()

end


--------------------------------
