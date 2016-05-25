-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["growing"] = 1,
};

sheetindex = {
[1] = "growing",
};

local growing = {
[1] = {
	[10003] = {
		["id"] = 10003,
		["levelgrowing"] = {50,50,100},
		["scrapamount"] = {20,40,60,80,150},
		["stargrowing"] = {10,10,20},
		["qualityamount"] = {10,20,40,80,150},
		["qualityskill"] = {30002,0,0,0,0},
	},
	[10013] = {
		["id"] = 10013,
		["levelgrowing"] = {50,50,100},
		["scrapamount"] = {20,40,60,80,150},
		["stargrowing"] = {10,10,20},
		["qualityamount"] = {10,20,40,80,150},
		["qualityskill"] = {30002,0,0,0,0},
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

local tbConfig = gf_CopyTable(growing[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
