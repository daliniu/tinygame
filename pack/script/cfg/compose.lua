-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["compose"] = 1,
};

sheetindex = {
[1] = "compose",
};

local compose = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["itemId"] = 15002,
		["demandItemId"] = {{15001,4}},
	},
	[2] = {
		["Bid"] = 2,
		["itemId"] = 16010,
		["demandItemId"] = {{16001,4}},
	},
	[3] = {
		["Bid"] = 3,
		["itemId"] = 19001,
		["demandItemId"] = {{15201,4}},
	},
	[4] = {
		["Bid"] = 4,
		["itemId"] = 19002,
		["demandItemId"] = {{15201,15}},
	},
	[5] = {
		["Bid"] = 5,
		["itemId"] = 19003,
		["demandItemId"] = {{15201,15},{15202,15}},
	},
	[6] = {
		["Bid"] = 6,
		["itemId"] = 19004,
		["demandItemId"] = {{15201,15},{15202,15},{15204,15}},
	},
	[7] = {
		["Bid"] = 7,
		["itemId"] = 19005,
		["demandItemId"] = {{15201,15},{15202,15},{15204,15},{15206,1}},
	},
	[8] = {
		["Bid"] = 8,
		["itemId"] = 19006,
		["demandItemId"] = {{15202,4}},
	},
	[9] = {
		["Bid"] = 9,
		["itemId"] = 19007,
		["demandItemId"] = {{15202,15}},
	},
	[10] = {
		["Bid"] = 10,
		["itemId"] = 19008,
		["demandItemId"] = {{15202,15},{15203,15}},
	},
	[11] = {
		["Bid"] = 11,
		["itemId"] = 19009,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15}},
	},
	[12] = {
		["Bid"] = 12,
		["itemId"] = 19010,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15},{15206,1}},
	},
	[13] = {
		["Bid"] = 13,
		["itemId"] = 19011,
		["demandItemId"] = {{15201,4}},
	},
	[14] = {
		["Bid"] = 14,
		["itemId"] = 19012,
		["demandItemId"] = {{15201,15}},
	},
	[15] = {
		["Bid"] = 15,
		["itemId"] = 19013,
		["demandItemId"] = {{15201,15},{15201,15}},
	},
	[16] = {
		["Bid"] = 16,
		["itemId"] = 19014,
		["demandItemId"] = {{15201,15},{15201,15},{15204,15}},
	},
	[17] = {
		["Bid"] = 17,
		["itemId"] = 19015,
		["demandItemId"] = {{15201,15},{15201,15},{15204,15},{15206,1}},
	},
	[18] = {
		["Bid"] = 18,
		["itemId"] = 19016,
		["demandItemId"] = {{15202,4}},
	},
	[19] = {
		["Bid"] = 19,
		["itemId"] = 19017,
		["demandItemId"] = {{15202,15}},
	},
	[20] = {
		["Bid"] = 20,
		["itemId"] = 19018,
		["demandItemId"] = {{15202,15},{15203,15}},
	},
	[21] = {
		["Bid"] = 21,
		["itemId"] = 19019,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15}},
	},
	[22] = {
		["Bid"] = 22,
		["itemId"] = 19020,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15},{15206,1}},
	},
	[23] = {
		["Bid"] = 23,
		["itemId"] = 19021,
		["demandItemId"] = {{15203,4}},
	},
	[24] = {
		["Bid"] = 24,
		["itemId"] = 19022,
		["demandItemId"] = {{15203,15}},
	},
	[25] = {
		["Bid"] = 25,
		["itemId"] = 19023,
		["demandItemId"] = {{15203,15},{15201,15}},
	},
	[26] = {
		["Bid"] = 26,
		["itemId"] = 19024,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15}},
	},
	[27] = {
		["Bid"] = 27,
		["itemId"] = 19025,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15},{15206,1}},
	},
	[28] = {
		["Bid"] = 28,
		["itemId"] = 19026,
		["demandItemId"] = {{15202,4}},
	},
	[29] = {
		["Bid"] = 29,
		["itemId"] = 19027,
		["demandItemId"] = {{15202,15}},
	},
	[30] = {
		["Bid"] = 30,
		["itemId"] = 19028,
		["demandItemId"] = {{15202,15},{15203,15}},
	},
	[31] = {
		["Bid"] = 31,
		["itemId"] = 19029,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15}},
	},
	[32] = {
		["Bid"] = 32,
		["itemId"] = 19030,
		["demandItemId"] = {{15202,15},{15203,15},{15204,15},{15206,1}},
	},
	[33] = {
		["Bid"] = 33,
		["itemId"] = 19031,
		["demandItemId"] = {{15203,4}},
	},
	[34] = {
		["Bid"] = 34,
		["itemId"] = 19032,
		["demandItemId"] = {{15203,15}},
	},
	[35] = {
		["Bid"] = 35,
		["itemId"] = 19033,
		["demandItemId"] = {{15203,15},{15201,15}},
	},
	[36] = {
		["Bid"] = 36,
		["itemId"] = 19034,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15}},
	},
	[37] = {
		["Bid"] = 37,
		["itemId"] = 19035,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15},{15206,1}},
	},
	[38] = {
		["Bid"] = 38,
		["itemId"] = 19036,
		["demandItemId"] = {{15203,4}},
	},
	[39] = {
		["Bid"] = 39,
		["itemId"] = 19037,
		["demandItemId"] = {{15203,15}},
	},
	[40] = {
		["Bid"] = 40,
		["itemId"] = 19038,
		["demandItemId"] = {{15203,15},{15201,15}},
	},
	[41] = {
		["Bid"] = 41,
		["itemId"] = 19039,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15}},
	},
	[42] = {
		["Bid"] = 42,
		["itemId"] = 19040,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15},{15206,1}},
	},
	[43] = {
		["Bid"] = 43,
		["itemId"] = 19041,
		["demandItemId"] = {{15202,4}},
	},
	[44] = {
		["Bid"] = 44,
		["itemId"] = 19042,
		["demandItemId"] = {{15202,15}},
	},
	[45] = {
		["Bid"] = 45,
		["itemId"] = 19043,
		["demandItemId"] = {{15202,15},{15202,15}},
	},
	[46] = {
		["Bid"] = 46,
		["itemId"] = 19044,
		["demandItemId"] = {{15202,15},{15202,15},{15204,15}},
	},
	[47] = {
		["Bid"] = 47,
		["itemId"] = 19045,
		["demandItemId"] = {{15202,15},{15202,15},{15204,15},{15206,1}},
	},
	[48] = {
		["Bid"] = 48,
		["itemId"] = 19046,
		["demandItemId"] = {{15201,4}},
	},
	[49] = {
		["Bid"] = 49,
		["itemId"] = 19047,
		["demandItemId"] = {{15201,15}},
	},
	[50] = {
		["Bid"] = 50,
		["itemId"] = 19048,
		["demandItemId"] = {{15201,15},{15202,15}},
	},
	[51] = {
		["Bid"] = 51,
		["itemId"] = 19049,
		["demandItemId"] = {{15201,15},{15202,15},{15204,15}},
	},
	[52] = {
		["Bid"] = 52,
		["itemId"] = 19050,
		["demandItemId"] = {{15201,15},{15202,15},{15204,15},{15206,1}},
	},
	[53] = {
		["Bid"] = 53,
		["itemId"] = 19051,
		["demandItemId"] = {{15202,4}},
	},
	[54] = {
		["Bid"] = 54,
		["itemId"] = 19052,
		["demandItemId"] = {{15202,15}},
	},
	[55] = {
		["Bid"] = 55,
		["itemId"] = 19053,
		["demandItemId"] = {{15202,15},{15201,15}},
	},
	[56] = {
		["Bid"] = 56,
		["itemId"] = 19054,
		["demandItemId"] = {{15202,15},{15201,15},{15204,15}},
	},
	[57] = {
		["Bid"] = 57,
		["itemId"] = 19055,
		["demandItemId"] = {{15202,15},{15201,15},{15204,15},{15206,1}},
	},
	[58] = {
		["Bid"] = 58,
		["itemId"] = 19056,
		["demandItemId"] = {{15203,4}},
	},
	[59] = {
		["Bid"] = 59,
		["itemId"] = 19057,
		["demandItemId"] = {{15203,15}},
	},
	[60] = {
		["Bid"] = 60,
		["itemId"] = 19058,
		["demandItemId"] = {{15203,15},{15201,15}},
	},
	[61] = {
		["Bid"] = 61,
		["itemId"] = 19059,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15}},
	},
	[62] = {
		["Bid"] = 62,
		["itemId"] = 19060,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15},{15206,1}},
	},
	[63] = {
		["Bid"] = 63,
		["itemId"] = 19061,
		["demandItemId"] = {{15202,4}},
	},
	[64] = {
		["Bid"] = 64,
		["itemId"] = 19062,
		["demandItemId"] = {{15202,15}},
	},
	[65] = {
		["Bid"] = 65,
		["itemId"] = 19063,
		["demandItemId"] = {{15202,15},{15201,15}},
	},
	[66] = {
		["Bid"] = 66,
		["itemId"] = 19064,
		["demandItemId"] = {{15202,15},{15201,15},{15204,15}},
	},
	[67] = {
		["Bid"] = 67,
		["itemId"] = 19065,
		["demandItemId"] = {{15202,15},{15201,15},{15204,15},{15206,1}},
	},
	[68] = {
		["Bid"] = 68,
		["itemId"] = 19066,
		["demandItemId"] = {{15203,4}},
	},
	[69] = {
		["Bid"] = 69,
		["itemId"] = 19067,
		["demandItemId"] = {{15203,15}},
	},
	[70] = {
		["Bid"] = 70,
		["itemId"] = 19068,
		["demandItemId"] = {{15203,15},{15201,15}},
	},
	[71] = {
		["Bid"] = 71,
		["itemId"] = 19069,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15}},
	},
	[72] = {
		["Bid"] = 72,
		["itemId"] = 19070,
		["demandItemId"] = {{15203,15},{15201,15},{15204,15},{15206,1}},
	},
	[73] = {
		["Bid"] = 73,
		["itemId"] = 10101,
		["demandItemId"] = {{16001,1},{15102,2}},
	},
	[74] = {
		["Bid"] = 74,
		["itemId"] = 10102,
		["demandItemId"] = {{16001,1},{15102,5}},
	},
	[75] = {
		["Bid"] = 75,
		["itemId"] = 10106,
		["demandItemId"] = {{16002,1},{15102,2}},
	},
	[76] = {
		["Bid"] = 76,
		["itemId"] = 10107,
		["demandItemId"] = {{16002,1},{15102,5}},
	},
	[77] = {
		["Bid"] = 77,
		["itemId"] = 10111,
		["demandItemId"] = {{16003,1},{15102,2}},
	},
	[78] = {
		["Bid"] = 78,
		["itemId"] = 10112,
		["demandItemId"] = {{16003,1},{15102,5}},
	},
	[79] = {
		["Bid"] = 79,
		["itemId"] = 10116,
		["demandItemId"] = {{16004,1},{15102,2}},
	},
	[80] = {
		["Bid"] = 80,
		["itemId"] = 10117,
		["demandItemId"] = {{16004,1},{15102,5}},
	},
	[81] = {
		["Bid"] = 81,
		["itemId"] = 10121,
		["demandItemId"] = {{16005,1},{15102,2}},
	},
	[82] = {
		["Bid"] = 82,
		["itemId"] = 10122,
		["demandItemId"] = {{16005,1},{15102,5}},
	},
	[83] = {
		["Bid"] = 83,
		["itemId"] = 10126,
		["demandItemId"] = {{16006,1},{15102,2}},
	},
	[84] = {
		["Bid"] = 84,
		["itemId"] = 110101,
		["demandItemId"] = {{16001,1},{15101,2}},
	},
	[85] = {
		["Bid"] = 85,
		["itemId"] = 110102,
		["demandItemId"] = {{16002,1},{15101,2}},
	},
	[86] = {
		["Bid"] = 86,
		["itemId"] = 110103,
		["demandItemId"] = {{16003,1},{15101,2}},
	},
	[87] = {
		["Bid"] = 87,
		["itemId"] = 110104,
		["demandItemId"] = {{16004,1},{15101,2}},
	},
	[88] = {
		["Bid"] = 88,
		["itemId"] = 110105,
		["demandItemId"] = {{16005,1},{15101,2}},
	},
	[89] = {
		["Bid"] = 89,
		["itemId"] = 110106,
		["demandItemId"] = {{16006,1},{15101,2}},
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

local tbConfig = gf_CopyTable(compose[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;