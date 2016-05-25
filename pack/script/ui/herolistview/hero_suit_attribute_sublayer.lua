----------------------------------------------------------
-- file:	hero_suit_attribute_sublayer.lua
-- Author:	page
-- Time:	2015/10/12 14:41
-- Desc:	英雄套装属性洗练面板
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/npc/herofactory")
require("script/core/configmanager/configmanager");

local l_tbEffectDecoration = mconfig.loadConfig("script/cfg/client/decorationeffect")
local l_tbSublayerType = def_GetHeroSublayerType();

local TB_STRUCT_SUIT_ATTRIBUTE_SUBLAYER = {
	MAX_SUIT_ATTRIBUTE = 5,
	-----------------------------------------
	m_pLayout = nil,
	
	m_nHeroID = 0,				-- 英雄ID
	
	m_tbWgtLock = {				-- 五个锁的控件
		-- [1] = widget,
	},
}

KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE = class("KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE",  KGC_UI_BASE_SUB_LAYER, TB_STRUCT_SUIT_ATTRIBUTE_SUBLAYER)

function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:OnExit()
    
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {}
	local hero = tbArg[1]
	if not hero then
		return;
	end
	
	-- 初始化结构
	if not self.m_tbWgtLock then
		self.m_tbWgtLock = {};
	end
	-- 初始化一个Factory
	self.m_Factory = KGC_HERO_FACTORY_TYPE:getInstance();
	
	-- self.m_heroObj = hero;
	self.m_nHeroID = hero:GetID();
	self:LoadScheme();
	
	-- 更新数据
	self:UpdateAttribute(hero);
	self:LoadAllAttributes(self.m_nHeroID);
end

function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_SUIT_ATTRIBUTE_PATH)
	self:addChild(self.m_pLayout)
	
	local pnlMain = self.m_pLayout:getChildByName("pnl_main");
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	local btnClose = pnlMain:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	-- 属性大全和规则
	local pnlAllAttrs = self.m_pLayout:getChildByName("pnl_all_attribute");
	local pnlRules = self.m_pLayout:getChildByName("pnl_rules");
	pnlAllAttrs:setVisible(false);
	pnlRules:setVisible(false);
	local btnAllAttrs = pnlMain:getChildByName("btn_allattribute");
	local btnRules = pnlMain:getChildByName("btn_rule");
	
	local fnTouch = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnAllAttrs then
				pnlAllAttrs:setVisible(true);
			elseif sender == btnRules then
				pnlRules:setVisible(true);
			end
		end
	end
	btnAllAttrs:addTouchEventListener(fnTouch);
	btnRules:addTouchEventListener(fnTouch);
	
	local btnClose1 = pnlAllAttrs:getChildByName("btn_close");
	local btnClose2 = pnlRules:getChildByName("btn_close");
	local btnOk1 = pnlAllAttrs:getChildByName("btn_confirm");
	local btnOk2 = pnlRules:getChildByName("btn_confirm");
	local fnCloseSubLayer = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnClose1 or sender == btnOk1 then
				pnlAllAttrs:setVisible(false);
			elseif sender == btnClose2 or sender == btnOk2 then
				pnlRules:setVisible(false);
			end
		end
	end
	btnClose1:addTouchEventListener(fnCloseSubLayer);
	btnClose2:addTouchEventListener(fnCloseSubLayer);
	btnOk1:addTouchEventListener(fnCloseSubLayer);
	btnOk2:addTouchEventListener(fnCloseSubLayer);
	
	-- 洗炼
	local btnRefresh = pnlMain:getChildByName("btn_refresh");
	local fnRefresh = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:RefreshAttribute();
		end
	end
	btnRefresh:addTouchEventListener(fnRefresh);
	
	local imgAttributeBg = pnlMain:getChildByName("img_superpowerbg");
	
	local function fnSelectedStateEvent(sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self:SetLock(sender, true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
			self:SetLock(sender, false)
        end
    end
	-- 洗练锁属性
	for i = 1, self.MAX_SUIT_ATTRIBUTE do
		local szName = "cb_lock_" .. i;
		local checkbox = imgAttributeBg:getChildByName(szName);
		checkbox._attr_index = i;
		checkbox:addEventListener(fnSelectedStateEvent);
		
		self.m_tbWgtLock[i] = checkbox;
	end
end

--@function: 更新英雄套装属性
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:UpdateAttribute(hero)
	if not hero then
		return;
	end
	
	local nEquipSuit = hero:GetEquipSuit();
	-- local nStar = self.m_Factory:GetEquipStars(nEquipSuit);

	local pnlMain = self.m_pLayout:getChildByName("pnl_main");
	local imgBg = pnlMain:getChildByName("img_superpowerbg");
	
	local tbSuitAttrs = hero:GetSuitAttributeDesc();
	for i = 1, self.MAX_SUIT_ATTRIBUTE do
		local szName = "lbl_wash_0" .. i;
		local lblAttribute = imgBg:getChildByName(szName);
		lblAttribute:setAnchorPoint(cc.p(0, 0.5));
		local szAttr = tbSuitAttrs[i]
		-- if nStar < i then
			-- local szStar = string.format("(全身%d星开启)", i);
			-- szAttr = szAttr .. szStar;
		-- end
		lblAttribute:setString(szAttr);
	end
end

--@function: 加载属性大全
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:LoadAllAttributes(nHeroID)
	if not nHeroID then
		return;
	end
	
	local pnlAllAttrs = self.m_pLayout:getChildByName("pnl_all_attribute");
	local lvAttributes = pnlAllAttrs:getChildByName("list_allattribute");
	
	lvAttributes:removeAllItems();
	local lblAttributeTemplate = pnlAllAttrs:getChildByName("lbl_attribute");
	lblAttributeTemplate:setVisible(false);
	
	local hero = me:GetHeroByID(nHeroID);
	if hero then
		local tbDesc = hero:GetAllSuitAttributeDesc() or {};
		local nCount = 1;
		for _, szDesc in pairs(tbDesc) do
			local szString = nCount .. "、" .. szDesc;
			local item = lblAttributeTemplate:clone();
			item:setString(szString);
			item:setVisible(true)
			lvAttributes:pushBackCustomItem(item);
			nCount = nCount + 1;
		end
	end
end

--@function: 洗练
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:RefreshAttribute()
	local bRet, nErrorID = self:IsCanRefresh();
	if not bRet then
		TipsViewLogic:getInstance():addMessageTips(nErrorID);
		return;
	end
	
	local tbLock = {};
	-- 获取哪些锁上了
	for i, widget in pairs(self.m_tbWgtLock) do
		local nLock = widget:getSelectedState() and 1 or 0;
		tbLock[i] = nLock;
	end
	
	-- 向服务器请求
	KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqRefreshSuitAttribute(self.m_nHeroID, tbLock);
end

--@function: 设置某条属性是否锁上
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:SetLock(widget, bLock)
	if not widget then
		return;
	end
	
	-- print(111, widget:getSelectedState())
end

--@function: 洗练
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:IsCanRefresh()
	local nCount = 0;
	for i, widget in pairs(self.m_tbWgtLock) do
		local nLock = widget:getSelectedState() and 1 or 0;
		nCount = nCount + nLock;
	end
	if nCount >= self.MAX_SUIT_ATTRIBUTE then
		return false, 12207;
	end
	
	return true;
end

--@function: 主界面更新通知二级界面更新
function KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	if nID == l_tbSublayerType.LT_REFRESH then
		local hero = me:GetHeroByID(self.m_nHeroID);
		self:UpdateAttribute(hero);
	end
end