----------------------------------------------------------
-- file:	normal.lua
-- Author:	page
-- Time:	2015/02/02 10:41
-- Desc:	普攻
--			
----------------------------------------------------------
require "script/core/skill/common/base"
----------------------------------------------------------
--data struct
local TB_SKILL_NORMAL_DATA = {
	--config
	------------------------------------
	-- m_szName = "普通技",
	------------------------------------
}

KGC_SKILL_NORMAL_TYPE = class("KGC_SKILL_NORMAL_TYPE", KGC_SKILL_BASE_TYPE, TB_SKILL_NORMAL_DATA)
local l_tbHitType = def_GetHitTypeData();
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_NORMAL_TYPE:ctor()
end

--
function KGC_SKILL_NORMAL_TYPE:OnInit()
	-- self:SetHitType(l_tbHitType.MISS_DIFF)
end

function KGC_SKILL_NORMAL_TYPE:IsSkill()
	return true;
end

----------------------------------------------------------

----------------------------------------------------------
--test
----------------------------------------------------------
