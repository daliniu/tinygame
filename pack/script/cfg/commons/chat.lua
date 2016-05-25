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

local chat = {
[1] = {
	[1] = {
		["channel"] = 1,
		["level"] = 0,
		["time"] = 0,
	},
	[2] = {
		["channel"] = 2,
		["level"] = 0,
		["time"] = 0,
	},
	[3] = {
		["channel"] = 3,
		["level"] = 0,
		["time"] = 0,
	},
	[4] = {
		["channel"] = 4,
		["level"] = 0,
		["time"] = 30,
	},
	[5] = {
		["channel"] = 5,
		["level"] = 0,
		["time"] = 0,
	},
	[6] = {
		["channel"] = 6,
		["level"] = 0,
		["time"] = 0,
	},
},
};


return chat[1]
