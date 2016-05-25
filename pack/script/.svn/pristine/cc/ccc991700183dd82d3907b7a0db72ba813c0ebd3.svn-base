module('minifunc', package.seeall)

--[[
todo
]]

local seed = 31415926

function random(nBegin, nEnd)
	seed = seed or 1
	nEnd = nEnd or 1
	nBegin = nBegin or nEnd
	seed = (seed * 3877 + 29573) % 0xffffffff
	if nEnd < nBegin then
		nBegin, nEnd = nEnd, nBegin
	end
	return nBegin + seed % (nEnd - nBegin + 1)
end

function setSeed(nSeed)
	seed = nSeed
end

function getRandomIndex(tbPro, nMaxNum)
	nMaxNum = nMaxNum or 100

	local nRand = random(1, nMaxNum)
	local nSum = 0
	for i = 1, #tbPro do
		nSum = nSum + tbPro[i]
		if nRand <= nSum then
			return i
		end
	end
	return 0
end

function copyTable(tbOrg)
	local tbSaveExitTable = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object;
        elseif tbSaveExitTable[object] then
            return tbSaveExitTable[object];
        end
        local tbNewTable = {};
        tbSaveExitTable[object] = tbNewTable
        for index, value in pairs(object) do
            tbNewTable[_copy(index)] = _copy(value)
        end
        return setmetatable(tbNewTable, getmetatable(object))
    end
    return _copy(tbOrg)
end

function printTable(lua_table, indent)
	if type(lua_table) ~= "table" then
		print("It's not a table:", lua_table)
		return
	end
    indent = indent or 1

	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("    ", indent)
		if type(v) == "table" then
			print(szPrefix.."["..k.."]".." = "..szSuffix)
			printTable(v, indent + 1)
			print(szPrefix.."},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(szPrefix.."["..k.."]".." = "..szSuffix..szValue..",")
		end
	end
end
