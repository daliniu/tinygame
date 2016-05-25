----------------------------------------------------------
-- file:	herolistlayer.lua
-- Author:	page
-- Time:	2015/09/07 10:18 
-- Desc:	英雄列表界面类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_layer")
require("script/ui/publicview/heroinfosublayer")
require("script/ui/heroinfoview/herolineupsublayer")
require("script/ui/heroinfoview/hero_suit_attribute_sublayer")
require("script/ui/heroinfoview/equipview/equiplogic")
require("script/core/npc/herofactory")
require("script/ui/mainbuttonview/mainbuttonview")

local l_tbEquipPos = def_GetPlayerEquipPos();

local TB_STRUCT_HERO_LIST_LAYER={
	m_pLayout = nil,				-- 主界面
	
	m_pnlMain = nil,				-- 主要面板
	m_pnlBaseInfo = nil,			-- 基础信息面板
	
	m_nCurHero = 1,					-- 当前英雄索引
	m_tbBtnEquips = {				-- 记录对应位置是否已经装备
		--[widget] = index;
	},
	m_tbEquipsPos2Widget = {		-- 保存所有的控件, 用作刷新
		-- [nPos] = widget,
	},
	m_tbHeroPanels = {},			-- 保存上阵英雄的panel控件
	m_tbHeroPanelsPos = {},			-- 记录英雄panel的初始位置, 后面移动需要用
	m_bIsMoving = false,			-- 防止动作被中断

	m_heroInfoLayer =nil,
	m_lineUpLayer =nil,		--布阵界面
	m_quInfoLayer =nil,		--装备信息界面
}

KGC_HERO_LIST_LAYER_TYPE = class("KGC_HERO_LIST_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_HERO_LIST_LAYER)

function KGC_HERO_LIST_LAYER_TYPE:ctor()
    
end

function KGC_HERO_LIST_LAYER_TYPE:Init()
	-- 初始化一个Factory
	self.m_Factory = KGC_HERO_FACTORY_TYPE:getInstance();
	
	self:LoadScheme();
	self:LoadHeros();
	self:UpdateHeros();
end

function KGC_HERO_LIST_LAYER_TYPE:OnExit()

end


--@function: 加载界面
function KGC_HERO_LIST_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_LIST_PATH)
	self:addChild(self.m_pLayout)
	
	--关闭按钮
    local function fnClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            KGC_HERO_LIST_LOGIC_TYPE:getInstance():closeLayer()
        end
    end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main")
	self.m_pnlBaseInfo = self.m_pnlMain:getChildByName("img_basicinfobg")
	
	-- 英雄信息按钮
	local btnPlayerInfo = self.m_pnlBaseInfo:getChildByName("btn_playerinfo")
	local fnHeroInfo = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventHeroBaseInfo();
		end
	end
	btnPlayerInfo:addTouchEventListener(fnHeroInfo);
	
	-- 布阵按钮
	local btnLineup = self.m_pnlMain:getChildByName("btn_formation")
	local imgRedPoint = btnLineup:getChildByName("img_redpoint")
	imgRedPoint:setVisible(false);
	local fnLineup = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.m_lineUpLayer = KGC_HERO_LINEUP_SUBLAYER_TYPE:create(self);
		end
	end
	btnLineup:addTouchEventListener(fnLineup);
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_LINEUP)== false then 
		btnLineup:setTouchEnabled(false)
	end


	-----------------------------------------------------------------------
	-- 英雄(上阵英雄按照位置分别放在1-2-3的panel上)
	local tbPnlHeros = self:GetHeroPanels();
	local pnlHeros = self.m_pnlMain:getChildByName("pnl_herobg")
	for i = 1, 3 do 
		local szName = "pnl_character" .. i;
		local pnlHero = pnlHeros:getChildByName(szName)
		self.m_tbHeroPanels[i] = pnlHero;
		local x, y = pnlHero:getPosition();
		self.m_tbHeroPanelsPos[i] = {x, y};
		pnlHero:addTouchEventListener(fnHeroInfo);
	end
	
	local btnLeft = pnlHeros:getChildByName("btn_left")
	local btnRight = pnlHeros:getChildByName("btn_right")
	btnLeft:setLocalZOrder(5);
	btnRight:setLocalZOrder(5);
	local fnSelectHero = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			-- UI位置从左到右为213,所以向左,所有的都+1; 向右所有的都-1
			if sender == btnLeft then
				self:ChangeHero(1)
			elseif sender == btnRight then
				self:ChangeHero(-1)
			end
		end
	end
	btnLeft:addTouchEventListener(fnSelectHero)
	btnRight:addTouchEventListener(fnSelectHero)
	
	--test
	local onKeyPressed = function(keyCode, event)
		if keyCode == 138 then
			for _, panel in pairs(self.m_tbHeroPanels) do
				local n = panel:getBackGroundColorOpacity()
				if n > 0 then
					panel:setBackGroundColorOpacity(0)
				else
					panel:setBackGroundColorOpacity(50)
				end
			end
		end
	end
	local listener = cc.EventListenerKeyboard:create();
	listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	--test end
	-----------------------------------------------------------------------
	--装备
	local fnEquip = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:EquipTouchEvent(sender)
		end
	end
	local tbEquipWidgetNames = {
		[l_tbEquipPos.P_HEAD] = "img_headbg",								-- 头
		[l_tbEquipPos.P_CLOTH] = "img_armorbg",								-- 衣服
		[l_tbEquipPos.P_SHOES] = "img_shoesbg",								-- 鞋子
		[l_tbEquipPos.P_WEAPON] = "img_weaponbg",							-- 武器
		[l_tbEquipPos.P_NECKLACE] = "img_necklacebg",						-- 项链
		[l_tbEquipPos.P_RING] = "img_ringbg",								-- 戒指
	}
	for nType, szName in pairs(tbEquipWidgetNames) do
		local btnEquip = self.m_pnlMain:getChildByName(szName)
		btnEquip:setTouchEnabled(true);
		self.m_tbBtnEquips[btnEquip] = nil;
		-- 保存控件对应的部位
		btnEquip._equip_type = nType;										
		btnEquip:addTouchEventListener(fnEquip)
		-- 保存装备控件用作更新
		self.m_tbEquipsPos2Widget[nType] = btnEquip;
	end
	
	-- 套装属性洗练
	local imgSuitAttributeBg = self.m_pnlMain:getChildByName("img_superpowerbg");
	imgSuitAttributeBg:setTouchEnabled(true);
	local fnTouchAttributeRefresh = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tbHeros = me:GetHeros();
			local hero = tbHeros[self.m_nCurHero]
			local layer = KGC_UI_HERO_SUIT_ATTRIBUTE_SUBLAYER_TYPE:create(self, {hero});
		end
	end
	imgSuitAttributeBg:addTouchEventListener(fnTouchAttributeRefresh);
	if SystemOpen:getInstance():getSystemIsOpen(SystemOpen.SYS_PICKUP)== false then 
		imgSuitAttributeBg:setTouchEnabled(false)
	end	
	
	-- 一键装备
	local btnAutoEuip =  self.m_pnlMain:getChildByName("btn_allequip");
	btnAutoEuip:setVisible(true);
	local imgRemind = btnAutoEuip:getChildByName("img_redpoint");
	imgRemind:setVisible(false);
	local fnTouchAutoEquip = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:AutoEquip();
		end
	end
	btnAutoEuip:addTouchEventListener(fnTouchAutoEquip);

	--创建主按钮
    self:AddSubLayer(MainButtonLayer:create())
end

--@function: 关闭子窗口回调
function KGC_HERO_LIST_LAYER_TYPE:OnCloseSubLayer()

end

function KGC_HERO_LIST_LAYER_TYPE:EquipTouchEvent(widget)
	if not widget then
		return;
	end
	
	-- 只显示上阵英雄(英雄->哪一套装备; 部位->哪一件装备)
	local tbHeros = me:GetHeros();
	local hero = tbHeros[self.m_nCurHero]
	if not hero then
		return;
	end
	local nType = widget._equip_type				-- 当前装备的部位
	local nEquipIndex = self.m_tbBtnEquips[widget]
	local equip = me:GetBag():GetItemByIndex(nEquipIndex)
	local nSuit = hero:GetEquipSuit();				-- 哪一套装备
	cclog("[Log]当前穿的第%s套装备", tostring(nSuit))
	if equip then
		self.m_equipSelected = equip;
		print("[Log]nType, nTypeDetail: ", nType, equip:GetTypeDetail())
	end
	cclog("[Log]点击装备位置：部位(%s), 第几套(%s)", tostring(nType), tostring(nSuit))
	
	if equip then
		KGC_EQUIP_LOGIC_TYPE:getInstance():SetSelectedEquip(self.m_equipSelected)
		self.m_quInfoLayer = KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(2, self)
	else
		KGC_EQUIP_LOGIC_TYPE:getInstance():SetSelectedEquip(nil, nType, nSuit)
		KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(1, self)
	end
end

function KGC_HERO_LIST_LAYER_TYPE:TouchEventHeroBaseInfo()
	local tbHeros = me:GetHeros();
	local hero = tbHeros[self.m_nCurHero]
	if hero then
		self.m_heroInfoLayer=KGC_HERO_INFO_SUBLAYER_TYPE:create(self, {hero})
	else
		TipsViewLogic:getInstance():addMessageTips(12200);
	end
end

--@function: 加载英雄信息
function KGC_HERO_LIST_LAYER_TYPE:LoadHeros()
	--说明：这里直接从me对象拿出来的hero对象, 有区别战斗系统临时hero对象
	local tbHeros = me:GetHeros()
	
	local tbPnlHeros = self:GetHeroPanels();
	-- notify: ipairs
	for i = 1, 3 do
		-- 英雄索引和panel索引一一对应, 且不会变
		local hero = tbHeros[i]
		local pnlHero = tbPnlHeros[i]
		if hero then
			pnlHero:setVisible(true);
			self.m_armCurHero = self:LoadHero(hero, pnlHero)
		else
			pnlHero:setVisible(false);
		end
		
		-- 微布阵英雄icon显示
		local szName = "img_herobg" .. i;
		local imgHero = self.m_pnlMain:getChildByName(szName);
		local imgIcon = imgHero:getChildByName("img_herohead")
		local imgSelected = imgHero:getChildByName("img_select")
		imgSelected:setVisible(false);
		if hero then
			imgIcon:setVisible(true);
			local szIconS, szIconR, szIconP = hero:GetHeadIcon();
			if szIconS then
				imgIcon:loadTexture(szIconS)
			end
		else
			imgIcon:setVisible(false);
		end
	end
end

function KGC_HERO_LIST_LAYER_TYPE:LoadHero(hero, pnlHero)
	local nModID = hero:GetID()
	local nModelID = hero:GetModelID();
	local armature = KGC_MODEL_MANAGER_TYPE:getInstance():CreateNpc(nModelID);
	
	if pnlHero and armature then
		pnlHero:removeAllChildren(true);
		
		--按比例缩放
		local armSize = armature:getContentSize();
		local pnlHeroSize = pnlHero:getContentSize();
		local rect = armature:getBoundingBox();
		local nScale = pnlHeroSize.width/rect.width;
		local scaleY = pnlHeroSize.height/rect.height;
		if scaleY < nScale then
			nScale = scaleY;
		end
		print("KGC_HERO_LIST_LAYER_TYPE:LoadHero", nScale)
		-- armature:setScale(nScale)
		armature:setScale(1.5)
		pnlHero:addChild(armature, 1)
		armature:setPositionX(pnlHeroSize.width/2);
	end
	
	if hero:IsHero() then
		armature:setAnimation(0, 'standby', true)
	end
	
	return armature;
end

--@function: 更新英雄信息
function KGC_HERO_LIST_LAYER_TYPE:UpdateHeros()
	--说明：这里直接从me对象拿出来的hero对象, 有区别战斗系统临时hero对象
	local tbHeros = me:GetHeros()
	if self.m_nCurHero <= 0 or self.m_nCurHero > #tbHeros then
		self.m_nCurHero = 1;
	end
	local hero = tbHeros[self.m_nCurHero]
	if not hero then
		return;
	end
	
	local pnlBaseInfo = self.m_pnlBaseInfo;
	local bmpLevel = pnlBaseInfo:getChildByName("bmp_level")			-- 英雄等级
	local bmpAttack = pnlBaseInfo:getChildByName("bmp_attack")			-- 英雄攻击力
	local bmpHP = pnlBaseInfo:getChildByName("bmp_health")				-- 英雄生命值
	local bmpDefend = pnlBaseInfo:getChildByName("bmp_defend")			-- 英雄防御力
	local pnlOther = pnlBaseInfo:getChildByName("pnl_chaname")
	local lblName = pnlOther:getChildByName("lbl_name")					-- 英雄名字
	local svStars = pnlOther:getChildByName("sv_stars")					-- 英雄星级
	local imgNameBg = pnlOther:getChildByName("img_namebg")				-- 英雄名字底框
	local imgTypeBg = pnlOther:getChildByName("img_typebg")				-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars();
	local szType = hero:GetHeroTypeResource();
	print("UpdateHeros, nQuality, nStar", nQuality, nStar)
	local tbColor, szTypeBg, szHeroBg, szStarBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	if not tbColor then
		return;
	end
	bmpLevel:setString(hero:GetLevel())
	bmpAttack:setString(hero:GetAttack())
	bmpHP:setString(hero:GetHP())
	bmpDefend:setString(hero:GetDefend())
	lblName:setString(hero:GetName())
	lblName:setColor(cc.c3b(r, g, b))
	imgNameBg:setColor(cc.c3b(r, g, b))
	self:UpdateStars(svStars, nStar, szStarBg)
	imgTypeBg:loadTexture(szTypeBg)
	imgType:loadTexture(szType);
	
	-- 微布阵显示(注意：位置和站位的panel一致)
	for i = 1, 3 do
		local szName = "img_herobg" .. i;
		local imgHero = self.m_pnlMain:getChildByName(szName);
		local imgSelected = imgHero:getChildByName("img_select")
		if self.m_nCurHero == i then
			imgSelected:setVisible(true);
		else
			imgSelected:setVisible(false);
		end
	end

	--更新装备
	self.m_tbBtnEquips = {};
	cclog("[Log]更新装备，英雄(%s), 位置(%d)", hero:GetName(), hero:GetPos())
	local nSuit = hero:GetEquipSuit();
	self:UpdateEquips(nSuit)
	
	-- 更新套装属性
	self:UpdateSuitAttribute(hero);
	
	-- 更新提醒
	self:UpdateRemind();
end

--@function: 左右切换
--@nChange: 方向+1：左；-1：右
function KGC_HERO_LIST_LAYER_TYPE:ChangeHero(nChange)
	if self.m_bIsMoving then
		return;
	end

	self:UpdatePosition(nChange)
	self:UpdateHeros();
end

--@function: 英雄位置移动
function KGC_HERO_LIST_LAYER_TYPE:UpdatePosition(nChange)
	local tbPnlHeros = self:GetHeroPanels();
	local tbHeros = me:GetHeros();
	local nMax = #tbHeros
	if nMax <= 0 then
		cclog("[Error]英雄个数<=0, @UpdatePosition")
	end
	
	-- 防止动作被中断
	self.m_bIsMoving = true;
	local nOldPos = self.m_nCurHero;

	for i, panel in pairs(tbPnlHeros) do
		local nPos = panel._position or i;
		local nNewPos = self:GetNewPosition(nPos, nMax, nChange)
		panel._position = nNewPos;
		if nNewPos == 1 then
			-- 当前英雄为站在最前面的, 英雄所在的panel一直没有变
			self.m_nCurHero = i;
		end
		--[[
		local tbPos = self.m_tbHeroPanelsPos[nNewPos]
		local x, y = unpack(tbPos or {});
		-- panel:setPosition(cc.p(x, y));
		local moveTo = cc.MoveTo:create(1, cc.p(x, y))
		local fnCall = function()
			if nNewPos == 1 then
				panel:setOpacity(255);
				-- 重新标记可以移动
				self.m_bIsMoving = false;
			else
				panel:setOpacity(120);
			end
		end
		local action = cc.Sequence:create(moveTo, cc.CallFunc:create(fnCall));
		-- panel:runAction(action)
		]]
	end
	
	local fnCall = function()
		self.m_bIsMoving = false;
		for i, panel in pairs(tbPnlHeros) do
			local nPos = panel._position or i;
			if nPos == 1 then
				panel:setLocalZOrder(1);
			else
				panel:setLocalZOrder(0);
			end
		end
	end
	
	local szAction = "pnl" .. nOldPos;
	if nChange == 1 then
		szAction = szAction .. "left";
	else
		szAction = szAction .. "right";
	end
	print("UpdatePosition", szAction)
	ccs.ActionManagerEx:getInstance():playActionByName("ui_hero_list.json", szAction, cc.CallFunc:create(fnCall))
end

--@function: 获取新的位置, 公式: x % nMax + nChange
--@nPos: 当前的位置
--@nMax: 位置的总数(eg: 总数是3, 当前位置如果是1, +1就编程了1)
--@nChange：变化的数值
function KGC_HERO_LIST_LAYER_TYPE:GetNewPosition(nPos, nMax, nChange)
	if not nPos or not nMax or not nChange then
		return 0;
	end
	local nNew = (nPos + nChange) % nMax;
	if nNew == 0 then
		nNew = nMax;
	end
	return nNew;
end

--@function: 获取上阵英雄所在的panel
function KGC_HERO_LIST_LAYER_TYPE:GetHeroPanels()
	if not self.m_tbHeroPanels then
		self.m_tbHeroPanels = {};
	end
	return self.m_tbHeroPanels;
end

function KGC_HERO_LIST_LAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
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

--@function: 更新英雄装备
--@nSuit: 装备为第(1/2/3)套装备
function KGC_HERO_LIST_LAYER_TYPE:UpdateEquips(nSuit)
	cclog("[Log]UpdateEquips: 更新第%d套装备", nSuit)
	local tbEquips = me:GetEquips();
	local tbData = tbEquips[nSuit]
	local tbNullEquipResource = {
		[l_tbEquipPos.P_HEAD] = CUI_PATH_EQUIP_NULL_HEAD,
		[l_tbEquipPos.P_CLOTH] = CUI_PATH_EQUIP_NULL_CLOTH,
		[l_tbEquipPos.P_SHOES] = CUI_PATH_EQUIP_NULL_SHOES,
		[l_tbEquipPos.P_WEAPON] = CUI_PATH_EQUIP_NULL_WEAPON,
		[l_tbEquipPos.P_NECKLACE] = CUI_PATH_EQUIP_NULL_NECKLACE,
		[l_tbEquipPos.P_RING] = CUI_PATH_EQUIP_NULL_RING,
	}
	
	if tbData then
		local tbSlots = tbData:GetEquips();
		for _, pos in pairs(l_tbEquipPos) do
			local equip = tbSlots[pos]
			local widget = self.m_tbEquipsPos2Widget[pos]
			local imgIcon = widget:getChildByName("img_equip")
			if equip then
				self.m_tbBtnEquips[widget] = equip:GetIndex();
				imgIcon:loadTexture(equip:GetIcon());
				widget:loadTexture(equip:GetQualityIcon())
			else
				imgIcon:loadTexture(tbNullEquipResource[widget._equip_type])
				widget:loadTexture(CUI_PATH_EQUIP_QUALITY_0);
			end
		end
	else
		for _, pos in pairs(l_tbEquipPos) do
			local widget = self.m_tbEquipsPos2Widget[pos]
			local imgIcon = widget:getChildByName("img_equip")
			imgIcon:loadTexture(tbNullEquipResource[widget._equip_type])
		end
	end
end

--@function: 更新英雄套装属性
function KGC_HERO_LIST_LAYER_TYPE:UpdateSuitAttribute(hero)
	if not hero then
		return;
	end
	
	local nEquipSuit = hero:GetEquipSuit();
	local nStar = self.m_Factory:GetEquipStars(nEquipSuit);
	
	local imgBg = self.m_pnlMain:getChildByName("img_superpowerbg");
	
	local tbSuitAttrs = hero:GetSuitAttributeDesc();
	for i = 1, 5 do
		local szName = "lbl_wash_0" .. i;
		local lblAttribute = imgBg:getChildByName(szName);
		lblAttribute:setAnchorPoint(cc.p(0, 0.5));
		local szAttr = tbSuitAttrs[i]
		if nStar < i then
			szAttr = string.format("(全身%d星开启)", i);
		end
		lblAttribute:setString(szAttr);
	end
end

--@function: 一键装备
function KGC_HERO_LIST_LAYER_TYPE:AutoEquip()
	local tbHeros = me:GetHeros();
	local hero = tbHeros[self.m_nCurHero]
	local nSuit = hero:GetEquipSuit();		
	local tbEquips = me:GetEquips();
	local objEquips = tbEquips[nSuit]

	cclog("[Log]一键装备，英雄(%s)，第几套(%s)", hero:GetName(), tostring(nSuit))
	local tbData = {}
	-- tbData.uuid = me:GetAccount();
	tbData.area = 1;
	tbData.sign = 1;
	tbData.seq = nSuit;
	if nSuit > 0 then
		local nCount = 0;
		for i = 1, 6 do 
			local oldEquip = objEquips:GetAEquip(i);
			local newEquip = me:GetBag():GetBestEquip(i, oldEquip);
			local szKey = "id" .. i;
			if newEquip then
				nCount = nCount + 1;
				tbData[szKey] = newEquip:GetIndex();
			else
				tbData[szKey] = 0;
			end
		end
		if nCount > 0 then
			KGC_EQUIP_LOGIC_TYPE:getInstance():ReqChangeEquicp(tbData);
		end
	else
		TipsViewLogic:getInstance():addMessageTips(11008);
	end
end

function KGC_HERO_LIST_LAYER_TYPE:OnCloseSubLayer(subLayer)
end

--@function: 装备淬炼结果
function KGC_HERO_LIST_LAYER_TYPE:EquipAttrPickResult()
	if self.pLogic.currentTabId ==1 then 
		self.characterLayer:OnEquipAttrPick()
	end
end

--@function: 重载KGC_UI_BASE_LAYER:OnUpdateSubLayer()
function KGC_HERO_LIST_LAYER_TYPE:OnUpdateSubLayer(nID, tbArg)
	print("OnUpdateSubLayer ... ", self:GetClassName())
	
	self:LoadHeros();
	self:UpdateHeros();
end

--@function: 更新提醒
function KGC_HERO_LIST_LAYER_TYPE:UpdateRemind()
	print("UpdateRemind ............... ");
	-- 更新当前英雄装备
	local tbHeros = me:GetHeros();
	local hero = tbHeros[self.m_nCurHero]
	if hero then
		local nSuit = hero:GetEquipSuit();		
		local tbEquips = me:GetEquips();
		local objEquips = tbEquips[nSuit]
		local nCount = 0;
		-- 六件装备
		for _, pos in pairs(l_tbEquipPos) do
			local oldEquip = objEquips:GetAEquip(pos);
			local newEquip = me:GetBag():GetBestEquip(pos, oldEquip);
		
			if newEquip then
				nCount = nCount + 1;
			end
		end
		print("要更新的个数为：", nCount);
		local btnAutoEuip =  self.m_pnlMain:getChildByName("btn_allequip");
		local imgRemind = btnAutoEuip:getChildByName("img_redpoint");
		if nCount > 0 then
			imgRemind:setVisible(true);
		else
			imgRemind:setVisible(false);
		end
	end
end
