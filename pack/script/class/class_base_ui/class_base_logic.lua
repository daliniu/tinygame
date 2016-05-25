
--逻辑基类
local TB_STRUCT_UI_BASE_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_UI_BASE_LOGIC = class("KGC_UI_BASE_LOGIC", CLASS_BASE_TYPE, TB_STRUCT_UI_BASE_LOGIC)


function KGC_UI_BASE_LOGIC:create()
    return KGC_UI_BASE_LOGIC:new()
end

function KGC_UI_BASE_LOGIC:initLayer(parent,id)

end

function KGC_UI_BASE_LOGIC:closeLayer()

end

function KGC_UI_BASE_LOGIC:updateLayer(iType, tbArg)
	self:OnUpdateLayer(iType, tbArg)
end

function KGC_UI_BASE_LOGIC:updateTips(iType)

end

function KGC_UI_BASE_LOGIC:OnUpdateLayer(iType)

end

function KGC_UI_BASE_LOGIC:UpdateData(nID)

end

--@function: 退出初始化,自己类重载
function KGC_UI_BASE_LOGIC:OnUnInit()
end

--@function: 退出初始化
function KGC_UI_BASE_LOGIC:UnInit()
	local layer = self:GetLayer();
	if layer then
		GameSceneManager:getInstance():removeLayer(layer.id);
	end
	self:SetLayer(nil);
	
	self:OnUnInit();
	
	-- 最后置空
	self.m_pLogic = nil;
end

function KGC_UI_BASE_LOGIC:GetLayer()
	return self.m_pLayer;
end

function KGC_UI_BASE_LOGIC:SetLayer(layer)
	self.m_pLayer = layer;
end