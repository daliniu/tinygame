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

local itembox = {
[1] = {
	[10001] = {
		["boxid"] = 10001,
		["itemid"] = {110101,110103,110105},
	},
	[10002] = {
		["boxid"] = 10002,
		["itemid"] = {16001,16004,15101},
	},
	[10003] = {
		["boxid"] = 10003,
		["itemid"] = {16001,16002,16003,16004,16005,16006,15102},
	},
	[10004] = {
		["boxid"] = 10004,
		["itemid"] = {16001,16002},
	},
	[10005] = {
		["boxid"] = 10005,
		["itemid"] = {110102,110104,110106},
	},
	[10006] = {
		["boxid"] = 10006,
		["itemid"] = {},
	},
	[15101] = {
		["boxid"] = 15101,
		["itemid"] = {15101},
	},
	[15102] = {
		["boxid"] = 15102,
		["itemid"] = {15102},
	},
	[16001] = {
		["boxid"] = 16001,
		["itemid"] = {16001},
	},
	[16002] = {
		["boxid"] = 16002,
		["itemid"] = {16002},
	},
	[16003] = {
		["boxid"] = 16003,
		["itemid"] = {16003},
	},
	[16004] = {
		["boxid"] = 16004,
		["itemid"] = {16004},
	},
	[16005] = {
		["boxid"] = 16005,
		["itemid"] = {16005},
	},
	[16006] = {
		["boxid"] = 16006,
		["itemid"] = {16006},
	},
	[16007] = {
		["boxid"] = 16007,
		["itemid"] = {16007},
	},
	[16008] = {
		["boxid"] = 16008,
		["itemid"] = {16008},
	},
	[16009] = {
		["boxid"] = 16009,
		["itemid"] = {16009},
	},
	[16010] = {
		["boxid"] = 16010,
		["itemid"] = {16010},
	},
	[16011] = {
		["boxid"] = 16011,
		["itemid"] = {16011},
	},
	[16012] = {
		["boxid"] = 16012,
		["itemid"] = {16012},
	},
	[16013] = {
		["boxid"] = 16013,
		["itemid"] = {16013},
	},
	[16014] = {
		["boxid"] = 16014,
		["itemid"] = {16014},
	},
	[16015] = {
		["boxid"] = 16015,
		["itemid"] = {16015},
	},
	[16016] = {
		["boxid"] = 16016,
		["itemid"] = {16016},
	},
	[16017] = {
		["boxid"] = 16017,
		["itemid"] = {16017},
	},
	[16018] = {
		["boxid"] = 16018,
		["itemid"] = {16018},
	},
	[16019] = {
		["boxid"] = 16019,
		["itemid"] = {16019},
	},
	[16020] = {
		["boxid"] = 16020,
		["itemid"] = {16020},
	},
	[16021] = {
		["boxid"] = 16021,
		["itemid"] = {16021},
	},
	[16022] = {
		["boxid"] = 16022,
		["itemid"] = {16022},
	},
	[16023] = {
		["boxid"] = 16023,
		["itemid"] = {16023},
	},
	[16024] = {
		["boxid"] = 16024,
		["itemid"] = {16024},
	},
	[16025] = {
		["boxid"] = 16025,
		["itemid"] = {16025},
	},
	[16026] = {
		["boxid"] = 16026,
		["itemid"] = {16026},
	},
	[16027] = {
		["boxid"] = 16027,
		["itemid"] = {16027},
	},
	[16028] = {
		["boxid"] = 16028,
		["itemid"] = {16028},
	},
	[16029] = {
		["boxid"] = 16029,
		["itemid"] = {16029},
	},
	[16030] = {
		["boxid"] = 16030,
		["itemid"] = {16030},
	},
	[16031] = {
		["boxid"] = 16031,
		["itemid"] = {16031},
	},
	[16032] = {
		["boxid"] = 16032,
		["itemid"] = {16032},
	},
	[16033] = {
		["boxid"] = 16033,
		["itemid"] = {16033},
	},
	[16034] = {
		["boxid"] = 16034,
		["itemid"] = {16034},
	},
	[16035] = {
		["boxid"] = 16035,
		["itemid"] = {16035},
	},
	[110101] = {
		["boxid"] = 110101,
		["itemid"] = {110101},
	},
	[110102] = {
		["boxid"] = 110102,
		["itemid"] = {110102},
	},
	[110103] = {
		["boxid"] = 110103,
		["itemid"] = {110103},
	},
	[110104] = {
		["boxid"] = 110104,
		["itemid"] = {110104},
	},
	[110105] = {
		["boxid"] = 110105,
		["itemid"] = {110105},
	},
	[110106] = {
		["boxid"] = 110106,
		["itemid"] = {110106},
	},
},
};


return itembox[1]