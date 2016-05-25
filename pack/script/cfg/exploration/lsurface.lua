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

local lsurface = {
[1] = {
	[10001] = {
		["Id"] = 10001,
		["Name"] = "1沼泽单格",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3211,
		["Effect1"] = {60070,100,-5,30},
		["Speed"] = 1,
	},
	[10002] = {
		["Id"] = 10002,
		["Name"] = "沼泽2",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3212,
		["Effect1"] = {60070,100,-5,30},
		["Speed"] = 1,
	},
	[10003] = {
		["Id"] = 10003,
		["Name"] = "沼泽3",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3213,
		["Effect1"] = {60072,100,-5,30},
		["Speed"] = 1,
	},
	[10004] = {
		["Id"] = 10004,
		["Name"] = "沼泽4",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3214,
		["Effect1"] = {60071,100,-5,30},
		["Speed"] = 1,
	},
	[10005] = {
		["Id"] = 10005,
		["Name"] = "沼泽5",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3215,
		["Effect1"] = {60070,100,-5,30},
		["Speed"] = 1,
	},
	[10006] = {
		["Id"] = 10006,
		["Name"] = "沼泽6",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3216,
		["Effect1"] = {60071,100,-5,30},
		["Speed"] = 1,
	},
	[10007] = {
		["Id"] = 10007,
		["Name"] = "沼泽7",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3217,
		["Effect1"] = {60070,100,-5,30},
		["Speed"] = 1,
	},
	[10008] = {
		["Id"] = 10008,
		["Name"] = "沼泽8",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3218,
		["Effect1"] = {60071,100,-5,30},
		["Speed"] = 1,
	},
	[10009] = {
		["Id"] = 10009,
		["Name"] = "沼泽9",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3219,
		["Effect1"] = {60072,100,-5,30},
		["Speed"] = 1,
	},
	[10010] = {
		["Id"] = 10010,
		["Name"] = "空沼泽",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Speed"] = 1,
	},
	[10011] = {
		["Id"] = 10011,
		["Name"] = "2沼泽单格",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3221,
		["Effect1"] = {60073,100,-5,30},
		["Speed"] = 1,
	},
	[10012] = {
		["Id"] = 10012,
		["Name"] = "沼泽2",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,2},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3222,
		["Effect1"] = {60074,100,5,50},
		["Speed"] = 1,
	},
	[10013] = {
		["Id"] = 10013,
		["Name"] = "沼泽3",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {2,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3223,
		["Effect1"] = {60075,100,-15,45},
		["Speed"] = 1,
	},
	[10014] = {
		["Id"] = 10014,
		["Name"] = "沼泽4",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Pic"] = 3224,
		["Effect1"] = {60073,100,-5,20},
		["Speed"] = 1,
	},
	[10020] = {
		["Id"] = 10020,
		["Name"] = "空沼泽",
		["ElementType"] = 30,
		["Genre"] = 10,
		["LandType"] = 1,
		["Area"] = {1,1},
		["Direction"] = 0,
		["APCostTimes"] = 3,
		["Speed"] = 1,
	},
	[20000] = {
		["Id"] = 20000,
		["Name"] = "大风左",
		["ElementType"] = 31,
		["Genre"] = 10,
		["LandType"] = 2,
		["Area"] = {1,1},
		["Direction"] = 1,
		["Pic"] = 0,
		["Speed"] = 0.40000000,
	},
	[20001] = {
		["Id"] = 20001,
		["Name"] = "大风右",
		["ElementType"] = 31,
		["Genre"] = 10,
		["LandType"] = 2,
		["Area"] = {1,1},
		["Direction"] = 2,
		["Pic"] = 0,
		["Speed"] = 0.40000000,
	},
	[20002] = {
		["Id"] = 20002,
		["Name"] = "大风上",
		["ElementType"] = 31,
		["Genre"] = 10,
		["LandType"] = 2,
		["Area"] = {1,1},
		["Direction"] = 3,
		["Pic"] = 0,
		["Speed"] = 0.40000000,
	},
	[20003] = {
		["Id"] = 20003,
		["Name"] = "大风下",
		["ElementType"] = 31,
		["Genre"] = 10,
		["LandType"] = 2,
		["Area"] = {1,1},
		["Direction"] = 4,
		["Pic"] = 0,
		["Speed"] = 0.40000000,
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

local tbConfig = gf_CopyTable(lsurface[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
