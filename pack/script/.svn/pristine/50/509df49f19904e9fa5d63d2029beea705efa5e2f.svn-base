----------------------------------------------------------
-- file:	contractbiology.lua
-- Author:	page
-- Time:	2014/12/02
-- Desc:	契约生物
----------------------------------------------------------
require "script/core/npc/hero"
--------------------------------
--define @ 2015/01/27 17:35
-- 类定义和data名字用大写
-- 
--------------------------------
--data struct 
local TB_DATA_CONTRACT_BIOLOGY = {
	
}

KGC_CONTRACT_BIOLOGY_TYPE = class("KGC_CONTRACT_BIOLOGY_TYPE", KG_HERO_TYPE, TB_DATA_CONTRACT_BIOLOGY)

local tbNpcType = def_GetNpcType();
--------------------------------
--function
--------------------------------
function KGC_CONTRACT_BIOLOGY_TYPE:ctor()
	--设置类型
	self.m_nType = tbNpcType.CONTRACT;
end

--@function: 
function KGC_CONTRACT_BIOLOGY_TYPE:OnInit(tbArg)
	self:SetBloodShare(false)
end

function KGC_CONTRACT_BIOLOGY_TYPE:IsHero()
	return false;
end

--@function：是否是召唤物
function KGC_CONTRACT_BIOLOGY_TYPE:IsSummon()
	return true;
end

---------------------------------------------------------
--test
