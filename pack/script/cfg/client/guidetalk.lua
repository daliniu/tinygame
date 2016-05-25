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

local guidetalk = {
[1] = {
	[1] = {
		["step"] = 1,
		["target"] = "首战后",
		["words"] = "命运之子！我是时空之女——潘多拉！你已经来到了时空漩涡，这里会有无穷无尽的敌人杀来，你必须抵挡它们！当然，击败它们也有丰富的奖励！",
	},
	[2] = {
		["step"] = 2,
		["target"] = "进探索",
		["words"] = "命运之子，我们回到了千年之前，你可以在这个世界上自由旅行，阻止千年之后的灾难发生！点击地图就可以移动！快来试试看！",
	},
	[3] = {
		["step"] = 3,
		["target"] = "召唤英雄",
		["words"] = "命运之子，随着你的等级提高，你可以把未来世界里的英雄召唤到你的身边，与你一同作战。快来试试吧！",
	},
	[4] = {
		["step"] = 4,
		["target"] = "英雄布阵",
		["words"] = "如果想要你复生出来的英雄发挥作用，你得把他们派到战阵上！否则，他们可发挥不了作用！",
	},
	[5] = {
		["step"] = 5,
		["target"] = "装备装备",
		["words"] = "你获得的这些装备可以尽情的使用，它们能够极大的提高你的战斗力，来我帮你穿上它们~",
	},
	[6] = {
		["step"] = 6,
		["target"] = "英雄升品",
		["words"] = "被你召唤来的英雄力量并不完善，你需要使用英雄碎片来为他们升品，升品之后英雄不但会提升属性，还能够获得强力的新技能。",
	},
	[7] = {
		["step"] = 7,
		["target"] = "装备打造",
		["words"] = "在繁荣的繁荣时代，可以用于锻造装备的珍贵材料随处可见，只要你有装备卷轴，就可以轻松地打造强力的新装备！让我们来造一件！",
	},
	[8] = {
		["step"] = 8,
		["target"] = "装备淬炼",
		["words"] = "其实装备的力量是可以互相融合的，用淬炼就可以把一件装备上的属性转移到另一件装备上。很难懂？试试你就明白啦！",
	},
	[9] = {
		["step"] = 9,
		["target"] = "召唤英雄2",
		["words"] = "命运之子，你的等级已经提升到足够再召唤一个英雄啦！还不快去？",
	},
	[10] = {
		["step"] = 10,
		["target"] = "步数宝箱",
		["words"] = "在魔窟中经过一定次数的连续战斗，你就会获得一个奖励宝箱！宝箱已到，来领取吧！",
	},
},
};


return guidetalk[1]
