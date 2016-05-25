-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["Sheet1"] = 1,
};

sheetindex = {
[1] = "Sheet1",
};

local itembox = {
[1] = {
	[10001] = {
		["boxid"] = 10001,
		["itemid"] = {110101,110103,110105},
	},
	[10002] = {
		["boxid"] = 10002,
		["itemid"] = {16001,16004,15101},
	},
	[10003] = {
		["boxid"] = 10003,
		["itemid"] = {16001,16002,16003,16004,16005,16006,15102},
	},
	[10004] = {
		["boxid"] = 10004,
		["itemid"] = {16001,16002},
	},
	[10005] = {
		["boxid"] = 10005,
		["itemid"] = {110102,110104,110106},
	},
	[10006] = {
		["boxid"] = 10006,
		["itemid"] = {},
	},
	[15101] = {
		["boxid"] = 15101,
		["itemid"] = {15101},
	},
	[15102] = {
		["boxid"] = 15102,
		["itemid"] = {15102},
	},
	[16001] = {
		["boxid"] = 16001,
		["itemid"] = {16001},
	},
	[16002] = {
		["boxid"] = 16002,
		["itemid"] = {16002},
	},
	[16003] = {
		["boxid"] = 16003,
		["itemid"] = {16003},
	},
	[16004] = {
		["boxid"] = 16004,
		["itemid"] = {16004},
	},
	[16005] = {
		["boxid"] = 16005,
		["itemid"] = {16005},
	},
	[16006] = {
		["boxid"] = 16006,
		["itemid"] = {16006},
	},
	[110101] = {
		["boxid"] = 110101,
		["itemid"] = {110101},
	},
	[110102] = {
		["boxid"] = 110102,
		["itemid"] = {110102},
	},
	[110103] = {
		["boxid"] = 110103,
		["itemid"] = {110103},
	},
	[110104] = {
		["boxid"] = 110104,
		["itemid"] = {110104},
	},
	[110105] = {
		["boxid"] = 110105,
		["itemid"] = {110105},
	},
	[110106] = {
		["boxid"] = 110106,
		["itemid"] = {110106},
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

local tbConfig = gf_CopyTable(itembox[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
