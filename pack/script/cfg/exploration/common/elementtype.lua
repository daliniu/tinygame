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

local elementtype = {
[1] = {
	[1] = {
		["Type"] = 1,
		["SheetName"] = "chest",
		["ElementName"] = "资源宝箱",
		["State"] = {1,2},
	},
	[2] = {
		["Type"] = 2,
		["SheetName"] = "chestchoo",
		["ElementName"] = "抉择型资源",
		["State"] = {1,2},
	},
	[3] = {
		["Type"] = 3,
		["SheetName"] = "guaji",
		["ElementName"] = "常态挂机点",
		["State"] = {1,2},
	},
	[4] = {
		["Type"] = 4,
		["SheetName"] = "guaji",
		["ElementName"] = "限时挂机点",
		["State"] = {1,2},
	},
	[5] = {
		["Type"] = 5,
		["SheetName"] = "guaji",
		["ElementName"] = "限时挂机点（立即）",
		["State"] = {1,2},
	},
	[6] = {
		["Type"] = 6,
		["SheetName"] = "monsterchal",
		["ElementName"] = "挑战怪",
		["State"] = {1,2},
	},
	[7] = {
		["Type"] = 7,
		["SheetName"] = "monsterchoo",
		["ElementName"] = "抉择型挑战",
		["State"] = {1,2},
	},
	[8] = {
		["Type"] = 8,
		["SheetName"] = "mission",
		["ElementName"] = "连续挑战类",
		["State"] = {1,2},
	},
	[9] = {
		["Type"] = 9,
		["SheetName"] = "unknow",
		["ElementName"] = "未知建筑",
		["State"] = {1,2,3},
	},
	[10] = {
		["Type"] = 10,
		["SheetName"] = "exit",
		["ElementName"] = "出口建筑",
		["State"] = {1,2},
	},
	[11] = {
		["Type"] = 11,
		["SheetName"] = "supply",
		["ElementName"] = "补给站",
		["State"] = {1},
	},
	[12] = {
		["Type"] = 12,
		["SheetName"] = "buffstation",
		["ElementName"] = "buff点",
		["State"] = {1,2},
	},
	[13] = {
		["Type"] = 13,
		["SheetName"] = "transport",
		["ElementName"] = "交通站",
		["State"] = {1,2},
	},
	[14] = {
		["Type"] = 14,
		["SheetName"] = "intelligence",
		["ElementName"] = "情报站",
		["State"] = {1,2},
	},
	[15] = {
		["Type"] = 15,
		["SheetName"] = "shop",
		["ElementName"] = "商店",
		["State"] = {1,2},
	},
	[16] = {
		["Type"] = 16,
		["SheetName"] = "watchtower",
		["ElementName"] = "瞭望塔",
		["State"] = {1,2},
	},
	[17] = {
		["Type"] = 17,
		["SheetName"] = "portal",
		["ElementName"] = "传送门",
	},
	[18] = {
		["Type"] = 18,
		["SheetName"] = "postbox",
		["ElementName"] = "邮筒",
		["State"] = {1,2},
	},
	[30] = {
		["Type"] = 30,
		["SheetName"] = "lsurface",
		["ElementName"] = "沼泽",
	},
	[31] = {
		["Type"] = 31,
		["SheetName"] = "lsurface",
		["ElementName"] = "大风",
	},
	[32] = {
		["Type"] = 32,
		["SheetName"] = "lobstacle",
		["ElementName"] = "可除障碍",
		["State"] = {1,2},
	},
	[33] = {
		["Type"] = 33,
		["ElementName"] = "绝对障碍",
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

local tbConfig = gf_CopyTable(elementtype[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
