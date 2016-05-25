-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["property"] = 1,
};

sheetindex = {
[1] = "property",
};

local property = {
[1] = {
	[8001] = {
		["ID"] = 8001,
		["desc"] = "攻击力",
	},
	[8002] = {
		["ID"] = 8002,
		["desc"] = "防御力",
	},
	[8003] = {
		["ID"] = 8003,
		["desc"] = "暴击率",
	},
	[8004] = {
		["ID"] = 8004,
		["desc"] = "闪避率",
	},
	[8005] = {
		["ID"] = 8005,
		["desc"] = "生命上限",
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

local tbConfig = gf_CopyTable(property[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
