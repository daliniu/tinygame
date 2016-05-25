----------------------------------------------------------
-- file:	npc/head.lua
-- Author:	page
-- Time:	2015/06/24	11:34
-- Desc:	npc interface for outer
----------------------------------------------------------
--[[
relationship:
head.lua
|--contractbiology.lua
	|--hero.lua
		|--npc.lua
			|--data.lua
|--monster.lua
	
]]
if not _SERVER then
require "script/core/npc/contractbiology"
require "script/core/npc/monster"
else
require "script/core/npc/hero"
end
