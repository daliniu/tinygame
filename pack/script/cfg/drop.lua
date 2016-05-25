-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["drop"] = 1,
};

sheetindex = {
[1] = "drop",
};

local drop = {
[1] = {
	[3001] = {
		["dropId"] = 3001,
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{1,5000},{2,5000}},
		["tepy1"] = {10101,1,1000,0},
		["tepy2"] = {"gold",10000,4000,0},
		["tepy3"] = {10102,1,2500,0},
		["tepy4"] = {10103,1,2500,0},
		["dropNum"] = 2,
	},
	[3002] = {
		["dropId"] = 3002,
		["foreverDrop"] = {{19301,5},{19302,5},{19303,5},{19304,5},{19305,5},{19306,5},{19307,5},{19308,5}},
		["number"] = {{1,10000}},
		["tepy1"] = {15001,99,5000,0},
		["dropNum"] = 9,
	},
	[3003] = {
		["dropId"] = 3003,
		["number"] = {{1,10000}},
		["tepy1"] = {16001,1,5000,0},
		["tepy2"] = {16007,1,1000,0},
		["tepy3"] = {16013,1,10,0},
		["dropNum"] = 1,
	},
	[3004] = {
		["dropId"] = 3004,
		["number"] = {{1,10000}},
		["tepy1"] = {16002,1,5000,0},
		["tepy2"] = {16003,1,5000,0},
		["tepy3"] = {16004,1,5000,0},
		["tepy4"] = {16008,1,1000,0},
		["tepy5"] = {16009,1,1000,0},
		["tepy6"] = {16010,1,1000,0},
		["tepy7"] = {16014,1,10,0},
		["tepy8"] = {16015,1,10,0},
		["tepy9"] = {16016,1,10,0},
		["dropNum"] = 1,
	},
	[3005] = {
		["dropId"] = 3005,
		["number"] = {{1,10000}},
		["tepy1"] = {16005,1,5000,0},
		["tepy2"] = {16006,1,5000,0},
		["tepy3"] = {16011,1,1000,0},
		["tepy4"] = {16012,1,1000,0},
		["tepy5"] = {16017,1,10,0},
		["tepy6"] = {16018,1,10,0},
		["dropNum"] = 1,
	},
	[3006] = {
		["dropId"] = 3006,
		["foreverDrop"] = {{10103,1},{10109,2},{10155,5}},
		["number"] = {{1,10000}},
		["tepy1"] = {16019,1,5000,0},
		["tepy2"] = {16025,1,1000,0},
		["tepy3"] = {16031,1,10,0},
		["dropNum"] = 9,
	},
	[3007] = {
		["dropId"] = 3007,
		["number"] = {{1,10000}},
		["tepy1"] = {16020,1,5000,0},
		["tepy2"] = {16021,1,5000,0},
		["tepy3"] = {16022,1,5000,0},
		["tepy4"] = {16026,1,1000,0},
		["tepy5"] = {16027,1,1000,0},
		["tepy6"] = {16028,1,1000,0},
		["tepy7"] = {16032,1,10,0},
		["tepy8"] = {16033,1,10,0},
		["tepy9"] = {16034,1,10,0},
		["dropNum"] = 1,
	},
	[3008] = {
		["dropId"] = 3008,
		["number"] = {{1,10000}},
		["tepy1"] = {16023,1,5000,0},
		["tepy2"] = {16024,1,5000,0},
		["tepy3"] = {16029,1,1000,0},
		["tepy4"] = {16030,1,1000,0},
		["tepy5"] = {16035,1,10,0},
		["tepy6"] = {16036,1,10,0},
		["dropNum"] = 1,
	},
	[3009] = {
		["dropId"] = 3009,
		["foreverDrop"] = {{15101,20},{15201,99},{15202,99},{15203,99},{15204,1},{15205,1},{15206,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 7,
	},
	[3010] = {
		["dropId"] = 3010,
		["foreverDrop"] = {{15102,20}},
		["number"] = {{1,10000}},
		["tepy1"] = {15001,1,5000,0},
		["tepy2"] = {15001,2,2500,0},
		["tepy3"] = {15001,3,1000,0},
		["dropNum"] = 1,
	},
	[3011] = {
		["dropId"] = 3011,
		["foreverDrop"] = {{10001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[3012] = {
		["dropId"] = 3012,
		["foreverDrop"] = {{10151,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[3013] = {
		["dropId"] = 3013,
		["foreverDrop"] = {{10151,1},{17902,1},{10001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 3,
	},
	[3014] = {
		["dropId"] = 3014,
		["foreverDrop"] = {{19001,5},{19006,5},{19011,5},{19016,5},{19021,5},{19026,5},{19031,5},{19036,5},{19041,5},{19046,5},{19051,5},{19056,5},{19061,5},{19066,5},{19071,5}},
		["number"] = {{0,10000}},
	},
	[10001] = {
		["dropId"] = 10001,
		["foreverDrop"] = {{"gold",500}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10002] = {
		["dropId"] = 10002,
		["foreverDrop"] = {{110101,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10003] = {
		["dropId"] = 10003,
		["foreverDrop"] = {{110102,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10004] = {
		["dropId"] = 10004,
		["foreverDrop"] = {{19011,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10005] = {
		["dropId"] = 10005,
		["foreverDrop"] = {{19061,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10006] = {
		["dropId"] = 10006,
		["foreverDrop"] = {{19011,2}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10007] = {
		["dropId"] = 10007,
		["foreverDrop"] = {{16001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10008] = {
		["dropId"] = 10008,
		["foreverDrop"] = {{16004,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10009] = {
		["dropId"] = 10009,
		["foreverDrop"] = {{15102,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10010] = {
		["dropId"] = 10010,
		["foreverDrop"] = {{15101,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10011] = {
		["dropId"] = 10011,
		["foreverDrop"] = {{15101,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10012] = {
		["dropId"] = 10012,
		["foreverDrop"] = {{15102,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10013] = {
		["dropId"] = 10013,
		["foreverDrop"] = {{15101,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10014] = {
		["dropId"] = 10014,
		["foreverDrop"] = {{16001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
	},
	[10015] = {
		["dropId"] = 10015,
		["number"] = {{1,10000}},
		["tepy1"] = {16001,1,1666,0},
		["tepy2"] = {16002,1,1666,0},
		["tepy3"] = {16003,1,1666,0},
		["tepy4"] = {16004,1,1666,0},
		["tepy5"] = {16005,1,1666,0},
		["tepy6"] = {16006,1,1670,0},
		["dropNum"] = 1,
	},
	[10016] = {
		["dropId"] = 10016,
		["number"] = {{1,10000}},
		["tepy1"] = {110102,1,3333,0},
		["tepy2"] = {110104,1,3333,0},
		["tepy3"] = {110106,1,3334,0},
		["dropNum"] = 1,
	},
	[10017] = {
		["dropId"] = 10017,
		["number"] = {{1,10000}},
		["tepy1"] = {110101,1,3333,0},
		["tepy2"] = {110103,1,3333,0},
		["tepy3"] = {110105,1,3334,0},
		["dropNum"] = 1,
	},
	[10018] = {
		["dropId"] = 10018,
		["foreverDrop"] = {{110105,1}},
		["number"] = {{0,10000}},
	},
	[10019] = {
		["dropId"] = 10019,
		["foreverDrop"] = {{110106,1}},
		["number"] = {{0,10000}},
	},
	[10020] = {
		["dropId"] = 10020,
		["foreverDrop"] = {{110103,1}},
		["number"] = {{0,10000}},
	},
	[10021] = {
		["dropId"] = 10021,
		["foreverDrop"] = {{110104,1}},
		["number"] = {{0,10000}},
	},
	[10022] = {
		["dropId"] = 10022,
		["foreverDrop"] = {{110104,1},{110103,1}},
		["number"] = {{0,10000}},
	},
	[10023] = {
		["dropId"] = 10023,
		["foreverDrop"] = {{110105,1},{110106,1}},
		["number"] = {{0,10000}},
	},
	[10024] = {
		["dropId"] = 10024,
		["foreverDrop"] = {{110109,1}},
		["number"] = {{0,10000}},
	},
	[10025] = {
		["dropId"] = 10025,
		["foreverDrop"] = {{110107,1}},
		["number"] = {{0,10000}},
	},
	[10026] = {
		["dropId"] = 10026,
		["number"] = {{0,10000}},
	},
	[10027] = {
		["dropId"] = 10027,
		["number"] = {{0,10000}},
	},
	[10028] = {
		["dropId"] = 10028,
		["foreverDrop"] = {{19011,5}},
		["number"] = {{0,10000}},
	},
	[10029] = {
		["dropId"] = 10029,
		["foreverDrop"] = {{16005,1}},
		["number"] = {{0,10000}},
	},
	[10030] = {
		["dropId"] = 10030,
		["foreverDrop"] = {{"ap",280}},
	},
	[10031] = {
		["dropId"] = 10031,
		["foreverDrop"] = {{"ap",350}},
	},
	[10032] = {
		["dropId"] = 10032,
		["foreverDrop"] = {{"ap",550}},
	},
	[10033] = {
		["dropId"] = 10033,
		["foreverDrop"] = {{"ap",665}},
	},
	[10034] = {
		["dropId"] = 10034,
		["foreverDrop"] = {{"ap",1500}},
	},
	[10035] = {
		["dropId"] = 10035,
		["foreverDrop"] = {{"ap",1173}},
	},
	[10036] = {
		["dropId"] = 10036,
		["foreverDrop"] = {{"ap",730}},
	},
	[10037] = {
		["dropId"] = 10037,
		["foreverDrop"] = {{"ap",710}},
	},
},
};

-- functions for xlstable read
local __getcell = function (t, a,b,c) return t[a][b][c] end
function GetCell(sheetx, rowx, colx)
	rst, v = pcall(__getcell, xlstable, sheetx, rowx, colx)
	if rst then return v
	else return nil
	end
end

function GetCellBySheetName(sheet, rowx, colx)
	return GetCell(sheetname[sheet], rowx, colx)
end

__XLS_END = true

local tbConfig = gf_CopyTable(drop[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
