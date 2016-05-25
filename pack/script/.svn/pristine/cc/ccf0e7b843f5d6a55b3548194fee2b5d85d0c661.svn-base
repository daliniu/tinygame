if not _SERVER then
require "script/cocos2dx/extern"

-- VisibleRectType = class("VisibleRectType")
-- VisibleRectType.__index = VisibleRectType
VisibleRectType = class()

VisibleRectType.s_VisibleRectType = cc.rect(0,0,0,0)

function VisibleRectType:lazyInit()
    if (self.s_VisibleRectType.width == 0.0 and self.s_VisibleRectType.height == 0.0) then
        --[[
        local pEGLView = cc.EGLView:getInstance()
        local origin   = pEGLView:getVisibleOrigin()
        ]]--
        self.s_VisibleRectType.x = 0
        self.s_VisibleRectType.y = 0
        local size  = cc.Director:getInstance():getWinSize()
        self.s_VisibleRectType.width  = size.width
        self.s_VisibleRectType.height = size.height
    end
end

function VisibleRectType:getVisibleRectType()
    self:lazyInit()
    return cc.rect(self.s_VisibleRectType.x, self.s_VisibleRectType.y, self.s_VisibleRectType.width, self.s_VisibleRectType.height)
end

function VisibleRectType:left()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x, self.s_VisibleRectType.y+self.s_VisibleRectType.height/2)
end

function VisibleRectType:right()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width, self.s_VisibleRectType.y+self.s_VisibleRectType.height/2)
end

function VisibleRectType:top()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width/2, self.s_VisibleRectType.y+self.s_VisibleRectType.height)
end

function VisibleRectType:bottom()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width/2, self.s_VisibleRectType.y)
end

function VisibleRectType:center()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width/2, self.s_VisibleRectType.y+self.s_VisibleRectType.height/2)
end

function VisibleRectType:leftTop()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x, self.s_VisibleRectType.y+self.s_VisibleRectType.height)
end

function VisibleRectType:rightTop()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width, self.s_VisibleRectType.y+self.s_VisibleRectType.height)
end

function VisibleRectType:leftBottom()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x,self.s_VisibleRectType.y)
end

function VisibleRectType:rightBottom()
    self:lazyInit()
    return cc.p(self.s_VisibleRectType.x+self.s_VisibleRectType.width, self.s_VisibleRectType.y)
end

VisibleRect = VisibleRectType.new()

end
--ui end