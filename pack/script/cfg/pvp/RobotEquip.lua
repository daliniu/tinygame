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

local RobotEquip = {
[1] = {
	[1] = {
		["ID"] = 1,
		["EquipId"] = 10102,
		["ATK"] = {200,100},
	},
	[2] = {
		["ID"] = 2,
		["EquipId"] = 10107,
		["HP"] = {200,100},
	},
	[3] = {
		["ID"] = 3,
		["EquipId"] = 10111,
		["DEF"] = {200,100},
	},
	[4] = {
		["ID"] = 4,
		["EquipId"] = 10117,
		["HP"] = {200,100},
	},
	[5] = {
		["ID"] = 5,
		["EquipId"] = 10121,
		["DEF"] = {200,100},
	},
	[6] = {
		["ID"] = 6,
		["EquipId"] = 10127,
		["HP"] = {200,100},
	},
	[7] = {
		["ID"] = 7,
		["EquipId"] = 10132,
		["ATK"] = {200,100},
	},
	[8] = {
		["ID"] = 8,
		["EquipId"] = 10136,
		["HP"] = {200,100},
	},
	[9] = {
		["ID"] = 9,
		["EquipId"] = 10141,
		["DEF"] = {200,100},
	},
	[10] = {
		["ID"] = 10,
		["EquipId"] = 10146,
		["HP"] = {200,100},
	},
	[11] = {
		["ID"] = 11,
		["EquipId"] = 10151,
		["DEF"] = {200,100},
	},
	[12] = {
		["ID"] = 12,
		["EquipId"] = 10156,
		["HP"] = {200,100},
	},
},
};


return RobotEquip[1]
