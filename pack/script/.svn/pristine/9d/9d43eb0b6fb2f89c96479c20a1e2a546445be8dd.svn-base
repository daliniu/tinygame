require("script/class/class_base_ui/class_base_layer")
require("script/ui/missionview/missionlayerletter");
require("script/ui/missionview/missionlayermission");

local MISSION_LAYER_TB={
    missionLayer    =   nil,
    letterLayer     =   nil,
}


--1 --第一个界面
--2 --第二个界面

local LAYER_ID_01 =1;
local LAYER_ID_02 =2;

MisssionLayer = class("MisssionLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end,MISSION_LAYER_TB)

function MisssionLayer:create()
	self = MisssionLayer.new();
    self:initAttr();
	return self;
end

function MisssionLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/missionLayer.json")
    self:addChild(self.pWidget)

    self.pLogic = MissionLogic:getInstance();

    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self.pLogic:closeLayer();
        end
    end

    local btn_close = self.pWidget:getChildByName("btn_close")
    btn_close:addTouchEventListener(fun_close)
    
    
    self:initAttr();
end

function MisssionLayer:OnExit()

end


function MisssionLayer:initAttr()

    local function fun_table(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local index =sender.index;
            self:fun_changeTab(index);
        end
    end


    local img_mission = self.pWidget:getChildByName("img_mission");
    img_mission.index=LAYER_ID_01;
    img_mission:addTouchEventListener(fun_table)


    local img_letter = self.pWidget:getChildByName("img_letter");
    img_letter.index=LAYER_ID_02;
    img_letter:addTouchEventListener(fun_table)


    self:changeTab(self.pLogic.currentIndex);
end


function MisssionLayer:fun_changeTab(index)
    if self.pLogic.currentIndex == index then 
        return;
    end

    self:changeTab(index);

end

function MisssionLayer:changeTab(index)
    self.pLogic.currentIndex = index;



    --界面

    if self.letterLayer~=nil then 
        self.letterLayer:setScale(0.001);
        self.letterLayer:setVisible(false);
    end

    if self.missionLayer ~=nil then 
        self.missionLayer:setScale(0.001);
        self.missionLayer:setVisible(false);          
    end

    if index == LAYER_ID_01 then
        if self.missionLayer ==nil then 
            self.missionLayer = MissionLayerMission:create();
            self:addChild(self.missionLayer);
        else
            self.missionLayer:setScale(1);
            self.missionLayer:setVisible(true);          
        end

    elseif index == LAYER_ID_02 then 
        if self.letterLayer ==nil then 
            self.letterLayer = MissionLayerLetter:create();
            self:addChild(self.letterLayer);
        else
            self.letterLayer:setScale(1);
            self.letterLayer:setVisible(true);          
        end

    end

end

