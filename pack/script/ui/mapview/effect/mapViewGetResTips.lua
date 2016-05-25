--获取资源特效提示

--[[
    local bRwardList={
        gold=nGold,
        exp = nExp,
        expTeam = nExpTeam,
        ap = nAP;
        item = tbObjs;
    }
]]--
require("script/core/configmanager/configmanager");

local signFile  =   mconfig.loadConfig("script/cfg/map/sign");
local itemFile  =   mconfig.loadConfig("script/cfg/pick/item");

MapViewGetResTips = class("MapViewGetResTips",function()
	return cc.Node:create()
end)

local TB_MAP_VIEW_GET_RES_TIPS ={
	id=nil,
	spDisplay = nil,
}

function MapViewGetResTips:create(bRwardList)
	self = MapViewGetResTips:new()
	self.bRwardList = bRwardList
	self:initAttr()
	return self
end

function MapViewGetResTips:ctor()
	-- body
end

function MapViewGetResTips:initAttr()

    local iTextSize = 25;
    local iIndex = 0;
    local fSpace = 25;
    if self.bRwardList.gold~=nil and self.bRwardList.gold~=0 then
        local resNum= ccui.Text:create()
        resNum:setPositionY(fSpace*iIndex);
        self:addChild(resNum)
        resNum:setFontSize(iTextSize)
        resNum:setString("金币+"..self.bRwardList.gold)
        iIndex=iIndex+1;
    end
  
    if self.bRwardList.exp~=nil and self.bRwardList.exp~=0 then
        local resNum= ccui.Text:create()
        resNum:setPositionY(fSpace*iIndex);
        self:addChild(resNum)
        resNum:setFontSize(iTextSize)

        resNum:setString("经验+"..self.bRwardList.exp)
         iIndex=iIndex+1;
    end

    if self.bRwardList.expTeam~=nil and self.bRwardList.expTeam~=0 then
        local resNum= ccui.Text:create()
        resNum:setPositionY(fSpace*iIndex);
        self:addChild(resNum)
        resNum:setFontSize(iTextSize)

        resNum:setString("团队经验+"..self.bRwardList.expTeam)
         iIndex=iIndex+1;
    end

    if self.bRwardList.ap~=nil and self.bRwardList.ap~=0 then
        local resNum= ccui.Text:create()
        resNum:setPositionY(fSpace*iIndex);
        self:addChild(resNum)
        resNum:setFontSize(iTextSize)

        resNum:setString("行动力+"..self.bRwardList.ap)
         iIndex=iIndex+1;
    end

     if type(self.bRwardList.item)=="table" then
        for k,v in pairs(self.bRwardList.item) do
            local resNum= ccui.Text:create()
            resNum:setPositionY(fSpace*iIndex);
            self:addChild(resNum)
            resNum:setFontSize(iTextSize)
            local sName = itemFile[v[1]].itemName
            resNum:setString(sName.."+"..v[2])
            iIndex=iIndex+1;
        end
    end

    if self.bRwardList.nSign then 
        local fConfig = signFile[self.bRwardList.nSign]
        local resNum= ccui.Text:create()
        resNum:setPositionY(fSpace*iIndex);
        self:addChild(resNum)
        resNum:setFontSize(iTextSize)

        resNum:setString(fConfig.Name.."+"..1)
        iIndex=iIndex+1;
    end


    self:runAction(cc.Sequence:create(
                                cc.MoveBy:create(2.5,cc.p(0,50)),
                                cc.RemoveSelf:create())) 
    
end

--buffer特效
-----------------------------------------------------------------------
MapViewGetBufferTips = class("MapViewGetBufferTips",function()
    return cc.Node:create()
end,TB_MAP_VIEW_GET_BUFFER_TIPS)

local TB_MAP_VIEW_GET_BUFFER_TIPS={
    id = nil,
    spDisplay = nil,    
}

function MapViewGetBufferTips:create(id)
    self = MapViewGetBufferTips:new()
    self.id = id
    self:initAttr()
    return self
end

function MapViewGetBufferTips:ctor()
    -- body
end

function MapViewGetBufferTips:initAttr()
    self.spDisplay = cc.Sprite:create("res/image/view/mapView/buffer/buffer01.png")
    self:addChild(self.spDisplay)

    self:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
                                    cc.RemoveSelf:create()))
end


--购买物品特效
------------------------------------------------------------------------
MapViewBuyItemEffect = class("MapViewBuyItemEffect",function()
    return cc.Node:create()
end,TB_MAP_VIEW_BUY_ITEM_EFFECT)

local TB_MAP_VIEW_BUY_ITEM_EFFECT={
    id = nil,
    num =num,
}

function MapViewBuyItemEffect:create(id,num)
    self = MapViewBuyItemEffect:new()
    self.id = id
    self.num = num
    self:initAttr()
    return self
end

function MapViewBuyItemEffect:ctor()
    -- body
end

function MapViewBuyItemEffect:initAttr()
    local resNum= ccui.Text:create()
    self:addChild(resNum)
    resNum:setFontSize(25)
    self:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
                                    cc.RemoveSelf:create()))

    local _file = mconfig.loadConfig("script/cfg/pick/item")
    local pItemConfig = _file[self.id]

    if pItemConfig~=nil then
        local pString =pItemConfig.itemName.."*"..self.num
        resNum:setString(pString)
    end

end

-------------------------------------------------------------------------
--补给特效
MapViewSupplyEffect = class("MapViewSupplyEffect",function()
    return cc.Node:create()
end,TB_MAP_VIEW_SUPPLY_EFFECT)

local TB_MAP_VIEW_SUPPLY_EFFECT ={
    num,
}

function MapViewSupplyEffect:create(num)
    self = MapViewSupplyEffect.new()
    self.num = num
    self:initAttr()
    return self
end

function MapViewSupplyEffect:ctor()
    -- body
end

function MapViewSupplyEffect:initAttr()
    local resNum= ccui.Text:create()
    self:addChild(resNum)
    resNum:setFontSize(25)
    self:runAction(cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(0,100)),
                                    cc.RemoveSelf:create()))
    resNum:setString("补给："..self.num)
end