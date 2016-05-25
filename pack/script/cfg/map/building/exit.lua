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
		["Pic1"] = 1700,
		["Monster"] = 1006,
		["Map"] = 1,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10002] = {
		["Id"] = 10002,
		["Name"] = "出口",
		["Pic1"] = 1001,
		["Monster"] = 1006,
		["Map"] = 1,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10003] = {
		["Id"] = 10003,
		["Name"] = "出口",
		["Pic1"] = 1701,
		["Monster"] = 10101,
		["Map"] = 2,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1000,
		["Desc2"] = 1001,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10004] = {
		["Id"] = 10004,
		["Name"] = "出口",
		["Pic1"] = 1702,
		["Monster"] = 10205,
		["Map"] = 3,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1002,
		["Desc2"] = 1003,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10005] = {
		["Id"] = 10005,
		["Name"] = "出口",
		["Pic1"] = 1702,
		["Monster"] = 10306,
		["Map"] = 4,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1004,
		["Desc2"] = 1005,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[10006] = {
		["Id"] = 10006,
		["Name"] = "出口",
		["Pic1"] = 1701,
		["Monster"] = 10409,
		["Map"] = 1,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {2,2},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1006,
		["Desc2"] = 1007,
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,70,2}},
	},
	[100101] = {
		["Id"] = 100101,
		["Name"] = "出口",
		["Pic1"] = "b1_1011001",
		["Monster"] = 11000101,
		["Map"] = 2,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 110001011,
		["Desc2"] = 110001012,
		["Pic2"] = {f0_10,0,36,2},
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,140,2}},
		["PicClickArea"] = {{69,-49,19,242}},
	},
	[200101] = {
		["Id"] = 200101,
		["Name"] = "出口",
		["Pic1"] = "b1_1011001",
		["Monster"] = 21000101,
		["Map"] = 3,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 210001011,
		["Desc2"] = 210001012,
		["Pic2"] = {f0_10,0,36,2},
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,140,2}},
		["PicClickArea"] = {{69,-49,19,242}},
	},
	[300101] = {
		["Id"] = 300101,
		["Name"] = "出口",
		["Pic1"] = "b2_1011001",
		["Monster"] = 31000101,
		["Map"] = 4,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 310001011,
		["Desc2"] = 310001012,
		["Pic2"] = {f0_10,0,36,2},
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,140,2}},
		["PicClickArea"] = {{69,-49,19,242}},
	},
	[400101] = {
		["Id"] = 400101,
		["Name"] = "出口",
		["Pic1"] = "b1_1011001",
		["Monster"] = 11000101,
		["Map"] = 5,
		["Reward"] = 9999,
		["ElementType"] = 10,
		["Genre"] = 3,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 310001011,
		["Desc2"] = 310001012,
		["Pic2"] = {f0_10,0,36,2},
		["PicType"] = "1,2,0,0；1",
		["DirTrigger"] = 0,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Effect2"] = {{60028,70,0,140,2}},
		["PicClickArea"] = {{69,-49,19,242}},
	},
},
};


return exit[1]