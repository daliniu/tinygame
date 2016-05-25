----------------------------------------------------------
-- file:	changelayer.lua
-- Author:	page
-- Time:	2015/06/29 16:07
-- Desc:	更换装备界面
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
local l_tbEquipPos = def_GetPlayerEquipPos();
local l_tbAttrType, l_tbAttrTypeName  = def_GetAttributeType();
local l_tbQualityType = def_GetQualityType();
local l_tbItemTypeGenre, l_tbItemTypeDetail = def_GetItemType();

local TB_STRUCT_EQUIP_CHANGE_VIEW = {
	m_pLayout = nil;
	
	------------------------------
	--ui
	m_svEquips = nil,				-- 道具列表滑动层
	m_pnlEquipInfo = nil,			-- 滑动层一上的一个道具信息
	
	--data
	m_tbEquips = {					-- 一个控件对应的一个道具
		--[widget] = equip;
	},
	
	m_fnTouchCallBack = nil,		-- 点击面板道具的回调函数
	
	m_nMinQuality = 0,				-- 显示的最低品质
}

KGC_UI_EQUIP_CHANGE_LAYER_TYPE = class("KGC_UI_EQUIP_CHANGE_LAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_EQUIP_CHANGE_VIEW)

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:OnExit()
    
end

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:ctor()

end


---初始化
function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:initAttr()
	self:LoadScheme();
	
	local nQuality = KGC_EQUIP_LOGIC_TYPE:getInstance():GetMinQuality();
	self:SetMinQuality(nQuality);
	local equip, nType, nSuit = KGC_EQUIP_LOGIC_TYPE:getInstance():GetSelectedEquip();
	-- local nSlot = KGC_EQUIP_LOGIC_TYPE:getInstance():GetEquipChangeTempData();
	if equip and nType ~= 0 then
		nType = equip:GetTypeDetail();
	end
	print("[Log]当前要更换的位置为：", nType)
	self:UpdateEquips(nType);
end

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_CHANGE)
	self:addChild(self.m_pLayout)
	
	--关闭按钮
	local fnClose = function(sender,eventType)
		KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(1);
	end
	local btnClose = self.m_pLayout:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	--装备显示列表
	self.m_svEquips = self.m_pLayout:getChildByName("sv_equips")
	self.m_pnlEquipInfo = self.m_pLayout:getChildByName("pnl_equip_info")
	
end

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:UpdateEquips(nType)
	local MAX_NUM = 25;
	
	cclog("[Log]更换装备列表, 类型为：", tostring(nType))
	self.m_svEquips:removeAllChildren();
	self.m_tbEquips = {};
	print("[时间]....................5", os.clock())
	
	local tbItems = self:GetItemsByRule(nType);
	print("[时间]....................6", os.clock())
	-- print("UpdateEquips", #tbItems)
	local nCount = 1;
	local nSpaceBetweenH = 5
	local nNumPerRow = 2;
	local size = self.m_pnlEquipInfo:getContentSize();
	local sizeSV = self.m_svEquips:getInnerContainerSize();
	-- 计算宽度的间隙
	local nSpaceBetweenW = (sizeSV.width - nNumPerRow * size.width)/(nNumPerRow + 1)
	local nRowNum = math.floor((#tbItems + 1)/nNumPerRow)
	if nRowNum > MAX_NUM then
		nRowNum = MAX_NUM;
	end
	local nContainerSizeHeight = (size.height + nSpaceBetweenH) * nRowNum + 10;	--多留一点的空间
	print(111, "height: ", nContainerSizeHeight, sizeSV.height);
	if nContainerSizeHeight < sizeSV.height then
		nContainerSizeHeight = sizeSV.height;
	end
	self.m_svEquips:setInnerContainerSize(cc.size(sizeSV.width, nContainerSizeHeight))
	
	local fnChange = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:ItemTouchEvent(sender);
		end
	end
	local nStartTime = os.clock();
	print("[时间]打开更换界面", nStartTime, #tbItems)
	for _, item in pairs(tbItems) do
		-- 太卡了
		if nCount > MAX_NUM then
			break;
		end
		-- print("[时间]....................1", os.clock())
		local uiItem = self.m_pnlEquipInfo:clone();
		-- print("[时间]....................2", os.clock())
		uiItem:setVisible(true);
		uiItem:addTouchEventListener(fnChange)
		
		local imgBg = uiItem:getChildByName("img_equip_bg")
		imgBg:loadTexture(item:GetQualityIcon())
		local lblName = uiItem:getChildByName("lbl_name")
		local imgIcon = imgBg:getChildByName("img_icon")
		local imgFlag = uiItem:getChildByName("img_equip_ison")
		-- print("[时间]....................3", os.clock())
		imgIcon:loadTexture(item:GetIcon())
		lblName:setString(item:GetName())
		-- print("[时间]....................4", os.clock())
		imgFlag:setVisible(false)
		-- print("装备是否已经装备", item:GetName(), item:IsEquip())
		if item:IsEquip() then
			imgFlag:setVisible(true)
		end
		
		-- 装备星级
		local svStars = imgBg:getChildByName("sv_stars")
		local nStar = item:GetStars();
		if svStars and item then
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
		
		-- 属性
		local imgAttrBg = uiItem:getChildByName("img_bg")
		local textBaseAttr = imgAttrBg:getChildByName("text_majorattribute")
		local nBaseAttrType, nBaseAttrNum = item:GetBaseAttribute();
		-- print(111, item:GetName(), nBaseAttrType, nBaseAttrNum)
		local szAttrString = l_tbAttrTypeName[nBaseAttrType] .. ": +" .. nBaseAttrNum;
		textBaseAttr:setString(szAttrString)
		local tbAddAttrs = item:GetAttributes()
		for i = 1, 4 do
			local szAttrName = "text_attribute_" .. i
			local textAttr = imgAttrBg:getChildByName(szAttrName)
			local tbAttr = tbAddAttrs[i]
			local nID, nNum = unpack(tbAttr or {})	
				
			if nID and nID >= 0 then
				textAttr:setVisible(true);
				local szString = "空"
				if nID > 0 then
					szString = l_tbAttrTypeName[nID]
					if type(nNum) then
						szString = szString .. ": +" .. nNum;
					end
				end

				textAttr:setString(szString)
			else
				textAttr:setVisible(false);
			end
		end
		
		--位置摆放
		local nRow = math.floor((nCount+1)/nNumPerRow)
		local x = nSpaceBetweenW;
		if nCount % nNumPerRow == 0 then					-- 第二个的x位置
			x = x + (size.width + nSpaceBetweenW) * 1;
		end
		local nTop = nRow*(size.height + nSpaceBetweenH)	-- 当前行控件距离上方的距离
		local y = nContainerSizeHeight - nTop
		print("position", x, y);
		uiItem:setPosition(cc.p(x, y))
		self.m_svEquips:addChild(uiItem)
		self.m_tbEquips[uiItem] = item;
		
		if self.m_svEquips.firstEq == nil then 
			self.m_svEquips.firstEq = uiItem;
		end
		
		nCount = nCount + 1;
	end
	local nEndTime = os.clock();
	cclog("[时间]打开更换界面结束, 消耗时间：%f,结束时间: %f, 循环次数：%d", nEndTime - nStartTime, nEndTime, nCount)
	-- self.m_svEquips:scrollToBottom(0, false);
end

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:ItemTouchEvent(widget)
	local equip = self.m_tbEquips[widget]
	if self.m_fnTouchCallBack then
		self.m_fnTouchCallBack(equip);
	else	-- 默认是换装备的操作
		local equipOld, _, nSuit = KGC_EQUIP_LOGIC_TYPE:getInstance():GetSelectedEquip();
		if equipOld then
			nSuit = equipOld:GetSuit();
		end
		local nType = equip:GetTypeDetail();
		cclog("[Log]更换装备，部位(%d)，第几套(%s)", nType, tostring(nSuit))
		local tbData = {}
		-- tbData.uuid = me:GetAccount();
		tbData.area = 1;
		tbData.sign = 1;
		tbData.seq = nSuit;
		if nSuit > 0 then
			for i = 1, 6 do 
				local szKey = "id" .. i;
				if nType == i then
					tbData[szKey] = equip:GetIndex();
				else
					tbData[szKey] = 0;
				end
			end
			-- if not DEBUG_CLOSED_NETWORK then
				-- g_Core:send(7001, tbData);
			-- end
			KGC_EQUIP_LOGIC_TYPE:getInstance():ReqChangeEquicp(tbData);
		else
			TipsViewLogic:getInstance():addMessageTips(11008);
		end
	end
	
	-- 关闭当前界面
	KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(1);
end

function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:RegisterCallback(fnCallback)
	self.m_fnTouchCallBack = fnCallback
end

--@function: 根据规则获取需要显示的道具
function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:GetItemsByRule(nType)
	tbItems = {}
	if nType > 0 then
		tbItems = me:GetBag():GetItemsByDetail(nType)
	elseif nType == 0 then
		--全部装备
		tbItems = me:GetBag():GetItemsByGenre(l_tbItemTypeGenre.G_EQUIP)
	end
	
	local tbRet = {}
	local equip = KGC_EQUIP_LOGIC_TYPE:getInstance():GetSelectedEquip();
	local nSelectedIndex = 0
	if equip then
		nSelectedIndex = equip:GetIndex();
	end
	for _, item in pairs(tbItems) do
		-- 某品质之上，并且不显示装备本身
		print("GetItemsByRule:", item:GetName(), item:GetQuality(), self.m_nMinQuality, nSelectedIndex~= item:GetIndex());
		if item:GetQuality() >= self.m_nMinQuality and nSelectedIndex~= item:GetIndex() then
			table.insert(tbRet, item);
		end
	end
	return tbRet;
end

--@function: 设置显示最低品质
function KGC_UI_EQUIP_CHANGE_LAYER_TYPE:SetMinQuality(nQuality)
	-- print("KGC_UI_EQUIP_CHANGE_LAYER_TYPE 最低品质为：", nQuality, self.m_nMinQuality)
	self.m_nMinQuality = nQuality or 0;
end
----------------------------------------------------------
--test
