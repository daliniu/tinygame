
--公告管理

require("script/ui/announcementview/announcementlayer");


local ANNOUN_LOGIC_TB={
	annDateTab =nil		--公告数据..
}


AnnouncementLogic = class("AnnouncementLogic", KGC_UI_BASE_LOGIC,ANNOUN_LOGIC_TB);

function AnnouncementLogic:getInstance()
    if AnnouncementLogic.m_pLogic == nil then
        AnnouncementLogic.m_pLogic = AnnouncementLogic:create()
        GameSceneManager:getInstance():insertLogic(AnnouncementLogic.m_pLogic)
    end
	
    return AnnouncementLogic.m_pLogic
end

function AnnouncementLogic:create()
    local _logic = AnnouncementLogic.new()
    _logic:Init()
    return _logic
end

function AnnouncementLogic:Init()
    
end

function AnnouncementLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = AnnouncementLayer:create();
    self.m_pLayer.id = id;
    self.m_pLayer.flag = true
    parent:addChild(self.m_pLayer)

end

function AnnouncementLogic:openAnnouncementLayer()

    self.annDateTab = require("res/announ/announ")

    local announOldVer = cc.UserDefault:getInstance():getIntegerForKey("announ",0)
    if announOldVer ==nil then 
        return;
    end
    if self.annDateTab == nil then
        return;
    end

    if self.annDateTab.info ==nil or 
        #self.annDateTab.info == 0 then 
        return;
    end

    if announOldVer < self.annDateTab.version then
        cc.UserDefault:getInstance():setIntegerForKey("announ",self.annDateTab.version)
        cc.UserDefault:getInstance():flush()
    else
        return;
    end

    GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_ANNOUNCEMENT)
end



function AnnouncementLogic:closeLayer()
	if self.m_pLayer then
		local nID = self.m_pLayer.id
		self.m_pLayer:closeLayer();
		
		self.m_pLayer = nil;
	end
end

function AnnouncementLogic:OnUpdateLayer(iType)
	if self.m_pLayer ==nil then 
		return;
	end

end

function AnnouncementLogic:wirteFileDate()


end

function AnnouncementLogic:loadFileDate()


end
