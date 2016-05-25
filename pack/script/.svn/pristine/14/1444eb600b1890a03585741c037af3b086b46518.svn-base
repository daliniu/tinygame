require("script/class/class_base_ui/class_base_sub_layer")
local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local cjson = require "cjson.core"

GMLogic  =class("GMLogic")

GMLogic.pLogic = nil

local ADD_ITEM  = -1;
local ADD_ACITON = 1;
local ADD_TEAM_EXP = 2;
local ADD_GLOD= 5;
local ADD_DIAMOND = 6;

function GMLogic:getInstance()
	if GMLogic.pLogic == nil then 
		GMLogic.pLogic = GMLogic.new()
	end
	return GMLogic.pLogic;
end

function GMLogic:reqGM(num,itype)
    if itype == ADD_ITEM then 
        g_Core:send(2002,{["itemid"]=num});
    elseif itype == ADD_ACITON then 
        g_Core:send(2004,{["type"]=itype,["value"]=num});

    elseif itype == ADD_TEAM_EXP then 
         g_Core:send(2004,{["type"]=itype,["value"]=num});
    elseif itype == ADD_GLOD then 
         g_Core:send(2004,{["type"]=itype,["value"]=num});
    elseif itype == ADD_DIAMOND then 
         g_Core:send(2004,{["type"]=itype,["value"]=num});
    end

end

function GMLogic:rspGMItem(pDate)
	for k,v in pairs(cjson.decode(pDate.item)) do
        print(k,v)
        me:GetBag():AddItem(k, v);
    end

    --更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG)    
end

function GMLogic:rspGMBaseInfo(pDate)
    local itype  = pDate.type;
    local iValue = pDate.value

    if iValue == 0 then 
        return;
    end

    if itype == ADD_ACITON then 
        me:SetAP(iValue);
    elseif itype == ADD_TEAM_EXP then 
        
    elseif itype == ADD_GLOD then 
        me:SetGold(iValue);
    elseif itype == ADD_DIAMOND then 
        me:SetDiamond(iValue);
    end

    --更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
end



GMView = class("GMView",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function GMView:create()
	self = GMView.new();
	return self
end

function GMView:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/gmView.json")
    self:addChild(self.pWidget)


    local TextField_item = self.pWidget:getChildByName("TextField_item")
    local TextField_jingbi = self.pWidget:getChildByName("TextField_jingbi")
    local TextField_zuanshi = self.pWidget:getChildByName("TextField_zuanshi")
    local TextField_xingdongli = self.pWidget:getChildByName("TextField_xingdongli")
    local TextField_exp = self.pWidget:getChildByName("TextField_exp")    

	--关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:closeLayer();
        end
    end

    --道具
    local function fun_daoju(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local id = TextField_item:getStringValue();
            GMLogic:getInstance():reqGM(id,ADD_ITEM);
        end	-- body
    end

    --金币
    local function fun_jinbi(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local iNum = TextField_jingbi:getStringValue();
            GMLogic:getInstance():reqGM(iNum,ADD_GLOD);
        end
    end

    --钻石
    local function fun_zuanshi(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local iNum = TextField_zuanshi:getStringValue();
            GMLogic:getInstance():reqGM(iNum,ADD_DIAMOND);
        end
    end

    --行动力
     local function fun_xingdongli(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local iNum = TextField_xingdongli:getStringValue();
            GMLogic:getInstance():reqGM(iNum,ADD_ACITON);
        end
    end   

    --经验
    local function fun_exp(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local iNum = tonumber(TextField_exp:getStringValue());
            me:ReqAddExp(iNum);
            --更新界面信息
            GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)
        end
    end

    --关闭
    local btn_close = self.pWidget:getChildByName("btn_close");
    btn_close:addTouchEventListener(fun_close)


    --道具
    local btn_daoju = self.pWidget:getChildByName("btn_daoju")
    btn_daoju:addTouchEventListener(fun_daoju)

    --金币
    local btn_jinbi = self.pWidget:getChildByName("btn_jinbi")
    btn_jinbi:addTouchEventListener(fun_jinbi)

    --钻石
    local btn_zuanshi = self.pWidget:getChildByName("btn_zuanshi")
    btn_zuanshi:addTouchEventListener(fun_zuanshi)


    --行动力
    local btn_xingdongli = self.pWidget:getChildByName("btn_xingdongli")
    btn_xingdongli:addTouchEventListener(fun_xingdongli)


    --经验
    local btn_exp = self.pWidget:getChildByName("btn_exp")
    btn_exp:addTouchEventListener(fun_exp)


end