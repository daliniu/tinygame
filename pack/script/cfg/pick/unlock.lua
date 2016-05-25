-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["backOpen"] = 1,
};

sheetindex = {
[1] = "backOpen",
};

local unlock = {
[1] = {
	[1] = {
		["Bid"] = 1,
		["itemId"] = 15001,
		["itemNo"] = 10,
		["price"] = 10,
	},
	[2] = {
		["Bid"] = 2,
		["itemId"] = 15001,
		["itemNo"] = 20,
		["price"] = 10,
	},
	[3] = {
		["Bid"] = 3,
		["itemId"] = 15002,
		["itemNo"] = 1,
		["price"] = 300,
	},
},
};


return unlock[1]
