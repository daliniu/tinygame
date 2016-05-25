--[[
使用lpack实现的数据缓冲
]]

require("script/lib/basefunctions")
require("script/ui/tipsview/tipsviewlogic")

require("lpack.core")
local cjson = require("cjson.core")

local Exbuffer = {}

function Exbuffer:pack(data)
	return cjson.encode(data)
end

function Exbuffer:unpack(tbBytes)
	local buf = {}
	for i = 1, #tbBytes do
		buf[#buf + 1] = string.char(tbBytes[i])
	end
	local buffer = table.concat(buf)
	print('unpack = ', buffer)
	local data = cjson.decode(buffer)
	if type(data) == "table" then
		return data
	end
	return nil
end

return Exbuffer

