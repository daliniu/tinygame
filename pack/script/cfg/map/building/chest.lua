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

local chest = {
[1] = {
	[10101] = {
		["Id"] = 10101,
		["Name"] = "普通宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 101,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[10104] = {
		["Id"] = 10104,
		["Name"] = "普通宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 101,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[10105] = {
		["Id"] = 10105,
		["Name"] = "武器",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3501,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[10108] = {
		["Id"] = 10108,
		["Name"] = "特殊宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 103,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[10130] = {
		["Id"] = 10130,
		["Name"] = "铁矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3514,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10131] = {
		["Id"] = 10131,
		["Name"] = "铁矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3514,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10132] = {
		["Id"] = 10132,
		["Name"] = "戒指卷（蓝）",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3520,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,0,32,1}},
		["IfWindows"] = 0,
	},
	[10133] = {
		["Id"] = 10133,
		["Name"] = "银矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3515,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10134] = {
		["Id"] = 10134,
		["Name"] = "项链卷（蓝）",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3521,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,0,32,1}},
		["IfWindows"] = 0,
	},
	[10125] = {
		["Id"] = 10125,
		["Name"] = "神秘木箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 1801,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,11,69,1}},
		["IfWindows"] = 0,
	},
	[10135] = {
		["Id"] = 10135,
		["Name"] = "银矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3515,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10136] = {
		["Id"] = 10136,
		["Name"] = "银矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3515,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10110] = {
		["Id"] = 10110,
		["Name"] = "中级宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 102,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[10115] = {
		["Id"] = 10115,
		["Name"] = "上锁的宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 104,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Precondition"] = 2,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[10117] = {
		["Id"] = 10117,
		["Name"] = "银矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3515,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10114] = {
		["Id"] = 10114,
		["Name"] = "盔甲卷（紫）",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3518,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,0,32,1}},
		["IfWindows"] = 0,
	},
	[10107] = {
		["Id"] = 10107,
		["Name"] = "卡特琳娜碎片",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3552,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[10109] = {
		["Id"] = 10109,
		["Name"] = "兰斯洛特碎片",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3551,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[10119] = {
		["Id"] = 10119,
		["Name"] = "神秘木箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 1801,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,11,69,1}},
		["IfWindows"] = 0,
	},
	[10120] = {
		["Id"] = 10120,
		["Name"] = "戒指卷（紫）",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3520,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,0,32,1}},
		["IfWindows"] = 0,
	},
	[10116] = {
		["Id"] = 10116,
		["Name"] = "铁矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3514,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10118] = {
		["Id"] = 10118,
		["Name"] = "银矿石",
		["IfFloat"] = 1,
		["Reward"] = 9999,
		["Pic1"] = 3515,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,10,32,1}},
		["IfWindows"] = 0,
	},
	[10122] = {
		["Id"] = 10122,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 102,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 0,
	},
	[10123] = {
		["Id"] = 10123,
		["Name"] = "金钱宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 102,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 0,
	},
	[10124] = {
		["Id"] = 10124,
		["Name"] = "高级宝箱",
		["IfFloat"] = 0,
		["Reward"] = 9999,
		["Pic1"] = 103,
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 1,
		["Desc2"] = 1,
		["Resetting"] = 1,
		["Effect2"] = {{60062,100,16,32,1}},
		["IfWindows"] = 1,
	},
	[100101] = {
		["Id"] = 100101,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 10100101,
		["Pic1"] = "b0_0111001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[100201] = {
		["Id"] = 100201,
		["Name"] = "稀世宝刀",
		["IfFloat"] = 0,
		["Reward"] = 10100201,
		["Pic1"] = "e0_wq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[200101] = {
		["Id"] = 200101,
		["Name"] = "衣服",
		["IfFloat"] = 0,
		["Reward"] = 20100101,
		["Pic1"] = "e0_yf11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[200201] = {
		["Id"] = 200201,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 20100201,
		["Pic1"] = "b0_0111001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[300101] = {
		["Id"] = 300101,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 30100101,
		["Pic1"] = "b0_0111001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[300201] = {
		["Id"] = 300201,
		["Name"] = "锁子甲",
		["IfFloat"] = 1,
		["Reward"] = 30100201,
		["Pic1"] = "e0_yf11005",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[300301] = {
		["Id"] = 300301,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 30100301,
		["Pic1"] = "b0_0111002",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001012,
		["Desc2"] = 101001012,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[300401] = {
		["Id"] = 300401,
		["Name"] = "魔法破甲剑",
		["IfFloat"] = 1,
		["Reward"] = 30100401,
		["Pic1"] = "e0_wq11005",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400101] = {
		["Id"] = 400101,
		["Name"] = "骑士战靴",
		["IfFloat"] = 1,
		["Reward"] = 40100101,
		["Pic1"] = "e0_xz11005",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400102] = {
		["Id"] = 400102,
		["Name"] = "铁矿石",
		["IfFloat"] = 1,
		["Reward"] = 40100102,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001014,
		["Desc2"] = 101001014,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400103] = {
		["Id"] = 400103,
		["Name"] = "铁矿石",
		["IfFloat"] = 1,
		["Reward"] = 40100103,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001014,
		["Desc2"] = 101001014,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400104] = {
		["Id"] = 400104,
		["Name"] = "武器卷轴",
		["IfFloat"] = 1,
		["Reward"] = 40100104,
		["Pic1"] = "i0_wq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001014,
		["Desc2"] = 101001014,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400105] = {
		["Id"] = 400105,
		["Name"] = "鞋子卷轴",
		["IfFloat"] = 1,
		["Reward"] = 40100105,
		["Pic1"] = "i0_xz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001014,
		["Desc2"] = 101001014,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400106] = {
		["Id"] = 400106,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 40100106,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400107] = {
		["Id"] = 400107,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 40100107,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400108] = {
		["Id"] = 400108,
		["Name"] = "经验药水",
		["IfFloat"] = 1,
		["Reward"] = 40100108,
		["Pic1"] = "i0_jy11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[400201] = {
		["Id"] = 400201,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 40100201,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[400301] = {
		["Id"] = 400301,
		["Name"] = "经验宝箱",
		["IfFloat"] = 0,
		["Reward"] = 40100301,
		["Pic1"] = "b0_0111001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[400401] = {
		["Id"] = 400401,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 40100401,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[400501] = {
		["Id"] = 400501,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 40100501,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500101] = {
		["Id"] = 500101,
		["Name"] = "神秘信箱",
		["IfFloat"] = 0,
		["Reward"] = 50100101,
		["Pic1"] = "b0_1811001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500201] = {
		["Id"] = 500201,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 50100201,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500301] = {
		["Id"] = 500301,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 50100301,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500401] = {
		["Id"] = 500401,
		["Name"] = "金钱袋",
		["IfFloat"] = 1,
		["Reward"] = 50100401,
		["Pic1"] = "i0_jq11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001013,
		["Desc2"] = 101001013,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500501] = {
		["Id"] = 500501,
		["Name"] = "大宝箱",
		["IfFloat"] = 0,
		["Reward"] = 50100501,
		["Pic1"] = "b0_0111003",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 501005011,
		["Desc2"] = 501005011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[500601] = {
		["Id"] = 500601,
		["Name"] = "神秘信箱",
		["IfFloat"] = 0,
		["Reward"] = 50100601,
		["Pic1"] = "b0_1811001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["Effect2"] = {{60062,200,32,64,1}},
		["IfWindows"] = 0,
	},
	[600101] = {
		["Id"] = 600101,
		["Name"] = "兰斯洛特碎片",
		["IfFloat"] = 0,
		["Reward"] = 60100101,
		["Pic1"] = "p0_ls11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600201] = {
		["Id"] = 600201,
		["Name"] = "神秘信箱",
		["IfFloat"] = 0,
		["Reward"] = 60100201,
		["Pic1"] = "b0_1811001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600301] = {
		["Id"] = 600301,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60100301,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600401] = {
		["Id"] = 600401,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60100401,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600501] = {
		["Id"] = 600501,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60100501,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600601] = {
		["Id"] = 600601,
		["Name"] = "金钱宝箱",
		["IfFloat"] = 0,
		["Reward"] = 60100601,
		["Pic1"] = "b0_0111002",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600701] = {
		["Id"] = 600701,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60100701,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600801] = {
		["Id"] = 600801,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60100801,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[600901] = {
		["Id"] = 600901,
		["Name"] = "大宝箱",
		["IfFloat"] = 0,
		["Reward"] = 60100901,
		["Pic1"] = "b0_0111003",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[601001] = {
		["Id"] = 601001,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60101001,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
	[601101] = {
		["Id"] = 601101,
		["Name"] = "石头",
		["IfFloat"] = 0,
		["Reward"] = 60101101,
		["Pic1"] = "i0_dz11001",
		["ElementType"] = 1,
		["Genre"] = 1,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 0,
		["PickupLived"] = 0,
		["Desc1"] = 101001011,
		["Desc2"] = 101001011,
		["Resetting"] = 1,
		["IfWindows"] = 0,
	},
},
};


return chest[1]
