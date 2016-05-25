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

local picture = {
[1] = {
	["b0_0111001"] = {
		["PicId"] = "b0_0111001",
		["Path"] = "res/map/building/00_chest_001.png",
	},
	["b0_0111002"] = {
		["PicId"] = "b0_0111002",
		["Path"] = "res/map/building/00_chest_002.png",
	},
	["b0_0111003"] = {
		["PicId"] = "b0_0111003",
		["Path"] = "res/map/building/00_chest_003.png",
	},
	["b0_0111004"] = {
		["PicId"] = "b0_0111004",
		["Path"] = "res/map/building/00_chest_004.png",
	},
	["b0_0111005"] = {
		["PicId"] = "b0_0111005",
		["Path"] = "res/map/building/00_chest_005.png",
	},
	["b0_0111006"] = {
		["PicId"] = "b0_0111006",
		["Path"] = "res/map/building/00_chest_006.png",
	},
	["b0_0211001"] = {
		["PicId"] = "b0_0211001",
		["Path"] = "res/map/building/00_chestchoo_001.png",
		["None"] = "袋子",
	},
	["b0_0211002"] = {
		["PicId"] = "b0_0211002",
		["Path"] = "res/map/building/00_chestchoo_002.png",
		["None"] = "盒子",
	},
	["b0_1811001"] = {
		["PicId"] = "b0_1811001",
		["Path"] = "res/map/building/00_postbox_001.png",
	},
	["b1_1211001"] = {
		["PicId"] = "b1_1211001",
		["Path"] = "res/map/building/01_buff_001.png",
	},
	["b1_1011001"] = {
		["PicId"] = "b1_1011001",
		["Path"] = "res/map/building/01_exit_001.png",
	},
	["b1_0322001"] = {
		["PicId"] = "b1_0322001",
		["Path"] = "res/map/building/01_guaji_001.png",
		["None"] = "祭坛型",
	},
	["b1_0322002"] = {
		["PicId"] = "b1_0322002",
		["Path"] = "res/map/building/01_guaji_002.png",
		["None"] = "练武场",
	},
	["b1_0333001"] = {
		["PicId"] = "b1_0333001",
		["Path"] = "res/map/building/01_guaji_003.png",
	},
	["b1_1522001"] = {
		["PicId"] = "b1_1522001",
		["Path"] = "res/map/building/01_shop_001.png",
	},
	["b1_1522002"] = {
		["PicId"] = "b1_1522002",
		["Path"] = "res/map/building/01_shop_002.png",
	},
	["b1_1522003"] = {
		["PicId"] = "b1_1522003",
		["Path"] = "res/map/building/01_shop_003.png",
	},
	["b1_1122001"] = {
		["PicId"] = "b1_1122001",
		["Path"] = "res/map/building/01_supply_001.png",
	},
	["b1_0922001"] = {
		["PicId"] = "b1_0922001",
		["Path"] = "res/map/building/01_unknow_001.png",
	},
	["b1_0922002"] = {
		["PicId"] = "b1_0922002",
		["Path"] = "res/map/building/01_unknow_002.png",
	},
	["b1_1611001"] = {
		["PicId"] = "b1_1611001",
		["Path"] = "res/map/building/01_watchtower_001.png",
	},
	["b2_1211001"] = {
		["PicId"] = "b2_1211001",
		["Path"] = "res/map/building/02_buff_001.png",
	},
	["b2_1011001"] = {
		["PicId"] = "b2_1011001",
		["Path"] = "res/map/building/02_exit_001.png",
	},
	["b2_0322001"] = {
		["PicId"] = "b2_0322001",
		["Path"] = "res/map/building/02_guaji_001.png",
	},
	["b2_0333001"] = {
		["PicId"] = "b2_0333001",
		["Path"] = "res/map/building/02_guaji_002.png",
	},
	["b2_1522001"] = {
		["PicId"] = "b2_1522001",
		["Path"] = "res/map/building/02_shop_001.png",
	},
	["b2_0922001"] = {
		["PicId"] = "b2_0922001",
		["Path"] = "res/map/building/02_unknow_001.png",
	},
	["b2_0922002"] = {
		["PicId"] = "b2_0922002",
		["Path"] = "res/map/building/02_unknow_002.png",
	},
	["b2_0922003"] = {
		["PicId"] = "b2_0922003",
		["Path"] = "res/map/building/02_unknow_003.png",
	},
	["b2_1611001"] = {
		["PicId"] = "b2_1611001",
		["Path"] = "res/map/building/02_watchtower_001.png",
	},
	["b3_0333001"] = {
		["PicId"] = "b3_0333001",
		["Path"] = "res/map/building/03_guaji_001.png",
		["None"] = "水车",
	},
	["b3_0333002"] = {
		["PicId"] = "b3_0333002",
		["Path"] = "res/map/building/03_guaji_002.png",
		["None"] = "大树叶",
	},
	["b3_1522001"] = {
		["PicId"] = "b3_1522001",
		["Path"] = "res/map/building/03_shop_001.png",
	},
	["b3_0922001"] = {
		["PicId"] = "b3_0922001",
		["Path"] = "res/map/building/03_unknow_001.png",
		["None"] = "风车大",
	},
	["b3_0922002"] = {
		["PicId"] = "b3_0922002",
		["Path"] = "res/map/building/03_unknow_002.png",
		["None"] = "风车小",
	},
	["b3_0922003"] = {
		["PicId"] = "b3_0922003",
		["Path"] = "res/map/building/03_unknow_003.png",
		["None"] = "圆水槽",
	},
	["b3_0922004"] = {
		["PicId"] = "b3_0922004",
		["Path"] = "res/map/building/03_unknow_004.png",
		["None"] = "矮，木桶",
	},
	["b3_0922005"] = {
		["PicId"] = "b3_0922005",
		["Path"] = "res/map/building/03_unknow_005.png",
		["None"] = "木屋",
	},
	["b5_1211001"] = {
		["PicId"] = "b5_1211001",
		["Path"] = "res/map/building/05_buff_001.png",
	},
	["b5_1211002"] = {
		["PicId"] = "b5_1211002",
		["Path"] = "res/map/building/05_buff_002.png",
	},
	["b5_0344001"] = {
		["PicId"] = "b5_0344001",
		["Path"] = "res/map/building/05_guaji_001.png",
	},
	["b5_1122001"] = {
		["PicId"] = "b5_1122001",
		["Path"] = "res/map/building/05_supply_001.png",
	},
	["b5_0922001"] = {
		["PicId"] = "b5_0922001",
		["Path"] = "res/map/building/05_unknow_001.png",
	},
	["b5_0922002"] = {
		["PicId"] = "b5_0922002",
		["Path"] = "res/map/building/05_unknow_002.png",
	},
	["b5_1611001"] = {
		["PicId"] = "b5_1611001",
		["Path"] = "res/map/building/05_watchtower_001.png",
	},
	["o1_do32001"] = {
		["PicId"] = "o1_do32001",
		["Path"] = "res/map/surface/01_obs_down_001.png",
	},
	["o1_do22002"] = {
		["PicId"] = "o1_do22002",
		["Path"] = "res/map/surface/01_obs_down_002.png",
	},
	["o1_do22003"] = {
		["PicId"] = "o1_do22003",
		["Path"] = "res/map/surface/01_obs_down_003.png",
	},
	["o1_do22004"] = {
		["PicId"] = "o1_do22004",
		["Path"] = "res/map/surface/01_obs_down_004.png",
	},
	["o1_do11005"] = {
		["PicId"] = "o1_do11005",
		["Path"] = "res/map/surface/01_obs_down_005.png",
	},
	["o1_do11006"] = {
		["PicId"] = "o1_do11006",
		["Path"] = "res/map/surface/01_obs_down_006.png",
	},
	["o1_do12007"] = {
		["PicId"] = "o1_do12007",
		["Path"] = "res/map/surface/01_obs_down_007.png",
	},
	["o1_do12008"] = {
		["PicId"] = "o1_do12008",
		["Path"] = "res/map/surface/01_obs_down_008.png",
	},
	["o1_gl11001"] = {
		["PicId"] = "o1_gl11001",
		["Path"] = "res/map/surface/01_obs_grass_001.png",
	},
	["o1_gl11002"] = {
		["PicId"] = "o1_gl11002",
		["Path"] = "res/map/surface/01_obs_grass_002.png",
	},
	["o1_gl11003"] = {
		["PicId"] = "o1_gl11003",
		["Path"] = "res/map/surface/01_obs_grass_003.png",
	},
	["o1_gl11004"] = {
		["PicId"] = "o1_gl11004",
		["Path"] = "res/map/surface/01_obs_grass_004.png",
	},
	["o1_gl11005"] = {
		["PicId"] = "o1_gl11005",
		["Path"] = "res/map/surface/01_obs_grass_005.png",
	},
	["o1_gl11006"] = {
		["PicId"] = "o1_gl11006",
		["Path"] = "res/map/surface/01_obs_grass_006.png",
	},
	["o1_gl11007"] = {
		["PicId"] = "o1_gl11007",
		["Path"] = "res/map/surface/01_obs_grass_007.png",
	},
	["o1_gl11008"] = {
		["PicId"] = "o1_gl11008",
		["Path"] = "res/map/surface/01_obs_grass_008.png",
	},
	["o1_gl11009"] = {
		["PicId"] = "o1_gl11009",
		["Path"] = "res/map/surface/01_obs_grass_009.png",
	},
	["o1_gl11010"] = {
		["PicId"] = "o1_gl11010",
		["Path"] = "res/map/surface/01_obs_grass_010.png",
	},
	["o1_gl11011"] = {
		["PicId"] = "o1_gl11011",
		["Path"] = "res/map/surface/01_obs_grass_011.png",
	},
	["o1_ow11001"] = {
		["PicId"] = "o1_ow11001",
		["Path"] = "res/map/surface/01_obs_other_001.png",
	},
	["o1_ow11002"] = {
		["PicId"] = "o1_ow11002",
		["Path"] = "res/map/surface/01_obs_other_002.png",
	},
	["o1_ow11003"] = {
		["PicId"] = "o1_ow11003",
		["Path"] = "res/map/surface/01_obs_other_003.png",
	},
	["o1_ow11004"] = {
		["PicId"] = "o1_ow11004",
		["Path"] = "res/map/surface/01_obs_other_004.png",
	},
	["o1_ow11005"] = {
		["PicId"] = "o1_ow11005",
		["Path"] = "res/map/surface/01_obs_other_005.png",
	},
	["o1_ow11006"] = {
		["PicId"] = "o1_ow11006",
		["Path"] = "res/map/surface/01_obs_other_006.png",
	},
	["o1_ol11007"] = {
		["PicId"] = "o1_ol11007",
		["Path"] = "res/map/surface/01_obs_other_007.png",
	},
	["o1_ol11008"] = {
		["PicId"] = "o1_ol11008",
		["Path"] = "res/map/surface/01_obs_other_008.png",
	},
	["o1_ol11009"] = {
		["PicId"] = "o1_ol11009",
		["Path"] = "res/map/surface/01_obs_other_009.png",
	},
	["o1_oj11010"] = {
		["PicId"] = "o1_oj11010",
		["Path"] = "res/map/surface/01_obs_other_010.png",
	},
	["o1_os11011"] = {
		["PicId"] = "o1_os11011",
		["Path"] = "res/map/surface/01_obs_other_011.png",
	},
	["o1_os11012"] = {
		["PicId"] = "o1_os11012",
		["Path"] = "res/map/surface/01_obs_other_012.png",
	},
	["o1_os11013"] = {
		["PicId"] = "o1_os11013",
		["Path"] = "res/map/surface/01_obs_other_013.png",
	},
	["o1_os11014"] = {
		["PicId"] = "o1_os11014",
		["Path"] = "res/map/surface/01_obs_other_014.png",
	},
	["o1_os11015"] = {
		["PicId"] = "o1_os11015",
		["Path"] = "res/map/surface/01_obs_other_015.png",
	},
	["o1_os33016"] = {
		["PicId"] = "o1_os33016",
		["Path"] = "res/map/surface/01_obs_other_016.png",
	},
	["o1_os12017"] = {
		["PicId"] = "o1_os12017",
		["Path"] = "res/map/surface/01_obs_other_017.png",
	},
	["o1_oz11018"] = {
		["PicId"] = "o1_oz11018",
		["Path"] = "res/map/surface/01_obs_other_018.png",
	},
	["o1_oz11019"] = {
		["PicId"] = "o1_oz11019",
		["Path"] = "res/map/surface/01_obs_other_019.png",
	},
	["o1_oj11020"] = {
		["PicId"] = "o1_oj11020",
		["Path"] = "res/map/surface/01_obs_other_020.png",
	},
	["o1_oj11021"] = {
		["PicId"] = "o1_oj11021",
		["Path"] = "res/map/surface/01_obs_other_021.png",
	},
	["o1_oj11022"] = {
		["PicId"] = "o1_oj11022",
		["Path"] = "res/map/surface/01_obs_other_022.png",
	},
	["o1_oj11023"] = {
		["PicId"] = "o1_oj11023",
		["Path"] = "res/map/surface/01_obs_other_023.png",
	},
	["o1_oj11024"] = {
		["PicId"] = "o1_oj11024",
		["Path"] = "res/map/surface/01_obs_other_024.png",
	},
	["o1_ow11025"] = {
		["PicId"] = "o1_ow11025",
		["Path"] = "res/map/surface/01_obs_other_025.png",
	},
	["o1_ow11026"] = {
		["PicId"] = "o1_ow11026",
		["Path"] = "res/map/surface/01_obs_other_026.png",
	},
	["o1_ow11027"] = {
		["PicId"] = "o1_ow11027",
		["Path"] = "res/map/surface/01_obs_other_027.png",
	},
	["o1_sh11001"] = {
		["PicId"] = "o1_sh11001",
		["Path"] = "res/map/surface/01_obs_stone_001.png",
	},
	["o1_sh11002"] = {
		["PicId"] = "o1_sh11002",
		["Path"] = "res/map/surface/01_obs_stone_002.png",
	},
	["o1_sh11003"] = {
		["PicId"] = "o1_sh11003",
		["Path"] = "res/map/surface/01_obs_stone_003.png",
	},
	["o1_sh11004"] = {
		["PicId"] = "o1_sh11004",
		["Path"] = "res/map/surface/01_obs_stone_004.png",
	},
	["o1_sh11005"] = {
		["PicId"] = "o1_sh11005",
		["Path"] = "res/map/surface/01_obs_stone_005.png",
	},
	["o1_sh11006"] = {
		["PicId"] = "o1_sh11006",
		["Path"] = "res/map/surface/01_obs_stone_006.png",
	},
	["o1_sh11007"] = {
		["PicId"] = "o1_sh11007",
		["Path"] = "res/map/surface/01_obs_stone_007.png",
	},
	["o1_sh11008"] = {
		["PicId"] = "o1_sh11008",
		["Path"] = "res/map/surface/01_obs_stone_008.png",
	},
	["o1_sl11009"] = {
		["PicId"] = "o1_sl11009",
		["Path"] = "res/map/surface/01_obs_stone_009.png",
	},
	["o1_sl11010"] = {
		["PicId"] = "o1_sl11010",
		["Path"] = "res/map/surface/01_obs_stone_010.png",
	},
	["o1_sl11011"] = {
		["PicId"] = "o1_sl11011",
		["Path"] = "res/map/surface/01_obs_stone_011.png",
	},
	["o1_sl11012"] = {
		["PicId"] = "o1_sl11012",
		["Path"] = "res/map/surface/01_obs_stone_012.png",
	},
	["o1_sl11013"] = {
		["PicId"] = "o1_sl11013",
		["Path"] = "res/map/surface/01_obs_stone_013.png",
	},
	["o1_sh11014"] = {
		["PicId"] = "o1_sh11014",
		["Path"] = "res/map/surface/01_obs_stone_014.png",
	},
	["o1_sh11015"] = {
		["PicId"] = "o1_sh11015",
		["Path"] = "res/map/surface/01_obs_stone_015.png",
	},
	["o1_sh11016"] = {
		["PicId"] = "o1_sh11016",
		["Path"] = "res/map/surface/01_obs_stone_016.png",
	},
	["o1_sl11017"] = {
		["PicId"] = "o1_sl11017",
		["Path"] = "res/map/surface/01_obs_stone_017.png",
	},
	["o1_sl11018"] = {
		["PicId"] = "o1_sl11018",
		["Path"] = "res/map/surface/01_obs_stone_018.png",
	},
	["o1_sl11019"] = {
		["PicId"] = "o1_sl11019",
		["Path"] = "res/map/surface/01_obs_stone_019.png",
	},
	["o1_sl11020"] = {
		["PicId"] = "o1_sl11020",
		["Path"] = "res/map/surface/01_obs_stone_020.png",
	},
	["o1_sl11021"] = {
		["PicId"] = "o1_sl11021",
		["Path"] = "res/map/surface/01_obs_stone_021.png",
	},
	["o1_sl11022"] = {
		["PicId"] = "o1_sl11022",
		["Path"] = "res/map/surface/01_obs_stone_022.png",
	},
	["o1_sl11023"] = {
		["PicId"] = "o1_sl11023",
		["Path"] = "res/map/surface/01_obs_stone_023.png",
	},
	["o1_sl11024"] = {
		["PicId"] = "o1_sl11024",
		["Path"] = "res/map/surface/01_obs_stone_024.png",
	},
	["o1_sl11025"] = {
		["PicId"] = "o1_sl11025",
		["Path"] = "res/map/surface/01_obs_stone_025.png",
	},
	["o1_sl11026"] = {
		["PicId"] = "o1_sl11026",
		["Path"] = "res/map/surface/01_obs_stone_026.png",
	},
	["o1_sl11027"] = {
		["PicId"] = "o1_sl11027",
		["Path"] = "res/map/surface/01_obs_stone_027.png",
	},
	["o1_sl11028"] = {
		["PicId"] = "o1_sl11028",
		["Path"] = "res/map/surface/01_obs_stone_028.png",
	},
	["o1_sh11029"] = {
		["PicId"] = "o1_sh11029",
		["Path"] = "res/map/surface/01_obs_stone_029.png",
	},
	["o1_sh11030"] = {
		["PicId"] = "o1_sh11030",
		["Path"] = "res/map/surface/01_obs_stone_030.png",
	},
	["o1_sl11031"] = {
		["PicId"] = "o1_sl11031",
		["Path"] = "res/map/surface/01_obs_stone_031.png",
	},
	["o1_sl11032"] = {
		["PicId"] = "o1_sl11032",
		["Path"] = "res/map/surface/01_obs_stone_032.png",
	},
	["o1_tr11001"] = {
		["PicId"] = "o1_tr11001",
		["Path"] = "res/map/surface/01_obs_tree_001.png",
	},
	["o1_tr11002"] = {
		["PicId"] = "o1_tr11002",
		["Path"] = "res/map/surface/01_obs_tree_002.png",
	},
	["o1_tr11003"] = {
		["PicId"] = "o1_tr11003",
		["Path"] = "res/map/surface/01_obs_tree_003.png",
	},
	["o1_tr11004"] = {
		["PicId"] = "o1_tr11004",
		["Path"] = "res/map/surface/01_obs_tree_004.png",
	},
	["o1_tr11005"] = {
		["PicId"] = "o1_tr11005",
		["Path"] = "res/map/surface/01_obs_tree_005.png",
	},
	["o1_tr11006"] = {
		["PicId"] = "o1_tr11006",
		["Path"] = "res/map/surface/01_obs_tree_006.png",
	},
	["o1_tr11007"] = {
		["PicId"] = "o1_tr11007",
		["Path"] = "res/map/surface/01_obs_tree_007.png",
	},
	["o1_tr11008"] = {
		["PicId"] = "o1_tr11008",
		["Path"] = "res/map/surface/01_obs_tree_008.png",
	},
	["o1_tr11011"] = {
		["PicId"] = "o1_tr11011",
		["Path"] = "res/map/surface/01_obs_tree_011.png",
	},
	["o1_tr11012"] = {
		["PicId"] = "o1_tr11012",
		["Path"] = "res/map/surface/01_obs_tree_012.png",
	},
	["o1_tr11013"] = {
		["PicId"] = "o1_tr11013",
		["Path"] = "res/map/surface/01_obs_tree_013.png",
	},
	["o1_tr11014"] = {
		["PicId"] = "o1_tr11014",
		["Path"] = "res/map/surface/01_obs_tree_014.png",
	},
	["o1_tr11015"] = {
		["PicId"] = "o1_tr11015",
		["Path"] = "res/map/surface/01_obs_tree_015.png",
	},
	["o1_tr11016"] = {
		["PicId"] = "o1_tr11016",
		["Path"] = "res/map/surface/01_obs_tree_016.png",
	},
	["o1_tr11017"] = {
		["PicId"] = "o1_tr11017",
		["Path"] = "res/map/surface/01_obs_tree_017.png",
	},
	["o1_tr11018"] = {
		["PicId"] = "o1_tr11018",
		["Path"] = "res/map/surface/01_obs_tree_018.png",
	},
	["o2_do32001"] = {
		["PicId"] = "o2_do32001",
		["Path"] = "res/map/surface/02_obs_down_001.png",
	},
	["o2_do32002"] = {
		["PicId"] = "o2_do32002",
		["Path"] = "res/map/surface/02_obs_down_002.png",
	},
	["o2_do22003"] = {
		["PicId"] = "o2_do22003",
		["Path"] = "res/map/surface/02_obs_down_003.png",
	},
	["o2_do11004"] = {
		["PicId"] = "o2_do11004",
		["Path"] = "res/map/surface/02_obs_down_004.png",
	},
	["o2_do22005"] = {
		["PicId"] = "o2_do22005",
		["Path"] = "res/map/surface/02_obs_down_005.png",
	},
	["o2_do12006"] = {
		["PicId"] = "o2_do12006",
		["Path"] = "res/map/surface/02_obs_down_006.png",
	},
	["o2_gl11001"] = {
		["PicId"] = "o2_gl11001",
		["Path"] = "res/map/surface/02_obs_grass_001.png",
	},
	["o2_gl11002"] = {
		["PicId"] = "o2_gl11002",
		["Path"] = "res/map/surface/02_obs_grass_002.png",
	},
	["o2_gh11001"] = {
		["PicId"] = "o2_gh11001",
		["Path"] = "res/map/surface/02_obs_grass_003.png",
	},
	["o2_gh11002"] = {
		["PicId"] = "o2_gh11002",
		["Path"] = "res/map/surface/02_obs_grass_004.png",
	},
	["o2_gh11003"] = {
		["PicId"] = "o2_gh11003",
		["Path"] = "res/map/surface/02_obs_grass_005.png",
	},
	["o2_gh11004"] = {
		["PicId"] = "o2_gh11004",
		["Path"] = "res/map/surface/02_obs_grass_006.png",
	},
	["o2_gl11003"] = {
		["PicId"] = "o2_gl11003",
		["Path"] = "res/map/surface/02_obs_grass_007.png",
	},
	["o2_gl11004"] = {
		["PicId"] = "o2_gl11004",
		["Path"] = "res/map/surface/02_obs_grass_008.png",
	},
	["o2_gl11005"] = {
		["PicId"] = "o2_gl11005",
		["Path"] = "res/map/surface/02_obs_grass_009.png",
	},
	["o2_oj11001"] = {
		["PicId"] = "o2_oj11001",
		["Path"] = "res/map/surface/02_obs_other_001.png",
	},
	["o2_oj11002"] = {
		["PicId"] = "o2_oj11002",
		["Path"] = "res/map/surface/02_obs_other_002.png",
	},
	["o2_os33001"] = {
		["PicId"] = "o2_os33001",
		["Path"] = "res/map/surface/02_obs_other_003.png",
	},
	["o2_os22002"] = {
		["PicId"] = "o2_os22002",
		["Path"] = "res/map/surface/02_obs_other_004.png",
	},
	["o2_oz11001"] = {
		["PicId"] = "o2_oz11001",
		["Path"] = "res/map/surface/02_obs_other_005.png",
	},
	["o2_oz11002"] = {
		["PicId"] = "o2_oz11002",
		["Path"] = "res/map/surface/02_obs_other_006.png",
	},
	["o2_ow11001"] = {
		["PicId"] = "o2_ow11001",
		["Path"] = "res/map/surface/02_obs_other_007.png",
	},
	["o2_ow11002"] = {
		["PicId"] = "o2_ow11002",
		["Path"] = "res/map/surface/02_obs_other_008.png",
	},
	["o2_ol11001"] = {
		["PicId"] = "o2_ol11001",
		["Path"] = "res/map/surface/02_obs_other_009.png",
	},
	["o2_ol11002"] = {
		["PicId"] = "o2_ol11002",
		["Path"] = "res/map/surface/02_obs_other_010.png",
	},
	["o2_ow11003"] = {
		["PicId"] = "o2_ow11003",
		["Path"] = "res/map/surface/02_obs_other_011.png",
	},
	["o2_ow11004"] = {
		["PicId"] = "o2_ow11004",
		["Path"] = "res/map/surface/02_obs_other_012.png",
	},
	["o2_ow11005"] = {
		["PicId"] = "o2_ow11005",
		["Path"] = "res/map/surface/02_obs_other_013.png",
	},
	["o2_ow11006"] = {
		["PicId"] = "o2_ow11006",
		["Path"] = "res/map/surface/02_obs_other_014.png",
	},
	["o2_sh11001"] = {
		["PicId"] = "o2_sh11001",
		["Path"] = "res/map/surface/02_obs_stone_001.png",
	},
	["o2_sh11002"] = {
		["PicId"] = "o2_sh11002",
		["Path"] = "res/map/surface/02_obs_stone_002.png",
	},
	["o2_sl11001"] = {
		["PicId"] = "o2_sl11001",
		["Path"] = "res/map/surface/02_obs_stone_003.png",
	},
	["o2_sl11002"] = {
		["PicId"] = "o2_sl11002",
		["Path"] = "res/map/surface/02_obs_stone_004.png",
	},
	["o2_sl11003"] = {
		["PicId"] = "o2_sl11003",
		["Path"] = "res/map/surface/02_obs_stone_005.png",
	},
	["o2_sl11004"] = {
		["PicId"] = "o2_sl11004",
		["Path"] = "res/map/surface/02_obs_stone_006.png",
	},
	["o2_tr22001"] = {
		["PicId"] = "o2_tr22001",
		["Path"] = "res/map/surface/02_obs_tree_001.png",
	},
	["o2_tr22002"] = {
		["PicId"] = "o2_tr22002",
		["Path"] = "res/map/surface/02_obs_tree_002.png",
	},
	["o2_tr11003"] = {
		["PicId"] = "o2_tr11003",
		["Path"] = "res/map/surface/02_obs_tree_003.png",
	},
	["o2_tr11004"] = {
		["PicId"] = "o2_tr11004",
		["Path"] = "res/map/surface/02_obs_tree_004.png",
	},
	["o3_ow22001"] = {
		["PicId"] = "o3_ow22001",
		["Path"] = "res/map/surface/03_obs_other_001.png",
	},
	["o3_ow22002"] = {
		["PicId"] = "o3_ow22002",
		["Path"] = "res/map/surface/03_obs_other_002.png",
	},
	["o3_ow22003"] = {
		["PicId"] = "o3_ow22003",
		["Path"] = "res/map/surface/03_obs_other_003.png",
	},
	["o3_ow22004"] = {
		["PicId"] = "o3_ow22004",
		["Path"] = "res/map/surface/03_obs_other_004.png",
	},
	["o3_ow11005"] = {
		["PicId"] = "o3_ow11005",
		["Path"] = "res/map/surface/03_obs_other_005.png",
	},
	["o3_ow11006"] = {
		["PicId"] = "o3_ow11006",
		["Path"] = "res/map/surface/03_obs_other_006.png",
	},
	["o3_ow11007"] = {
		["PicId"] = "o3_ow11007",
		["Path"] = "res/map/surface/03_obs_other_007.png",
	},
	["03_ob11001"] = {
		["PicId"] = "03_ob11001",
		["Path"] = "res/map/surface/03_obs_other_008.png",
	},
	["03_ob11002"] = {
		["PicId"] = "03_ob11002",
		["Path"] = "res/map/surface/03_obs_other_009.png",
	},
	["03_ob22003"] = {
		["PicId"] = "03_ob22003",
		["Path"] = "res/map/surface/03_obs_other_010.png",
	},
	["03_ob22004"] = {
		["PicId"] = "03_ob22004",
		["Path"] = "res/map/surface/03_obs_other_011.png",
	},
	["03_ob11005"] = {
		["PicId"] = "03_ob11005",
		["Path"] = "res/map/surface/03_obs_other_012.png",
	},
	["03_ob11006"] = {
		["PicId"] = "03_ob11006",
		["Path"] = "res/map/surface/03_obs_other_013.png",
	},
	["03_op11001"] = {
		["PicId"] = "03_op11001",
		["Path"] = "res/map/surface/03_obs_other_014.png",
	},
	["03_op11002"] = {
		["PicId"] = "03_op11002",
		["Path"] = "res/map/surface/03_obs_other_015.png",
	},
	["03_op11003"] = {
		["PicId"] = "03_op11003",
		["Path"] = "res/map/surface/03_obs_other_016.png",
	},
	["03_og11001"] = {
		["PicId"] = "03_og11001",
		["Path"] = "res/map/surface/03_obs_other_017.png",
	},
	["03_og11002"] = {
		["PicId"] = "03_og11002",
		["Path"] = "res/map/surface/03_obs_other_018.png",
	},
	["03_og11003"] = {
		["PicId"] = "03_og11003",
		["Path"] = "res/map/surface/03_obs_other_019.png",
	},
	["o3_tr11001"] = {
		["PicId"] = "o3_tr11001",
		["Path"] = "res/map/surface/03_obs_tree_001.png",
	},
	["o3_tr11002"] = {
		["PicId"] = "o3_tr11002",
		["Path"] = "res/map/surface/03_obs_tree_002.png",
	},
	["05_do22001"] = {
		["PicId"] = "05_do22001",
		["Path"] = "res/map/surface/05_obs_city_001.png",
	},
	["05_do22002"] = {
		["PicId"] = "05_do22002",
		["Path"] = "res/map/surface/05_obs_city_002.png",
	},
	["05_wa21001"] = {
		["PicId"] = "05_wa21001",
		["Path"] = "res/map/surface/05_obs_city_003.png",
	},
	["05_wa12002"] = {
		["PicId"] = "05_wa12002",
		["Path"] = "res/map/surface/05_obs_city_004.png",
	},
	["05_wa11003"] = {
		["PicId"] = "05_wa11003",
		["Path"] = "res/map/surface/05_obs_city_005.png",
		["None"] = "小墙面",
	},
	["05_pi11001"] = {
		["PicId"] = "05_pi11001",
		["Path"] = "res/map/surface/05_obs_city_006.png",
		["None"] = "大柱子",
	},
	["05_pi11002"] = {
		["PicId"] = "05_pi11002",
		["Path"] = "res/map/surface/05_obs_city_007.png",
		["None"] = "水晶柱子",
	},
	["05_fl22001"] = {
		["PicId"] = "05_fl22001",
		["Path"] = "res/map/surface/05_obs_city_008.png",
	},
	["05_fl21002"] = {
		["PicId"] = "05_fl21002",
		["Path"] = "res/map/surface/05_obs_city_009.png",
	},
	["05_fl21003"] = {
		["PicId"] = "05_fl21003",
		["Path"] = "res/map/surface/05_obs_city_010.png",
	},
	["05_fl21004"] = {
		["PicId"] = "05_fl21004",
		["Path"] = "res/map/surface/05_obs_city_011.png",
	},
	["05_do12003"] = {
		["PicId"] = "05_do12003",
		["Path"] = "res/map/surface/05_obs_city_012.png",
	},
	["05_pi11003"] = {
		["PicId"] = "05_pi11003",
		["Path"] = "res/map/surface/05_obs_city_013.png",
	},
	["s1_3211001"] = {
		["PicId"] = "s1_3211001",
		["Path"] = "res/map/surface/01_sur_grass_001.png",
	},
	["s1_3211002"] = {
		["PicId"] = "s1_3211002",
		["Path"] = "res/map/surface/01_sur_grass_002.png",
	},
	["s1_3211003"] = {
		["PicId"] = "s1_3211003",
		["Path"] = "res/map/surface/01_sur_grass_003.png",
	},
	["s1_3011011"] = {
		["PicId"] = "s1_3011011",
		["Path"] = "res/map/surface/01_sur_mound_001.png",
		["None"] = "土丘草",
	},
	["s1_3011012"] = {
		["PicId"] = "s1_3011012",
		["Path"] = "res/map/surface/01_sur_mound_002.png",
		["None"] = "土丘土",
	},
	["s1_3011021"] = {
		["PicId"] = "s1_3011021",
		["Path"] = "res/map/surface/01_sur_swamp_001.png",
	},
	["s2_3011001"] = {
		["PicId"] = "s2_3011001",
		["Path"] = "res/map/surface/02_sur_cobweb_001.png",
		["None"] = "蜘蛛网",
	},
	["m0_jl11001"] = {
		["PicId"] = "m0_jl11001",
		["Path"] = "res/map/monster/00_monster_001.png",
		["None"] = "巨龙",
	},
	["m0_ct11001"] = {
		["PicId"] = "m0_ct11001",
		["Path"] = "res/map/monster/00_monster_002.png",
		["None"] = "炽天使",
	},
	["m0_bm11001"] = {
		["PicId"] = "m0_bm11001",
		["Path"] = "res/map/monster/00_monster_003.png",
		["None"] = "比蒙巨兽",
	},
	["m0_xm11001"] = {
		["PicId"] = "m0_xm11001",
		["Path"] = "res/map/monster/00_monster_004.png",
		["None"] = "血魔花",
	},
	["m0_dy11001"] = {
		["PicId"] = "m0_dy11001",
		["Path"] = "res/map/monster/00_monster_005.png",
		["None"] = "地狱犬",
	},
	["m0_sw11001"] = {
		["PicId"] = "m0_sw11001",
		["Path"] = "res/map/monster/00_monster_006.png",
		["None"] = "死亡骑士",
	},
	["m0_em11001"] = {
		["PicId"] = "m0_em11001",
		["Path"] = "res/map/monster/00_monster_007.png",
		["None"] = "恶魔城主",
	},
	["m0_xh11001"] = {
		["PicId"] = "m0_xh11001",
		["Path"] = "res/map/monster/00_monster_008.png",
		["None"] = "小火龙",
	},
	["m0_hy11001"] = {
		["PicId"] = "m0_hy11001",
		["Path"] = "res/map/monster/00_monster_009.png",
		["None"] = "火元素",
	},
	["m0_sx11001"] = {
		["PicId"] = "m0_sx11001",
		["Path"] = "res/map/monster/00_monster_010.png",
		["None"] = "石像鬼",
	},
	["m0_zz11001"] = {
		["PicId"] = "m0_zz11001",
		["Path"] = "res/map/monster/00_monster_011.png",
		["None"] = "沼泽人",
	},
	["m0_sj11001"] = {
		["PicId"] = "m0_sj11001",
		["Path"] = "res/map/monster/00_monster_012.png",
		["None"] = "石巨人",
	},
	["m0_sj11002"] = {
		["PicId"] = "m0_sj11002",
		["Path"] = "res/map/monster/00_monster_013.png",
		["None"] = "狮鹫",
	},
	["m0_jt11001"] = {
		["PicId"] = "m0_jt11001",
		["Path"] = "res/map/monster/00_monster_014.png",
		["None"] = "九头龙",
	},
	["m0_ql11001"] = {
		["PicId"] = "m0_ql11001",
		["Path"] = "res/map/monster/00_monster_015.png",
		["None"] = "麒麟",
	},
	["m0_hy11001"] = {
		["PicId"] = "m0_hy11001",
		["Path"] = "res/map/monster/00_monster_016.png",
		["None"] = "光元素",
	},
	["m0_gl11001"] = {
		["PicId"] = "m0_gl11001",
		["Path"] = "res/map/monster/00_monster_017.png",
		["None"] = "光灵",
	},
	["m0_sr11002"] = {
		["PicId"] = "m0_sr11002",
		["Path"] = "res/map/monster/00_monster_018.png",
		["None"] = "狮人",
	},
	["m0_mg11001"] = {
		["PicId"] = "m0_mg11001",
		["Path"] = "res/map/monster/00_monster_019.png",
		["None"] = "蘑菇",
	},
	["m0_fh11001"] = {
		["PicId"] = "m0_fh11001",
		["Path"] = "res/map/monster/00_monster_020.png",
		["None"] = "凤凰",
	},
	["m0_hx11001"] = {
		["PicId"] = "m0_hx11001",
		["Path"] = "res/map/monster/00_monster_021.png",
		["None"] = "火蜥蜴",
	},
	["m0_jr11001"] = {
		["PicId"] = "m0_jr11001",
		["Path"] = "res/map/monster/00_monster_022.png",
		["None"] = "鲛人",
	},
	["m0_kl11001"] = {
		["PicId"] = "m0_kl11001",
		["Path"] = "res/map/monster/00_monster_023.png",
		["None"] = "骷髅",
	},
	["m0_tk11001"] = {
		["PicId"] = "m0_tk11001",
		["Path"] = "res/map/monster/00_monster_024.png",
		["None"] = "天空龙",
	},
	["m0_sl11001"] = {
		["PicId"] = "m0_sl11001",
		["Path"] = "res/map/monster/00_monster_025.png",
		["None"] = "史莱姆",
	},
	["m0_sf11001"] = {
		["PicId"] = "m0_sf11001",
		["Path"] = "res/map/monster/00_monster_026.png",
		["None"] = "斯芬克斯",
	},
	["m0_sj11003"] = {
		["PicId"] = "m0_sj11003",
		["Path"] = "res/map/monster/00_monster_027.png",
		["None"] = "树精",
	},
	["m0_jh11001"] = {
		["PicId"] = "m0_jh11001",
		["Path"] = "res/map/monster/00_monster_028.png",
		["None"] = "巨虎",
	},
	["m0_dj11001"] = {
		["PicId"] = "m0_dj11001",
		["Path"] = "res/map/monster/00_monster_029.png",
		["None"] = "独角兽",
	},
	["m0_sy11001"] = {
		["PicId"] = "m0_sy11001",
		["Path"] = "res/map/monster/00_monster_030.png",
		["None"] = "水元素",
	},
	["m0_md11001"] = {
		["PicId"] = "m0_md11001",
		["Path"] = "res/map/monster/00_monster_031.png",
		["None"] = "美杜莎",
	},
	["m0_mg11002"] = {
		["PicId"] = "m0_mg11002",
		["Path"] = "res/map/monster/00_monster_032.png",
		["None"] = "莫甘娜",
	},
	["m0_sr11001"] = {
		["PicId"] = "m0_sr11001",
		["Path"] = "res/map/monster/00_monster_033.png",
		["None"] = "食人花",
	},
	["m0_mg11003"] = {
		["PicId"] = "m0_mg11003",
		["Path"] = "res/map/monster/00_monster_034.png",
		["None"] = "蘑菇群魔",
	},
	["p0_ls11001"] = {
		["PicId"] = "p0_ls11001",
		["Path"] = "res/map/resource/00_character_001.png",
		["None"] = "兰斯洛特",
	},
	["p0_kt11001"] = {
		["PicId"] = "p0_kt11001",
		["Path"] = "res/map/resource/00_character_002.png",
		["None"] = "卡特琳娜",
	},
	["p0_ys11001"] = {
		["PicId"] = "p0_ys11001",
		["Path"] = "res/map/resource/00_character_003.png",
		["None"] = "亚瑟王",
	},
	["p0_zd11001"] = {
		["PicId"] = "p0_zd11001",
		["Path"] = "res/map/resource/00_character_004.png",
		["None"] = "贞德",
	},
	["p0_dj11001"] = {
		["PicId"] = "p0_dj11001",
		["Path"] = "res/map/resource/00_character_005.png",
		["None"] = "妲己",
	},
	["p0_mg11001"] = {
		["PicId"] = "p0_mg11001",
		["Path"] = "res/map/resource/00_character_006.png",
		["None"] = "莫甘娜",
	},
	["p0_pd11001"] = {
		["PicId"] = "p0_pd11001",
		["Path"] = "res/map/resource/00_character_007.png",
		["None"] = "潘多拉",
	},
	["p0_km11001"] = {
		["PicId"] = "p0_km11001",
		["Path"] = "res/map/resource/00_character_008.png",
		["None"] = "孔明",
	},
	["p0_hm11001"] = {
		["PicId"] = "p0_hm11001",
		["Path"] = "res/map/resource/00_character_009.png",
		["None"] = "花木兰",
	},
	["p0_cc11001"] = {
		["PicId"] = "p0_cc11001",
		["Path"] = "res/map/resource/00_character_010.png",
		["None"] = "曹操",
	},
	["p0_ml11001"] = {
		["PicId"] = "p0_ml11001",
		["Path"] = "res/map/resource/00_character_011.png",
		["None"] = "玛丽",
	},
	["p0_bl11001"] = {
		["PicId"] = "p0_bl11001",
		["Path"] = "res/map/resource/00_character_012.png",
		["None"] = "布伦希尔德",
	},
	["p0_te11001"] = {
		["PicId"] = "p0_te11001",
		["Path"] = "res/map/resource/00_character_013.png",
		["None"] = "托尔",
	},
	["p0_hl11001"] = {
		["PicId"] = "p0_hl11001",
		["Path"] = "res/map/resource/00_character_015.png",
		["None"] = "赫拉克勒斯",
	},
	["p0_lc11001"] = {
		["PicId"] = "p0_lc11001",
		["Path"] = "res/map/resource/00_character_017.png",
		["None"] = "路西法",
	},
	["e0_wq11001"] = {
		["PicId"] = "e0_wq11001",
		["Path"] = "res/ui/picture/equip/pic_equip_weapon_01.png",
		["None"] = "武器",
	},
	["e0_wq11005"] = {
		["PicId"] = "e0_wq11005",
		["Path"] = "res/ui/picture/equip/pic_equip_weapon_05.png",
		["None"] = "第五武器",
	},
	["e0_tk11001"] = {
		["PicId"] = "e0_tk11001",
		["Path"] = "res/ui/picture/equip/pic_equip_head_01.png",
		["None"] = "头盔",
	},
	["e0_yf11001"] = {
		["PicId"] = "e0_yf11001",
		["Path"] = "res/ui/picture/equip/pic_equip_armor_01.png",
		["None"] = "衣服",
	},
	["e0_yf11005"] = {
		["PicId"] = "e0_yf11005",
		["Path"] = "res/ui/picture/equip/pic_equip_armor_05.png",
		["None"] = "第五衣服",
	},
	["e0_xz11001"] = {
		["PicId"] = "e0_xz11001",
		["Path"] = "res/ui/picture/equip/pic_equip_shoes_01.png",
		["None"] = "鞋子",
	},
	["e0_xz11005"] = {
		["PicId"] = "e0_xz11005",
		["Path"] = "res/ui/picture/equip/pic_equip_shoes_05.png",
		["None"] = "第五鞋子",
	},
	["e0_jz11001"] = {
		["PicId"] = "e0_jz11001",
		["Path"] = "res/ui/picture/equip/pic_equip_ring_01.png",
		["None"] = "戒指",
	},
	["e0_xl11001"] = {
		["PicId"] = "e0_xl11001",
		["Path"] = "res/ui/picture/equip/pic_equip_necklace_01.png",
		["None"] = "项链",
	},
	["i0_dz11001"] = {
		["PicId"] = "i0_dz11001",
		["Path"] = "res/ui/picture/item/item_foundary_01.png",
		["None"] = "打造石头1--铁矿",
	},
	["i0_dz11002"] = {
		["PicId"] = "i0_dz11002",
		["Path"] = "res/ui/picture/item/item_foundary_02.png",
		["None"] = "打造石头2--银矿",
	},
	["i0_wq11001"] = {
		["PicId"] = "i0_wq11001",
		["Path"] = "res/ui/picture/item/item_paper_weapon_01.png",
		["None"] = "武器卷轴",
	},
	["i0_xz11001"] = {
		["PicId"] = "i0_xz11001",
		["Path"] = "res/ui/picture/item/item_paper_shoes_01.png",
		["None"] = "鞋子卷轴",
	},
	["i0_jy11001"] = {
		["PicId"] = "i0_jy11001",
		["Path"] = "res/ui/picture/item/item_exp_potion_01.png",
		["None"] = "经验药水",
	},
	["i0_jq11001"] = {
		["PicId"] = "i0_jq11001",
		["Path"] = "res/ui/picture/item/item_gift_money_01.png",
		["None"] = "金钱袋",
	},
	["f0_03"] = {
		["PicId"] = "f0_03",
		["Path"] = "res/map/icon/03.png",
	},
	["f0_09"] = {
		["PicId"] = "f0_09",
		["Path"] = "res/map/icon/09.png",
	},
	["f0_10"] = {
		["PicId"] = "f0_10",
		["Path"] = "res/map/icon/10.png",
	},
	["f0_11"] = {
		["PicId"] = "f0_11",
		["Path"] = "res/map/icon/11.png",
	},
	["f0_15"] = {
		["PicId"] = "f0_15",
		["Path"] = "res/map/icon/15.png",
	},
	["f0_16"] = {
		["PicId"] = "f0_16",
		["Path"] = "res/map/icon/16.png",
	},
},
};


return picture[1]
