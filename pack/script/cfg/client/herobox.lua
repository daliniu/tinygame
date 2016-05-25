-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["monsterbox"] = 1,
};

sheetindex = {
[1] = "monsterbox",
};

local herobox = {
[1] = {
	[1] = {
		["Id"] = 1,
		["Desc"] = "新手第1场战斗",
		["Organism1"] = {10016,4},
		["Organism2"] = {10018,5},
		["Organism3"] = {10017,6},
		["dialog"] = "script/cfg/client/dialog/dialog1",
		["afkerpoint"] = 9002,
		["delaytime"] = 1000,
		["skills_1"] = {50001},
		["skills_2"] = {50012},
		["first"] = 1,
	},
	[2] = {
		["Id"] = 2,
		["Desc"] = "新手第2场战斗",
		["Organism1"] = {10016,4},
		["Organism2"] = {10018,5},
		["Organism3"] = {10017,6},
		["dialog"] = "script/cfg/client/dialog/dialog2",
		["afkerpoint"] = 9003,
		["delaytime"] = 1000,
		["skills_1"] = {50002},
		["skills_2"] = {50012},
		["first"] = 2,
	},
	[3] = {
		["Id"] = 3,
		["Desc"] = "新手第3场战斗",
		["Organism1"] = {10016,4},
		["Organism2"] = {10018,5},
		["Organism3"] = {10017,6},
		["dialog"] = "script/cfg/client/dialog/dialog3",
		["afkerpoint"] = 9004,
		["delaytime"] = 1000,
		["skills_1"] = {50003},
		["skills_2"] = {50012},
		["first"] = 2,
	},
	[4] = {
		["Id"] = 4,
		["Desc"] = "新手第4场战斗",
		["Organism1"] = {10016,4},
		["Organism2"] = {10018,5},
		["Organism3"] = {10017,6},
		["dialog"] = "script/cfg/client/dialog/dialog4",
		["afkerpoint"] = 9005,
		["delaytime"] = 1000,
		["skills_1"] = {50004,50005,50006,50007,50008},
		["skills_2"] = {50011,50009,50010},
		["first"] = 2,
	},
},
};


return herobox[1]
