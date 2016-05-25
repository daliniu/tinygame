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

local statustype = {
[1] = {
	[1] = {
		["effecttypeid"] = 1,
		["des"] = "飞行",
		["statustype"] = 1,
		["disperse"] = 0,
		["coexist"] = 0,
	},
	[2] = {
		["effecttypeid"] = 2,
		["des"] = "吸收护盾",
		["statustype"] = 1,
		["disperse"] = 1,
		["coexist"] = 2,
	},
	[3] = {
		["effecttypeid"] = 3,
		["des"] = "嘲讽",
		["statustype"] = 1,
		["disperse"] = 0,
		["coexist"] = 0,
	},
	[4] = {
		["effecttypeid"] = 4,
		["des"] = "增加属性",
		["statustype"] = 1,
		["disperse"] = 1,
		["coexist"] = 1,
	},
	[5] = {
		["effecttypeid"] = 5,
		["des"] = "免疫",
		["statustype"] = 1,
		["disperse"] = 1,
		["coexist"] = 2,
	},
	[6] = {
		["effecttypeid"] = 6,
		["des"] = "放逐",
		["statustype"] = 2,
		["disperse"] = 0,
		["coexist"] = 2,
	},
	[7] = {
		["effecttypeid"] = 7,
		["des"] = "眩晕",
		["statustype"] = 2,
		["disperse"] = 1,
		["coexist"] = 2,
	},
	[8] = {
		["effecttypeid"] = 8,
		["des"] = "减少属性",
		["statustype"] = 2,
		["disperse"] = 1,
		["coexist"] = 1,
	},
	[9] = {
		["effecttypeid"] = 9,
		["des"] = "持续伤害",
		["statustype"] = 2,
		["disperse"] = 1,
		["coexist"] = 1,
	},
	[10] = {
		["effecttypeid"] = 10,
		["des"] = "触发技能",
		["statustype"] = 1,
		["disperse"] = 0,
		["coexist"] = 1,
	},
},
};


return statustype[1]
