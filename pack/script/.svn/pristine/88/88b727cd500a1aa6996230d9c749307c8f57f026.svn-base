require("script/class/class_base_ui/class_base_logic")
require("script/ui/functionchooseview/FunctionChooseLayer")

FunctionChooseLogic = class("FunctionChooseLogic",function()
    return KGC_UI_BASE_LOGIC:create()
end)


FunctionChooseLogic.currentHeroID=0
FunctionChooseLogic.pLayer=nil
FunctionChooseLogic.pLogic=nil

function FunctionChooseLogic:getInstance()
    if FunctionChooseLogic.pLogic==nil then
    	FunctionChooseLogic.pLogic=FunctionChooseLogic:new()
    end
    return FunctionChooseLogic.pLogic
end

function FunctionChooseLogic:initLayer(parent,id)
    -- if self.pLayer~=nil then
    -- 	return
    -- end
    self.pLayer=FunctionChooseLayer:create()
    self.pLayer.id=id;
    parent:addChild(self.pLayer)
end

function FunctionChooseLogic:closeLayer()
	if self.pLayer then
		GameSceneManager:getInstance():removeLayer(self.pLayer.id);
		self.pLayer=nil
	end
end

function FunctionChooseLogic:updateLayer(iType)

end

function FunctionChooseLogic:updateTips(iType)

end
