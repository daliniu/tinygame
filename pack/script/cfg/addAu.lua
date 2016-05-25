-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["addAu"] = 1,
};

sheetindex = {
[1] = "addAu",
};

local addAu = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["addId"] = 1001,
		["number"] = 7,
		["tepy1"] = {{1,2000}},
		["tepy2"] = {{2,2000}},
		["tepy3"] = {{6,6000}},
		["tepy4"] = {{0,6000}},
		["tepy5"] = {{5,6000}},
		["tepy6"] = {{900,500}},
		["tepy7"] = {{901,500}},
	},
	[2] = {
		["Bid"] = 2,
		["addId"] = 1002,
		["number"] = 3,
		["tepy1"] = {{1,2000}},
		["tepy2"] = {{2,2000}},
		["tepy3"] = {{6,6000}},
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

local tbConfig = gf_CopyTable(addAu[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
