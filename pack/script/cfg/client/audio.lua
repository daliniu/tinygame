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

local audio = {
[1] = {
	[1001] = {
		["ID"] = 1001,
		["data"] = "战斗背景音乐1",
		["type"] = 1,
		["loop"] = 1,
		["path"] = "res/audio/background/audio_bg_fight_01",
	},
	[1002] = {
		["ID"] = 1002,
		["data"] = "战斗背景音乐2",
		["type"] = 1,
		["loop"] = 1,
		["path"] = "res/audio/background/audio_bg_fight_02",
	},
	[1003] = {
		["ID"] = 1003,
		["data"] = "主界面背景音乐1",
		["type"] = 1,
		["loop"] = 1,
		["path"] = "res/audio/background/audio_bg_main_01",
	},
	[1004] = {
		["ID"] = 1004,
		["data"] = "地图背景音乐1",
		["type"] = 1,
		["loop"] = 1,
		["path"] = "res/audio/background/audio_bg_map_01",
	},
	[2001] = {
		["ID"] = 2001,
		["data"] = "增加水晶1",
		["type"] = 2,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_special_addcristal_01",
	},
	[2002] = {
		["ID"] = 2002,
		["data"] = "按键音1",
		["type"] = 2,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_special_button_01",
	},
	[2003] = {
		["ID"] = 2003,
		["data"] = "按键音2",
		["type"] = 2,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_special_button_02",
	},
	[2004] = {
		["ID"] = 2004,
		["data"] = "升级音效",
		["type"] = 2,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_special_upgrade_01",
	},
	[3001] = {
		["ID"] = 3001,
		["data"] = "连携角色特效音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_combo_role_01",
	},
	[3002] = {
		["ID"] = 3002,
		["data"] = "暗杀特效音效1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_assination_01",
	},
	[3003] = {
		["ID"] = 3003,
		["data"] = "血腥风暴特效音效1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_bloodstorm_01",
	},
	[3004] = {
		["ID"] = 3004,
		["data"] = "暗系特效2音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_dark_02",
	},
	[3005] = {
		["ID"] = 3005,
		["data"] = "末日烈焰特效音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_doomfire_01",
	},
	[3006] = {
		["ID"] = 3006,
		["data"] = "火系特效2音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_fire_02",
	},
	[3007] = {
		["ID"] = 3007,
		["data"] = "神之怒特效音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_godanger_01",
	},
	[3008] = {
		["ID"] = 3008,
		["data"] = "雷神之锤特效音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_godhammer_01",
	},
	[3009] = {
		["ID"] = 3009,
		["data"] = "圣系特效1音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_holy_01",
	},
	[3010] = {
		["ID"] = 3010,
		["data"] = "圣系特效2音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_holy_02",
	},
	[3011] = {
		["ID"] = 3011,
		["data"] = "圣系特效3音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_holy_03",
	},
	[3012] = {
		["ID"] = 3012,
		["data"] = "勇气护盾特效音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_holyshield_01",
	},
	[3013] = {
		["ID"] = 3013,
		["data"] = "自然特效3音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_nature_03",
	},
	[3014] = {
		["ID"] = 3014,
		["data"] = "自然特效4音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_nature_04",
	},
	[3015] = {
		["ID"] = 3015,
		["data"] = "物理特效2音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_strike_02",
	},
	[3016] = {
		["ID"] = 3016,
		["data"] = "物理特效3音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_strike_03",
	},
	[3017] = {
		["ID"] = 3017,
		["data"] = "物理特效4音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_strike_04",
	},
	[3018] = {
		["ID"] = 3018,
		["data"] = "水系特效1音乐1",
		["type"] = 3,
		["loop"] = 1,
		["path"] = "res/audio/effect/audio_skill_water_01",
	},
},
};


return audio[1]
