----------------------------------------------------------
-- file:	skill.lua
-- Author:	page
-- Time:	2015/02/02 10:41
-- Desc:	技能管理类，全局
--			
----------------------------------------------------------
require "script/core/skill/common/head"
require("script/core/configmanager/configmanager");
----------------------------------------------------------
local l_tbSkillsInfo = mconfig.loadConfig("script/cfg/skills/skills")

local l_tbSkillType = def_GetSkillTypeData();

--data struct
local TB_SKILL_DATA = {
	--config
	------------------------------------
	m_Instance = nil,				-- 单列
}

KGC_SKILL_MANAGER_TYPE = class("KGC_SKILL_MANAGER_TYPE", CLASS_BASE_TYPE, TB_SKILL_DATA)
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_MANAGER_TYPE:Init()
end

----------------------------------------------------------
function KGC_SKILL_MANAGER_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_SKILL_MANAGER_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end

function KGC_SKILL_MANAGER_TYPE:Init()
end

function KGC_SKILL_MANAGER_TYPE:CastSkill(launchers, targets, skill, products)
	if type(launchers) ~= "table" or type(targets) ~= "table" then
		cclog("[Error]launchers or targets is NULL！@CastSkill()")
		return false;
	end
	-- cclog("释放技能CastSkill：|||||%s|||||", skill:GetName())
	if not skill then
		return;
	end
-- tst_PrintTime(10000)
	local tbLauncher, tbDefends, tbRetState, nRet = skill:Cast(launchers, targets, products)
-- tst_PrintTime(10001)	
	return tbLauncher, tbDefends, tbRetState, nRet;
end

function KGC_SKILL_MANAGER_TYPE:CreateSkill(nID, tbConfig)
	local skill = KGC_SKILL_BASE_TYPE.new()
	local tbInfo = self:GetSkillInfo(nID)
	if not tbInfo then
		return;
	end
	--config
	tbConfig = tbConfig or {} ---???question：以后修改为配置表读取的数据
	tbConfig.nID = nID;

	skill:Init(tbConfig, tbInfo)
	return skill;
end

function KGC_SKILL_MANAGER_TYPE:GetSkillInfo(nID)
	if not l_tbSkillsInfo[nID] then
		cclog("[Error]没有找到技能信息GetSkillInfo(%s)", nID);
	end
	return l_tbSkillsInfo[nID]
end
----------------------------------------------------------
g_SkillManager = KGC_SKILL_MANAGER_TYPE:getInstance();

--数据结构
--[[
m_tbProducts = {
	--攻击者数据
	[1] = {位置ID, 技能, },
	--被攻击者数据
	[2] = {位置ID, 伤害, 被动},
}

--战斗过程数据结构
m_tbStructFightData = {
	ship = me/tbEnemy,
	tbHeros = {
		[1] = {
			hero = nil,
			tbFightInfo = {
				nPos = ,					--位置信息，有可能被击到别的位置
				nHp=,						--血量
				nCost,						--费用
				nState,						--状态{死亡}
				tbNpcAttribute = {			--特殊一些魔法属性:buff类
					--在前还是后，直接作为属性类的一个成员
				},		
			},
		}
		[2] = {},
	}
}
]]

----------------------------------------------------------
--test
----------------------------------------------------------
