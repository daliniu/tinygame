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

local battleresult = {
[1] = {
	[1] = {
		["Key"] = 1,
		["StarLevel"] = 0,
		["RemainingBlood"] = {-100,0},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_14.png",
	},
	[2] = {
		["Key"] = 2,
		["StarLevel"] = 1,
		["RemainingBlood"] = {0,5},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_12.png",
	},
	[3] = {
		["Key"] = 3,
		["StarLevel"] = 2,
		["RemainingBlood"] = {5,20},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_13.png",
	},
	[4] = {
		["Key"] = 4,
		["StarLevel"] = 3,
		["RemainingBlood"] = {20,45},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_11.png",
	},
	[5] = {
		["Key"] = 5,
		["StarLevel"] = 4,
		["RemainingBlood"] = {45,60},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_10.png",
	},
	[6] = {
		["Key"] = 6,
		["StarLevel"] = 5,
		["RemainingBlood"] = {60,100},
		["SupplyDeduction"] = 0,
		["PicRes"] = "res/ui/03_fightUI/03_bg_txt_09.png",
	},
},
};


return battleresult[1]
