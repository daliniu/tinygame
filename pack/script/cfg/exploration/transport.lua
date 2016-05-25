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

local transport = {
[1] = {
	[13001] = {
		["Id"] = 13001,
		["Name"] = "交通站",
		["ElementType"] = 13,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1300,
		["Pic1"] = 1300,
		["Pic2"] = 1300,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["TranACount"] = {{{1},{1,1}},{{2},{1,1}},{{3},{1,1}}},
	},
	[13002] = {
		["Id"] = 13002,
		["Name"] = "交通站",
		["ElementType"] = 13,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1300,
		["Pic1"] = 1301,
		["Pic2"] = 1301,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["TranACount"] = {{{1},{1,1}},{{2},{1,1}},{{3},{1,1}}},
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

local tbConfig = gf_CopyTable(transport[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
