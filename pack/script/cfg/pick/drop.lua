-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["drop"] = 1,
};

sheetindex = {
[1] = "drop",
};

local drop = {
[1] = {
	[3001] = {
		["dropId"] = 3001,
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{1,5000},{2,5000}},
		["tepy1"] = {10101,1,1000,0},
		["tepy2"] = {"gold",10000,4000,0},
		["tepy3"] = {10102,1,2500,0},
		["tepy4"] = {10103,1,2500,0},
		["dropNum"] = 2,
		["Showitem"] = {19302,19302},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3002] = {
		["dropId"] = 3002,
		["foreverDrop"] = {{19301,5},{19302,5},{19303,5},{19304,5},{19305,5},{19306,5},{19307,5},{19308,5}},
		["number"] = {{1,10000}},
		["tepy1"] = {15001,99,5000,0},
		["dropNum"] = 9,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3003] = {
		["dropId"] = 3003,
		["number"] = {{1,10000}},
		["tepy1"] = {16001,1,5000,0},
		["tepy2"] = {16007,1,1000,0},
		["tepy3"] = {16013,1,10,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3004] = {
		["dropId"] = 3004,
		["number"] = {{1,10000}},
		["tepy1"] = {16002,1,5000,0},
		["tepy2"] = {16003,1,5000,0},
		["tepy3"] = {16004,1,5000,0},
		["tepy4"] = {16008,1,1000,0},
		["tepy5"] = {16009,1,1000,0},
		["tepy6"] = {16010,1,1000,0},
		["tepy7"] = {16014,1,10,0},
		["tepy8"] = {16015,1,10,0},
		["tepy9"] = {16016,1,10,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3005] = {
		["dropId"] = 3005,
		["number"] = {{1,10000}},
		["tepy1"] = {16005,1,5000,0},
		["tepy2"] = {16006,1,5000,0},
		["tepy3"] = {16011,1,1000,0},
		["tepy4"] = {16012,1,1000,0},
		["tepy5"] = {16017,1,10,0},
		["tepy6"] = {16018,1,10,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3006] = {
		["dropId"] = 3006,
		["foreverDrop"] = {{10103,1},{10109,2},{10155,5}},
		["number"] = {{1,10000}},
		["tepy1"] = {16019,1,5000,0},
		["tepy2"] = {16025,1,1000,0},
		["tepy3"] = {16031,1,10,0},
		["dropNum"] = 9,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3007] = {
		["dropId"] = 3007,
		["number"] = {{1,10000}},
		["tepy1"] = {16020,1,5000,0},
		["tepy2"] = {16021,1,5000,0},
		["tepy3"] = {16022,1,5000,0},
		["tepy4"] = {16026,1,1000,0},
		["tepy5"] = {16027,1,1000,0},
		["tepy6"] = {16028,1,1000,0},
		["tepy7"] = {16032,1,10,0},
		["tepy8"] = {16033,1,10,0},
		["tepy9"] = {16034,1,10,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3008] = {
		["dropId"] = 3008,
		["number"] = {{1,10000}},
		["tepy1"] = {16023,1,5000,0},
		["tepy2"] = {16024,1,5000,0},
		["tepy3"] = {16029,1,1000,0},
		["tepy4"] = {16030,1,1000,0},
		["tepy5"] = {16035,1,10,0},
		["tepy6"] = {16036,1,10,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3009] = {
		["dropId"] = 3009,
		["foreverDrop"] = {{15101,20},{15201,99},{15202,99},{15203,99},{15204,1},{15205,1},{15206,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 7,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3010] = {
		["dropId"] = 3010,
		["foreverDrop"] = {{15102,20}},
		["number"] = {{1,10000}},
		["tepy1"] = {15001,1,5000,0},
		["tepy2"] = {15001,2,2500,0},
		["tepy3"] = {15001,3,1000,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3011] = {
		["dropId"] = 3011,
		["foreverDrop"] = {{10001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3012] = {
		["dropId"] = 3012,
		["foreverDrop"] = {{10151,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[3013] = {
		["dropId"] = 3013,
		["foreverDrop"] = {{10151,1},{17902,1},{10001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 3,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[19205] = {
		["dropId"] = 19205,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19006,70},{19007,30},{19011,70},{19012,30},{19061,70},{19062,30},{12004,80},{12002,80},{16007,2},{16008,2},{15101,80},{15102,80}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10001] = {
		["dropId"] = 10001,
		["foreverDrop"] = {{"gold",500}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10002] = {
		["dropId"] = 10002,
		["foreverDrop"] = {{110101,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10003] = {
		["dropId"] = 10003,
		["foreverDrop"] = {{110102,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10004] = {
		["dropId"] = 10004,
		["foreverDrop"] = {{19011,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10005] = {
		["dropId"] = 10005,
		["foreverDrop"] = {{19061,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10006] = {
		["dropId"] = 10006,
		["foreverDrop"] = {{19011,2}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10007] = {
		["dropId"] = 10007,
		["foreverDrop"] = {{16001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10008] = {
		["dropId"] = 10008,
		["foreverDrop"] = {{16004,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10009] = {
		["dropId"] = 10009,
		["foreverDrop"] = {{15102,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10010] = {
		["dropId"] = 10010,
		["foreverDrop"] = {{15101,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10011] = {
		["dropId"] = 10011,
		["foreverDrop"] = {{15101,10}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10012] = {
		["dropId"] = 10012,
		["foreverDrop"] = {{15102,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10013] = {
		["dropId"] = 10013,
		["foreverDrop"] = {{15101,10},{16001,1},{16003,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10014] = {
		["dropId"] = 10014,
		["foreverDrop"] = {{16001,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10015] = {
		["dropId"] = 10015,
		["number"] = {{1,10000}},
		["tepy1"] = {16002,1,2500,0},
		["tepy2"] = {16004,1,2500,0},
		["tepy3"] = {15101,5,5000,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10016] = {
		["dropId"] = 10016,
		["number"] = {{1,10000}},
		["tepy1"] = {110102,1,3333,0},
		["tepy2"] = {110104,1,3333,0},
		["tepy3"] = {110106,1,3334,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10017] = {
		["dropId"] = 10017,
		["number"] = {{1,10000}},
		["tepy1"] = {110101,1,3333,0},
		["tepy2"] = {110103,1,3333,0},
		["tepy3"] = {110105,1,3334,0},
		["dropNum"] = 1,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10018] = {
		["dropId"] = 10018,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110105,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10019] = {
		["dropId"] = 10019,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110106,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10020] = {
		["dropId"] = 10020,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110103,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10021] = {
		["dropId"] = 10021,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110104,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10022] = {
		["dropId"] = 10022,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110104,1},{110103,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10023] = {
		["dropId"] = 10023,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110105,1},{110106,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10024] = {
		["dropId"] = 10024,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110109,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10025] = {
		["dropId"] = 10025,
		["IfShowR"] = 1,
		["foreverDrop"] = {{110107,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10026] = {
		["dropId"] = 10026,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
		["number"] = {{0,10000}},
	},
	[10027] = {
		["dropId"] = 10027,
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
		["number"] = {{0,10000}},
	},
	[10028] = {
		["dropId"] = 10028,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19011,5}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10029] = {
		["dropId"] = 10029,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16005,1}},
		["number"] = {{0,10000}},
		["Enabled"] = {1,2,0},
	},
	[10030] = {
		["dropId"] = 10030,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",220}},
		["Enabled"] = {1,2,0},
	},
	[100321] = {
		["dropId"] = 100321,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",260}},
		["Enabled"] = {1,2,0},
	},
	[10031] = {
		["dropId"] = 10031,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",295}},
		["Enabled"] = {1,2,0},
	},
	[10032] = {
		["dropId"] = 10032,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",300}},
		["Enabled"] = {1,2,0},
	},
	[10033] = {
		["dropId"] = 10033,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",320}},
		["Enabled"] = {1,2,0},
	},
	[100322] = {
		["dropId"] = 100322,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",340}},
		["Enabled"] = {1,2,0},
	},
	[10034] = {
		["dropId"] = 10034,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",500}},
		["Enabled"] = {1,2,0},
	},
	[10035] = {
		["dropId"] = 10035,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",550}},
		["Enabled"] = {1,2,0},
	},
	[100401] = {
		["dropId"] = 100401,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",550}},
		["Enabled"] = {1,2,0},
	},
	[10036] = {
		["dropId"] = 10036,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",570}},
		["Enabled"] = {1,2,0},
	},
	[10037] = {
		["dropId"] = 10037,
		["IfShowR"] = 1,
		["foreverDrop"] = {{"ap",710}},
		["Enabled"] = {1,2,0},
	},
	[10108] = {
		["dropId"] = 10108,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16001,1},{16003,1},{15102,10}},
		["Enabled"] = {1,2,0},
	},
	[10132] = {
		["dropId"] = 10132,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16005,1}},
		["Enabled"] = {1,2,0},
	},
	[10133] = {
		["dropId"] = 10133,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15102,5}},
		["Enabled"] = {1,2,0},
	},
	[10134] = {
		["dropId"] = 10134,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16006,1}},
		["Enabled"] = {1,2,0},
	},
	[10144] = {
		["dropId"] = 10144,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16007,1}},
		["Enabled"] = {1,2,0},
	},
	[10201] = {
		["dropId"] = 10201,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19061,5}},
		["Enabled"] = {1,2,0},
	},
	[10135] = {
		["dropId"] = 10135,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15102,5}},
		["Enabled"] = {1,2,0},
	},
	[10136] = {
		["dropId"] = 10136,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15102,5}},
		["Enabled"] = {1,2,0},
	},
	[10115] = {
		["dropId"] = 10115,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16007,1}},
		["Enabled"] = {1,2,0},
	},
	[10117] = {
		["dropId"] = 10117,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15102,5}},
		["Enabled"] = {1,2,0},
	},
	[10114] = {
		["dropId"] = 10114,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16009,1}},
		["Enabled"] = {1,2,0},
	},
	[10107] = {
		["dropId"] = 10107,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19011,1}},
		["Enabled"] = {1,2,0},
	},
	[10203] = {
		["dropId"] = 10203,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19011,2}},
		["Enabled"] = {1,2,0},
	},
	[10109] = {
		["dropId"] = 10109,
		["IfShowR"] = 1,
		["foreverDrop"] = {{19006,5}},
		["Enabled"] = {1,2,0},
	},
	[10154] = {
		["dropId"] = 10154,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16012,1}},
		["Enabled"] = {1,2,0},
	},
	[10116] = {
		["dropId"] = 10116,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15101,5}},
		["Enabled"] = {1,2,0},
	},
	[10118] = {
		["dropId"] = 10118,
		["IfShowR"] = 1,
		["foreverDrop"] = {{15102,5}},
		["Enabled"] = {1,2,0},
	},
	[10124] = {
		["dropId"] = 10124,
		["IfShowR"] = 1,
		["foreverDrop"] = {{16013,1}},
		["Enabled"] = {1,2,0},
	},
	[10120] = {
		["dropId"] = 10120,
		["Showitem"] = {19202},
		["foreverDrop"] = {{16011,1}},
		["Enabled"] = {1,2,0},
		["IfShowR"] = 1,
	},
	[9999] = {
		["dropId"] = 9999,
		["Name"] = "地图测试用的奖励",
		["foreverDrop"] = {{"gold",10000}},
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10100101] = {
		["dropId"] = 10100101,
		["Name"] = "经验宝箱",
		["foreverDrop"] = {{"teamexp",600},{12004,6},{19061,5},{19011,5},{19016,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10100201] = {
		["dropId"] = 10100201,
		["Name"] = "新手剑",
		["foreverDrop"] = {{110107,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30100101] = {
		["dropId"] = 30100101,
		["Name"] = "经验宝箱",
		["foreverDrop"] = {{"teamexp",650}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30100201] = {
		["dropId"] = 30100201,
		["Name"] = "衣服",
		["foreverDrop"] = {{10111,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30100301] = {
		["dropId"] = 30100301,
		["Name"] = "经验宝箱",
		["foreverDrop"] = {{"teamexp",100},{19016,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30100401] = {
		["dropId"] = 30100401,
		["Name"] = "魔法破甲剑",
		["foreverDrop"] = {{10103,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100201] = {
		["dropId"] = 40100201,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100301] = {
		["dropId"] = 40100301,
		["Name"] = "经验宝箱",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100401] = {
		["dropId"] = 40100401,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100501] = {
		["dropId"] = 40100501,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100101] = {
		["dropId"] = 50100101,
		["Name"] = "神秘信箱，掉标记500101",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100201] = {
		["dropId"] = 50100201,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100301] = {
		["dropId"] = 50100301,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100401] = {
		["dropId"] = 50100401,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100501] = {
		["dropId"] = 50100501,
		["Name"] = "上锁的大宝箱",
		["foreverDrop"] = {{19062,10},{19012,10},{19017,10}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50100601] = {
		["dropId"] = 50100601,
		["Name"] = "神秘信箱，掉标记500201",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30900101] = {
		["dropId"] = 30900101,
		["Name"] = "打造材料2套",
		["foreverDrop"] = {{16002,1},{16005,1},{15101,10},{15102,10}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {12003},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40900101] = {
		["dropId"] = 40900101,
		["Name"] = "头盔",
		["foreverDrop"] = {{10108,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10106},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40900201] = {
		["dropId"] = 40900201,
		["Name"] = "升品碎片",
		["foreverDrop"] = {{19011,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19061},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50900101] = {
		["dropId"] = 50900101,
		["Name"] = "武器卷轴",
		["foreverDrop"] = {{16025,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {16025},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50900201] = {
		["dropId"] = 50900201,
		["Name"] = "铁矿石",
		["foreverDrop"] = {{15101,50}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {15101},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50900301] = {
		["dropId"] = 50900301,
		["Name"] = "银矿石",
		["foreverDrop"] = {{15102,50}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[10600101] = {
		["dropId"] = 10600101,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30600101] = {
		["dropId"] = 30600101,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"gold",1000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30600201] = {
		["dropId"] = 30600201,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"teamexp",30}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40600101] = {
		["dropId"] = 40600101,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"gold",5000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40600201] = {
		["dropId"] = 40600201,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"gold",5000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40600301] = {
		["dropId"] = 40600301,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"teamexp",60}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50600101] = {
		["dropId"] = 50600101,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"gold",8000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50600201] = {
		["dropId"] = 50600201,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"teamexp",125}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50600301] = {
		["dropId"] = 50600301,
		["Name"] = "地图怪奖励",
		["foreverDrop"] = {{"teamexp",560}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[402001011] = {
		["dropId"] = 402001011,
		["Name"] = "项链",
		["foreverDrop"] = {{10128,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10128},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[402001012] = {
		["dropId"] = 402001012,
		["Name"] = "戒指",
		["foreverDrop"] = {{10123,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10123},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[402002011] = {
		["dropId"] = 402002011,
		["Name"] = "项链",
		["foreverDrop"] = {{10130,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10130},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[402002012] = {
		["dropId"] = 402002012,
		["Name"] = "戒指",
		["foreverDrop"] = {{10125,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10125},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[502001011] = {
		["dropId"] = 502001011,
		["Name"] = "金钥匙",
		["foreverDrop"] = {{"gold",1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19204},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[502001012] = {
		["dropId"] = 502001012,
		["Name"] = "铜钥匙",
		["foreverDrop"] = {{"gold",1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19204},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[502002011] = {
		["dropId"] = 502002011,
		["Name"] = "神圣钢盔",
		["foreverDrop"] = {{10139,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10139},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[502002012] = {
		["dropId"] = 502002012,
		["Name"] = "圣灵钢盔",
		["foreverDrop"] = {{10140,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {10110},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11101] = {
		["dropId"] = 11101,
		["Name"] = "挂机点1",
		["foreverDrop"] = {{15101,5},{15102,5}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11102] = {
		["dropId"] = 11102,
		["Name"] = "挂机点2",
		["foreverDrop"] = {{15101,5},{15102,5}},
		["number"] = {{1,6}},
		["tepy1"] = {16001,1,1,0},
		["tepy2"] = {16002,1,1,0},
		["tepy3"] = {16003,1,1,0},
		["tepy4"] = {16004,1,1,0},
		["tepy5"] = {16005,1,1,0},
		["tepy6"] = {16006,1,1,0},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11103] = {
		["dropId"] = 11103,
		["Name"] = "挂机点3",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16007,1,1,1},
		["tepy2"] = {16008,1,1,1},
		["tepy3"] = {16009,1,1,1},
		["tepy4"] = {16010,1,1,1},
		["tepy5"] = {16011,1,1,1},
		["tepy6"] = {16012,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11104] = {
		["dropId"] = 11104,
		["Name"] = "挂机点4",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16013,1,1,1},
		["tepy2"] = {16014,1,1,1},
		["tepy3"] = {16015,1,1,1},
		["tepy4"] = {16016,1,1,1},
		["tepy5"] = {16017,1,1,1},
		["tepy6"] = {16018,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11105] = {
		["dropId"] = 11105,
		["Name"] = "挂机点5",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16001,1,1,1},
		["tepy2"] = {16002,1,1,1},
		["tepy3"] = {16003,1,1,1},
		["tepy4"] = {16004,1,1,1},
		["tepy5"] = {16005,1,1,1},
		["tepy6"] = {16006,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11106] = {
		["dropId"] = 11106,
		["Name"] = "挂机点6",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16001,1,1,1},
		["tepy2"] = {16002,1,1,1},
		["tepy3"] = {16003,1,1,1},
		["tepy4"] = {16004,1,1,1},
		["tepy5"] = {16005,1,1,1},
		["tepy6"] = {16006,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11107] = {
		["dropId"] = 11107,
		["Name"] = "挂机点7",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16001,1,1,1},
		["tepy2"] = {16002,1,1,1},
		["tepy3"] = {16003,1,1,1},
		["tepy4"] = {16004,1,1,1},
		["tepy5"] = {16005,1,1,1},
		["tepy6"] = {16006,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[11108] = {
		["dropId"] = 11108,
		["Name"] = "挂机点8",
		["foreverDrop"] = {{15101,10},{15102,10}},
		["number"] = {{2,6}},
		["tepy1"] = {16001,1,1,1},
		["tepy2"] = {16002,1,1,1},
		["tepy3"] = {16003,1,1,1},
		["tepy4"] = {16004,1,1,1},
		["tepy5"] = {16005,1,1,1},
		["tepy6"] = {16006,1,1,1},
		["dropNum"] = 1,
		["Showitem"] = {15101,15102},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30900201] = {
		["dropId"] = 30900201,
		["Name"] = "英雄石像的宝藏",
		["foreverDrop"] = {{"gold",10000},{10124,1},{16004,1},{16006,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[30600301] = {
		["dropId"] = 30600301,
		["Name"] = "新加的大小怪之大怪",
		["foreverDrop"] = {{"teamexp",60}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[50600102] = {
		["dropId"] = 50600102,
		["Name"] = "新加的怪物集团",
		["foreverDrop"] = {{"teamexp",1300}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100101] = {
		["dropId"] = 40100101,
		["Name"] = "骑士战靴",
		["foreverDrop"] = {{10118,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100102] = {
		["dropId"] = 40100102,
		["Name"] = "铁矿石",
		["foreverDrop"] = {{15101,6}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100103] = {
		["dropId"] = 40100103,
		["Name"] = "铁矿石",
		["foreverDrop"] = {{15101,4}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100104] = {
		["dropId"] = 40100104,
		["Name"] = "武器卷轴",
		["foreverDrop"] = {{16007,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100105] = {
		["dropId"] = 40100105,
		["Name"] = "鞋子卷轴",
		["foreverDrop"] = {{16010,1}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100106] = {
		["dropId"] = 40100106,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",5000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100107] = {
		["dropId"] = 40100107,
		["Name"] = "金钱袋",
		["foreverDrop"] = {{"gold",10000}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
	[40100108] = {
		["dropId"] = 40100108,
		["Name"] = "经验药水",
		["foreverDrop"] = {{12004,2}},
		["number"] = {{0,10000}},
		["dropNum"] = 1,
		["Showitem"] = {19202},
		["IfShowR"] = 1,
		["Enabled"] = {1,2,0},
	},
},
};


return drop[1]
