----------------------------------------------------------
----------------------------------------------------------
-- file:	heroshoplayer.lua
-- Author:	page
-- Time:	2015/09/16 16:44
-- Desc:	英雄商店面板
----------------------------------------------------------
require "script/ui/resource"
require("script/ui/publicview/heroinfosublayer")
----------------------------------------------------------

--data struct
local TB_STRUCT_HERO_SHOP_LAYER = {
	--config

	MAX_REFRESH_TIMES = 5,					-- 最大刷新次数
	MAX_GOODS = 5,							-- 商店碎片个数
	REFRESH_TIME = 1800,					-- 刷新时间, 单位(s)
	------------------------------------------------------
	--界面
	m_Layout = nil,							--保存界面结构root
	m_pnlMain = nil,						-- 有效UI部分
	m_svGoods = nil,						-- 商店的货物存放(碎片放在的scrollview)
	m_pnlGoodsTemplate = nil,				-- 每一个货物(碎片)的控件模版
	m_tbPnlGoods = {},					-- 道具列表
	
	-- 读UI文件初始化配置数据
	m_nSVMaxHeight = 0,						-- 商店的scrollview高度
	m_nHeight = 0,							-- 一个货物(碎片)的控件高度
	m_nTopSpace = 0,						-- 最上面一个货物(碎片)距离顶端的间隔
	m_nHeightSpace = 0,						-- 两个货物控件之间的距离
	
	m_nSecond = 0,							-- 倒计时的时间
	m_schedulerTimer = nil,					-- 定时器
	
	m_nTimes = 0,							-- 次数
}

KGC_HERO_SHOP_LAYER_TYPE = class("KGC_HERO_SHOP_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_HERO_SHOP_LAYER)
--------------------------------
--ui function
--------------------------------
function KGC_HERO_SHOP_LAYER_TYPE:ctor()
	
end

function KGC_HERO_SHOP_LAYER_TYPE:Init(tbIDs, nTimes, nSecond)
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_SHOP_PATH)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	
	self.m_nTimes = nTimes;
	self.m_nSecond = nSecond;
	
	self:LoadScheme()
	self:CreateGoods(tbIDs);
end

--解析界面文件
function KGC_HERO_SHOP_LAYER_TYPE:LoadScheme()
	local btnClose = self.m_Layout:getChildByName("btn_close")
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_HERO_SHOP_LOGIC_TYPE:getInstance():closeLayer();
		end
	end
	btnClose:addTouchEventListener(fnClose)
	
	self.m_pnlMain = self.m_Layout:getChildByName("img_bg")
	
	-- 商店摆放货品的数量
	local imgMaterialBg = self.m_pnlMain:getChildByName("img_materialbg");
	self.m_svGoods = imgMaterialBg:getChildByName("sv_material");
	local sizeSV = self.m_svGoods:getInnerContainerSize();
	self.m_nSVMaxHeight = sizeSV.height;
	self.m_pnlGoodsTemplate = self.m_svGoods:getChildByName("img_heropiece_1")
	self.m_pnlGoodsTemplate:setVisible(false);
	local pnlHeroTemplateV = self.m_svGoods:getChildByName("img_heropiece_2")	-- 垂直间隔计算
	pnlHeroTemplateV:setVisible(false);
	local size = self.m_pnlGoodsTemplate:getContentSize();
	self.m_nHeight = size.height;
	local x, y = self.m_pnlGoodsTemplate:getPosition();
	local xV, yV = pnlHeroTemplateV:getPosition();
	
	self.m_nTopSpace = sizeSV.height - y - size.height/2;
	self.m_nHeightSpace = y - yV - size.height;
	
	-- 刷新按钮
	local btnRefresh = self.m_pnlMain:getChildByName("btn_refresh");
	local fnRefresh = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:RefreshGoods();
		end
	end
	btnRefresh:addTouchEventListener(fnRefresh);
	
	-- 刷新次数
	self:UpdateRefreshTimes();

	-- 定时器
	self.m_lblTime = self.m_pnlMain:getChildByName("lbl_timelimit");
	local fnUpdate = function(dt)
		self:UpdateTime(dt);
	end
	local scheduler = cc.Director:getInstance():getScheduler() 
	self.m_schedulerTimer = scheduler:scheduleScriptFunc(fnUpdate, 1, false);
end

function KGC_HERO_SHOP_LAYER_TYPE:UpdateData(tbIDs, nTimes, nSecond)
	self.m_nSecond = nSecond or 0;
	self.m_nTimes = nTimes or 0;
	self:UpdateRefreshTimes();
	
	self:UpdateAllGoods(tbIDs);
end

--@function: 增加商店英雄碎片节点
function KGC_HERO_SHOP_LAYER_TYPE:CreateGoods(tbGoods)
	if not tbGoods then
		return;
	end
	local nLevel = me:GetLevel();
	local tbLevelConfig = {0, 10, 20, 30, 40};
	
	local tbPanelGoods = self:GetPanelGoods();
	local fnUpdateGoods = function(i, nID)
		-- 位置调整
		local nRow = i-1;
	
		local pnlItem = self.m_pnlGoodsTemplate:clone();
		pnlItem:setVisible(true);
		-- 锚点在(0.5, 0.5)
		local y = self.m_nSVMaxHeight - nRow * (self.m_nHeight + self.m_nHeightSpace) - self.m_nTopSpace - self.m_nHeight/2;
		pnlItem:setPositionY(y);
		self.m_svGoods:addChild(pnlItem);

		local pnlLock = pnlItem:getChildByName("pnl_lock");
		local lblLock = pnlLock:getChildByName("lbl_lock");
		if nLevel >= tbLevelConfig[i] then
			pnlLock:setVisible(false);
		else
			pnlLock:setVisible(true);
			local szString = string.format("等级 %d 开放", tbLevelConfig[i]);
			lblLock:setString(szString);
		end
		-- 数据绑定
		pnlItem._item_id = nID;			-- 道具ID
		
		-- 更新数据
		self:UpdateGoods(pnlItem);
		
		local fnOK = function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				self:BuyGoods(sender);
			end
		end
		local btnOK = pnlItem:getChildByName("btn_buy");
		btnOK._item_id = nID;
		btnOK._shop_index = i;		-- 商店索引
		btnOK:addTouchEventListener(fnOK);
		
		tbPanelGoods[i] = pnlItem;
	end
	
	local nCount = 0;
	for i = 1, self.MAX_GOODS do
		nCount = nCount + 1;
		fnUpdateGoods(nCount, tbGoods[i]);
	end
end

--@function: 增加商店英雄碎片节点
function KGC_HERO_SHOP_LAYER_TYPE:UpdateAllGoods(tbGoods)
	print("UpdateAllGoods ... ");
	local tbPanelGoods = self:GetPanelGoods();
	for i = 1, self.MAX_GOODS do
		local pnlGoods = tbPanelGoods[i];
		local nItemID = tbGoods[i];
		if pnlGoods and nItemID then
			pnlGoods._item_id = nItemID;
			local btnOK = pnlGoods:getChildByName("btn_buy");
			btnOK._item_id = nItemID;
			self:UpdateGoods(pnlGoods);
		end
	end
end

function KGC_HERO_SHOP_LAYER_TYPE:UpdateGoods(pnlItem)
	if not pnlItem then
		return;
	end
	
	local pnlHeroPiece = pnlItem:getChildByName("pnl_hero");
	local imgHeroBg = pnlHeroPiece:getChildByName("img_herobg");
	local imgHero = imgHeroBg:getChildByName("img_hero");
	
	local nItemID = pnlItem._item_id;
	print("UpdateGoods ... ", nItemID)
	local pnlCover = pnlItem:getChildByName("pnl_cover");
	if nItemID and nItemID > 0 then				-- 未购买
		pnlCover:setVisible(false);
		local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(nItemID)
		imgHeroBg:loadTexture(item:GetQualityIcon());
		imgHero:loadTexture(item:GetIcon());
		imgHero:setVisible(true);
	elseif nItemID and nItemID < 0 then			-- 已经购买
		pnlCover:setVisible(true);
		local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(-1 * nItemID)
		imgHeroBg:loadTexture(item:GetQualityIcon());
		imgHero:loadTexture(item:GetIcon());
		imgHero:setVisible(true);
	else
		imgHero:setVisible(false);
	end
	
	self:UpdateMaterials(pnlItem);
end

function KGC_HERO_SHOP_LAYER_TYPE:UpdateMaterials(pnlItem)
	if not pnlItem then
		return;
	end
	
	local nItemID = pnlItem._item_id;
	-- 取绝对值
	nItemID = math.abs(nItemID);
	local tbMaterials = KGC_ITEM_MANAGER_TYPE:getInstance():GetComposeMaterials(nItemID) or {};
	for i=1, 4 do
		local tbData = tbMaterials[i]
		local szName = "img_materiallevel0" .. i;
		local imgMaterial = pnlItem:getChildByName(szName);
		if tbData then
			imgMaterial:setVisible(true);
			local bmpNum = imgMaterial:getChildByName("btm_itemnumber");
			local imgIcon = imgMaterial:getChildByName("img_itemicon");
			
			local nID, nNum = unpack(tbData);
			local item = me:GetBag():GetItemByID(nID);
			
			local nHas = 0;
			if item then
				nHas = item:GetNum();
				
				imgIcon:loadTexture(item:GetIcon());
			end
			
			local szString = nHas .. "/" .. nNum;
			bmpNum:setString(szString);
			-- 红色标识
			if nHas < nNum then
				bmpNum:setColor(cc.c3b(255, 0, 0));
			else
				bmpNum:setColor(cc.c3b(255, 255, 255));
			end
		else
			imgMaterial:setVisible(false);
		end
	end
end

function KGC_HERO_SHOP_LAYER_TYPE:BuyGoods(widget)
	if not widget then
		return;
	end
	print("我要购买了 ... ", widget._item_id);
	local nItemID = widget._item_id;
	local nShop = widget._shop_index;
	if self:IsCanBuy(nItemID) then
		KGC_HERO_SHOP_LOGIC_TYPE:getInstance():ReqBuy(nShop, nItemID);
	else
		TipsViewLogic:getInstance():addMessageTips(12206);
	end
end

function KGC_HERO_SHOP_LAYER_TYPE:IsCanBuy(nID)
	if not nID then
		cclog("[Error]是否可以购买@IsCanBuy(nID:%s)", tostring(nID));
		return false;
	end

	local bRet = true;
	local tbMaterials = KGC_ITEM_MANAGER_TYPE:getInstance():GetComposeMaterials(nID) or {};
	for i=1, 4 do
		local tbData = tbMaterials[i]
		if tbData then
			local nID, nNum = unpack(tbData);
			local item = me:GetBag():GetItemByID(nID);
			
			local nHas = 0;
			if item then
				nHas = item:GetNum();
			end
			
			cclog("IsCanBuy: nID(%d), nHas(%d)--nNum(%d)", nID, nHas, nNum);
			
			if nHas < nNum then
				bRet = false;
				break;
			end
		end
	end
	return bRet;
end

function KGC_HERO_SHOP_LAYER_TYPE:UpdateRefreshTimes()
	local lblTimes = self.m_pnlMain:getChildByName("lbl_times");
	local szString = "剩余次数： " .. self.m_nTimes;
	lblTimes:setString(szString);
	
	-- 客户端自己先修改时间
	if self.m_nTimes < self.MAX_REFRESH_TIMES and self.m_nSecond == 0 then
		self.m_nSecond = self.REFRESH_TIME;
	end
end

--@function: 刷新倒计时
function KGC_HERO_SHOP_LAYER_TYPE:UpdateTime(dt)
	self.m_nSecond = self.m_nSecond - 1;
	if self.m_nSecond >= 0 then
		local szFormat = tf_FormatSecond(self.m_nSecond);
		local szTime = "刷新时间： " .. szFormat;
		self.m_lblTime:setString(szTime);
	end
	
	if self.m_nSecond == 0 then	
		if self.m_nTimes < self.MAX_REFRESH_TIMES then
			self.m_nTimes = self.m_nTimes + 1;
		end
		
		self:UpdateRefreshTimes();
	end
end

--@function: 刷新
function KGC_HERO_SHOP_LAYER_TYPE:RefreshGoods()
	print("我要刷新 ... ")
	if self.m_nTimes > 0 then
		KGC_HERO_SHOP_LOGIC_TYPE:getInstance():ReqHeroShop(1);
	else
		TipsViewLogic:getInstance():addMessageTips(12208);
	end
end

--@function: 购买之后更新商店指定货品
function KGC_HERO_SHOP_LAYER_TYPE:UpdateGoodsByIndex(nIndex)
	local tbPanelGoods = self:GetPanelGoods();
	local pnlGoods = tbPanelGoods[nIndex]
	if pnlGoods then
		pnlGoods._item_id = -1 * pnlGoods._item_id;
		self:UpdateGoods(pnlGoods);
	end
	
	self:UpdateAllMaterials();
end

--@function: 获取货品的的所有panel
function KGC_HERO_SHOP_LAYER_TYPE:GetPanelGoods()
	if not self.m_tbPnlGoods then
		self.m_tbPnlGoods = {};
	end
	return self.m_tbPnlGoods;
end

--@function: 更新所有材料, 一个货物购买了之后, 其他货物材料都需要更新(相同材料)
function KGC_HERO_SHOP_LAYER_TYPE:UpdateAllMaterials()
	local tbPanelGoods = self:GetPanelGoods();
	for i = 1, self.MAX_GOODS do
		local pnlGoods = tbPanelGoods[i];
		self:UpdateMaterials(pnlGoods);
	end
end

function KGC_HERO_SHOP_LAYER_TYPE:OnExit()
	local scheduler = cc.Director:getInstance():getScheduler()
	if self.m_schedulerTimer then
		scheduler:unscheduleScriptEntry(self.m_schedulerTimer)
		self.m_schedulerTimer = nil;
	end
end


--------------------------------
