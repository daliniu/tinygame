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

local buffexp = {
[1] = {
	[1] = {
		["BuffId"] = 1,
		["Name"] = "减少步耗（百分比）",
		["Desc"] = "每次行走的步数消耗减少30%",
		["Pic"] = 10000,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 30,
		["TimeArg"] = 30,
		["SpeedUp"] = 30,
	},
	[2] = {
		["BuffId"] = 2,
		["Name"] = "减少步耗（数值）",
		["Desc"] = "每次行走的步数消耗减少2",
		["Pic"] = 10000,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 2,
		["EffectArg"] = 2,
		["TimeArg"] = 30,
		["SpeedUp"] = 30,
	},
	[3] = {
		["BuffId"] = 3,
		["Name"] = "增加步耗（百分比）",
		["Desc"] = "每次行走的步数消耗增加30%",
		["Pic"] = 10000,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 3,
		["EffectArg"] = 30,
		["TimeArg"] = 30,
		["SpeedUp"] = 30,
	},
	[4] = {
		["BuffId"] = 4,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 20,
		["SpeedUp"] = 50,
	},
	[5] = {
		["BuffId"] = 5,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 10,
		["SpeedUp"] = 50,
	},
	[6] = {
		["BuffId"] = 6,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 15,
		["SpeedUp"] = 50,
	},
	[7] = {
		["BuffId"] = 7,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 20,
		["SpeedUp"] = 50,
	},
	[8] = {
		["BuffId"] = 8,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 15,
		["SpeedUp"] = 50,
	},
	[9] = {
		["BuffId"] = 9,
		["Name"] = "行走不消耗步数",
		["Desc"] = "每次行走的步数消耗减少100%",
		["Pic"] = 10001,
		["EffectID"] = 0,
		["BuffType"] = 1,
		["Effecttype"] = 1,
		["EffectArg"] = 100,
		["TimeArg"] = 10,
		["SpeedUp"] = 50,
	},
	[10] = {
		["BuffId"] = 10,
		["Name"] = "金钱奖励加成",
		["Desc"] = "每次获得的金钱奖励加成20%",
		["Pic"] = 10002,
		["EffectID"] = 0,
		["BuffType"] = 2,
		["Effecttype"] = 5,
		["EffectArg"] = 20,
		["TimeArg"] = 5,
		["SpeedUp"] = 0,
	},
	[20] = {
		["BuffId"] = 20,
		["Name"] = "降价",
		["Desc"] = "商店道具单价降低30%",
		["Pic"] = 10002,
		["EffectID"] = 0,
		["BuffType"] = 2,
		["Effecttype"] = 6,
		["EffectArg"] = 30,
		["TimeArg"] = 86400,
		["SpeedUp"] = 0,
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

local tbConfig = gf_CopyTable(buffexp[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
