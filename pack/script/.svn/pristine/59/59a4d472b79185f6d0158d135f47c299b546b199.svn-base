require("script/ui/networkview/NetworkView")
require("script/class/class_base_ui/class_base_logic")

NetworkLogic=class("NetworkLogic",function()
    return KGC_UI_BASE_LOGIC:create()
end)

NetworkLogic.m_pLogic    =nil
NetworkLogic.m_pLayer    =nil

NetworkLogic.test01=1

function NetworkLogic:getInstance()
	if NetworkLogic.m_pLogic==nil then
        NetworkLogic.m_pLogic=NetworkLogic:create()
		GameSceneManager:getInstance():insertLogic(NetworkLogic.m_pLogic)
	end
	return NetworkLogic.m_pLogic
end

function NetworkLogic:create()
    local _logic = NetworkLogic:new()
    return _logic
end

function NetworkLogic:initLayer(parent,id)
	print("NetworkLogic:initLayer")
    if self.m_pLayer ~=nil then
    	return
    end

    self.m_pLayer=KG_UINetwork.new()
	self.m_pLayer:init();

    self.m_pLayer.id=id
    parent:addChild(self.m_pLayer)

    return self.m_pLayer
end

function NetworkLogic:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function NetworkLogic:sendingNetwork()
	if not DEBUG_CLOSED_NETWORK then
		self.m_pLayer:sending()
	end
end

function NetworkLogic:connectingNetwork()
	if not DEBUG_CLOSED_NETWORK then
		self.m_pLayer:connecting()
	end
end

function NetworkLogic:disconnectNetwork()
	if not DEBUG_CLOSED_NETWORK then
		self.m_pLayer:disconnect()
	end
end

function NetworkLogic:kickNetwork()
	if not DEBUG_CLOSED_NETWORK then
		self.m_pLayer:kick()
	end
end

function NetworkLogic:connectedNetwork()
	if not DEBUG_CLOSED_NETWORK then
    self.m_pLayer:connected()
	end
end

function NetworkLogic:updateLayer(iType)

end
