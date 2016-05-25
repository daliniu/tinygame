----------------------------------------------------------
-- file:	starandpickuplayer.lua
-- Author:	page
-- Time:	2015/06/29 17:50
-- Desc:	强化装备界面(淬炼、升星)
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/item/head")
require("script/ui/herolistview/equipview/changelayer")
require("script/core/configmanager/configmanager");

local l_tbOtherConfig = mconfig.loadConfig("script/cfg/commons/ConfigValue");
local l_tbAttrType, l_tbAttrTypeName  = def_GetAttributeType();
local l_tbQualityType = def_GetQualityType();

local TB_STRUCT_EQUIP_REINFORCE_VIEW = {
	m_pLayout = nil,
	m_equipSelected = nil,	-- 当前选择的装备
	
	m_nCurPage = 0,			-- 当前标签页
	m_tbPages = {			-- page 界面
	},
	
	m_Factory,				-- 兵工厂
	--------------------------------------
	-- 升星
	m_tbBtn2EquipID = {			-- 材料面板按钮对应的装备索引
		--[widget] = index,	
	},
	m_btnAddMaterial = nil,		-- 记录当前选中的材料控件
	m_tbBtnAdd = {				-- 添加材料的按钮
		--[index] = widget,		
	},
	m_layoutStarRetsult = nil,	-- 升星结果界面
	
	m_svStars = nil,			-- 升星装备的星级控件
	m_pnlStarCover = nil,		-- 升星成功的特效遮挡
	--------------------------------------
	-- 淬炼
	m_tbPnlAttributes = {			-- 每一条属性
		--[[
		[1] = {
			[1] = 
			[2] = 
			[3] = 
			[4] = 
		},
		[2] = {},
		]]
	},
	m_btnEquip2 = nil,			-- 被淬炼的所在的控件
	m_equipIndex2 = 0,			-- 第二件选择的装备索引(淬炼, ps：不要存对象)
	m_szIconEquip2 = "",		-- 第二件要淬炼的装备图标
	m_nEquipStar2 = 0,			-- 第二件要淬炼的装备星级
	m_szNameEquip2 = "",		-- 第二件要淬炼的装备名字
	m_szQualityEquip2 = "",		-- 第二件要淬炼的装备的品质资源
	m_tbAttrsEquip2 = {},		-- 第二件要淬炼的装备的属性
	m_nSelAttr = 0,				-- 选择的属性
	
	m_tbPosPickAttr1 = nil,		-- 属性特效：保存第一条属性位置
	m_tbPosPickAttr2 = nil,		-- 属性特效：保存第二条属性位置
	
	m_svStarsPick = nil,		-- 淬炼界面装备的星级控件
	--------------------------------------

	m_chooseQuLayer =nil;
}

KGC_UI_EQUIP_REINFORCE_LAYER_TYPE = class("KGC_UI_EQUIP_REINFORCE_LAYER_TYPE", 
	KGC_UI_BASE_SUB_LAYER, 
	TB_STRUCT_EQUIP_REINFORCE_VIEW)

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:OnExit()
    
end

---初始化
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:initAttr()
	
	self.m_equipSelected = KGC_EQUIP_LOGIC_TYPE:getInstance():GetSelectedEquip();
	
	-- 初始化一个Factory存储数据
	self.m_Factory = KGC_EQUIP_FACTORY_TYPE:getInstance();
	self.m_Factory:ClearData();
	self.m_Factory:SetSelectedEquip(self.m_equipSelected)
	
	self.m_tbMaterialsID = KGC_EQUIP_FACTORY_TYPE:getInstance():GetMaterialsID();
	
	self:LoadScheme();
end

--@function: 获取当前选中的装备
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:GetSelectedEquip()
	return self.m_equipSelected;
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_REINFORCE)
	self:addChild(self.m_pLayout)
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(4);
		end
	end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	---------------------------------------- pick
	-- 加载淬炼界面
	local layoutPick = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_REINFORCE_PICK)
	layoutPick:setVisible(false)
	self.m_pLayout:addChild(layoutPick)
	self.m_tbPages[1] = layoutPick;
	
	local pnlPickMain =  layoutPick:getChildByName("pnl_main")
	local imgEquipBg = pnlPickMain:getChildByName("img_equipbg")
	-- 选择的道具
	local btnEquip1 = imgEquipBg:getChildByName("btn_equip_1")
	local szEquip1QualityIcon = self.m_equipSelected:GetQualityIcon();
	btnEquip1:loadTextures(szEquip1QualityIcon, szEquip1QualityIcon);
	local imgIcon1 = btnEquip1:getChildByName("img_icon")
	imgIcon1:setVisible(true);
	imgIcon1:loadTexture(self.m_equipSelected:GetIcon());
	local lblName1 = btnEquip1:getChildByName("text_name")
	lblName1:setString(self.m_equipSelected:GetName())
	self.m_svStarsPick = btnEquip1:getChildByName("sv_stars")
	self:UpdateStars(self.m_svStarsPick, self.m_equipSelected:GetStars())
	
	local btnEquip2 = imgEquipBg:getChildByName("btn_equip_2")
	local fnAddEquip = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:AddEquip(sender);
		end
	end
	btnEquip2:addTouchEventListener(fnAddEquip)
	self.m_btnEquip2 = btnEquip2
	
	local imgIcon = btnEquip2:getChildByName("img_icon")
	local lblName = btnEquip2:getChildByName("text_name")
	local imgNull = btnEquip2:getChildByName("img_pickequip")
	imgIcon:setVisible(false);
	lblName:setVisible(false);
	imgNull:setVisible(true)
	
	--属性面板
	for i=1, 2 do
		local szName = "pnl_attribute_group_" .. i;
		local pnlAttrGroup = pnlPickMain:getChildByName(szName)
		if not self.m_tbPnlAttributes[i] then
			self.m_tbPnlAttributes[i] = {}
		end
		for j = 1, 4 do
			local szNameAttr = "pnl_attribute_" .. j
			local pnlAttr = pnlAttrGroup:getChildByName(szNameAttr)
			self.m_tbPnlAttributes[i][j] = pnlAttr;
			pnlAttr._group = i;
			local fnSelect = function(sender, eventType)
				if eventType == ccui.TouchEventType.ended then
					local nGroup = sender._group;
					local tbGroup = self.m_tbPnlAttributes[nGroup]
					self:SelectedAttribute(tbGroup, sender);
				end
			end
			-- 只有需要淬炼的道具需要可勾选属性
			if i == 1 then
				pnlAttr:addTouchEventListener(fnSelect)
			end
		end
	end

	self:UpdateAttributes(1, self.m_equipSelected:GetIndex());
	self:UpdateAttributes(2, self.m_equipIndex2);
	
	-- 淬炼结果面板
	self:LoadSchemeOfPickResult();

	--淬炼按钮
	local btnPickConfirm = pnlPickMain:getChildByName("btn_pick")
	local fnPickConfirm = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:EquipPickAttr();
		end
	end
	btnPickConfirm:addTouchEventListener(fnPickConfirm)
	
	---------------------------------------- star
	-- 加载升星界面
	local layoutStar = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_REINFORCE_STAR)
	self.m_pLayout:addChild(layoutStar)
	self.m_tbPages[2] = layoutStar;
	
	local pnlStar = layoutStar:getChildByName("pnl_star_main")
	-- 选择的道具
	local btnEquip = pnlStar:getChildByName("btn_equip")
	local szQualityIcon = self.m_equipSelected:GetQualityIcon();
	btnEquip:loadTextures(szQualityIcon, szQualityIcon)
	local imgIcon = btnEquip:getChildByName("img_icon")
	imgIcon:setVisible(true);
	imgIcon:loadTexture(self.m_equipSelected:GetIcon())
	self.m_svStars = btnEquip:getChildByName("sv_stars")
	self:UpdateStars(self.m_svStars, self.m_equipSelected:GetStars());
	
	-- 材料
	local pnlMaterial = layoutStar:getChildByName("pnl_materials")
	pnlMaterial:setVisible(false)
	local fnClosePanel = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			pnlMaterial:setVisible(false)
		end
	end
	pnlMaterial:addTouchEventListener(fnClosePanel)
	local fnAddMaterial = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchAddMaterial(sender, pnlMaterial);
		end
	end
	for i = 1, 5 do
		local szName = "btn_add_" .. i;
		local btnMaterial = pnlStar:getChildByName(szName)
		btnMaterial:addTouchEventListener(fnAddMaterial)
		
		-- 把每一个可以添加道具的按钮设置一个索引
		btnMaterial.m_nIndex = i;
		self.m_tbBtnAdd[i] = btnMaterial;
	end	
	--升星按钮
	local btnStarConfirm = pnlStar:getChildByName("btn_star")
	local fnStarConfirm = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:EquipStar();
		end
	end
	btnStarConfirm:addTouchEventListener(fnStarConfirm)
	-- 一键放入
	local btnAuto = pnlStar:getChildByName("btn_auto")
	local fnAutoSelectMaterials = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:AutoSelectMaterials();
		end
	end
	btnAuto:addTouchEventListener(fnAutoSelectMaterials)
	
	-- 升星概率
	self.m_tfRate = pnlStar:getChildByName("tf_rate")
	
	-- 消耗
	local bmlMoney = btnStarConfirm:getChildByName("bmp_money")
	local nGold = self.m_Factory:GetStarCost();
	print("nGold = ", nGold)
	bmlMoney:setString(nGold)
	
	-- 升星结果界面
	self.m_layoutStarRetsult = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_REINFORCE_STAR_RESULT)
	self.m_pLayout:addChild(self.m_layoutStarRetsult)
	self.m_layoutStarRetsult:setVisible(false);
	local fnTouchWhereever = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.m_layoutStarRetsult:setVisible(false)
		end
	end
	self.m_layoutStarRetsult:addTouchEventListener(fnTouchWhereever)
	
	-- 放特效的遮挡
	self.m_pnlStarCover = layoutStar:getChildByName("pnl_cover")
	self.m_pnlStarResult = pnlStar:getChildByName("img_result")
	---------------------------------------- end
	
	-- 标签页按钮
	local btnStar = self.m_pLayout:getChildByName("btn_star")
	local btnPick = self.m_pLayout:getChildByName("btn_pick")

	local fnChange = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if sender == btnPick then
				self:ChangePage(1)
				
			elseif sender == btnStar then
				self:ChangePage(2)
			end
		end
	end
	btnStar:addTouchEventListener(fnChange)
	btnPick:addTouchEventListener(fnChange)


	---
	self:UpdateRate();
end

--@function: 切换标签页
--@nPage: 1-淬炼; 2-升星
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:ChangePage(nPage)
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

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:ChangeButton(nPage)
	local btnStar = self.m_pLayout:getChildByName("btn_star")
	local btnPick = self.m_pLayout:getChildByName("btn_pick")
	
	local imgUpPick = btnPick:getChildByName("img_up")
	local imgDownPick = btnPick:getChildByName("img_down")
	local imgUpStar = btnStar:getChildByName("img_up")
	local imgDownStar = btnStar:getChildByName("img_down")
	if nPage == 2 then			-- 升星
		imgUpStar:setVisible(true)
		imgDownStar:setVisible(false)
		imgDownPick:setVisible(true);
		imgUpPick:setVisible(false);
	elseif nPage == 1 then		-- 淬炼
		imgUpStar:setVisible(false)
		imgDownStar:setVisible(true)
		imgDownPick:setVisible(false);
		imgUpPick:setVisible(true);
	end
end

-------------------------------------------------------------------
--升星

--@function: 
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:EquipStar()
	local nTotal = self.m_Factory:GetMaterialsTotalNums()
	if nTotal <= 0 then
		TipsViewLogic:getInstance():addMessageTips(11000);
		return;
	end
	
	if self.m_equipSelected then
		local nStar = self.m_equipSelected:GetStars()
		if nStar >= tonumber(l_tbOtherConfig.nEquipMaxStars.content) then
			TipsViewLogic:getInstance():addMessageTips(11003);
			return;
		end
	else
		cclog("[Error]没有选择装备!@KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:initAttr")
		return;
	end
	
	local tbMaterials = self.m_Factory:GetMaterialsIndex();
	--test
	print("升星材料 ... ")
	local tbMaterialsNum = self.m_Factory:GetMaterialsNums();
	for k, v in pairs(tbMaterialsNum) do
		cclog("[Log]材料ID(%d) = 数量(%d)", k, v)
	end
	for k, v in pairs(tbMaterials) do
		cclog("[Log]索引(%d) = 材料ID(%d)", k, v)
	end
	-- test end
	-- 发送服务器请求升星
	local tbArg = {}
	tbArg.uuid = me:GetAccount();
	tbArg.area = 1;
	tbArg.equipId = self.m_equipSelected:GetIndex();
	tbArg.id1 = tbMaterials[1] or 0;
	tbArg.id2 = tbMaterials[2] or 0;
	tbArg.id3 = tbMaterials[3] or 0;
	tbArg.id4 = tbMaterials[4] or 0;
	tbArg.id5 = tbMaterials[5] or 0;
	KGC_EQUIP_LOGIC_TYPE:getInstance():ReqEquicpStar(tbArg);
end

--@function: 点击添加材料按钮
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:TouchAddMaterial(widget, pnlMaterial)
	-- 当前位置已经有材料
	local bIsAdded, nItemIndex = self.m_Factory:IsAdded(widget.m_nIndex);
	cclog("[Log]点击添加材料按钮, 第(%d)个, 对应的材料索引为(%d)", widget.m_nIndex, nItemIndex)
	if bIsAdded then
		self.m_Factory:SubMaterial(widget.m_nIndex, nItemIndex)
		self:UpdateAMaterial(widget, 0)
	elseif self.m_Factory:IsRateUp() then
		TipsViewLogic:getInstance():addMessageTips(11002);
	else
		self.m_btnAddMaterial = widget;
		self:InitMaterialsWindow(pnlMaterial, widget)
	end
end


--@function: 每次打开材料面板的初始化
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:InitMaterialsWindow(pnlMaterial, widget)
	pnlMaterial:setVisible(true);
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			pnlMaterial:setVisible(false);
		end
	end
	local btnClose = pnlMaterial:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	local svMaterials = pnlMaterial:getChildByName("sv_materials")
	local tbBagMaterialsNum = self.m_Factory:GetMateriasNumInBag();
	
	local fnConfirm = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 添加材料的按钮
			local btnAdd = self.m_btnAddMaterial;		
			-- 已经添加的材料数量
			local tbMaterialsCount = self.m_Factory:GetMaterialsNums();
			pnlMaterial:setVisible(false);
			-- id, GetID(), GetIndex()
			local nIndex = self.m_tbBtn2EquipID[sender]
			local nNumInBag = tbBagMaterialsNum[nIndex] or 0
			local nNum = self.m_Factory:GetLeftMaterials(nIndex);
			if nNum > 0 then
				self.m_Factory:AddMaterial(btnAdd.m_nIndex, nIndex)
				--更新材料
				if btnAdd then
					self:UpdateAMaterial(btnAdd, nIndex);
				end
			end
		end
	end
	
	local tbMaterialsCount = self.m_Factory:GetMaterialsNums();
	-- notify: 注意这里是ipairs, 显示从一阶强化石到五阶强化石
	for i, id in ipairs(self.m_tbMaterialsID) do
		local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(id)
		local itemTemp = me:GetBag():GetItemByID(id)
		local nIndex = 0;
		if itemTemp then
			item = itemTemp;
			nIndex = item:GetIndex();
		end
		local szName = "btn_material_" .. i;
		local button = svMaterials:getChildByName(szName)
		local imgMaterialBg = button:getChildByName("img_materialbg")
		local imgIcon = imgMaterialBg:getChildByName("img_icon")
		-- local bmlNum = imgMaterialBg:getChildByName("bml_num")
		local textNum = imgMaterialBg:getChildByName("text_itemnumber")
		button:addTouchEventListener(fnConfirm)
		
		local imgBg = button:getChildByName("img_bg")
		local lblName = imgBg:getChildByName("lbl_name")		-- 材料名字
		local lblRate = imgBg:getChildByName("lbl_rate")		-- 材料成功概率
		lblName:setString(item:GetName())
		local nRate = self.m_Factory:GetRateByArg(self.m_equipSelected:GetStars(), item:GetLevel());
		lblRate:setString("(成功率+" .. nRate .. "%)");
		
		--test
		local nNumInBag = tbBagMaterialsNum[nIndex] or 0
		local nNum1 = nNumInBag - (tbMaterialsCount[nIndex] or 0)
		--test end
		local nNum = self.m_Factory:GetLeftMaterials(nIndex);
		print("[Log]测试剩余材料数量", nNumInBag, tbMaterialsCount[nIndex], nNum1, nNum)
		imgMaterialBg:loadTexture(item:GetQualityIcon())
		imgIcon:loadTexture(item:GetIcon())
		textNum:setString(nNum)
		-- 遮罩
		local pnlCover = button:getChildByName("pnl_cover")
		if nNum <= 0 then
			pnlCover:setVisible(true);
		else
			pnlCover:setVisible(false);
		end
		
		self.m_tbBtn2EquipID[button] = nIndex;
	end
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdateAMaterial(btnAdd, nIndex)
	local nIndex = nIndex or 0;
	if not btnAdd then
		return;
	end
	local item = me:GetBag():GetItemByIndex(nIndex)
	local imgIcon = btnAdd:getChildByName("img_icon")
	local imgSelected = btnAdd:getChildByName("img_select")
	if item then
		imgIcon:setVisible(true);
		imgIcon:loadTexture(item:GetIcon());
		imgSelected:setVisible(false);
		local szIcon = item:GetQualityIcon();
		btnAdd:loadTextures(szIcon, szIcon)
	else
		imgIcon:setVisible(false);
		imgSelected:setVisible(true);
		btnAdd:loadTextures(CUI_PATH_ITEM_QUALITY_0, CUI_PATH_ITEM_QUALITY_0)
	end
	self:UpdateRate();
end

--@function: 一键放入
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:AutoSelectMaterials()
	local tbItems = self.m_Factory:AutoSelectMaterials();
	self:UpdateMaterials(tbItems);
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdateMaterials(tbItems, tbButtons)
	-- table.sort(self.m_tbBtnAdd);
	local tbButtons = tbButtons or self.m_tbBtnAdd
	local tbMaterials = self.m_Factory:GetMaterialsIndex();
	for k, v in pairs(tbButtons) do
		local button = tbButtons[k];
		local imgIcon = button:getChildByName("img_icon");
		local imgSelected = button:getChildByName("img_select")
		imgIcon:setVisible(true);
		local nIndex = tbMaterials[k];
		if nIndex and nIndex ~= 0 and tbItems then
			local item = tbItems[nIndex]
			if item then
				imgIcon:loadTexture(item:GetIcon())
				imgSelected:setVisible(false);
				
				local szIcon = item:GetQualityIcon();
				button:loadTextures(szIcon, szIcon)
			end
		else
			imgIcon:setVisible(false)
			imgSelected:setVisible(true);
			button:loadTextures(CUI_PATH_ITEM_QUALITY_0, CUI_PATH_ITEM_QUALITY_0)
		end
	end
	self:UpdateRate();
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdateRate()
	local nBase, nRate = self.m_Factory:GetStarRate();
	local nTotal = nBase + nRate;
	local szString = nTotal .. "%+";
	self.m_tfRate:setString(szString)
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:StarResult(nIndex, nStar)
	local nLayerID = self.m_pParent:GetLayerID();		-- for 特效
	local nStarNew = nStar or 0;
	local nStarOld = self.m_equipSelected:GetStars();
	local _, nOldNum = self.m_equipSelected:GetBaseAttribute();
	cclog("[Log]当前星级(%d)<-->升星之后的星级(%d)", nStarOld, nStarNew)
	
	--更新数据内容
	self.m_equipSelected:SetStar(nStarNew);
	
	-- 删除道具
	self.m_Factory:DeleteMaterials();
	
	local fnCallBack = function()
		if nStarOld < nStarNew then
			-- self.m_layoutStarRetsult:setVisible(true)
			if self.m_pnlStarResult then
				self.m_pnlStarResult:setVisible(true);
				local lblAttrBefore = self.m_pnlStarResult:getChildByName("text_basicdata")
				local lblAttrAfter = self.m_pnlStarResult:getChildByName("text_upgradedata")
				local nType, nNum = self.m_equipSelected:GetBaseAttribute();
				local szStringBefore = l_tbAttrTypeName[nType] .. ": +" .. nOldNum
				local szStringAfter = l_tbAttrTypeName[nType] .. ": +" .. nNum
				lblAttrBefore:setString(szStringBefore);
				lblAttrAfter:setString(szStringAfter)
				
				local call = function()
					self.m_pnlStarResult:setVisible(false);
				end
				local action = cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(call))
				self.m_pnlStarResult:runAction(action)
			end
		else
			TipsViewLogic:getInstance():addMessageTips(11001);
		end
		
		self.m_Factory:ClearData()
		self:UpdateMaterials();
		self:UpdateStars(self.m_svStars, self.m_equipSelected:GetStars());
		-- 淬炼界面升星也要更新
		self:UpdateStars(self.m_svStarsPick, self.m_equipSelected:GetStars());
		
		self.m_pnlStarCover:setVisible(false);
	end
	
	self.m_pnlStarCover:setVisible(true);
	local btnEquip = self.m_svStars:getParent();
	local effect = af_BindEffect2Node(btnEquip, 50004, {{0.5, 0.5}}, 5, fnCallBack, {3, 0, nLayerID})
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdateStars(svStars, nStar)
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_star_" .. i
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
-------------------------------------------------------------------
--淬炼
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:EquipPickAttr()
	local nSelEquipIndex = self.m_Factory:GetSplitEquip()
	if not nSelEquipIndex or nSelEquipIndex == 0 then
		TipsViewLogic:getInstance():addMessageTips(11004);
		return;
	end
	
	local nSelAttr = self.m_Factory:GetSelectedAttribute();
	print("选择的属性：", nSelAttr)
	if not nSelAttr or nSelAttr <= 0 then
		TipsViewLogic:getInstance():addMessageTips(11005);
		return;
	end
	
	local fnCallBack = function(bRet)
		print("[Log]消息框结果：", bRet)
		if bRet then
			local nIndex1 = self.m_equipSelected:GetIndex();
			local nIndex2 = self.m_Factory:GetSplitEquip();
			local nAttrIndex = self.m_Factory:GetSelectedAttribute();
			KGC_EQUIP_LOGIC_TYPE:getInstance():reqAttrPick(nIndex1, nIndex2, nAttrIndex);
		end
	end
	TipsViewLogic:getInstance():addMessaBox(11007, fnCallBack, self);
	
end

--@function: 选择需要被淬炼的道具
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:AddEquip(widget)
	local fnCallBack = function(equip)
		print("[Test]选择道具为：", equip:GetName())
		-- 不能选择相同的道具
		if equip == self.m_equipSelected then
			TipsViewLogic:getInstance():addMessageTips(11006);
			return;
		end
		self.m_equipIndex2 = equip:GetIndex();
		self.m_szIconEquip2 = equip:GetIcon();
		self.m_szNameEquip2 = equip:GetName();
		self.m_szQualityEquip2 = equip:GetQualityIcon();
		self.m_tbAttrsEquip2 = equip:GetAttributes();
		local szQualityIcon = equip:GetQualityIcon();
		widget:loadTextures(szQualityIcon, szQualityIcon);
		
		local imgIcon = widget:getChildByName("img_icon")
		local imgNull = widget:getChildByName("img_pickequip")
		imgNull:setVisible(false);
		local lblName2 = widget:getChildByName("text_name")
		lblName2:setString(equip:GetName())
		
		if imgIcon then
			imgIcon:setVisible(true)
			imgIcon:loadTexture(self.m_szIconEquip2);
		end
		
		self.m_Factory:SetSplitEquip(self.m_equipIndex2)
		self:UpdateAttributes(2, self.m_equipIndex2);
		local svStars = widget:getChildByName("sv_stars")
		svStars:setVisible(true)
		self.m_nEquipStar2 = equip:GetStars()
		self:UpdateStars(svStars, self.m_nEquipStar2)
	end
	
	if self.m_equipIndex2 == 0 then
		-- 可以被淬炼的装备为绿色品质以上
		-- print("淬炼的装备品质最低为：", l_tbQualityType.Q_02)
		KGC_EQUIP_LOGIC_TYPE:getInstance():SetMinQuality(l_tbQualityType.Q_02)
		KGC_EQUIP_LOGIC_TYPE:getInstance():SetEquipType(0)
		self.m_chooseQuLayer = KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(1, self);
		self.m_chooseQuLayer:RegisterCallback(fnCallBack)
	else
		self.m_equipIndex2 = 0;
		widget:loadTextures(CUI_PATH_EQUIP_QUALITY_0, CUI_PATH_EQUIP_QUALITY_0);
		local imgIcon = widget:getChildByName("img_icon")
		local lblName = widget:getChildByName("text_name")
		local svStars = widget:getChildByName("sv_stars")
		if imgIcon then
			imgIcon:setVisible(false);
			lblName:setVisible(false);
			svStars:setVisible(false);
		end
		
		self.m_Factory:SetSplitEquip(self.m_equipIndex2)
		self:UpdateAttributes(2, self.m_equipIndex2);
	end
end

--@function: 更新属性面板
--@nDir: 1-左边; 2-右边
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdateAttributes(nDir, nIndex)
	local tbGroup = self.m_tbPnlAttributes[nDir]
	if tbGroup then
		local nIndex = nIndex or 0;
		if nIndex == 0 then
			for index, pnlAttr in pairs(tbGroup) do
				pnlAttr:setVisible(false);
			end
		else
			local equip = me:GetBag():GetItemByIndex(nIndex);
			local tbAttrs = equip:GetAttributes();
			print("[Log]更新装备属性面板：", nIndex, equip:GetName(), #tbAttrs)
			
			for index, pnlAttr in pairs(tbGroup) do
				local tbAttr = tbAttrs[index]
				
				local nID, nNum = unpack(tbAttr or {})	
				
				if nID and nID >= 0 then
					pnlAttr:setVisible(true);
					local szString = "空"
					if nID > 0 then
						szString = l_tbAttrTypeName[nID]
						if type(nNum) then
							szString = szString .. "+" .. nNum;
						end
					end
					local lblAttr = pnlAttr:getChildByName("lbl_attribute")
					lblAttr:setString(szString)
				else
					pnlAttr:setVisible(false);
				end
			end
		end
	end
end

--@function: 选择属性功能函数
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:SelectedAttribute(tbGroup, widget)
	local tbGroup = tbGroup or {}
	for index, button in pairs(tbGroup) do
		local imgSelected = button:getChildByName("img_selected")
		if button == widget then
			imgSelected:setVisible(true)
			self.m_Factory:SetSelectedAttribute(index)
			self.m_nSelAttr = index;
		else
			imgSelected:setVisible(false)
		end
	end
end

--@function: 淬炼结果
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:AttrPickResult(tbAttrs, tbItems)
	print("[Log]处理淬炼结果 ... ")
	local fnCallBack = function()
		self:UpdateAttributes(1, self.m_equipSelected:GetIndex())
		self:UpdateAttributes(2, 0)
		
		local imgIcon = self.m_btnEquip2:getChildByName("img_icon")
		local lblName = self.m_btnEquip2:getChildByName("text_name")
		if imgIcon then
			imgIcon:setVisible(false);
			lblName:setVisible(false);
		end
		local imgNull = self.m_btnEquip2:getChildByName("img_pickequip")
		imgNull:setVisible(true)
		
		self.m_equipIndex2 = 0;
		self.m_Factory:SetSplitEquip(self.m_equipIndex2)
		-- self.m_Factory:SetSelectedAttribute(0)
	end
	
	self:UpdatePickResult(tbAttrs, tbItems, fnCallBack)
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:LoadSchemeOfPickResult()
	self.m_pnlPickResult = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_REINFORCE_PICK_RESULT)
	self.m_pnlPickResult:setVisible(false);
	self.m_pLayout:addChild(self.m_pnlPickResult)
	
	local imgPRBg = self.m_pnlPickResult:getChildByName("img_selectitembg")
	local btnConfirm = imgPRBg:getChildByName("btn_confirm")
	btnConfirm:setVisible(false);
	local btnRecover = imgPRBg:getChildByName("btn_recover")
	btnRecover:setVisible(false);
	local btnClose = self.m_pnlPickResult:getChildByName("btn_close")
	btnClose:setVisible(false);
	local fnConfirm = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:PickRecoverConfirm(false);
		end
	end
	
	local fnRecover = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:PickRecoverConfirm(true);
			
		end
	end
	btnConfirm:addTouchEventListener(fnConfirm)
	btnClose:addTouchEventListener(fnConfirm);
	btnRecover:addTouchEventListener(fnRecover)
	
	-- 保存属性位置
	local pnlAttrBefore = imgPRBg:getChildByName("pnl_attribute_before")
	local svAttrs = pnlAttrBefore:getChildByName("sv_attrs")
	local textAttr1 = svAttrs:getChildByName("text_attr_1")
	local textAttr2 = svAttrs:getChildByName("text_attr_2")
	local nPosX1, nPosY1 = textAttr1:getPosition()
	local nPosX2, nPosY2 = textAttr2:getPosition()
	self.m_tbPosPickAttr1 = cc.p(nPosX1, nPosY1);
	self.m_tbPosPickAttr2 = cc.p(nPosX2, nPosY2);
end

--@function: 开始显示淬炼结果界面
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:UpdatePickResult(tbAttrs, tbItems, fnCallBack)
	local nLayerID = self.m_pParent:GetLayerID();		-- for 特效
	local pnlPickResult = self.m_pnlPickResult;
	pnlPickResult:setVisible(true);
	local btnClose = pnlPickResult:getChildByName("btn_close")
	btnClose:setVisible(false);

	-- 第一件装备显示
	local imgPRBg = pnlPickResult:getChildByName("img_selectitembg")
	local pnlPREquip1 = imgPRBg:getChildByName("pnl_equipinfo_1")
	local imgEquipBg1 = pnlPREquip1:getChildByName("img_equipbg")
	pnlPREquip1:setVisible(true);
	imgEquipBg1:setVisible(true);
	imgEquipBg1:loadTexture(self.m_equipSelected:GetQualityIcon());
	local svStars1 = imgEquipBg1:getChildByName("sv_stars_1")		-- 星级
	svStars1:setVisible(true);
	self:UpdateStars(svStars1, self.m_equipSelected:GetStars())
	local imgIconE1 = imgEquipBg1:getChildByName("img_icon")		-- 图标
	imgIconE1:setVisible(true);
	imgIconE1:loadTexture(self.m_equipSelected:GetIcon())
	local lblName1 = imgEquipBg1:getChildByName("lbl_name")			-- 名字
	lblName1:setString(self.m_equipSelected:GetName())
	--特效
	local effect1 = af_BindEffect2Node(imgEquipBg1, 60018, {{0.5, 0.5}}, 1, nil, {nil, nil, nLayerID})

	-- 第二件装备显示
	local imgEquipBg2 = pnlPREquip1:getChildByName("img_meltingequip")
	imgEquipBg2:setVisible(true)
	imgEquipBg2:loadTexture(self.m_szQualityEquip2);
	local imgIconE2 = imgEquipBg2:getChildByName("img_icon")		-- 图标
	imgIconE2:loadTexture(self.m_szIconEquip2)
	local lblName2 = imgEquipBg2:getChildByName("lbl_name")			-- 名字
	lblName2:setString(self.m_szNameEquip2)
	local svStars2 = imgEquipBg2:getChildByName("sv_stars_2")		-- 星级
	svStars2:setVisible(true);		
	self:UpdateStars(svStars2, self.m_nEquipStar2)
	--特效
	local effect2 = af_BindEffect2Node(imgEquipBg2, 60019, {{0.5, 0.5}}, 1, nil, {nil, nil, nLayerID})
	
	-- 两个按钮
	local btnConfirm = imgPRBg:getChildByName("btn_confirm")
	local btnRecover = imgPRBg:getChildByName("btn_recover")
	
	-- 特效播放完毕之后的界面
	local pnlPREquip2 = imgPRBg:getChildByName("pnl_equipinfo_2")
	pnlPREquip2:setVisible(false);
	
	--属性随机特效
	local pnlAttrBefore = imgPRBg:getChildByName("pnl_attribute_before")
	local pnlAttrAfter = imgPRBg:getChildByName("pnl_attribute_after")
	pnlAttrBefore:setVisible(true);
	pnlAttrAfter:setVisible(false);
	local delay = cc.DelayTime:create(15)
	local svAttrs = pnlAttrBefore:getChildByName("sv_attrs")
	local textAttr1 = svAttrs:getChildByName("text_attr_1")
	local textAttr2 = svAttrs:getChildByName("text_attr_2")
	if self.m_tbPosPickAttr1 and self.m_tbPosPickAttr2 then
		textAttr1:setPosition(self.m_tbPosPickAttr1)
		textAttr2:setPosition(self.m_tbPosPickAttr2)
	end
	
	--发光特效
	
	-- 奖励显示
	local imgMaterialBg = imgPRBg:getChildByName("img_materialbg")
	for i = 1, 4 do
		local szName = "img_material0" .. i;
		local imgMaterial = imgMaterialBg:getChildByName(szName)
		local imgIcon = imgMaterial:getChildByName("img_itemicon")
		local item = tbItems[i];
		if item then
			imgMaterial:setVisible(true);
			imgIcon:loadTexture(item:GetIcon())
			local bmlNum = imgMaterial:getChildByName("btm_itemnumber")
			bmlNum:setString(item:GetNum())
			local imgQuality = imgMaterial:getChildByName("img_materiallevelbg")
			imgQuality:loadTexture(item:GetQualityIcon())
		else
			imgMaterial:setVisible(false);
		end
	end
	
	local fnCall = function()
		pnlPREquip1:setVisible(false);
		-- 选择的道具的资源图
		pnlPREquip2:setVisible(true);
		-- 显示按钮
		btnConfirm:setVisible(true);
		btnRecover:setVisible(true);
		btnClose:setVisible(true);
		
		local imgEquipBg = pnlPREquip2:getChildByName("img_equipbg")
		imgEquipBg:loadTexture(self.m_equipSelected:GetQualityIcon())	-- 品质
		local imgIcon = imgEquipBg:getChildByName("img_icon")			-- 图标
		imgIcon:setVisible(true);
		imgIcon:loadTexture(self.m_equipSelected:GetIcon());
		local lblName = imgEquipBg:getChildByName("lbl_name")			-- 名字
		lblName:setString(self.m_equipSelected:GetName())
		local svStars = imgEquipBg:getChildByName("sv_stars")
		self:UpdateStars(svStars, self.m_equipSelected:GetStars())
		
		-- 新旧属性的显示
		pnlAttrBefore:setVisible(false);
		pnlAttrAfter:setVisible(true);
		local textAttrOld = pnlAttrAfter:getChildByName("text_addedattribute")
		local textAttrNew = pnlAttrAfter:getChildByName("text_oringnalattribute")
		local nID1, nNum1 = unpack(tbAttrs[1])
		local szAttrOld = tostring(l_tbAttrTypeName[nID1]) .. ": +" .. nNum1 
		textAttrOld:setString(szAttrOld)
		local nID2, nNum2 = unpack(tbAttrs[2])
		local szAttrNew = tostring(l_tbAttrTypeName[nID2]) .. ": +" .. nNum2
		textAttrNew:setString(szAttrNew)
		
		fnCallBack();
	end
	
	-- 随机完特效做完之后移动到中间
	local fnMoveTogether = function()
		-- 被淬炼装备(移动到中间->消失)
		local mb2 = cc.MoveBy:create(1, cc.p(-200, 0));
		local nPosX2, nPosY2 = imgEquipBg2:getPosition();
		local ac2 = cc.Sequence:create(mb2,
									cc.CallFunc:create(
										function()
											effect2:removeFromParent(true);
											imgEquipBg2:setVisible(false);
											imgEquipBg2:setPosition(cc.p(nPosX2, nPosY2))
										end
									));
		imgEquipBg2:runAction(ac2)
		-- 要淬炼的装备(移动到中间->爆炸特效->消失->回调)
		local mb1 = cc.MoveBy:create(1, cc.p(200, 0));
		local nPosX1, nPosY1 = imgEquipBg1:getPosition();
		local fnCallAtAll = function()
			imgEquipBg1:setVisible(false);
			imgEquipBg1:setPosition(cc.p(nPosX1, nPosY1))
			fnCall();
		end
		local ac1 = cc.Sequence:create(mb1,
									cc.CallFunc:create(
										function()
											effect1:removeFromParent(true);
											local effect3 = af_BindEffect2Node(imgEquipBg1, 60017, {{0.5, 0.5}}, 1, fnCallAtAll, {nil, nil, nLayerID})
										end
									));
		imgEquipBg1:runAction(ac1)
	end
	
	self:AttributesMove(textAttr1, textAttr2 , fnMoveTogether)
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:AttributesMove(wgt1, wgt2, fnCallBack)
	local nCount = 0;
	local nTime = 0;
	local nMaxCount = 7;
	local nMaxTime = 0.5;

	-- 淬炼的属性
	local tbNewAttrs = self.m_equipSelected:GetAttributes();
	local szNewAttr = self:ConstructAttr(tbNewAttrs[self.m_nSelAttr]) or "";
	
	-- 被淬炼装备的属性
	local tbStrings = {};
	local tbAttrs = self.m_tbAttrsEquip2;
	for _, tbAttr in pairs(tbAttrs) do
		local szString = self:ConstructAttr(tbAttr);
		if szString then
			table.insert(tbStrings, szString);
		end
	end
	local nMaxNums = #tbStrings;			
					
	local fnMove
	fnMove = function(wgt1, wgt2, fnCallBack)
		nCount = nCount + 1;
		-- 用指数函数实现变化
		local nAddTime = 2^(0.5/nMaxCount * nCount) - 1;
		if nAddTime > nMaxTime then
			nAddTime = nMaxTime;
		end
		nTime = nAddTime;
		print("动态时间为：", nTime, nAddTime)
		
		--设置属性字符串
		local szString1 = tbStrings[nCount%nMaxNums + 1]
		local szString2 = tbStrings[(nCount+1)%nMaxNums + 1]
		if nCount > nMaxCount then
			szString2 = szNewAttr;
		end
		-- print(111, szString1, szString2, nCount, nMaxNums, szNewAttr)
		wgt1:setString(szString1)
		wgt2:setString(szString2)
		
		local x, y = wgt2:getPosition();
		local fnMoveTop = function()
			wgt1:setPosition(cc.p(x, y))
			if nCount > nMaxCount then
				fnCallBack();
				return;
			end
			fnMove(wgt2, wgt1, fnCallBack)
		end
		local atMove1 = cc.MoveBy:create(nTime, cc.p(0, -80))
		wgt2:runAction(atMove1);
		local atMove2 = cc.MoveBy:create(nTime, cc.p(0, -80))
		local at = cc.Sequence:create(atMove2, cc.CallFunc:create(fnMoveTop))
		wgt1:runAction(at);
	end
	if nMaxNums <= 0 then
		fnCallBack();
	else
		fnMove(wgt1, wgt2, fnCallBack);
	end
end

--@function: 构建一个属性的字符串
function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:ConstructAttr(tbAttr)
	local szString = nil;
	local nID, nNum = unpack(tbAttr or {})		

	if nID and nID >= 0 then
		szString = "空"
		if nID > 0 then
			szString = l_tbAttrTypeName[nID]
			if type(nNum) == "number" then
				szString = szString .. "+" .. nNum;
			end
		end
	end
	return szString;
end

function KGC_UI_EQUIP_REINFORCE_LAYER_TYPE:PickRecoverConfirm(bRecover)
	self.m_pnlPickResult:setVisible(false);
	if bRecover then
		local nIndex = self.m_equipSelected:GetIndex();
		KGC_EQUIP_LOGIC_TYPE:getInstance():reqPickRecover(nIndex);
	else
		self.m_Factory:SetSelectedAttribute(0)
	end
end
