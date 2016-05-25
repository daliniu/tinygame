----------------------------------------------------------
-- file:	normallayer.lua
-- Author:	page
-- Time:	2015/11/30 19:42
-- Desc:	竞技场日竞技赛战斗界面
----------------------------------------------------------
require("script/ui/resource");
require("script/ui/arenaview/normalview/arena_heroinfo_sublayer");
require("script/core/configmanager/configmanager");
require("script/ui/publicview/mainbuttonview");
----------------------------------------------------------
local l_tbNormalRewardConfig = mconfig.loadConfig("script/cfg/pvp/SportsChest");
--data struct
local TB_STRUCT_ARENA_NROMAL_LAYER = {
	-- config

	----------------------------------------------------------
	m_pLayout = nil,					-- json界面
	
	m_pnlPlayerInfoTemplate = nil,		-- listview的模版
	m_tbRewardButton = {},				-- 奖励宝箱按钮
	
	m_tbPlayerData = {},				-- 每一个panel对应的玩家数据对象
}

KGC_ARENA_NORMAL_LAYER_TYPE = class("KGC_ARENA_NORMAL_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_ARENA_NROMAL_LAYER)
--------------------------------
--ui function
--------------------------------

function KGC_ARENA_NORMAL_LAYER_TYPE:Init()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_NROMAL_PATH);
    self:addChild(self.m_pLayout);
	self:LoadScheme();
	self:UpdateData();
end

--解析界面文件
function KGC_ARENA_NORMAL_LAYER_TYPE:LoadScheme()
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main");
	local btnClose = self.m_pLayout:getChildByName("btn_close");
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 打开主面板
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA);
			
			KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance():closeLayer()
        end
	end
	btnClose:addTouchEventListener(fnClose);
	
	-- 玩家panel
	self.m_pnlPlayerInfoTemplate = self.m_pLayout:getChildByName("pnl_playerinfo");
	self.m_pnlPlayerInfoTemplate:setVisible(true);
	
	self.m_lvPlayers = self.m_pLayout:getChildByName("lv_playerinfo");
	self.m_lvPlayers:setItemModel(self.m_pnlPlayerInfoTemplate);
	self.m_pnlPlayerInfoTemplate:setVisible(false);
	
	-- 奖励宝箱
	local fnGetReward = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:GetWinReward(sender);
		end
	end
	for i = 1, 3 do
		local szName = "btn_cage" .. i;
		local btnBox = self.m_pnlMain:getChildByName(szName);
		btnBox.m_index = i;
		self.m_tbRewardButton[i] = btnBox;
		btnBox:addTouchEventListener(fnGetReward);
	end
	
	-- 退出战斗
	local fnQuit = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:QuitFight(sender);
		end
	end
	local btnQuit = self.m_pLayout:getChildByName("btn_quit");
	btnQuit:addTouchEventListener(fnQuit);
	
	--创建主按钮
    self.m_pMainBtnLayer = MainButtonLayer:create()
    self:AddSubLayer(self.m_pMainBtnLayer)
end


function KGC_ARENA_NORMAL_LAYER_TYPE:UpdateData()
	self:UpdateReward();
	self:UpdatePlayers();
	
	-- 更新己方阵容
	self:UpdateSelf();
	
	-- 战斗次数
	local nCount, nMax = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalFightCount();
	local lblFightCount = self.m_pLayout:getChildByName("lbl_fightnum");
	local lblTotalCount = self.m_pLayout:getChildByName("lbl_total");
	lblFightCount:setString(nCount);
	lblTotalCount:setString(nMax);
	if nCount <= 0 then
		lblFightCount:setColor(cc.c3b(255, 0, 0));
	else
		lblFightCount:setColor(cc.c3b(255, 255, 255));
	end
	
end

--@function: 更新奖励宝箱
function KGC_ARENA_NORMAL_LAYER_TYPE:UpdateReward()
	local tbRewardFlag = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalRewardFlag();
	local nWinCount =  KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalWinCount();
	print("nWinCount: ", nWinCount);
	local barBox = self.m_pnlMain:getChildByName("bar_fightgoing");
	for i = 1, 3 do
		local szName = "btn_cage" .. i;
		local btnBox = self.m_pnlMain:getChildByName(szName);
		local imgTip = btnBox:getChildByName("img_get");	-- 点击领取图标
		
		local nFlag = tbRewardFlag[i] or 0;
		local bEnabled = false;
		-- 胜利次数决定宝箱是否可以领取
		local nNeedWin = 0;
		if l_tbNormalRewardConfig[i] then
			nNeedWin = l_tbNormalRewardConfig[i].WinNum or 0;
		end
		print("nFlag, nNeedWin: ", nFlag, nNeedWin);
		local nPercent = nWinCount * 20;
		if nPercent < 0 then
			nPercent = 0;
		end
		print("nPercent", nPercent);
		if nWinCount >= nNeedWin then
			-- 是否已经领取标志
			if nFlag == 0 then
				bEnabled = true;
			end
		end
		
		barBox:setPercent(nPercent);
		btnBox:setTouchEnabled(bEnabled);
		if bEnabled then
			imgTip:setVisible(true);
			
			-- 特效
			local nLayerID = self:GetLayerID();		-- for 特效
			local effect = af_BindEffect2Node(btnBox, 60067, {nil, -1}, 1, nil, {nil, 1, nLayerID});
			btnBox.m_effect = effect;
		else
			imgTip:setVisible(false);
		end
	end
end

--@function: 更新己方阵容
function KGC_ARENA_NORMAL_LAYER_TYPE:UpdateSelf()
	local pnlMine = self.m_pnlMain:getChildByName("pnl_myinfo");
	local tbHeros = me:GetHeros();
	for i = 1, 3 do
		local hero = tbHeros[i];
		local szName = "img_herobg_" .. i;
		local imgHeroBg = pnlMine:getChildByName(szName);
		self:UpdateHero(imgHeroBg, hero);
	end
	
	-- 调整布阵
	local fnLineup = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP);
		end
	end
	local btnLineup = pnlMine:getChildByName("btn_change");
	btnLineup:addTouchEventListener(fnLineup);
	
	-- 战斗力
	local nFP = me:GetFightPoint();
	local bmpFightPoint = pnlMine:getChildByName("bmp_playerbattlescore");
	bmpFightPoint:setString(nFP);
end

function KGC_ARENA_NORMAL_LAYER_TYPE:UpdatePlayers()
	local tbFightInfo = KGC_ARENA_FACTORY_TYPE:getInstance():GetNormalFightInfo();
	local nCount = 0;
	-- 清空
	self.m_lvPlayers:removeAllItems();
	self.m_tbPlayerData = {};
	
	local fnTouchHero = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:ShowHeroInfo(sender);
		end
	end
	
	local fnFight = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:StartFight(sender);
		end
	end
	
	--notify: 排序过的并且使用ipairs取
	for k, tbData in ipairs(tbFightInfo) do
		local nIndex = tbData.index;
		local player = tbData.player;
		local nResult = tbData.result;
		local nMasterScore = tbData.masterscore;
		
		self.m_lvPlayers:pushBackDefaultItem();
		local panel = self.m_lvPlayers:getItem(k-1);
		panel:setVisible(true);
		panel:addTouchEventListener(fnTouchHero);
		panel.m_index = nIndex;
		
		local btnHead = panel:getChildByName("btn_head");
		local bmpLevel = btnHead:getChildByName("bmp_level");
		local lblName = btnHead:getChildByName("lbl_npc_name");
		bmpLevel:setString(player:GetLevel());
		lblName:setString(player:GetName());
		
		-- 上阵英雄
		local tbHeros = player:GetHeros() or {};
		for i = 1, 3 do
			local hero = tbHeros[i];
			local szName = "img_herobg_" .. i;
			local imgHeroBg = panel:getChildByName(szName);
			self:UpdateHero(imgHeroBg, hero);
		end
		
		-- 战斗力
		local bmpFightPoint = panel:getChildByName("bmp_playerbattlescore");
		bmpFightPoint:setString(player:GetFightPoint());
		
		-- 开战
		local btnFight = panel:getChildByName("btn_fight");
		btnFight.m_index = nIndex;
		btnFight:addTouchEventListener(fnFight);
		
		-- 保存数据对应
		self.m_tbPlayerData[nIndex] = player;
		
		-- 已经战胜了的话叉叉掉
		local pnlCover = panel:getChildByName("pnl_cover");
		cclog("UpdatePlayers, player(%s), index = %s, nResult = %s", tostring(player:GetUuid()), tostring(nIndex), tostring(nResult));
		if nResult == 1 then
			pnlCover:setVisible(true);
		else
			pnlCover:setVisible(false);
		end
	end
end

--@function: 更新一个英雄面板
function KGC_ARENA_NORMAL_LAYER_TYPE:UpdateHero(widget, hero)
	if not widget then
		return;
	end
	
	local imgHeroBg = widget;
	local lblLevel = imgHeroBg:getChildByName("lbl_level")				-- 英雄等级
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local svStars = imgHeroBg:getChildByName("sv_star");				-- 英雄星级
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
	local bmpFightPoint = imgFightPoint:getChildByName("bmp_fightnum");	-- 英雄战斗力
	
	if not hero then
		imgHeroBg:setVisible(false);
		return;
	end
	imgHeroBg:setVisible(true);
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	
	imgHeroBg:loadTexture(szHeroBg);
	lblLevel:setString(hero:GetLevel());
	self:UpdateStars(svStars, nStar, szStarBg)
	imgHero:loadTexture(szIconS);
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	bmpFightPoint:setString(hero:GetFightPoint());
	
	-- 更新装备
	-- cclog("[Log]更新装备，英雄(%s), 位置(%d)", hero:GetName(), hero:GetPos())
	-- local nSuit = hero:GetEquipSuit();
	-- self:UpdateEquips(widget, nSuit)
end

function KGC_ARENA_NORMAL_LAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_starbg0" .. i
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

--@function: 显示英雄的详细信息
function KGC_ARENA_NORMAL_LAYER_TYPE:ShowHeroInfo(widget)
	local nIndex = widget.m_index;
	local player = self.m_tbPlayerData[nIndex];
	KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:create(self, {player});
end

--@function: 领取奖励
function KGC_ARENA_NORMAL_LAYER_TYPE:GetWinReward(widget)
	print("获取奖励 ... ", widget.m_index);
	if widget.m_effect then
		widget.m_effect:removeFromParent(true);
		widget.m_effect = nil;
	end
	widget:setTouchEnabled(false);
	
	KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance():ReqGetReward(widget.m_index);
end

--@function: 开战
function KGC_ARENA_NORMAL_LAYER_TYPE:StartFight(widget)
	if not widget then
		return;
	end
	
	local nCount = KGC_ARENA_FACTORY_TYPE:getInstance():GetArenaNormalFightCount();
	if nCount > 0 then
		local fnCallBack = function()
			local nIndex = widget.m_index;
			local player = self.m_tbPlayerData[nIndex];
			if player then
				-- 战斗次数 + 1;
				KGC_ARENA_FACTORY_TYPE:getInstance():AddArenaNormalWinCount();
				-- 向服务器请求
				KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance():ReqStartFight(nIndex, player);
			end
		end
		-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP, {fnCallBack});
		fnCallBack();
	else
		TipsViewLogic:getInstance():addMessageTips(12300);
	end
end

--@function: 退出战斗
function KGC_ARENA_NORMAL_LAYER_TYPE:QuitFight(widget)
	KGC_ARENA_NORMAL_LOGIC_TYPE:getInstance():ReqQuitFight();
end