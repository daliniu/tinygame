-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["character"] = 1,
};

sheetindex = {
[1] = "character",
};

local character = {
[1] = {
	[10001] = {
		["id"] = 10001,
		["name"] = "亚瑟王",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 80,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1001,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113007},
		["levelgrowing"] = {50,50,100},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,70}},
		["teamId"] = 1,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1375,0.088,0.022},{0.20625,0.132,0.033},{0.22916,0.14666,0.036665},{0.24062,0.154,0.0385},{0.275,0.176,0.044}},
		["freehero"] = 0,
	},
	[10002] = {
		["id"] = 10002,
		["name"] = "斯巴达克斯",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1002,
		["type"] = 2,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30005,7},
		["skill2_1"] = {30007,2},
		["skill2_2"] = {30017,8},
		["skill3_1"] = {30010,3},
		["skill3_2"] = {30013,9},
		["skill4_1"] = {30011,4},
		["skill4_2"] = {30020,10},
		["skill5_1"] = {30006,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113008},
		["levelgrowing"] = {50,50,101},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,71}},
		["teamId"] = 1,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.0862,0.1402,0.035},{0.1293,0.2103,0.0525},{0.1437,0.2337,0.05843},{0.1509,0.2454,0.0613},{0.1725,0.2804,0.0701}},
		["freehero"] = 0,
	},
	[10003] = {
		["id"] = 10003,
		["name"] = "卡特琳娜",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1003,
		["type"] = 2,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30003,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30009,8},
		["skill3_1"] = {30015,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30020,4},
		["skill4_2"] = {30011,10},
		["skill5_1"] = {30006,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113009},
		["levelgrowing"] = {50,50,102},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,72}},
		["teamId"] = 1,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.0887,0.1364,0.0341},{0.1330,0.2046,0.0511},{0.1478,0.2273,0.0568},{0.1552,0.2387,0.0596},{0.1774,0.2728,0.0682}},
		["freehero"] = {1,1},
	},
	[10004] = {
		["id"] = 10004,
		["name"] = "布伦希尔德",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1004,
		["type"] = 1,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113010},
		["levelgrowing"] = {50,50,103},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,73}},
		["teamId"] = 2,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.11,0.11,0.0275},{0.165,0.165,0.0412},{0.1833,0.1833,0.0458},{0.1925,0.1925,0.0481},{0.22,0.22,0.055}},
		["freehero"] = {1,3},
	},
	[10005] = {
		["id"] = 10005,
		["name"] = "贞德",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1005,
		["type"] = 1,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113011},
		["levelgrowing"] = {50,50,104},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,74}},
		["teamId"] = 2,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.08978,0.13474,0.033685},{0.13467,0.20211,0.0505275},{0.14963,0.22456,0.05614},{0.15711,0.23579,0.0589475},{0.17956,0.26948,0.06737}},
		["freehero"] = 0,
	},
	[10006] = {
		["id"] = 10006,
		["name"] = "潘多拉",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1006,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,105},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,75}},
		["teamId"] = 2,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1089,0.1111,0.027775},{0.16335,0.16665,0.0416625},{0.1815,0.18516,0.04629},{0.19057,0.19442,0.048605},{0.2178,0.2222,0.05555}},
		["freehero"] = 0,
	},
	[10007] = {
		["id"] = 10007,
		["name"] = "莫甘娜",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1007,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,106},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,76}},
		["teamId"] = 3,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1111,0.1089,0.027225},{0.16665,0.16335,0.0408375},{0.18516,0.1815,0.045375},{0.19442,0.19057,0.0476425},{0.2222,0.2178,0.05445}},
		["freehero"] = 0,
	},
	[10008] = {
		["id"] = 10008,
		["name"] = "苏妲己",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1008,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,107},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,77}},
		["teamId"] = 3,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.13496,0.08964,0.02241},{0.20244,0.13446,0.033615},{0.22493,0.1494,0.03735},{0.23618,0.15687,0.0392175},{0.26992,0.17928,0.04482}},
		["freehero"] = 0,
	},
	[10009] = {
		["id"] = 10009,
		["name"] = "孔明",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1009,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,108},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,78}},
		["teamId"] = 3,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1073,0.11274,0.028185},{0.16095,0.16911,0.0422775},{0.17883,0.1879,0.046975},{0.18777,0.19729,0.0493225},{0.2146,0.22548,0.05637}},
		["freehero"] = 0,
	},
	[10010] = {
		["id"] = 10010,
		["name"] = "花木兰",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1010,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,109},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,79}},
		["teamId"] = 4,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.11224,0.1078,0.02695},{0.16836,0.1617,0.040425},{0.18706,0.17966,0.044915},{0.19642,0.18865,0.0471625},{0.22448,0.2156,0.0539}},
		["freehero"] = 0,
	},
	[10011] = {
		["id"] = 10011,
		["name"] = "托尔",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1011,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,110},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,80}},
		["teamId"] = 4,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.088,0.1375,0.0343},{0.132,0.20625,0.0515},{0.14666,0.22916,0.0572},{0.154,0.24062,0.0601},{0.176,0.275,0.0687}},
		["freehero"] = 0,
	},
	[10012] = {
		["id"] = 10012,
		["name"] = "路西法",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1012,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,111},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,81}},
		["teamId"] = 4,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.13252,0.0913,0.022825},{0.19878,0.13695,0.0342375},{0.22086,0.15216,0.03804},{0.23191,0.15977,0.0399425},{0.26504,0.1826,0.04565}},
		["freehero"] = 0,
	},
	[10013] = {
		["id"] = 10013,
		["name"] = "曹孟德",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1013,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30003,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,111},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,81}},
		["teamId"] = 5,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.0873,0.1386,0.0346},{0.1309,0.2079,0.0519},{0.1455,0.231,0.0577},{0.1527,0.2425,0.0606},{0.1746,0.2772,0.0693}},
		["freehero"] = {1,2},
	},
	[10014] = {
		["id"] = 10014,
		["name"] = "血腥玛丽",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1014,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,111},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,81}},
		["teamId"] = 5,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.1134,0.1067,0.026675},{0.1701,0.16005,0.0400125},{0.189,0.17783,0.0444575},{0.19845,0.18672,0.04668},{0.2268,0.2134,0.05335}},
		["freehero"] = 0,
	},
	[10015] = {
		["id"] = 10015,
		["name"] = "赫拉克勒斯",
		["hp"] = 0,
		["atk"] = 0,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increasehurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 1,
		["tenacitylevel"] = 0,
		["anticritrate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 0,
		["commonskillid"] = {10001,10002,10003,10004,10005,10006},
		["modelid"] = 1015,
		["type"] = 3,
		["skill1_1"] = {30002,1},
		["skill1_2"] = {30004,7},
		["skill2_1"] = {30005,2},
		["skill2_2"] = {30007,8},
		["skill3_1"] = {30008,3},
		["skill3_2"] = {30016,9},
		["skill4_1"] = {30010,4},
		["skill4_2"] = {30013,10},
		["skill5_1"] = {30020,5},
		["skill5_2"] = {30018,11},
		["skill6_1"] = {30018,6},
		["skill6_2"] = {30018,12},
		["suit"] = {113005,113006,113012},
		["levelgrowing"] = {50,50,111},
		["stargrowing"] = {{10,10,20},{20,20,30},{20,20,30},{40,40,60},{60,60,81}},
		["teamId"] = 5,
		["grow_base"] = {2,75,50},
		["grow_rate"] = {{0.13924,0.0869,0.021725},{0.20886,0.13035,0.0325875},{0.23206,0.14483,0.0362075},{0.24367,0.15207,0.0380175},{0.27848,0.1738,0.04345}},
		["freehero"] = 0,
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

local tbConfig = gf_CopyTable(character[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
