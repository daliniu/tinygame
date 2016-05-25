-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["condition"] = 1,
};

sheetindex = {
[1] = "condition",
};

local condition = {
[1] = {
	[9001] = {
		["id"] = 9001,
		["desc"] = "回合开始后",
	},
	[9002] = {
		["id"] = 9002,
		["desc"] = "回合结束后",
	},
	[9003] = {
		["id"] = 9003,
		["desc"] = "当友方英雄释放普通攻击时",
	},
	[9004] = {
		["id"] = 9004,
		["desc"] = "当友方英雄释放法术时",
	},
	[9005] = {
		["id"] = 9005,
		["desc"] = "当友方英雄召唤生物时",
	},
	[9006] = {
		["id"] = 9006,
		["desc"] = "当友方英雄释放多重施法时",
	},
	[9007] = {
		["id"] = 9007,
		["desc"] = "当友方英雄释放合击技能时",
	},
	[9008] = {
		["id"] = 9008,
		["desc"] = "当敌方释放技能时",
	},
	[9009] = {
		["id"] = 9009,
		["desc"] = "当友方释放技能时",
	},
	[9010] = {
		["id"] = 9010,
		["desc"] = "释放技能时",
	},
	[9011] = {
		["id"] = 9011,
		["desc"] = "受伤后",
	},
	[9012] = {
		["id"] = 9012,
		["desc"] = "造成伤害后",
	},
	[9013] = {
		["id"] = 9013,
		["desc"] = "友方受到治疗后",
	},
	[9014] = {
		["id"] = 9014,
		["desc"] = "生物进场后",
	},
	[9015] = {
		["id"] = 9015,
		["desc"] = "友方生物进场后",
	},
	[9016] = {
		["id"] = 9016,
		["desc"] = "敌方生物进场后",
	},
	[9017] = {
		["id"] = 9017,
		["desc"] = "亡语",
	},
	[9018] = {
		["id"] = 9018,
		["desc"] = "友方生物死亡后",
	},
},
};


return condition[1]