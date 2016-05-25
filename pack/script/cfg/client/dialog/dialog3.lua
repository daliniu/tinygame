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

local dialog3 = {
[1] = {
	[1] = {
		["step"] = 1,
		["camp"] = 2,
		["pos"] = 5,
		["dialog"] = "我要杀了你",
	},
	[2] = {
		["step"] = 2,
		["camp"] = 1,
		["pos"] = 6,
		["dialog"] = "杀人还是我比较在行",
	},
},
};


return dialog3[1]
