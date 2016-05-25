require("script/ui/openview/OpenView")
require("script/class/class_base_ui/class_base_logic")

OpenViewLogic=class("OpenViewLogic",function()
    return KGC_UI_BASE_LOGIC:create()
end)

TB_OPEN_VIEW_LOGIC ={
    pLogic    =nil,
    pLayer    =nil,
}


function OpenViewLogic:getInstance()
	if self.pLogic==nil then
        self.pLogic=OpenViewLogic:create()
		GameSceneManager:getInstance():insertLogic(self.pLogic)
	end
	return OpenViewLogic.pLogic
end

function OpenViewLogic:create()
    local _logic = OpenViewLogic:new()
    _logic:initAttr()
    return _logic
end

function OpenViewLogic:initAttr()
    -- body
    local tbTemp = gf_CopyTable(TB_OPEN_VIEW_LOGIC)
    for k, v in pairs(tbTemp) do
        self[k] = v;
    end
end

function OpenViewLogic:initLayer(parent,id)
    if self.pLayer ~=nil then
    	return
    end
    self.pLayer=OpenView:create()
    self.pLayer.id=id
    parent:addChild(self.pLayer)
end

function OpenViewLogic:closeLayer()
	if self.pLayer then
		GameSceneManager:getInstance():removeLayer(self.pLayer.id);
		self.pLayer=nil
	end
end

function OpenViewLogic:updateLayer(iType)

end
