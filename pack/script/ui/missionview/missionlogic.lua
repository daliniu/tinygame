require("script/ui/missionview/missionlayer");


local MISSION_LOGIC_TB={
    currentIndex    =   1,
}

MissionLogic = class("MissionLogic", KGC_UI_BASE_LOGIC,MISSION_LOGIC_TB);

function MissionLogic:getInstance()
    if MissionLogic.m_pLogic == nil then
        MissionLogic.m_pLogic = MissionLogic:create()
        GameSceneManager:getInstance():insertLogic(MissionLogic.m_pLogic)
    end
	
    return MissionLogic.m_pLogic
end

function MissionLogic:create()
    local _logic = MissionLogic.new()
    _logic:Init()
    return _logic
end

function MissionLogic:Init()

end

function MissionLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = MisssionLayer:create();
    self.m_pLayer.id = id;
	self.m_pLayer.flag = true
    parent:addChild(self.m_pLayer)

end


function MissionLogic:closeLayer()
	if self.m_pLayer then
		local nID = self.m_pLayer.id
		self.m_pLayer:closeLayer();
		
		self.m_pLayer = nil;
	end
end

function MissionLogic:OnUpdateLayer(iType)
	if self.m_pLayer ==nil then 
		return;
	end

end
