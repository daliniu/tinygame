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

local watchtower = {
[1] = {
	[16001] = {
		["Id"] = 16001,
		["Name"] = "瞭望塔",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1600,
		["Desc2"] = 1601,
		["Pic1"] = 1600,
		["Pic2"] = 1600,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {5,5},
		["Effect2"] = {{60047,100,0,190,1}},
	},
	[16002] = {
		["Id"] = 16002,
		["Name"] = "瞭望塔",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1600,
		["Desc2"] = 1601,
		["Pic1"] = 1601,
		["Pic2"] = 1601,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {6,6},
		["Effect2"] = {{60047,100,0,190,1}},
	},
	[16003] = {
		["Id"] = 16003,
		["Name"] = "2瞭望塔",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1600,
		["Desc2"] = 1601,
		["Pic1"] = 1602,
		["Pic2"] = 1602,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {6,6},
		["Effect2"] = {{60047,100,0,190,1}},
	},
	[16004] = {
		["Id"] = 16004,
		["Name"] = "3瞭望塔",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1600,
		["Desc2"] = 1601,
		["Pic1"] = 1602,
		["Pic2"] = 1602,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {6,6},
		["Effect2"] = {{60047,100,0,190,1}},
	},
	[16005] = {
		["Id"] = 16005,
		["Name"] = "4瞭望塔",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1600,
		["Desc2"] = 1601,
		["Pic1"] = 1601,
		["Pic2"] = 1601,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {6,6},
		["Effect2"] = {{60047,100,0,190,1}},
	},
	[16006] = {
		["Id"] = 16006,
		["Name"] = "史莱姆",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1602,
		["Desc2"] = 1602,
		["Pic1"] = 3649,
		["Pic2"] = 3649,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {1,1},
		["Effect2"] = {{60064,100,0,92,1}},
	},
	[16007] = {
		["Id"] = 16007,
		["Name"] = "四大美人",
		["ElementType"] = 16,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1603,
		["Desc2"] = 1603,
		["Pic1"] = 3637,
		["Pic2"] = 3637,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Anchor"] = 0,
		["Direction"] = 0,
		["Square"] = {1,1},
		["Effect2"] = {{60064,100,0,92,1}},
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

local tbConfig = gf_CopyTable(watchtower[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
