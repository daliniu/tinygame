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

local initialization = {
[1] = {
	[1] = {
		["Id"] = 1,
		["Name"] = "金币",
		["Value"] = 0,
	},
	[2] = {
		["Id"] = 2,
		["Name"] = "钻石",
		["Value"] = 0,
	},
	[3] = {
		["Id"] = 3,
		["Name"] = "步数",
		["Value"] = 180,
	},
	[4] = {
		["Id"] = 4,
		["Name"] = "道具",
		["Value"] = {{12007,1},{12001,100},{19205,1},{99999,1}},
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

local tbConfig = gf_CopyTable(initialization[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
