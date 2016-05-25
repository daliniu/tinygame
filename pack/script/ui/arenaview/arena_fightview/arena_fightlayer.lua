----------------------------------------------------------
-- file:	arena_fightlayer.lua
-- Author:	page
-- Time:	2015/12/08 17:21
-- Desc:	竞技场敌我对战界面
----------------------------------------------------------
require ("script/ui/resource");
require ("script/ui/arenaview/arena_fightview/rewardsublayer");
----------------------------------------------------------
--data struct
local TB_STRUCT_ARENA_FIGHT_LAYER = {
	-- config
	m_bUpdate = true,				--是否updae
	----------------------------------------------------------
	m_pLayout = nil,					-- json界面
	
	m_pnlPlayerInfoTemplate = nil,		-- listview的模版
	m_tbRewardButton = {},				-- 奖励宝箱按钮
	
	m_tbPlayerData = {},				-- 每一个panel对应的玩家数据对象
	m_bRewardFlag = false,				-- 是否已经弹出奖励界面
	
	m_nCurStage = 0,					-- 当前阶段(筹码赛、八强赛)
	m_nCurStep = 0,						-- 阶段下面的段
}

KGC_ARENA_FIGHT_LAYER_TYPE = class("KGC_ARENA_FIGHT_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_ARENA_FIGHT_LAYER)
--------------------------------
--ui function
--------------------------------

function KGC_ARENA_FIGHT_LAYER_TYPE:Init()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_FIGHT_PATH);
    self:addChild(self.m_pLayout);
	self.m_nCurStage, self.m_nCurStep = KGC_ARENA_FACTORY_TYPE:getInstance():GetCurrentStage();
	
	self:LoadScheme();
	
	-- 更新一下必要的数据
	self:Update();
	
	self:UpdateData();
end

--解析界面文件
function KGC_ARENA_FIGHT_LAYER_TYPE:LoadScheme()
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main");
	local btnClose = self.m_pLayout:getChildByName("btn_close");
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_ARENA_FIGHT_LOGIC_TYPE:getInstance():closeLayer()
        end
	end
	btnClose:addTouchEventListener(fnClose);
	
end

function KGC_ARENA_FIGHT_LAYER_TYPE:Update(dt)
	
	local nStage, nStep = KGC_ARENA_FACTORY_TYPE:getInstance():GetCurrentStage();
	
	-- 阶段变化
	if self.m_nCurStage ~= nStage then
		cclog("[log]进入新阶段：%s", tostring(nStage));
		self.m_nCurStage = nStage;
		self.m_nCurStep = 0;
		self.m_bRewardFlag = false;
	end
		
	if nStage == 1 then			-- 筹码赛阶段状态判断
		self.m_nCurStage = nStage;
		local nTurn, nMaxTurn = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaDailyTurn(1);
		-- print("nStep, nTurn, nMaxTurn", nStep, nTurn, nMaxTurn);
		if nStep <= nTurn and nStep > self.m_nCurStep then
			print("跳转到筹码赛下一个阶段：", nStep);
			self.m_nCurStep = nStep;
			self:UpdateDataAtTime();
		elseif nStep == nTurn + 1 then				-- 弹出奖励界面
			if not self.m_bRewardFlag then
				self.m_bRewardFlag = true;
				
				if not true then		-- 是否已经领取奖励
					
				else
					print("打开筹码赛奖励界面：", nStep);
					KGC_UI_ARENA_REWARD_SUBLAYER_TYPE:create(self);
					
				end
				-- 请求获取八强数据
				KGC_ARENA_LOGIC_TYPE:getInstance():ReqDailyEightFightInfo();
			end
		end
	elseif nStage == 2 then		-- 八强赛阶段状态判断
		-- 判断是否已经进入八强赛
		local bInEight = KGC_ARENA_FACTORY_TYPE:getInstance():IsInEight();
		if bInEight then
			-- 八强赛只有四轮(加一个等待时间)
			local nTurn, nMaxTurn = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaDailyTurn(2);
			-- print("nStep, nTurn, nMaxTurn", nStep, nTurn, nMaxTurn);
			if nStep <= nTurn and nStep > self.m_nCurStep then
				print("跳转到八强赛下一个阶段：", nStep);
				self.m_nCurStep = nStep;
				self:UpdateDataAtTime();
			elseif nStep == nTurn + 1 then	-- 弹出奖励界面
				if not self.m_bRewardFlag then
					self.m_bRewardFlag = true;
					
					print("恭喜你八强打完了! ^_^");
				end
			end
		end
	end
end

function KGC_ARENA_FIGHT_LAYER_TYPE:UpdateData()
	--test
	self:UpdateDataAtTime();
	--test end
	
	-- 更新英雄数据, 固定左边是自己
	local tbFightInfo = KGC_ARENA_FACTORY_TYPE:getInstance():GetDailyFightInfo();
	if not tbFightInfo then
		cclog("[Error]没有战斗数据！@KGC_ARENA_FIGHT_LAYER_TYPE:UpdateData.");
		return;
	else
		local player1, player2, nSeed, nWinner = unpack(tbFightInfo);
		
		local pnlSelf = self.m_pLayout:getChildByName("pnl_player_self");
		local pnlEnemy = self.m_pLayout:getChildByName("pnl_player_enemy");
		
		local nUuid = me:GetUuid();
		if nUuid == player1:GetUuid() then
			self:UpdatePlayers(pnlSelf, player1);
			self:UpdatePlayers(pnlEnemy, player2);
		else
			self:UpdatePlayers(pnlSelf, player2);
			self:UpdatePlayers(pnlEnemy, player1);
		end
	end
end

--@function: 更新一个玩家的数据
function KGC_ARENA_FIGHT_LAYER_TYPE:UpdatePlayers(pnlPlayer, player)
	if not pnlPlayer then
		return;
	end
	
	if player then
		pnlPlayer:setVisible(true);
		local tbHeros = player:GetHeros();
		for i = 1, 3 do
			local hero = tbHeros[i];
			local szName = "img_heroeye_" .. i;
			local pnlHero = pnlPlayer:getChildByName(szName);
			self:UpdateHero(pnlHero, hero);
		end
	else
		pnlPlayer:setVisible(false);
	end
end

--@function: 更新一个英雄
function KGC_ARENA_FIGHT_LAYER_TYPE:UpdateHero(pnlHero, hero)
	if not pnlHero then
		return;
	end
	
	if hero then
		pnlHero:setVisible(true);
		
		local lblName = pnlHero:getChildByName("lbl_heroname");
		local lblLevel = pnlHero:getChildByName("lbl_level");
		local svStar = pnlHero:getChildByName("sv_star");
		
		local nQuality = hero:GetQuality();
		local nStar = hero:GetStars()
		local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
		local szIconS, szIconR, szIconP = hero:GetHeadIcon();
		
		pnlHero:loadTexture(szIconP);
		lblName:setString(hero:GetName());
		lblLevel:setString(hero:GetLevel());
		self:UpdateStars(svStar, nStar, szStarBg);
	else
		pnlHero:setVisible(false);
	end
end

--@function: 更新英雄星级
function KGC_ARENA_FIGHT_LAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_starbg_" .. i
			local imgStarEmpty = svStars:getChildByName(szName)
			imgStarEmpty:setVisible(true);
			if szStarBg then
				imgStarEmpty:loadTexture(szStarBg)
			end
			local imgStarFull = imgStarEmpty:getChildByName("img_star")
			if i <= nStar then
				imgStarFull:setVisible(true);
			else
				imgStarFull:setVisible(false);
			end
		end
	end
end

function KGC_ARENA_FIGHT_LAYER_TYPE:UpdateDataAtTime()
	local lblMoney = self.m_pLayout:getChildByName("lbl_moneynum");
	lblMoney:setString(self.m_nCurStage .. "-" .. self.m_nCurStep);
end