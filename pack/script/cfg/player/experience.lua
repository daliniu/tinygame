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

local experience = {
[1] = {
	[1] = {
		["level"] = 1,
		["experience"] = 5,
	},
	[2] = {
		["level"] = 2,
		["experience"] = 10,
	},
	[3] = {
		["level"] = 3,
		["experience"] = 40,
	},
	[4] = {
		["level"] = 4,
		["experience"] = 250,
	},
	[5] = {
		["level"] = 5,
		["experience"] = 250,
	},
	[6] = {
		["level"] = 6,
		["experience"] = 650,
	},
	[7] = {
		["level"] = 7,
		["experience"] = 650,
	},
	[8] = {
		["level"] = 8,
		["experience"] = 650,
	},
	[9] = {
		["level"] = 9,
		["experience"] = 650,
	},
	[10] = {
		["level"] = 10,
		["experience"] = 650,
	},
	[11] = {
		["level"] = 11,
		["experience"] = 650,
	},
	[12] = {
		["level"] = 12,
		["experience"] = 650,
	},
	[13] = {
		["level"] = 13,
		["experience"] = 650,
	},
	[14] = {
		["level"] = 14,
		["experience"] = 1300,
	},
	[15] = {
		["level"] = 15,
		["experience"] = 1800,
	},
	[16] = {
		["level"] = 16,
		["experience"] = 1800,
	},
	[17] = {
		["level"] = 17,
		["experience"] = 1800,
	},
	[18] = {
		["level"] = 18,
		["experience"] = 1800,
	},
	[19] = {
		["level"] = 19,
		["experience"] = 1800,
	},
	[20] = {
		["level"] = 20,
		["experience"] = 1800,
	},
	[21] = {
		["level"] = 21,
		["experience"] = 1800,
	},
	[22] = {
		["level"] = 22,
		["experience"] = 2200,
	},
	[23] = {
		["level"] = 23,
		["experience"] = 2400,
	},
	[24] = {
		["level"] = 24,
		["experience"] = 2600,
	},
	[25] = {
		["level"] = 25,
		["experience"] = 2800,
	},
	[26] = {
		["level"] = 26,
		["experience"] = 3000,
	},
	[27] = {
		["level"] = 27,
		["experience"] = 3500,
	},
	[28] = {
		["level"] = 28,
		["experience"] = 4000,
	},
	[29] = {
		["level"] = 29,
		["experience"] = 4500,
	},
	[30] = {
		["level"] = 30,
		["experience"] = 5000,
	},
	[31] = {
		["level"] = 31,
		["experience"] = 5500,
	},
	[32] = {
		["level"] = 32,
		["experience"] = 6000,
	},
	[33] = {
		["level"] = 33,
		["experience"] = 6500,
	},
	[34] = {
		["level"] = 34,
		["experience"] = 7000,
	},
	[35] = {
		["level"] = 35,
		["experience"] = 7500,
	},
	[36] = {
		["level"] = 36,
		["experience"] = 8000,
	},
	[37] = {
		["level"] = 37,
		["experience"] = 8500,
	},
	[38] = {
		["level"] = 38,
		["experience"] = 9000,
	},
	[39] = {
		["level"] = 39,
		["experience"] = 9500,
	},
	[40] = {
		["level"] = 40,
		["experience"] = 10000,
	},
	[41] = {
		["level"] = 41,
		["experience"] = 10500,
	},
	[42] = {
		["level"] = 42,
		["experience"] = 11000,
	},
	[43] = {
		["level"] = 43,
		["experience"] = 11500,
	},
	[44] = {
		["level"] = 44,
		["experience"] = 12000,
	},
	[45] = {
		["level"] = 45,
		["experience"] = 12500,
	},
	[46] = {
		["level"] = 46,
		["experience"] = 13000,
	},
	[47] = {
		["level"] = 47,
		["experience"] = 13500,
	},
	[48] = {
		["level"] = 48,
		["experience"] = 14000,
	},
	[49] = {
		["level"] = 49,
		["experience"] = 14500,
	},
	[50] = {
		["level"] = 50,
		["experience"] = 15000,
	},
	[51] = {
		["level"] = 51,
		["experience"] = 15500,
	},
	[52] = {
		["level"] = 52,
		["experience"] = 16000,
	},
	[53] = {
		["level"] = 53,
		["experience"] = 16500,
	},
	[54] = {
		["level"] = 54,
		["experience"] = 17000,
	},
	[55] = {
		["level"] = 55,
		["experience"] = 17500,
	},
	[56] = {
		["level"] = 56,
		["experience"] = 18000,
	},
	[57] = {
		["level"] = 57,
		["experience"] = 18500,
	},
	[58] = {
		["level"] = 58,
		["experience"] = 19000,
	},
	[59] = {
		["level"] = 59,
		["experience"] = 19500,
	},
	[60] = {
		["level"] = 60,
		["experience"] = 20000,
	},
	[61] = {
		["level"] = 61,
		["experience"] = 20500,
	},
	[62] = {
		["level"] = 62,
		["experience"] = 21000,
	},
	[63] = {
		["level"] = 63,
		["experience"] = 21500,
	},
	[64] = {
		["level"] = 64,
		["experience"] = 22000,
	},
	[65] = {
		["level"] = 65,
		["experience"] = 22500,
	},
	[66] = {
		["level"] = 66,
		["experience"] = 23000,
	},
	[67] = {
		["level"] = 67,
		["experience"] = 23500,
	},
	[68] = {
		["level"] = 68,
		["experience"] = 24000,
	},
	[69] = {
		["level"] = 69,
		["experience"] = 24500,
	},
	[70] = {
		["level"] = 70,
		["experience"] = 25000,
	},
	[71] = {
		["level"] = 71,
		["experience"] = 25500,
	},
	[72] = {
		["level"] = 72,
		["experience"] = 26000,
	},
	[73] = {
		["level"] = 73,
		["experience"] = 26500,
	},
	[74] = {
		["level"] = 74,
		["experience"] = 27000,
	},
	[75] = {
		["level"] = 75,
		["experience"] = 27500,
	},
	[76] = {
		["level"] = 76,
		["experience"] = 28000,
	},
	[77] = {
		["level"] = 77,
		["experience"] = 28500,
	},
	[78] = {
		["level"] = 78,
		["experience"] = 29000,
	},
	[79] = {
		["level"] = 79,
		["experience"] = 29500,
	},
	[80] = {
		["level"] = 80,
		["experience"] = 30000,
	},
	[81] = {
		["level"] = 81,
		["experience"] = 30500,
	},
	[82] = {
		["level"] = 82,
		["experience"] = 31000,
	},
	[83] = {
		["level"] = 83,
		["experience"] = 31500,
	},
	[84] = {
		["level"] = 84,
		["experience"] = 32000,
	},
	[85] = {
		["level"] = 85,
		["experience"] = 32500,
	},
	[86] = {
		["level"] = 86,
		["experience"] = 33000,
	},
	[87] = {
		["level"] = 87,
		["experience"] = 33500,
	},
	[88] = {
		["level"] = 88,
		["experience"] = 34000,
	},
	[89] = {
		["level"] = 89,
		["experience"] = 34500,
	},
	[90] = {
		["level"] = 90,
		["experience"] = 35000,
	},
	[91] = {
		["level"] = 91,
		["experience"] = 35500,
	},
	[92] = {
		["level"] = 92,
		["experience"] = 36000,
	},
	[93] = {
		["level"] = 93,
		["experience"] = 36500,
	},
	[94] = {
		["level"] = 94,
		["experience"] = 37000,
	},
	[95] = {
		["level"] = 95,
		["experience"] = 37500,
	},
	[96] = {
		["level"] = 96,
		["experience"] = 38000,
	},
	[97] = {
		["level"] = 97,
		["experience"] = 38500,
	},
	[98] = {
		["level"] = 98,
		["experience"] = 39000,
	},
	[99] = {
		["level"] = 99,
		["experience"] = 39500,
	},
},
};


return experience[1]
