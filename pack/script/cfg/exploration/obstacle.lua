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

local obstacle = {
[1] = {
	[33001] = {
		["Id"] = 33001,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33001,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33002] = {
		["Id"] = 33002,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33002,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33003] = {
		["Id"] = 33003,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33003,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33004] = {
		["Id"] = 33004,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33004,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33005] = {
		["Id"] = 33005,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33005,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33006] = {
		["Id"] = 33006,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33006,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33007] = {
		["Id"] = 33007,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33007,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33008] = {
		["Id"] = 33008,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33008,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33009] = {
		["Id"] = 33009,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 5,
		["Pic1"] = 33009,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33010] = {
		["Id"] = 33010,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 5,
		["Pic1"] = 33010,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33011] = {
		["Id"] = 33011,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 11,
		["Pic1"] = 33011,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33012] = {
		["Id"] = 33012,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 12,
		["Pic1"] = 33012,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33013] = {
		["Id"] = 33013,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 11,
		["Pic1"] = 33013,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33014] = {
		["Id"] = 33014,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 12,
		["Pic1"] = 33014,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33015] = {
		["Id"] = 33015,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 12,
		["Pic1"] = 33015,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33016] = {
		["Id"] = 33016,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 10,
		["Pic1"] = 33016,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33017] = {
		["Id"] = 33017,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 10,
		["Pic1"] = 33017,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33018] = {
		["Id"] = 33018,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 7,
		["Pic1"] = 33018,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33101] = {
		["Id"] = 33101,
		["Area"] = {1,1},
		["XOffset"] = 9,
		["YOffset"] = 28,
		["Pic1"] = 33101,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33102] = {
		["Id"] = 33102,
		["Area"] = {1,1},
		["XOffset"] = 9,
		["YOffset"] = 28,
		["Pic1"] = 33102,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33103] = {
		["Id"] = 33103,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 28,
		["Pic1"] = 33103,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33104] = {
		["Id"] = 33104,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 28,
		["Pic1"] = 33104,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33105] = {
		["Id"] = 33105,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 28,
		["Pic1"] = 33105,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33106] = {
		["Id"] = 33106,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 28,
		["Pic1"] = 33106,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33107] = {
		["Id"] = 33107,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 42,
		["Pic1"] = 33107,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33108] = {
		["Id"] = 33108,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 44,
		["Pic1"] = 33108,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33109] = {
		["Id"] = 33109,
		["Area"] = {2,2},
		["XOffset"] = -23,
		["YOffset"] = 35,
		["Pic1"] = 33109,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33110] = {
		["Id"] = 33110,
		["Area"] = {2,2},
		["XOffset"] = -22,
		["YOffset"] = 24,
		["Pic1"] = 33110,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33111] = {
		["Id"] = 33111,
		["Area"] = {2,2},
		["XOffset"] = 0,
		["YOffset"] = 30,
		["Pic1"] = 33111,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33112] = {
		["Id"] = 33112,
		["Area"] = {2,2},
		["XOffset"] = 0,
		["YOffset"] = 10,
		["Pic1"] = 33112,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33113] = {
		["Id"] = 33113,
		["Area"] = {1,1},
		["XOffset"] = -3,
		["YOffset"] = 15,
		["Pic1"] = 33113,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33114] = {
		["Id"] = 33114,
		["Area"] = {1,1},
		["XOffset"] = 5,
		["YOffset"] = 36,
		["Pic1"] = 33114,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33115] = {
		["Id"] = 33115,
		["Area"] = {1,1},
		["XOffset"] = 7,
		["YOffset"] = 32,
		["Pic1"] = 33115,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33116] = {
		["Id"] = 33116,
		["Area"] = {1,1},
		["XOffset"] = -11,
		["YOffset"] = 39,
		["Pic1"] = 33116,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33117] = {
		["Id"] = 33117,
		["Area"] = {1,1},
		["XOffset"] = -12,
		["YOffset"] = 44,
		["Pic1"] = 33117,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33118] = {
		["Id"] = 33118,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 23,
		["Pic1"] = 33118,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33119] = {
		["Id"] = 33119,
		["Area"] = {2,1},
		["XOffset"] = 25,
		["YOffset"] = 156,
		["Pic1"] = 33119,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33120] = {
		["Id"] = 33120,
		["Area"] = {1,2},
		["XOffset"] = -25,
		["YOffset"] = 150,
		["Pic1"] = 33120,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33121] = {
		["Id"] = 33121,
		["Area"] = {1,1},
		["XOffset"] = 10,
		["YOffset"] = 149,
		["Pic1"] = 33121,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33122] = {
		["Id"] = 33122,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 145,
		["Pic1"] = 33122,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33123] = {
		["Id"] = 33123,
		["Area"] = {1,1},
		["XOffset"] = -13,
		["YOffset"] = 29,
		["Pic1"] = 33123,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33124] = {
		["Id"] = 33124,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 27,
		["Pic1"] = 33124,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33125] = {
		["Id"] = 33125,
		["Area"] = {1,1},
		["XOffset"] = -13,
		["YOffset"] = 18,
		["Pic1"] = 33125,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33126] = {
		["Id"] = 33126,
		["Area"] = {1,1},
		["XOffset"] = -10,
		["YOffset"] = 18,
		["Pic1"] = 33126,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33127] = {
		["Id"] = 33127,
		["Area"] = {1,1},
		["XOffset"] = 11,
		["YOffset"] = 20,
		["Pic1"] = 33127,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33128] = {
		["Id"] = 33128,
		["Area"] = {1,1},
		["XOffset"] = 11,
		["YOffset"] = 17,
		["Pic1"] = 33128,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33129] = {
		["Id"] = 33129,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 39,
		["Pic1"] = 33129,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33130] = {
		["Id"] = 33130,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 44,
		["Pic1"] = 33130,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33131] = {
		["Id"] = 33131,
		["Area"] = {1,1},
		["XOffset"] = 5,
		["YOffset"] = 36,
		["Pic1"] = 33131,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33132] = {
		["Id"] = 33132,
		["Area"] = {1,1},
		["XOffset"] = 7,
		["YOffset"] = 32,
		["Pic1"] = 33132,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33133] = {
		["Id"] = 33133,
		["Area"] = {1,1},
		["XOffset"] = -11,
		["YOffset"] = 39,
		["Pic1"] = 33133,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33134] = {
		["Id"] = 33134,
		["Area"] = {1,1},
		["XOffset"] = -12,
		["YOffset"] = 44,
		["Pic1"] = 33134,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33135] = {
		["Id"] = 33135,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 23,
		["Pic1"] = 33135,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33136] = {
		["Id"] = 33136,
		["Area"] = {2,1},
		["XOffset"] = 25,
		["YOffset"] = 156,
		["Pic1"] = 33136,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33137] = {
		["Id"] = 33137,
		["Area"] = {1,1},
		["XOffset"] = 13,
		["YOffset"] = 168,
		["Pic1"] = 33137,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33138] = {
		["Id"] = 33138,
		["Area"] = {1,1},
		["XOffset"] = 10,
		["YOffset"] = 149,
		["Pic1"] = 33138,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33139] = {
		["Id"] = 33139,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 145,
		["Pic1"] = 33139,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33140] = {
		["Id"] = 33140,
		["Area"] = {2,2},
		["XOffset"] = 6,
		["YOffset"] = 119,
		["Pic1"] = 33140,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33141] = {
		["Id"] = 33141,
		["Area"] = {2,2},
		["XOffset"] = 6,
		["YOffset"] = 119,
		["Pic1"] = 33141,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33142] = {
		["Id"] = 33142,
		["Area"] = {2,2},
		["XOffset"] = 5,
		["YOffset"] = 110,
		["Pic1"] = 33142,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33143] = {
		["Id"] = 33143,
		["Area"] = {2,2},
		["XOffset"] = 5,
		["YOffset"] = 110,
		["Pic1"] = 33143,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33144] = {
		["Id"] = 33144,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 35,
		["Pic1"] = 33144,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33145] = {
		["Id"] = 33145,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 35,
		["Pic1"] = 33145,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33146] = {
		["Id"] = 33146,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 35,
		["Pic1"] = 33146,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33201] = {
		["Id"] = 33201,
		["Area"] = {2,2},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33201,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33202] = {
		["Id"] = 33202,
		["Area"] = {1,1},
		["XOffset"] = -16,
		["YOffset"] = 24,
		["Pic1"] = 33202,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33203] = {
		["Id"] = 33203,
		["Area"] = {2,2},
		["XOffset"] = -20,
		["YOffset"] = 10,
		["Pic1"] = 33203,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33204] = {
		["Id"] = 33204,
		["Area"] = {1,2},
		["XOffset"] = -27,
		["YOffset"] = 23,
		["Pic1"] = 33204,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33205] = {
		["Id"] = 33205,
		["Area"] = {2,3},
		["XOffset"] = -44,
		["YOffset"] = 26,
		["Pic1"] = 33205,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33206] = {
		["Id"] = 33206,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 20,
		["Pic1"] = 33206,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33207] = {
		["Id"] = 33207,
		["Area"] = {1,2},
		["XOffset"] = -19,
		["YOffset"] = 19,
		["Pic1"] = 33207,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33208] = {
		["Id"] = 33208,
		["Area"] = {2,1},
		["XOffset"] = 18,
		["YOffset"] = 23,
		["Pic1"] = 33208,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33209] = {
		["Id"] = 33209,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 10,
		["Pic1"] = 33209,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33210] = {
		["Id"] = 33210,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33210,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33211] = {
		["Id"] = 33211,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33211,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33212] = {
		["Id"] = 33212,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33212,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33213] = {
		["Id"] = 33213,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33213,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33214] = {
		["Id"] = 33214,
		["Area"] = {2,2},
		["XOffset"] = -21,
		["YOffset"] = 19,
		["Pic1"] = 33214,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33215] = {
		["Id"] = 33215,
		["Area"] = {2,2},
		["XOffset"] = -11,
		["YOffset"] = 19,
		["Pic1"] = 33215,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33216] = {
		["Id"] = 33216,
		["Area"] = {1,2},
		["XOffset"] = -24,
		["YOffset"] = 28,
		["Pic1"] = 33216,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33217] = {
		["Id"] = 33217,
		["Area"] = {1,2},
		["XOffset"] = -19,
		["YOffset"] = 23,
		["Pic1"] = 33217,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33218] = {
		["Id"] = 33218,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 23,
		["Pic1"] = 33218,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33219] = {
		["Id"] = 33219,
		["Area"] = {2,1},
		["XOffset"] = 22,
		["YOffset"] = 28,
		["Pic1"] = 33219,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33220] = {
		["Id"] = 33220,
		["Area"] = {2,2},
		["XOffset"] = -29,
		["YOffset"] = 29,
		["Pic1"] = 33220,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33221] = {
		["Id"] = 33221,
		["Area"] = {2,2},
		["XOffset"] = -29,
		["YOffset"] = 29,
		["Pic1"] = 33221,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33222] = {
		["Id"] = 33222,
		["Area"] = {2,2},
		["XOffset"] = -10,
		["YOffset"] = 10,
		["Pic1"] = 33222,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33223] = {
		["Id"] = 33223,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 13,
		["Pic1"] = 33223,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33224] = {
		["Id"] = 33224,
		["Area"] = {1,1},
		["XOffset"] = -16,
		["YOffset"] = 18,
		["Pic1"] = 33224,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33225] = {
		["Id"] = 33225,
		["Area"] = {1,1},
		["XOffset"] = -12,
		["YOffset"] = 23,
		["Pic1"] = 33225,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33226] = {
		["Id"] = 33226,
		["Area"] = {1,2},
		["XOffset"] = -17,
		["YOffset"] = 29,
		["Pic1"] = 33226,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33227] = {
		["Id"] = 33227,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 25,
		["Pic1"] = 33227,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33228] = {
		["Id"] = 33228,
		["Area"] = {2,1},
		["XOffset"] = 2,
		["YOffset"] = 22,
		["Pic1"] = 33228,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33229] = {
		["Id"] = 33229,
		["Area"] = {2,2},
		["XOffset"] = -20,
		["YOffset"] = 29,
		["Pic1"] = 33229,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33230] = {
		["Id"] = 33230,
		["Area"] = {2,2},
		["XOffset"] = -35,
		["YOffset"] = 21,
		["Pic1"] = 33230,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33231] = {
		["Id"] = 33231,
		["Area"] = {1,2},
		["XOffset"] = -24,
		["YOffset"] = 28,
		["Pic1"] = 33231,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33232] = {
		["Id"] = 33232,
		["Area"] = {1,2},
		["XOffset"] = -19,
		["YOffset"] = 23,
		["Pic1"] = 33232,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33233] = {
		["Id"] = 33233,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 23,
		["Pic1"] = 33233,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33234] = {
		["Id"] = 33234,
		["Area"] = {2,1},
		["XOffset"] = 22,
		["YOffset"] = 28,
		["Pic1"] = 33234,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33235] = {
		["Id"] = 33235,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 10,
		["Pic1"] = 33235,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33236] = {
		["Id"] = 33236,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33236,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33237] = {
		["Id"] = 33237,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33237,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33238] = {
		["Id"] = 33238,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33238,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33239] = {
		["Id"] = 33239,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33239,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33240] = {
		["Id"] = 33240,
		["Area"] = {3,3},
		["XOffset"] = -20,
		["YOffset"] = 18,
		["Pic1"] = 33240,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33241] = {
		["Id"] = 33241,
		["Area"] = {2,1},
		["XOffset"] = 29,
		["YOffset"] = 31,
		["Pic1"] = 33241,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33242] = {
		["Id"] = 33242,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 18,
		["Pic1"] = 33242,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33243] = {
		["Id"] = 33243,
		["Area"] = {3,3},
		["XOffset"] = 3,
		["YOffset"] = 12,
		["Pic1"] = 33243,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33244] = {
		["Id"] = 33244,
		["Area"] = {1,2},
		["XOffset"] = -33,
		["YOffset"] = 29,
		["Pic1"] = 33244,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33245] = {
		["Id"] = 33245,
		["Area"] = {2,3},
		["XOffset"] = -17,
		["YOffset"] = 19,
		["Pic1"] = 33245,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33246] = {
		["Id"] = 33246,
		["Area"] = {1,1},
		["XOffset"] = -13,
		["YOffset"] = 30,
		["Pic1"] = 33246,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33247] = {
		["Id"] = 33247,
		["Area"] = {1,1},
		["XOffset"] = -4,
		["YOffset"] = 30,
		["Pic1"] = 33247,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33248] = {
		["Id"] = 33248,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 30,
		["Pic1"] = 33248,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33249] = {
		["Id"] = 33249,
		["Area"] = {3,3},
		["XOffset"] = -20,
		["YOffset"] = 18,
		["Pic1"] = 33249,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33250] = {
		["Id"] = 33250,
		["Area"] = {2,1},
		["XOffset"] = 29,
		["YOffset"] = 31,
		["Pic1"] = 33250,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33251] = {
		["Id"] = 33251,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 18,
		["Pic1"] = 33251,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33252] = {
		["Id"] = 33252,
		["Area"] = {3,3},
		["XOffset"] = 3,
		["YOffset"] = 12,
		["Pic1"] = 33252,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33253] = {
		["Id"] = 33253,
		["Area"] = {1,2},
		["XOffset"] = -33,
		["YOffset"] = 29,
		["Pic1"] = 33253,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33254] = {
		["Id"] = 33254,
		["Area"] = {2,3},
		["XOffset"] = -17,
		["YOffset"] = 19,
		["Pic1"] = 33254,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33255] = {
		["Id"] = 33255,
		["Area"] = {1,1},
		["XOffset"] = -13,
		["YOffset"] = 30,
		["Pic1"] = 33255,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33256] = {
		["Id"] = 33256,
		["Area"] = {1,1},
		["XOffset"] = -4,
		["YOffset"] = 30,
		["Pic1"] = 33256,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33257] = {
		["Id"] = 33257,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 30,
		["Pic1"] = 33257,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33258] = {
		["Id"] = 33258,
		["Area"] = {1,1},
		["XOffset"] = 12,
		["YOffset"] = 25,
		["Pic1"] = 33258,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33259] = {
		["Id"] = 33259,
		["Area"] = {1,1},
		["XOffset"] = 12,
		["YOffset"] = 25,
		["Pic1"] = 33259,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33260] = {
		["Id"] = 33260,
		["Area"] = {2,2},
		["XOffset"] = 1,
		["YOffset"] = 30,
		["Pic1"] = 33260,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33261] = {
		["Id"] = 33261,
		["Area"] = {2,2},
		["XOffset"] = 1,
		["YOffset"] = 30,
		["Pic1"] = 33261,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33262] = {
		["Id"] = 33262,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 1,
		["Pic1"] = 33262,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33263] = {
		["Id"] = 33263,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 1,
		["Pic1"] = 33263,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33264] = {
		["Id"] = 33264,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 1,
		["Pic1"] = 33264,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33265] = {
		["Id"] = 33265,
		["Area"] = {1,1},
		["XOffset"] = 12,
		["YOffset"] = 25,
		["Pic1"] = 33265,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33266] = {
		["Id"] = 33266,
		["Area"] = {1,1},
		["XOffset"] = 12,
		["YOffset"] = 25,
		["Pic1"] = 33266,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33267] = {
		["Id"] = 33267,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33267,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33268] = {
		["Id"] = 33268,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33268,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33269] = {
		["Id"] = 33269,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33269,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33301] = {
		["Id"] = 33301,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33301,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33302] = {
		["Id"] = 33302,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 20,
		["Pic1"] = 33302,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33303] = {
		["Id"] = 33303,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 10,
		["Pic1"] = 33303,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33304] = {
		["Id"] = 33304,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 10,
		["Pic1"] = 33304,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33305] = {
		["Id"] = 33305,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 20,
		["Pic1"] = 33305,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33306] = {
		["Id"] = 33306,
		["Area"] = {1,1},
		["XOffset"] = -7,
		["YOffset"] = 18,
		["Pic1"] = 33306,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33307] = {
		["Id"] = 33307,
		["Area"] = {2,2},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33307,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33308] = {
		["Id"] = 33308,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 25,
		["Pic1"] = 33308,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33309] = {
		["Id"] = 33309,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33309,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33310] = {
		["Id"] = 33310,
		["Area"] = {1,1},
		["XOffset"] = 0,
		["YOffset"] = 0,
		["Pic1"] = 33310,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33311] = {
		["Id"] = 33311,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 15,
		["Pic1"] = 33311,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33312] = {
		["Id"] = 33312,
		["Area"] = {1,1},
		["XOffset"] = -23,
		["YOffset"] = 15,
		["Pic1"] = 33312,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33313] = {
		["Id"] = 33313,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 15,
		["Pic1"] = 33313,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33314] = {
		["Id"] = 33314,
		["Area"] = {1,1},
		["XOffset"] = -2,
		["YOffset"] = 12,
		["Pic1"] = 33314,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33315] = {
		["Id"] = 33315,
		["Area"] = {1,1},
		["XOffset"] = -1,
		["YOffset"] = 14,
		["Pic1"] = 33315,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33317] = {
		["Id"] = 33317,
		["Area"] = {1,1},
		["XOffset"] = -10,
		["YOffset"] = 24,
		["Pic1"] = 33317,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33318] = {
		["Id"] = 33318,
		["Area"] = {1,1},
		["XOffset"] = -11,
		["YOffset"] = 23,
		["Pic1"] = 33318,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33319] = {
		["Id"] = 33319,
		["Area"] = {1,1},
		["XOffset"] = 2,
		["YOffset"] = 30,
		["Pic1"] = 33319,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33320] = {
		["Id"] = 33320,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 24,
		["Pic1"] = 33320,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33321] = {
		["Id"] = 33321,
		["Area"] = {1,1},
		["XOffset"] = 23,
		["YOffset"] = 17,
		["Pic1"] = 33321,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
	[33322] = {
		["Id"] = 33322,
		["Area"] = {1,1},
		["XOffset"] = 1,
		["YOffset"] = 24,
		["Pic1"] = 33322,
		["ElementType"] = 33,
		["Genre"] = 11,
	},
},
};

-- functions for xlstable read
local __getcell = function (t, a,b,c) return t[a][b][c] end
function GetCell(sheetx, rowx, colx)
	rst, v = pcall(__getcell, xlstable, sheetx, rowx, colx)
	if rst then return v
	else return nil
	end
end

function GetCellBySheetName(sheet, rowx, colx)
	return GetCell(sheetname[sheet], rowx, colx)
end

__XLS_END = true

local tbConfig = gf_CopyTable(obstacle[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
