-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["statusresults"] = 1,
};

sheetindex = {
[1] = "statusresults",
};

local statusresults = {
[1] = {
	[6001] = {
		["id"] = 6001,
		["effecttype"] = 2,
		["active"] = 0,
		["arg1"] = 50,
		["arg2"] = 50,
		["arg3"] = 1,
		["arg4"] = 1,
		["arg5"] = 0,
		["arg6"] = 0,
		["arg7"] = 0,
	},
	[6002] = {
		["id"] = 6002,
		["effecttype"] = 4,
		["active"] = 1,
		["arg1"] = {8001,8005},
		["arg2"] = {80,90},
		["arg3"] = 10,
		["arg4"] = 0,
		["arg5"] = 0,
		["arg6"] = 0,
		["arg7"] = 0,
	},
	[6003] = {
		["id"] = 6003,
		["effecttype"] = 1,
		["active"] = 1,
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
		["arg5"] = 0,
		["arg6"] = 0,
		["arg7"] = 0,
	},
	[6004] = {
		["id"] = 6004,
		["effecttype"] = 8,
		["active"] = 1,
		["arg1"] = {8001,8005},
		["arg2"] = {100,100},
		["arg3"] = 0,
		["arg4"] = 0,
		["arg5"] = 0,
		["arg6"] = 0,
		["arg7"] = 0,
	},
	[6005] = {
		["id"] = 6005,
		["effecttype"] = 7,
		["active"] = 0,
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
		["arg5"] = 0,
		["arg6"] = 0,
		["arg7"] = 0,
	},
	[40011] = {
		["id"] = 40011,
		["effecttype"] = 10,
		["active"] = 1,
		["arg1"] = 40012,
	},
	[40021] = {
		["id"] = 40021,
		["effecttype"] = 10,
		["active"] = 1,
		["arg1"] = 40022,
	},
	[40031] = {
		["id"] = 40031,
		["effecttype"] = 1,
		["active"] = 1,
	},
	[40041] = {
		["id"] = 40041,
		["effecttype"] = 10,
		["active"] = 1,
		["arg1"] = 40042,
	},
	[6007] = {
		["id"] = 6007,
		["effecttype"] = 3,
		["active"] = 1,
	},
	[6008] = {
		["id"] = 6008,
		["effecttype"] = 5,
		["active"] = 0,
	},
	[6009] = {
		["id"] = 6009,
		["effecttype"] = 6,
		["active"] = 1,
	},
	[6010] = {
		["id"] = 6010,
		["effecttype"] = 9,
		["active"] = 0,
		["arg1"] = 10,
		["arg2"] = 50,
		["arg3"] = 0.10000000,
	},
},
};


return statusresults[1]
