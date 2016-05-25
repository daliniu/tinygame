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

local powermatch = {
[1] = {
	[1] = {
		["ID"] = 1,
		["MyPower"] = {100,1000},
		["Power1"] = {-20,-11},
		["Reward1"] = 1,
		["Power2"] = {-10,0},
		["Reward2"] = 3,
		["Power3"] = {1,20},
		["Reward3"] = 5,
		["SequenceID"] = 1,
	},
	[2] = {
		["ID"] = 2,
		["MyPower"] = {1000,2000},
		["Power1"] = {-20,-11},
		["Reward1"] = 1,
		["Power2"] = {-10,5},
		["Reward2"] = 3,
		["Power3"] = {6,20},
		["Reward3"] = 5,
		["SequenceID"] = 2,
	},
	[3] = {
		["ID"] = 3,
		["MyPower"] = {2000,3000},
		["Power1"] = {-20,-11},
		["Reward1"] = 1,
		["Power2"] = {-10,5},
		["Reward2"] = 3,
		["Power3"] = {6,20},
		["Reward3"] = 5,
		["SequenceID"] = 3,
	},
	[4] = {
		["ID"] = 4,
		["MyPower"] = {3000,999999},
		["Power1"] = {-20,-11},
		["Reward1"] = 1,
		["Power2"] = {-10,5},
		["Reward2"] = 3,
		["Power3"] = {6,20},
		["Reward3"] = 5,
		["SequenceID"] = 3,
	},
},
};


return powermatch[1]
