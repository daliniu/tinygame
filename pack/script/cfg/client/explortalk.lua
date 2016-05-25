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

local explortalk = {
[1] = {
	[1] = {
		["id"] = 1,
		["talk"] = "发现敌人！进入战斗！",
	},
	[2] = {
		["id"] = 2,
		["talk"] = "寻找潜藏的史莱姆~",
	},
	[3] = {
		["id"] = 3,
		["talk"] = "查看食人魔的营地~",
	},
	[4] = {
		["id"] = 4,
		["talk"] = "测量恐龙的脚印~",
	},
	[5] = {
		["id"] = 5,
		["talk"] = "看星星确定自己的位置~",
	},
	[6] = {
		["id"] = 6,
		["talk"] = "在营地里睡觉~",
	},
	[7] = {
		["id"] = 7,
		["talk"] = "太阳底下打个盹~",
	},
	[8] = {
		["id"] = 8,
		["talk"] = "巡查怪物出没的洞穴~",
	},
	[9] = {
		["id"] = 9,
		["talk"] = "小心的绕过墙角~",
	},
	[10] = {
		["id"] = 10,
		["talk"] = "检查天花板上有没有怪物~",
	},
	[11] = {
		["id"] = 11,
		["talk"] = "好像闻到了奇怪的味道~",
	},
	[12] = {
		["id"] = 12,
		["talk"] = "误入哥布林的营地~",
	},
	[13] = {
		["id"] = 13,
		["talk"] = "好像踩到了什么东西~",
	},
	[14] = {
		["id"] = 14,
		["talk"] = "排成密集队形向前冲锋~",
	},
	[15] = {
		["id"] = 15,
		["talk"] = "分析死亡骑士的盔甲~",
	},
},
};


return explortalk[1]
