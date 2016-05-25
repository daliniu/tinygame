----------------------------------------------------------
-- file:	data.lua
-- Author:	page
-- Time:	2015/06/17
-- Desc:	npc相关数据类
----------------------------------------------------------

require ("script/class/class_data_base");
require("script/core/configmanager/configmanager");
require("script/lib/definefunctions");
local l_tbSuitAttribute = mconfig.loadConfig("script/cfg/character/suitAu");
local l_tbSuitAttrType = def_GetSuitAttribute();
local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
----------------------------------------------------------
-- 1. 技能槽类
local TB_STRUCT_NPC_SKILL_SLOT_DATA = {
	m_tbSkills = {},		--技能槽技能
	
	m_tbLevel = {},			--技能槽等级
	
	--config
	m_nSlotMaxSkill = 1,	--技能槽最大个数
	
	m_nCounter = 0,			-- 计数器
}

KGC_DATA_NPC_SKILL_SLOT = class("KGC_DATA_NPC_SKILL_SLOT", KGC_DATA_BASE_TYPE, TB_STRUCT_NPC_SKILL_SLOT_DATA)

function KGC_DATA_NPC_SKILL_SLOT:ctor()

end

function KGC_DATA_NPC_SKILL_SLOT:Init(tbArg)
	if type(tbArg) == "table" then
		for nCost, tbData in pairs(tbArg) do
			local nLevel = tbData.level
			self:SetLevelByCost(nCost, nLevel)
			
			-- 费用
			local nSkillID = tbData.skillId;
			if l_tbSkillConfig[nSkillID] then
				local nCost = l_tbSkillConfig[nSkillID].cost or 0;
				self:AddSkil(nCost, nSkillID);
				cclog("[log]技能(id:%s)加入技能槽", tostring(nSkillID));
			end
		end
	end
end

function KGC_DATA_NPC_SKILL_SLOT:GetSkills()
	if not self.m_tbSkills then
		self.m_tbSkills = {};
	end
	return self.m_tbSkills;
end

function KGC_DATA_NPC_SKILL_SLOT:GetSkillsByCost(nCost)
	local tbSkills = self:GetSkills();
	
	if not tbSkills[nCost] then
		tbSkills[nCost] = {};
	end
	
	return tbSkills[nCost];
end

function KGC_DATA_NPC_SKILL_SLOT:SetSkillByIndex(nCost, nIndex, nSkillID)
	local tbSkills = self:GetSkillsByCost(nCost)
	if not tbSkills[nIndex] then
		self.m_nCounter = self.m_nCounter + 1;
	end
	tbSkills[nIndex] = nSkillID;
end

function KGC_DATA_NPC_SKILL_SLOT:AddSkil(nCost, nID)
	local tbSkills = self:GetSkillsByCost(nCost)
	if #tbSkills > self.m_nSlotMaxSkill then
		cclog("[Warning]技能槽可使用的技能大于%d个！", self.m_nSlotMaxSkill);
	end
	if not self:IsSkillExist(nCost, nID) then
		table.insert(tbSkills, nID);
		self.m_nCounter = self.m_nCounter + 1;
	else
		cclog("[Warning]技能(%d)已经在技能槽中了，费用(%d)", nID, nCost);
	end
	-- end
end

--@function: 技能是否已经在技能槽了
function KGC_DATA_NPC_SKILL_SLOT:IsSkillExist(nCost, nID)
	local tbSkills = self:GetSkillsByCost(nCost);
	for k, v in pairs(tbSkills) do
		if v == nID then
			return true;
		end
	end
	return false;
end

function KGC_DATA_NPC_SKILL_SLOT:GetLevelByCost(nCost)
	local nLevel = self.m_tbLevel[nCost] or 1;			--默认现在是1级
	return nLevel;
end

function KGC_DATA_NPC_SKILL_SLOT:SetLevelByCost(nCost, nLevel)
	local nLevel = nLevel or 1;							--默认现在是1级
	self.m_tbLevel[nCost] = nLevel
end

--@function: 获取技能槽修改协议需要的结构
function KGC_DATA_NPC_SKILL_SLOT:GetModifySlotStruct()
	local tbStruct = {};
	local tbAllSkills = self:GetSkills();
	for i = 1, 6 do
		local szKey = "skillId" .. i;
		local nSkillID = 0;
		if tbAllSkills[i] then
			nSkillID = tbAllSkills[i][1];
		end
		tbStruct[szKey] = nSkillID;
	end
	return tbStruct;
end
--------------------------------------------------------------------
-- 2. 套装属性类
local TB_STRUCT_HERO_SUIT_ATTRIBUTE_DATA = {
	-- config
	MAX_COUNT = 5,
	--------------------------------------------
	m_tbAttrs = {				-- 属性
		-- [1] = nType1,
		-- [2] = nType2,
	},
	
	-- 属性效果数值
	m_nAttackAdd = 0,			-- 伤害提升
	m_nDefendAdd = 0,			-- 防御提升
	m_tbSkillCostSub = {		-- 技能消耗降低
		-- [nSkillID] = nSub,
	},
}

KGC_DATA_HERO_SUIT_ATTRIBUTE = class("KGC_DATA_HERO_SUIT_ATTRIBUTE", KGC_DATA_BASE_TYPE, TB_STRUCT_HERO_SUIT_ATTRIBUTE_DATA)

function KGC_DATA_HERO_SUIT_ATTRIBUTE:ctor()

end

function KGC_DATA_HERO_SUIT_ATTRIBUTE:Init(nAttr1, nAttr2, nAttr3, nAttr4, nAttr5, nSuit)
	local tbAttrs = self:GetSuitAttribute();
	local nAttr1 = nAttr1 or 0;
	local nAttr2 = nAttr2 or 0;
	local nAttr3 = nAttr3 or 0;
	local nAttr4 = nAttr4 or 0;
	local nAttr5 = nAttr5 or 0;
	tbAttrs[1] = tonumber(nAttr1);
	tbAttrs[2] = tonumber(nAttr2);
	tbAttrs[3] = tonumber(nAttr3);
	tbAttrs[4] = tonumber(nAttr4);
	tbAttrs[5] = tonumber(nAttr5);

	-- test 
	-- print("[测试]初始化的套装属性为：")
	-- tst_print_lua_table(tbAttrs);
	-- test end
	
	-- 初始化基本数值
	self.m_nAttackAdd = 0;
	self.m_nDefendAdd = 0;
	self.m_tbSkillCostSub = {};
	
	-- 初始化时候的数值计算-->放在me初始化之后统一计算
	-- self:CalculateAttribute(nSuit);
end

--@function：初始化的时候计算好各种数值
--@nStar: 全身开启的星级
function KGC_DATA_HERO_SUIT_ATTRIBUTE:CalculateAttribute(nStar)
	local nStar = nStar or 0;

	-- <=0的星级不需要计算
	if nStar <= 0 then
		return;
	end
	local tbAttrs = self:GetSuitAttribute();
	for nIndex, nID in pairs(tbAttrs) do
		if nIndex >= nStar then
			local tbData = self:GetAttributeByID(nID);
			if tbData then
				local nType = tonumber(tbData.userTeyp);
				if nType == l_tbSuitAttrType.ESAT_EFFECT_ADD then			-- 特定技能效果增加百分比
					
				elseif nType == l_tbSuitAttrType.ESAT_CAST_SUB then			-- 特定技能释放消耗降低
					if not self.m_tbSkillCostSub then
						self.m_tbSkillCostSub = {};
					end
					local tbSkillID = tbData.target;
					local nSub = self:GetConfigNum(nID);
					for _, nSkillID in pairs(tbSkillID) do
						-- 注意1：如果有多条相同的, 后面会覆盖前面的；
						-- 注意2：nSub可以是负值, 所以拿到的值都只管加好了；
						self.m_tbSkillCostSub[nSkillID] = nSub;
					end
				elseif nType == l_tbSuitAttrType.ESAT_ATTACK_ADD then		-- 伤害提升百分比
					local nAdd = self:GetAttackAddByID(nID);
					self.m_nAttackAdd = self.m_nAttackAdd + nAdd;
				elseif nType == l_tbSuitAttrType.ESAT_DEFEND_ADD then		-- 防御提升百分比
					local nAdd = self:GetDefendAddByID(nID);
					self.m_nDefendAdd = self.m_nDefendAdd + nAdd;
				elseif nType == l_tbSuitAttrType.ESAT_TARGET_ADD then		-- 特定技能目标增加
				end
			end
		end
	end
end

function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetSuitAttributeDesc()
	local tbAttrString = {}
	
	local tbAttrs = self:GetSuitAttribute();
	for i = 1, self.MAX_COUNT do
		local nID = tbAttrs[i];
		print("nID: ", nID);
		local szDesc = self:GetAttributeDesc(nID);
		if szDesc then
			szDesc = i .. ". " .. szDesc;
		else
			szDesc = i .. ". 未开启";
		end
		tbAttrString[i] = szDesc;
	end
	
	return tbAttrString;
end

function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetSuitAttribute()
	if not self.m_tbAttrs then
		self.m_tbAttrs = {};
	end
	return self.m_tbAttrs;
end

--@function: 根据ID从配置表获取某条属性
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetAttributeByID(nID)
	return l_tbSuitAttribute[nID]
end

--@function: 获取某条属性的描述
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetAttributeDesc(nID)
	local tbData = self:GetAttributeByID(nID);
	if tbData then
		return tbData.auName;
	end
end

--@function: 获取所有属性的描述
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetAllSuitAttributeDesc(nHeroID)
	local tbDesc = {};
	for nID, tbData in pairs(l_tbSuitAttribute) do
		if nHeroID == tbData.heroId then
			table.insert(tbDesc, tbData.auName);
		end
	end
	return tbDesc;
end

--@function: 获取某条属性提升伤害
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetAttackAddByID(nID)
	return self:GetConfigNum(nID);
end

--@function: 获取某条属性提升防御
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetDefendAddByID(nID)
	return self:GetConfigNum(nID);
end

--@function: 获取某条属性配置表的数值
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetConfigNum(nID)
	local nAdd = 0;
	local tbData = self:GetAttributeByID(nID);
	if tbData then
		nAdd = tbData.userNo;
	end
	return nAdd;
end

--@function: 套装属性-提升伤害
--@nAtk: 当前攻击力
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetAttackAdd(nAtk)
	local nAtk = nAtk or 0;
	local nAdd = math.floor(nAtk * self.m_nAttackAdd / 100);
	-- cclog("[log]套装属性-提升伤害, 当前攻击力(%d)--百分比(%d)-->提升值(%d)", nAtk, self.m_nAttackAdd, nAdd);
	return nAdd;
end

--@function: 套装属性-提升防御
--@nDef: 当前防御值
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetDefendAdd(nDef)
	local nDef = nDef or 0;
	local nAdd = math.floor(nDef * self.m_nDefendAdd / 100);
	-- cclog("[log]套装属性-提升防御, 当前防御力(%d)--百分比(%d)-->提升值(%d)", nDef, self.m_nDefendAdd, nAdd);
	return nAdd;
end

--@function: 套装属性-特定技能增加效果
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetEffectAdd(nSkillID)
end

--@function: 套装属性-特定技能释放消耗降低
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetCostSub(nSkillID)
	local tbSkillCostSub = self.m_tbSkillCostSub or {};
	local nSub = tbSkillCostSub[nSkillID] or 0;
	return nSub;
end

--@function: 套装属性-特定技能目标增加
function KGC_DATA_HERO_SUIT_ATTRIBUTE:GetTargetAdd(nSkillID)
end
--------------------------------------------------------------------
--test
function KGC_DATA_NPC_SKILL_SLOT:PrintSlotSkill()
	local tbSkillSlot = self:GetSkills();
	for nCost, tbSkills in pairs(tbSkillSlot) do
		cclog("[技能槽]费用(%d):", nCost)
		for _, nSkillID in pairs(tbSkills ) do
			local tbConfig = {}
			-- tbConfig.nLevel = self:GetLevelByCost(nCost);
			tbConfig.nCost = nCost
			tbConfig.nID = nSkillID
			local skill = g_SkillManager:CreateSkill(nSkillID, tbConfig)
			cclog("\t技能ID(%d)，技能费用(%d) --> 技能名字(%s)", tbConfig.nID, tbConfig.nCost, skill:GetName())
		end
	end
end
