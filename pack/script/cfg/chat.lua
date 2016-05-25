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

local chat = {
[1] = {
	[1] = {
		["channel"] = 1,
		["level"] = 0,
		["time"] = 0,
	},
	[2] = {
		["channel"] = 2,
		["level"] = 0,
		["time"] = 0,
	},
	[3] = {
		["channel"] = 3,
		["level"] = 0,
		["time"] = 0,
	},
	[4] = {
		["channel"] = 4,
		["level"] = 0,
		["time"] = 30,
	},
	[5] = {
		["channel"] = 5,
		["level"] = 0,
		["time"] = 0,
	},
	[6] = {
		["channel"] = 6,
		["level"] = 0,
		["time"] = 0,
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

local tbConfig = gf_CopyTable(chat[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
