----------------------------------------------------------
-- file:	herofactory.lua
-- Author:	page
-- Time:	2015/09/15 10:33 
-- Desc:	兵工厂：英雄处理(升品、升星)
----------------------------------------------------------
require("script/core/configmanager/configmanager");
local l_tbHeroQualityConfig = mconfig.loadConfig("script/cfg/hero/heroquality");
local l_tbHeroQualityConsumeConfig = mconfig.loadConfig("script/cfg/hero/heroqualityconsume", true);
local l_tbHeroStarConfig = mconfig.loadConfig("script/cfg/hero/herostar");

local l_tbHeroQualityType = def_GetHeroQualityType();
local l_tbEquipPos = def_GetPlayerEquipPos();

--data struct 
local TB_STRUCT_HERO_FACTORY = {
	m_Instance = nil;
	----------------------------------
	
}
--------------------------------)
KGC_HERO_FACTORY_TYPE = class("KGC_HERO_FACTORY_TYPE", CLASS_BASE_TYPE, TB_STRUCT_HERO_FACTORY)
--------------------------------
--function
--------------------------------

function KGC_HERO_FACTORY_TYPE:ctor()	
	
end

function KGC_HERO_FACTORY_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_HERO_FACTORY_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end
--------------------------------------------------------------
function KGC_HERO_FACTORY_TYPE:Init(tbArg)
	-- 初始化的时候重新构造一下配置表
	self:ConstructQualityConsumeConfig();
end
----------------------------------------------------------
-- *** 升品 ***
--@function: 获取下一个品质需要等数据
--@return: 需求等级; 属性成长数值
function KGC_HERO_FACTORY_TYPE:GetNextQualityData(hero, nQuality)
	if not hero then
		cclog("[Error]获取英雄品质信息错误@GetNextQualityData(hero == nil)");
		return;
	end
	
	local nQuality = nQuality or hero:GetQuality();
	local tbConfig = l_tbHeroQualityConfig[nQuality];
	local tbNextConfig = l_tbHeroQualityConfig[nQuality+1];
	if not tbConfig then
		tbConfig = {ap = 0, def = 0, hp = 0};
	end
	if not tbNextConfig then
		cclog("[Error]没有找到对应品质的配置信息(nQuality=(%s))", tostring(nQuality+1));
		tbNextConfig = tbConfig;
	end
	local nLevel = tbNextConfig.lv
	local tbCurQualityAdd = {tbConfig.ap, tbConfig.def, tbConfig.hp};
	local tbNextQualityAdd = {tbNextConfig.ap, tbNextConfig.def, tbNextConfig.hp};
	
	return nLevel, tbCurQualityAdd, tbNextQualityAdd;
end

--@function: 获取新品质开启的技能
function KGC_HERO_FACTORY_TYPE:GetNextQualitySkills(hero, nQuality)
	if not hero then
		cclog("[Error]获取英雄品质信息错误@GetNextQualityData(hero == nil)");
		return;
	end
	
	local tbSkills = {};
	local nQuality = (nQuality or hero:GetQuality()) + 1;
	local tbAllConfigSkills = hero:GetAllConfigSkills();
	for nID, nNeedQuality in pairs(tbAllConfigSkills) do
		-- local nID, nNeedQuality = unpack(tbSkills or {});
		print("GetNextQualitySkills", nID, nQuality, nNeedQuality);
		if nID and nNeedQuality then
			if nNeedQuality == nQuality then
				cclog("[log]升品(%d)开启技能：%d", nQuality, nID);
				table.insert(tbSkills, nID);
			end
		end
	end
	
	return tbSkills;
end

--@function: 获取升品消耗
--@nID: 英雄ID
--@nQuality: 英雄升级到该品质需要的消耗
function KGC_HERO_FACTORY_TYPE:GetUpQualityNeed(nID, nQuality)
	if not nID then
		cclog("[Error]英雄ID为空@GetUpQualityNeed");
		return;
	end
	
	local tbConfig = self:GetQualityConsumeConfig();
	local tbData = tbConfig[tostring(nID)]
	if not tbData then
		cclog("[Error]没有找到英雄升品对应的配置表(nID=%s)@GetUpQualityNeed", tostring(nID));
		return;
	end

	local tbConsume = tbData[nQuality]
	if not tbConsume then
		cclog("[Error]升品没有找到品质(%s)对应的消耗", tostring(nQuality));
		return;
	end
	return tbConsume;
end

--@function: 组装升品消耗配置表
function KGC_HERO_FACTORY_TYPE:ConstructQualityConsumeConfig()
	local tbConfig = self:GetQualityConsumeConfig();

	for nID, tbData in pairs(l_tbHeroQualityConsumeConfig or {}) do
		tbConfig[nID] = {};
		
		tbConfig[nID][l_tbHeroQualityType.ET_G] = tbData[tostring(l_tbHeroQualityType.ET_G)];
		tbConfig[nID][l_tbHeroQualityType.ET_G1] = tbData[tostring(l_tbHeroQualityType.ET_G1)];
		tbConfig[nID][l_tbHeroQualityType.ET_B] = tbData[tostring(l_tbHeroQualityType.ET_B)];
		tbConfig[nID][l_tbHeroQualityType.ET_B1] = tbData[tostring(l_tbHeroQualityType.ET_B1)];
		tbConfig[nID][l_tbHeroQualityType.ET_B2] = tbData[tostring(l_tbHeroQualityType.ET_B2)];
		tbConfig[nID][l_tbHeroQualityType.ET_B3] = tbData[tostring(l_tbHeroQualityType.ET_B3)];
		tbConfig[nID][l_tbHeroQualityType.ET_P] = tbData[tostring(l_tbHeroQualityType.ET_P)];
		tbConfig[nID][l_tbHeroQualityType.ET_P1] = tbData[tostring(l_tbHeroQualityType.ET_P1)];
		tbConfig[nID][l_tbHeroQualityType.ET_P2] = tbData[tostring(l_tbHeroQualityType.ET_P2)];
		tbConfig[nID][l_tbHeroQualityType.ET_P3] = tbData[tostring(l_tbHeroQualityType.ET_P3)];
		tbConfig[nID][l_tbHeroQualityType.ET_P4] = tbData[tostring(l_tbHeroQualityType.ET_P4)];
		tbConfig[nID][l_tbHeroQualityType.ET_P5] = tbData[tostring(l_tbHeroQualityType.ET_P5)];
		tbConfig[nID][l_tbHeroQualityType.ET_O] = tbData[tostring(l_tbHeroQualityType.ET_O)];
	end
end

--@function: 获取升品消耗配置表
function KGC_HERO_FACTORY_TYPE:GetQualityConsumeConfig()
	if not self.m_tbQualityConsumeConfig then
		self.m_tbQualityConsumeConfig = {};
	end
	return self.m_tbQualityConsumeConfig;
end

--@function: 从配置表得到最大的品质
function KGC_HERO_FACTORY_TYPE:GetMaxQuality()
	return #(l_tbHeroQualityConfig or {});
end

--@function: 是否可以升品
function KGC_HERO_FACTORY_TYPE:IsCanUpQuality(hero)
	local nCurLevel = hero:GetLevel();
	local nLevel = self:GetNextQualityData(hero);
	if nCurLevel < nLevel then
		return false, 12202;
	end
	
	local tbConsume = self:GetUpQualityNeed(hero:GetID(), hero:GetQuality() + 1);
	local bRet = true;
	for _, tbData in pairs(tbConsume) do
		local nItemID, nItemNum = unpack(tbData or {});
		local item = me:GetBag():GetItemByID(nItemID);
		if not item or item:GetNum() < nItemNum then
			if item then
				cclog("[log]道具(%s)缺少数量(%d/%d)", item:GetName(), item:GetNum(), nItemNum);
			else
				cclog("[log]道具缺少, ID(%d)", nItemID);
			end
			bRet = false;
			break;
		end
	end
	if not bRet then
		return false, 12203;
	else
		cclog("[Error]升品消耗配置表错误或者英雄ID错误:ID(%s)-Quality(%s)", tostring(hero:GetID()), tostring(hero:GetQuality() + 1));
	end
	
	return true;
end

--@function: 升品返回数据处理
function KGC_HERO_FACTORY_TYPE:ProcessQualityResult(tbHeroInfo)
	if not tbHeroInfo then
		cclog("[Error]升品结果错误，玩家数据为nil");
		return;
	end
	local nHeroID, nQuality = tonumber(tbHeroInfo.heroId), tonumber(tbHeroInfo.quality);
	local hero = me:GetHeroByID(nHeroID);
	-- 材料对应的品质：就是升阶到当前的品质
	local tbConsume = self:GetUpQualityNeed(nHeroID, nQuality);
	
	-- local nItemID, nItemNum = unpack(tbConsume or {});
	-- cclog("[log]升品(%s)服务器返回扣除道具：ID(%s), 数量(%s)", tostring(nQuality), tostring(nItemID), tostring(nItemNum));
	
	-- 删除道具
	for _, tbData in pairs(tbConsume) do
		local nItemID, nItemNum = unpack(tbData or {});
		cclog("[log]升品(%s)服务器返回扣除道具：ID(%s), 数量(%s)", tostring(nQuality), tostring(nItemID), tostring(nItemNum));
		if nItemID and nItemNum then
			me:GetBag():SubItemByID(nItemID, nItemNum);
		end
	end
	
	-- 设置品质
	if hero then
		hero:SetQuality(nQuality);
	end
	
	-- 技能重新计算
	if hero then
		local tbSkills = self:GetNextQualitySkills(hero);
		hero:InitSkills(tbSkills, nQuality);
	end
end

-- *** 升星 ***
function KGC_HERO_FACTORY_TYPE:GetUpStarNeed(nStar)
	if not nStar then
		cclog("[Error]星级为nil@GetUpStarNeed");
		return;
	end
	local tbNextConfig = l_tbHeroStarConfig[nStar];
	if not tbNextConfig then
		cclog("[Error]星级配置数据为空(nStar-%s)", tostring(nStar));
		return;
	end
	local nID = tbNextConfig.itemId;		-- 道具ID
	local nNum = tbNextConfig.itemNum;		-- 道具数量
	local nCost = tbNextConfig.gold;		-- 金币消耗
	return nID, nNum, nCost;
end

--@function: 获取下一个品质需要等数据
--@return: 需求等级; 属性成长数值
function KGC_HERO_FACTORY_TYPE:GetNextStarData(hero, nStar)
	if not hero then
		cclog("[Error]获取英雄星级信息错误@GetNextStarData(hero == nil)");
		return;
	end
	
	local nStar = nStar or hero:GetStars();
	local nCurHP, nCurAtt, nCurDef = hero:GetStarGrowing(nStar);
	local nNextHP, nNextAtt, nNextDef = hero:GetStarGrowing(nStar + 1);
	local tbCurStarAdd = {nCurHP or 0, nCurAtt or 0, nCurDef or 0};
	local tbNextStarAdd = {nNextHP or 0, nNextAtt or 0, nNextDef or 0};
	
	return tbCurStarAdd, tbNextStarAdd;
end

--@function: 是否可以升星
function KGC_HERO_FACTORY_TYPE:IsCanUpStar(hero)
	local nStar = hero:GetStars() + 1;
	local nItemID, nItemNum, nCost = self:GetUpStarNeed(nStar);
	local nGold = me:GetGold();
	if nGold < nCost then
		return false, 12204;
	end

	if nItemID and nItemNum then
		local item = me:GetBag():GetItemByID(nItemID);
		if not item or item:GetNum() < nItemNum then
			return false, 12205;
		end
	else
		cclog("[Error]升品消耗配置表错误或者英雄ID错误:ID(%s)", tostring(hero:GetID()));
	end
	
	return true;
end

--@function: 升星返回数据处理
function KGC_HERO_FACTORY_TYPE:ProcessStarResult(tbHeroInfo)
	if not tbHeroInfo then
		cclog("[Error]升星结果错误，玩家数据为nil");
		return;
	end
	local nHeroID, nStar = tonumber(tbHeroInfo.heroId), tonumber(tbHeroInfo.star);
	local hero = me:GetHeroByID(nHeroID);
	-- 材料对应的星级：是升级到当前的星级
	local nItemID, nItemNum, nCost = self:GetUpStarNeed(nStar);
	
	-- 删除道具
	me:GetBag():SubItemByID(nItemID, nItemNum);
	me:AddGold(-1 * nCost);
	
	-- 设置星级信息
	if hero then
		hero:SetStars(nStar);
	end
end

----------------------------------------------------------
-- 套装属性洗练
--@function: 获取第nSuit套装备同星级
--@nSuit: 第几套装备
function KGC_HERO_FACTORY_TYPE:GetEquipStars(nSuit)
	return me:GetEquipStars(nSuit);
end

--@function: 套装属性洗练返回数据处理
function KGC_HERO_FACTORY_TYPE:ProcessRefreshResult(tbHeroInfo)
	if not tbHeroInfo then
		cclog("[Error]洗炼结果错误，玩家数据为nil");
		return;
	end
	local nHeroID = tonumber(tbHeroInfo.heroId);
	local hero = me:GetHeroByID(nHeroID);

	-- 设置星级信息
	if hero then
		hero:InitSuitAttribute(tbHeroInfo.suitId1, tbHeroInfo.suitId2, tbHeroInfo.suitId3, tbHeroInfo.suitId4, tbHeroInfo.suitId5);
	end
end
----------------------------------------------------------
--test
