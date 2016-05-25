-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["status"] = 1,
};

sheetindex = {
[1] = "status",
};

local status = {
[1] = {
	[60001] = {
		["id"] = 60001,
		["name"] = "大气护盾",
		["icon"] = 0,
		["desc"] = "抵挡少量伤害",
		["staturesultsid"] = 6001,
		["statustype"] = 1,
		["overlapping"] = 1,
		["replace"] = 1,
		["duration"] = 0,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,0},
		["triggercondition"] = 0,
		["dispel"] = 1,
	},
	[60002] = {
		["id"] = 60002,
		["name"] = "增幅",
		["icon"] = 0,
		["desc"] = "触发：增加攻击力",
		["staturesultsid"] = 0,
		["statustype"] = 1,
		["overlapping"] = 1,
		["replace"] = 0,
		["duration"] = 0,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,60006},
		["triggercondition"] = 9008,
		["dispel"] = 1,
	},
	[60003] = {
		["id"] = 60003,
		["name"] = "飞行",
		["icon"] = 0,
		["desc"] = "直接攻击对方英雄",
		["staturesultsid"] = 6003,
		["statustype"] = 1,
		["overlapping"] = 1,
		["replace"] = 0,
		["duration"] = 0,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,0},
		["triggercondition"] = 0,
		["dispel"] = 0,
	},
	[60004] = {
		["id"] = 60004,
		["name"] = "力竭",
		["icon"] = 0,
		["desc"] = "攻击力降低",
		["staturesultsid"] = 6004,
		["statustype"] = 2,
		["overlapping"] = 1,
		["replace"] = 1,
		["duration"] = 2,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,0},
		["triggercondition"] = 0,
		["dispel"] = 1,
	},
	[60005] = {
		["id"] = 60005,
		["name"] = "晕眩",
		["icon"] = 0,
		["desc"] = "无法行动",
		["staturesultsid"] = 6005,
		["statustype"] = 2,
		["overlapping"] = 1,
		["replace"] = 2,
		["duration"] = 1,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,0},
		["triggercondition"] = 0,
		["dispel"] = 1,
	},
	[60006] = {
		["id"] = 60006,
		["name"] = "士气",
		["icon"] = 0,
		["desc"] = "攻击力增加",
		["staturesultsid"] = 6002,
		["statustype"] = 1,
		["overlapping"] = 5,
		["replace"] = 0,
		["duration"] = 3,
		["effectivetimes"] = 0,
		["triggerresultid"] = {0,0},
		["triggercondition"] = 0,
		["dispel"] = 1,
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

local tbConfig = gf_CopyTable(status[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
