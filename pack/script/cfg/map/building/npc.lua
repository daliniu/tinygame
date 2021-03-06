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

local npc = {
[1] = {
	[19011] = {
		["Id"] = 19011,
		["Name"] = "蘑菇一家",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19011,
		["Desc2"] = 19011,
		["Pic1"] = 3637,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10111,2007,1},{10112,1000,2},{10113,2007,1},{10114,1006,1},{10115,2007,1},{10116,1013,2}},
	},
	[19012] = {
		["Id"] = 19012,
		["Name"] = "路过的蘑菇们",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19012,
		["Desc2"] = 19012,
		["Pic1"] = 3638,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10121,1000,2},{10122,2007,1},{10123,1006,1}},
	},
	[19021] = {
		["Id"] = 19021,
		["Name"] = "漂浮的光灵",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19021,
		["Desc2"] = 19021,
		["Pic1"] = 3634,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10211,2023,1},{10212,1000,2},{10213,2023,1},{10214,1000,2},{10215,2023,1}},
	},
	[19022] = {
		["Id"] = 19022,
		["Name"] = "迷乱的美杜莎",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19022,
		["Desc2"] = 19022,
		["Pic1"] = 600,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10221,2003,1},{10222,1000,2},{10223,2003,1},{10224,1006,1},{10225,2003,1}},
	},
	[19031] = {
		["Id"] = 19031,
		["Name"] = "骷髅逃兵",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19031,
		["Desc2"] = 19031,
		["Pic1"] = 3646,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10311,2025,1},{10312,1000,2},{10313,1006,1},{10314,1000,2}},
	},
	[19032] = {
		["Id"] = 19032,
		["Name"] = "骷髅叛军",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 19032,
		["Desc2"] = 19032,
		["Pic1"] = 3645,
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,92,1}},
		["WordAndPic"] = {{10321,2025,1},{10322,1000,2},{10323,1013,2},{10324,2025,1}},
	},
	[100101] = {
		["Id"] = 100101,
		["Name"] = "天使",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_ct11001",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{1001011,2034,1},{1001012,2034,1},{1001013,1000,2},{1001014,2034,1}},
	},
	[200101] = {
		["Id"] = 200101,
		["Name"] = "史莱姆",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_sl11001",
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,184,1}},
		["WordAndPic"] = {{1001011,2007,1},{1001012,1000,2},{1001013,2007,1},{1001014,1006,1},{1001015,2007,1},{1001016,1013,2}},
	},
	[200201] = {
		["Id"] = 200201,
		["Name"] = "蘑菇",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_mg11001",
		["Resetting"] = 0,
		["Effect2"] = {{60064,100,0,184,1}},
		["WordAndPic"] = {{1001011,2007,1},{1001012,1000,2},{1001013,2007,1},{1001014,1006,1},{1001015,2007,1},{1001016,1013,2}},
	},
	[300101] = {
		["Id"] = 300101,
		["Name"] = "路过的蘑菇们",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_mg11001",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{3001011,2007,1},{3001012,1000,2},{3001013,2007,1},{3001014,1000,1},{3001015,2007,1}},
	},
	[400101] = {
		["Id"] = 400101,
		["Name"] = "好心人",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_gl11001",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{4001011,2023,1},{4001012,1000,2},{4001013,2023,1}},
	},
	[400201] = {
		["Id"] = 400201,
		["Name"] = "狮鹫哥哥",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_sj11002",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{4002011,2099,1},{4002012,1000,2},{4002013,2099,1},{4002014,1000,2},{4002015,2099,1}},
	},
	[400301] = {
		["Id"] = 400301,
		["Name"] = "狮鹫弟弟",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_sj11002",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{4003011,2098,1},{4003012,1000,2},{4003013,2098,1}},
	},
	[500101] = {
		["Id"] = 500101,
		["Name"] = "天使",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_ct11001",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{5001011,2034,1},{5001012,1000,2},{5001013,2034,1},{5001014,1000,2}},
	},
	[500201] = {
		["Id"] = 500201,
		["Name"] = "天使",
		["ElementType"] = 19,
		["Genre"] = 7,
		["Area"] = {1,1},
		["Obstacle"] = 1,
		["GetInto"] = 0,
		["PickupLived"] = 1,
		["Desc1"] = 119001011,
		["Desc2"] = 119001011,
		["Pic1"] = "m0_ct11001",
		["Resetting"] = 0,
		["Effect2"] = {{60085,200,0,184,1}},
		["WordAndPic"] = {{5002011,2034,1},{5002012,1000,2},{5002013,2034,1},{5002014,1000,2},{5002015,2034,1},{5002016,1000,2}},
	},
},
};


return npc[1]
