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

local mapinfo = {
[1] = {
	[1] = {
		["MapId"] = 1,
		["ResPath"] = "res/map/01",
		["InfoFile"] = "01.json",
		["InitPos"] = {5,5},
		["ExitId"] = 105,
		["UnlockCondition1"] = 0,
		["UnlockCondition2"] = 0,
		["UnlockCondition3"] = 0,
		["Area1"] = 2,
		["MapSign"] = {1,2,3},
		["BGPic"] = 201,
		["ScenePic"] = 1,
		["APCost"] = 5,
		["PicMapItem"] = "res/ui/16_mapchoose/mapicon/mapicon_woodland.png",
		["PicMapName"] = "res/ui/16_mapchoose/16_txt_map_01.png",
	},
	[2] = {
		["MapId"] = 2,
		["ResPath"] = "res/map/02",
		["InfoFile"] = "02.json",
		["InitPos"] = {10,4},
		["ExitId"] = 816,
		["UnlockCondition1"] = 0,
		["UnlockCondition2"] = 0,
		["UnlockCondition3"] = 0,
		["Area1"] = 1447,
		["MapSign"] = {1,2,3},
		["BGPic"] = 201,
		["ScenePic"] = 1,
		["APCost"] = 6,
		["PicMapItem"] = "res/ui/16_mapchoose/mapicon/mapicon_bloodflower.png",
		["PicMapName"] = "res/ui/16_mapchoose/16_txt_map_02.png",
	},
	[3] = {
		["MapId"] = 3,
		["ResPath"] = "res/map/03",
		["InfoFile"] = "03.json",
		["InitPos"] = {5,20},
		["ExitId"] = 1454,
		["UnlockCondition1"] = 0,
		["UnlockCondition2"] = 0,
		["UnlockCondition3"] = 0,
		["Area1"] = 1359,
		["MapSign"] = {1,2},
		["BGPic"] = 201,
		["ScenePic"] = 1,
		["APCost"] = 7,
		["PicMapItem"] = "res/ui/16_mapchoose/mapicon/mapicon_bloodflower.png",
		["PicMapName"] = "res/ui/16_mapchoose/16_txt_map_03.png",
	},
	[4] = {
		["MapId"] = 4,
		["ResPath"] = "res/map/04",
		["InfoFile"] = "04.json",
		["InitPos"] = {2,6},
		["ExitId"] = 1541,
		["UnlockCondition1"] = 0,
		["UnlockCondition2"] = 0,
		["UnlockCondition3"] = 0,
		["Area1"] = 1483,
		["MapSign"] = {3,4,5},
		["BGPic"] = 201,
		["ScenePic"] = 1,
		["APCost"] = 8,
		["PicMapItem"] = "res/ui/16_mapchoose/mapicon/mapicon_waterland.png",
		["PicMapName"] = "res/ui/16_mapchoose/16_txt_map_04.png",
	},
	[100] = {
		["MapId"] = 100,
		["ResPath"] = "res/map/100",
		["InfoFile"] = "100.json",
		["InitPos"] = {5,5},
		["ExitId"] = 105,
		["UnlockCondition1"] = 0,
		["UnlockCondition2"] = 0,
		["UnlockCondition3"] = 0,
		["Area1"] = 2,
		["MapSign"] = {1,2,3},
		["BGPic"] = 201,
		["ScenePic"] = 1,
		["APCost"] = 5,
		["PicMapItem"] = "res/ui/16_mapchoose/mapicon/mapicon_woodland.png",
		["PicMapName"] = "res/ui/16_mapchoose/16_txt_map_01.png",
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

local tbConfig = gf_CopyTable(mapinfo[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
