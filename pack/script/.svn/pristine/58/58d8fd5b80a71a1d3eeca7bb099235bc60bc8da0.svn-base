require("script/class/class_base_ui/class_base_sub_layer")

SkillInfoTips = class("SkillInfoTips",function()
    return KGC_UI_BASE_SUB_LAYER:create()
end)

SkillInfoTips.currentID = 0;

function SkillInfoTips:create(id)
    self  = SkillInfoTips:new()
    self.currentID = id
    self:initAttr()
    return self
end

function SkillInfoTips:ctor()
    self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/SkillTips.json")
    self:addChild(self.pWidget)
    --关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer()
        end
    end  
    local btn_close = self.pWidget  --关闭按钮
    btn_close:addTouchEventListener(fun_close)
end


function SkillInfoTips:initAttr()
	
end