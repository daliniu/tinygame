----------------------------------------------------------
-- file:	testfunctions.lua
-- Author:	page
-- Time:	2015/01/25 : Happy Birthday to myself ^_^
-- Desc:	一些测试用的lib函数
----------------------------------------------------------
local tst_print_lua_table_tcollision = {}
function tst_print_lua_table (lua_table, indent, bName)
	local getTableName = function(tb)
			local tbName = "tbName"
			for k,v in pairs(_G) do
				if v == tb then
					tbName = k
					break;
				end
			end
			return tbName;
		end
	--check
	if type(lua_table) ~= "table" then
		print("It's not a table:", lua_table)
		return;
	end
	
    indent = indent or 1
	if indent == 1 and bName then
		print(getTableName(lua_table) .. " = {")
	end
	--if not tst_print_lua_table_tcollision[lua_table] then
		--tst_print_lua_table_tcollision[lua_table] = true;
		for k, v in pairs(lua_table) do
			if type(k) == "string" then
				k = string.format("%q", k)
			end
			local szSuffix = ""
			if type(v) == "table" then
				szSuffix = "{"
			end
			local szPrefix = string.rep("    ", indent)
			formatting = szPrefix.."["..k.."]".." = "..szSuffix
			if type(v) == "table" then
				print(formatting)
				--if not tst_print_lua_table_tcollision[v] then
					tst_print_lua_table(v, indent + 1)
				--else
				--	tst_print_lua_table_tcollision[v] = true;
				--	print(szPrefix, v)
				--end
				print(szPrefix.."},")
			else
				local szValue = ""
				if type(v) == "string" then
					szValue = string.format("%q", v)
				else
					szValue = tostring(v)
				end
				print(formatting..szValue..",")
			end
		end
	--else
	--	print(string.rep("    ", indent), lua_table)
	--end
	if indent == 1 and bName then
		print("}")
	end
end

function tst_print_table(lua_table, indent)
	local fn_PrintTable = tst_print_lua_table;
	local tbCollision = {}
	
end

function tst_open_log_file()
if not _SERVER then
	if not g_tstLogFile then
		local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		if cc.PLATFORM_OS_WINDOWS == targetPlatform then
			local szCmd = "if not exist log mkdir log"
			-- os.execute导致打印信息卡住
			-- print(os.execute(szCmd));
			print(io.popen(szCmd));
			local szFileName = "log/" .. tf_FormatFileNameWithTime();
			g_tstLogFile = io.open(szFileName, 'a+');
		end
	end
end
end

function tst_close_log_file()
if not _SERVER then
	if g_tstLogFile then
		g_tstLogFile:close();
	end
end
end

function cclog(...)
	print(string.format(...))
if not _SERVER then
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if cc.PLATFORM_OS_WINDOWS == targetPlatform then
		local szLog = os.date("[%Y %m %d %H:%M:%S] ", os.time()) .. string.format(...) .. "\n";
		if g_tstLogFile then
			g_tstLogFile:write(szLog);
		end
	end
end
end

function tst_print_textures_cache()
	print("--------------------------------------------")
	local szLog = cc.Director:getInstance():getTextureCache():getCachedTextureInfo();
	print(#szLog);
	--Run-Time Check Failure #2 - Stack around the variable 'buf' was corrupted.

	function long_print(szLog)
		local nStart, nEnd = 1;
		local nMax = 15*1024;
		local nLong = #szLog;
		local nCount = 1;
		while true and nCount <=10 do
			print("*********************************", nCount)
			local nEnd = nStart+nMax-1
			if nEnd >= nLong then
				nEnd = -1;
			end
			local szTemp = string.sub(szLog, nStart, nEnd);
			print(nStart, nEnd, szTemp)
			nStart = nMax + 1;
			if nEnd == -1 then
				break;
			end
			nStart = nEnd;
			nCount = nCount + 1;
		end
	end
	long_print(szLog)
	print("--------------------------------------------")
end

function tst_PrintTime(nTick)
	print(nTick, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", os.clock())
end

function tst_reload_file()
	local tbReloadFiles = {
		-- "script/ui/mainview/MainView",
		
		"script/ui/herolistview/equipview/equiplogic",
		"script/ui/mainview/MainView",
		-- 竞技场
		"script/core/arena/factory",
		"script/ui/arenaview/arenalayer",
		"script/ui/arenaview/arenalogic",
		"script/ui/arenaview/watch_sublayer",
		"script/ui/arenaview/arena_fightview/arena_fightlayer",
		"script/ui/arenaview/normalview/normallogic",
		"script/ui/arenaview/normalview/normallayer",
		-- 升星和升品
		"script/ui/herolistview/hero_reinforce_sublayer",
		"script/core/npc/herofactory",
		"script/ui/herolistview/herolistlayer",
		"script/ui/herolistview/herolistlogic",
	}
	for _, szFileName in pairs(tbReloadFiles) do
		print(package.loaded[szFileName])
		package.loaded[szFileName] = nil
		require(szFileName)
	end
end

function tst_write_file(szFileName, szContent)
	local file = io.open(szFileName, 'a+');
	file:write(szContent);
	file:close();
end

--sqlite
--[[
local sqlite3 =require("sqlite3")
print("sqlite3  version"..sqlite3.version())
local db = sqlite3.open("xxx.db")
assert( db:exec "CREATE TABLE test (col1, col2)" )
assert( db:exec "INSERT INTO test VALUES (1, 2)" )
assert( db:exec "INSERT INTO test VALUES (2, 4)" )
assert( db:exec "INSERT INTO test VALUES (3, 6)" )
assert( db:exec "INSERT INTO test VALUES (4, 8)" )
assert( db:exec "INSERT INTO test VALUES (5, 10)" )
]]