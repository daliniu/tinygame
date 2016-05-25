----------------------------------------------------------
-- file:	NULL
-- Author:	page
-- Time:	2015/01/27
-- Desc:	ui
----------------------------------------------------------
-- require "script/ui/define"
require "script/ui/resource"
require("script/ui/networkview/NetworkView")
require "script/cocos2dx/experimentalConstants"
local l_tbGameState = def_GetGameState();
----------------------------------------------------------
--data struct
local TB_UILOGIN_DATA = {
	--config
	m_szFile = CUI_JSON_LOGIN_PATH,		--界面文件路径

	--界面
	m_Layout = false,					--保存界面结构root
	m_Layer = false,					--自己维护一个layer
	m_LoginInfo,						--登录信息层
	m_BtnLogin,							--登录按钮
	m_TextUser,							--用户名输入框
	m_TextPas,							--密码输入框

	m_nTimes = 0,						-- 进度条当前更新进度
	m_nMaxTimes = 0,					-- 进度条更新总次数

	m_mainPnl = nil,					--主层
	m_maskImg = nil,					--白蒙板
}

KG_UILogin = class("KG_UILogin", KGC_UI_BASE_LAYER, TB_UILOGIN_DATA)
--------------------------------
--ui function
--------------------------------
function KG_UILogin:ctor(tbArg)

end

function KG_UILogin:init(tbArg)
	-- self:InitBase(tbArg)

	self:createLayer()

	self:playBackgroundMusic()
end

function KG_UILogin:createLayer()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_LOGIN_PATH)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	self:LoadScheme()

	--网络初始化
	if not DEBUG_CLOSED_NETWORK then
		g_Core:initCommunicator();
	end
end

--@function:　更新加载进度条
function KG_UILogin:UpdateProgress()
	local progressBar = ccui.Helper:seekWidgetByName(self.m_Layout, "progressbar")
	progressBar:setVisible(true);
	local imgHead = progressBar:getChildByName("img_head")

	-- 定时器更新进度条
	local nTimes = self.m_nTimes + 1;
	self.m_nTimes = nTimes;
	local nTotal = self.m_nMaxTimes or 1;
	-- print(777, nTimes, nTotal, nPercent)
	local nPercent = 0;
	if nTotal > 0 then
		nPercent = (nTimes / nTotal) * 100
	end
	if nPercent > 100 then
		nPercent = 100;
	end
	progressBar:setPercent(nPercent);					--更新进度条

	if nTimes >= nTotal then
		self.m_fnCallBack();
		KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():closeLayer();
	end
end

--@function: 注册进度条事件
--@nTimes: 进度条分段
--@fnCallBack: 进度条满时候回调函数
function KG_UILogin:RegisterProgressEvent(nTimes, fnCallBack)
	if not fnCallBack then
		return false;
	end
	self.m_nMaxTimes = nTimes or 0;
	self.m_fnCallBack = fnCallBack;

	return true;
end

-- 背景音乐
function KG_UILogin:playBackgroundMusic()
    AudioManager:getInstance():setBackgroundMusicVolume(0.8)
    AudioManager:getInstance():playBackground("res/audio/background/audio_bg_main_01");
end

--解析界面文件
function KG_UILogin:LoadScheme()
	--login info
	self.m_mainPnl = ccui.Helper:seekWidgetByName(self.m_Layout, "Panel_4")
	self.m_maskImg = ccui.Helper:seekWidgetByName(self.m_Layout, "Image_18")
	self.m_LoginInfo = ccui.Helper:seekWidgetByName(self.m_Layout, "img_login");
	self.m_BtnLogin = ccui.Helper:seekWidgetByName(self.m_Layout, "Button_3")
	self.m_TextUser = ccui.Helper:seekWidgetByName(self.m_Layout, "phonenumber")
	self.m_TextPas = ccui.Helper:seekWidgetByName(self.m_Layout, "code")
	self.m_PnlSelectArea = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_select_area")

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	self.m_TextUser:setVisible(true);
--[[
	if  cc.PLATFORM_OS_ANDROID == targetPlatform then
		self.m_TextUser:setVisible(false)
	end
]]--
	local function touchEvent(sender,eventType)
		me:SetPlat(targetPlatform)
		print('login touchEvent = ', cc.PLATFORM_OS_ANDROID, targetPlatform)
		me:SetArea(1)
		
		-- 设置登录状态
		g_Core:SetGameState(l_tbGameState.TS_LOGINING);

		if sender == self.m_BtnLogin then
			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.ended then

				-- 登录回调函数
				local loginCallback = function(outArgs)
					if outArgs.retCode == NETWORK_RETCODE_SUCCESS then
						--登录成功
						LoginViewLogic:getInstance():onLogin(true, outArgs.playerInfo)

						sender:setVisible(false)
						self.m_LoginInfo:setVisible(false);
					else
						self:LoginFailed()

						sender:setVisible(true)
						self.m_LoginInfo:setVisible(true);
					end
				end

				-- 区分平台处理
--[[
if  cc.PLATFORM_OS_ANDROID == targetPlatform then				-- android平台
				local onLoginSuccess = function(_code, _authInfo)
					print("..........onLoginSuccess", _code, _authInfo)
					cclog("..........onLoginSuccess %d : %s", _code, _authInfo)

					-- 保存帐号和区服
					g_Core.authInfo = _authInfo
					g_Core.area = 1;
					--测试兼容平台 end
					-- 服务端登录接口
					g_Core.communicator.conn.loginGame({authInfo=g_Core.authInfo, area=1, code=_code, plat=targetPlatform}, loginCallback)
				end

				local onLoginCancel = function(code, msg)
					print("..........onLoginCancel", code, msg)
					cclog("..........onLoginCancel", code, msg)
					self:LoginFailed()
				end

				local onLoginFail = function(code, msg, channelCode)
					print("..........onLoginFail", code, msg, channelCode)
 					self:LoginFailed()
				end

				-- sdk处理
				local mySdk = ProtocolXGSDK:new()
				mySdk:setListener(onLoginSuccess, sdk.XGSDKCALLBACK_ONLOGINSUCCESS)
				mySdk:setListener(onLoginCancel, sdk.XGSDKCALLBACK_ONLOGINCALCEL)
				mySdk:setListener(onLoginFail, sdk.XGSDKCALLBACK_ONLOGINFAIL)
				mySdk:login("tinygame")
else
]]--															-- windows平台
				local user = self.m_TextUser:getStringValue();
				local password = self.m_TextPas:getStringValue();
				if string.len(user) <= 0 and not DEBUG_CLOSED_NETWORK then
					self:ShowTips("Please Input Username ... ")
					return false;
				end

				-- 保存帐号和区服
				g_Core.authInfo = user
				g_Core.area = 1;
				g_Core.communicator.conn.loginGame({authInfo=user, area=1, code=0, plat=targetPlatform}, loginCallback)
--[[
end
]]--
				-- sender:setVisible(false)
				-- self.m_LoginInfo:setVisible(false);
				-- self:Loading()
			elseif eventType == ccui.TouchEventType.canceled then
			end
		elseif sender == self.m_BtnSelAreas then
			if eventType == ccui.TouchEventType.ended then
				if self.m_PnlSelectArea then
					--self.m_PnlSelectArea:setVisible(true)
					--self.m_ImgSelAreas:setVisible(false)
				g_Core:closeNetwork()
				g_Core.gateIP = "10.20.68.103"
				g_Core:initCommunicator();
				self.m_ImgSelAreas:setVisible(false)
				end
			end
		else
			self.m_Widget = sender;
		end
    end
	self.m_BtnLogin:addTouchEventListener(touchEvent);
	self.m_TextUser:addTouchEventListener(touchEvent)
	self.m_TextPas:addTouchEventListener(touchEvent);

	local function onKeyReleased(keyCode, event)
		local label = self.m_Widget
		--test
		-- if keyCode == cc.KeyCode.KEY_T then
			-- print("test ... ")
			-- self:TestOpenTestUI();
		-- end
		--test end

		if not self.m_Widget then
			return;
		end
		if keyCode == cc.KeyCode.KEY_BACKSPACE then
			local str = label:getStringValue();
			-- 先置空，不然下面一句会报错
			label:setText("")
			label:setText(string.sub(str, 0, string.len(str) - 1))
		end
	end
	local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	-- 加载进度条
	local progressBar = ccui.Helper:seekWidgetByName(self.m_Layout, "progressbar")
	progressBar:setVisible(false);
	self.m_nTimes = 0;
	self.m_nMaxTimes = 0;
	--test
	--[[
	local fnTestTouchEvent = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			local zOrder = self.pnl_test_blue:getLocalZOrder();
			print("Test ... ", zOrder, zOrder == 1 and 0 or 1)
			-- self.pnl_test_blue:setLocalZOrder(zOrder == 1 and 0 or 1)
			-- self.pnl_test_red:setLocalZOrder(zOrder == 1 and 1 or 0)
			-- sender:setLocalZOrder(1)
			sender:setGlobalZOrder(100)
		end
	end
	self.pnl_test_blue = ccui.Helper:seekWidgetByName(self.m_Layout, "pngl_test_blue")
	self.btn_test = ccui.Helper:seekWidgetByName(self.pnl_test_blue, "btn_test")
	self.pnl_test_red = ccui.Helper:seekWidgetByName(self.m_Layout, "pnl_test_red")
	self.img_test = ccui.Helper:seekWidgetByName(self.pnl_test_red, "img_test")
	self.btn_test:addTouchEventListener(fnTestTouchEvent);
	]]
	--test end

	local fnCall = function()
		self.m_BtnLogin:setVisible(true);
		self.m_LoginInfo:setVisible(true);
	end
	-- 播放动画
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_WINDOWS ~= targetPlatform) then
    	-- self.m_maskImg:setVisible(true)
    	self.m_mainPnl:setVisible(false)
    	local tSize = self.m_Layout:getContentSize()
		local videoPlayer = ccexp.VideoPlayer:create()
	    videoPlayer:setPosition(cc.p(tSize.width / 2, tSize.height / 2))
	    videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
	    videoPlayer:setFullScreenEnabled(true)
	    videoPlayer:setContentSize(tSize)
	    videoPlayer:setTouchEnabled(false)
	    self:addChild(videoPlayer, -1)
	    -- local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("res/animation/opening1.mp4")
        videoPlayer:setFileName("res/animation/opening1.mp4")
        local function onVideoEventCallback(sener, eventType)
	        if eventType == ccexp.VideoPlayerEvent.COMPLETED then
	        	videoPlayer:stop()
	        	videoPlayer:removeFromParent(true)
	        	self.m_Layout:setVisible(true)
	        	-- self.m_maskImg:setVisible(false)
				self.m_mainPnl:setVisible(true)
	        	ccs.ActionManagerEx:getInstance():playActionByName("login.json", "Animation0", cc.CallFunc:create(fnCall))
	            fnCall()
	        elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
	        	videoPlayer:resume()
	        end
	    end
	    videoPlayer:addEventListener(onVideoEventCallback)
	    --延时再进行播放，部分机型立即播放会无法显示
    	self.m_Layout:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    		videoPlayer:play()
    	end)))
	else
		self.m_Layout:setVisible(true)
		ccs.ActionManagerEx:getInstance():playActionByName("login.json", "Animation0", cc.CallFunc:create(fnCall))
    end
end

function KG_UILogin:OnExit()

end

function KG_UILogin:LoginFailed(szErr)
	print("登录失败：", szErr)
	local label = cc.Label:createWithTTF(szErr or "", CUI_PATH_FONT_MARKER_FELT, 30)
	-- label:setColor(cc.c3b(0, 0, 0))
	local size = self:getContentSize()
	label:setPosition(cc.p(size.width/2, size.height/2))
	self:addChild(label, 10)
	local call = function()
		label:removeFromParent(true);
		self.m_BtnLogin:setVisible(true)
		self.m_LoginInfo:setVisible(true);
	end


	local action = cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(call))
	label:runAction(action)
end

function KG_UILogin:ShowTips(szMsg)
	print("弹tips: ", szMsg)
	if not szMsg or string.len(szMsg) <= 0 then
		return;
	end

	local label = cc.Label:createWithTTF(szMsg, CUI_PATH_FONT_MARKER_FELT, 30)
	-- label:setColor(cc.c3b(0, 0, 0))
	local size = self:getContentSize()
	label:setPosition(cc.p(size.width/2, size.height/2))
	self:addChild(label, 10)
	local call = function()
		label:removeFromParent(true);
		self.m_BtnLogin:setVisible(true)
		self.m_LoginInfo:setVisible(true);
	end

	local action = cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(call))
	label:runAction(action)
end
--------------------------------
--relisization
-- g_uiLogin = KG_UILogin.new()

--------------------------------
--test
function KG_UILogin:TestOpenTestUI()
	 local layout = ccs.GUIReader:getInstance():widgetFromJsonFile("res/test_leak.json")
    self:addChild(layout)
	local btnClose = layout:getChildByName("btn_close");
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			layout:runAction(cc.RemoveSelf:create());
		end
	end
	btnClose:addTouchEventListener(fnClose);

	local tbBlend = {
		[1] = gl.ONE,
		[2] = gl.ZERO,
		[3] = gl.SRC_ALPHA,
		[4] = gl.DST_ALPHA,
		[5] = gl.ONE_MINUS_SRC_ALPHA,
		[6] = gl.ONE_MINUS_DST_ALPHA,
	}

	print(111)
	for k, v in pairs(tbBlend) do
		print(k, type(k), v);
	end

	print(222)
	for k, v in ipairs(tbBlend) do
		print(k, type(k), v);
	end

	print(333, #tbBlend, table.getn(tbBlend))
	-- blend test
	-- print("222")
	-- local imgTest = layout:getChildByName("Image_24");
	-- imgTest:setVisible(false);
	-- local x, y = imgTest:getPosition();
	-- local sprite = cc.Sprite:create("res/ui/11_team/001_ob_03_1.png")
	-- layout:addChild(sprite);
	-- sprite:setPosition(cc.p(x+50, y));
	-- sprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	-- sprite:setBlendFunc(gl.ONE, gl.GL_ONE_MINUS_DST_COLOR)
	-- 特效

	local img2 = layout:getChildByName("Panel_23");
	local img3 = layout:getChildByName("Image_24");
	img3:setVisible(false);

	-- widget　没有setBlendFunc函数
	-- local sprite = cc.Sprite:create("res/ui/11_team/001_ob_03_1.png")
	local sprite = cc.Sprite:create("res/ui/11_team/001_ob_05_1.png")
	local sprite2 = cc.Sprite:create("res/ui/11_team/001_ob_01_1.png");
	layout:addChild(sprite);
	sprite:setPosition(cc.p(570, 500));
	gf_SetRandomSeed(os.time());
	local nRand = math.random(#tbBlend)
	local src = tbBlend[nRand];
	print("随机源：", nRand, src, #tbBlend)
	sprite:setBlendFunc(src, gl.ONE);

	sprite:addChild(sprite2);
	sprite2:setPosition(cc.p(18, 37));
end
