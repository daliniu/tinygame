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

local heroshop = {
[1] = {
	[1] = {
		["ID"] = 1,
		["1st"] = 19001,
		["2st"] = 19002,
		["3st"] = 19002,
		["4st"] = 19004,
		["5st"] = 19003,
	},
	[2] = {
		["ID"] = 2,
		["1st"] = 19002,
		["2st"] = 19003,
		["3st"] = 19003,
		["4st"] = 19009,
		["5st"] = 19004,
	},
	[3] = {
		["ID"] = 3,
		["1st"] = 19006,
		["2st"] = 19007,
		["3st"] = 19007,
		["4st"] = 19014,
		["5st"] = 19005,
	},
	[4] = {
		["ID"] = 4,
		["1st"] = 19007,
		["2st"] = 19008,
		["3st"] = 19008,
		["4st"] = 19019,
		["5st"] = 19008,
	},
	[5] = {
		["ID"] = 5,
		["1st"] = 19011,
		["2st"] = 19012,
		["3st"] = 19012,
		["4st"] = 19024,
		["5st"] = 19009,
	},
	[6] = {
		["ID"] = 6,
		["1st"] = 19012,
		["2st"] = 19013,
		["3st"] = 19013,
		["4st"] = 19029,
		["5st"] = 19010,
	},
	[7] = {
		["ID"] = 7,
		["1st"] = 19016,
		["2st"] = 19017,
		["3st"] = 19017,
		["4st"] = 19034,
		["5st"] = 19013,
	},
	[8] = {
		["ID"] = 8,
		["1st"] = 19017,
		["2st"] = 19018,
		["3st"] = 19018,
		["4st"] = 19039,
		["5st"] = 19014,
	},
	[9] = {
		["ID"] = 9,
		["1st"] = 19021,
		["2st"] = 19022,
		["3st"] = 19022,
		["4st"] = 19044,
		["5st"] = 19015,
	},
	[10] = {
		["ID"] = 10,
		["1st"] = 19022,
		["2st"] = 19023,
		["3st"] = 19023,
		["4st"] = 19049,
		["5st"] = 19018,
	},
	[11] = {
		["ID"] = 11,
		["1st"] = 19026,
		["2st"] = 19027,
		["3st"] = 19027,
		["4st"] = 19054,
		["5st"] = 19019,
	},
	[12] = {
		["ID"] = 12,
		["1st"] = 19027,
		["2st"] = 19028,
		["3st"] = 19028,
		["4st"] = 19059,
		["5st"] = 19020,
	},
	[13] = {
		["ID"] = 13,
		["1st"] = 19031,
		["2st"] = 19032,
		["3st"] = 19032,
		["4st"] = 19064,
		["5st"] = 19023,
	},
	[14] = {
		["ID"] = 14,
		["1st"] = 19032,
		["2st"] = 19033,
		["3st"] = 19033,
		["4st"] = 19069,
		["5st"] = 19024,
	},
	[15] = {
		["ID"] = 15,
		["1st"] = 19036,
		["2st"] = 19037,
		["3st"] = 19037,
		["4st"] = 19002,
		["5st"] = 19025,
	},
	[16] = {
		["ID"] = 16,
		["1st"] = 19037,
		["2st"] = 19038,
		["3st"] = 19038,
		["4st"] = 19003,
		["5st"] = 19028,
	},
	[17] = {
		["ID"] = 17,
		["1st"] = 19041,
		["2st"] = 19042,
		["3st"] = 19042,
		["4st"] = 19007,
		["5st"] = 19029,
	},
	[18] = {
		["ID"] = 18,
		["1st"] = 19042,
		["2st"] = 19043,
		["3st"] = 19043,
		["4st"] = 19008,
		["5st"] = 19030,
	},
	[19] = {
		["ID"] = 19,
		["1st"] = 19046,
		["2st"] = 19047,
		["3st"] = 19047,
		["4st"] = 19012,
		["5st"] = 19033,
	},
	[20] = {
		["ID"] = 20,
		["1st"] = 19047,
		["2st"] = 19048,
		["3st"] = 19048,
		["4st"] = 19013,
		["5st"] = 19034,
	},
	[21] = {
		["ID"] = 21,
		["1st"] = 19051,
		["2st"] = 19052,
		["3st"] = 19052,
		["4st"] = 19017,
		["5st"] = 19035,
	},
	[22] = {
		["ID"] = 22,
		["1st"] = 19052,
		["2st"] = 19053,
		["3st"] = 19053,
		["4st"] = 19018,
		["5st"] = 19038,
	},
	[23] = {
		["ID"] = 23,
		["1st"] = 19056,
		["2st"] = 19057,
		["3st"] = 19057,
		["4st"] = 19022,
		["5st"] = 19039,
	},
	[24] = {
		["ID"] = 24,
		["1st"] = 19057,
		["2st"] = 19058,
		["3st"] = 19058,
		["4st"] = 19023,
		["5st"] = 19040,
	},
	[25] = {
		["ID"] = 25,
		["1st"] = 19061,
		["2st"] = 19062,
		["3st"] = 19062,
		["4st"] = 19027,
		["5st"] = 19043,
	},
	[26] = {
		["ID"] = 26,
		["1st"] = 19062,
		["2st"] = 19063,
		["3st"] = 19063,
		["4st"] = 19028,
		["5st"] = 19044,
	},
	[27] = {
		["ID"] = 27,
		["1st"] = 19066,
		["2st"] = 19067,
		["3st"] = 19067,
		["4st"] = 19032,
		["5st"] = 19045,
	},
	[28] = {
		["ID"] = 28,
		["1st"] = 19067,
		["2st"] = 19068,
		["3st"] = 19068,
		["4st"] = 19033,
		["5st"] = 19048,
	},
	[29] = {
		["ID"] = 29,
		["4st"] = 19037,
		["5st"] = 19049,
	},
	[30] = {
		["ID"] = 30,
		["4st"] = 19038,
		["5st"] = 19050,
	},
	[31] = {
		["ID"] = 31,
		["4st"] = 19042,
		["5st"] = 19053,
	},
	[32] = {
		["ID"] = 32,
		["4st"] = 19043,
		["5st"] = 19054,
	},
	[33] = {
		["ID"] = 33,
		["4st"] = 19047,
		["5st"] = 19055,
	},
	[34] = {
		["ID"] = 34,
		["4st"] = 19048,
		["5st"] = 19058,
	},
	[35] = {
		["ID"] = 35,
		["4st"] = 19052,
		["5st"] = 19059,
	},
	[36] = {
		["ID"] = 36,
		["4st"] = 19053,
		["5st"] = 19060,
	},
	[37] = {
		["ID"] = 37,
		["4st"] = 19057,
		["5st"] = 19063,
	},
	[38] = {
		["ID"] = 38,
		["4st"] = 19058,
		["5st"] = 19064,
	},
	[39] = {
		["ID"] = 39,
		["4st"] = 19062,
		["5st"] = 19065,
	},
	[40] = {
		["ID"] = 40,
		["4st"] = 19063,
		["5st"] = 19068,
	},
	[41] = {
		["ID"] = 41,
		["4st"] = 19067,
		["5st"] = 19069,
	},
	[42] = {
		["ID"] = 42,
		["4st"] = 19068,
		["5st"] = 19070,
	},
},
};


return heroshop[1]
