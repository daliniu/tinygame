require("script/core/network/serialize")
require("script/core/network/define")
require("script/ui/tipsview/tipsviewlogic")
local proto = require("script/core/network/serial_proto")
local Exbuffer = require("script/core/network/parse")
local DataCache = require("script/core/network/data_cache")
local scheduler = require("script/core/network/scheduler")
local SerialType = def_GetSerialDataType()
local CALLBACK_MAX_MSG_CACHE           = 20           -- 客户端缓存消息最大值
local TCLIENT_TIMEOUT                  = 2             -- 客户端发包超时时间
--全局对象
local cbCache = DataCache.new(CALLBACK_MAX_MSG_CACHE)
local regCbTable = {}

local Communicator ={}
--[[
1       serverName
2       funcName
3       args
4       funcId
5       retCode
]]--

function table_is_empty(t)
	return _G.next(t) == nil
end

function initCommunicator(host, port, callback)
	g_Core:initNetwork(host, port, callback)
	if proto.interface == nil then
		print("proto interface is nil")
		return nil
	end

	for serverName, server in pairs(proto.interface) do
		Communicator[serverName] = {}
		for funcName, funcInterface in pairs(server) do
			if serverName ~= "client" then
				-- 远程调用
				local callRemoteFunc = function(inArgs, inCallback, inIsUi)
						local serialData, cb, isUi
						if not inCallback then
							serialData = {}
							cb = inArgs
							isUi = false
						else
							if type(inArgs) ~= "function" then
						 		serialData = serialize(funcInterface.inArgs, inArgs)
						 		cb = inCallback
						 		isUi = inIsUi
							else
						 		serialData = {}
						 		cb = inArgs
						 		isUi = inCallback
							end
						end
						local data = {
							[SerialType.EU_SERVERNAME] = server.seq,
							[SerialType.EU_FUNCNAME] = funcInterface.seq,
							[SerialType.EU_ARGS] = serialData,
							[SerialType.EU_FUNCID] = cbCache:push({
								callback = cb,
								outArgs  = funcInterface.outArgs,
								time     = os.time()}),
							[SerialType.EU_RETCODE] = 0
						}
						print("serverName:", server.seq, "funcName:", funcInterface.seq, "Args:", funcInterface.inArgs, "funcId", data[SerialType.EU_FUNCID])
						if not isUi then
							g_Core:sendEx(data, isUi)
						else
							g_Core:sendEx(data, false)
						end
				end
				Communicator[serverName][funcName] = callRemoteFunc
			else
				-- 只有回调
				local regCallback = function(callback)
					regCbTable[funcInterface.seq] = {}
					regCbTable[funcInterface.seq].callback = callback
					regCbTable[funcInterface.seq].outArgs = funcInterface.outArgs
				end
				Communicator[serverName][funcName] = regCallback
			end
		end
	end

	local _checkTimeout = function()
		--print("checkTimeout.........")
		tst_print_lua_table(cbCache:data())
		for k, v in pairs(cbCache:data()) do
			local expireTime = os.time() -  v.time
			if expireTime > TCLIENT_TIMEOUT then
				print("Timeout.........Timeout", expireTime)
				cbCache:erase(k)
				-- 目前简单的断线重连
				g_Core:closeNetwork()
				NetworkLogic:getInstance():disconnectNetwork()
				return
			end
		end
	end
	if Communicator.checkTimeout then
		scheduler.unscheduleGlobal(Communicator.checkTimeout)
	end

	Communicator.checkTimeout = scheduler.scheduleGlobal(_checkTimeout, TCLIENT_TIMEOUT)

	return Communicator
end

function recvCallback(data)
	-- 回调函数检查
	if regCbTable[data[SerialType.EU_FUNCNAME]] then
		local unserialData = unserialize(regCbTable[data[SerialType.EU_FUNCNAME]].outArgs, data[SerialType.EU_ARGS])
		print("push...")
		tst_print_lua_table(unserialData)
		regCbTable[data[SerialType.EU_FUNCNAME]].callback(unserialData)
		return
	end
	local cbData = cbCache:get(data[SerialType.EU_FUNCID])
	cbCache:erase(data[SerialType.EU_FUNCID])
	if data[SerialType.EU_RETCODE] ~= 0 then
		print("status = ", data[SerialType.EU_RETCODE])
		-- 此返回码表示不需要提示信息
		if data[SerialType.EU_RETCODE] == NETWORK_NO_NEED_TIPS then
			return nil
		end
		if data[SerialType.EU_RETCODE] < NETWORK_NO_NEED_TIPS then
			-- 弹出提示框
			TipsViewLogic:getInstance():addMessageTips(data[SerialType.EU_RETCODE])
			return nil
		elseif data[SerialType.EU_RETCODE] > NETWORK_NO_NEED_TIPS
			and data[SerialType.EU_RETCODE] < NETWORK_RETCODE_NEED_UNPACK then
			-- 逻辑错误码抛给上层调用
			local unserialData = {}
			unserialData.retCode = data[SerialType.EU_RETCODE]
			if cbData.callback then
				cbData.callback(unserialData)
			else
				print("lost callback function fail")
			end
			return nil
		else
			-- 逻辑错误码抛给上层调用
			-- 但有返回数据需要抛给上层
			doCallbackFunc(data, cbData)
		end
	end
	doCallbackFunc(data, cbData)
end

function doCallbackFunc(data, cbData)
	if cbData and cbData.callback then
		local unserialData = unserialize(cbData.outArgs, data[SerialType.EU_ARGS])
		print("recv...", data[SerialType.EU_FUNCID])
		unserialData.retCode = data[SerialType.EU_RETCODE]
		tst_print_lua_table(unserialData)
		cbData.callback(unserialData)
	else
		TipsViewLogic:getInstance():addMessageTips(40001)
		print("lost callback function fail")
	end
end
