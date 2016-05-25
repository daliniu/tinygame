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

local portal = {
[1] = {
	[17001] = {
		["Id"] = 17001,
		["Name"] = "1号传送门",
		["ElementType"] = 17,
		["Genre"] = 5,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1700,
		["Pic1"] = 1700,
		["Pic2"] = 1700,
		["Resetting"] = 0,
		["Portal"] = 0,
		["Map"] = 0,
		["Scale"] = 100,
	},
	[17002] = {
		["Id"] = 17002,
		["Name"] = "1号传送门",
		["ElementType"] = 17,
		["Genre"] = 5,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1700,
		["Pic1"] = 1701,
		["Pic2"] = 1701,
		["Resetting"] = 0,
		["Portal"] = 0,
		["Map"] = 0,
		["Scale"] = 100,
	},
},
};


return portal[1]
