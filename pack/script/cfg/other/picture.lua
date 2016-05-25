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
	[1] = {
		["PicId"] = 1,
		["Path"] = "res/map/building/01_building_001.png",
	},
	[101] = {
		["PicId"] = 101,
		["Path"] = "res/map/building/00_building_001.png",
	},
	[102] = {
		["PicId"] = 102,
		["Path"] = "res/map/building/00_building_002.png",
	},
	[103] = {
		["PicId"] = 103,
		["Path"] = "res/map/building/00_building_003.png",
	},
	[104] = {
		["PicId"] = 104,
		["Path"] = "res/map/building/00_building_004.png",
	},
	[105] = {
		["PicId"] = 105,
		["Path"] = "res/map/building/00_building_005.png",
	},
	[106] = {
		["PicId"] = 106,
		["Path"] = "res/map/building/00_building_006.png",
	},
	[199] = {
		["PicId"] = 199,
		["Path"] = "res/map/building/chest001.png",
	},
	[200] = {
		["PicId"] = 200,
		["Path"] = "res/map/building/chestchoo001.png",
	},
	[201] = {
		["PicId"] = 201,
		["Path"] = "res/map/building/01_building_004.png",
	},
	[300] = {
		["PicId"] = 300,
		["Path"] = "res/map/building/guaji1001.png",
	},
	[301] = {
		["PicId"] = 301,
		["Path"] = "res/map/building/01_building_003.png",
		["MaskArea"] = {{-1,1},{0,1},{1,-1},{1,0},{1,1},{1,2},{2,0},{2,1},{2,2},{2,3},{3,2}},
	},
	[400] = {
		["PicId"] = 400,
		["Path"] = "res/map/building/guaji2001.png",
	},
	[401] = {
		["PicId"] = 401,
		["Path"] = "res/map/building/01_building_002.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{1,2},{2,2}},
	},
	[500] = {
		["PicId"] = 500,
		["Path"] = "res/map/building/guaji3001.png",
	},
	[600] = {
		["PicId"] = 600,
		["Path"] = "res/map/building/monsterchal001.png",
	},
	[601] = {
		["PicId"] = 601,
		["Path"] = "res/map/building/monsterchal002.png",
	},
	[700] = {
		["PicId"] = 700,
		["Path"] = "res/map/building/monsterchoo001.png",
	},
	[800] = {
		["PicId"] = 800,
		["Path"] = "res/map/building/mission001.png",
	},
	[801] = {
		["PicId"] = 801,
		["Path"] = "res/map/building/01_building_012.png",
		["MaskArea"] = {{-1,1},{0,1},{1,0},{1,1},{1,2},{2,2}},
	},
	[900] = {
		["PicId"] = 900,
		["Path"] = "res/map/building/unknow001.png",
	},
	[901] = {
		["PicId"] = 901,
		["Path"] = "res/map/building/01_building_009.png",
		["MaskArea"] = {{0,1}},
	},
	[902] = {
		["PicId"] = 902,
		["Path"] = "res/map/building/02_building_001.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{1,2},{2,2}},
	},
	[903] = {
		["PicId"] = 903,
		["Path"] = "res/map/building/02_building_002.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,1},{2,2}},
	},
	[904] = {
		["PicId"] = 904,
		["Path"] = "res/map/building/02_building_003.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{1,2},{2,0},{2,1},{2,2},{3,1},{3,2},{3,3},{4,2},{4,3}},
	},
	[905] = {
		["PicId"] = 905,
		["Path"] = "res/map/building/02_building_005.png",
		["MaskArea"] = {{0,1}},
	},
	[906] = {
		["PicId"] = 906,
		["Path"] = "res/map/building/03_building_001.png",
		["MaskArea"] = {{0,1},{0,2},{1,0},{1,1},{1,2},{2,1},{2,2},{2,3},{3,1},{3,2},{3,3},{3,4}},
	},
	[907] = {
		["PicId"] = 907,
		["Path"] = "res/map/building/03_building_002.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,0},{2,1},{2,2},{2,3},{3,2},{3,3},{4,3},{5,3}},
	},
	[908] = {
		["PicId"] = 908,
		["Path"] = "res/map/building/03_building_003.png",
		["MaskArea"] = {{-1,1},{0,1},{1,-1},{1,0},{1,1},{1,2},{2,0},{2,1},{2,2}},
	},
	[909] = {
		["PicId"] = 909,
		["Path"] = "res/map/building/03_building_004.png",
		["MaskArea"] = {{-1,1},{0,1},{0,2},{1,-1},{1,0},{1,1},{1,2},{2,1},{2,2},{3,2}},
	},
	[910] = {
		["PicId"] = 910,
		["Path"] = "res/map/building/03_building_005.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{1,2},{2,1},{2,2},{2,3},{3,2},{3,3},{4,2},{4,3}},
	},
	[911] = {
		["PicId"] = 911,
		["Path"] = "res/map/building/03_building_006.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{2,1},{2,2}},
	},
	[912] = {
		["PicId"] = 912,
		["Path"] = "res/map/building/03_building_007.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{1,2},{2,1},{2,2}},
	},
	[913] = {
		["PicId"] = 913,
		["Path"] = "res/map/building/03_building_008.png",
		["MaskArea"] = {{1,0},{1,1},{1,2},{2,0},{2,1},{2,2},{2,3},{3,2}},
	},
	[1000] = {
		["PicId"] = 1000,
		["Path"] = "res/map/building/qizi001.png",
	},
	[1001] = {
		["PicId"] = 1001,
		["Path"] = "res/map/building/01_building_015.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,1},{2,2},{2,3}},
	},
	[1002] = {
		["PicId"] = 1002,
		["Path"] = "res/map/building/02_building_010.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,1},{2,2},{2,3}},
	},
	[1100] = {
		["PicId"] = 1100,
		["Path"] = "res/map/building/supply001.png",
	},
	[1101] = {
		["PicId"] = 1101,
		["Path"] = "res/map/building/01_building_008.png",
		["MaskArea"] = {{0,1},{1,0},{1,1}},
	},
	[1200] = {
		["PicId"] = 1200,
		["Path"] = "res/map/building/buffstation001.png",
	},
	[1201] = {
		["PicId"] = 1201,
		["Path"] = "res/map/building/buffstation002.png",
	},
	[1202] = {
		["PicId"] = 1202,
		["Path"] = "res/map/building/01_building_011.png",
		["MaskArea"] = {{1,1}},
	},
	[1203] = {
		["PicId"] = 1203,
		["Path"] = "res/map/building/02_building_007.png",
		["MaskArea"] = {{1,1}},
	},
	[1204] = {
		["PicId"] = 1204,
		["Path"] = "res/map/building/02_building_008.png",
	},
	[1300] = {
		["PicId"] = 1300,
		["Path"] = "res/map/building/transport001.png",
	},
	[1301] = {
		["PicId"] = 1301,
		["Path"] = "res/map/building/01_building_014.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,2}},
	},
	[1400] = {
		["PicId"] = 1400,
		["Path"] = "res/map/building/intelligence001.png",
	},
	[1401] = {
		["PicId"] = 1401,
		["Path"] = "res/map/building/01_building_013.png",
		["MaskArea"] = {{-1,1},{0,1},{0,2},{1,-1},{1,0},{1,1},{1,2},{2,1},{2,2},{2,3},{3,3}},
	},
	[1500] = {
		["PicId"] = 1500,
		["Path"] = "res/map/building/shop001.png",
	},
	[1501] = {
		["PicId"] = 1501,
		["Path"] = "res/map/building/01_building_010.png",
		["MaskArea"] = {{-1,1},{0,1},{1,0},{1,1},{1,2},{2,1}},
	},
	[1502] = {
		["PicId"] = 1502,
		["Path"] = "res/map/building/02_building_009.png",
		["MaskArea"] = {{-1,1},{0,1},{1,0},{1,1},{1,2},{2,1}},
	},
	[1600] = {
		["PicId"] = 1600,
		["Path"] = "res/map/building/watchtower001.png",
	},
	[1601] = {
		["PicId"] = 1601,
		["Path"] = "res/map/building/01_building_007.png",
		["MaskArea"] = {{1,1},{1,2},{2,1},{2,2},{3,3}},
	},
	[1602] = {
		["PicId"] = 1602,
		["Path"] = "res/map/building/02_building_004.png",
		["MaskArea"] = {{1,1},{1,2},{2,1},{2,2},{3,3}},
	},
	[1700] = {
		["PicId"] = 1700,
		["Path"] = "res/map/building/portal001.png",
	},
	[1701] = {
		["PicId"] = 1701,
		["Path"] = "res/map/building/01_building_005.png",
		["MaskArea"] = {{1,1}},
	},
	[1702] = {
		["PicId"] = 1702,
		["Path"] = "res/map/building/02_building_006.png",
		["MaskArea"] = {{1,1}},
	},
	[1800] = {
		["PicId"] = 1800,
		["Path"] = "res/map/building/postbox001.png",
	},
	[1801] = {
		["PicId"] = 1801,
		["Path"] = "res/map/building/01_building_006.png",
	},
	[3207] = {
		["PicId"] = 3207,
		["Path"] = "res/map/surface/01_sur_grass_001.png",
	},
	[3208] = {
		["PicId"] = 3208,
		["Path"] = "res/map/surface/01_sur_grass_002.png",
	},
	[3209] = {
		["PicId"] = 3209,
		["Path"] = "res/map/surface/01_sur_grass_003.png",
	},
	[3211] = {
		["PicId"] = 3211,
		["Path"] = "res/map/surface/01_sur_swamp_001.png",
	},
	[3212] = {
		["PicId"] = 3212,
		["Path"] = "res/map/surface/01_sur_swamp_002.png",
	},
	[3213] = {
		["PicId"] = 3213,
		["Path"] = "res/map/surface/01_sur_swamp_003.png",
	},
	[3214] = {
		["PicId"] = 3214,
		["Path"] = "res/map/surface/01_sur_swamp_004.png",
	},
	[3215] = {
		["PicId"] = 3215,
		["Path"] = "res/map/surface/01_sur_swamp_005.png",
	},
	[3216] = {
		["PicId"] = 3216,
		["Path"] = "res/map/surface/01_sur_swamp_006.png",
	},
	[3217] = {
		["PicId"] = 3217,
		["Path"] = "res/map/surface/01_sur_swamp_007.png",
	},
	[3218] = {
		["PicId"] = 3218,
		["Path"] = "res/map/surface/01_sur_swamp_008.png",
	},
	[3219] = {
		["PicId"] = 3219,
		["Path"] = "res/map/surface/01_sur_swamp_009.png",
	},
	[3221] = {
		["PicId"] = 3221,
		["Path"] = "res/map/surface/02_sur_swamp_001.png",
	},
	[3222] = {
		["PicId"] = 3222,
		["Path"] = "res/map/surface/02_sur_swamp_002.png",
	},
	[3223] = {
		["PicId"] = 3223,
		["Path"] = "res/map/surface/02_sur_swamp_003.png",
	},
	[3224] = {
		["PicId"] = 3224,
		["Path"] = "res/map/surface/02_sur_swamp_004.png",
	},
	[3501] = {
		["PicId"] = 3501,
		["Path"] = "res/ui/picture/equip/pic_equip_weapon_01.png",
	},
	[3502] = {
		["PicId"] = 3502,
		["Path"] = "res/ui/picture/equip/pic_equip_head_01.png",
	},
	[3503] = {
		["PicId"] = 3503,
		["Path"] = "res/ui/picture/equip/pic_equip_armor_01.png",
	},
	[3504] = {
		["PicId"] = 3504,
		["Path"] = "res/ui/picture/equip/pic_equip_shoes_01.png",
	},
	[3505] = {
		["PicId"] = 3505,
		["Path"] = "res/ui/picture/equip/pic_equip_ring_01.png",
	},
	[3506] = {
		["PicId"] = 3506,
		["Path"] = "res/ui/picture/equip/pic_equip_necklace_01.png",
	},
	[3514] = {
		["PicId"] = 3514,
		["Path"] = "res/ui/picture/item/item_foundary_01.png",
	},
	[3515] = {
		["PicId"] = 3515,
		["Path"] = "res/ui/picture/item/item_foundary_02.png",
	},
	[3516] = {
		["PicId"] = 3516,
		["Path"] = "res/ui/picture/item/item_paper_weapon_01.png",
	},
	[3517] = {
		["PicId"] = 3517,
		["Path"] = "res/ui/picture/item/item_paper_head_01.png",
	},
	[3518] = {
		["PicId"] = 3518,
		["Path"] = "res/ui/picture/item/item_paper_armor_01.png",
	},
	[3519] = {
		["PicId"] = 3519,
		["Path"] = "res/ui/picture/item/item_paper_shoes_01.png",
	},
	[3520] = {
		["PicId"] = 3520,
		["Path"] = "res/ui/picture/item/item_paper_ring_01.png",
	},
	[3521] = {
		["PicId"] = 3521,
		["Path"] = "res/ui/picture/item/item_paper_necklace_01.png",
	},
	[3551] = {
		["PicId"] = 3551,
		["Path"] = "res/map/resource/00_character_001.png",
	},
	[3552] = {
		["PicId"] = 3552,
		["Path"] = "res/map/resource/00_character_002.png",
	},
	[3553] = {
		["PicId"] = 3553,
		["Path"] = "res/map/resource/00_character_003.png",
	},
	[3554] = {
		["PicId"] = 3554,
		["Path"] = "res/map/resource/00_character_004.png",
	},
	[3555] = {
		["PicId"] = 3555,
		["Path"] = "res/map/resource/00_character_005.png",
	},
	[3556] = {
		["PicId"] = 3556,
		["Path"] = "res/map/resource/00_character_006.png",
	},
	[3557] = {
		["PicId"] = 3557,
		["Path"] = "res/map/resource/00_character_007.png",
	},
	[3558] = {
		["PicId"] = 3558,
		["Path"] = "res/map/resource/00_character_008.png",
	},
	[3559] = {
		["PicId"] = 3559,
		["Path"] = "res/map/resource/00_character_009.png",
	},
	[3560] = {
		["PicId"] = 3560,
		["Path"] = "res/map/resource/00_character_010.png",
	},
	[3561] = {
		["PicId"] = 3561,
		["Path"] = "res/map/resource/00_character_011.png",
	},
	[3562] = {
		["PicId"] = 3562,
		["Path"] = "res/map/resource/00_character_012.png",
	},
	[3563] = {
		["PicId"] = 3563,
		["Path"] = "res/map/resource/00_character_013.png",
	},
	[3564] = {
		["PicId"] = 3564,
		["Path"] = "res/map/resource/00_character_014.png",
	},
	[3565] = {
		["PicId"] = 3565,
		["Path"] = "res/map/resource/00_character_015.png",
	},
	[3566] = {
		["PicId"] = 3566,
		["Path"] = "res/map/resource/00_character_016.png",
	},
	[3567] = {
		["PicId"] = 3567,
		["Path"] = "res/map/resource/00_character_017.png",
	},
	[3601] = {
		["PicId"] = 3601,
		["Path"] = "res/map/monster/00_monster_001.png",
	},
	[3602] = {
		["PicId"] = 3602,
		["Path"] = "res/map/monster/00_monster_002.png",
	},
	[3603] = {
		["PicId"] = 3603,
		["Path"] = "res/map/monster/00_monster_003.png",
	},
	[3604] = {
		["PicId"] = 3604,
		["Path"] = "res/map/monster/00_monster_004.png",
	},
	[3605] = {
		["PicId"] = 3605,
		["Path"] = "res/map/monster/00_monster_005.png",
	},
	[3606] = {
		["PicId"] = 3606,
		["Path"] = "res/map/monster/00_monster_006.png",
	},
	[3607] = {
		["PicId"] = 3607,
		["Path"] = "res/map/monster/00_monster_007.png",
	},
	[3608] = {
		["PicId"] = 3608,
		["Path"] = "res/map/monster/00_monster_008.png",
	},
	[3609] = {
		["PicId"] = 3609,
		["Path"] = "res/map/monster/00_monster_009.png",
	},
	[3610] = {
		["PicId"] = 3610,
		["Path"] = "res/map/monster/00_monster_010.png",
	},
	[3611] = {
		["PicId"] = 3611,
		["Path"] = "res/map/monster/00_monster_011.png",
	},
	[3612] = {
		["PicId"] = 3612,
		["Path"] = "res/map/monster/00_monster_012.png",
	},
	[3613] = {
		["PicId"] = 3613,
		["Path"] = "res/map/monster/00_monster_013.png",
	},
	[3614] = {
		["PicId"] = 3614,
		["Path"] = "res/map/monster/00_monster_014.png",
	},
	[3615] = {
		["PicId"] = 3615,
		["Path"] = "res/map/monster/00_monster_015.png",
	},
	[3616] = {
		["PicId"] = 3616,
		["Path"] = "res/map/monster/00_monster_016.png",
	},
	[3617] = {
		["PicId"] = 3617,
		["Path"] = "res/map/monster/00_monster_017.png",
	},
	[3618] = {
		["PicId"] = 3618,
		["Path"] = "res/map/monster/00_monster_018.png",
	},
	[3619] = {
		["PicId"] = 3619,
		["Path"] = "res/map/monster/00_monster_019.png",
	},
	[3620] = {
		["PicId"] = 3620,
		["Path"] = "res/map/monster/00_monster_020.png",
	},
	[3621] = {
		["PicId"] = 3621,
		["Path"] = "res/map/monster/00_monster_021.png",
	},
	[3622] = {
		["PicId"] = 3622,
		["Path"] = "res/map/monster/00_monster_022.png",
	},
	[3623] = {
		["PicId"] = 3623,
		["Path"] = "res/map/monster/00_monster_023.png",
	},
	[3624] = {
		["PicId"] = 3624,
		["Path"] = "res/map/monster/00_monster_024.png",
	},
	[3625] = {
		["PicId"] = 3625,
		["Path"] = "res/map/monster/00_monster_025.png",
	},
	[3626] = {
		["PicId"] = 3626,
		["Path"] = "res/map/monster/00_monster_026.png",
	},
	[3627] = {
		["PicId"] = 3627,
		["Path"] = "res/map/monster/00_monster_027.png",
	},
	[3628] = {
		["PicId"] = 3628,
		["Path"] = "res/map/monster/00_monster_028.png",
	},
	[3629] = {
		["PicId"] = 3629,
		["Path"] = "res/map/monster/00_monster_029.png",
	},
	[3630] = {
		["PicId"] = 3630,
		["Path"] = "res/map/monster/00_monster_030.png",
	},
	[3631] = {
		["PicId"] = 3631,
		["Path"] = "res/map/monster/00_monster_031.png",
	},
	[3632] = {
		["PicId"] = 3632,
		["Path"] = "res/map/monster/00_monster_032.png",
	},
	[3633] = {
		["PicId"] = 3633,
		["Path"] = "res/map/monster/00_monster_033.png",
	},
	[3634] = {
		["PicId"] = 3634,
		["Path"] = "res/map/monster/00_monster_034.png",
	},
	[3635] = {
		["PicId"] = 3635,
		["Path"] = "res/map/monster/00_monster_035.png",
	},
	[3636] = {
		["PicId"] = 3636,
		["Path"] = "res/map/monster/00_monster_036.png",
	},
	[3637] = {
		["PicId"] = 3637,
		["Path"] = "res/map/monster/00_monster_037.png",
	},
	[3638] = {
		["PicId"] = 3638,
		["Path"] = "res/map/monster/00_monster_038.png",
	},
	[3639] = {
		["PicId"] = 3639,
		["Path"] = "res/map/monster/00_monster_039.png",
	},
	[3640] = {
		["PicId"] = 3640,
		["Path"] = "res/map/monster/00_monster_040.png",
	},
	[3641] = {
		["PicId"] = 3641,
		["Path"] = "res/map/monster/00_monster_041.png",
	},
	[3642] = {
		["PicId"] = 3642,
		["Path"] = "res/map/monster/00_monster_042.png",
	},
	[3643] = {
		["PicId"] = 3643,
		["Path"] = "res/map/monster/00_monster_043.png",
	},
	[3644] = {
		["PicId"] = 3644,
		["Path"] = "res/map/monster/00_monster_044.png",
	},
	[3645] = {
		["PicId"] = 3645,
		["Path"] = "res/map/monster/00_monster_045.png",
	},
	[3646] = {
		["PicId"] = 3646,
		["Path"] = "res/map/monster/00_monster_046.png",
	},
	[3647] = {
		["PicId"] = 3647,
		["Path"] = "res/map/monster/00_monster_047.png",
	},
	[3648] = {
		["PicId"] = 3648,
		["Path"] = "res/map/monster/00_monster_048.png",
	},
	[3649] = {
		["PicId"] = 3649,
		["Path"] = "res/map/monster/00_monster_049.png",
	},
	[3650] = {
		["PicId"] = 3650,
		["Path"] = "res/map/monster/00_monster_050.png",
	},
	[3651] = {
		["PicId"] = 3651,
		["Path"] = "res/map/monster/00_monster_051.png",
	},
	[3652] = {
		["PicId"] = 3652,
		["Path"] = "res/map/monster/00_monster_052.png",
	},
	[3653] = {
		["PicId"] = 3653,
		["Path"] = "res/map/monster/00_monster_053.png",
	},
	[3654] = {
		["PicId"] = 3654,
		["Path"] = "res/map/monster/00_monster_054.png",
	},
	[3655] = {
		["PicId"] = 3655,
		["Path"] = "res/map/monster/00_monster_055.png",
	},
	[3656] = {
		["PicId"] = 3656,
		["Path"] = "res/map/monster/00_monster_056.png",
	},
	[3657] = {
		["PicId"] = 3657,
		["Path"] = "res/map/monster/00_monster_057.png",
	},
	[3658] = {
		["PicId"] = 3658,
		["Path"] = "res/map/monster/00_monster_058.png",
	},
	[3659] = {
		["PicId"] = 3659,
		["Path"] = "res/map/monster/00_monster_059.png",
	},
	[3660] = {
		["PicId"] = 3660,
		["Path"] = "res/map/monster/00_monster_060.png",
	},
	[3661] = {
		["PicId"] = 3661,
		["Path"] = "res/map/monster/00_monster_061.png",
	},
	[3662] = {
		["PicId"] = 3662,
		["Path"] = "res/map/monster/00_monster_062.png",
	},
	[3663] = {
		["PicId"] = 3663,
		["Path"] = "res/map/monster/00_monster_063.png",
	},
	[3664] = {
		["PicId"] = 3664,
		["Path"] = "res/map/monster/00_monster_064.png",
	},
	[10000] = {
		["PicId"] = 10000,
		["Path"] = "res/ui/picture/buff/buff02.png",
	},
	[10001] = {
		["PicId"] = 10001,
		["Path"] = "res/ui/picture/buff/buff03.png",
	},
	[10002] = {
		["PicId"] = 10002,
		["Path"] = "res/ui/picture/buff/buff01.png",
	},
	[33001] = {
		["PicId"] = 33001,
		["Path"] = "res/map/surface/01_nsur_grass_001.png",
	},
	[33002] = {
		["PicId"] = 33002,
		["Path"] = "res/map/surface/01_nsur_grass_002.png",
	},
	[33003] = {
		["PicId"] = 33003,
		["Path"] = "res/map/surface/01_nsur_grass_003.png",
	},
	[33004] = {
		["PicId"] = 33004,
		["Path"] = "res/map/surface/01_nsur_grass_004.png",
	},
	[33005] = {
		["PicId"] = 33005,
		["Path"] = "res/map/surface/01_nsur_grass_005.png",
	},
	[33006] = {
		["PicId"] = 33006,
		["Path"] = "res/map/surface/01_nsur_grass_006.png",
	},
	[33007] = {
		["PicId"] = 33007,
		["Path"] = "res/map/surface/01_nsur_grass_007.png",
	},
	[33008] = {
		["PicId"] = 33008,
		["Path"] = "res/map/surface/01_nsur_grass_008.png",
	},
	[33009] = {
		["PicId"] = 33009,
		["Path"] = "res/map/surface/02_nsur_grass_001.png",
	},
	[33010] = {
		["PicId"] = 33010,
		["Path"] = "res/map/surface/02_nsur_grass_002.png",
	},
	[33011] = {
		["PicId"] = 33011,
		["Path"] = "res/map/surface/02_nsur_grass_003.png",
	},
	[33012] = {
		["PicId"] = 33012,
		["Path"] = "res/map/surface/02_nsur_grass_004.png",
	},
	[33013] = {
		["PicId"] = 33013,
		["Path"] = "res/map/surface/02_nsur_grass_005.png",
	},
	[33014] = {
		["PicId"] = 33014,
		["Path"] = "res/map/surface/02_nsur_grass_006.png",
	},
	[33015] = {
		["PicId"] = 33015,
		["Path"] = "res/map/surface/02_nsur_grass_007.png",
	},
	[33016] = {
		["PicId"] = 33016,
		["Path"] = "res/map/surface/02_nsur_grass_008.png",
	},
	[33017] = {
		["PicId"] = 33017,
		["Path"] = "res/map/surface/02_nsur_grass_009.png",
	},
	[33018] = {
		["PicId"] = 33018,
		["Path"] = "res/map/surface/02_nsur_grass_010.png",
	},
	[33101] = {
		["PicId"] = 33101,
		["Path"] = "res/map/surface/01_obs_edge_001.png",
	},
	[33102] = {
		["PicId"] = 33102,
		["Path"] = "res/map/surface/01_obs_edge_002.png",
	},
	[33103] = {
		["PicId"] = 33103,
		["Path"] = "res/map/surface/01_obs_edge_003.png",
	},
	[33104] = {
		["PicId"] = 33104,
		["Path"] = "res/map/surface/01_obs_edge_004.png",
	},
	[33105] = {
		["PicId"] = 33105,
		["Path"] = "res/map/surface/01_obs_edge_005.png",
	},
	[33106] = {
		["PicId"] = 33106,
		["Path"] = "res/map/surface/01_obs_edge_006.png",
	},
	[33107] = {
		["PicId"] = 33107,
		["Path"] = "res/map/surface/01_obs_edge_007.png",
	},
	[33108] = {
		["PicId"] = 33108,
		["Path"] = "res/map/surface/01_obs_edge_008.png",
	},
	[33109] = {
		["PicId"] = 33109,
		["Path"] = "res/map/surface/01_obs_edge_009.png",
		["MaskArea"] = {{2,0},{2,1},{3,1},{2,2},{3,2},{1,2},{0,2},{1,3},{2,3},{3,3},{4,3},{3,4}},
	},
	[33110] = {
		["PicId"] = 33110,
		["Path"] = "res/map/surface/01_obs_edge_010.png",
		["MaskArea"] = {{0,2},{1,2},{2,0},{2,1},{2,2},{3,2},{3,3}},
	},
	[33111] = {
		["PicId"] = 33111,
		["Path"] = "res/map/surface/01_obs_edge_011.png",
		["MaskArea"] = {{0,2},{1,2}},
	},
	[33112] = {
		["PicId"] = 33112,
		["Path"] = "res/map/surface/01_obs_edge_012.png",
	},
	[33113] = {
		["PicId"] = 33113,
		["Path"] = "res/map/surface/01_obs_edge_013.png",
	},
	[33114] = {
		["PicId"] = 33114,
		["Path"] = "res/map/surface/01_obs_edge_014.png",
	},
	[33115] = {
		["PicId"] = 33115,
		["Path"] = "res/map/surface/01_obs_edge_015.png",
	},
	[33116] = {
		["PicId"] = 33116,
		["Path"] = "res/map/surface/01_obs_edge_016.png",
	},
	[33117] = {
		["PicId"] = 33117,
		["Path"] = "res/map/surface/01_obs_edge_017.png",
	},
	[33118] = {
		["PicId"] = 33118,
		["Path"] = "res/map/surface/01_obs_edge_018.png",
	},
	[33119] = {
		["PicId"] = 33119,
		["Path"] = "res/map/surface/01_obs_edge_019.png",
	},
	[33120] = {
		["PicId"] = 33120,
		["Path"] = "res/map/surface/01_obs_edge_020.png",
	},
	[33121] = {
		["PicId"] = 33121,
		["Path"] = "res/map/surface/01_obs_edge_021.png",
	},
	[33122] = {
		["PicId"] = 33122,
		["Path"] = "res/map/surface/01_obs_edge_022.png",
	},
	[33123] = {
		["PicId"] = 33123,
		["Path"] = "res/map/surface/02_obs_edge_001.png",
	},
	[33124] = {
		["PicId"] = 33124,
		["Path"] = "res/map/surface/02_obs_edge_002.png",
	},
	[33125] = {
		["PicId"] = 33125,
		["Path"] = "res/map/surface/02_obs_edge_003.png",
	},
	[33126] = {
		["PicId"] = 33126,
		["Path"] = "res/map/surface/02_obs_edge_004.png",
	},
	[33127] = {
		["PicId"] = 33127,
		["Path"] = "res/map/surface/02_obs_edge_005.png",
	},
	[33128] = {
		["PicId"] = 33128,
		["Path"] = "res/map/surface/02_obs_edge_006.png",
	},
	[33129] = {
		["PicId"] = 33129,
		["Path"] = "res/map/surface/02_obs_edge_007.png",
	},
	[33130] = {
		["PicId"] = 33130,
		["Path"] = "res/map/surface/02_obs_edge_008.png",
	},
	[33131] = {
		["PicId"] = 33131,
		["Path"] = "res/map/surface/02_obs_edge_009.png",
	},
	[33132] = {
		["PicId"] = 33132,
		["Path"] = "res/map/surface/02_obs_edge_010.png",
	},
	[33133] = {
		["PicId"] = 33133,
		["Path"] = "res/map/surface/02_obs_edge_011.png",
	},
	[33134] = {
		["PicId"] = 33134,
		["Path"] = "res/map/surface/02_obs_edge_012.png",
	},
	[33135] = {
		["PicId"] = 33135,
		["Path"] = "res/map/surface/02_obs_edge_013.png",
	},
	[33136] = {
		["PicId"] = 33136,
		["Path"] = "res/map/surface/02_obs_edge_014.png",
	},
	[33137] = {
		["PicId"] = 33137,
		["Path"] = "res/map/surface/02_obs_edge_015.png",
	},
	[33138] = {
		["PicId"] = 33138,
		["Path"] = "res/map/surface/02_obs_edge_016.png",
	},
	[33139] = {
		["PicId"] = 33139,
		["Path"] = "res/map/surface/02_obs_edge_017.png",
	},
	[33140] = {
		["PicId"] = 33140,
		["Path"] = "res/map/surface/03_obs_edge_001.png",
	},
	[33141] = {
		["PicId"] = 33141,
		["Path"] = "res/map/surface/03_obs_edge_002.png",
	},
	[33142] = {
		["PicId"] = 33142,
		["Path"] = "res/map/surface/03_obs_edge_003.png",
	},
	[33143] = {
		["PicId"] = 33143,
		["Path"] = "res/map/surface/03_obs_edge_004.png",
	},
	[33144] = {
		["PicId"] = 33144,
		["Path"] = "res/map/surface/03_obs_edge_005.png",
		["None"] = "水块",
	},
	[33145] = {
		["PicId"] = 33145,
		["Path"] = "res/map/surface/03_obs_edge_006.png",
		["None"] = "水块",
	},
	[33146] = {
		["PicId"] = 33146,
		["Path"] = "res/map/surface/03_obs_edge_007.png",
		["None"] = "水块",
	},
	[33201] = {
		["PicId"] = 33201,
		["Path"] = "res/map/surface/01_obs_stone_001.png",
		["MaskArea"] = {{1,2},{2,1},{2,2},{2,3},{3,2},{3,3},{3,4},{4,3},{4,4}},
	},
	[33202] = {
		["PicId"] = 33202,
		["Path"] = "res/map/surface/01_obs_stone_002.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{1,2},{2,1},{2,2}},
	},
	[33203] = {
		["PicId"] = 33203,
		["Path"] = "res/map/surface/01_obs_stone_003.png",
		["MaskArea"] = {{1,2},{2,0},{2,1},{2,2}},
	},
	[33204] = {
		["PicId"] = 33204,
		["Path"] = "res/map/surface/01_obs_stone_004.png",
	},
	[33205] = {
		["PicId"] = 33205,
		["Path"] = "res/map/surface/01_obs_stone_005.png",
	},
	[33206] = {
		["PicId"] = 33206,
		["Path"] = "res/map/surface/01_obs_stone_006.png",
	},
	[33207] = {
		["PicId"] = 33207,
		["Path"] = "res/map/surface/01_obs_stone_007.png",
	},
	[33208] = {
		["PicId"] = 33208,
		["Path"] = "res/map/surface/01_obs_stone_008.png",
	},
	[33209] = {
		["PicId"] = 33209,
		["Path"] = "res/map/surface/01_obs_stone_009.png",
	},
	[33210] = {
		["PicId"] = 33210,
		["Path"] = "res/map/surface/01_obs_stone_010.png",
	},
	[33211] = {
		["PicId"] = 33211,
		["Path"] = "res/map/surface/01_obs_stone_011.png",
	},
	[33212] = {
		["PicId"] = 33212,
		["Path"] = "res/map/surface/01_obs_stone_012.png",
	},
	[33213] = {
		["PicId"] = 33213,
		["Path"] = "res/map/surface/01_obs_stone_013.png",
	},
	[33214] = {
		["PicId"] = 33214,
		["Path"] = "res/map/surface/01_obs_stone_014.png",
		["MaskArea"] = {{0,2},{1,2},{2,0},{2,1},{2,2},{2,3},{3,2},{3,3},{3,4},{4,3},{4,4},{5,4}},
	},
	[33215] = {
		["PicId"] = 33215,
		["Path"] = "res/map/surface/01_obs_stone_015.png",
		["MaskArea"] = {{1,2},{2,1},{2,2}},
	},
	[33216] = {
		["PicId"] = 33216,
		["Path"] = "res/map/surface/01_obs_stone_016.png",
	},
	[33217] = {
		["PicId"] = 33217,
		["Path"] = "res/map/surface/01_obs_stone_017.png",
	},
	[33218] = {
		["PicId"] = 33218,
		["Path"] = "res/map/surface/01_obs_stone_018.png",
	},
	[33219] = {
		["PicId"] = 33219,
		["Path"] = "res/map/surface/01_obs_stone_019.png",
	},
	[33220] = {
		["PicId"] = 33220,
		["Path"] = "res/map/surface/02_obs_stone_001.png",
		["MaskArea"] = {{-1,1},{0,1},{1,-1},{1,0},{1,1},{1,2},{2,2}},
	},
	[33221] = {
		["PicId"] = 33221,
		["Path"] = "res/map/surface/02_obs_stone_002.png",
		["MaskArea"] = {{0,1},{1,-1},{1,0},{1,1},{2,1},{2,2}},
	},
	[33222] = {
		["PicId"] = 33222,
		["Path"] = "res/map/surface/02_obs_stone_003.png",
	},
	[33223] = {
		["PicId"] = 33223,
		["Path"] = "res/map/surface/02_obs_stone_004.png",
	},
	[33224] = {
		["PicId"] = 33224,
		["Path"] = "res/map/surface/02_obs_stone_005.png",
		["MaskArea"] = {{1,1},{2,2}},
	},
	[33225] = {
		["PicId"] = 33225,
		["Path"] = "res/map/surface/02_obs_stone_006.png",
		["MaskArea"] = {{1,1}},
	},
	[33226] = {
		["PicId"] = 33226,
		["Path"] = "res/map/surface/02_obs_stone_007.png",
	},
	[33227] = {
		["PicId"] = 33227,
		["Path"] = "res/map/surface/02_obs_stone_008.png",
		["MaskArea"] = {{1,1},{2,1},{2,2}},
	},
	[33228] = {
		["PicId"] = 33228,
		["Path"] = "res/map/surface/02_obs_stone_009.png",
	},
	[33229] = {
		["PicId"] = 33229,
		["Path"] = "res/map/surface/02_obs_stone_010.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{2,1},{2,2},{3,2}},
	},
	[33230] = {
		["PicId"] = 33230,
		["Path"] = "res/map/surface/02_obs_stone_011.png",
		["MaskArea"] = {{0,1},{1,0},{1,1}},
	},
	[33231] = {
		["PicId"] = 33231,
		["Path"] = "res/map/surface/02_obs_stone_012.png",
	},
	[33232] = {
		["PicId"] = 33232,
		["Path"] = "res/map/surface/02_obs_stone_013.png",
	},
	[33233] = {
		["PicId"] = 33233,
		["Path"] = "res/map/surface/02_obs_stone_014.png",
	},
	[33234] = {
		["PicId"] = 33234,
		["Path"] = "res/map/surface/02_obs_stone_015.png",
	},
	[33235] = {
		["PicId"] = 33235,
		["Path"] = "res/map/surface/02_obs_stone_016.png",
	},
	[33236] = {
		["PicId"] = 33236,
		["Path"] = "res/map/surface/02_obs_stone_017.png",
	},
	[33237] = {
		["PicId"] = 33237,
		["Path"] = "res/map/surface/02_obs_stone_018.png",
	},
	[33238] = {
		["PicId"] = 33238,
		["Path"] = "res/map/surface/02_obs_stone_019.png",
	},
	[33239] = {
		["PicId"] = 33239,
		["Path"] = "res/map/surface/02_obs_stone_020.png",
	},
	[33240] = {
		["PicId"] = 33240,
		["Path"] = "res/map/surface/02_obs_stone_021.png",
	},
	[33241] = {
		["PicId"] = 33241,
		["Path"] = "res/map/surface/02_obs_stone_022.png",
	},
	[33242] = {
		["PicId"] = 33242,
		["Path"] = "res/map/surface/02_obs_stone_023.png",
	},
	[33243] = {
		["PicId"] = 33243,
		["Path"] = "res/map/surface/02_obs_stone_024.png",
	},
	[33244] = {
		["PicId"] = 33244,
		["Path"] = "res/map/surface/02_obs_stone_025.png",
	},
	[33245] = {
		["PicId"] = 33245,
		["Path"] = "res/map/surface/02_obs_stone_026.png",
	},
	[33246] = {
		["PicId"] = 33246,
		["Path"] = "res/map/surface/02_obs_stone_027.png",
	},
	[33247] = {
		["PicId"] = 33247,
		["Path"] = "res/map/surface/02_obs_stone_028.png",
	},
	[33248] = {
		["PicId"] = 33248,
		["Path"] = "res/map/surface/02_obs_stone_029.png",
	},
	[33249] = {
		["PicId"] = 33249,
		["Path"] = "res/map/surface/03_obs_stone_001.png",
	},
	[33250] = {
		["PicId"] = 33250,
		["Path"] = "res/map/surface/03_obs_stone_002.png",
	},
	[33251] = {
		["PicId"] = 33251,
		["Path"] = "res/map/surface/03_obs_stone_003.png",
	},
	[33252] = {
		["PicId"] = 33252,
		["Path"] = "res/map/surface/03_obs_stone_004.png",
	},
	[33253] = {
		["PicId"] = 33253,
		["Path"] = "res/map/surface/03_obs_stone_005.png",
	},
	[33254] = {
		["PicId"] = 33254,
		["Path"] = "res/map/surface/03_obs_stone_006.png",
	},
	[33255] = {
		["PicId"] = 33255,
		["Path"] = "res/map/surface/03_obs_stone_007.png",
	},
	[33256] = {
		["PicId"] = 33256,
		["Path"] = "res/map/surface/03_obs_stone_008.png",
	},
	[33257] = {
		["PicId"] = 33257,
		["Path"] = "res/map/surface/03_obs_stone_009.png",
	},
	[33258] = {
		["PicId"] = 33258,
		["Path"] = "res/map/surface/03_obs_stone_010.png",
	},
	[33259] = {
		["PicId"] = 33259,
		["Path"] = "res/map/surface/03_obs_stone_011.png",
	},
	[33260] = {
		["PicId"] = 33260,
		["Path"] = "res/map/surface/03_obs_stone_012.png",
	},
	[33261] = {
		["PicId"] = 33261,
		["Path"] = "res/map/surface/03_obs_stone_013.png",
	},
	[33262] = {
		["PicId"] = 33262,
		["Path"] = "res/map/surface/03_obs_stone_014.png",
	},
	[33263] = {
		["PicId"] = 33263,
		["Path"] = "res/map/surface/03_obs_stone_015.png",
	},
	[33264] = {
		["PicId"] = 33264,
		["Path"] = "res/map/surface/03_obs_stone_016.png",
	},
	[33265] = {
		["PicId"] = 33265,
		["Path"] = "res/map/surface/03_obs_stone_017.png",
	},
	[33266] = {
		["PicId"] = 33266,
		["Path"] = "res/map/surface/03_obs_stone_018.png",
	},
	[33267] = {
		["PicId"] = 33267,
		["Path"] = "res/map/surface/03_obs_stone_019.png",
	},
	[33268] = {
		["PicId"] = 33268,
		["Path"] = "res/map/surface/03_obs_stone_020.png",
	},
	[33269] = {
		["PicId"] = 33269,
		["Path"] = "res/map/surface/03_obs_stone_021.png",
	},
	[33301] = {
		["PicId"] = 33301,
		["Path"] = "res/map/surface/01_obs_tree_001.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{2,2}},
	},
	[33302] = {
		["PicId"] = 33302,
		["Path"] = "res/map/surface/01_obs_tree_002.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{2,1},{2,2}},
	},
	[33303] = {
		["PicId"] = 33303,
		["Path"] = "res/map/surface/01_obs_tree_003.png",
		["MaskArea"] = {{0,1},{1,0},{1,1},{2,2}},
	},
	[33304] = {
		["PicId"] = 33304,
		["Path"] = "res/map/surface/01_obs_tree_004.png",
		["MaskArea"] = {{1,1},{2,2}},
	},
	[33305] = {
		["PicId"] = 33305,
		["Path"] = "res/map/surface/01_obs_tree_005.png",
		["MaskArea"] = {{1,1},{1,2},{2,1},{2,2},{2,3}},
	},
	[33306] = {
		["PicId"] = 33306,
		["Path"] = "res/map/surface/01_obs_tree_006.png",
	},
	[33307] = {
		["PicId"] = 33307,
		["Path"] = "res/map/surface/01_obs_tree_007.png",
	},
	[33308] = {
		["PicId"] = 33308,
		["Path"] = "res/map/surface/01_obs_tree_008.png",
		["MaskArea"] = {{1,2},{2,2},{2,3},{3,2},{3,3},{4,2},{4,3}},
	},
	[33309] = {
		["PicId"] = 33309,
		["Path"] = "res/map/surface/01_obs_tree_009.png",
	},
	[33310] = {
		["PicId"] = 33310,
		["Path"] = "res/map/surface/01_obs_tree_010.png",
	},
	[33311] = {
		["PicId"] = 33311,
		["Path"] = "res/map/surface/01_obs_tree_011.png",
		["MaskArea"] = {{0,1},{1,1},{2,1},{2,2}},
	},
	[33312] = {
		["PicId"] = 33312,
		["Path"] = "res/map/surface/01_obs_tree_012.png",
		["MaskArea"] = {{1,1},{1,2},{2,1},{2,2},{2,3},{3,2},{3,3}},
	},
	[33313] = {
		["PicId"] = 33313,
		["Path"] = "res/map/surface/01_obs_tree_013.png",
		["MaskArea"] = {{0,1},{1,0},{1,1}},
	},
	[33314] = {
		["PicId"] = 33314,
		["Path"] = "res/map/surface/01_obs_tree_014.png",
		["MaskArea"] = {{1,1},{2,1},{2,2},{2,3},{3,3},{3,4},{4,4},{4,5}},
	},
	[33315] = {
		["PicId"] = 33315,
		["Path"] = "res/map/surface/01_obs_tree_015.png",
		["MaskArea"] = {{1,0},{1,1},{2,1},{2,2}},
	},
	[33317] = {
		["PicId"] = 33317,
		["Path"] = "res/map/surface/02_obs_tree_001.png",
		["MaskArea"] = {{1,1},{1,2},{2,1},{2,2},{2,3},{3,3}},
	},
	[33318] = {
		["PicId"] = 33318,
		["Path"] = "res/map/surface/02_obs_tree_002.png",
		["MaskArea"] = {{1,1},{1,2},{1,3},{2,1},{2,2},{2,3},{3,2},{3,3}},
	},
	[33319] = {
		["PicId"] = 33319,
		["Path"] = "res/map/surface/02_obs_tree_003.png",
		["MaskArea"] = {{1,1},{2,2},{2,3},{3,2},{3,3}},
	},
	[33320] = {
		["PicId"] = 33320,
		["Path"] = "res/map/surface/02_obs_tree_004.png",
		["MaskArea"] = {{1,1},{2,1},{2,2},{3,3}},
	},
	[33321] = {
		["PicId"] = 33321,
		["Path"] = "res/map/surface/03_obs_tree_001.png",
		["MaskArea"] = {{1,1},{1,2},{2,2},{2,3},{3,2},{3,3},{3,4},{4,3},{4,4}},
	},
	[33322] = {
		["PicId"] = 33322,
		["Path"] = "res/map/surface/03_obs_tree_002.png",
		["MaskArea"] = {{1,1},{1,2},{2,2},{2,3},{3,2},{3,3},{3,4},{4,3},{4,4}},
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

local tbConfig = gf_CopyTable(picture[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
