require("script/class/class_base_ui/class_base_layer")
FunctionChooseLayer = class("FunctionChooseLayer",function()
    return KGC_UI_BASE_LAYER:create()
end)


FunctionChooseLayer.iDireciton  =0 --方向

FunctionChooseLayer.pFunctionItem=nil


--创建
function FunctionChooseLayer:create()
	self = FunctionChooseLayer:new()
	return self
end

function FunctionChooseLayer:ctor()
    self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/FunctionChooseLayer.json")
    self:addChild(self.pWidget)
    
    self:initAttr()
end
--初始化界面信息
function FunctionChooseLayer:initAttr()
   
    --按钮响应事件
    local function fun_close(sender,eventType)         --关闭界面
        if eventType==ccui.TouchEventType.ended then
            FunctionChooseLogic:getInstance():closeLayer()
        end
    end 
    local btn_close= self.pWidget:getChildByName("Panel_close")  --关闭按钮
    btn_close:addTouchEventListener(fun_close)   
    self:initFunction()   --初始功能按钮
    	
end

--初始化英雄信息
function FunctionChooseLayer:initFunction()
	
    self.pFunctionItem=self.pWidget:getChildByName("panel_card"):getChildByName("ScrollView_function"):getChildByName("Panel_cardItem");
    if self.pFunctionItem~=nil then
        self.pFunctionItem:retain()
        self.pFunctionItem:removeFromParent()
    else
        return
    end
    --图标按钮点击事件
    local function fun_openView(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
        	--打开相应界面（暂时只开英雄界面）
            GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_HEROINFO,0);
        end
    end
   	--先创建5个，后面再根据策划心情和开启条件增减~
   	local _iNum = 5
    self.pWidget:getChildByName("panel_card"):getChildByName("ScrollView_function"):setInnerContainerSize(cc.size(_iNum*230,300))
    for i =0,_iNum-1,1 do
        local _panel=self.pFunctionItem:clone()   
        self.pWidget:getChildByName("panel_card"):getChildByName("ScrollView_function"):addChild(_panel);   
        _panel:setPositionX(_panel:getPositionX()+i*200)    
        _panel:setTag(i)
        _panel:addTouchEventListener(fun_openView)   
        --元素信息
        local _paneControl=_panel:getChildByName("Panel_control") 
        local _labName=_paneControl:getChildByName("lab_name")
        _labName:setString(i)   
        local _labInfo=_paneControl:getChildByName("lab_info")
        _labInfo:setString(i+1000)            
	end	
end
