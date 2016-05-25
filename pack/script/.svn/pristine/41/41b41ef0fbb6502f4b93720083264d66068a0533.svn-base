----------------------------------------------------------
-- file:	resultview.lua
-- Author:	page
-- Time:	2015/08/27 14:42
-- Desc:	战斗结果界面
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/configmanager/configmanager");
local l_tbBattleResult = mconfig.loadConfig("script/cfg/battle/battleresult", true)
local l_tbCamp = def_GetFightCampData();
	
local l_tbFightFrom = {
	FROM_MAP = 1,		-- 打地图上怪物的战斗的结算界面
	FROM_PVP = 2,		-- 打pvp战斗的结算界面
}
	
local TB_STRUCT_FIGHT_RESULT_VIEW = {
	--config
	m_MAXCOL = 4,							-- 一行最多放多少
	--------------------------------------------------------
	m_pLayout = nil,
	m_pnlMain = nil,
	m_svStars = nil,
	m_btnConfirm = nil,							-- 确定退出按钮
	m_nFightFrom  = 1,							-- 哪种战斗形式打开的结算界面
	
	-- scrollview 相关配置
	m_nSVMaxHeight = 0,							-- 最大高度
	m_nWidth = 0,								-- 模版宽度
	m_nHeight = 0,								-- 模版高度
	m_nWidthSpace = 0,							-- 水平方向的间隔
	m_nHeightSpace = 0,							-- 垂直方向的间隔
	m_nHeadSpaceH = 0,							-- 水平最前面间隔
	m_nHeadSpaceV = 0,							-- 垂直最前面间隔
}

KGC_UI_FIGHT_RESULT_LAYER_TYPE = class("KGC_UI_FIGHT_RESULT_LAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_FIGHT_RESULT_VIEW)

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:OnExit()

end

---初始化
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {};
	self.m_nFightFrom = tbArg[1] or l_tbFightFrom.FROM_MAP;
	
	self:LoadScheme();
end

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_RESULT_PATH)
	self:addChild(self.m_pLayout)
	
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main")
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.m_nFightFrom == l_tbFightFrom.FROM_MAP then
				MapViewLogic:getInstance():openCurrentMap();
			elseif self.m_nFightFrom == l_tbFightFrom.FROM_PVP then
				GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PVP_ARENA_NORMAL);
				-- 战斗界面隐藏掉
				FightViewLogic:getInstance():closeLayer();
			end
			self:closeLayer();
		end
	end
	
	-- 星级
	self.m_svStars = self.m_pnlMain:getChildByName("sv_stars")
	
	-- 奖励
	self.m_pnlReward = self.m_pLayout:getChildByName("pnl_rewards");
	self.m_pnlReward:setVisible(false);
	
	self.m_btnConfirm = self.m_pLayout:getChildByName("btn_confirm");
	self.m_btnConfirm:addTouchEventListener(fnClose);
	self.m_btnConfirm:setTouchEnabled(false);
	
	-- 经验条
	self.m_pnlExp = self.m_pLayout:getChildByName("pnl_exp");
	self.m_pnlExp:setVisible(false);
	
	-- 失败提示面板
	self.m_pnlTip = self.m_pLayout:getChildByName("pnl_tip");
	self.m_pnlTip:setVisible(false);
	
	
	-- 计算scrollview需要的数据
	self.m_svReward = self.m_pnlReward:getChildByName("sv_reward")
	self.m_svReward:setVisible(false);
	local sizeSV = self.m_svReward:getInnerContainerSize();
	self.m_nSVMaxHeight = sizeSV.height;
	self.m_pnlTemplate = self.m_svReward:getChildByName("img_item")
	self.m_pnlTemplate:setVisible(false);
	local pnlTemplateH = self.m_svReward:getChildByName("img_itemH")		-- 水平间隔计算
	local pnlTemplateV = self.m_svReward:getChildByName("img_itemV")		-- 垂直间隔计算
	pnlTemplateH:setVisible(false);
	pnlTemplateV:setVisible(false);
	local size = self.m_pnlTemplate:getContentSize();
	self.m_nWidth = size.width;
	self.m_nHeight = size.height;
	local x, y = self.m_pnlTemplate:getPosition();
	local xH, yH = pnlTemplateH:getPosition();
	local xV, yV = pnlTemplateV:getPosition();
	self.m_nWidthSpace = xH - x - size.width;
	self.m_nHeightSpace = y - yV - size.height;
	self.m_nHeadSpaceH = x;
	self.m_nHeadSpaceV = sizeSV.height - y;
end

--@function: 更新界面数据
--@nAPCost:  战斗消耗的补给
--@nWinCamp: 1-胜利;2-失败(和阵营对应)
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateData(nWinCamp, nHPLeftRate, nSign, tbReward)
	local nGold, nExp, nAP, tbItems = unpack(tbReward or {});
	nAP = nAP or 0;
	nGold = nGold or 0;
	nExp = nExp or 0;
	tbItems = tbItems or {}
	print("Fight Result UpdateData(Gold, nExp, nAP, nHPLeftRate): ", nGold, nExp, nAP, nHPLeftRate)
	-- 战斗结果：胜利 or 失败
	self:UpdateResult(nHPLeftRate)
	
	-- 更新奖励
	self:UpdateReward(nGold, nExp, nAP, tbItems)

	self:UpdateTeam();
	self:UpdateHeros();
end

--@function: 新的更新界面函数, 要求传进来的数值类奖励先拼好
--@nAPCost:  战斗消耗的补给
--@nWinCamp: 1-胜利;2-失败(和阵营对应)
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateDataNew(nWinCamp, nHPLeftRate, tbCurrency, tbItemObjs)
	local tbItemObjs = tbItemObjs or {}
	print("Fight Result UpdateData(nHPLeftRate): ", nHPLeftRate)
	-- 战斗结果：胜利 or 失败
	self:UpdateResult(nHPLeftRate)
	
	-- 更新奖励
	self:UpdateRewardNew(tbCurrency, tbItemObjs)

	self:UpdateTeam();
	self:UpdateHeros();
end

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateStars(svStars, nStar)
	print("UpdateStars", nStar);
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_star" .. i
			local imgStarEmpty = svStars:getChildByName(szName)
			imgStarEmpty:setVisible(true);
			local imgStarFull = imgStarEmpty:getChildByName("img_star")
			if i <= nStar then
				imgStarFull:setVisible(true);
			else
				imgStarFull:setVisible(false);
			end
		end
	end
end

--@function: 更新奖励界面, 第一部分(经验、金币、行动力、标记)
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateReward(nGold, nExp, nAP, tbItems)
	print("UpdateReward", nGold, nExp, nAP, nTime);
	
	-- 构造非道具奖励
	local tbData = {}
	if nGold and nGold > 0 then
		local szIcon = gf_GetIconStructByType("gold").iconpath;
		table.insert(tbData, {"", szIcon, nGold})
	end
	
	if nExp and nExp > 0 then
		local szIcon = gf_GetIconStructByType("heroexp").iconpath;
		table.insert(tbData, {"", szIcon, nExp})
	end
	
	if nAP and nAP > 0 then
		local szIcon = gf_GetIconStructByType("ap").iconpath;
		table.insert(tbData, {"", szIcon, nAP})
	end
	
	-- 道具类奖励
	for _, data in pairs(tbItems or {}) do
		local item, num = unpack(data or {});
		if item and num then
			local szQuality = item:GetQualityIcon();
			local szIcon = item:GetIcon();
			table.insert(tbData, {szQuality, szIcon, num})
		end
	end
	
	self:LoadReward(tbData)
end

--@function: 更新奖励界面, 第一部分(经验、金币、行动力、标记)
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateRewardNew(tbCurrency, tbItems)
	print("UpdateRewardNew", nGold, nExp, nAP, nTime);
	
	-- 构造非道具奖励
	local tbData = {}
	for k, v in pairs(tbCurrency or {}) do
		if v > 0 then
			local szIcon = gf_GetIconStructByType(k).iconpath;
			table.insert(tbData, {"", szIcon, v})
		end
	end
	
	-- 道具类奖励
	for _, data in pairs(tbItems or {}) do
		local item, num = unpack(data or {});
		if item and num then
			local szQuality = item:GetQualityIcon();
			local szIcon = item:GetIcon();
			table.insert(tbData, {szQuality, szIcon, num})
		end
	end
	
	self:LoadReward(tbData)
end

--@function: 加载奖励
--@tbCurrency: tbData
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:LoadReward(tbData)
	print("LoadReward", #(tbData or {}));
	if not tbData then
		return;
	end
	-- 每一行最多放四个
	local fnTouchItem = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- self:TouchItem(sender);
		end
	end
	
	local nMax = #tbData;
	local fnUpdate = function(i, data)
		if not data then
			return;
		end
		-- 位置调整
		local nRow = math.floor((i-1)/self.m_MAXCOL) + 1;
		local nCol = (i-1) % self.m_MAXCOL + 1;
		local szQuality, szIcon, nNum = data[1] or "", data[2] or "", data[3] or 0;
		local item = self.m_pnlTemplate:clone();
		self:UpdateItem(item, data);
		item:setVisible(true);
		local x = self.m_nHeadSpaceH + (nCol-1) * (self.m_nWidth + self.m_nWidthSpace);
		local nHeight = self.m_nHeadSpaceV + (nRow-1) * (self.m_nHeight + self.m_nHeightSpace);
		local y = self.m_nSVMaxHeight - nHeight;
		item:setPosition(cc.p(x, y));
		self.m_svReward:addChild(item);
		item:addTouchEventListener(fnTouchItem);
	end
	
	self.m_svReward:setVisible(true);
	for i = 1, nMax do
		fnUpdate(i, tbData[i]);
	end
	
end

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateResult(nHPLeftRate)
	print("UpdateResult", nHPLeftRate);
	if not nHPLeftRate then
		cclog("[Error]补给错误nSupplyDec:%s", tostring(nHPLeftRate))
		self:PlayStarsEffect(0);
		return;
	end
	local nHPLeftRate = tonumber(nHPLeftRate);
	local nStar, szPath = self:GetResultConfig(nHPLeftRate)
	if not nStar or not szPath then
		cclog("[Error]错误的战斗结果配置表, 星级或者路径没有找到")
		return;
	end
	
	-- 胜利不一样，加载不一样的资源
	local imgResult = self.m_pnlMain:getChildByName("img_result")
	imgResult:loadTexture(szPath)
	
	-- 补给
	local lblSupply = self.m_pnlReward:getChildByName("lbl_suppliesnum")
	local szSupply = "-" .. nHPLeftRate .. "%"
	lblSupply:setString(szSupply)
	
	-- 星级播放特效
	self:PlayStarsEffect(nStar);
end

--@function: 根据补给值得到是哪一档的奖励
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:GetResultConfig(nHPLeftRate)
	-- 配置表是百分之的
	local nHPLeftRate = (nHPLeftRate or 0) * 100;
	
	local nMax = 100;
	-- notify: key为字符串了，不能通过#l_tbBattleResult获得最大值
	local nIndex = 0;
	for _, tbData in pairs(l_tbBattleResult) do
		nIndex = nIndex + 1;
	end

	for _, tbData in pairs(l_tbBattleResult) do
		local k = tonumber(tbData.Key);
		local tbHPRange = tbData.RemainingBlood or {};
		local nStart, nEnd = tbHPRange[1] or 0, tbHPRange[2] or 0;
		if nHPLeftRate <= nEnd and k < nIndex then
			nIndex = k;
		end
	end
	
	local tbConfig = l_tbBattleResult[tostring(nIndex)];
	local nStar = tbConfig.StarLevel;
	local szPath = tbConfig.PicRes;
	print("GetResultConfig: ", nIndex, nStar, szPath);
	return nStar, szPath;
	-- cclog("[Error]没有找到对应补给的配置表GetResultConfig(%s)", tostring(nHPLeftRate))
end

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:PlayStarsEffect(nStar, fnCallBack)
	print("PlayStarsEffect", nStar, fnCallBack);
	local nStar = nStar or 0;
	if nStar > 5 then
		nStar = 5;
	end
	
	-- 动作回调函数
	local fnCall = function()
		if fnCallBack then
			fnCallBack();
		end
		
		self:UpdateStars(self.m_svStars, nStar);
		
		-- 可见
		self.m_btnConfirm:setTouchEnabled(true);
		self.m_pnlReward:setVisible(true);
		
		if nStar > 0 then		-- 胜利
			self.m_pnlExp:setVisible(true);
		else					-- 失败
			self.m_pnlTip:setVisible(true);
		end
	end
	
	local fnPlayStar = function()
		if nStar <= 0 then
			fnCall();
		else
			for i = 1, nStar do
				local szAction = "star" .. i;
				local action = nil;
				if i == 1 then
					self:PlayUIAction("ui_fight_result.json", szAction, cc.CallFunc:create(fnCall));
				else
					self:PlayUIAction("ui_fight_result.json", szAction);
				end
			end
		end
	end
	
	-- 胜利或者失败的动画
	local szAction = "";
	if nStar > 0 then
		szAction = "win";
	else
		szAction = "lose";
	end

	self:PlayUIAction("ui_fight_result.json", szAction, cc.CallFunc:create(fnPlayStar));
end

--@function: 队伍信息
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateTeam()
	print("UpdateTeam");
	-- 团队经验
	local nTeamLevel = me:GetLevel();
	local nExp = me:GetExp()
	local nLevelUpExp = me:GetLevelUpExp();
	local szExp = nExp .. "/" .. nLevelUpExp;
	local nPercent = nExp / nLevelUpExp * 100;
	
	local imgPlayerInfo = self.m_pnlExp:getChildByName("img_playerlevel");
	local bmlLevel = imgPlayerInfo:getChildByName("bmp_playerlevel");
	local barExp = imgPlayerInfo:getChildByName("bar_exp");
	local bmlExp = imgPlayerInfo:getChildByName("bmp_expnum");
	
	bmlLevel:setString(nTeamLevel);
	barExp:setPercent(nPercent);
	bmlExp:setString(szExp);
end

--@function: 英雄信息
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateHeros()
	local tbHeros = me:GetHeros();
	for i = 1, 3 do
		local szName = "pnl_hero_" .. i;
		local pnlHero = self.m_pnlExp:getChildByName(szName);
		if pnlHero then
			local hero = tbHeros[i]
			self:UpdateHero(pnlHero, hero);
		end
	end
end

function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateHero(pnlHero, hero)
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

--@function: 更新一个Item
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:UpdateItem(widget, tbData)
	if not widget or not tbData then
		cclog("[Error]控件或者要显示的对象为空");
		return;
	end
	local szQuality, szIcon, nNum = tbData[1] or "", tbData[2] or "", tbData[3] or 0;
	widget:setVisible(true);
	local imgQuality = widget:getChildByName("img_quality");	-- 品质框
	local imgIcon = widget:getChildByName("img_icon");			-- 图标
	local lblNum = widget:getChildByName("bml_num");			-- 数量
	imgQuality:loadTexture(szQuality);
	imgIcon:loadTexture(szIcon);
	lblNum:setString(nNum);
end
-------------------------------------------------------------
--test

--@function: 随机给一个扣除的补给百分比
function KGC_UI_FIGHT_RESULT_LAYER_TYPE:TestGetSupply()
	local tbSupply = {}
	for _, tbData in pairs(l_tbBattleResult) do
		table.insert(tbSupply, tbData.SupplyDeduction or 0);
	end
	local nRand = math.random(#tbSupply);

	return nRand;
end