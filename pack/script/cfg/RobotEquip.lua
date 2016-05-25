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

local RobotEquip = {
[1] = {
	[1] = {
		["ID"] = 1,
		["EquipId"] = 10102,
		["Star"] = 1,
	},
	[2] = {
		["ID"] = 2,
		["EquipId"] = 10107,
		["Star"] = 1,
	},
	[3] = {
		["ID"] = 3,
		["EquipId"] = 10111,
		["Star"] = 1,
	},
	[4] = {
		["ID"] = 4,
		["EquipId"] = 10117,
		["Star"] = 1,
	},
	[5] = {
		["ID"] = 5,
		["EquipId"] = 10121,
		["Star"] = 1,
	},
	[6] = {
		["ID"] = 6,
		["EquipId"] = 10127,
		["Star"] = 1,
	},
	[7] = {
		["ID"] = 7,
		["EquipId"] = 10132,
		["Star"] = 2,
	},
	[8] = {
		["ID"] = 8,
		["EquipId"] = 10136,
		["Star"] = 2,
	},
	[9] = {
		["ID"] = 9,
		["EquipId"] = 10141,
		["Star"] = 2,
	},
	[10] = {
		["ID"] = 10,
		["EquipId"] = 10146,
		["Star"] = 2,
	},
	[11] = {
		["ID"] = 11,
		["EquipId"] = 10151,
		["Star"] = 2,
	},
	[12] = {
		["ID"] = 12,
		["EquipId"] = 10156,
		["Star"] = 2,
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

local tbConfig = gf_CopyTable(RobotEquip[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
