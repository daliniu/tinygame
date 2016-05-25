-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["backOpen"] = 1,
};

sheetindex = {
[1] = "backOpen",
};

local unlock = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["itemId"] = 15001,
		["itemNo"] = 10,
		["price"] = 10,
	},
	[2] = {
		["Bid"] = 2,
		["itemId"] = 15001,
		["itemNo"] = 20,
		["price"] = 10,
	},
	[3] = {
		["Bid"] = 3,
		["itemId"] = 15002,
		["itemNo"] = 1,
		["price"] = 300,
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

local tbConfig = gf_CopyTable(unlock[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
