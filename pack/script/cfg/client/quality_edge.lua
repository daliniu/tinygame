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

local quality_edge = {
[1] = {
	[1] = {
		["itemtype"] = 1,
		["qualitytype1"] = "res/ui/00/00_bg_equipment_00.png",
		["qualitytype2"] = "res/ui/00/00_bg_equipment_01.png",
		["qualitytype3"] = "res/ui/00/00_bg_equipment_02.png",
		["qualitytype4"] = "res/ui/00/00_bg_equipment_03.png",
		["qualitytype5"] = "res/ui/00/00_bg_equipment_04.png",
	},
	[2] = {
		["itemtype"] = 2,
		["qualitytype1"] = "res/ui/00/00_bg_item_00.png",
		["qualitytype2"] = "res/ui/00/00_bg_item_01.png",
		["qualitytype3"] = "res/ui/00/00_bg_item_02.png",
		["qualitytype4"] = "res/ui/00/00_bg_item_03.png",
		["qualitytype5"] = "res/ui/00/00_bg_item_04.png",
	},
	[3] = {
		["itemtype"] = 3,
		["qualitytype1"] = "res/ui/11_team/11_bg_1.png",
		["qualitytype2"] = "res/ui/11_team/11_bg_2.png",
		["qualitytype3"] = "res/ui/11_team/11_bg_3.png",
		["qualitytype4"] = "res/ui/11_team/11_bg_4.png",
		["qualitytype5"] = "res/ui/11_team/11_bg_5.png",
	},
	[4] = {
		["itemtype"] = 4,
		["qualitytype1"] = "res/ui/00/00_bg_item_00.png",
		["qualitytype2"] = "res/ui/00/00_bg_item_01.png",
		["qualitytype3"] = "res/ui/00/00_bg_item_02.png",
		["qualitytype4"] = "res/ui/00/00_bg_item_03.png",
		["qualitytype5"] = "res/ui/00/00_bg_item_04.png",
	},
},
};


return quality_edge[1]
