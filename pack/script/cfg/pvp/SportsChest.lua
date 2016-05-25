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

local SportsChest = {
[1] = {
	[1] = {
		["ID"] = 1,
		["WinNum"] = 1,
		["Reward1"] = 30,
		["Reward2"] = 100,
	},
	[2] = {
		["ID"] = 2,
		["WinNum"] = 3,
		["Reward1"] = 60,
		["Reward2"] = 150,
	},
	[3] = {
		["ID"] = 3,
		["WinNum"] = 5,
		["Reward1"] = 100,
		["Reward2"] = 200,
	},
},
};


return SportsChest[1]
