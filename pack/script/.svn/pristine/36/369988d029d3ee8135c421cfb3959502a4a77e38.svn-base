----------------------------------------------------------
-- file:	chatview.lua
-- Author:	page
-- Time:	2015/08/14 16:02
-- Desc:	聊天面板
----------------------------------------------------------
require "script/ui/resource"
----------------------------------------------------------
local l_tbRewardType = {
	ET_GOLD		= 1,			-- 金币
	ET_AP		= 2,			-- 行动力
}

--data struct
local TB_STRUCT_UI_REWARD_LAYER = {
	m_pLayout = nil,
	m_pnlMain = nil,
}

KGC_REWARD_LAYER_TYPE = class("KGC_REWARD_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_UI_REWARD_LAYER)
--------------------------------
--ui function
--------------------------------

function KGC_REWARD_LAYER_TYPE:Init(tbArgs)
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_REWARD_PATH)
	assert(self.m_pLayout)
	self:addChild(self.m_pLayout)
	self:LoadScheme()
	
	self:UpdateData(tbArgs)
end

function KGC_REWARD_LAYER_TYPE:LoadScheme()
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main")
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			MapViewLogic:getInstance():openCurrentMap();
			KGC_REWARD_LAYER_LOGIC_TYPE:getInstance():closeLayer(1);
		end
	end
	self.m_pnlMain:addTouchEventListener(fnClose)
	
	-- 奖励
	self.m_pnlReward = self.m_pLayout:getChildByName("pnl_rewards");
	
	local btnConfirm = self.m_pLayout:getChildByName("btn_confirm");
	btnConfirm:addTouchEventListener(fnClose);
end

--@function: 更新界面数据
--@tbArgs: 奖励
--[[
	tbArg = {
		nGold = 0,
		nExp = 0,
		nAP = 0,
		tbItems = {},
	}
]]
function KGC_REWARD_LAYER_TYPE:UpdateData(tbArgs)
	if not tbArgs then
		cclog("[Error]通关奖励数据为空!");
		return;
	end
	
	local nRewardID = tbArgs.rewardid;
	local tbItemData = tbArgs.bagAdd;
	local bRet, nGold, nExp, nExpTeam, nAP, nSign, tbItems = KGC_REWARD_MANAGER_TYPE:getInstance():AddRewardByID(nRewardID, tbItemData)
	if not bRet then
		cclog("[Error]奖励数据错误！");
		return;
	end
	
	nGold = nGold or 0;
	nExp = nExp or 0;
	nAP = nAP or 0;
	tbItems = tbItems or {}
	
	-- 数值类奖励(经验、金币、行动力、标记)
	local tbReward = {}
	if nGold > 0 then
		table.insert(tbReward, {l_tbRewardType.ET_GOLD, nGold})
	end
	
	if nAP > 0 then
		table.insert(tbReward, {l_tbRewardType.ET_AP, nAP})
	end

	self:UpdateReward(self.m_pnlReward, tbReward);
	
	-- 更新数据
	self:UpdateItems(tbItems);
	self:UpdateTeam();
	self:UpdateHeros();
	
	-- 播放特效
	self:PlayStarsEffect();
end

--@function: 更新奖励界面, 第一部分(经验、金币、行动力、标记)
function KGC_REWARD_LAYER_TYPE:UpdateReward(pnlReward, tbReward)
	if not pnlReward then
		return;
	end
	
	local tbImages = {
		[l_tbRewardType.ET_GOLD] = "res/ui/05_mainUI/05_ico_main_03.png",
		[l_tbRewardType.ET_AP] = "res/ui/05_mainUI/05_ico_main_01.png",
	}
	
	local tbReward = tbReward or {}
	for i=1, #tbImages do
		local szName = "img_reward_" .. i;
		local imgReward = pnlReward:getChildByName(szName)
		if imgReward then
			local imgIcon = imgReward:getChildByName("img_icon");
			local lblContent = imgReward:getChildByName("lbl_content")
			local tbData = tbReward[i] or {}
			local nType, szContent = unpack(tbData)
			if nType and szContent then
				imgReward:setVisible(true);
				local szImage = tbImages[nType]
				if szImage then
					imgReward:loadTexture(szImage)
				end
				lblContent:setString(szContent);
			else
				imgReward:setVisible(false);
			end
		end
	end
end

function KGC_REWARD_LAYER_TYPE:UpdateItems(tbItems, nSign)
	local pnlReward = self.m_pnlReward;
	-- 道具显示
	for i = 1, 4 do
		local szName = "img_item" .. i;
		local imgItem = pnlReward:getChildByName(szName)
		local imgIcon = imgItem:getChildByName("img_icon")
		local item = tbItems[i];
		if item then
			imgItem:setVisible(true);
			imgIcon:loadTexture(item:GetIcon())
			local bmlNum = imgItem:getChildByName("bml_num")
			bmlNum:setString(item:GetNum())
			local imgQuality = imgItem:getChildByName("img_quality")
			imgQuality:loadTexture(item:GetQualityIcon())
		else
			imgItem:setVisible(false);
		end
	end
end

--@function: 队伍信息
function KGC_REWARD_LAYER_TYPE:UpdateTeam()
	print("UpdateTeam");
	-- 团队经验
	local nTeamLevel = me:GetLevel();
	local nExp = me:GetExp()
	local nLevelUpExp = me:GetLevelUpExp();
	local szExp = nExp .. "/" .. nLevelUpExp;
	local nPercent = nExp / nLevelUpExp * 100;
	
	local imgPlayerInfo = self.m_pLayout:getChildByName("img_playerlevel");
	local bmlLevel = imgPlayerInfo:getChildByName("bmp_playerlevel");
	local barExp = imgPlayerInfo:getChildByName("bar_exp");
	local bmlExp = imgPlayerInfo:getChildByName("bmp_expnum");
	
	bmlLevel:setString(nTeamLevel);
	barExp:setPercent(nPercent);
	bmlExp:setString(szExp);
end

--@function: 英雄信息
function KGC_REWARD_LAYER_TYPE:UpdateHeros()
	local tbHeros = me:GetHeros();
	for i = 1, 3 do
		local szName = "pnl_hero_" .. i;
		local pnlHero = self.m_pLayout:getChildByName(szName);
		if pnlHero then
			local hero = tbHeros[i]
			self:UpdateHero(pnlHero, hero);
		end
	end
end

function KGC_REWARD_LAYER_TYPE:UpdateHero(pnlHero, hero)
	if not pnlHero then
		return;
	end
	
	if not hero then
		pnlHero:setVisible(false);
		return;
	end
	pnlHero:setVisible(true);
	
	local imgHeroBg = pnlHero:getChildByName("img_herobg");				-- 英雄背景
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local lblName = pnlHero:getChildByName("lbl_heroname");				-- 英雄名字
	local imgExpBg = pnlHero:getChildByName("img_expbg");				
	local barExp = imgExpBg:getChildByName("bar_exp");					-- 经验条
	
	local nQuality = hero:GetQuality();
	local szType = hero:GetHeroTypeResource();
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	local nExp = hero:GetExp();
	local nLevelUpExp = hero:GetLevelUpExp();
	local nPercent = nExp/nLevelUpExp * 100;
	
	imgHeroBg:loadTexture(szHeroBg);
	imgHero:loadTexture(szIconS);
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	lblName:setString(hero:GetName());
	lblName:setColor(cc.c3b(r, g, b));
	barExp:setPercent(nPercent);
end

function KGC_REWARD_LAYER_TYPE:PlayStarsEffect(fnCallBack)
	print("PlayStarsEffect", fnCallBack);
	
	-- 动作回调函数
	local fnCall = function()
		if fnCallBack then
			fnCallBack();
		end
	end
	
	
	-- ccs.ActionManagerEx:getInstance():playActionByName("ui_fight_result.json", szAction, cc.CallFunc:create(fnCall))
	fnCall();
end
-------------------------------------------------------------
--test
