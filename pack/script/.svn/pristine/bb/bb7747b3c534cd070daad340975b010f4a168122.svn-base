----------------------------------------------------------
-- file:	reinforcelayer.lua
-- Author:	page
-- Time:	2015/06/29 16:07
-- Desc:	强化入口界面
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/ui/herolistview/equipview/starandpickuplayer")
require("script/core/configmanager/configmanager");

local l_tbAttrType, l_tbAttrTypeName  = def_GetAttributeType();
local TB_STRUCT_EQUIP_VIEW = {
	m_pLayout = nil,
	
	m_pnlAttr = nil,
	----------------
	m_equipSelected = nil,				-- 当前选中的装备
}

KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE = class("KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_EQUIP_VIEW)

function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:OnExit()
    
end

---初始化
function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:initAttr()
	-- self.m_equipSelected = self.m_pParent:GetSelectedEquip();
	self.m_equipSelected = KGC_EQUIP_LOGIC_TYPE:getInstance():GetSelectedEquip();
	
	self:LoadScheme();
	
	self:UpdateData(self.m_equipSelected:GetIndex());
end

--@function: 获取当前选中的装备
function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:GetSelectedEquip()
	return self.m_equipSelected;
end

function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:SetSelectedEquip(equip)
	self.m_equipSelected = equip;
end

function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP)
	self:addChild(self.m_pLayout)
	
	local pnlEquip = self.m_pLayout:getChildByName("pnl_equip")
	-- 关闭按钮
	local fnClose = function(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(2);
		end
	end
	local btnClose = pnlEquip:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	-- 按钮
	local btnPick = pnlEquip:getChildByName("btn_pick")			-- 淬炼
	local btnStar = pnlEquip:getChildByName("btn_up")				-- 升星
	local btnChange = pnlEquip:getChildByName("btn_change")		-- 更换
	local fnTouch = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:TouchEvent(sender)
		end
	end
	btnPick:addTouchEventListener(fnTouch)
	btnStar:addTouchEventListener(fnTouch)
	btnChange:addTouchEventListener(fnTouch)
	
	-- 属性
	self.m_pnlAttr = pnlEquip:getChildByName("pnl_attribute");
end

function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:TouchEvent(widget)
	local name = widget:getName();
	-- 放到前面：Logic关闭掉当前界面获取不到parent了
	local pParent = self.m_pParent
	if name == "btn_change" then
		KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(1, pParent);
	elseif name == "btn_pick" then
		local layout = KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(4, pParent);
		layout:ChangePage(1)
		pParent.m_layoutReinforce = layout;
	elseif name == "btn_up" then
			local layout = KGC_EQUIP_LOGIC_TYPE:getInstance():initLayer(4, pParent);
			layout:ChangePage(2)
			pParent.m_layoutReinforce = layout;
	end
	
	KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(2);
end

--@function: 更新数据
function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:UpdateData(nEquipIndex)
	local equip = me:GetBag():GetItemByIndex(nEquipIndex);
	if not equip then
		return;
	end
	
	local pnlEquip = self.m_pLayout:getChildByName("pnl_equip")
	local imgBg = pnlEquip:getChildByName("img_icon_bg");
	local imgIcon = imgBg:getChildByName("img_icon");
	local lblName = pnlEquip:getChildByName("lbl_name");
	local atlFightPoint = pnlEquip:getChildByName("atl_fightpoint");
	
	imgBg:loadTexture(equip:GetQualityIcon());				-- 底框
	imgIcon:loadTexture(equip:GetIcon());					-- 图标
	lblName:setString(equip:GetName());						-- 名字
	atlFightPoint:setString(equip:GetFightPoint());			-- 战斗力
	
	-- 更新属性
	self:UpdateAttribute(equip);
end

--@function: 更新属性
function KGC_UI_EQUIP_REINFORCE_MAIN_LAYER_TYPE:UpdateAttribute(equip)
	-- 基础属性
	local lblBaseAttr = self.m_pnlAttr:getChildByName("lbl_basic")
	local nBaseAttrType, nBaseAttrNum = equip:GetBaseAttribute();
	local szAttrString = l_tbAttrTypeName[nBaseAttrType] .. ": +" .. nBaseAttrNum;
	lblBaseAttr:setString(szAttrString)
	
	-- 附加属性
	local tbAddAttrs = equip:GetAttributes()
	for i = 1, 4 do
		local szAttrName = "lbl_attr_" .. i
		local lblAttr = self.m_pnlAttr:getChildByName(szAttrName)
		local tbAttr = tbAddAttrs[i]
		local nID, nNum = unpack(tbAttr or {})	
			
		if nID and nID >= 0 then
			lblAttr:setVisible(true);
			local szString = "空"
			if nID > 0 then
				szString = l_tbAttrTypeName[nID]
				if type(nNum) then
					szString = szString .. ": +" .. nNum;
				end
			end
			lblAttr:setString(szString)
		else
			lblAttr:setVisible(false);
		end
	end
end
