----------------------------------------------------------
-- file:	equipsplitlayer.lua
-- Author:	page
-- Time:	2015/07/07 16:52
-- Desc:	装备拆分收益
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")

local TB_STRUCT_EQUIP_SPLIT_VIEW = {
	m_pLayout = nil;
	
}

KGC_UI_EQUIP_SPLIT_LAYER_TYPE = class("KGC_UI_EQUIP_SPLIT_LAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_EQUIP_SPLIT_VIEW)

function KGC_UI_EQUIP_SPLIT_LAYER_TYPE:OnExit()
    
end

function KGC_UI_EQUIP_SPLIT_LAYER_TYPE:ctor()
	self:initAttr();
end


---初始化
function KGC_UI_EQUIP_SPLIT_LAYER_TYPE:initAttr()
	self:LoadScheme();
end

function KGC_UI_EQUIP_SPLIT_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_EQUIP_SPLIT)
	self:addChild(self.m_pLayout)
	
	-- 点击任意位置关闭按钮
	local fnClose = function(sender,eventType)
		KGC_EQUIP_LOGIC_TYPE:getInstance():closeLayer(3);
	end
	self.m_pLayout:addTouchEventListener(fnClose)
	
	self.m_pnlInfo = self.m_pLayout:getChildByName("pnl_info")
end

function KGC_UI_EQUIP_SPLIT_LAYER_TYPE:UpdateData(tbItems, nGold)
	for i, item in pairs(tbItems) do
		print(111, i, item:GetName())
	end
	
	local lblGold = self.m_pnlInfo:getChildByName("lbl_gold")
	lblGold:setString(nGold)
end
----------------------------------------------------------
--test
