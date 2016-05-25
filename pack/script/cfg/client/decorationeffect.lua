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

local decorationeffect = {
[1] = {
	[1000] = {
		["majoreffctid"] = 1000,
		["describe"] = "连携主特效（60004）",
		["position"] = {375,967},
		["scale"] = 1,
		["eff_id"] = 60004,
	},
	[1001] = {
		["majoreffctid"] = 1001,
		["describe"] = "升级特效（60006）",
		["scale"] = 2.50000000,
		["eff_id"] = 60006,
	},
	[1002] = {
		["majoreffctid"] = 1002,
		["describe"] = "角色升品主特效（60034）",
		["position"] = {375,858},
		["scale"] = 2.20000000,
		["eff_id"] = 60034,
	},
	[1003] = {
		["majoreffctid"] = 1003,
		["describe"] = "角色升品特效（60036）",
		["scale"] = 1.10000000,
		["eff_id"] = 60036,
	},
	[1004] = {
		["majoreffctid"] = 1004,
		["describe"] = "角色升星特效（60035）",
		["position"] = {380,862},
		["scale"] = 2,
		["eff_id"] = 60035,
	},
	[1005] = {
		["majoreffctid"] = 1005,
		["describe"] = "角色召唤（60038）",
		["position"] = {375,500},
		["scale"] = 3,
		["eff_id"] = 60038,
	},
},
};


return decorationeffect[1]
