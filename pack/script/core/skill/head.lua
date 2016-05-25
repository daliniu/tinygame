----------------------------------------------------------
-- file:	skill/head.lua
-- Author:	page
-- Time:	2015/06/24	12:00
-- Desc:	skill interface for outer
----------------------------------------------------------
--[[
***relationship***

head.lua
|--manager.lua
	|--common/head.lua
		|--normal.lua
		|	|--base.lua
		|		|--lib/definefunctions.lua(Õ‚≤ø)
		|		|--common/data.lua
		|		|--effect/head.lua
		|		|	|--effect_attack.lua
		|		|		|--effect_base.lua
		|		|--statemanager.lua
		|			|--special/head.lua
		|				|--state_shield.lua
		|				|	|--state_base.lua	
		|				|--state_taunt.lua
		|--contract.lua
		|	|--base.lua
		|--combo.lua
		|	|--base.lua
		|--magic.lua
			|--base.lua
	
]]
require "script/core/skill/manager"