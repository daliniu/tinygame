-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["eqStar"] = 1,
};

sheetindex = {
[1] = "eqStar",
};

local eqStar = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["star"] = 1,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 50,
		["cost"] = 10000,
		["splitReturn"] = {{12001,1},{"gold",10000}},
		["item1"] = 50,
		["item2"] = 100,
		["item3"] = 100,
		["item4"] = 100,
		["item5"] = 100,
	},
	[2] = {
		["Bid"] = 2,
		["star"] = 2,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 20,
		["cost"] = 30000,
		["splitReturn"] = {{12002,2},{"gold",30000}},
		["item1"] = 30,
		["item2"] = 60,
		["item3"] = 80,
		["item4"] = 100,
		["item5"] = 100,
	},
	[3] = {
		["Bid"] = 3,
		["star"] = 3,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 5,
		["cost"] = 100000,
		["splitReturn"] = {{12002,2},{"gold",30001}},
		["item1"] = 10,
		["item2"] = 30,
		["item3"] = 60,
		["item4"] = 80,
		["item5"] = 100,
	},
	[4] = {
		["Bid"] = 4,
		["star"] = 4,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 250000,
		["splitReturn"] = {{12002,2},{"gold",30002}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 30,
		["item4"] = 60,
		["item5"] = 80,
	},
	[5] = {
		["Bid"] = 5,
		["star"] = 5,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 500000,
		["splitReturn"] = {{12002,2},{"gold",30003}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
	},
	[6] = {
		["Bid"] = 6,
		["star"] = 6,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 750000,
		["splitReturn"] = {{12001,1},{"gold",10000}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
	},
	[7] = {
		["Bid"] = 7,
		["star"] = 7,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 1000000,
		["splitReturn"] = {{12002,2},{"gold",30000}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
	},
	[8] = {
		["Bid"] = 8,
		["star"] = 8,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 1250000,
		["splitReturn"] = {{12002,2},{"gold",30001}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
	},
	[9] = {
		["Bid"] = 9,
		["star"] = 9,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 1500000,
		["splitReturn"] = {{12002,2},{"gold",30002}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
	},
	[10] = {
		["Bid"] = 10,
		["star"] = 10,
		["eqPosition"] = 1,
		["increase"] = 2,
		["success"] = 0,
		["cost"] = 1750000,
		["splitReturn"] = {{12002,2},{"gold",30003}},
		["item1"] = 10,
		["item2"] = 10,
		["item3"] = 10,
		["item4"] = 30,
		["item5"] = 60,
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

local tbConfig = gf_CopyTable(eqStar[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;