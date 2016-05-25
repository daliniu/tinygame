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

local RobotHero = {
[1] = {
	[1] = {
		["ID"] = 1,
		["HeroId"] = 10007,
		["Level"] = 10,
		["Star"] = 1,
		["Quality"] = 2,
		["SkillLv"] = {5,5,5,5,5,5},
	},
	[2] = {
		["ID"] = 2,
		["HeroId"] = 10008,
		["Level"] = 10,
		["Star"] = 1,
		["Quality"] = 2,
		["SkillLv"] = {5,5,5,5,5,5},
	},
	[3] = {
		["ID"] = 3,
		["HeroId"] = 10009,
		["Level"] = 10,
		["Star"] = 1,
		["Quality"] = 2,
		["SkillLv"] = {5,5,5,5,5,5},
	},
	[4] = {
		["ID"] = 4,
		["HeroId"] = 10010,
		["Level"] = 25,
		["Star"] = 2,
		["Quality"] = 3,
		["SkillLv"] = {5,5,5,5,5,5},
	},
	[5] = {
		["ID"] = 5,
		["HeroId"] = 10011,
		["Level"] = 25,
		["Star"] = 2,
		["Quality"] = 3,
		["SkillLv"] = {5,5,5,5,5,5},
	},
	[6] = {
		["ID"] = 6,
		["HeroId"] = 10012,
		["Level"] = 25,
		["Star"] = 2,
		["Quality"] = 3,
		["SkillLv"] = {5,5,5,5,5,5},
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

local tbConfig = gf_CopyTable(RobotHero[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
