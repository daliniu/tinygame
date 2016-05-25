local SerialProto = require("script/core/network/serial_proto")

function unserialize(name, object)
	local unserialObject = {};

	assert(SerialProto[name] ~= nil, "unserialize "..name.." is null fail")

	local data = SerialProto[name]
	for k, v in ipairs(data) do
		if data[k].type == "string" then
			unserialObject[data[k].value] = object[k]
		elseif data[k].type == "map" then
			if data[k].type1 ~= "map2" then
				if data[k].type2 == "string" then
					unserialObject[data[k].value] = object[k]
				else
					unserialObject[data[k].value] = {}
					assert(object[k] ~= nil, "unserialize "..data[k].type2.." is null fail")
					for k1, v1 in pairs(object[k]) do
						unserialObject[data[k].value][k1] = unserialize(data[k].type2, v1)
					end
				end
			else
				if data[k].type2 == "string" then
					unserialObject = object
				else
					unserialObject = {}
					assert(object ~= nil, "unserialize "..data[k].type2.." is null fail")
					for k1, v1 in pairs(object) do
						unserialObject[k1] = unserialize(data[k].type2, v1)
					end
				end
			end
		elseif data[k].type == "vector" then
			if data[k].type1 ~= "vector2" then
				if data[k].type2 == "string" then
					unserialObject[data[k].value] = object[k]
				else
					unserialObject[data[k].value] = {}
					assert(object[k] ~= nil, "unserialize "..data[k].type2.." is null fail")
					for k1, v1 in ipairs(object[k]) do
						unserialObject[data[k].value][k1] = unserialize(data[k].type2, v1)
					end
				end
			else
				if data[k].type2 == "string" then
					unserialObject = object
				else
					unserialObject = {}
					assert(object ~= nil, "unserialize "..data[k].type2.." is null fail")
					for k1, v1 in ipairs(object) do
						unserialObject[k1] = unserialize(data[k].type2, v1)
					end
				end
			end
		elseif data[k].type == "struct" then
			unserialObject[data[k].value] = unserialize(data[k].type1, object[k])
		else
			assert(false, "unserialize "..data[k].type.." "..data[k].type.." is not defined fail")
			return nil
		end
	end
	return unserialObject
end

function serialize(name, object)
	local serialObject = {};

	assert(SerialProto[name] ~= nil, "serialize "..name.." is null fail")

	local data = SerialProto[name]
	for k, v in ipairs(data) do
		if data[k].type == "string" then
			assert(object[data[k].value] ~= nil, "serialize "..name.." "..data[k].value.." is null fail")
			serialObject[k] = object[data[k].value]
		elseif data[k].type == "map" then
			-- 循环map
			if data[k].type1 ~= "map2" then
				assert(object[data[k].value] ~= nil, "serialize "..name.." "..data[k].value.." is null fail")
				if data[k].type2 == "string" then
					serialObject[k] = object[data[k].value]
				else
					serialObject[k] = {}
					if object[data[k].value] then
						for k1, v1 in pairs(object[data[k].value]) do
							serialObject[k][k1] = serialize(data[k].type2, v1)
						end
					end
				end
			else
				if data[k].type2 == "string" then
					serialObject = object
				else
					serialObject = {}
					for k1, v1 in pairs(object) do
						serialObject[k1] = serialize(data[k].type2, v1)
					end
				end
			end
		elseif data[k].type == "vector" then
			if data[k].type1 ~= "vector2" then
				assert(object[data[k].value] ~= nil, "serialize "..name.." "..data[k].value.." is null fail")
				if data[k].type2 == "string" then
					serialObject[k] = object[data[k].value]
				else
					serialObject[k] = {}
					if object[data[k].value] then
						for k1, v1 in ipairs(object[data[k].value]) do
							serialObject[k][k1] = serialize(data[k].type2, v1)
						end
					end
				end
			else
				if data[k].type2 == "string" then
					serialObject = object
				else
					serialObject = {}
					for k1, v1 in ipairs(object) do
						serialObject[k1] = serialize(data[k].type2, v1)
					end
				end
			end
		elseif data[k].type == "struct" then
			serialObject[k] = serialize(data[k].type1, object[data[k].value])
		else
			assert(false, "serialize "..name.." "..data[k].type.." is not defined fail")
			return nil
		end
	end
	return serialObject
end

--[[

local heroInfo = {
	["curExp"] = 100,
	["level"] = 100,
	["quality"] = 100,
	["skillList"] = {
		"12313",
		"asfwqf",
		"sss222"
	},
	["sT"] = {
		{
			["level"] = 1001,
		},
		{
			["level"] = 1002,
		},
		{
			["level"] = 1003,
		},
	},
	["sM"] = {
		["100001"] = "aaa",
		["100002"] = "bbb",
		["100005"] = "ccc",
	},
	["skillSlotList"] = {
		["100001"] = {
			["level"] = 2001,
		},
		["100002"] = {
			["level"] = "234234",
		},
		["100005"] = {
			["level"] = 2003,
		},
	},
}

require "serialize"

local un = serialize("HeroInfoT", heroInfo)
tst_print_lua_table(un)
print("....")
tst_print_lua_table(unserialize("HeroInfoT", un))

print("....", cjson.encode(un))

]]--
