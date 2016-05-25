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

local buffstation = {
[1] = {
	[12001] = {
		["Id"] = 12001,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1200,
		["Pic2"] = 1201,
		["Resetting"] = 0,
		["Buff"] = 1,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12002] = {
		["Id"] = 12002,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1200,
		["Pic2"] = 1201,
		["Resetting"] = 0,
		["Buff"] = 2,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12003] = {
		["Id"] = 12003,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1200,
		["Pic2"] = 1201,
		["Resetting"] = 0,
		["Buff"] = 3,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12004] = {
		["Id"] = 12004,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1202,
		["Pic2"] = 1202,
		["Resetting"] = 0,
		["Buff"] = 1,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12005] = {
		["Id"] = 12005,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1202,
		["Pic2"] = 1202,
		["Resetting"] = 0,
		["Buff"] = 2,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12006] = {
		["Id"] = 12006,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1202,
		["Pic2"] = 1202,
		["Resetting"] = 0,
		["Buff"] = 3,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12007] = {
		["Id"] = 12007,
		["Name"] = "2圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1203,
		["Pic2"] = 1203,
		["Resetting"] = 0,
		["Buff"] = 4,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12008] = {
		["Id"] = 12008,
		["Name"] = "4圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1202,
		["Pic2"] = 1202,
		["Resetting"] = 0,
		["Buff"] = 7,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12009] = {
		["Id"] = 12009,
		["Name"] = "4圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1202,
		["Pic2"] = 1202,
		["Resetting"] = 0,
		["Buff"] = 8,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12010] = {
		["Id"] = 12010,
		["Name"] = "2圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1203,
		["Pic2"] = 1203,
		["Resetting"] = 0,
		["Buff"] = 5,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[12011] = {
		["Id"] = 12011,
		["Name"] = "3圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 1200,
		["Desc2"] = 1201,
		["Pic1"] = 1203,
		["Pic2"] = 1203,
		["Resetting"] = 0,
		["Buff"] = 6,
		["Effect2"] = {{60049,100,0,110,1}},
	},
	[500101] = {
		["Id"] = 500101,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 512001011,
		["Desc2"] = 512001012,
		["Pic1"] = "b2_1211001",
		["Resetting"] = 0,
		["Buff"] = 6,
		["Effect2"] = {{60049,200,0,230,1}},
	},
	[600101] = {
		["Id"] = 600101,
		["Name"] = "圣泉",
		["ElementType"] = 12,
		["Genre"] = 4,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 512001011,
		["Desc2"] = 512001012,
		["Pic1"] = "b2_1211001",
		["Resetting"] = 0,
		["Buff"] = 6,
		["Effect2"] = {{60049,200,0,230,1}},
	},
},
};


return buffstation[1]
