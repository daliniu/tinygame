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

local picgroup = {
[1] = {
	[1] = {
		["GroupID"] = 1,
		["GroupName"] = "随机云朵图组",
		["Pic1"] = "res/map/background/map_bg_front_cloud_01.png",
		["Pic2"] = "res/map/background/map_bg_front_cloud_02.png",
		["Pic3"] = "res/map/background/map_bg_front_cloud_03.png",
	},
	[101] = {
		["GroupID"] = 101,
		["GroupName"] = "战斗地图林间",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_battlewoods_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_battlewoods_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_battlewoods_01c.png",
	},
	[102] = {
		["GroupID"] = 102,
		["GroupName"] = "战斗地图血色花海",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_01c.png",
	},
	[103] = {
		["GroupID"] = 103,
		["GroupName"] = "战斗地图要塞",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_city_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_city_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_city_01c.png",
	},
	[104] = {
		["GroupID"] = 104,
		["GroupName"] = "战斗地图沙漠",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_desert_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_desert_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_desert_01c.png",
	},
	[105] = {
		["GroupID"] = 105,
		["GroupName"] = "战斗地图水乡",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_waterland_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_waterland_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_waterland_01c.png",
	},
	[106] = {
		["GroupID"] = 106,
		["GroupName"] = "战斗地图血色洞穴",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_02a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_02b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_bloodflower_02c.png",
	},
	[107] = {
		["GroupID"] = 107,
		["GroupName"] = "战斗地图草地帐篷",
		["Pic1"] = "res/ui/01_battleselectcha/battlescene/01_bg_newworld_01a.png",
		["Pic2"] = "res/ui/01_battleselectcha/battlescene/01_bg_newworld_01b.png",
		["Pic3"] = "res/ui/01_battleselectcha/battlescene/01_bg_newworld_01c.png",
	},
	[201] = {
		["GroupID"] = 201,
		["GroupName"] = "草地系地图前背景",
		["Pic1"] = "res/map/background/map_bg_back_mountain_01.png",
		["Pic2"] = "res/map/background/map_bg_back_cloud_01.png",
		["Pic3"] = "res/map/background/map_bg_front_stick_01.png",
		["Pic4"] = "res/map/background/map_bg_front_cloud_04.png",
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

local tbConfig = gf_CopyTable(picgroup[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
