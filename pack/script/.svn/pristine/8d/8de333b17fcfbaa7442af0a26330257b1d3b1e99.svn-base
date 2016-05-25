----------------------------------------------------------
-- file:	monster.lua
-- Author:	page
-- Time:	2015/07/27 17:01
-- Desc:	契约生物
----------------------------------------------------------
require "script/core/npc/npc"
require("script/core/configmanager/configmanager");
--------------------------------
--define @ 2015/01/27 17:35
-- 类定义和data名字用大写
-- 
--------------------------------
local l_tbMonsterConfig = mconfig.loadConfig("script/cfg/battle/monster");
--data struct 
local TB_STRUCT_MONSTER = {
	
}

KGC_MONSTER_TYPE = class("KGC_MONSTER_TYPE", KG_NPC_BASE_TYPE, TB_STRUCT_MONSTER)

local tbNpcType = def_GetNpcType();
--------------------------------
--function
--------------------------------
function KGC_MONSTER_TYPE:ctor()

end

function KGC_MONSTER_TYPE:GetConfigInfo(nID)
	return l_tbMonsterConfig[nID]
end

--@function: 
function KGC_MONSTER_TYPE:OnInit(tbArg)
	local nPos = self:GetPos();
	print("KGC_MONSTER_TYPE:OnInit, nPos = ", nPos)
	self:SetBloodShare(true)
	print("OnInit: ", self:GetName(), self:IsBloodShare())
end
---------------------------------------------------------
--test
