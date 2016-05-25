----------------------------------------------------------
-- file:	hero_reinforce_sublayer.lua
-- Author:	page
-- Time:	2015/09/18 09:59
-- Desc:	英雄强化面板(升品、升星)
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/npc/herofactory")

local l_tbEffectDecoration = require("script/cfg/client/decorationeffect")
local l_tbSublayerType = def_GetHeroSublayerType();

local TB_STRUCT_HERO_REINFORCE_SUBLAYER = {
	m_pLayout = nil,

	m_nCurPage = 0,			-- 当前标签页
	m_tbPages = {			-- page 界面
	},
	
	m_Factory,				-- 兵工厂
	
	m_heroObj = nil,		-- 英雄对象
	
	m_imgColor,				-- 符文背景
	m_imgColorBg,			-- 颜色渐变背景
	--------------------------------------
	-- 升品
	
	--------------------------------------
	-- 升星
	
	--------------------------------------
}

KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE = class("KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE", 
	KGC_UI_BASE_SUB_LAYER, 
	TB_STRUCT_HERO_REINFORCE_SUBLAYER)

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:OnExit()
    
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {}
	local hero = tbArg[1]
	if not hero then
		return;
	end
	-- 初始化一个Factory
	self.m_Factory = KGC_HERO_FACTORY_TYPE:getInstance();
	
	self.m_heroObj = hero;
	self:LoadScheme();
	
	-- 更新数据
	self:UpdateQualityInfo(self.m_heroObj);
	self:UpdateStarsInfo(self.m_heroObj);
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_REINFORCE_PATH)
	self:addChild(self.m_pLayout)
	
	local imgBg = self.m_pLayout:getChildByName("img_bg");
	self.m_imgColor = imgBg:getChildByName("img_color");
	self.m_imgColorBg = imgBg:getChildByName("pnl_colour_bg");
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	---------------------------------------- 升品
	-- 加载升品界面
	local layoutQuality = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_QUALITY_PATH)
	layoutQuality:setVisible(true)
	self.m_pLayout:addChild(layoutQuality)
	self.m_tbPages[1] = layoutQuality;
	
	local btnUpQuality = layoutQuality:getChildByName("btn_confirm");
	local fnUpQuality = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventUpQuality();
		end
	end
	btnUpQuality:addTouchEventListener(fnUpQuality);
	---------------------------------------- 升星
	-- 加载升星界面
	local layoutStars = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_STARS_PATH)
	layoutStars:setVisible(false);
	self.m_pLayout:addChild(layoutStars)
	self.m_tbPages[2] = layoutStars;
	
	local btnUpStar = layoutStars:getChildByName("btn_confirm");
	local fnUpQuality = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEventUpStar();
		end
	end
	btnUpStar:addTouchEventListener(fnUpQuality);
	---------------------------------------- end
	
	-- 标签页按钮
	local btnQuality = self.m_pLayout:getChildByName("btn_quality")
	local btnStar = self.m_pLayout:getChildByName("btn_star")

	local fnChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnQuality then
				self:ChangePage(1)
				-- self:UpdateQualityInfo(self.m_heroObj);
			elseif sender == btnStar then
				self:ChangePage(2)
				-- self:UpdateStarsInfo(self.m_heroObj);
			end
		end
	end
	btnStar:addTouchEventListener(fnChange)
	btnQuality:addTouchEventListener(fnChange)
	
	-- 左右切换按钮
	local btnLeft = self.m_pLayout:getChildByName("btn_left")
	local btnRight = self.m_pLayout:getChildByName("btn_right")
	btnLeft:setLocalZOrder(1);
	btnRight:setLocalZOrder(1);
	local fnTouchChangeHero = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnLeft then
				self:ChangeHero(1);
			elseif sender == btnRight then
				self:ChangeHero(-1);
			end
		end
	end
	btnLeft:addTouchEventListener(fnTouchChangeHero);
	btnRight:addTouchEventListener(fnTouchChangeHero);
	
	-- 动画
	local actionTo = cc.RotateBy:create(15, 90)
	self.m_imgColor:runAction(cc.RepeatForever:create(actionTo));
end

--@function: 切换标签页
--@nPage: 1-升品; 2-升星
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:ChangePage(nPage)
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
		
		-- 颜色
		local tbColor = {
			[1] = {73, 37, 121},
			[2] = {120, 36, 116},
		}
		local r, g, b = unpack(tbColor[nPage]);
		self.m_imgColor:setColor(cc.c3b(r, g, b));
		self.m_imgColorBg:setColor(cc.c3b(r, g, b));
	end
	
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:ChangeButton(nPage)
	local btnStar = self.m_pLayout:getChildByName("btn_star")
	local btnQuality = self.m_pLayout:getChildByName("btn_quality")
	
	local imgUpQuality = btnQuality:getChildByName("img_up")
	local imgDownQuality = btnQuality:getChildByName("img_down")
	local imgUpStar = btnStar:getChildByName("img_up")
	local imgDownStar = btnStar:getChildByName("img_down")
	if nPage == 2 then			-- 升星
		imgUpStar:setVisible(true)
		imgDownStar:setVisible(false)
		imgDownQuality:setVisible(true);
		imgUpQuality:setVisible(false);
	elseif nPage == 1 then		-- 升品
		imgUpStar:setVisible(false)
		imgDownStar:setVisible(true)
		imgDownQuality:setVisible(false);
		imgUpQuality:setVisible(true);
	end
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateHero(pnlHero, hero, nQuality)
	if not pnlHero then
		return;
	end
	
	local imgHeroBg = pnlHero:getChildByName("img_herobg");				-- 英雄背景
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local svStars = imgHeroBg:getChildByName("sv_star")					-- 英雄星级
	
	local nQuality = nQuality or hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	imgHeroBg:loadTexture(szHeroBg);
	imgHero:loadTexture(szIconS);
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	if svStars then
		self:UpdateStars(svStars, nStar, szStarBg)
	end
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
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

--@function: 更新材料
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateAMaterialInfo(pnlItem, nID, nNum)
	if not pnlItem then
		return;
	end

	local nNum = nNum or 0;
	if nID then
		-- 计算自己的数量
		local nHas = 0;
		local item = me:GetBag():GetItemByID(nID);
		if item then
			nHas = item:GetNum();
		end
		print(nID, "道具拥有数量：", nHas);
		
		local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(nID)
		pnlItem:setVisible(true);
		local lblName = pnlItem:getChildByName("lbl_itemname");				-- 材料名字
		local imgIcon = pnlItem:getChildByName("img_itemicon");				-- 材料图标
		local imgQuality = pnlItem:getChildByName("img_materiallevelbg");	-- 材料品质
		local bmpNum = pnlItem:getChildByName("btm_itemnumber");			-- 材料数量
		
		lblName:setString(item:GetName());
		imgIcon:loadTexture(item:GetIcon());
		imgQuality:loadTexture(item:GetQualityIcon());
		local szNum = nHas .. "/" .. nNum;
		bmpNum:setString(szNum);
		if nHas < nNum then
			bmpNum:setColor(cc.c3b(255, 0, 0));
		else
			bmpNum:setColor(cc.c3b(255, 255, 255));
		end
	else
		pnlItem:setVisible(false);
	end
end

--@function: 左右切换英雄
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:ChangeHero(nChange)
	if self.m_heroObj then
		local tbHeros = me:GetHeros();
		local nMax = #tbHeros;
		local nIndex = 1;
		for i = 1, nMax do
			if self.m_heroObj == tbHeros[i] then
				nIndex = i;
				break;
			end
		end
		
		-- 计算下一个index
		local nNext = self:GetNewPosition(nIndex, nMax, nChange);
		local hero = tbHeros[nNext]
		if hero then
			self.m_heroObj = hero;
			
			-- 更新数据
			self:UpdateQualityInfo(self.m_heroObj);
			self:UpdateStarsInfo(self.m_heroObj);
		end
	end
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:GetNewPosition(nPos, nMax, nChange)
	if not nPos or not nMax or not nChange then
		return 0;
	end
	local nNew = (nPos + nChange) % nMax;
	if nNew == 0 then
		nNew = nMax;
	end
	return nNew;
end

--@function: 主界面更新通知二级界面更新
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	local nLayerID = self.m_pParent:GetLayerID();		-- for 特效

	local fnCallBack = function()
		self:UpdateQualityInfo(self.m_heroObj);
		self:UpdateStarsInfo(self.m_heroObj);
	end
	
	-- 播放特效
	if nID == 2 then			-- 升星回调
		local pnlStars = self.m_tbPages[2];
		local node = pnlStars:getChildByName("Image_156");
		local posX, posY = node:getPosition();
		local tbConfig = l_tbEffectDecoration[1004]
		local nScale = tbConfig.scale;
		local tbPos = tbConfig.position;
			
		local effect = af_BindEffect2Node(pnlStars, 60035, nil, nScale, fnCallBack, {nil, nil, nLayerID})
		if effect then
			if tbPos then
				effect:setPosition(cc.p(unpack(tbPos)));
			end
		end
	elseif nID == 3 then		-- 升品回调
		local tbConfig1 = l_tbEffectDecoration[1003]		-- 角色身上特效
		local nScale1 = tbConfig1.scale;
		local tbConfig2 = l_tbEffectDecoration[1002]		-- 升品主特效
		local nScale2 = tbConfig2.scale;
		local tbPos2 = tbConfig2.position;
		
		local pnlQuality = self.m_tbPages[1];
		
		for i = 1, 4 do
			local szName = "img_material0" .. i;
			local node = pnlQuality:getChildByName(szName);
			-- print(111, node, szName);
			local x, y = node:getPosition();
			
			local effect1 = af_BindEffect2Node(pnlQuality, 60036, nil, nScale1, nil, {nil, nil, nLayerID})
			if effect1 then
				effect1:setPosition(cc.p(x, y));
			end
		end
		local fnCall = function()
			local effect2 = af_BindEffect2Node(pnlQuality, 60034, nil, nScale2, fnCallBack, {nil, nil, nLayerID})
			if effect2 then
				effect2:setPosition(cc.p(unpack(tbPos2)));
			end
		end
		local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(fnCall));
		pnlQuality:runAction(action);
		-- local node = pnlQuality:getChildByName("img_heroinput");
		-- local posX, posY = node:getPosition();
		-- local effect = af_BindEffect2Node(pnlQuality, 60035, {{0.5, 0.5}, 100}, 5, fnCallBack)
		if effect then
			-- effect:setPosition(cc.p(posX, posY));
		end
	end
end
-------------------------------------------------------------------
-- ***升品***
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:TouchEventUpQuality()
	print("开始升品 ... ")
	local bRet, nErrID = self:IsCanUpQuality(self.m_heroObj)
	if bRet then
		KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqHeroUpQuality(self.m_heroObj:GetID());
	else
		TipsViewLogic:getInstance():addMessageTipsEx(nErrID);
	end
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateQualityInfo(hero)
	local pnlQuality = self.m_tbPages[1]
	if not pnlQuality then
		return;
	end
	
	local pnlHero = pnlQuality:getChildByName("pnl_hero");
	self:UpdateHero(pnlHero, hero);
	
	for i=1, 2 do
		local szName = "pnl_hero_" .. i;
		local pnlHero = pnlQuality:getChildByName(szName);
		local nQuality = hero:GetQuality();
		nQuality = nQuality + i - 1;
		self:UpdateHero(pnlHero, hero, nQuality);
	end
	
	-- 属性
	local nNeedLevel, tbCurQualityAddAttr, tbNextQualityAddAttr = KGC_HERO_FACTORY_TYPE:getInstance():GetNextQualityData(hero);
	local lblLevel = pnlHero:getChildByName("lbl_levelinfo");
	
	local nLevel = hero:GetLevel();
	local szString = "LV." .. nLevel .. "/" .. nNeedLevel;
	lblLevel:setString(szString);
	if nLevel < nNeedLevel then
		lblLevel:setColor(cc.c3b(255, 0, 0));
	else
		lblLevel:setColor(cc.c3b(255, 255, 255));
	end
	
	local l_tbAddAttr = {
		[1] = tbCurQualityAddAttr,
		[2] = tbNextQualityAddAttr,
	};
	self:UpdateAttribute(pnlQuality, hero, l_tbAddAttr);
	
	-- 材料
	self:UpdateMaterials(pnlQuality, hero);
end

--@function: 更新升品属性提升
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateAttribute(panel, hero, tbData)
	if not panel then
		return;
	end

	local imgBg = panel:getChildByName("pnl_soulbg");
	local l_tbAttrName = {
		[1] = "攻击力",
		[2] = "防御力",
		[3] = "生命值",
	};
	
	for i = 1, 2 do
		local szName = "pnl_date" .. i;
		local pnlAttr = imgBg:getChildByName(szName);
		local tbAttr = tbData[i]
		for j = 1, 3 do
			local szName = "lbl_info" .. j;
			local lblInfo = pnlAttr:getChildByName(szName);
			if tbAttr[j] then
				local szString = l_tbAttrName[j] .. ":+" .. tbAttr[j];
				lblInfo:setVisible(true);
				lblInfo:setString(szString);
			else
				lblInfo:setVisible(false);
			end
		end
	end
	
	-- 星级(升星);
	local nStar = hero:GetStars();
	local nQuality = hero:GetQuality();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local svStarsBefore = imgBg:getChildByName("sv_star_before");
	local svStarsAfter = imgBg:getChildByName("sv_star_after");
	if svStarsBefore then
		self:UpdateStars(svStarsBefore, nStar, szStarBg);
	end
	
	if svStarsAfter then
		self:UpdateStars(svStarsAfter, nStar+1, szStarBg);
	end
end

--@function: 更新材料
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateMaterials(pnlQuality, hero)
	if not pnlQuality then
		return;
	end
	local nID = hero:GetID();
	local nQuality = hero:GetQuality();
	local tbMaterials = KGC_HERO_FACTORY_TYPE:getInstance():GetUpQualityNeed(nID, nQuality+1);
	
	print("当前品质为：", nQuality, tbMaterials);
	if tbMaterials then
		for i = 1, 4 do
			local nID, nNum = unpack(tbMaterials[i] or {});
			print("下一个品质所需材料ID和数量：", nID, nNum)
			local szName = "img_material0" .. i;
			local imgMaterial = pnlQuality:getChildByName(szName);
			-- if i == 1 then
				self:UpdateAMaterialInfo(imgMaterial, nID, nNum);
			-- else
				-- self:UpdateAMaterialInfo(imgMaterial, nil);
			-- end
		end
	else
		for i = 1, 4 do
			local szName = "img_material0" .. i;
			local imgMaterial = pnlQuality:getChildByName(szName);
			imgMaterial:setVisible(false);
		end
	end
end

--@function: 是否可以升品
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:IsCanUpQuality(hero)
	return KGC_HERO_FACTORY_TYPE:getInstance():IsCanUpQuality(hero);
end
-------------------------------------------------------------------
-- ***升星***
function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:TouchEventUpStar()
	print("开始升星 ... ")
	local bRet, nErrID = self:IsCanUpStar(self.m_heroObj)
	if bRet then
		KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqHeroUpStar(self.m_heroObj:GetID());
	else
		TipsViewLogic:getInstance():addMessageTipsEx(nErrID);
	end
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:UpdateStarsInfo(hero)
	local pnlStars = self.m_tbPages[2]
	if not pnlStars then
		return;
	end
	
	local pnlHero = pnlStars:getChildByName("pnl_hero");
	self:UpdateHero(pnlHero, hero);
	
	-- 属性
	local tbCurStarAddAttr, tbNextStarAddAttr = KGC_HERO_FACTORY_TYPE:getInstance():GetNextStarData(hero);
	local l_tbAddAttr = {
		[1] = tbCurStarAddAttr,
		[2] = tbNextStarAddAttr,
	};
	self:UpdateAttribute(pnlStars, hero, l_tbAddAttr);
	
	-- 材料
	local nStar = hero:GetStars();
	local nID, nNum, nCost = KGC_HERO_FACTORY_TYPE:getInstance():GetUpStarNeed(nStar + 1);
	local imgMateria = pnlStars:getChildByName("img_material");
	self:UpdateAMaterialInfo(imgMateria, nID, nNum);
	
	-- 金币
	local btnMoney = pnlStars:getChildByName("btn_money");
	local bmpMoney = btnMoney:getChildByName("bmp_moneynum");
	bmpMoney:setString(nCost);
end

function KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:IsCanUpStar(hero)
	return KGC_HERO_FACTORY_TYPE:getInstance():IsCanUpStar(hero);
end