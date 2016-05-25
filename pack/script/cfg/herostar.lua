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

local herostar = {
[1] = {
	[1] = {
		["starLv"] = 1,
		["itemId"] = 15121,
		["itemNum"] = 3,
		["gold"] = 5000,
	},
	[2] = {
		["starLv"] = 2,
		["itemId"] = 15122,
		["itemNum"] = 10,
		["gold"] = 10000,
	},
	[3] = {
		["starLv"] = 3,
		["itemId"] = 15123,
		["itemNum"] = 20,
		["gold"] = 30000,
	},
	[4] = {
		["starLv"] = 4,
		["itemId"] = 15124,
		["itemNum"] = 40,
		["gold"] = 60000,
	},
	[5] = {
		["starLv"] = 5,
		["itemId"] = 15125,
		["itemNum"] = 80,
		["gold"] = 100000,
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

local tbConfig = gf_CopyTable(herostar[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
