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

local chestchoo = {
[1] = {
	[2001] = {
		["Id"] = 2001,
		["Name"] = "抉择资源1",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 200,
		["Desc2"] = 201,
		["Pic1"] = 201,
		["Pic2"] = 201,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10011,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 0,
		["Reward2"] = 10012,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 0,
	},
	[2002] = {
		["Id"] = 2002,
		["Name"] = "抉择资源2",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 200,
		["Desc2"] = 201,
		["Pic1"] = 201,
		["Pic2"] = 201,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10014,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 0,
		["Reward2"] = 10013,
		["Probability2"] = 50,
		["Show2"] = 1,
		["Color2"] = 1,
	},
	[2003] = {
		["Id"] = 2003,
		["Name"] = "抉择资源3",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 200,
		["Desc2"] = 201,
		["Pic1"] = 201,
		["Pic2"] = 201,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10015,
		["Probability1"] = 60,
		["Show1"] = 0,
		["Color1"] = 0,
		["Reward2"] = 10016,
		["Probability2"] = 60,
		["Show2"] = 0,
		["Color2"] = 1,
	},
	[2005] = {
		["Id"] = 2005,
		["Name"] = "采魔晶的小光灵",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 202,
		["Desc2"] = 203,
		["Pic1"] = 3634,
		["Pic2"] = 3634,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10182,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10183,
		["Probability2"] = 60,
		["Show2"] = 1,
		["Color2"] = 1,
		["Effect2"] = {{60064,100,0,92,1}},
	},
	[2006] = {
		["Id"] = 2006,
		["Name"] = "聚宝盆",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 204,
		["Desc2"] = 205,
		["Pic1"] = 201,
		["Pic2"] = 201,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10184,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10185,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
		["Effect2"] = {{60062,100,12,32,1}},
	},
	[2007] = {
		["Id"] = 2007,
		["Name"] = "上锁的宝箱",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 206,
		["Desc2"] = 207,
		["Pic1"] = 201,
		["Pic2"] = 201,
		["Precondition"] = {{3,2}},
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10186,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10187,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
		["Effect2"] = {{60062,100,12,32,1}},
	},
	[2008] = {
		["Id"] = 2008,
		["Name"] = "小仙子",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 208,
		["Desc2"] = 209,
		["Pic1"] = 3634,
		["Pic2"] = 3634,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10188,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10189,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
		["Effect2"] = {{60064,100,0,92,1}},
	},
	[2009] = {
		["Id"] = 2009,
		["Name"] = "尼莫",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 210,
		["Desc2"] = 211,
		["Pic1"] = 3643,
		["Pic2"] = 3643,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10190,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10191,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
		["Effect2"] = {{60064,100,0,92,1}},
	},
	[2010] = {
		["Id"] = 2010,
		["Name"] = "测试抉择资源前置条件",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 206,
		["Desc2"] = 207,
		["Pic1"] = 105,
		["Pic2"] = 105,
		["Precondition"] = {{3,2}},
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10186,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10187,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
	},
	[2011] = {
		["Id"] = 2011,
		["Name"] = "测试抉择资源前置条件",
		["ElementType"] = 2,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 208,
		["Desc2"] = 209,
		["Pic1"] = 3624,
		["Pic2"] = 3624,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["Reward1"] = 10188,
		["Probability1"] = 100,
		["Show1"] = 0,
		["Color1"] = 1,
		["Reward2"] = 10189,
		["Probability2"] = 100,
		["Show2"] = 0,
		["Color2"] = 1,
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

local tbConfig = gf_CopyTable(chestchoo[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;