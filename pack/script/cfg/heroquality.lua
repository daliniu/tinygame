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

local heroquality = {
[1] = {
	[1] = {
		["quality"] = 1,
		["lv"] = 5,
		["ap"] = 20,
		["def"] = 20,
		["hp"] = 20,
	},
	[2] = {
		["quality"] = 2,
		["lv"] = 10,
		["ap"] = 20,
		["def"] = 20,
		["hp"] = 20,
	},
	[3] = {
		["quality"] = 3,
		["lv"] = 20,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[4] = {
		["quality"] = 4,
		["lv"] = 20,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[5] = {
		["quality"] = 5,
		["lv"] = 20,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[6] = {
		["quality"] = 6,
		["lv"] = 20,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[7] = {
		["quality"] = 7,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[8] = {
		["quality"] = 8,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[9] = {
		["quality"] = 9,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[10] = {
		["quality"] = 10,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[11] = {
		["quality"] = 11,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[12] = {
		["quality"] = 12,
		["lv"] = 30,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
	},
	[13] = {
		["quality"] = 13,
		["lv"] = 40,
		["ap"] = 50,
		["def"] = 50,
		["hp"] = 50,
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

local tbConfig = gf_CopyTable(heroquality[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
