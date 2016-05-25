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

local quality_basic = {
[1] = {
	[0] = {
		["id"] = 0,
		["name"] = "灰",
		["color"] = {87,87,87},
		["star"] = "res/ui/11_team/11_001_ob_star_1.png",
	},
	[1] = {
		["id"] = 1,
		["name"] = "白",
		["color"] = {206,129,43},
		["star"] = "res/ui/11_team/11_001_ob_star_1.png",
	},
	[2] = {
		["id"] = 2,
		["name"] = "绿",
		["color"] = {42,196,46},
		["star"] = "res/ui/11_team/11_001_ob_star_2.png",
	},
	[3] = {
		["id"] = 3,
		["name"] = "蓝",
		["color"] = {58,146,255},
		["star"] = "res/ui/11_team/11_001_ob_star_3.png",
	},
	[4] = {
		["id"] = 4,
		["name"] = "紫",
		["color"] = {216,60,225},
		["star"] = "res/ui/11_team/11_001_ob_star_4.png",
	},
	[5] = {
		["id"] = 5,
		["name"] = "橙",
		["color"] = {255,174,34},
		["star"] = "res/ui/11_team/11_001_ob_star_5.png",
	},
},
};


return quality_basic[1]
