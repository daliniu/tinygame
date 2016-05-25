----------------------------------------------------------
-- file:	monsterbox.lua
-- Author:	page
-- Time:	2015/07/27 16:57
-- Desc:	怪物盒子类(继承ship)
----------------------------------------------------------
require "script/core/player/ship"
--------------------------------
--define
--------------------------------

--data struct
local TB_STRUCT_MONSTER_BOX = {

}


KGC_MONSTER_BOX_TYPE = class("KGC_MONSTER_BOX_TYPE", KGC_SHIP_BASE_TYPE, TB_STRUCT_MONSTER_BOX)

--------------------------------
--function
--------------------------------
function KGC_MONSTER_BOX_TYPE:ctor()
end

--init
function KGC_MONSTER_BOX_TYPE:OnInit(tbArg)
	
end

--@function: 创建一个怪物
function KGC_MONSTER_BOX_TYPE:CreateNpc()
	local npc = KGC_MONSTER_TYPE.new();
	return npc;
end

---------------------------------------------------
--test
