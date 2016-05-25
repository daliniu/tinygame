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

local powermatch = {
[1] = {
	[1] = {
		["ID"] = 1,
		["MyPower"] = {100,500},
	},
	[2] = {
		["ID"] = 2,
		["MyPower"] = {501,600},
		["Power1"] = {1},
		["Reward1"] = 1,
		["Power2"] = {1,2},
		["Reward2"] = 3,
		["Power3"] = {2,3},
		["Reward3"] = 5,
	},
	[3] = {
		["ID"] = 3,
		["MyPower"] = {601,700},
		["Power1"] = {1,2},
		["Reward1"] = 1,
		["Power2"] = {1,2,3},
		["Reward2"] = 3,
		["Power3"] = {3,4},
		["Reward3"] = 5,
	},
	[4] = {
		["ID"] = 4,
		["MyPower"] = {701,800},
		["Power1"] = {2,3},
		["Reward1"] = 1,
		["Power2"] = {2,3,4},
		["Reward2"] = 3,
		["Power3"] = {4,5},
		["Reward3"] = 5,
	},
	[5] = {
		["ID"] = 5,
		["MyPower"] = {801,900},
		["Power1"] = {2,3,4},
		["Reward1"] = 1,
		["Power2"] = {3,4},
		["Reward2"] = 3,
		["Power3"] = {5,6},
		["Reward3"] = 5,
	},
	[6] = {
		["ID"] = 6,
		["MyPower"] = {901,1000},
		["Power1"] = {4,5},
		["Reward1"] = 1,
		["Power2"] = {5,6},
		["Reward2"] = 3,
		["Power3"] = {6,7},
		["Reward3"] = 5,
	},
	[7] = {
		["ID"] = 7,
		["MyPower"] = {1001,1100},
		["Power1"] = {5,6},
		["Reward1"] = 1,
		["Power2"] = {6,7},
		["Reward2"] = 3,
		["Power3"] = {7,8},
		["Reward3"] = 5,
	},
	[8] = {
		["ID"] = 8,
		["MyPower"] = {1101,1200},
		["Power1"] = {6,7},
		["Reward1"] = 1,
		["Power2"] = {7,8},
		["Reward2"] = 3,
		["Power3"] = {8,9},
		["Reward3"] = 5,
	},
	[9] = {
		["ID"] = 9,
		["MyPower"] = {1201,1300},
		["Power1"] = {7,8},
		["Reward1"] = 1,
		["Power2"] = {8,9},
		["Reward2"] = 3,
		["Power3"] = {9,10},
		["Reward3"] = 5,
	},
	[10] = {
		["ID"] = 10,
		["MyPower"] = {1301,1400},
		["Power1"] = {8,9},
		["Reward1"] = 1,
		["Power2"] = {9,10},
		["Reward2"] = 3,
		["Power3"] = {10,11},
		["Reward3"] = 5,
	},
	[11] = {
		["ID"] = 11,
		["MyPower"] = {1401,1500},
		["Power1"] = {9,10},
		["Reward1"] = 1,
		["Power2"] = {10,11},
		["Reward2"] = 3,
		["Power3"] = {11,12},
		["Reward3"] = 5,
	},
	[12] = {
		["ID"] = 12,
		["MyPower"] = {1501,1600},
		["Power1"] = {10,11},
		["Reward1"] = 1,
		["Power2"] = {11,12},
		["Reward2"] = 3,
		["Power3"] = {12,13},
		["Reward3"] = 5,
	},
	[13] = {
		["ID"] = 13,
		["MyPower"] = {1601,1700},
		["Power1"] = {11,12},
		["Reward1"] = 1,
		["Power2"] = {12,13},
		["Reward2"] = 3,
		["Power3"] = {13,14},
		["Reward3"] = 5,
	},
	[14] = {
		["ID"] = 14,
		["MyPower"] = {1701,1800},
		["Power1"] = {12,13},
		["Reward1"] = 1,
		["Power2"] = {13,14},
		["Reward2"] = 3,
		["Power3"] = {14,15},
		["Reward3"] = 5,
	},
	[15] = {
		["ID"] = 15,
		["MyPower"] = {1801,1900},
		["Power1"] = {13,14},
		["Reward1"] = 1,
		["Power2"] = {14,15},
		["Reward2"] = 3,
		["Power3"] = {15,16},
		["Reward3"] = 5,
	},
	[16] = {
		["ID"] = 16,
		["MyPower"] = {1901,2000},
		["Power1"] = {14,15},
		["Reward1"] = 1,
		["Power2"] = {15,16},
		["Reward2"] = 3,
		["Power3"] = {16,17},
		["Reward3"] = 5,
	},
	[17] = {
		["ID"] = 17,
		["MyPower"] = {2001,2100},
		["Power1"] = {15,16},
		["Reward1"] = 1,
		["Power2"] = {16,17},
		["Reward2"] = 3,
		["Power3"] = {17,18},
		["Reward3"] = 5,
	},
	[18] = {
		["ID"] = 18,
		["MyPower"] = {2101,2200},
		["Power1"] = {16,17},
		["Reward1"] = 1,
		["Power2"] = {17,18},
		["Reward2"] = 3,
		["Power3"] = {18,19},
		["Reward3"] = 5,
	},
	[19] = {
		["ID"] = 19,
		["MyPower"] = {2201,2300},
		["Power1"] = {17,18},
		["Reward1"] = 1,
		["Power2"] = {18,19},
		["Reward2"] = 3,
		["Power3"] = {19,20},
		["Reward3"] = 5,
	},
	[20] = {
		["ID"] = 20,
		["MyPower"] = {2301,99999},
		["Power1"] = {18,19},
		["Reward1"] = 1,
		["Power2"] = {19,20},
		["Reward2"] = 3,
		["Power3"] = {20,21},
		["Reward3"] = 5,
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

local tbConfig = gf_CopyTable(powermatch[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
