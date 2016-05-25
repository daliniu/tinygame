---------------------------------------------------------------
-- file:	playfactory.lua
-- Author:	page
-- Time:	2015/06/23 
-- Desc:	在player之上的一个对象：创建一个player，一个怪物盒子等
--			
---------------------------------------------------------------
if not _SERVER then
require ("script/core/player/monsterbox");
end

require("script/lib/basefunctions")
require("script/lib/testfunctions")
require("script/core/player/player");
require("script/core/configmanager/configmanager");

local l_tbMonsterBox = mconfig.loadConfig("script/cfg/battle/monsterbox")
local l_tbMonsterConfig =  mconfig.loadConfig ("script/cfg/battle/monster")
local l_tbCharacterConfig = mconfig.loadConfig("script/cfg/character/character", true)
local l_tbHeroBox = mconfig.loadConfig("script/cfg/client/herobox")

---------------------------------------------------------------
local TB_STRUCT_PLAYER_FACTORY = {
	m_pLogic = nil,
}

KGC_PLAYER_FACTORY_TYPE = class("KGC_PLAYER_FACTORY_TYPE", CLASS_BASE_TYPE, TB_STRUCT_PLAYER_FACTORY)

function KGC_PLAYER_FACTORY_TYPE:getInstance()
	if not KGC_PLAYER_FACTORY_TYPE.m_pLogic then
        KGC_PLAYER_FACTORY_TYPE.m_pLogic = KGC_PLAYER_FACTORY_TYPE.new()
	end
	return KGC_PLAYER_FACTORY_TYPE.m_pLogic
end

function KGC_PLAYER_FACTORY_TYPE:CreatePlayer(playerdata)
 	local player =  KGC_PLAYER_TYPE.new()
	player:init(playerdata)
	return player
end

--@function: 怪物在阵上的位置
--@function: 当前第几只怪
function KGC_PLAYER_FACTORY_TYPE:GetPosition(nType, nIndex)
	print("GetPosition: ",  nType, nIndex)
	local nPos = 0;
	if nType == 1 then				-- 和英雄角色一样的站位
		nPos = nIndex + 3;
	elseif nType == 2 then			-- 单一的一个boss
		nPos = 5;
	elseif nType == 3 then			-- 前排有三个旗子
		nPos = nIndex;
	end
	
	return nPos;
end

--@function: 获取玩家所有的英雄(不包括指引用到的英雄)
function KGC_PLAYER_FACTORY_TYPE:GetAllHeros()
	local tbHeros = {};
	for id, tbData in pairs(l_tbCharacterConfig) do
		tbData.heroId = id;
		local hero = KG_HERO_TYPE.new();
		hero:Init(tbData)
		table.insert(tbHeros, hero);
	end
	return tbHeros;
end

--@function: 获取玩家所有的英雄(不包括指引用到的英雄)
function KGC_PLAYER_FACTORY_TYPE:GetFightBg(nBoxID)
	print("RandomFightBg ... ", nBoxID);
	local tbConfig = l_tbMonsterBox[nBoxID]
	if not tbConfig then
		print(string.format("[Error]怪物盒子ID(%s)没有找到", tostring(nBoxID)))
		return nil;
	end
	
	local tbPics = tbConfig.BattlePic;
	return tbPics;
end
------------------------------------------------------------
-- test
function KGC_PLAYER_FACTORY_TYPE:TestCreatePlayer(nID)
	local nID = nID or 1;
	local tbPlayerInfo = {};
	local tbConfig = l_tbHeroBox[nID] or {};
	local tbData = {};
	table.insert(tbData, tbConfig.Organism1);
	table.insert(tbData, tbConfig.Organism2);
	table.insert(tbData, tbConfig.Organism3);
	tbPlayerInfo.teamList = {};
	for _, data in pairs(tbData) do
		if data then
			local nHeroID, nPos = unpack(data);
			tbPlayerInfo.teamList[nHeroID] = {};
			tbPlayerInfo.teamList[nHeroID].heroId = nHeroID;
			tbPlayerInfo.teamList[nHeroID].pos = nPos;
		end
	end
	
	tst_print_lua_table(tbPlayerInfo);
	
	return self:CreatePlayer(tbPlayerInfo);
end

function KGC_PLAYER_FACTORY_TYPE:TestCreateServerPlayer()
	local tbPlayerInfo = {
		[1] = {
			["level"] = 1,
			["teamList"] = {
				["10004"] = {
					["level"] = 1,
					["star"] = 1,
					["skillSlotList"] = {
						["4"] = {
							["level"] = 1,
						},
						["1"] = {
							["level"] = 1,
						},
						["5"] = {
							["level"] = 1,
						},
						["2"] = {
							["level"] = 1,
						},
						["6"] = {
							["level"] = 1,
						},
					 ["3"] = {
							["level"] = 1,
						},
					},
					["suitId2"] = 18,
					["heroId"] = 10004,
					["suitId1"] = 20,
					["pos"] = 4,
					["suitId3"] = 18,
					["quality"] = 1,
					["suitId4"] = 18,
					["curExp"] = 0,
					["suitId5"] = 18,
				},
				["10006"] = {
					["level"] = 1,
					["star"] = 1,
					["skillSlotList"] = {
						["4"] = {
							["level"] = 1,
						},
						["1"] = {
							["level"] = 1,
						},
						["5"] = {
							["level"] = 1,
						},
						["2"] = {
							["level"] = 1,
						},
						["6"] = {
							["level"] = 1,
						},
						["3"] = {
							["level"] = 1,
						},
					},
					["suitId2"] = 30,
					["heroId"] = 10006,
					["suitId1"] = 30,
					["pos"] = 6,
					["suitId3"] = 28,
					["quality"] = 1,
					["suitId4"] = 27,
					["curExp"] = 0,
					["suitId5"] = 26,
				},
				["10005"] = {
					["level"] = 1,
					["star"] = 1,
					["skillSlotList"] = {
						["4"] = {
							["level"] = 1,
						},
						["1"] = {
							["level"] = 1,
						},
						["5"] = {
							["level"] = 1,
						},
						["2"] = {
							["level"] = 1,
						},
						["6"] = {
							["level"] = 1,
						},
						["3"] = {
							["level"] = 1,
						},
					},
					["suitId2"] = 23,
					["heroId"] = 10005,
					["suitId1"] = 25,
					["pos"] = 5,
					["suitId3"] = 23,
					["quality"] = 1,
					["suitId4"] = 24,
					["curExp"] = 0,
					["suitId5"] = 23,
				},
			},
			["action"] = 10000,
			["diamond"] = 100,
			["gold"] = 99,
			["equipList"] = {
				["2"] = {
				},
				["1"] = {
				},
				["3"] = {
				},
			},
			["vip"] = 0,
			["curExp"] = 0,
			["userName"] = "test039",
		},
		[2] = {
			["level"] = 1,
			["teamList"] = {
				["10004"] = {
					["level"] = 1,
					["star"] = 1,
					["skillSlotList"] = {
						["4"] = {
							["level"] = 1,
						},
						["1"] = {
							["level"] = 1,
						},
						["5"] = {
							["level"] = 1,
						},
						["2"] = {
							["level"] = 1,
						},
						["6"] = {
							["level"] = 1,
						},
					 ["3"] = {
							["level"] = 1,
						},
					},
					["heroId"] = 10004,
					["pos"] = 4,
					["quality"] = 1,
				},
				["10005"] = {
					["level"] = 1,
					["star"] = 1,
					["skillSlotList"] = {
						["4"] = {
							["level"] = 1,
						},
						["1"] = {
							["level"] = 1,
						},
						["5"] = {
							["level"] = 1,
						},
						["2"] = {
							["level"] = 1,
						},
						["6"] = {
							["level"] = 1,
						},
						["3"] = {
							["level"] = 1,
						},
					},
					["heroId"] = 10005,
					["pos"] = 5,
					["quality"] = 1,
				},
				-- ["10005"] = {
					-- ["level"] = 1,
					-- ["star"] = 1,
					-- ["heroId"] = 10005,
					-- ["pos"] = 5,
					-- ["quality"] = 1,
				-- },
			},
			["equipList"] = {
				["2"] = {
				},
				["1"] = {
				},
				["3"] = {
				},
			},
		}
	}
	return tbPlayerInfo[1];
end

------------------------------------------------------------
--relization
g_PlayerFactory = KGC_PLAYER_FACTORY_TYPE:getInstance()
