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

local mission = {
[1] = {
	[8001] = {
		["Id"] = 8001,
		["Name"] = "锁妖塔",
		["ElementType"] = 8,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 800,
		["Desc2"] = 801,
		["Pic1"] = 800,
		["Pic2"] = 800,
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Floors"] = 5,
		["Reward"] = 10017,
		["Monster"] = {1,1,1,1,1,1},
		["Effect2"] = {{60049,100,0,49,1}},
	},
	[8002] = {
		["Id"] = 8002,
		["Name"] = "锁妖塔",
		["ElementType"] = 8,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 800,
		["Desc2"] = 801,
		["Pic1"] = 801,
		["Pic2"] = 801,
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Floors"] = 5,
		["Reward"] = 10017,
		["Monster"] = {1010,1011,1012,1013,1014},
		["Effect2"] = {{60049,100,0,49,1}},
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

local tbConfig = gf_CopyTable(mission[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
