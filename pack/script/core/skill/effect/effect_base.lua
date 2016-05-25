----------------------------------------------------------
-- file:	base.lua
-- Author:	page
-- Time:	2015/04/02
-- Desc:	效果 基类
----------------------------------------------------------
require "script/class/class_data_base"

--data struct
local TB_EFFECT_BASE_STRUCT = {
}

KGC_EFFECT_DATA_BASE_TYPE = class("KGC_EFFECT_DATA_BASE_TYPE", KGC_DATA_BASE_TYPE, TB_EFFECT_BASE_STRUCT)

function KGC_EFFECT_DATA_BASE_TYPE:ctor()
end

function KGC_EFFECT_DATA_BASE_TYPE:Init()

end

function KGC_EFFECT_DATA_BASE_TYPE:UpdateEffect()
	
	
	self:OnUpdateEffect();
end

function KGC_EFFECT_DATA_BASE_TYPE:OnUpdateEffect()
end