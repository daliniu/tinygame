require("script/lib/basefunctions")
require("script/ui/networkview/NetworkView")
require("script/ui/networkview/NetworkLogic")

local Exbuffer = require("script/core/network/parse")
local scheduler = require("script/core/network/scheduler")
local DataCache = require("script/core/network/data_cache")

local TClient = gf_class()
local TCLIENT_RECONNECT_TIME          = 3             -- 断线重新发起重连次数
local TCLIENT_MAX_MSG_CACHE           = 10            -- 客户端缓存消息最大值
local TCLIENT_MAX_MSG_COUNT           = 99999         -- 客户端缓存消息最大计数值
local TCLIENT_HEARTBEAT_TIME          = 1             -- 心跳发送间隔
local TCLIENT_MAX_HEARTBEAT           = 99999         -- 心跳最大计数值
local TCLIENT_HEARTBEAT_EXPIRE_COUNT  = 5	         -- 连续N个心跳包没收到ack则认为此连接已断线

local TCLIENT_CONN_STATE_DISCONNECT   = 0
local TCLIENT_CONN_STATE_CONNECTING   = 1
local TCLIENT_CONN_STATE_CONNECTED    = 2
local TCLIENT_CONN_STATE_HANGING      = 3
local TCLIENT_CONN_STATE_CLOSE        = 4
local TCLIENT_RECONNECT_TRY_MAX_COUNT = 3	         -- 重连最大尝试次数

-- 重新登录
function __reLogin()
	if me == nil then
		return
	end
	local user = me:GetAccount()
	local _area = me:GetArea()
	local _plat = me:GetPlat()

	print("__reLogin = ", user, _area, _plat)

	if string.len(g_Core.authInfo) > 0 then
		local loginCallback = function(outArgs)
			if outArgs.retCode == NETWORK_RETCODE_SUCCESS then
				--登录成功
				--LoginViewLogic:getInstance():onLogin(true, outArgs.playerInfo)
			else
 				g_Core:LoginOut();
 			end
		end
		g_Core.communicator.conn.loginGame({authInfo=g_Core.authInfo, area=_area, code=0, plat=_plat}, loginCallback)
	end
end


function TClient:ctor(__host, __port, __callback)
    self.host               = __host
    self.port               = __port
	self.reconnectScheduler = nil
	self.heartbeatScheduler = nil
	self.connectState       = TCLIENT_CONN_STATE_DISCONNECT
	self.reconnNum          = 0
	self.msgCache           = DataCache.new(TCLIENT_MAX_MSG_CACHE)
	self.healthCache        = DataCache.new(TCLIENT_MAX_HEARTBEAT)
	self.reLoginCallback    = nil                                     -- 重新连接重新登录回调函数
	self.callback           = __callback
	self:connect(__host, __port)
end

function TClient:registerHandle()

	local function onOpen(strData)
		print("onOpen was fired")
		--self.connector:sendString('open..........')

		NetworkLogic:getInstance():connectedNetwork()
		--已经连接上
		self:connected()

		-- 网络连接完成调用回调
		if self.callback then
			self.callback()
			self.callback = nil
		end

		--把堆积的消息发送给服务端
		self:sendDelayMsg()
	end

	local function onMessage(Data)
		-- test
		local tbData = Exbuffer:unpack(Data)
		if tbData then
			NetworkLogic:getInstance():connectedNetwork()
			recvCallback(tbData)
		else
			print('protocol parse failed')
		end
	end

	local function onClose(tbData)
		print("onClose was fired")
		if self.connectState ~= TCLIENT_CONN_STATE_CLOSE then
			print('onClose|close with exception')
			self:disconnect()
			self:reconnect()
		else
			self:disconnect()
		end
	end

	local function onError(tbData)
		print("onError was fired")
		self:close()
		self:reconnect()
	end

	self.connector:registerScriptHandler(onOpen, cc.WEBSOCKET_OPEN)
	self.connector:registerScriptHandler(onMessage, cc.WEBSOCKET_MESSAGE)
	self.connector:registerScriptHandler(onClose, cc.WEBSOCKET_CLOSE)
	self.connector:registerScriptHandler(onError, cc.WEBSOCKET_ERROR)
end

function TClient:isRetry()
	if self.reconnNum >= TCLIENT_RECONNECT_TRY_MAX_COUNT then
		self.reconnNum = 0
		return false
	else
		self.reconnNum = self.reconnNum + 1
		return true
	end
end

function TClient:connected()
	self.connectState = TCLIENT_CONN_STATE_CONNECTED
	self.reconnNum = 0
	-- 重新登录
	if self.reLoginCallback ~= nil then
		self.reLoginCallback()
	end
end

function TClient:disconnect()
	self.connectState = TCLIENT_CONN_STATE_DISCONNECT
	self.connector = nil
end

function TClient:reconnect()
	-- 状态为连接中则不可重复触发
	if self.connectState ~= TCLIENT_CONN_STATE_CONNECTING then

		NetworkLogic:getInstance():connectingNetwork()

		-- 关闭连接
		if self.connector ~= nil then
			-- 这里会阻塞需要处理
			self:close()
		end

		-- 设置重连回调函数
		self.reLoginCallback = __reLogin

		self.connectState = TCLIENT_CONN_STATE_CONNECTING

		local function __connect()
			self:connect(self.host, self.port)
		end

		if self:isRetry() then
			if self.reconnectScheduler then
				scheduler.unscheduleGlobal(self.reconnectScheduler)
			end
			self.reconnectScheduler = scheduler.performWithDelayGlobal(__connect, TCLIENT_RECONNECT_TIME)
		else
			print('reconnect|beyond connect count.........')
			-- 连接3次不成功
			self:close()
			NetworkLogic:getInstance():disconnectNetwork()
		end
	end
end

function TClient:connect(__host, __port)
	-- 连接服务器
	self.connector = cc.WebSocket:create("ws://"..__host..":"..__port)

	-- 注册监听函数
	if nil ~= self.connector then
		self:registerHandle()
	else
		print('connect|init fail')
	end

	-- 设置发送心跳
	if not DEBUG_CLOSED_NETWORK then
		-- self:setHeartBeat()
	end
	print('connect|connecting')
	-- connect 完成，但不代表连接成功
	self.connectState = TCLIENT_CONN_STATE_HANGING
end

function TClient:sendEx(data, isLoadUi)
	-- 连接未打开则缓存消息
	local msg = Exbuffer:pack(data)
	if self.connector == nil or
		self.connectState ~= TCLIENT_CONN_STATE_CONNECTED then
		self:pushMsgToCache(msg)
		-- 状态为连接中则不可重复触发
		self:reconnect()
	else
		if isLoadUi then
			NetworkLogic:getInstance():sendingNetwork()
		end
		self.connector:sendString(msg)
	end
end

-- 发送缓存消息
function TClient:sendDelayMsg()
	--缓存为空则直接返回
	for k, v in pairs(self.msgCache:data()) do
		print('sendDelayMsg|key:'..k..'|data:'..v)
		self:sendEx(v)
	end
	self.msgCache:clear()
end

-- 存储缓存消息
function TClient:pushMsgToCache(data)
	-- 缓存消息
	print('pushMsgToCache|'..data)
	self.msgCache:push(data)
end

function TClient:close()
	self.connectState = TCLIENT_CONN_STATE_CLOSE
	if self.heartbeatScheduler then
		scheduler.unscheduleGlobal(self.heartbeatScheduler)
	end
	if self.connector ~= nil then
		self.connector:close()
	end
	self.msgCache:clear()
	self.connector = nil
end

--设置发送心跳包
function TClient:setHeartBeat()
	-- 清空心跳cache
	self.healthCache:clear()

	local function __heartBeat()
		-- 发送 心跳包不需要缓存
		local heartNum = self.healthCache:push(0)
		if self.connector ~= nil then

		end
		-- 检查心跳准备重连
		self:checkHealth()
	end

	if self.heartbeatScheduler then
		scheduler.unscheduleGlobal(self.heartbeatScheduler)
	end

	self.heartbeatScheduler = scheduler.scheduleGlobal(__heartBeat, TCLIENT_HEARTBEAT_TIME)
end

-- 检查心跳是否正常，不正常则重新连接
function TClient:checkHealth()
	local Num = 0

	-- 计算未收到ack的心跳个数
	-- 在一个集合中取最长的连续序列
	--for k, v in pairs(self.healthCache:data()) do
		--Num = Num + 1
	--end
	local health = self.healthCache:data()

	local function findHealth(k, sign)
		if sign == '+' and health[k + 1] ~= nil then
			--health[k + 1] = nil
			return findHealth(k+1, sign) + 1
		elseif sign == '-' and health[k - 1] ~= nil then
			--health[k - 1] = nil
			return findHealth(k-1, sign) + 1
		else
			return 0
		end
	end

	for k, v in pairs(health) do
		local len = findHealth(k, '+') + findHealth(k, '-') + 1
		if len >= Num then
			Num = len
		end
	end

	-- 丢失过多ack 重连
	if Num >= TCLIENT_HEARTBEAT_EXPIRE_COUNT then
		print('checkHealth|reconnect|'..Num)
		self:reconnect()
	end
end

return TClient
