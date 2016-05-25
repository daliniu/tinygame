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

local monsterchoo = {
[1] = {
	[7001] = {
		["Id"] = 7001,
		["Name"] = "缺银子的小偷",
		["ElementType"] = 7,
		["Genre"] = 3,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 0,
		["Desc1"] = 700,
		["Pic1"] = 700,
		["Pic2"] = 700,
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Monster"] = 1,
		["StepCost"] = 5,
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

local tbConfig = gf_CopyTable(monsterchoo[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
