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

local newcharacter = {
[1] = {
	[10016] = {
		["id"] = 10016,
		["name"] = "亚瑟王",
		["hp"] = 5000,
		["atk"] = 2000,
		["defense"] = 70,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 10,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 80,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["skillid"] = {30001,50002,50004,50007,50008},
		["conskillid"] = {0,0},
		["modelid"] = 1001,
		["type"] = 3,
		["skill1_1"] = {30002,0},
		["skill1_2"] = {30004,2},
		["skill2_1"] = {30005,0},
		["skill2_2"] = {30007,2},
		["skill3_1"] = {30008,0},
		["skill3_2"] = {30016,2},
		["skill4_1"] = {30010,1},
		["skill4_2"] = {30013,3},
		["skill5_1"] = {30020,1},
		["skill5_2"] = {30018,4},
		["skill6_1"] = {30018,2},
		["skill6_2"] = {30018,5},
		["suit"] = {113005,113006,113007},
		["levelgrowing"] = {50,50,100},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,70}},
		["teamId"] = 1,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1375,0.088,0.022},{0.20625,0.132,0.033},{0.22916,0.14666,0.036665},{0.24062,0.154,0.0385},{0.275,0.176,0.044}},
	},
	[10017] = {
		["id"] = 10017,
		["name"] = "斯巴达克斯",
		["hp"] = 5000,
		["atk"] = 3000,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 10,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["skillid"] = {30024,50001,50005,50006,50007},
		["conskillid"] = {0,0},
		["modelid"] = 1002,
		["type"] = 3,
		["skill1_1"] = {30002,0},
		["skill1_2"] = {30004,2},
		["skill2_1"] = {30005,0},
		["skill2_2"] = {30007,2},
		["skill3_1"] = {30008,0},
		["skill3_2"] = {30016,2},
		["skill4_1"] = {30010,1},
		["skill4_2"] = {30013,3},
		["skill5_1"] = {30020,1},
		["skill5_2"] = {30018,4},
		["skill6_1"] = {30018,2},
		["skill6_2"] = {30018,5},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,111},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,81}},
		["teamId"] = 5,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.0873,0.1386,0.0346},{0.1309,0.2079,0.0519},{0.1455,0.231,0.0577},{0.1527,0.2425,0.0606},{0.1746,0.2772,0.0693}},
	},
	[10018] = {
		["id"] = 10018,
		["name"] = "卡特琳娜",
		["hp"] = 5000,
		["atk"] = 2000,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 10,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["skillid"] = {30022,50003,50008},
		["conskillid"] = {0,0},
		["modelid"] = 1003,
		["type"] = 2,
		["skill1_1"] = {30021,0},
		["skill1_2"] = {30007,2},
		["skill2_1"] = {30005,0},
		["skill2_2"] = {30009,2},
		["skill3_1"] = {30008,0},
		["skill3_2"] = {30016,2},
		["skill4_1"] = {30020,1},
		["skill4_2"] = {30011,3},
		["skill5_1"] = {30006,1},
		["skill5_2"] = {30018,4},
		["skill6_1"] = {30018,2},
		["skill6_2"] = {30018,5},
		["suit"] = {113005,113006,113009},
		["levelgrowing"] = {50,50,102},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,72}},
		["teamId"] = 1,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.0887,0.1364,0.0341},{0.1330,0.2046,0.0511},{0.1478,0.2273,0.0568},{0.1552,0.2387,0.0596},{0.1774,0.2728,0.0682}},
	},
},
};

-- functions for xlstable read
local __getcell = function (t, a,b,c) return t[a][b][c] end
function GetCell(sheetx, rowx, colx)
	rst, v = pcall(__getcell, xlstable, sheetx, rowx, colx)
	if rst then return v
	else return nil
	end
end

function GetCellBySheetName(sheet, rowx, colx)
	return GetCell(sheetname[sheet], rowx, colx)
end

__XLS_END = true

local tbConfig = gf_CopyTable(newcharacter[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
