----------------------------------------------------------
-- file:	herolineupsublayer.lua
-- Author:	page
-- Time:	2015/09/07 11:42
-- Desc:	英雄布阵二级界面类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
local l_tbEquipPos = def_GetPlayerEquipPos();
local l_tbSublayerType = def_GetHeroSublayerType();

local TB_STRUCT_HERO_LINEUP_SUBLAYER={
	m_pLayout = nil,				-- 主界面
	
	m_pnlMain = nil,				-- 所有控件在这上面
	
	-- 未上阵英雄排列参数
	m_nWidth = 167,					-- 一个英雄panel的宽度
	m_nHeight = 200,				-- 一个英雄panel的高度
	m_nWidthSpace = 0,				-- 两个英雄panel水平间距
	m_nHeightSpace = 0,				-- 两个英雄panel垂直间距
	m_nSVMaxHeight = 1000,			-- scrollview的最大高度
	
	m_wgtHero = nil,				-- 保存选中的英雄
	m_tbOnlineHeroPanels = {},		-- 保存上阵英雄占用的未上阵中的panel
}

KGC_HERO_LINEUP_SUBLAYER_TYPE = class("KGC_HERO_LINEUP_SUBLAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_HERO_LINEUP_SUBLAYER)

function KGC_HERO_LINEUP_SUBLAYER_TYPE:ctor()
end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_HERO_LINEUP_SUBLAYER_TYPE:initAttr()
	self:LoadScheme();
	
	self:LoadHerosOnline();
	self:LoadHerosOffline();
end

function KGC_HERO_LINEUP_SUBLAYER_TYPE:OnExit()

end

--@function: 加载界面
function KGC_HERO_LINEUP_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_LINEUP_PATH)
	self:addChild(self.m_pLayout)
	self.m_pnlMain = self.m_pLayout:getChildByName("img_bg")
	
	--关闭按钮
    local function fnClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:closeLayer()
        end
    end
	local btnClose = self.m_pnlMain:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	-- 上阵英雄
	-- local fnTouchHeroOnline = function(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended then
			-- print("touch hero online ... ")
			-- self:TouchEventHero(sender);
		-- end
	-- end
	-- for i = 1, 3 do 
		-- local szName = "pnl_hero".. i;
		-- local pnlHero = self.m_pnlMain:getChildByName(szName);
		-- pnlHero:addTouchEventListener(fnTouchHeroOnline);
		-- -- 设置战斗力不可见
		-- local imgHeroBg = pnlHero:getChildByName("img_herobg");
		-- local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
		-- imgFightPoint:setVisible(false);
	-- end
	
	-- 未上阵英雄
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
	cclog("[log]未上阵英雄列表：最大高度：%d", self.m_nSVMaxHeight);
	cclog("[log]未上阵英雄列表：参考英雄panel的宽高(%d, %d), 坐标(%d, %d)", size.width, size.height, x, y);
	cclog("[log]未上阵英雄列表：水平参考坐标(%d, %d), 计算水平间隔：%d", xH, yH, self.m_nWidthSpace);
	cclog("[log]未上阵英雄列表：垂直参考坐标(%d, %d), 垂直水平间隔：%d", xV, yV, self.m_nHeightSpace);
end

--@function: 加载阵上英雄
function KGC_HERO_LINEUP_SUBLAYER_TYPE:LoadHerosOnline()
	local tbHeros = me:GetHeros();
	
	-- 上阵英雄
	local fnTouchHeroOnline = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("touch hero online ... ", sender._position)
			self:TouchEventHero(sender);
		end
	end
	
	for i = 1, 3 do
		local szName = "pnl_hero" .. i;
		local pnlHero = self.m_pnlMain:getChildByName(szName);
		pnlHero:setVisible(true);
		local imgHero = pnlHero:getChildByName("img_herobg");
		imgHero:setVisible(false);
		
		-- 保存位置信息(4, 5, 6)
		pnlHero._position = i + 3; 
		
		pnlHero:addTouchEventListener(fnTouchHeroOnline);
		-- 设置战斗力不可见
		local imgHeroBg = pnlHero:getChildByName("img_herobg");
		local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
		imgFightPoint:setVisible(false);
		
		self:UpdateHero(pnlHero, i);
	end
	
	-- 阵上英雄有位置, 显示的时候按位置来, panel1-pos3, panel2-pos4, panel3-pos5
	local tbTemp = {};
	for _, hero in pairs(tbHeros) do
		local nPos = hero:GetPos();
		local szName = self:GetPos2PanelName(nPos);
		if szName then
			local pnlHero = self.m_pnlMain:getChildByName(szName);
			local imgHero = pnlHero:getChildByName("img_herobg");
			imgHero:setVisible(true);
			pnlHero._hero_id = hero:GetID();
			self:UpdateHero(pnlHero);
		end
	end
end

--@function: 加载未上阵英雄
function KGC_HERO_LINEUP_SUBLAYER_TYPE:LoadHerosOffline()
	-- 每一行最多放四个
	local MAX_COL = 4;
	
	local fnTouchHeroOffline = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("touch hero offline ... ")
			-- self:SetSelectArrow(sender, true);
			self:TouchEventHero(sender);
		end
	end
	
	local tbOnlineHeroPanels = self:GetOnlineHeroPanel();
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
		pnlHero:addTouchEventListener(fnTouchHeroOffline);
		
		-- 设置战斗力不可见
		local imgHeroBg = pnlHero:getChildByName("img_herobg");
		local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
		imgFightPoint:setVisible(false);
		
		-- 数据绑定
		local nID = hero:GetID();
		pnlHero._hero_id = nID;
		if hero:IsOn() then
			pnlHero:setOpacity(125);
			pnlHero:setTouchEnabled(false);
			tbOnlineHeroPanels[nID] = pnlHero;
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

--@function: 设置选中箭头位置和是否可见
--@widget: 非nil的时候可见; 为nil的时候把当前的设置为不可见
function KGC_HERO_LINEUP_SUBLAYER_TYPE:SetSelectArrow(widget)
	local bVisible = bVisible or false;
	if self.m_wgtHero then
		-- 英雄panel高亮去掉
		self:SetHeroPanelVisible(self.m_wgtHero, false);
		local btnSelect = self.m_wgtHero:getChildByName("btn_select");
		btnSelect:setVisible(false);
	end
	if not widget then
		self.m_wgtHero = nil;
		return;
	end
	
	self.m_wgtHero = widget;
	local btnSelect = self.m_wgtHero:getChildByName("btn_select");
	btnSelect:setVisible(true);
end

--@function: 设置英雄为选中状态
--@pnlHero: 英雄控件
function KGC_HERO_LINEUP_SUBLAYER_TYPE:SetHeroPanelVisible(pnlHero, bVisible)
	if not pnlHero then
		return;
	end
	local bVisible = bVisible or false;
	
	local imgHeroBg = pnlHero:getChildByName("img_herobg")			-- 英雄背景
	local imgEquipBg = pnlHero:getChildByName("img_equipbg");		-- 装备背景
	if imgHeroBg then
		local imgSelect = imgHeroBg:getChildByName("img_select");
		if imgSelect then
			imgSelect:setVisible(bVisible);
		end
	end
	if imgEquipBg then
		local imgSelect = imgEquipBg:getChildByName("img_select");
		if imgSelect then
			imgSelect:setVisible(bVisible);
		end
	end
end

--@function 点击英雄触发事件
function KGC_HERO_LINEUP_SUBLAYER_TYPE:TouchEventHero(widget)
	if not widget then
		return;
	end

	print("TouchEventHero ... ", tostring(widget), widget._position);
	-- 先检测是否需要选中
	if self:CheckIsSelected() then
		if self:CheckIsSwap(self.m_wgtHero, widget) then
			cclog("[Log]可以换英雄了 ... ")
			self:SwapHero(self.m_wgtHero, widget);
		else
			self:SetSelectArrow(widget);
		end
	else
		self:SetSelectArrow(widget);
	end
	
	-- 设置英雄高亮
	self:SetHeroPanelVisible(widget, true);
	self:SetFighetPointVisible(true);
end

--@function: 检测是否已经选中英雄了
function KGC_HERO_LINEUP_SUBLAYER_TYPE:CheckIsSelected()
	return self.m_wgtHero and true or false;
end

--@function: 检测是否可以换位置
function KGC_HERO_LINEUP_SUBLAYER_TYPE:CheckIsSwap(widgetSrc, widgetDst)
	local bRet = true;
	if widgetSrc == widgetDst then
		bRet = false;
	end
	local heroSrc = self:GetHeroByWidget(widgetSrc);
	local heroDst = self:GetHeroByWidget(widgetDst);
	if not heroSrc and not heroDst then
		cclog("[Error]根据ID没有找到对应的英雄src(%s)-%s, dst(%s)-%s@CheckIsSwap", tostring(nIDSrc), tostring(heroSrc), tostring(nIDDst), tostring(heroDst));
		bRet = false;
	else
		local nPosSrc = self:GetPosByWidget(widgetSrc);
		local nPosDst = self:GetPosByWidget(widgetDst);
		if not gf_IsValidPos(nPosSrc) and not gf_IsValidPos(nPosDst) then
			cclog("[Error]换阵位置都是无效的nPosSrc(%s), nPosDst(%s)", tostring(nPosSrc), tostring(nPosDst));
			bRet = false;
		end
	end
	
	return bRet;
end


--@function: 两个英雄互换
--@widgetSrc: 第一个选中的英雄
--@widgetDst: 要互换的英雄
function KGC_HERO_LINEUP_SUBLAYER_TYPE:SwapHero(widgetSrc, widgetDst)	
	local heroSrc = self:GetHeroByWidget(widgetSrc);
	local heroDst = self:GetHeroByWidget(widgetDst);
	if not heroSrc and not heroDst then
		cclog("[Error]根据ID没有找到对应的英雄src(%s)-%s, dst(%s)-%s", tostring(widgetSrc._hero_id), tostring(heroSrc), tostring(widgetDst._hero_id), tostring(heroDst));
		return;
	end
	
	-- 向服务器请求布阵: 目标位置需要为有效位置
	local nPosSrc = self:GetPosByWidget(widgetSrc);
	local nPosDst = self:GetPosByWidget(widgetDst);
	local nPos = nPosSrc;
	local nHeroID = 0;
	--------------------------------------
	-- heroDst 判断得到
	-- (1)heroDst不为空 --> 阵下任意一个		--> nPosSrc 肯定不为0(必定是阵上)
	-- (2)heroDst不为空 --> 阵上有英雄的那个	--> nPosSrc 不为0(阵上), 为0(阵下), 
	-- (3)heroDst为空 	--> 阵上没有英雄的那个	--> nPosSrc 不为0(阵上), 为0(阵下)
	--------------------------------------
	if heroDst then							-- 后点的一次有英雄(阵上或者阵下)
		nHeroID = heroDst:GetID();			
	else									-- 后点的一次没有英雄(阵上为空)
		nPos = nPosDst;
		if heroSrc then							-- 前一次点的有英雄
			nHeroID = heroSrc:GetID();
		end
	end
	--------------------------------------
	-- 根据位置判断
	-- (1)nPos == 0 --> 阵下
	-- (2)nPos != 0 --> 阵上
	--------------------------------------
	if nPos <= 0 then
		nPos = nPosDst;
		if heroSrc then
			nHeroID = heroSrc:GetID();
		end
	end
	
	if nPos <= 0 or nHeroID == 0 then
		cclog("[Error]没有有效的位置(%s)或者没有有效的英雄信息(%s)！", tostring(nPos), tostring(nHeroID));
		return;
	end
	
	-- 向服务器请求
	KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqHeroLineup(nHeroID, nPos, {widgetSrc, widgetDst});
end

--@function: 更新一个英雄面板
function KGC_HERO_LINEUP_SUBLAYER_TYPE:UpdateHero(widget, nSuit)
	if not widget then
		return;
	end
	local hero = me:GetHeroByID(widget._hero_id);
	print("UpdateHero", hero, widget._hero_id);
	local imgHeroBg = widget:getChildByName("img_herobg");				-- 英雄背景
	local lblLevel = imgHeroBg:getChildByName("lbl_level")				-- 英雄等级
	local lblName = widget:getChildByName("lbl_heroname");				-- 英雄名字
	local imgHero = imgHeroBg:getChildByName("img_hero");				-- 英雄头像
	local svStars = imgHeroBg:getChildByName("sv_star");				-- 英雄星级
	local imgTypeBg = imgHeroBg:getChildByName("img_herotypebg")		-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")				-- 英雄类型
	local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
	local bmpFightPoint = imgFightPoint:getChildByName("bmp_fightnum");	-- 英雄战斗力
	
	if not hero then
		imgHeroBg:setVisible(false);
		self:UpdateEquips(widget, nSuit or 0)
		return;
	end
	imgHeroBg:setVisible(true);
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local tbColor, _, szHeroBg, szStarBg, szTypeBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	imgHeroBg:loadTexture(szHeroBg);
	lblLevel:setString("LV." .. hero:GetLevel());
	if lblName then
		lblName:setString(hero:GetName());
	end
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	imgHero:loadTexture(szIconS);
	self:UpdateStars(svStars, nStar, szStarBg)
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
	bmpFightPoint:setString(hero:GetFightPoint());
	
	-- 更新装备
	cclog("[Log]更新装备，英雄(%s), 位置(%d)", hero:GetName(), hero:GetPos())
	local nSuit = hero:GetEquipSuit();
	self:UpdateEquips(widget, nSuit)
end

--@function: 更新英雄装备
--@nSuit: 装备为第(1/2/3)套装备
function KGC_HERO_LINEUP_SUBLAYER_TYPE:UpdateEquips(widget, nSuit)
	cclog("[Log]UpdateEquips: 更新第%s套装备", tostring(nSuit))
	if not widget then
		cclog("[Error]控件不存在！@UpdateEquips");
		return;
	end
	local imgEquipBg = widget:getChildByName("img_equipbg");
	if not imgEquipBg then
		return;
	end
	
	local tbEquips = me:GetEquips();
	local tbData = tbEquips[nSuit]
	local tbSlots = nil;
	if tbData then
		tbSlots = tbData:GetEquips();
	end
	local tbNullEquipResource = {
		[l_tbEquipPos.P_HEAD] = CUI_PATH_EQUIP_NULL_HEAD,
		[l_tbEquipPos.P_CLOTH] = CUI_PATH_EQUIP_NULL_CLOTH,
		[l_tbEquipPos.P_SHOES] = CUI_PATH_EQUIP_NULL_SHOES,
		[l_tbEquipPos.P_WEAPON] = CUI_PATH_EQUIP_NULL_WEAPON,
		[l_tbEquipPos.P_NECKLACE] = CUI_PATH_EQUIP_NULL_NECKLACE,
		[l_tbEquipPos.P_RING] = CUI_PATH_EQUIP_NULL_RING,
	}
	
	local tbEquipWidgetNames = {
		[l_tbEquipPos.P_HEAD] = "img_head",								-- 头
		[l_tbEquipPos.P_CLOTH] = "img_armor",							-- 衣服
		[l_tbEquipPos.P_SHOES] = "img_shoes",							-- 鞋子
		[l_tbEquipPos.P_WEAPON] = "img_weapon",							-- 武器
		[l_tbEquipPos.P_NECKLACE] = "img_necklace",						-- 项链
		[l_tbEquipPos.P_RING] = "img_ring",								-- 戒指
	}
	for nType, szName in pairs(tbEquipWidgetNames) do
		local btnEquip = imgEquipBg:getChildByName(szName)
		-- btnEquip:setTouchEnabled(true);
		-- self.m_tbBtnEquips[btnEquip] = nil;
		-- 保存控件对应的部位
		btnEquip._equip_type = nType;										
		-- btnEquip:addTouchEventListener(fnEquip)
		-- 保存装备控件用作更新
		-- self.m_tbEquipsPos2Widget[nType] = btnEquip;
		
		-- 显示装备图片
		local imgIcon = btnEquip:getChildByName("img_equip")
		if tbSlots then
			local equip = tbSlots[nType];
			if equip then
				imgIcon:loadTexture(equip:GetIcon());
				btnEquip:loadTexture(equip:GetQualityIcon())
			else
				imgIcon:loadTexture(tbNullEquipResource[nType])
				btnEquip:loadTexture(CUI_PATH_EQUIP_QUALITY_0);
			end
		else
			imgIcon:loadTexture(tbNullEquipResource[nType])
		end
	end
end

--@function: 更加widget找英雄
function KGC_HERO_LINEUP_SUBLAYER_TYPE:GetHeroByWidget(widget)	
	if not widget then
		cclog("[Error]控件无效@GetHeroByWidget(widget(%s))", tostring(widget));
		return;
	end
	local hero = me:GetHeroByID(widget._hero_id);
	return hero;
end

--@function: 根据widget找位置
function KGC_HERO_LINEUP_SUBLAYER_TYPE:GetPosByWidget(widget)	
	if not widget then
		cclog("[Error]控件无效@GetHeroByWidget(widget(%s))", tostring(widget));
		return 0;
	end
	local hero = self:GetHeroByWidget(widget);
	local nPos = 0;
	if hero then
		nPos = hero:GetPos();
	end
	-- 如果控件上没有绑定英雄, 位置信息就跟控件本身走
	if nPos <= 0 then
		nPos = widget._position or 0;
	end
	print("[log]英雄控件对应的英雄和位置为：", hero, nPos);
	
	return nPos;
end

--@function: 获取和未上阵英雄一起的上阵英雄面板
function KGC_HERO_LINEUP_SUBLAYER_TYPE:GetOnlineHeroPanel()	
	if not self.m_tbOnlineHeroPanels then
		self.m_tbOnlineHeroPanels = {};
	end
	return self.m_tbOnlineHeroPanels;
end

--@function: 三个上阵英雄面板的处理:透明、不可点击
function KGC_HERO_LINEUP_SUBLAYER_TYPE:ProcessOnlineHeroPanel(wgtSrc, wgtDst)
	local heroSrc = self:GetHeroByWidget(wgtSrc);
	local heroDst = self:GetHeroByWidget(wgtDst);
	-- 阵上和阵下互换的时候才需要调整，所以两个都是有效的
	if not heroSrc or not heroDst then
		return;
	end
	
	local tbOnlineHeroPanels = self:GetOnlineHeroPanel();
	-- 注意：位置已经换过来了
	local nPosSrc = heroSrc:GetPos();
	local nPosDst = heroDst:GetPos();
	
	-- 上阵到空位置上
	if nPosSrc == nPosDst then
		local widget = wgtSrc;
		if not gf_IsValidPos(wgtDst._position) then
			widget = wgtDst;
		end
		widget:setTouchEnabled(false);
		widget:setOpacity(125);
		tbOnlineHeroPanels[heroSrc:GetID()] = widget;
	end
	
	-- 都在阵上或者都不在阵上 不需要处理
	if (gf_IsValidPos(nPosSrc) and gf_IsValidPos(nPosDst)) or
	(not gf_IsValidPos(nPosSrc) and not gf_IsValidPos(nPosDst)) then
		return;
	end
	
	
	-- local pnlHero = nil;
	-- local nID = nil;
	-- if gf_IsValidPos(nPosSrc) then
		-- pnlHero = tbOnlineHeroPanels[heroSrc:GetID()];
		-- nID = heroDst:GetID();
	-- elseif gf_IsValidPos(nPosDst) then
		-- pnlHero = tbOnlineHeroPanels[heroDst:GetID()];
		-- nID = heroSrc:GetID();
	-- end
	local pnlHero = tbOnlineHeroPanels[heroSrc:GetID()]
	local nID = heroDst:GetID();
	if not pnlHero then
		pnlHero = tbOnlineHeroPanels[heroDst:GetID()]
		nID = heroSrc:GetID();
	end

	if pnlHero and nID then
		pnlHero._hero_id = nID;
		self:UpdateHero(pnlHero);
	end
end

--@function: 获取上阵英雄位置对应的panel关系
function KGC_HERO_LINEUP_SUBLAYER_TYPE:GetPos2PanelName(nPos)
	if gf_IsValidPos(nPos) then
		-- 3为上阵英雄最大个数
		local szName = "pnl_hero" .. (nPos - 3);
		return szName;
	end
end

function KGC_HERO_LINEUP_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	if nID ~= l_tbSublayerType.LT_LINEUP then
		return;
	end
	print("OnUpdateLayer ................", nID)
	local widgetSrc, widgetDst = unpack(tbArg or {});
	local heroSrc = self:GetHeroByWidget(widgetSrc);
	local heroDst = self:GetHeroByWidget(widgetDst);
	if not heroSrc and not heroDst then
		cclog("[Error]根据ID没有找到对应的英雄src(%s)-%s, dst(%s)-%s", tostring(widgetSrc._hero_id), tostring(heroSrc), tostring(widgetDst._hero_id), tostring(heroDst));
		return;
	end
	
	-- 数据互换
	local nPosSrc = self:GetPosByWidget(widgetSrc);
	local nPosDst = self:GetPosByWidget(widgetDst);
	me:SwapHero(heroSrc, heroDst, nPosSrc, nPosDst);
	
	-- 互换
	print("_hero_id", widgetSrc._hero_id, widgetDst._hero_id)
	-- widgetSrc._hero_id, widgetDst._hero_id = widgetDst._hero_id, widgetSrc._hero_id;
	self:SwapHeroIDOfWidget(widgetSrc, widgetDst);
	self:SetSelectArrow(nil, false);
	
	-- 更新
	local fnCallBack = function()
		widgetSrc:setScale(1);
		local nSuitSrc = gf_GetEquipSuitByPos(nPosSrc);
		self:UpdateHero(widgetSrc, nSuitSrc);
		local nSuitDst = gf_GetEquipSuitByPos(nPosDst);
		self:UpdateHero(widgetDst, nSuitDst);
		self:ProcessOnlineHeroPanel(widgetSrc, widgetDst);
		
		-- 设置英雄panel为正常状态，高亮不可见
		self:SetHeroPanelVisible(widgetSrc, false);
		self:SetHeroPanelVisible(widgetDst, false);
		
		self:SetFighetPointVisible(false);
	end
	
	-- 动画
	local scaleBy = cc.ScaleBy:create(1, 1.2)
	local action = cc.Sequence:create(scaleBy, cc.CallFunc:create(fnCallBack));
	widgetSrc:runAction(action);
	local skewBy = cc.SkewBy:create(0.5, 90, 5);
	local acDst = cc.Sequence:create(skewBy, skewBy:reverse());
	-- widgetDst:runAction(acDst);
end

--@function: 互换两个英雄panel的英雄ID
function KGC_HERO_LINEUP_SUBLAYER_TYPE:SwapHeroIDOfWidget(wgtSrc, wgtDst)
	if not wgtSrc or not wgtDst then
		return;
	end

	-- print(111, wgtSrc._hero_id,wgtDst._hero_id, wgtSrc._position, wgtDst._position)
	-- 如果阵上为空，并且和阵下换阵的时候，阵下的英雄ID不需要换
	--(1)先点击阵上再点击阵下的
	-- print(555, gf_IsValidPos(wgtDst._position), gf_IsValidPos(wgtSrc._position));
	if not wgtSrc._hero_id and not gf_IsValidPos(wgtDst._position) then
		wgtSrc._hero_id = wgtDst._hero_id;
	--(2)先点击阵下再点击阵上的
	elseif not wgtDst._hero_id and not gf_IsValidPos(wgtSrc._position) then
		wgtDst._hero_id = wgtSrc._hero_id;
	else
		wgtSrc._hero_id, wgtDst._hero_id = wgtDst._hero_id, wgtSrc._hero_id;
	end
end

--@function: 设置英雄panel上的战斗力可见与否
function KGC_HERO_LINEUP_SUBLAYER_TYPE:SetFighetPointVisible(bVisible)
	local bVisible = bVisible or false;
	for i = 1, 3 do
		local szName = "pnl_hero" .. i;
		local pnlHero = self.m_pnlMain:getChildByName(szName);
		-- 设置战斗力不可见
		local imgHeroBg = pnlHero:getChildByName("img_herobg");
		local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
		imgFightPoint:setVisible(bVisible);
	end
	
	local tbPnlHeros = self.m_svHeroList:getChildren() or {};
	for _, pnlHero in pairs(tbPnlHeros) do
		local imgHeroBg = pnlHero:getChildByName("img_herobg");
		if imgHeroBg then
			local imgFightPoint = imgHeroBg:getChildByName("img_fightnumbg");
			if imgFightPoint then
				imgFightPoint:setVisible(bVisible);
			end
		end
	end
end

function KGC_HERO_LINEUP_SUBLAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
	print("KGC_HERO_LINEUP_SUBLAYER_TYPE:UpdateStars", svStars, nStar, szStarBg)
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