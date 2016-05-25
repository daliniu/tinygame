-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["summons"] = 1,
};

sheetindex = {
[1] = "summons",
};

local summons = {
[1] = {
	[20001] = {
		["id"] = 20001,
		["name"] = "狮鹫骑士",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2002,
	},
	[20002] = {
		["id"] = 20002,
		["name"] = "狮鹫兽",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2001,
	},
	[20003] = {
		["id"] = 20003,
		["name"] = "石像鬼",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2004,
	},
	[20004] = {
		["id"] = 20004,
		["name"] = "恶魔",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2004,
	},
	[20005] = {
		["id"] = 20005,
		["name"] = "狮鹫兽",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2003,
	},
	[20006] = {
		["id"] = 20006,
		["name"] = "狮鹫兽",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2002,
	},
	[20007] = {
		["id"] = 20007,
		["name"] = "美杜莎",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2003,
	},
	[20008] = {
		["id"] = 20008,
		["name"] = "石像鬼",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2004,
	},
	[20009] = {
		["id"] = 20009,
		["name"] = "火蜥蜴",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2005,
	},
	[20010] = {
		["id"] = 20010,
		["name"] = "巨虎",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2006,
	},
	[20011] = {
		["id"] = 20011,
		["name"] = "蘑菇军团",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2007,
	},
	[20012] = {
		["id"] = 20012,
		["name"] = "火焰虎",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2008,
	},
	[20013] = {
		["id"] = 20013,
		["name"] = "巨蜥",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2009,
	},
	[20014] = {
		["id"] = 20014,
		["name"] = "狮人",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2010,
	},
	[20015] = {
		["id"] = 20015,
		["name"] = "食人花",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2011,
	},
	[20016] = {
		["id"] = 20016,
		["name"] = "火元素",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2012,
	},
	[20017] = {
		["id"] = 20017,
		["name"] = "水元素",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2013,
	},
	[20018] = {
		["id"] = 20018,
		["name"] = "树精卫士",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2014,
	},
	[20019] = {
		["id"] = 20019,
		["name"] = "地狱犬",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2015,
	},
	[20020] = {
		["id"] = 20020,
		["name"] = "熔岩巨人",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2016,
	},
	[20021] = {
		["id"] = 20021,
		["name"] = "伊芙利特",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2017,
	},
	[20022] = {
		["id"] = 20022,
		["name"] = "石巨人",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2018,
	},
	[20023] = {
		["id"] = 20023,
		["name"] = "天空龙",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2019,
	},
	[20024] = {
		["id"] = 20024,
		["name"] = "死亡骑士",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2020,
	},
	[20025] = {
		["id"] = 20025,
		["name"] = "凤凰",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2021,
	},
	[20026] = {
		["id"] = 20026,
		["name"] = "恶魔领主",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2022,
	},
	[20027] = {
		["id"] = 20027,
		["name"] = "光灵",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2023,
	},
	[20028] = {
		["id"] = 20028,
		["name"] = "史莱姆",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2024,
	},
	[20029] = {
		["id"] = 20029,
		["name"] = "骷髅兵",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2025,
	},
	[20030] = {
		["id"] = 20030,
		["name"] = "血魔花",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2026,
	},
	[20031] = {
		["id"] = 20031,
		["name"] = "独角兽",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2027,
	},
	[20032] = {
		["id"] = 20032,
		["name"] = "小火龙",
		["hp"] = 1000,
		["atk"] = 550,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2028,
	},
	[20033] = {
		["id"] = 20033,
		["name"] = "鲛人",
		["hp"] = 350,
		["atk"] = 150,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2029,
	},
	[20034] = {
		["id"] = 20034,
		["name"] = "光元素",
		["hp"] = 200,
		["atk"] = 100,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2030,
	},
	[20035] = {
		["id"] = 20035,
		["name"] = "食尸鬼",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2031,
	},
	[20036] = {
		["id"] = 20036,
		["name"] = "斯芬克斯",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2032,
	},
	[20037] = {
		["id"] = 20037,
		["name"] = "九头蛇",
		["hp"] = 1500,
		["atk"] = 1000,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2033,
	},
	[20038] = {
		["id"] = 20038,
		["name"] = "炽天使",
		["hp"] = 2000,
		["atk"] = 1000,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2034,
	},
	[20039] = {
		["id"] = 20039,
		["name"] = "麒麟",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2035,
	},
	[20040] = {
		["id"] = 20040,
		["name"] = "比蒙巨兽",
		["hp"] = 250,
		["atk"] = 200,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2036,
	},
	[20041] = {
		["id"] = 20041,
		["name"] = "古龙",
		["hp"] = 900,
		["atk"] = 800,
		["defense"] = 50,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 2,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2037,
	},
	[20042] = {
		["id"] = 20042,
		["name"] = "九头蛇",
		["hp"] = 300,
		["atk"] = 650,
		["defense"] = 0,
		["reducehurt"] = 0,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 3,
		["skillid"] = {40005,0},
		["conskillid"] = {40002,0},
		["modelid"] = 2033,
	},
	[20043] = {
		["id"] = 20043,
		["name"] = "食尸鬼",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2031,
	},
	[20044] = {
		["id"] = 20044,
		["name"] = "死亡骑士",
		["hp"] = 380,
		["atk"] = 150,
		["defense"] = 0,
		["reducehurt"] = 10,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 4,
		["skillid"] = {40005,0},
		["conskillid"] = {40001,0},
		["modelid"] = 2020,
	},
	[20045] = {
		["id"] = 20045,
		["name"] = "恶魔领主",
		["hp"] = 200,
		["atk"] = 180,
		["defense"] = 30,
		["reducehurt"] = 20,
		["penetrationlevel"] = 0,
		["increase_hurt"] = 0,
		["critlevel"] = 0,
		["critrate"] = 0,
		["tenacitylevel"] = 0,
		["anticrit_rate"] = 0,
		["hitlevel"] = 0,
		["hits"] = 90,
		["dodgelevel"] = 0,
		["dodgerate"] = 10,
		["cost"] = 1,
		["skillid"] = {40005,0},
		["conskillid"] = {40003,0},
		["modelid"] = 2022,
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

local tbConfig = gf_CopyTable(summons[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;