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

local broadcast = {
[1] = {
	[0] = {
		["effecttype"] = 0,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "给",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "施加了",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "状态",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[1] = {
		["effecttype"] = 1,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "对",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "造成",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "点伤害",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[2] = {
		["effecttype"] = 2,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "给",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "恢复",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "点生命",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[3] = {
		["effecttype"] = 3,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "使",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "释放",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "技能",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[4] = {
		["effecttype"] = 4,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "对",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "造成",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "伤害",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[5] = {
		["effecttype"] = 5,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "使",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "增加",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "法力水晶",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[6] = {
		["effecttype"] = 6,
		["text1"] = "召唤了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "在",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "召唤",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[7] = {
		["effecttype"] = 7,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "在",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "复制",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[8] = {
		["effecttype"] = 8,
		["text1"] = "释放了",
		["skillnamecolour"] = {{255, 205, 0}, 255, 20},
		["text2"] = "对",
		["effectrangecolour"] = {{157, 162, 176}, 255, 18},
		["text3"] = "造成",
		["effectcolour"] = {{254, 254, 254}, 255, 18},
		["text4"] = "点伤害",
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
	[1000] = {
		["effecttype"] = 1000,
		["text1"] = "获取金币",
		["skillnamecolour"] = {{255, 205, 0}, 255, 18},
		["text2"] = "经验",
		["effectrangecolour"] = {{255, 205, 0}, 255, 18},
		["textcolour"] = {{157, 162, 176}, 255, 18},
	},
},
};


return broadcast[1]
