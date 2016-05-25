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

local systemlevel = {
[1] = {
	[1] = {
		["ID"] = 1,
		["Des"] = "地图系统",
		["Openlevel"] = 3,
	},
	[2] = {
		["ID"] = 2,
		["Des"] = "活动系统",
		["Openlevel"] = 1,
	},
	[3] = {
		["ID"] = 3,
		["Des"] = "任务系统",
		["Openlevel"] = 1,
	},
	[4] = {
		["ID"] = 4,
		["Des"] = "打造系统",
		["Openlevel"] = 5,
	},
	[5] = {
		["ID"] = 5,
		["Des"] = "队伍系统",
		["Openlevel"] = 1,
	},
	[6] = {
		["ID"] = 6,
		["Des"] = "背包系统",
		["Openlevel"] = 1,
	},
	[7] = {
		["ID"] = 7,
		["Des"] = "挂机系统",
		["Openlevel"] = 1,
	},
	[8] = {
		["ID"] = 8,
		["Des"] = "召唤系统",
		["Openlevel"] = 5,
	},
	[9] = {
		["ID"] = 9,
		["Des"] = "布阵系统",
		["Openlevel"] = 5,
	},
	[10] = {
		["ID"] = 10,
		["Des"] = "淬炼系统",
		["Openlevel"] = 15,
	},
	[11] = {
		["ID"] = 11,
		["Des"] = "主页系统",
		["Openlevel"] = 3,
	},
},
};


return systemlevel[1]
