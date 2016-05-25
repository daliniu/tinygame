----------------------------------------------------------
-- file:	hero_reinforce_sublayer.lua
-- Author:	page
-- Time:	2015/09/18 09:59
-- Desc:	英雄强化面板(升品、升星)
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require ("script/core/arena/factory");

-- 表情类型
local l_tbPageType = {
	PT_MYNE = 1,		-- 我的战斗
	PT_EIGHT = 2,		-- 八强战斗
	PT_MAX = 3,			
};

local TB_STRUCT_ARENA_WATCH_GAME_SUBLAYER = {
	-- config
	m_nUpHeightAdd = 16,		-- 标签页按钮选中的高度增加
	---------------------------------------
	m_pLayout = nil,

	m_nCurPage = 0,				-- 当前标签页
	m_tbPages = {				-- page 界面
	},
	m_tbButtons = {},			-- 标签按钮
	m_sizeButtonNameBg = nil,	-- 标签页按钮底图
	
	m_Factory,					-- 兵工厂
	
	--------------------------------------
	-- 我的战斗
	m_pnlFightTemplate = nil,	-- 一个战斗的模版panel
	m_lvFightList = nil,		-- 所有战斗所在的listview
	--------------------------------------
	-- 八强战斗
	m_pnlData = nil,			-- 八强赛数据panel
	--------------------------------------
}

KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE = class("KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE", 
	KGC_UI_BASE_SUB_LAYER, 
	TB_STRUCT_ARENA_WATCH_GAME_SUBLAYER)

function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:OnExit()
    
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {}
	-- 初始化一个Factory
	self.m_Factory = KGC_ARENA_FACTORY_TYPE:getInstance();
	
	-- 初始化界面
	self:LoadScheme();
	
	-- 更新数据
	self:ChangePage(l_tbPageType.PT_MYNE);
	
	self:UpdateMyFight();
	self:UpdateEightFight();
end

function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_WATCH_GAME_PATH)
	self:addChild(self.m_pLayout)

	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			print("close ... ");
			self:closeLayer();
		end
	end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	---------------------------------------- 我的战斗
	-- 加载我的战斗界面
	local layoutMineFight = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_WG_MINE_PATH)
	layoutMineFight:setVisible(true)
	self.m_pLayout:addChild(layoutMineFight)
	self.m_tbPages[l_tbPageType.PT_MYNE] = layoutMineFight;
	
	self:LoadMineFightScheme(layoutMineFight);
	---------------------------------------- 八强战斗
	-- 加载八强战斗界面
	local layoutEightFight = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_WG_EIGHT_PATH)
	layoutEightFight:setVisible(false);
	self.m_pLayout:addChild(layoutEightFight)
	self.m_tbPages[l_tbPageType.PT_EIGHT] = layoutEightFight;
	
	self:LoadEightFightScheme(layoutEightFight);
	---------------------------------------- end
	
	-- 标签页按钮
	local btnMyFight = self.m_pLayout:getChildByName("btn_myfight")
	local btnEightFight = self.m_pLayout:getChildByName("btn_topeight")
	self.m_tbButtons[l_tbPageType.PT_MYNE] = btnMyFight;
	self.m_tbButtons[l_tbPageType.PT_EIGHT] = btnEightFight;
	
	local fnChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnMyFight then
				self:ChangePage(l_tbPageType.PT_MYNE)
			elseif sender == btnEightFight then
				self:ChangePage(l_tbPageType.PT_EIGHT)
			end
		end
	end
	btnMyFight:addTouchEventListener(fnChange);
	btnEightFight:addTouchEventListener(fnChange);
	
	-- 图片参考
	local imgBgMy = btnMyFight:getChildByName("img_bg");
	local imgBgEight = btnEightFight:getChildByName("img_bg");
	self.m_sizeButtonNameBg = imgBgMy:getContentSize();
	-- 设置锚点: 选中的高度要变高, 锚点设置在下面方便
	imgBgMy:setAnchorPoint(cc.p(0.5, 0));
	imgBgEight:setAnchorPoint(cc.p(0.5, 0));
end

--@function: 解析我的战斗界面
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:LoadMineFightScheme(pnlMineFight)
	print("LoadMineFightScheme ... ", pnlMineFight);
	if not pnlMineFight then
		return;
	end
	-- 玩家panel
	self.m_pnlFightTemplate = pnlMineFight:getChildByName("pnl_fight");
	self.m_pnlFightTemplate:setVisible(true);
	self.m_lvFightList = pnlMineFight:getChildByName("lv_fightlist");
	self.m_lvFightList:setItemModel(self.m_pnlFightTemplate);
	self.m_pnlFightTemplate:setVisible(false);
end

--@function: 解析八强战斗界面
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:LoadEightFightScheme(pnlEightFight)
	print("LoadEightFightScheme ... ", pnlEightFight);
	if not pnlEightFight then
		return;
	end
	
	self.m_pnlData = pnlEightFight:getChildByName("pnl_data");
end

--@function: 切换标签页
--@nPage: 1-我的战斗; 2-八强战斗
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:ChangePage(nPage)
	if nPage and nPage ~= self.m_nCurPage then
		local layout = self.m_tbPages[nPage]
		if layout then
			layout:setVisible(true)
			-- 显示当前页，其他的隐藏
			for k, v in pairs(self.m_tbPages) do
				if v ~= layout then
					v:setVisible(false)
				end
			end
			self.m_nCurPage = nPage;
		end
		
		self:ChangeButton(nPage)
	end
	
end

function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:ChangeButton(nPage)
	local tbImages = {
		[1] = "res/ui/06_bagandrole/06_btn_tap_01a.png",
		[2] = "res/ui/06_bagandrole/06_btn_tap_01.png",
	};
	for page, button in pairs(self.m_tbButtons or {}) do
		local size = self.m_sizeButtonNameBg or cc.size(200, 47);
		local imgBg = button:getChildByName("img_bg");
		if page == nPage then
			imgBg:loadTexture(tbImages[1]);
			local w, h = size.width, size.height + self.m_nUpHeightAdd;
			imgBg:setContentSize(cc.size(w, h));
		else
			imgBg:loadTexture(tbImages[2]);
			imgBg:setContentSize(size);
		end
	end
end

--@function: 主界面更新通知二级界面更新
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	
end
-------------------------------------------------------------------
-- ***我的战斗***

--@function: 更新我的参与的所有战斗
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:UpdateMyFight()
	self.m_lvFightList:removeAllItems();
	
	local fnFight = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- self:TouchEventStartFight(sender);
			print("fight ... ");
		end
	end
	
	-- 更新玩家数据
	local fnUpdatePlayer = function(btnPlayer, player)
		if not btnPlayer then
			return;
		end
		
		local lblName = btnPlayer:getChildByName("lbl_npc_name");
		local lblLevel = btnPlayer:getChildByName("bmp_level");
		if player then
			btnPlayer:loadTextureNormal(CUI_PATH_MAJOR_ROLE_HEAD);
			lblName:setVisible(true);
			lblLevel:setVisible(true);
			lblLevel:setString(player:GetLevel());
			lblName:setString("【" .. player:GetUuid() .. "】");
		else
			btnPlayer:loadTextureNormal(CUI_PATH_NULL_ROLE_HEAD);
			lblName:setVisible(false);
			lblLevel:setVisible(false);
		end
	end
	
	local tbFightInfo  = KGC_ARENA_FACTORY_TYPE:getInstance():GetDailyChipsFightInfo();
	print("我的战斗场次：", #tbFightInfo);
	local nCount = 0;
	for _, tbData in pairs(tbFightInfo) do
		self.m_lvFightList:pushBackDefaultItem();
		nCount = nCount + 1;
		local panel = self.m_lvFightList:getItem(nCount-1);
		panel:setVisible(true);
		
		local player1, player2, nSeed, nWinner = unpack(tbData or {});
		if player1 and player2 then
			local playerSelf, playerEnemy = nil, nil;
			if player1:GetUuid() == me:GetUuid() then
				playerSelf, playerEnemy = player1, player2;
			else
				playerSelf, playerEnemy = player2, player1;
			end
			
			-- 己方
			local btnPlayerSelf = panel:getChildByName("btn_playerhead");
			fnUpdatePlayer(btnPlayerSelf, playerSelf);
			-- 敌方
			local btnPlayerSelf = panel:getChildByName("btn_enemyhead");
			fnUpdatePlayer(btnPlayerSelf, playerSelf);
		end

		-- 播放
		local btnFight = panel:getChildByName("btn_fight");
		btnFight:addTouchEventListener(fnFight);
	end
end
-------------------------------------------------------------------
-- ***八强战斗***
--@function: 更新当前八强战斗
--@notify：服务器传回来的数据是有排名顺序的
function KGC_UI_ARENA_WATCH_GAME_SUBLAYER_TYPE:UpdateEightFight()
	local nStage, nStep = KGC_ARENA_FACTORY_TYPE:getInstance():GetCurrentStage();
	local tbFightInfo4, tbFightInfo2, tbFightInfo1 = KGC_ARENA_FACTORY_TYPE:getInstance():GetDailyEightFightInfo();
	local tbPlayers = KGC_ARENA_FACTORY_TYPE:getInstance():GetDailyEightFightPlayers();
	
	-- 四强轮
	--[[
		左上：1-8; 阵营1
		左下：2-7; 阵营2
		右上：3-6; 阵营1
		右下：4-5; 阵营2
	]]
	local fnUpdateHead = function(widget, uuid)
		if not widget then
			return;
		end
		local lblLevel = widget:getChildByName("bmp_level");		-- 等级
		local lblName = widget:getChildByName("lbl_npc_name");		-- 名字
		local player = tbPlayers[uuid];
		if player then
			widget:loadTextureNormal(CUI_PATH_MAJOR_ROLE_HEAD);
			lblLevel:setVisible(true);
			lblLevel:setString(player:GetLevel());
			lblName:setString("【" .. player:GetUuid() .. "】");
		else
			widget:loadTextureNormal(CUI_PATH_NULL_ROLE_HEAD);
			lblLevel:setVisible(false);
			lblName:setString("【未决出】");
		end
	end
	
	-- 四强轮
	for i = 1, 4 do
		local szName1 = "btn_playerhead_A" .. i;
		local szName2 = "btn_playerhead_A" .. (9-i);
		local btnPlayer1 = self.m_pnlData:getChildByName(szName1);
		local btnPlayer2 = self.m_pnlData:getChildByName(szName2);
		local tbData = (tbFightInfo4 or {})[i];
		
		if tbData then
			local nUuid1, nUuid2, nSeed, nWinner = unpack(tbData);
			print("UpdateEightFight 4: ", nUuid1, nUuid2, nSeed, nWinner);
			fnUpdateHead(btnPlayer1, nUuid1);
			fnUpdateHead(btnPlayer2, nUuid2);
			
			-- 设置对战数据到下一轮
			local szNameWinner = "btn_playerhead_B" .. i;
			local btnPlayerWinner = self.m_pnlData:getChildByName(szNameWinner);
			btnPlayerWinner.m_data = tbData;
		else
			
		end
	end
	
	-- 冠亚轮
	--[[
		-- 1 vs 3
		-- 2 vs 4
	]]
	for i = 1, 2 do
		local szName1 = "btn_playerhead_B" .. i;			
		local szName2 = "btn_playerhead_B" .. i + 2;		
		local btnPlayer1 = self.m_pnlData:getChildByName(szName1);
		local btnPlayer2 = self.m_pnlData:getChildByName(szName2);
		local tbData = (tbFightInfo2 or {})[i];
		
		if tbData then
			local nUuid1, nUuid2, nSeed, nWinner = unpack(tbData);
			print("UpdateEightFight 2: ", nUuid1, nUuid2, nSeed, nWinner);
			fnUpdateHead(btnPlayer1, nUuid1);
			fnUpdateHead(btnPlayer2, nUuid2);
			
			-- 设置对战数据到下一轮
			local szNameWinner = "btn_playerhead_C" .. i;
			local btnPlayerWinner = self.m_pnlData:getChildByName(szNameWinner);
			btnPlayerWinner.m_data = tbData;
		else
			
		end
	end
	
	-- 决赛轮
	local nChampionUuid = nil;
	for i = 1, 1 do
		local szName1 = "btn_playerhead_C" .. i;
		local szName2 = "btn_playerhead_C" .. i + 1;
		local btnPlayer1 = self.m_pnlData:getChildByName(szName1);
		local btnPlayer2 = self.m_pnlData:getChildByName(szName2);
		local tbData = (tbFightInfo1 or {})[i];
		
		if tbData then
			local nUuid1, nUuid2, nSeed, nWinner = unpack(tbData);
			print("UpdateEightFight 1: ", nUuid1, nUuid2, nSeed, nWinner);
			fnUpdateHead(btnPlayer1, nUuid1);
			fnUpdateHead(btnPlayer2, nUuid2);
			
			nChampionUuid = nUuid1;
			if nWinner == 2 then
				nChampionUuid = nUuid2;
			end
			
			-- 设置对战数据到下一轮
			local szNameWinner = "btn_playerhead_C" .. i;
			local btnPlayerWinner = self.m_pnlData:getChildByName(szNameWinner);
			btnPlayerWinner.m_data = tbData;
		else
			
		end
	end
	
	-- 冠军
	local btnChampion = self.m_pnlData:getChildByName("btn_playerhead_winner");
	fnUpdateHead(btnChampion, nChampionUuid);
end