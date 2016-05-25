-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["character"] = 1,
};

sheetindex = {
[1] = "character",
};

local skilllevelup = {
[1] = {
	[1] = {
		["groove"] = 1,
		["cost"] = {500,100},
	},
	[2] = {
		["groove"] = 2,
		["cost"] = {600,200},
	},
	[3] = {
		["groove"] = 3,
		["cost"] = {700,300},
	},
	[4] = {
		["groove"] = 4,
		["cost"] = {800,400},
	},
	[5] = {
		["groove"] = 5,
		["cost"] = {900,500},
	},
	[6] = {
		["groove"] = 6,
		["cost"] = {1000,600},
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

local tbConfig = gf_CopyTable(skilllevelup[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
