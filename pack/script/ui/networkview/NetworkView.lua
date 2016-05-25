----------------------------------------------------------
-- file:	NULL
-- Author:	page
-- Time:	2015/01/27
-- Desc:	ui
----------------------------------------------------------
require "script/ui/resource"


----------------------------------------------------------
--data struct
local TB_UINETWORK_DATA = {
	m_szFile = CUI_JSON_NETWORK,
	m_Layout = false,
	m_Layer = false,
	m_NetworkInfo,
	m_BtnLogin,
	m_LblDisplay,
	m_BtnClose
}

KG_UINetwork = class("KG_UINetwork", KGC_UI_BASE_LAYER, TB_UINETWORK_DATA)
--------------------------------
--ui function
--------------------------------
function KG_UINetwork:ctor()
	print('KG_UINetwork:ctor')
end

function KG_UINetwork:init()
	self:createLayer(CUI_JSON_NETWORK)
end

function KG_UINetwork:createLayer(filePath)
	print('KG_UINetwork:createLayer',filePath)
	self.m_Layer = cc.Layer:create()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(filePath)
	assert(self.m_Layout)
	local visibleSize = cc.Director:getInstance():getVisibleSize();

    self.m_Layout:setAnchorPoint(0.5,0.5)
    self.m_Layout:setPosition(cc.p(visibleSize.width/2,visibleSize.height/2));
    self:setLocalZOrder(-100)

	self:addChild(self.m_Layout)
	self:parse()
	self:connected()
	return self.m_Layer;
end

function KG_UINetwork:connecting()
	self.m_BtnClose:setVisible(false)
	self.m_BtnReconnect:setVisible(false)
	self:setVisible(true)
	self:setLocalZOrder(100)
	bg = ccui.Helper:seekWidgetByName(self.m_Layout, "imgBackground")
	-- 断线播放动作
	local rtAction = cc.RotateBy:create(5, 360)
	local rpAction = cc.RepeatForever:create(rtAction)
	bg:runAction(rpAction)
	self.m_LblDisplay:setString('正在连接中...')
end

function KG_UINetwork:disconnect()
	self.m_BtnClose:setVisible(true)
	self.m_BtnReconnect:setVisible(true)
	self:setVisible(true)
    self:setLocalZOrder(100)
	bg = ccui.Helper:seekWidgetByName(self.m_Layout, "imgBackground")
	-- 断线播放动作
	local rtAction = cc.RotateBy:create(5, 360)
	local rpAction = cc.RepeatForever:create(rtAction)
	bg:runAction(rpAction)
	self.m_LblDisplay:setString('已断线，请重连...')
end

function KG_UINetwork:kick()
	self.m_BtnClose:setVisible(true)
	self.m_BtnReconnect:setVisible(true)
	self:setVisible(true)
    self:setLocalZOrder(100)
	bg = ccui.Helper:seekWidgetByName(self.m_Layout, "imgBackground")
	-- 断线播放动作
	local rtAction = cc.RotateBy:create(5, 360)
	local rpAction = cc.RepeatForever:create(rtAction)
	bg:runAction(rpAction)
	self.m_LblDisplay:setString('已被踢下线，请重连或退出...')
end

function KG_UINetwork:sending()
	self.m_BtnClose:setVisible(false)
	self.m_BtnReconnect:setVisible(false)
	self:setVisible(true)
    self:setLocalZOrder(100)
	bg = ccui.Helper:seekWidgetByName(self.m_Layout, "imgBackground")
	-- 断线播放动作
	local rtAction = cc.RotateBy:create(2, 360)
	local rpAction = cc.RepeatForever:create(rtAction)
	bg:runAction(rpAction)
	self.m_LblDisplay:setString('发送中...')
end

function KG_UINetwork:connected()
	self:setVisible(false)
    self:setLocalZOrder(-100)
	bg = ccui.Helper:seekWidgetByName(self.m_Layout, "imgBackground")
	bg:stopAllActions()

end

function KG_UINetwork:parse()
	self.m_BtnClose = self.m_Layout:getChildByName("btnClose")
	self.m_BtnReconnect = self.m_Layout:getChildByName("btnReconnect")
	self.m_LblDisplay = self.m_Layout:getChildByName("lblDisplay")

	--self.m_TextUse = ccui.Helper:seekWidgetByName(self.m_Layout, "phonenumber")

	local function touchEvent(sender,eventType)
		if sender == self.m_BtnReconnect then
			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.ended then
			-- 重连逻辑
			print('reconnect.........')
			self:connecting()
			--GameSceneManager:getInstance():connect()
			g_Core:initNetCommunicator(__reLogin)
			end
		else
			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.ended then
			-- 退出逻辑
			print('close.........')
			self:connected()
			print('KG_UINetwork  LoginOut')
			g_Core:LoginOut();
			end
		end
    end
	self.m_BtnReconnect:addTouchEventListener(touchEvent);
	self.m_BtnClose:addTouchEventListener(touchEvent)

end

function KG_UINetwork:OnExit()

end

