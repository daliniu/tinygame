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

local lobstacle = {
[1] = {
	[32001] = {
		["Id"] = 32001,
		["Name"] = "初级可除草丛",
		["ElementType"] = 32,
		["Genre"] = 11,
		["Area"] = {1,1},
		["LandType"] = 1,
		["ToItem"] = 10001,
		["Pic"] = 3207,
		["Obstacle"] = 2,
		["PickupLived"] = 0,
		["Effect3"] = {60031,100,35,35,3},
		["Effect3AddType"] = 1,
	},
	[32002] = {
		["Id"] = 32002,
		["Name"] = "中级可除草丛",
		["ElementType"] = 32,
		["Genre"] = 11,
		["Area"] = {1,1},
		["LandType"] = 2,
		["ToItem"] = 10002,
		["Pic"] = 3208,
		["Obstacle"] = 2,
		["PickupLived"] = 0,
		["Effect3"] = {60031,100,35,35,3},
		["Effect3AddType"] = 1,
	},
	[32003] = {
		["Id"] = 32003,
		["Name"] = "高级可除草丛",
		["ElementType"] = 32,
		["Genre"] = 11,
		["Area"] = {1,1},
		["LandType"] = 3,
		["ToItem"] = 10003,
		["Pic"] = 3209,
		["Obstacle"] = 2,
		["PickupLived"] = 0,
		["Effect3"] = {60031,100,35,35,3},
		["Effect3AddType"] = 1,
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

local tbConfig = gf_CopyTable(lobstacle[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
