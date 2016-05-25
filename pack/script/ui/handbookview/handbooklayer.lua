----------------------------------------------------------
----------------------------------------------------------
-- file:	handbooklayer.lua
-- Author:	page
-- Time:	2015/09/14 14:41
-- Desc:	英雄图鉴面板
----------------------------------------------------------
require "script/ui/resource"
require("script/ui/publicview/heroinfosublayer")
require("script/ui/handbookview/resultsublayer")
----------------------------------------------------------

--data struct
local TB_STRUCT_HANDBOOK_LAYER = {
	--config

	------------------------------------------------------
	--界面
	m_Layout = nil,							--保存界面结构root
	m_pnlMain = nil,						-- 有效UI部分
	
	m_tbHeros = {							-- 绑定英雄对象
		-- [nID] = hero,
	},
	
	bIsRunning = false,						-- 动作是否正在运行中
}

KGC_HANDBOOK_LAYER_TYPE = class("KGC_HANDBOOK_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_HANDBOOK_LAYER)
--------------------------------
--ui function
--------------------------------
function KGC_HANDBOOK_LAYER_TYPE:ctor()
	
end

function KGC_HANDBOOK_LAYER_TYPE:Init()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_HANDBOOK_PATH)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	self:LoadScheme()
	
	self:LoadAllHeros();
	self:UpdateData();
end

--解析界面文件
function KGC_HANDBOOK_LAYER_TYPE:LoadScheme()
	local btnClose = self.m_Layout:getChildByName("btn_close")
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_HANDBOOK_LOGIC_TYPE:getInstance():closeLayer();
		end
	end
	btnClose:addTouchEventListener(fnClose)
	
	self.m_pnlMain = self.m_Layout:getChildByName("img_bg")
	
	-- 计算scrollview需要的数据
	self.m_svHeroList = self.m_pnlMain:getChildByName("sv_herolist")
	local sizeSV = self.m_svHeroList:getInnerContainerSize();
	self.m_nSVMaxHeight = sizeSV.height;
	self.m_pnlHeroTemplate = self.m_svHeroList:getChildByName("pnl_hero")
	self.m_pnlHeroTemplate:setVisible(false);
	local pnlHeroTemplateH = self.m_svHeroList:getChildByName("pnl_hero_1")		-- 水平间隔计算
	local pnlHeroTemplateV = self.m_svHeroList:getChildByName("pnl_hero_4")		-- 垂直间隔计算
	pnlHeroTemplateH:setVisible(false);
	pnlHeroTemplateV:setVisible(false);
	local size = self.m_pnlHeroTemplate:getContentSize();
	self.m_nWidth = size.width;
	self.m_nHeight = size.height;
	local x, y = self.m_pnlHeroTemplate:getPosition();
	local xH, yH = pnlHeroTemplateH:getPosition();
	local xV, yV = pnlHeroTemplateV:getPosition();
	self.m_nWidthSpace = xH - x - size.width;
	self.m_nHeightSpace = y - yV - size.height;

	-- 随机英雄部分
	self.m_tbCallHeroPanels = {};
	self.m_tbPanelsOriginal = {};
	local fnCall = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventSelectHero(sender);
		end
	end
	for i = 1, 4 do
		local szName = "pnl_hero" .. i;
		local pnlHero = self.m_Layout:getChildByName(szName);
		-- 从0-4好计算循环变换的数值
		pnlHero._order = i-1;
		local btnCall = pnlHero:getChildByName("btn_summon");
		btnCall:addTouchEventListener(fnCall);
		pnlHero:addTouchEventListener(fnCall);
		table.insert(self.m_tbCallHeroPanels, pnlHero);
		local x, y = pnlHero:getPosition();
		local nScale = pnlHero:getScale();
		self.m_tbPanelsOriginal[i-1] = {x, y, nScale};
		
		-- 遮罩
		local pnlCover = pnlHero:getChildByName("pnl_cover");
		if i == 1 then
			pnlCover:setVisible(false);
		else
			pnlCover:setVisible(true);
		end
	end
	
	local btnLeft = self.m_pnlMain:getChildByName("btn_left");
	local btnRight = self.m_pnlMain:getChildByName("btn_right");
	local fnTouchChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnLeft then
				self:ChangeHero(-1);
			elseif sender == btnRight then
				self:ChangeHero(1);
			end
		end
	end
	btnLeft:addTouchEventListener(fnTouchChange);
	btnRight:addTouchEventListener(fnTouchChange);
end

--@function: 加载所有英雄
function KGC_HANDBOOK_LAYER_TYPE:LoadAllHeros()
	-- 每一行最多放四个
	local MAX_COL = 4;
	
	local fnTouchHero = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventHero(sender);
		end
	end
	
	local fnUpdateHero = function(i, hero)
		-- 位置调整
		local nRow = math.floor((i-1)/MAX_COL) + 1;
		local nCol = (i-1) % MAX_COL + 1;
		local pnlHero = self.m_pnlHeroTemplate:clone();
		pnlHero:setVisible(true);
		local x = (nCol-1) * (self.m_nWidth + self.m_nWidthSpace);
		local y = self.m_nSVMaxHeight - nRow* (self.m_nHeight + self.m_nHeightSpace);
		pnlHero:setPosition(cc.p(x, y));
		self.m_svHeroList:addChild(pnlHero);
		pnlHero:addTouchEventListener(fnTouchHero);

		-- 数据绑定
		pnlHero._hero_obj = hero;
		
		-- 更新数据
		self:UpdateHero(pnlHero);
	end
	
	local nCount = 0;
	local tbAllHeros = KGC_HANDBOOK_LOGIC_TYPE:GetAllHeros() or {};
	local tbHeros = self:GetHeros();
	-- 排序
	local fnCompare = function(a, b)
		if a:GetHeroType() == b:GetHeroType() then
			return a:GetID() < b:GetID();
		else
			return a:GetHeroType() < b:GetHeroType();
		end
	end
	table.sort(tbAllHeros, fnCompare);

	for i = 1, #tbAllHeros do
		local hero = tbAllHeros[i];
		nCount = nCount + 1;
		fnUpdateHero(nCount, hero);
		local nHeroID = tostring(hero:GetID());
		tbHeros[nHeroID] = hero;
	end
	print("[log]加载完所有英雄...@KGC_HANDBOOK_LAYER_TYPE:LoadAllHeros")
end

--@function: 更新一个英雄面板
function KGC_HANDBOOK_LAYER_TYPE:UpdateHero(widget)
	if not widget then
		return;
	end
	local hero = widget._hero_obj;
	if not hero then
		return;
	end
	
	local imgHeroBg = widget:getChildByName("img_herobg");				-- 英雄背景
	local lblName = widget:getChildByName("lbl_heroname");				-- 英雄名字
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local svStars = imgHeroBg:getChildByName("sv_star");				-- 英雄星级
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars();
	local szType = hero:GetHeroTypeResource();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	imgHeroBg:loadTexture(szHeroBg);
	if lblName then
		lblName:setString(hero:GetName());
	end
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	imgHero:setVisible(true);
	imgHero:loadTexture(szIconS);
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	
	-- 是否已经拥有这个英雄
	local heroHas = me:GetHeroByID(hero:GetID());
	local imgCover = imgHeroBg:getChildByName("img_select");
	if heroHas then
		imgCover:setVisible(true);
	else
		imgCover:setVisible(false);
	end
end

--@function: 更新一个英雄面板
function KGC_HANDBOOK_LAYER_TYPE:UpdateRandomHero(widget)
	if not widget then
		return;
	end
	local hero = widget._hero_obj;
	
	local imgHero = widget:getChildByName("img_hero");					-- 英雄头像
	local imgType = imgHero:getChildByName("img_herotype")				-- 英雄类型
	local lblName = widget:getChildByName("lbl_heroname");				-- 英雄名字
	if hero then
		local szType = hero:GetHeroTypeResource();
		local szIconS, szIconR, szIconP, szIconSu = hero:GetHeadIcon();
		imgHero:setVisible(true);
		imgHero:loadTexture(szIconSu);
		imgType:setVisible(true);
		imgType:loadTexture(szType);
		lblName:setString(hero:GetName());
	else
		imgHero:loadTexture(CUI_PATH_HANDBOOK_RANDOM_HERO);
		imgType:setVisible(false);
		lblName:setString("随机英雄");
	end
end

function KGC_HANDBOOK_LAYER_TYPE:UpdateData(tbHeros, nTimes)
	self:UpdateRandomHeros(tbHeros);
	self:UpdateRandomTimes(nTimes);
end

--@function: 更新随机英雄
function KGC_HANDBOOK_LAYER_TYPE:UpdateRandomHeros(tbHeros, nTimes)
	local tbHeros = tbHeros or {};
	for i = 1, 4 do
		local szName = "pnl_hero" .. i;
		local pnlHero = self.m_Layout:getChildByName(szName);
		local nID = tbHeros[i];
		local hero = self:GetHeroByID(nID);
		if hero then
			local btnCall = pnlHero:getChildByName("btn_summon");
			pnlHero._hero_obj = hero;
			btnCall._hero_obj = hero;
		end
		self:UpdateRandomHero(pnlHero);
	end
end

function KGC_HANDBOOK_LAYER_TYPE:UpdateRandomTimes(nTimes)
	local nTimes = nTimes or 0;
	local imgBg = self.m_pnlMain:getChildByName("img_summonnumbg");
	local bmpNum = imgBg:getChildByName("bmp_heronum");
	bmpNum:setString(nTimes);
	
	local imgCover = self.m_pnlMain:getChildByName("img_cover");
	imgCover:setVisible(false);
	if nTimes <= 0 then
		imgCover:setVisible(true);
		imgCover:setTouchEnabled(true);
	end
end

function KGC_HANDBOOK_LAYER_TYPE:GetHeros()
	if not self.m_tbHeros then
		self.m_tbHeros = {};
	end
	return self.m_tbHeros;
end

function KGC_HANDBOOK_LAYER_TYPE:GetHeroByID(nID)
	local nID = tostring(nID);
	local tbHeros = self:GetHeros();
	return tbHeros[nID];
end


function KGC_HANDBOOK_LAYER_TYPE:TouchEventHero(widget)
	local hero = widget._hero_obj;
	if hero then
		KGC_HERO_INFO_SUBLAYER_TYPE:create(self, {hero})
	end
end

--@function: 召唤选择或者随机英雄
function KGC_HANDBOOK_LAYER_TYPE:TouchEventSelectHero(widget)
	
	local hero = widget._hero_obj;
	local nID = 0;
	if hero then
		nID = hero:GetID();
	end
	
	print("召唤英雄 ... ", nID);
	KGC_HANDBOOK_LOGIC_TYPE:getInstance():ReqRollHero(nID);
end

--@function: 左右切换英雄
function KGC_HANDBOOK_LAYER_TYPE:ChangeHero(nChange)
	print("左右切换英雄", nChange)
	if self.bIsRunning then
		return;
	end
	self.bIsRunning = true;
	
	local fnCall = function(sender, tbArg)
		self.bIsRunning = false;
	end
	
	for _, pnlHero in pairs(self.m_tbCallHeroPanels) do
		local order = pnlHero._order;
		order = (order+nChange)%4;
		pnlHero._order = order;
		
		-- 修改层级关系		
		if order == 0 then
			pnlHero:setLocalZOrder(2);
		elseif order == 1 or order == 3 then
			if order == 3 and nChange == 1 then		
						
			else
				pnlHero:setLocalZOrder(1);
			end
		elseif order == 2 then
			pnlHero:setLocalZOrder(0);
		end		
		
		-- 遮罩
		local pnlCover = pnlHero:getChildByName("pnl_cover");
		if order == 0 then
			pnlCover:setVisible(false);
		else
			pnlCover:setVisible(true);
		end
		
		local x, y, nScale = unpack(self.m_tbPanelsOriginal[order]);
		
		local moveTo = cc.MoveTo:create(0.5, cc.p(x, y));
		local scaleTo = cc.ScaleTo:create(0.5, nScale);
		local spawn = cc.Spawn:create(moveTo, scaleTo);
		local action = cc.Sequence:create(spawn, cc.CallFunc:create(fnCall, {pnlHero}));
		pnlHero:runAction(action);
	end
end

--@function: 召唤结果
--@nID: 英雄ID
function KGC_HANDBOOK_LAYER_TYPE:SummonResult(nID, tbHeros, nTimes)
	print("[log]召唤后更新：", nID, #(tbHeros or {}), nTimes)
	self:UpdateData(tbHeros, nTimes);
	
	-- 打开召唤结果界面
	local layer = KGC_HERO_SUMMON_RESULTL_SUBLAYER:create(self, {nID});
end

function KGC_HANDBOOK_LAYER_TYPE:OnExit()

end


--------------------------------
