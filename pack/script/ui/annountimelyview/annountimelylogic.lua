
--及时公告管理

require("script/ui/annountimelyview/annountimelylayer")

local ANNOUN_TIMELY_LOGIC={
	infoTab={}
}

AnnounTimelyLogic = class("AnnounTimelyLogic", KGC_UI_BASE_LOGIC,ANNOUN_TIMELY_LOGIC);

function AnnounTimelyLogic:getInstance()
    if AnnounTimelyLogic.m_pLogic == nil then
        AnnounTimelyLogic.m_pLogic = AnnounTimelyLogic:create()
        GameSceneManager:getInstance():insertLogic(AnnounTimelyLogic.m_pLogic)
    end
	
    return AnnounTimelyLogic.m_pLogic
end

function AnnounTimelyLogic:create()
    local _logic = AnnounTimelyLogic.new()
    _logic:Init()
    return _logic
end

function AnnounTimelyLogic:Init()
    
end


function AnnounTimelyLogic:initLayer(parent)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = AnnounTimelyLayer:create();
    parent:addChild(self.m_pLayer)

end

function AnnounTimelyLogic:addInfo(info)
	if self.m_pLayer ==nil then
    	return
    end

   table.insert(self.infoTab,info);
   self.m_pLayer:addInfo()

end

function AnnounTimelyLogic:getInfo()
	local bRet =nil
	for k,v in pairs(self.infoTab) do
		bRet =  v;
		table.remove(self.infoTab,k)
		return bRet;
	end

	return nil
end