----------------------------------------------------------

----------------------------------------------------------

--[[
1       serverName
2       funcName
3       args
4       funcId
5       retCode
]]--
local TB_DEFINE_SERIAL_DATA_TYPE = {
	EU_SERVERNAME = 1,						-- 服务名
	EU_FUNCNAME   = 2,						-- 函数名
	EU_ARGS       = 3,						-- 参数
	EU_FUNCID     = 4,						-- 函数id
	EU_RETCODE    = 5,						-- 返回值
}

NETWORK_RETCODE_SUCCESS = 0
NETWORK_NO_NEED_TIPS = 10000
NETWORK_RETCODE_NEED_UNPACK = 15000         -- 大于15000的错误码会解包
function def_GetSerialDataType()
	return TB_DEFINE_SERIAL_DATA_TYPE;
end
