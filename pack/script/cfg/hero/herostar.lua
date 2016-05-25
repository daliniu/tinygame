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

local herostar = {
[1] = {
	[1] = {
		["starLv"] = 1,
		["itemId"] = 15121,
		["itemNum"] = 3,
		["gold"] = 5000,
	},
	[2] = {
		["starLv"] = 2,
		["itemId"] = 15122,
		["itemNum"] = 10,
		["gold"] = 10000,
	},
	[3] = {
		["starLv"] = 3,
		["itemId"] = 15123,
		["itemNum"] = 20,
		["gold"] = 30000,
	},
	[4] = {
		["starLv"] = 4,
		["itemId"] = 15124,
		["itemNum"] = 40,
		["gold"] = 60000,
	},
	[5] = {
		["starLv"] = 5,
		["itemId"] = 15125,
		["itemNum"] = 80,
		["gold"] = 100000,
	},
},
};


return herostar[1]
