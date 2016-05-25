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

local exit = {
[1] = {
	[10001] = {
		["Id"] = 10001,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["Pic1"] = 1700,
		["Pic2"] = 600,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 1006,
		["Map"] = 1,
		["Reward"] = 10002,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10002] = {
		["Id"] = 10002,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["Pic1"] = 1001,
		["Pic2"] = 600,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 1006,
		["Map"] = 1,
		["Reward"] = 10003,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10003] = {
		["Id"] = 10003,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["Pic1"] = 1701,
		["Pic2"] = 1701,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 10101,
		["Map"] = 2,
		["Reward"] = 10140,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10004] = {
		["Id"] = 10004,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1002,
		["Desc2"] = 1003,
		["Pic1"] = 1702,
		["Pic2"] = 1702,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 10205,
		["Map"] = 3,
		["Reward"] = 10145,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10005] = {
		["Id"] = 10005,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1004,
		["Desc2"] = 1005,
		["Pic1"] = 1702,
		["Pic2"] = 1702,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 10306,
		["Map"] = 4,
		["Reward"] = 10151,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10006] = {
		["Id"] = 10006,
		["Name"] = "出口",
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1006,
		["Desc2"] = 1007,
		["Pic1"] = 1701,
		["Pic2"] = 1701,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Monster"] = 10409,
		["Map"] = 1,
		["Reward"] = 10160,
		["Effect2"] = {{60028,70,0,70,2}},
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

local tbConfig = gf_CopyTable(exit[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
