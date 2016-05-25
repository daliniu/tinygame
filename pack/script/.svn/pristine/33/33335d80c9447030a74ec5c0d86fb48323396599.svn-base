----------------------------------------------------------
-- file:	npc.lua
-- Author:	page
-- Time:	2014/12/02
-- Desc:	游戏所有npc的基类(包括：英雄、宠物、契约生物等)
----------------------------------------------------------
require("script/core/npc/data");
require("script/core/skill/manager");
require("script/core/configmanager/configmanager");
--------------------------------
--define @ 2015/01/27 17:35
-- 类定义和data名字用大写
-----------------------
--data struct 
local TB_NPC_BASE_DATA = {
	m_tbShip = nil,		--所属队伍
	m_szName = "",		--名字
	m_nID = 0,			-- 模版ID
	m_nModelID = 0,		-- 模型ID(对应骨骼动画)
	m_tbIcons = {		-- 头像
		szSquare = "",		-- 方形
		szRound = "",		-- 圆形
		szParall = "",		-- 平行四边形
		szSummon = "",		-- 图鉴召唤头像
	},		
	m_szModel = "",		--骨骼动画模版名
	m_Arm = nil,		--骨骼
	m_nType = 1,		--类型(英雄、契约生物、待定)
	m_nOcc = 0,			--职业
	
	--基本信息
	m_nLv = 1,			--等级
	
	--技能相关
	m_tbSkillPool = {},			--技能池：所有学会的技能
	m_objSkillSlot = nil,		--技能槽对象:KGC_DATA_NPC_SKILL_SLOT, 只有勾上的技能在技能槽
	m_tbAutoSkill = {},			--不占用技能槽技能(eg: 合作技能)
	m_tbTriggerSkills = {},		--触发类技能
	m_tbConfigSkillS = {},		--技能配置表：所有技能和他的开启条件(品质)
	
	----战斗需要的一些信息
	m_tbFightInfo = {	
		nPos = 99,				-- 位置
		nHP = 100,				-- 生命值
		nCost = 0,				-- 费用
		bCanAttack = false,		--是否可攻击
		
		nAtk = 0,				--攻击力
		nDef = 0,				--防御力
		nAL = 0,				--减伤等级(减伤比是计算来的,只存一个就好了)
		nPL = 0,				--穿透等级(伤害加深比)
		nCL = 0,				--暴击等级(暴击率)
		nTL = 0,				--韧性等级(免爆率)
		nHL = 0,				--命中等级(命中率)
		nML = 0,				--闪避等级(闪避率)
		nCAL = 0,				--反击等级(反击率)
		nVL = 0,				--吸血等级(吸血率)
		
		nPR = 0,				--伤害加深比
		nCR = 0,				--暴击率
		nTR = 0,				--免爆率
		nHR = 0,				--命中率
		nMR = 0,				--闪避率
		nCAR = 0,				--反击率
		nVR = 0,				--吸血率
		nDR = 0,				--减伤比
		
		nHLF = 100,				--命中率调整系数
		nMLF = 100,				--闪避率调整系数
		nCLF = 100,				--暴击率调整系数
		nTLF = 100,				--免爆率调整系数
		nAtkF = 4,				--减伤比调整系数
		nPLF = 100,				--穿透率调整系数
		nCALF = 10,				--反击率调整系数
		nVLF = 10,				--吸血率调整系数
	},		
	
	--转职相关
	m_tbOccTrans = {
	},
	
	m_nSlotMaxSkill = 1,		--技能槽最大可以配置的技能
	m_bShare = false,			-- 血条是否共用
	
	--------------------------------------------------
	-- config
	MAX_LEVEL_BASE_NUM = 10000,		-- 计算各种战斗率需要的基数
	MAX_RATE_BASE_NUM = 100,		-- 计算各种战斗率需要的基数
}
--------------------------------)
KG_NPC_BASE_TYPE = class("KG_NPC_BASE_TYPE", CLASS_BASE_TYPE, TB_NPC_BASE_DATA)

local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
local l_tbNPCModel = mconfig.loadConfig("script/cfg/client/model")
local l_tbAttrType, l_tbAttrTypeName  = def_GetAttributeType();
local l_tbSkillType = def_GetSkillTypeData();
--------------------------------
--function
--------------------------------
--init 和构造函数其实是一样的，只是这里的数据不一定都有
function KG_NPC_BASE_TYPE:ctor()	
	
end

function KG_NPC_BASE_TYPE:Init(tbArg)
	-- test
	cclog("[Log]初始化NPC ......................................")
	-- test end
	local nID = 0;
	if tbArg and tbArg.heroId then
		nID = tonumber(tbArg.heroId);
	end
	
	--初始化技能槽
	
	self.m_objSkillSlot = KGC_DATA_NPC_SKILL_SLOT.new();
	if tbArg.skillSlotList then
		self.m_objSkillSlot:Init(tbArg.skillSlotList)
	end
	
	local bReloadSlot = true;	-- 标记技能槽是否重新从配置加载: 服务器有不加载; 服务器无则加载
	--变动的数据，不存配置表
	if type(tbArg) == "table" then
		self:SetID(nID);
		local nLevel = tbArg.level or 1;
		self:SetLevel(tonumber(nLevel))
		self:SetPos(tonumber(tbArg.pos))
	end
	
	--读取配置表
	local tbConfig = self:GetConfigInfo(nID)
	if type(tbConfig) == "table" then
		self:SetModelID(tbConfig.modelid)
		self:SetName(tbConfig.name)
		self:SetHP(tbConfig.hp)
		self:SetAttack(tbConfig.atk)
		self:SetDefend(tbConfig.defense)
		self:SetAL(tbConfig.reducehurt);
		self:SetPL(tbConfig.penetrationlevel, tbConfig.increasehurt)
		self:SetCL(tbConfig.critlevel, tbConfig.critrate)
		self:SetTL(tbConfig.tenacitylevel, tbConfig.anticritrate)
		self:SetHL(tbConfig.hitlevel, tbConfig.hits)
		self:SetML(tbConfig.dodgelevel, tbConfig.dodgerate)
		if gf_IsValidPos(self:GetPos()) then
			self:CreateTrigger(tbConfig.conskillid)
		end
	
		-- 英雄普通技能增加费用区分
		local tbNormalSkills = tbConfig.commonskillid or {}
		self:InitNormalSkills(tbNormalSkills)
		
		-- 根据品质开发的技能组装
		local tbSkills = self:GetSkillFromConfig(tbConfig, tbArg.quality);
		self:InitSkills(tbSkills, tbArg.quality);
		
		-- 初始化合体技能
		local tbComboSkills = tbConfig.comboid or {};
		self:InitComboSkills(tbComboSkills);

		--只有monster有等级
		if tbConfig.level then
			self:SetLevel(tbConfig.level)
		end
	else
		cclog("[Error]初始化角色错误id(%s)", tostring(nID))
		return;
	end
	
	if tbConfig.modelid then
		local tbModelConfig = l_tbNPCModel[tbConfig.modelid]
		if tbModelConfig then
			self:SetHeadIcon(tbModelConfig.icon_square, tbModelConfig.icon_round, tbModelConfig.icon_parallelogram, tbModelConfig.icon_summon, tbModelConfig.img_cha);
		else
			cclog("[Error]没有找到英雄模版ID(%s)", tostring(tbConfig.modelid));
		end
	end

	self:OnInit(tbArg)
	cclog("[Log]角色(%s-%d)初始化完毕 ............. end", self:GetName(), self:GetID());
end

--@function: 初始化普通技能
function KG_NPC_BASE_TYPE:InitNormalSkills(tbSkills)
	if type(tbSkills) ~= "table" then
		cclog("[Error]普通技能配置表错误@InitNormalSkills")
		assert(false);
		return;
	end
	
	for _, id in ipairs(tbSkills) do
		self:AddNormalSkill(id);
	end
end

--@function: 初始化技能
function KG_NPC_BASE_TYPE:InitSkills(tbSkills, nQuality)
	if type(tbSkills) ~= "table" then
		cclog("[Error]技能配置表错误@InitSkills")
		assert(false);
		return;
	end
	
	-- 把技能加入到技能槽
	for _, id in ipairs(tbSkills) do
		if id and id > 0 then
			if not l_tbSkillConfig[id] then
				cclog("[Error]配置表错误, 没有技能ID(%d)", id);
			end

			local nCost = l_tbSkillConfig[id].cost or 0
			-- 所有学会的技能
			self:AddSkillToPool(nCost, id);
		end
	end
end

--@function: 初始化合体技能
function KG_NPC_BASE_TYPE:InitComboSkills(tbSkills)
	for _, id in ipairs(tbSkills) do
		if id and id > 0 then
			if not l_tbSkillConfig[id] then
				cclog("[Error]配置表错误, 没有技能ID(%d)", id);
			end

			local nCost = l_tbSkillConfig[id].cost or 0
			-- 所有学会的技能
			-- self:AddSkillToPool(nCost, id);
		end
	end
end

function KG_NPC_BASE_TYPE:GetNormalSkill()
	if not self.m_tbNormalSkill then
		self.m_tbNormalSkill = {};
	end
	
	return self.m_tbNormalSkill;
end

function KG_NPC_BASE_TYPE:AddNormalSkill(nID)
	local tbNormalSkill = self:GetNormalSkill();
	if nID and nID > 0 then
		local skill = g_SkillManager:CreateSkill(nID)
		if not self:IsExist(skill, tbNormalSkill) then
			table.insert(tbNormalSkill, skill);
		end
	else
		cclog("[Error]普通技能ID错误(ID = %s)", tostring(nID));
	end
end

function KG_NPC_BASE_TYPE:IsExist(skill, tbSkills)
	if not skill then
		return false;
	end

	local tbSkills = tbSkills or {};
	for k, v in pairs(tbSkills) do
		if v:GetID() == skill:GetID() then
			return true;
		end
	end
	
	return false;
end

function KG_NPC_BASE_TYPE:OnInit(tbArg)

end

function KG_NPC_BASE_TYPE:GetConfigInfo(nID)
	-- local tbNpc = mconfig.loadConfig("script/cfg/summons/summons")
	-- if self:IsHero() then
	local tbNpc= mconfig.loadConfig("script/cfg/character/character")
	-- end
	return tbNpc[nID]
end

function KG_NPC_BASE_TYPE:GetFightInfo()
	return self.m_tbFightInfo;
end

function KG_NPC_BASE_TYPE:IsCanAttack()
	local tbFightInfo = self:GetFightInfo()
	return tbFightInfo.bCanAttack;
end

function KG_NPC_BASE_TYPE:EnableAttack(bEnable)
	local tbFightInfo = self:GetFightInfo()
	tbFightInfo.bCanAttack = bEnable;
end

function KG_NPC_BASE_TYPE:SetName(szName)
	self.m_szName = szName or "";
end

function KG_NPC_BASE_TYPE:GetName()
	return self.m_szName;
end

function KG_NPC_BASE_TYPE:GetPos()
	local tbFightInfo = self:GetFightInfo()
	return tbFightInfo.nPos;
end

function KG_NPC_BASE_TYPE:SetPos(nPos)
	nPos = nPos or 0;
	local tbFightInfo = self:GetFightInfo()
	tbFightInfo.nPos = nPos;
end

function KG_NPC_BASE_TYPE:GetHP()
	local tbFightInfo = self:GetFightInfo()
	
	-- 等级成长
	local nHPAdd = self:GetLevelGrowing();
	local nHP = tbFightInfo.nHP + nHPAdd or 0;
	-- cclog("[Log]等级成长-增加血量(%d) --> (%d)", nHPAdd, nHP)
	
	-- 品质增加
	local nHPAdd = self:GetQualityGrowing();
	nHP = nHP + nHPAdd;
	
	-- 装备属性增加
	if self.m_tbShip then
		local nAdd3 = self.m_tbShip:GetEquipAttributeValue(self:GetEquipSuit(), l_tbAttrType.T_HP);
		nHP = nHP + nAdd3;
		-- cclog("[Log]英雄(%s)装备-增加生命值(%d) --> (%d)", self:GetName(), nAdd3, nHP)
	end
	
	return nHP;
end

function KG_NPC_BASE_TYPE:SetHP(nHP)
	local tbFightInfo = self:GetFightInfo()
	tbFightInfo.nHP = nHP;
end

function KG_NPC_BASE_TYPE:GetCost()
	return self:GetFightInfo().nCost;
end

function KG_NPC_BASE_TYPE:SetCost(nCost)
	nCost = nCost or 0;
	self:GetFightInfo().nCost = nCost;
end

--@function: 返回方形、圆形、平行四边形ICON
function KG_NPC_BASE_TYPE:GetHeadIcon()
	if not self.m_tbIcons then
		self.m_tbIcons = {};
	end
	return self.m_tbIcons.szSquare, self.m_tbIcons.szRound, self.m_tbIcons.szParall, self.m_tbIcons.szSummon, self.m_tbIcons.szCharacter;
end

--@function: 设置NPC头像
--@szIconS: 方形
--@szIconR: 圆形
--@szIconP: 平行四边形
--@szIconSu: 图鉴召唤头像
function KG_NPC_BASE_TYPE:SetHeadIcon(szIconS, szIconR, szIconP, szIconSu, szCharacter)
	-- print("SetHeadIcon", szIconS, szIconR, szIconP)
	if not self.m_tbIcons then
		self.m_tbIcons = {};
	end
	self.m_tbIcons.szSquare = szIconS or "";
	self.m_tbIcons.szRound = szIconR or "";
	self.m_tbIcons.szParall = szIconP or "";
	self.m_tbIcons.szSummon = szIconSu or "";
	self.m_tbIcons.szCharacter = szCharacter or "";
end

function KG_NPC_BASE_TYPE:GetType()
	return self.m_nType;
end

function KG_NPC_BASE_TYPE:SetType(nType)
	self.m_nType = nType or 0;
end

function KG_NPC_BASE_TYPE:GetName()
	return self.m_szName;
end

--@function: 设置模版ID
function KG_NPC_BASE_TYPE:SetID(nID)
	self.m_nID = nID or 0;
end

function KG_NPC_BASE_TYPE:GetID()
	return self.m_nID;
end

--@function: 设置模型ID
function KG_NPC_BASE_TYPE:SetModelID(nID)
	self.m_nModelID = nID or 0;
end

function KG_NPC_BASE_TYPE:GetModelID()
	return self.m_nModelID;
end

function KG_NPC_BASE_TYPE:GetModel()
	return self.m_szModel;
end

function KG_NPC_BASE_TYPE:IsHero()
	return false;
end

--@function: 是否是召唤生物
function KG_NPC_BASE_TYPE:IsSummon()
	return false;
end

function KG_NPC_BASE_TYPE:SetShip(tbShip)
	self.m_tbShip = tbShip;
end

function KG_NPC_BASE_TYPE:GetShip()
	return self.m_tbShip;
end

function KG_NPC_BASE_TYPE:IsRemote()
	return self.m_nOcc == 1;
end

function KG_NPC_BASE_TYPE:GetOccupation()
	return self.m_nOcc;
end

function KG_NPC_BASE_TYPE:SetOccupation(nOcc)
	self.m_nOcc = nOcc;
end

function KG_NPC_BASE_TYPE:GetLevel()
	return self.m_nLv;
end

function KG_NPC_BASE_TYPE:SetLevel(nLevel)
	self.m_nLv = nLevel or 0;
end

--@function: 设置减伤等级
function KG_NPC_BASE_TYPE:SetAL(nAL)
	local tbFightInfo = self:GetFightInfo()
	tbFightInfo.nAL = nAL or 0;
end

function KG_NPC_BASE_TYPE:GetAL()
	local tbFightInfo = self:GetFightInfo()
	return tbFightInfo.nAL;
end

function KG_NPC_BASE_TYPE:SetHL(nHL, nHR)
	local tbFightInfo = self:GetFightInfo()
	tbFightInfo.nHL = nHL or 0;
	tbFightInfo.nHR = nHR or 0;
end

function KG_NPC_BASE_TYPE:GetHL()
	local tbFightInfo = self:GetFightInfo()
	return tbFightInfo.nHL, tbFightInfo.nHR, tbFightInfo.nHLF;
end

--@function: 命中率计算公式：计算得到的概率/基数 + 基础命中率/基数
function KG_NPC_BASE_TYPE:GetHitRate()
	local tbInfo = self:GetFightInfo()
	local nHL, nHR, nHLF = self:GetHL();
	local nRate1 = nHL/(nHL + nHLF)

	local nRate = nRate1/self.MAX_LEVEL_BASE_NUM + nHR/self.MAX_RATE_BASE_NUM;
	return nRate;
end

--@function: 闪避率计算公式：计算得到的概率/基数 + 基础命中率/基数
function KG_NPC_BASE_TYPE:GetDodgeRate()
	local nML, nMR, nMLF = self:GetML();
	local nRate1 = nML/(nML + nMLF)
	local nRate = nRate1/self.MAX_LEVEL_BASE_NUM + nMR/self.MAX_RATE_BASE_NUM;
	return nRate;
end

--@function: 暴击率计算公式：计算得到的概率/基数 + 基础命中率/基数
function KG_NPC_BASE_TYPE:GetCritRate()
	local nCL, nCR, nCLF = self:GetCL();
	local nRate1 = 0;
	local nDividend = nCL + nCLF
	if nDividend ~= 0 then
		nRate1 = nCL/nDividend
	end
	
	local nRate = nRate1/self.MAX_LEVEL_BASE_NUM + nCR/self.MAX_RATE_BASE_NUM;
	return nRate;
end

--@function: 免爆率计算公式:计算得到的概率/基数 + 基础命中率/基数
function KG_NPC_BASE_TYPE:GetNoCritRate()
	local nTL, nTR, nTLF = self:GetTL()
	local nRate1 = 0;
	local nDividend = nTL + nTLF
	if nDividend ~= 0 then
		nRate1 = nTL/nDividend;
	end
	
	local nRate = nRate1/self.MAX_LEVEL_BASE_NUM + nTR/self.MAX_RATE_BASE_NUM;
	return nRate;
end

--@function: 获取防御力
function KG_NPC_BASE_TYPE:GetDefend()
	local tbInfo = self:GetFightInfo()
	
	-- 等级成长
	local _, _, nDefAdd = self:GetLevelGrowing();
	local nDef = tbInfo.nDef + nDefAdd or 0;
	-- cclog("[Log]等级成长-增加防御(%d) --> (%d)", nDefAdd, nDef)
	
	-- 品质增加
	local _, _, nDefAdd = self:GetQualityGrowing();
	nDef = nDef + nDefAdd;
	
	-- 套装属性提升
	local nAdd2 = self:GetDefendBySuitAttribute(nDef);
	nDef = nDef + nAdd2;
	
	-- 装备属性增加
	if self.m_tbShip then
		local nAdd3 = self.m_tbShip:GetEquipAttributeValue(self:GetEquipSuit(), l_tbAttrType.T_DEF);
		nDef = nDef + nAdd3;
		-- cclog("[Log]英雄(%s)装备-防御增加(%d) --> (%d)", self:GetName(), nAdd3, nDef)
	end
	
	return nDef;
end

function KG_NPC_BASE_TYPE:SetDefend(nDefense)
	local tbInfo = self:GetFightInfo()
	tbInfo.nDef = nDefense or 0;
end

--@function: 获取攻击力
function KG_NPC_BASE_TYPE:GetAttack()
	local tbInfo = self:GetFightInfo()
	
	-- 等级成长
	local _, nAtkAdd = self:GetLevelGrowing();
	local nAtk = tbInfo.nAtk + nAtkAdd or 0;
	-- cclog("[Log]英雄(%s)等级成长-增加攻击(%d) --> (%d)", self:GetName(), nAtkAdd, nAtk)
	
	-- 品质增加
	local _, nAtkAdd = self:GetQualityGrowing();
	nAtk = nAtk + nAtkAdd;
	
	-- 套装属性增加
	local nAdd2 = self:GetAttackBySuitAttribute(nAtk);
	nAtk = nAtk + nAdd2;
	
	-- 装备属性增加
	if self.m_tbShip then
		local nAdd3 = self.m_tbShip:GetEquipAttributeValue(self:GetEquipSuit(), l_tbAttrType.T_ATK);
		nAtk = nAtk + nAdd3;
		-- cclog("[Log]英雄(%s)装备-增加攻击(%d) --> (%d)", self:GetName(), nAdd3, nAtk)
	end
	
	return nAtk;
end

function KG_NPC_BASE_TYPE:SetAttack(nAttack)
	local tbInfo = self:GetFightInfo()
	tbInfo.nAtk = nAttack or 0;
end

--@function: 减伤比计算公式(launcher-->self)
--@nAttack: 攻击者战斗力
function KG_NPC_BASE_TYPE:GetDefendRate(nAttack)
	local nAttack = nAttack or 0;
	local tbFight = self:GetFightInfo()
	local nRate = 0;
	local nDividend = self:GetDefend();

	if tbFight.nAtkF ~= 0 then
		nDividend = nDividend + nAttack/tbFight.nAtkF
	end
	if nDividend ~= 0 then
		nRate = self:GetDefend()/nDividend;
	end
	-- print(nRate, "减伤比计算公式：", self:GetDefend(), nDividend, nAttack, tbFight.nAtkF, self:GetDefend())
	--保留三位小数
	return gf_GetPreciseDecimal(nRate, 3)
end

--@function: 设置减伤比
-- function KG_NPC_BASE_TYPE:SetDefendRate(nDR)
	-- local tbInfo = self:GetFightInfo()
	-- tbInfo.nDR = nDR or 0;
-- end

--@function: 穿透率计算公式
function KG_NPC_BASE_TYPE:GetPenetrationRate()
	local tbInfo = self:GetFightInfo()
	local nRate = 0;
	-- print("穿透率计算公式：", tbInfo.nPL, tbInfo.nPLF)
	if self:GetPL() ~= 0 then
		nRate = self:GetPL()/tbInfo.nPLF
	end
	--保留一位小数
	return gf_GetPreciseDecimal(nRate, 3)
end

--@function: 获取穿透等级
function KG_NPC_BASE_TYPE:GetPL()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nPL;
end

function KG_NPC_BASE_TYPE:SetPL(nPL, nPR)
	local tbInfo = self:GetFightInfo()
	tbInfo.nPL = nPL or 0;
	tbInfo.nPR = nPR or 0;
end

--@function: 获取反击等级
function KG_NPC_BASE_TYPE:GetCALevel()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nCAL;
end

--@function: 获取反击调整系数
function KG_NPC_BASE_TYPE:GetCAFactor()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nCALF;
end

--@function: 获取吸血等级
function KG_NPC_BASE_TYPE:GetVampireLevel()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nVL;
end

--@function: 获取吸血概率调整系数
function KG_NPC_BASE_TYPE:GetVLFactor()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nVLF;
end

--@function: 获取暴击等级
function KG_NPC_BASE_TYPE:GetCL()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nCL, tbInfo.nCR, tbInfo.nCLF;
end

function KG_NPC_BASE_TYPE:SetCL(nCL, nCR)
	local tbInfo = self:GetFightInfo()
	tbInfo.nCL = nCL or 0;
	tbInfo.nCR = nCR or 0;
end

--@function: 获取韧性等级
function KG_NPC_BASE_TYPE:GetTL()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nTL, tbInfo.nTR, tbInfo.nTLF;
end

function KG_NPC_BASE_TYPE:SetTL(nTL, nTR)
	local tbInfo = self:GetFightInfo()
	tbInfo.nTL = nTL or 0;
	tbInfo.nTR = nTR or 0;
end

--@function: 获取闪避等级
function KG_NPC_BASE_TYPE:GetML()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nML, tbInfo.nMR, tbInfo.nMLF;
end

function KG_NPC_BASE_TYPE:SetML(nML, nMR)
	local tbInfo = self:GetFightInfo()
	tbInfo.nML = nML or 0;
	tbInfo.nMR = nMR or 0;
end

--@function: 设置是否共用血条
function KG_NPC_BASE_TYPE:SetBloodShare(bShare)
	self.m_bShare = bShare or false;
end

function KG_NPC_BASE_TYPE:IsBloodShare()
	return self.m_bShare;
end

--@function：获取合作技能
function KG_NPC_BASE_TYPE:GetComboSkill()
	if not self.m_tbAutoSkill then
		self.m_tbAutoSkill = {};
	end
	return self.m_tbAutoSkill;
end

--@function: 获取已经学习的技能，技能池
function KG_NPC_BASE_TYPE:GetSkillPool()
	if not self.m_tbSkillPool then
		self.m_tbSkillPool = {};
	end
	
	return self.m_tbSkillPool;
end

--@function: 获取已经学习的技能，技能池
function KG_NPC_BASE_TYPE:GetSkillPoolByCost(nCost)
	local tbSkillPool = self:GetSkillPool();
	
	if not tbSkillPool[nCost] then
		tbSkillPool[nCost] = {};
	end
	
	return tbSkillPool[nCost];
end

function KG_NPC_BASE_TYPE:AddSkillToPool(nCost, nID)
	local tbSkillPool = self:GetSkillPoolByCost(nCost);
	if nID and nID > 0 then
		local fnIsExist = function(nSkillID)
			for _, nSkillID in pairs(tbSkillPool) do
				if nSkillID == nID then
					return true;
				end
			end
			return false;
		end
		if not fnIsExist(nID) then
			table.insert(tbSkillPool, nID)
		else
			cclog("[Warning]技能池中技能(%d)已经存在", nID);
		end
	end
end

--@function: 获取技能槽技能(技能对象)
function KG_NPC_BASE_TYPE:GetSlot()
	
	-- if self.m_tbSlot and #self.m_tbSlot > 0 then
		-- return self.m_tbSlot
	-- end
	if not self.m_tbSlot then
		self.m_tbSlot = {}
	end
	--清空：每个技能对象在战斗过程中保存自己的一些信息(例如契约生物的位置信息), 所以不要参杂在一起
	self.m_tbSlot = {}
	local tbSlot = self:CreateSlot()
	for _, skill in pairs(tbSlot) do
		table.insert(self.m_tbSlot, skill)
	end

	return self.m_tbSlot;
end

--@function: 根据技能槽数据(id, level)创建技能对象
function KG_NPC_BASE_TYPE:CreateSlot()
	local tbSlot = {}
	local tbSkillSlot = self.m_objSkillSlot:GetSkills();
	-- local tbSkillPool = self:GetSkillPool();
	-- cclog("技能槽技能创建(CreateSlot)：pos(%s), #tbSkillSlot(%d)", self:GetPos(), self:TestGetSlotNum())
	-- tst_PrintTime(5001)
	for nCost, tbSkills in pairs(tbSkillSlot) do
		-- print("cost:", #(tbSkills or {}))
		for _, nSkillID in pairs(tbSkills) do
			local tbConfig = {}
			-- tbConfig.nLevel = tbSkill[2]
			tbConfig.nCost = nCost
			tbConfig.nID = nSkillID;
			local skill = g_SkillManager:CreateSkill(nSkillID, tbConfig)
			-- cclog("\t技能ID(%d)，技能费用(%d) --> 技能名字(%s)", tbConfig.nID, tbConfig.nCost, skill:GetName())

			table.insert(tbSlot, skill)
		end
	end
	-- tst_PrintTime(5002)
	return tbSlot;
end

--@function: 获取技能对象
function KG_NPC_BASE_TYPE:GetSkillObj(tbSkill)
	local tbRet = {};
	local tbSkill = tbSkill or {};
	for _, tbSkill in pairs(tbSkills ) do
		local tbConfig = {}
		tbConfig.nLevel = tbSkill[2]
		tbConfig.nID = tbSkill[1]
		local skill = g_SkillManager:CreateSkill(tbSkill[1], tbConfig)
		table.insert(tbRet, skill);
	end
	return skill;
end

function KG_NPC_BASE_TYPE:CreateTrigger(tbIDs)
	if type(tbIDs) ~= "table" then
		return false;
	end
	
	if not self.m_tbTriggerSkills then
		self.m_tbTriggerSkills = {};
	end
	
	for _, id in ipairs(tbIDs) do
		if id > 0 then
			local tbConfig = {}
			tbConfig.nLevel = 1
			local skill = g_SkillManager:CreateSkill(id, tbConfig)
			table.insert(self.m_tbTriggerSkills, skill);
		end
	end
	cclog("[Log]自带触发类技能创建%d个", #self.m_tbTriggerSkills)
end

function KG_NPC_BASE_TYPE:GetTriggerSkills()
	return self.m_tbTriggerSkills;
end

function KG_NPC_BASE_TYPE:HasTriggerSkills()
	local tbTriggerSkills = self:GetTriggerSkills() or {};
	print("#tbTriggerSkills", #tbTriggerSkills)
	return #tbTriggerSkills > 0;
end

--@function: 获取对应费用的技能槽技能(技能槽索引为费用)
function KG_NPC_BASE_TYPE:GetSlotByCost(nCost)
	local nCost = nCost or 0;
	local tbSkillSlot = self.m_objSkillSlot:GetSkillsByCost(nCost);
	
	return tbSkillSlot;
end

--@function: 技能是否可以放入技能槽
function KG_NPC_BASE_TYPE:IsSkillCanPutSlot(nSkillID, nQuality)
	local skill = g_SkillManager:CreateSkill(nSkillID)
	if not skill then
		cclog("[Error]技能为空@IsSkillCanPutSlot");
		return false;
	end
	local bRet = false;
	-- 合作技能判断
	if skill:IsCombo() then
		local tbComboSkill = self:GetComboSkill();
		print("\t合体技能：", skill:GetName(), tbComboSkill, #tbComboSkill);
		for id, skill in pairs(tbComboSkill) do
			if id == skill:GetID() then
				bRet = true;
				break;
			end
		end
		-- cclog("[log]技能(%s-%d)是否可以放入技能槽：%s", skill:GetName(), skill:GetID(), tostring(bRet));
		return bRet;
	end
	
	-- 是否已经学会()
	local tbAllConfigSkills = self:GetAllConfigSkills();
	if self:IsHero() then
		local nQuality = nQuality or 0;
		-- 技能槽技能
		if tbAllConfigSkills[nSkillID] then
			if nQuality >= tbAllConfigSkills[nSkillID] then
				bRet = true;
			end
		else
			bRet = true;
		end
	else
		bRet = true;
	end
	
	cclog("[log]技能(%s-%d)是否可以放入技能槽：%s", skill:GetName(), skill:GetID(), tostring(bRet));
	return bRet;
end

--合作技能处理函数
function KG_NPC_BASE_TYPE:OnHeroInsert()
	
end

function KG_NPC_BASE_TYPE:OnHeroRemove()
	
end

--@function: 根据品质获取技能
function KG_NPC_BASE_TYPE:GetSkillFromConfig(tbConfig, nQuality)
	local nQuality = nQuality or -1;
	local tbSkills = {};
	
	-- 简单判断一下
	if not tbConfig.skill1_1 then
		return tbSkills;
	end
	
	local fnIsQualityOK = function(nQuality, nNeedQuality)
		local nQuality = nQuality or -1;
		local nNeedQuality = nNeedQuality or 0;
		return nQuality >= nNeedQuality;
	end

	local tbAllConfigSkills = self:GetAllConfigSkills();
	
	for nCost = 1, 6 do			--六费
		for i = 1, 2 do			--两个技能
			szName = "skill" .. nCost .. "_" .. i;
			local nID, nNeedQuality = unpack(tbConfig[szName] or {});
			if nID and nID >= 0 then
				if fnIsQualityOK(nQuality, nNeedQuality) then
					table.insert(tbSkills, nID);
				end
				
				--保存一份配置表的技能
				tbAllConfigSkills[nID] = nNeedQuality;
			end
		end
	end

	return tbSkills;
end

--@function: 根据品质获取技能
function KG_NPC_BASE_TYPE:GetAllConfigSkills()
	if not self.m_tbConfigSkillS then
		self.m_tbConfigSkillS = {};
	end
	return self.m_tbConfigSkillS;
end

--@function: 获取等级成长
--@return: 生命、攻击、防御
function KG_NPC_BASE_TYPE:GetLevelGrowing(nLevel)
	return 0, 0, 0;
end

--@function: 获取品质成长
--@return: 生命、攻击、防御
function KG_NPC_BASE_TYPE:GetQualityGrowing()
	return 0, 0, 0;
end

--@function: 获取套装属性攻击力提升
function KG_NPC_BASE_TYPE:GetAttackBySuitAttribute(nAtk)
	return 0;
end

--@function: 获取套装属性防御力提升
function KG_NPC_BASE_TYPE:GetDefendBySuitAttribute(nDef)
	return 0;
end

--@function: 获取费用消耗额外值
function KG_NPC_BASE_TYPE:GetCostExtra()
	return 0;
end

--@function: 获取装备索引
function KG_NPC_BASE_TYPE:GetEquipSuit()
	return 0;
end

--@function: 获取技能槽等级
function KG_NPC_BASE_TYPE:GetSlotLevelByCost(nCost)
	return self.m_objSkillSlot:GetLevelByCost(nCost);
end
---------------------------------------------------------
--test
function KG_NPC_BASE_TYPE:TestPrintRoleData()
	for k, v in pairs(self) do
		--print(k, v)
	end
end

--test
function KG_NPC_BASE_TYPE:TestGetSlotNum()
	local nCount = 0;
	local tbSkillSlot = self.m_objSkillSlot:GetSkills();
	for k, v in pairs(tbSkillSlot) do
		nCount = nCount + 1;
	end
	return nCount;
end

function KG_NPC_BASE_TYPE:TestPrintSkill()
	print("技能信息：...")
	self.m_objSkillSlot:PrintSlotSkill();
	
	print("已经学会的技能: ")
	local tbNormalSkill = self:GetSkillPool();
	for nCost, tbSkills	in pairs(tbNormalSkill) do
		for _, nSkillID in pairs(tbSkills or {}) do
			local skill = g_SkillManager:CreateSkill(nSkillID);
			cclog("\t[费用%d]: 技能ID(%d), 技能等级(%d)", skill:GetCost(), skill:GetID(), skill:GetLevel());
		end
	end
	print("普攻：")
	local tbNormalSkill = self:GetNormalSkill();
	for _, skill in pairs(tbNormalSkill) do
		cclog("\t[费用%d]: 技能ID(%d), 技能等级(%d)", skill:GetCost(), skill:GetID(), skill:GetLevel());
	end
	print("技能信息：... end")
end