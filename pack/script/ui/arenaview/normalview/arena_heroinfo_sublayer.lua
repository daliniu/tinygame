----------------------------------------------------------
-- file:	arena_heroinfo_sublayer.lua
-- Author:	page
-- Time:	2015/12/20:42
-- Desc:	对战面板英雄详细信息
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")

local l_tbEquipPos = def_GetPlayerEquipPos();

local TB_STRUCT_ARENA_HERO_INFO_SUBLAYER = {
	m_pLayout = nil,
	
	m_nCurHero = 1,						-- 当前英雄索引
	m_tbEquipsPos2Widget = {},			-- 保存装备控件
}

KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE = class("KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE", 
	KGC_UI_BASE_SUB_LAYER, 
	TB_STRUCT_ARENA_HERO_INFO_SUBLAYER)

function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:OnExit()
    
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {};
	local player = tbArg[1];
	if not player then
		return;
	end
	self.m_objPlayer = player;
	
	self:LoadScheme();
	
	self:LoadMiniHeros();
	self:UpdateHeros();
end

function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_PVP_ARENA_HEROINFO_PATH)
	self:addChild(self.m_pLayout)
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	self.m_pLayout:addTouchEventListener(fnClose);
	local btnClose = self.m_pLayout:getChildByName("btn_close");
	btnClose:addTouchEventListener(fnClose);
	
	--装备
	local tbEquipWidgetNames = {
		[l_tbEquipPos.P_HEAD] = "img_head",								-- 头
		[l_tbEquipPos.P_CLOTH] = "img_armor",							-- 衣服
		[l_tbEquipPos.P_SHOES] = "img_shoes",							-- 鞋子
		[l_tbEquipPos.P_WEAPON] = "img_weapon",							-- 武器
		[l_tbEquipPos.P_NECKLACE] = "img_necklace",						-- 项链
		[l_tbEquipPos.P_RING] = "img_ring",								-- 戒指
	}
	for nType, szName in pairs(tbEquipWidgetNames) do
		local btnEquip = self.m_pLayout:getChildByName(szName)
		-- 保存控件对应的部位
		btnEquip._equip_type = nType;										
		-- 保存装备控件用作更新
		self.m_tbEquipsPos2Widget[nType] = btnEquip;
	end
	
	-- 左右切换按钮
	local btnLeft = self.m_pLayout:getChildByName("btn_left")
	local btnRight = self.m_pLayout:getChildByName("btn_right")
	local fnChange = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnLeft then
				self:ChangeHero(-1)
			elseif sender == btnRight then
				self:ChangeHero(1)
			end
		end
	end
	btnLeft:addTouchEventListener(fnChange)
	btnRight:addTouchEventListener(fnChange)
end

--@function: 更新英雄信息
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:UpdateHeros()
	if not self.m_objPlayer then
		return;
	end
	local tbHeros = self.m_objPlayer:GetHeros()
	if self.m_nCurHero <= 0 or self.m_nCurHero > #tbHeros then
		self.m_nCurHero = 1;
	end
	local hero = tbHeros[self.m_nCurHero]
	if not hero then
		return;
	end
	
	local pnlHero = self.m_pLayout:getChildByName("pnl_hero");
	local imgHeroBg = pnlHero:getChildByName("img_herobg");				-- 英雄背景
	local lblName = pnlHero:getChildByName("lbl_heroname");				-- 英雄名字
	local lblLevel = imgHeroBg:getChildByName("lbl_level")				-- 英雄等级
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local svStars = imgHeroBg:getChildByName("sv_star");				-- 英雄星级
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
	local bmpFightPoint = imgFightPoint:getChildByName("bmp_fightnum");	-- 英雄战斗力
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	
	imgHeroBg:loadTexture(szHeroBg);
	lblLevel:setString("LV." .. hero:GetLevel());
	lblName:setString(hero:GetName());
	imgHero:loadTexture(szIconS);
	self:UpdateStars(svStars, nStar, szStarBg)
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	bmpFightPoint:setString(hero:GetFightPoint());
	
	-- 微布阵显示(注意：位置和站位的panel一致)
	for i = 1, 3 do
		local szName = "img_herobg" .. i;
		local imgHero = self.m_pLayout:getChildByName(szName);
		local imgSelected = imgHero:getChildByName("img_select")
		if self.m_nCurHero == i then
			imgSelected:setVisible(true);
		else
			imgSelected:setVisible(false);
		end
	end

	--更新装备
	self.m_tbBtnEquips = {};
	local nSuit = hero:GetEquipSuit();
	self:UpdateEquips(nSuit)
end

--@function: 微布阵英雄icon显示
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:LoadMiniHeros()
	if not self.m_objPlayer then
		return;
	end
	local tbHeros = self.m_objPlayer:GetHeros()
	for i = 1, 3 do
		local hero = tbHeros[i]
		local szName = "img_herobg" .. i;
		local imgHero = self.m_pLayout:getChildByName(szName);
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

function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
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

--@function: 更新英雄装备
--@nSuit: 装备为第(1/2/3)套装备
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:UpdateEquips(nSuit)
	if not self.m_objPlayer then
		return;
	end
	local tbEquips = self.m_objPlayer:GetEquips();
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

--@function: 左右切换
--@nChange: 方向-1：左；+1：右
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:ChangeHero(nChange)
	if self.m_bIsMoving or not self.m_objPlayer then
		return;
	end
	
	-- 防止动作被中断
	self.m_bIsMoving = true;
	
	-- 计算新的当前英雄
	local tbHeros = self.m_objPlayer:GetHeros();
	local nMax = #tbHeros
	if nMax <= 0 then
		cclog("[Error]英雄个数<=0, @KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:ChangeHero")
	end
	self.m_nCurHero = self:GetNewPosition(self.m_nCurHero, nMax, nChange);
		
	self:UpdateHeros();
	
	self.m_bIsMoving = false;
end

--@function: 获取新的位置, 公式: x % nMax + nChange
--@nPos: 当前的位置
--@nMax: 位置的总数(eg: 总数是3, 当前位置如果是1, +1就编程了1)
--@nChange：变化的数值
function KGC_UI_ARENA_HERO_INFO_SUBLAYER_TYPE:GetNewPosition(nPos, nMax, nChange)
	if not nPos or not nMax or not nChange then
		return 0;
	end
	local nNew = (nPos + nChange) % nMax;
	if nNew == 0 then
		nNew = nMax;
	end
	return nNew;
end