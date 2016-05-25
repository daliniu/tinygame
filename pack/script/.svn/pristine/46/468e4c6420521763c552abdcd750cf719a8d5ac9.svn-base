require("script/ui/bulletview/bulletlayer");



BulletLogic = class("BulletLogic");

function BulletLogic:getInstance()
    if BulletLogic.m_pLogic == nil then
        BulletLogic.m_pLogic = BulletLogic:create()
    end
	
    return BulletLogic.m_pLogic
end

function BulletLogic:create()
    local _logic = BulletLogic.new()
    _logic:Init()
    return _logic
end

function BulletLogic:Init()
    
end

function BulletLogic:initLayer(parent)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer=BulletLayer:create();
    parent:addChild(self.m_pLayer);

end

--[[
	massageTab.type = nType;
	massageTab.name = szName;
	massageTab.msg = szMsg;
]]--
function BulletLogic:addMassage(massage)
	if self.m_pLayer ==nil then
    	return
    end
    
    self.m_pLayer:addMassage(massage);
end