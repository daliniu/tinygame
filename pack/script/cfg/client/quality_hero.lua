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

local quality_hero = {
[1] = {
	[0] = {
		["id"] = 0,
		["name"] = "白",
		["color"] = {206,129,43},
		["roundpath"] = "res/ui/11_team/11_bg_01_1.png",
		["squarepath"] = "res/ui/11_team/11_bg_1.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_1.png",
		["edge"] = "res/ui/11_team/001_ob_01_1.png",
	},
	[1] = {
		["id"] = 1,
		["name"] = "绿",
		["color"] = {42,196,46},
		["roundpath"] = "res/ui/11_team/11_bg_01_2.png",
		["squarepath"] = "res/ui/11_team/11_bg_2.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_2.png",
		["edge"] = "res/ui/11_team/001_ob_02_1.png",
	},
	[2] = {
		["id"] = 2,
		["name"] = "绿+1",
		["color"] = {42,196,46},
		["roundpath"] = "res/ui/11_team/11_bg_01_2.png",
		["squarepath"] = "res/ui/11_team/11_bg_2.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_2.png",
		["edge"] = "res/ui/11_team/001_ob_02_1a.png",
	},
	[3] = {
		["id"] = 3,
		["name"] = "蓝",
		["color"] = {58,146,255},
		["roundpath"] = "res/ui/11_team/11_bg_01_3.png",
		["squarepath"] = "res/ui/11_team/11_bg_3.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_3.png",
		["edge"] = "res/ui/11_team/001_ob_03_1.png",
	},
	[4] = {
		["id"] = 4,
		["name"] = "蓝+1",
		["color"] = {58,146,255},
		["roundpath"] = "res/ui/11_team/11_bg_01_3.png",
		["squarepath"] = "res/ui/11_team/11_bg_3.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_3.png",
		["edge"] = "res/ui/11_team/001_ob_03_1a.png",
	},
	[5] = {
		["id"] = 5,
		["name"] = "蓝+2",
		["color"] = {58,146,255},
		["roundpath"] = "res/ui/11_team/11_bg_01_3.png",
		["squarepath"] = "res/ui/11_team/11_bg_3.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_3.png",
		["edge"] = "res/ui/11_team/001_ob_03_1b.png",
	},
	[6] = {
		["id"] = 6,
		["name"] = "蓝+3",
		["color"] = {58,146,255},
		["roundpath"] = "res/ui/11_team/11_bg_01_3.png",
		["squarepath"] = "res/ui/11_team/11_bg_3.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_3.png",
		["edge"] = "res/ui/11_team/001_ob_03_1c.png",
	},
	[7] = {
		["id"] = 7,
		["name"] = "紫",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1.png",
	},
	[8] = {
		["id"] = 8,
		["name"] = "紫+1",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1a.png",
	},
	[9] = {
		["id"] = 9,
		["name"] = "紫+2",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1b.png",
	},
	[10] = {
		["id"] = 10,
		["name"] = "紫+3",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1c.png",
	},
	[11] = {
		["id"] = 11,
		["name"] = "紫+4",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1d.png",
	},
	[12] = {
		["id"] = 12,
		["name"] = "紫+5",
		["color"] = {216,60,225},
		["roundpath"] = "res/ui/11_team/11_bg_01_4.png",
		["squarepath"] = "res/ui/11_team/11_bg_4.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_4.png",
		["edge"] = "res/ui/11_team/001_ob_04_1e.png",
	},
	[13] = {
		["id"] = 13,
		["name"] = "橙",
		["color"] = {255,174,34},
		["roundpath"] = "res/ui/11_team/11_bg_01_5.png",
		["squarepath"] = "res/ui/11_team/11_bg_5.png",
		["starpath"] = "res/ui/11_team/11_001_ob_star_5.png",
		["edge"] = "res/ui/11_team/001_ob_05_1.png",
	},
},
};


return quality_hero[1]
