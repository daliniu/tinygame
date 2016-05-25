-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["addAu"] = 1,
};

sheetindex = {
[1] = "addAu",
};

local addAu = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["addId"] = 1001,
		["number"] = 7,
		["tepy1"] = {{1,2000}},
		["tepy2"] = {{2,2000}},
		["tepy3"] = {{6,6000}},
		["tepy4"] = {{0,6000}},
		["tepy5"] = {{5,6000}},
		["tepy6"] = {{900,500}},
		["tepy7"] = {{901,500}},
	},
	[2] = {
		["Bid"] = 2,
		["addId"] = 1002,
		["number"] = 3,
		["tepy1"] = {{1,2000}},
		["tepy2"] = {{2,2000}},
		["tepy3"] = {{6,6000}},
	},
},
};


return addAu[1]
