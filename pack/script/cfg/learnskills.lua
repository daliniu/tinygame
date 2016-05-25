-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["10001"] = 1,
};

sheetindex = {
[1] = "10001",
};

local learnskills = {
[1] = {
	[30001] = {
		["ID"] = 30001,
		["character_level"] = 1,
		["cost"] = 0,
		["next_skill"] = 0,
	},
	[30002] = {
		["ID"] = 30002,
		["character_level"] = 1,
		["cost"] = 0,
		["next_skill"] = 0,
	},
	[30003] = {
		["ID"] = 30003,
		["character_level"] = 1,
		["cost"] = 0,
		["next_skill"] = 0,
	},
	[30004] = {
		["ID"] = 30004,
		["character_level"] = 1,
		["cost"] = 0,
		["next_skill"] = 0,
	},
	[30005] = {
		["ID"] = 30005,
		["character_level"] = 1,
		["cost"] = 0,
		["next_skill"] = 0,
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

local tbConfig = gf_CopyTable(learnskills[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
