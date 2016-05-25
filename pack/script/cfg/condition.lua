-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["condition"] = 1,
};

sheetindex = {
[1] = "condition",
};

local condition = {
[1] = {
	[9001] = {
		["id"] = 9001,
		["desc"] = "技能命中",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9002] = {
		["id"] = 9002,
		["desc"] = "死亡",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9003] = {
		["id"] = 9003,
		["desc"] = "回合开始",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9004] = {
		["id"] = 9004,
		["desc"] = "回合结束",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9005] = {
		["id"] = 9005,
		["desc"] = "受伤",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9006] = {
		["id"] = 9006,
		["desc"] = "造成伤害",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9007] = {
		["id"] = 9007,
		["desc"] = "进场",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9008] = {
		["id"] = 9008,
		["desc"] = "角色释放<参数1>触发",
		["arg1"] = 1,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9009] = {
		["id"] = 9009,
		["desc"] = "角色释放<参数1>触发",
		["arg1"] = 2,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9010] = {
		["id"] = 9010,
		["desc"] = "角色释放<参数1>触发",
		["arg1"] = 3,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9011] = {
		["id"] = 9011,
		["desc"] = "角色释放<参数1>触发",
		["arg1"] = 4,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
	},
	[9012] = {
		["id"] = 9012,
		["desc"] = "信念",
		["arg1"] = 0,
		["arg2"] = 0,
		["arg3"] = 0,
		["arg4"] = 0,
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

local tbConfig = gf_CopyTable(condition[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
