----------------------------------------------------------
-- file:	upgradelogic.lua
-- Author:	page
-- Time:	2015/08/08 加班中...
-- Desc:	升级面板逻辑管理类
----------------------------------------------------------
require("script/ui/upgradeview/upgradeview")
require("script/class/class_base_ui/class_base_logic")

local TB_STRUCT_UPGRADE_VIEW_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_UPGRADE_VIEW_LOGIC_TYPE=class("KGC_UPGRADE_VIEW_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_UPGRADE_VIEW_LOGIC)


function KGC_UPGRADE_VIEW_LOGIC_TYPE:getInstance()
	if not KGC_UPGRADE_VIEW_LOGIC_TYPE.m_pLogic then
        KGC_UPGRADE_VIEW_LOGIC_TYPE.m_pLogic = KGC_UPGRADE_VIEW_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_UPGRADE_VIEW_LOGIC_TYPE.m_pLogic)
	end
	return KGC_UPGRADE_VIEW_LOGIC_TYPE.m_pLogic
end

function KGC_UPGRADE_VIEW_LOGIC_TYPE:create()
    local _logic = KGC_UPGRADE_VIEW_LOGIC_TYPE.new()
    return _logic
end

function KGC_UPGRADE_VIEW_LOGIC_TYPE:initLayer(parent,id, tbArgs)

    if self.m_pLayer then
    	return;
    end
	
	local nAddLevel = tonumber(tbArgs);
    self.m_pLayer = KGC_UPGRADE_VIEW_TYPE.new()
	self.m_pLayer:Init(parent, nAddLevel);
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_UPGRADE_VIEW_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function KGC_UPGRADE_VIEW_LOGIC_TYPE:updateLayer(iType)

end