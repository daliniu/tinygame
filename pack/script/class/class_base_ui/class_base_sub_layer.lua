require("script/class/class_base_ui/class_base_layer")

local TB_STRUCT_UI_BASE_SUB_LAYER = {
	m_pParent = nil;
}

KGC_UI_BASE_SUB_LAYER = class("KGC_UI_BASE_SUB_LAYER",KGC_UI_BASE_LAYER, TB_STRUCT_UI_BASE_SUB_LAYER)

function KGC_UI_BASE_SUB_LAYER:create(parent, tbArg)
    local layer = self.new()
    if parent then
		-- parent:addChild(layer);
		parent:AddSubLayer(layer);
		layer.m_pParent = parent;
		layer:initAttr(tbArg);
	end
    return layer
end

function KGC_UI_BASE_SUB_LAYER:ctor()

end

function KGC_UI_BASE_SUB_LAYER:initAttr()

end

function KGC_UI_BASE_SUB_LAYER:closeLayer()
	local parent = self.m_pParent
	self:runAction(cc.RemoveSelf:create())
	if parent then 
		parent:CloseSubLayer(self);
	end
	
	self.m_pParent = nil;
end

--@function: 主界面更新通知二级界面更新
function KGC_UI_BASE_SUB_LAYER:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
end