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

local sign = {
[1] = {
	[1] = {
		["Id"] = 1,
		["Name"] = "魔法钥匙",
		["Desc"] = "附近宝箱可以找到。",
		["Pic"] = "res/ui/picture/item/item_specialitem_01.png",
	},
	[2] = {
		["Id"] = 2,
		["Name"] = "铜钥匙",
		["Desc"] = "在瀑布可以找到。",
		["Pic"] = "res/ui/picture/item/item_specialitem_01.png",
	},
	[3] = {
		["Id"] = 3,
		["Name"] = "黄钥匙",
		["Desc"] = "听村里的老人说神秘的石屋曾经出现过。",
		["Pic"] = "res/ui/picture/item/item_specialitem_01.png",
	},
	[4] = {
		["Id"] = 4,
		["Name"] = "《皮克斯》",
		["Desc"] = "在瀑布可以找到。",
		["Pic"] = "res/ui/picture/item/item_specialitem_03.png",
	},
	[5] = {
		["Id"] = 5,
		["Name"] = "少女的黄金水",
		["Desc"] = "听村里的老人说神秘的石屋曾经出现过。",
		["Pic"] = "res/ui/temp/temp_blood_01.png",
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

local tbConfig = gf_CopyTable(sign[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
