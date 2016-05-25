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

local Robot = {
[1] = {
	[1] = {
		["RobotID"] = 1,
		["Hero1"] = 1,
		["Hero2"] = 2,
		["Hero3"] = 3,
		["Equip1"] = {1,2,3,4,5,6},
		["Equip2"] = {1,2,3,4,5,6},
		["Equip3"] = {1,2,3,4,5,6},
	},
	[2] = {
		["RobotID"] = 2,
		["Hero1"] = 4,
		["Hero2"] = 5,
		["Hero3"] = 6,
		["Equip1"] = {7,8,9,10,11,12},
		["Equip2"] = {7,8,9,10,11,12},
		["Equip3"] = {7,8,9,10,11,12},
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

local tbConfig = gf_CopyTable(Robot[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
