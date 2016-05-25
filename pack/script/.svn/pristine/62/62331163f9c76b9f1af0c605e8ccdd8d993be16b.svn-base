----------------------------------------------------------
-- file:	hero_select_sublayer.lua
-- Author:	page
-- Time:	2015/09/23 19:47 
-- Desc:	英雄选择升级二级界面类
-- Modify	(1)Page@2015/09/14 17:42 --> 多个地方调用这个界面,故移动到此
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/ui/herolistview/heroskillsublayer")
require("script/ui/herolistview/hero_reinforce_sublayer")

local TB_STRUCT_HERO_SELECT_SUBLAYER={

	m_pLayout = nil,				-- 主界面
	m_svHeros = nil,				-- 英雄列表scrollview
	m_pnlHeroTemplate = nil,		-- 一个英雄panel的模版
	
	m_wgtSelect = nil,				-- 选中的英雄
	
	-- 相关配置
	m_nSVMaxHeight = 0,				-- scrollview的高度
	m_nWidth = 0,					-- 一个英雄模版的宽度
	m_nHeight = 0,					-- 一个英雄模版的高度
	m_nTopSpace = 0,				-- 最左边空隙
	m_nLeftSpace = 0,				-- 最顶端空隙
	m_nWidthSpace = 0,				-- 两个控件的水平间隔
	m_nHeightSpace = 0,				-- 两个控件的垂直间隔
	
	m_schedule = nil,				-- 定时器
	
}

KGC_HERO_SELECT_SUBLAYER_TYPE = class("KGC_HERO_SELECT_SUBLAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_HERO_SELECT_SUBLAYER)

function KGC_HERO_SELECT_SUBLAYER_TYPE:ctor()

end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_HERO_SELECT_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {}
	local fnCallback = tbArg[1]
	if not fnCallback then
		cclog("[Error]使用经验道具没有注册回调函数");
		return;
	end
	self.m_fnCallBack = fnCallback;
	self:LoadScheme();
	
	self:LoadAllHeros();
end

function KGC_HERO_SELECT_SUBLAYER_TYPE:OnExit()
	self:CloseScheduler();
end

--@function: 加载界面
function KGC_HERO_SELECT_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_SELECT_PATH)
	self:addChild(self.m_pLayout)

	--关闭按钮
    local function fnClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:closeLayer()
        end
    end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	-- 英雄列表配置
	self.m_svHeros = self.m_pLayout:getChildByName("sv_heros")
	local sizeSV = self.m_svHeros:getInnerContainerSize();
	self.m_nSVMaxHeight = sizeSV.height;
	self.m_pnlHeroTemplate = self.m_svHeros:getChildByName("pnl_hero_1")
	self.m_pnlHeroTemplate:setVisible(false);
	local pnlHeroTemplateH = self.m_svHeros:getChildByName("pnl_hero_2")		-- 水平间隔计算
	local pnlHeroTemplateV = self.m_svHeros:getChildByName("pnl_hero_3")		-- 垂直间隔计算
	pnlHeroTemplateH:setVisible(false);
	pnlHeroTemplateV:setVisible(false);
	local size = self.m_pnlHeroTemplate:getContentSize();
	self.m_nWidth = size.width;
	self.m_nHeight = size.height;
	local x, y = self.m_pnlHeroTemplate:getPosition();
	local xH, yH = pnlHeroTemplateH:getPosition();
	local xV, yV = pnlHeroTemplateV:getPosition();
	self.m_nTopSpace = sizeSV.height - y - size.height;
	self.m_nLeftSpace = x;
	self.m_nWidthSpace = xH - x - size.width;
	self.m_nHeightSpace = y - yV - size.height;
	
	cclog("[log]英雄列表：最大高度：%d", self.m_nSVMaxHeight);
	cclog("[log]英雄列表：参考英雄panel的宽高(%d, %d), 坐标(%d, %d)", size.width, size.height, x, y);
	cclog("[log]英雄列表：最顶端空隙：%d, 最左边空隙：%d", self.m_nTopSpace, self.m_nLeftSpace);
	cclog("[log]英雄列表：水平参考坐标(%d, %d), 计算水平间隔：%d", xH, yH, self.m_nWidthSpace);
	cclog("[log]英雄列表：垂直参考坐标(%d, %d), 垂直水平间隔：%d", xV, yV, self.m_nHeightSpace);
end

--@function: 加载所有拥有的英雄
function KGC_HERO_SELECT_SUBLAYER_TYPE:LoadAllHeros()
	-- 每一行最多放四个
	local MAX_COL = 4;
	
	local fnTouchHero = function(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:TouchEventHeroBegan(sender);
		elseif eventType == ccui.TouchEventType.moved then
			self:TouchEventHeroMoved(sender);
		elseif eventType == ccui.TouchEventType.ended then
			self:TouchEventHeroEnded(sender);
		end
	end
	
	-- local tbOnlineHeroPanels = self:GetOnlineHeroPanel();
	local fnUpdateHero = function(i, hero)
		-- 位置调整
		local nRow = math.floor((i-1)/MAX_COL) + 1;
		local nCol = (i-1) % MAX_COL + 1;
		local pnlHero = self.m_pnlHeroTemplate:clone();
		pnlHero:setVisible(true);
		local x = (nCol-1) * (self.m_nWidth + self.m_nWidthSpace) + self.m_nLeftSpace;
		local y = self.m_nSVMaxHeight - nRow* (self.m_nHeight + self.m_nHeightSpace) - self.m_nTopSpace;
		pnlHero:setPosition(cc.p(x, y));
		self.m_svHeros:addChild(pnlHero);
		pnlHero:addTouchEventListener(fnTouchHero);
		
		-- 设置战斗力不可见
		local imgHeroBg = pnlHero:getChildByName("img_herobg");
		local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
		imgFightPoint:setVisible(false);
		
		-- 数据绑定
		local nID = hero:GetID();
		pnlHero._hero_id = nID;
		if hero:IsOn() then
			-- pnlHero:setOpacity(125);
			-- pnlHero:setTouchEnabled(false);
			-- tbOnlineHeroPanels[nID] = pnlHero;
		end
		
		-- 更新数据
		self:UpdateHero(pnlHero);
	end
	
	local nCount = 0;
	-- 先显示上阵的
	local tbHeros = me:GetHeros();
	for i = 1, #tbHeros do
		nCount = nCount + 1;
		local hero = tbHeros[i];
		fnUpdateHero(nCount, hero);
	end
	
	-- 再显示未上阵的
	local tbAllHeros = me:GetAllHeros();
	for i = 1, #tbAllHeros do
		local hero = tbAllHeros[i];
		if not hero:IsOn() then
			nCount = nCount + 1;
			fnUpdateHero(nCount, hero);
		end
	end
end

--@function: 更新一个英雄面板
function KGC_HERO_SELECT_SUBLAYER_TYPE:UpdateHero(widget)
	if not widget then
		return;
	end
	local hero = me:GetHeroByID(widget._hero_id);
	if not hero then
		return;
	end
	
	local imgHeroBg = widget:getChildByName("img_herobg");				-- 英雄背景
	local lblLevel = imgHeroBg:getChildByName("lbl_level")				-- 英雄等级
	local lblName = widget:getChildByName("lbl_heroname");				-- 英雄名字
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local imgExpBg = widget:getChildByName("img_expbg");
	local barExp = imgExpBg:getChildByName("bar_exp");					-- 经验条

	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local nExp = hero:GetExp();
	local nNeedExp = hero:GetLevelUpExp();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	imgHeroBg:loadTexture(szHeroBg);
	lblLevel:setString("LV." .. hero:GetLevel());
	if lblName then
		lblName:setString(hero:GetName());
	end
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	imgHero:loadTexture(szIconS);
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	
	local nPercent = (nExp / nNeedExp) * 100
	if nPercent > 100 then
		nPercent = 100;
	end						
	barExp:setPercent(nPercent);					
end

--@function 点击英雄触发事件
function KGC_HERO_SELECT_SUBLAYER_TYPE:TouchEventHeroBegan(widget)
	if not widget then
		return;
	end
	print("began ... ")
	self.m_wgtSelect = widget;
	
	self:OpenScheduler();
	
	self.m_nStartTime = os.time();
	self.m_nExpAdd = 100;
	
	local nID = widget._hero_id;
	self:ReqAddExp(nID);
end

--@function 点击英雄触发事件
function KGC_HERO_SELECT_SUBLAYER_TYPE:TouchEventHeroMoved(widget)
	if not widget then
		return;
	end
	local nID = widget._hero_id;
	
	print("moving ... ")
	
end

--@function 点击英雄触发事件
function KGC_HERO_SELECT_SUBLAYER_TYPE:TouchEventHeroEnded(widget)
	if not widget then
		return;
	end
	print("ended ... ");
	self:CloseScheduler();
end

--@function: 打开定时器
function KGC_HERO_SELECT_SUBLAYER_TYPE:OpenScheduler()
	local fnCallback = function(sender)
		print("update ... ", os.time())
		local nTimePass = os.time() - self.m_nStartTime or 0;
		if nTimePass > 1 then
			self.m_nStartTime = os.time();
			self:ReqAddExp(nID);
		end
	end
	local scheduler = cc.Director:getInstance():getScheduler()
	self.m_schedule = scheduler:scheduleScriptFunc(fnCallback, 1, false)
end

--@function: 关闭定时器
function KGC_HERO_SELECT_SUBLAYER_TYPE:CloseScheduler()
	local scheduler = cc.Director:getInstance():getScheduler()
	if self.m_schedule then
		scheduler:unscheduleScriptEntry(self.m_schedule)
	end
end

--@function: 主界面更新通知二级界面更新
function KGC_HERO_SELECT_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	self:UpdateHero(self.m_wgtSelect);
end

--@function 点击英雄触发事件
function KGC_HERO_SELECT_SUBLAYER_TYPE:ReqAddExp(nID)
	local nID = nID or 0;
	local nExp = self.m_nExpAdd or 0;
	if self.m_fnCallBack then
		self.m_fnCallBack(nID);
	end
end