require("script/class/class_base_ui/class_base_layer")
require "script/cocos2dx/Opengl"
require "script/cocos2dx/OpenglConstants"

OpenView = class("OpenView",function()
	return KGC_UI_BASE_LAYER:create()
end)


local function gotoNextView(node,tab)
    OpenViewLogic:getInstance():closeLayer()

	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LOGIN)
	AnnouncementLogic:getInstance():openAnnouncementLayer();

	--test
	-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_AFK_STATISTICS);
	-- test end
end

function OpenView:create()
    local _layer= OpenView:new()
    return _layer
end

function OpenView:ctor()
   self:initAttr()
end

function OpenView:initAttr()

    self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/openview.json")
    self:addChild(self.pWidget)
    ccs.ActionManagerEx:getInstance():playActionByName("openview.json", "openview",cc.CallFunc:create(gotoNextView,{}))

    -- local _call  =   cc.CallFunc:create(gotoNextView,{})
    -- local _pAction  = cc.Sequence:create({cc.DelayTime:create(1.0),_call})
    -- self:runAction(_pAction);
end

function OpenView:initTest()
    
end






















