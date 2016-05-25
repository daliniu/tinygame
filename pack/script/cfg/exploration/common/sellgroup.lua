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

local sellgroup = {
[1] = {
	[1] = {
		["Key"] = 1,
		["Group"] = 1,
		["ItemID"] = 10101,
		["Pro"] = 200,
		["Num"] = 1,
		["PriceType"] = 0,
		["Price"] = 1000,
	},
	[2] = {
		["Key"] = 2,
		["Group"] = 1,
		["ItemID"] = 10106,
		["Pro"] = 200,
		["Num"] = 2,
		["PriceType"] = 0,
		["Price"] = 1000,
	},
	[3] = {
		["Key"] = 3,
		["Group"] = 1,
		["ItemID"] = 10111,
		["Pro"] = 600,
		["Num"] = 10,
		["PriceType"] = 0,
		["Price"] = 1000,
	},
	[4] = {
		["Key"] = 4,
		["Group"] = 2,
		["ItemID"] = 12003,
		["Pro"] = 600,
		["Num"] = 1,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[5] = {
		["Key"] = 5,
		["Group"] = 2,
		["ItemID"] = 12003,
		["Pro"] = 200,
		["Num"] = 2,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[6] = {
		["Key"] = 6,
		["Group"] = 2,
		["ItemID"] = 12003,
		["Pro"] = 200,
		["Num"] = 10,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[7] = {
		["Key"] = 7,
		["Group"] = 3,
		["ItemID"] = 16001,
		["Pro"] = 200,
		["Num"] = 1,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[8] = {
		["Key"] = 8,
		["Group"] = 3,
		["ItemID"] = 16001,
		["Pro"] = 600,
		["Num"] = 2,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[9] = {
		["Key"] = 9,
		["Group"] = 3,
		["ItemID"] = 16001,
		["Pro"] = 200,
		["Num"] = 10,
		["PriceType"] = 0,
		["Price"] = 100,
	},
	[10] = {
		["Key"] = 10,
		["Group"] = 4,
		["ItemID"] = 16005,
		["Pro"] = 1000,
		["Num"] = 1,
		["PriceType"] = 0,
		["Price"] = 1000,
	},
	[11] = {
		["Key"] = 11,
		["Group"] = 5,
		["ItemID"] = 15101,
		["Pro"] = 1000,
		["Num"] = 3,
		["PriceType"] = 0,
		["Price"] = 2000,
	},
	[12] = {
		["Key"] = 12,
		["Group"] = 6,
		["ItemID"] = 15102,
		["Pro"] = 1000,
		["Num"] = 3,
		["PriceType"] = 0,
		["Price"] = 2000,
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

local tbConfig = gf_CopyTable(sellgroup[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
