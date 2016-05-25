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

local exploration = {
[1] = {
	[1] = {
		["Key"] = 1,
		["MapId"] = 1,
		["UId"] = 2220,
		["Exploration"] = 10,
	},
	[2] = {
		["Key"] = 2,
		["MapId"] = 1,
		["UId"] = 2451,
		["Exploration"] = 10,
	},
	[3] = {
		["Key"] = 3,
		["MapId"] = 1,
		["UId"] = 2453,
		["Exploration"] = 10,
	},
	[4] = {
		["Key"] = 4,
		["MapId"] = 1,
		["UId"] = 2457,
		["Exploration"] = 10,
	},
	[5] = {
		["Key"] = 5,
		["MapId"] = 2,
		["UId"] = 1713,
		["Exploration"] = 10,
	},
	[6] = {
		["Key"] = 6,
		["MapId"] = 2,
		["UId"] = 1715,
		["Exploration"] = 10,
	},
	[7] = {
		["Key"] = 7,
		["MapId"] = 2,
		["UId"] = 1914,
		["Exploration"] = 10,
	},
	[8] = {
		["Key"] = 8,
		["MapId"] = 2,
		["UId"] = 1942,
		["Exploration"] = 10,
	},
	[9] = {
		["Key"] = 9,
		["MapId"] = 2,
		["UId"] = 1946,
		["Exploration"] = 10,
	},
	[10] = {
		["Key"] = 10,
		["MapId"] = 2,
		["UId"] = 1949,
		["Exploration"] = 10,
	},
	[11] = {
		["Key"] = 11,
		["MapId"] = 2,
		["UId"] = 1953,
		["Exploration"] = 10,
	},
	[12] = {
		["Key"] = 12,
		["MapId"] = 2,
		["UId"] = 1954,
		["Exploration"] = 10,
	},
	[13] = {
		["Key"] = 13,
		["MapId"] = 2,
		["UId"] = 1973,
		["Exploration"] = 10,
	},
	[14] = {
		["Key"] = 14,
		["MapId"] = 2,
		["UId"] = 1974,
		["Exploration"] = 10,
	},
	[15] = {
		["Key"] = 15,
		["MapId"] = 3,
		["UId"] = 1978,
		["Exploration"] = 10,
	},
	[16] = {
		["Key"] = 16,
		["MapId"] = 3,
		["UId"] = 1982,
		["Exploration"] = 10,
	},
	[17] = {
		["Key"] = 17,
		["MapId"] = 3,
		["UId"] = 2285,
		["Exploration"] = 10,
	},
	[18] = {
		["Key"] = 18,
		["MapId"] = 3,
		["UId"] = 2356,
		["Exploration"] = 10,
	},
	[19] = {
		["Key"] = 19,
		["MapId"] = 3,
		["UId"] = 2359,
		["Exploration"] = 10,
	},
	[20] = {
		["Key"] = 20,
		["MapId"] = 3,
		["UId"] = 2423,
		["Exploration"] = 10,
	},
	[21] = {
		["Key"] = 21,
		["MapId"] = 3,
		["UId"] = 2443,
		["Exploration"] = 10,
	},
	[22] = {
		["Key"] = 22,
		["MapId"] = 3,
		["UId"] = 2447,
		["Exploration"] = 10,
	},
	[23] = {
		["Key"] = 23,
		["MapId"] = 3,
		["UId"] = 2467,
		["Exploration"] = 10,
	},
	[24] = {
		["Key"] = 24,
		["MapId"] = 3,
		["UId"] = 2468,
		["Exploration"] = 10,
	},
	[25] = {
		["Key"] = 25,
		["MapId"] = 3,
		["UId"] = 2475,
		["Exploration"] = 10,
	},
	[26] = {
		["Key"] = 26,
		["MapId"] = 3,
		["UId"] = 2477,
		["Exploration"] = 10,
	},
	[27] = {
		["Key"] = 27,
		["MapId"] = 3,
		["UId"] = 2479,
		["Exploration"] = 10,
	},
	[28] = {
		["Key"] = 28,
		["MapId"] = 3,
		["UId"] = 2480,
		["Exploration"] = 10,
	},
	[29] = {
		["Key"] = 29,
		["MapId"] = 3,
		["UId"] = 2501,
		["Exploration"] = 10,
	},
	[30] = {
		["Key"] = 30,
		["MapId"] = 3,
		["UId"] = 2502,
		["Exploration"] = 10,
	},
	[31] = {
		["Key"] = 31,
		["MapId"] = 3,
		["UId"] = 2504,
		["Exploration"] = 10,
	},
	[32] = {
		["Key"] = 32,
		["MapId"] = 3,
		["UId"] = 2505,
		["Exploration"] = 10,
	},
	[33] = {
		["Key"] = 33,
		["MapId"] = 3,
		["UId"] = 2506,
		["Exploration"] = 10,
	},
	[34] = {
		["Key"] = 34,
		["MapId"] = 3,
		["UId"] = 2507,
		["Exploration"] = 10,
	},
	[35] = {
		["Key"] = 35,
		["MapId"] = 3,
		["UId"] = 2508,
		["Exploration"] = 10,
	},
	[36] = {
		["Key"] = 36,
		["MapId"] = 3,
		["UId"] = 2509,
		["Exploration"] = 10,
	},
	[37] = {
		["Key"] = 37,
		["MapId"] = 3,
		["UId"] = 2510,
		["Exploration"] = 10,
	},
	[38] = {
		["Key"] = 38,
		["MapId"] = 3,
		["UId"] = 2511,
		["Exploration"] = 10,
	},
	[39] = {
		["Key"] = 39,
		["MapId"] = 4,
		["UId"] = 2307,
		["Exploration"] = 10,
	},
	[40] = {
		["Key"] = 40,
		["MapId"] = 4,
		["UId"] = 2467,
		["Exploration"] = 10,
	},
	[41] = {
		["Key"] = 41,
		["MapId"] = 4,
		["UId"] = 2655,
		["Exploration"] = 10,
	},
	[42] = {
		["Key"] = 42,
		["MapId"] = 4,
		["UId"] = 2682,
		["Exploration"] = 10,
	},
	[43] = {
		["Key"] = 43,
		["MapId"] = 4,
		["UId"] = 2688,
		["Exploration"] = 10,
	},
	[44] = {
		["Key"] = 44,
		["MapId"] = 4,
		["UId"] = 2698,
		["Exploration"] = 10,
	},
	[45] = {
		["Key"] = 45,
		["MapId"] = 4,
		["UId"] = 3030,
		["Exploration"] = 10,
	},
	[46] = {
		["Key"] = 46,
		["MapId"] = 4,
		["UId"] = 3045,
		["Exploration"] = 10,
	},
	[47] = {
		["Key"] = 47,
		["MapId"] = 4,
		["UId"] = 3047,
		["Exploration"] = 10,
	},
	[48] = {
		["Key"] = 48,
		["MapId"] = 4,
		["UId"] = 3050,
		["Exploration"] = 10,
	},
	[49] = {
		["Key"] = 49,
		["MapId"] = 4,
		["UId"] = 3055,
		["Exploration"] = 10,
	},
	[50] = {
		["Key"] = 50,
		["MapId"] = 4,
		["UId"] = 3058,
		["Exploration"] = 10,
	},
	[51] = {
		["Key"] = 51,
		["MapId"] = 4,
		["UId"] = 3060,
		["Exploration"] = 10,
	},
	[52] = {
		["Key"] = 52,
		["MapId"] = 4,
		["UId"] = 3062,
		["Exploration"] = 10,
	},
	[53] = {
		["Key"] = 53,
		["MapId"] = 4,
		["UId"] = 3071,
		["Exploration"] = 10,
	},
	[54] = {
		["Key"] = 54,
		["MapId"] = 4,
		["UId"] = 3073,
		["Exploration"] = 10,
	},
	[55] = {
		["Key"] = 55,
		["MapId"] = 4,
		["UId"] = 3085,
		["Exploration"] = 10,
	},
},
};


return exploration[1]
