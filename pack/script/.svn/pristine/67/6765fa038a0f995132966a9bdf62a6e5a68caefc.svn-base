----------------------------------------------------------
-- file:	hero.lua
-- Author:	page
-- Time:	2014/12/02
-- Desc:	英雄：部队的成员单位
----------------------------------------------------------
if not _SERVER then
require "script/lib/definefunctions"
end
require "script/core/npc/npc"
require("script/core/configmanager/configmanager");
local l_tbQualityConfig = mconfig.loadConfig("script/cfg/client/quality_hero")
local l_tbCharacterConfig = mconfig.loadConfig("script/cfg/character/character")
local l_tbLevelUpExp = mconfig.loadConfig("script/cfg/player/experience");
local l_tbHeroQualityConfig = require("script/cfg/hero/heroquality");
local l_tbHeroType = def_GetHeroType();
local l_tbEquipPos = def_GetPlayerEquipPos();
--------------------------------

--define @ 2015/01/27 17:35
-- 类定义和data名字用大写
--data struct 
local TB_HERO_DATA = {
	m_nExp = 0,			-- 经验
	m_nStars = 0,		-- 星级
	m_nQuality = 0,		-- 品质
	m_nHeroType = 0,	-- 英雄类型(快攻、中速、控制)
	
	--不占用技能槽技能(合作技能)
	m_tbAutoSkill = {
		--[id] = skill;
	},
	
	m_tbSkillObjsPool = {			--所有技能的对象
		--[[格式
			[nCost1] = {skill1, skill2, ...},
			[nCost2] = {skill1, skill2, ...},
		]]
	},
	m_tbSkillObjsSlot = {},			--技能槽技能对象，同上
	
	--技能ID
	m_tbSlot = {},

	--技能槽
	m_tbSkillSlot={};
		--[[格式
 			{
				1 : {level : 1},
				2 : {level : 1},
				3 : {level : 1},
				4 : {level : 1},
				5 : {level : 1},
				6 : {level : 1}
			};

		]]
	
	--{1, 1} [1] = {level = 1,}
	
	m_objSuitAttribute = nil,		-- 套装属性
}
--------------------------------
KG_HERO_TYPE = class("KG_HERO_TYPE", KG_NPC_BASE_TYPE, TB_HERO_DATA)

local tbNpcType = def_GetNpcType();

local l_tbUIUpdateType
if not _SERVER then
l_tbUIUpdateType = def_GetUIUpdateTypeData();
end
--------------------------------
--function
--------------------------------
function KG_HERO_TYPE:ctor()
	self.m_nType = tbNpcType.HERO;
end

--init 和构造函数其实是一样的，只是这里的数据不一定都有
function KG_HERO_TYPE:OnInit(tbArg)	
	if tbArg.m_szModel then
		self.m_szModel = tbArg.m_szModel;
	end
	
	if tbArg.curExp then
		self:SetExp(tbArg.curExp)
	end
	
	if tbArg.m_nOcc then
		self.m_nOcc = tbArg.m_nOcc;
	end
	
	if tbArg.type then
		self:SetHeroType(tbArg.type);
	end
	
	self:SetStars(tbArg.star)				-- 星级
	self:SetQuality(tbArg.quality)			-- 品质
	
	--技能槽初始化
	local pSkillSlotDate = tbArg.skillSlotList 
	self:InitSKillSlot(pSkillSlotDate)
	
	-- 英雄默认是血条共用
	self:SetBloodShare(true);

	-- 初始化套装属性
	self:InitSuitAttribute(tbArg.suitId1, tbArg.suitId2, tbArg.suitId3, tbArg.suitId4, tbArg.suitId5);
end

function KG_HERO_TYPE:GetHeroType()
	return self.m_nHeroType;
end

function KG_HERO_TYPE:SetHeroType(nType)
	self.m_nHeroType = nType or 0;
end

function KG_HERO_TYPE:GetHeroTypeResource()
	local tbResource = {
		[l_tbHeroType.ET_FAST] = CUI_PATH_HERO_TYPE_FAST,
		[l_tbHeroType.ET_MEDIUM] = CUI_PATH_HERO_TYPE_MEDIUM,
		[l_tbHeroType.ET_CONTROL] = CUI_PATH_HERO_TYPE_CONTROL,
	};
	local nType = self:GetHeroType();
	return tbResource[nType];
end

function KG_HERO_TYPE:IsHero()
	return true;
end

--合作技能处理函数
function KG_HERO_TYPE:OnHeroInsert()
	if not self.m_objSkillSlot then
		return;
	end

	-- 合体技能这个时候没有进入技能槽
	local tbSkillPool = self:GetSkillPool();
	for nCost, tbSkills in pairs(tbSkillPool) do
		for _, nSkillID in pairs(tbSkills) do
			local tbConfig = {}
			tbConfig.nID = nSkillID
			tbConfig.nCost = nCost;
			local skill = g_SkillManager:CreateSkill(nSkillID, tbConfig)
			if skill:IsCombo() then
				--合作者都上阵了
				local tbPartner = skill:GetPartner()
				local tbShip = self:GetShip()
				if tbShip:IsPartnerIn(tbPartner) then
					tbShip:AddPartnerSkill(tbPartner, skill)
				end
			end
		end
	end
end

function KG_HERO_TYPE:OnHeroRemove()
	self:SetPos(0);
	local tbComboSkill = self:GetComboSkill();
	for id, skill in pairs(tbComboSkill) do
		local tbPartner = skill:GetPartner()
		local tbShip = self:GetShip()
		tbShip:RemovePartnerSkill(tbPartner, skill)
	end
end

function KG_HERO_TYPE:AddComboSkill(skill)
	print("[log]添加合体技能：", self:GetName(), skill:GetName());
	local tbComboSkill = self:GetComboSkill();
	if skill:IsSkill() then
		tbComboSkill[self:GetID()] = skill;
	end
end

function KG_HERO_TYPE:RemoveComboSkill(skill)
	print("[log]删除合体技能：", self:GetName(), skill:GetName());
	local tbComboSkill = self:GetComboSkill();
	if skill:IsSkill() then
		tbComboSkill[self:GetID()] = nil;
	end
end

function KG_HERO_TYPE:GetFlag()
	return self.m_nFlag;
end

--@function：英雄上阵: 有位置信息
function KG_HERO_TYPE:IsOn()
	return gf_IsValidPos(self:GetPos());
end

--@function：英雄未上阵
function KG_HERO_TYPE:IsOff()
	return not gf_IsValidPos(self:GetPos());
end

--@function：英雄是否拥有:去配置表读取
function KG_HERO_TYPE:IsHas()
	return self.m_nFlag == 1 or self.m_nFlag == 2;
end

function KG_HERO_TYPE:GetAllSkills()
	local tbSkills = {};
	local tbSkillPool = self:GetSkillPool();
	for nCost, tbSkill in pairs(tbSkillPool) do
		for _, skill in pairs(tbSkill) do
			table.insert(tbSkills, skill[1]);
		end
	end
	
	return tbSkills;
end

--@function: 创建技能对象
function KG_HERO_TYPE:CreateSkillObjs(tbSkillSet)
	local tbObjs = {}

	for nCost, tbSkills in pairs(tbSkillSet) do
		if not tbObjs[nCost] then
			tbObjs[nCost] = {}
		end
		
		-- 根据技能槽等级得到等级
		local nLevel = 1;
		if self.m_objSkillSlot then
			nLevel = self.m_objSkillSlot:GetLevelByCost(nCost);
		end
			
		for _, nSkillID in pairs(tbSkills) do
			local tbConfig = {}
			tbConfig.nLevel = nLevel;
			tbConfig.nCost = nCost
			tbConfig.nID = nSkillID
			local skill = g_SkillManager:CreateSkill(nSkillID, tbConfig)
			-- cclog("\t技能ID(%d)，技能费用(%d) --> 技能名字(%s)", tbConfig.nID, tbConfig.nCost, skill:GetName())
			table.insert(tbObjs[nCost], skill)
		end
	end
	return tbObjs;
end

--@function: 获取所有技能对象
function KG_HERO_TYPE:GetAllSkillObjs()
	if self.m_tbSkillObjsPool then
		local tbSkillPool = self:GetSkillPool();
		self.m_tbSkillObjsPool = self:CreateSkillObjs(tbSkillPool);
	end

	--test
	print("***************************")
	print("[log]所有学会的技能：");
	for nCost, tbSkills in pairs(self.m_tbSkillObjsPool) do
		cclog("\t费用[%d] = ", nCost)
		for _, skill in pairs(tbSkills or {}) do
			cclog("\t技能：%s- %d", skill:GetName(), skill:GetID());
		end
	end
	print("[log]所有学会的技能 ... end");
	print("***************************")
	--test 
	return self.m_tbSkillObjsPool;
end

--@function: 获取技能槽技能对象，nCost作为索引
--[[@return = {
		[nCost] = {skill1, skill2},
	}
]]
function KG_HERO_TYPE:GetSlotSkillObjs()
	if self.m_tbSkillObjsSlot then
		local tbSkillSlot = self.m_objSkillSlot:GetSkills();
		self.m_tbSkillObjsSlot = self:CreateSkillObjs(tbSkillSlot);
	end

	--test
	print("***************************")
	print("[log]技能槽所有的技能：");
	for nCost, tbSkills in pairs(self.m_tbSkillObjsSlot) do
		cclog("\t费用[%d] = ", nCost)
		for _, skill in pairs(tbSkills or {}) do
			cclog("\t\t技能：%s- %d", skill:GetName(), skill:GetID());
		end
	end
	print("[log]技能槽所有的技能 ... end");
	print("***************************")
	--test 
	return self.m_tbSkillObjsSlot;
end

--@function: 更换技能槽某个位置的技能
--@nCost-费用为nCost的技能槽
--@nIndex: 在当前技能槽的索引
function KG_HERO_TYPE:SwapSlotAt(nCost, nIndex, skill)
	if not nCost or nCost <= 0 then
		cclog("[Error]更换技能槽技能参数错误！@SwapSlotAt")
		return;
	end
	
	--Notify: 现在技能槽只有一个，替换第一个
	local nIndex = 1;
	local nSkillID = skill:GetID()
	local nLevel = skill:GetLevel();

	self.m_objSkillSlot:SetSkillByIndex(nCost, nIndex, nSkillID, nLevel)
	--test
	-- local tbSkillSlot = self.m_objSkillSlot:GetSkills();
	-- print("tbSkillSlot = ")
	-- tst_print_lua_table(tbSkillSlot)
	--test end
end

function KG_HERO_TYPE:GetExp()
	return self.m_nExp;
end

function KG_HERO_TYPE:SetExp(nExp)
	self.m_nExp = nExp or 0;
end

function KG_HERO_TYPE:AddExp(tbHero, nExp)
	-- print("[经验]增加英雄经验", nExp)
	if type(nExp) ~= "number" then
		cclog("[Error]参数类型不正确！@AddExp")
		return;
	end
	local nCur = self:GetExp();
	--是否升级
	local nLevelUpExp = self:GetLevelUpExp();
	local nTotalExp = nCur + nExp
	while(nTotalExp >= nLevelUpExp) do
		self:AddLevel(1)
		nTotalExp = nTotalExp - nLevelUpExp;

		nLevelUpExp = self:GetLevelUpExp();
	end
	self:SetExp(nTotalExp)
	
	-----------------------------
	--和服务器数据校验
	local nLevelS = tbHero.level; 
	local nExpS = tbHero.curExp;
	
	if self:GetLevel() ~= nLevelS or self:GetExp() ~= nExpS then
		cclog("[Error]加经验player客户端和服务器数据不一致！等级(%d-%d), 经验(%d-%d)@KG_HERO_TYPE:AddExp", self:GetLevel(), nLevelS, self:GetExp(), nExpS)
		self:SetExp(nExpS)
		self:SetLevel(nLevelS)
	else
		cclog("[Log]KG_HERO_TYPE:AddExp加经验验证通过!")
	end
	-----------------------------
end

function KG_HERO_TYPE:GetLevelUpExp()
	-- local nExp = math.pow((self:GetLevel() + 8), 3) * 2;
	local nCurLevel = self:GetLevel();
	local nMaxExp = 10000;
	local nNeedExp = nMaxExp;
	-- 配置表experience配置的等级对应的经验即为升级的经验
	if l_tbLevelUpExp[nCurLevel] then
		nNeedExp = l_tbLevelUpExp[nCurLevel].experience or nMaxExp;
	else
		cclog("[Warning]配置表experience没有等级(%d)的配置", nCurLevel +1);
	end

	print("GetLevelUpExp", self:GetLevel(), nNeedExp)
	return nNeedExp;
end

function KG_HERO_TYPE:AddLevel(nLevel)
	if type(nLevel) ~= "number" then
		cclog("[Error]参数类型不正确！@AddLevel")
		return;
	end
	
	self:SetLevel(self:GetLevel() + nLevel)
	
	print("我要升级了", self:GetName(), self:GetLevel(), self:GetPos())
	-- 通知界面升级
	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_LEVELUP, {self:GetPos()});
end


--技能槽数据初始化
function KG_HERO_TYPE:InitSKillSlot(pDate)
	if pDate == nil then 
		return;
	end
	self.m_tbSkillSlot={}

	for k,v in pairs(pDate) do
		self.m_tbSkillSlot[tonumber(k)]=v;
	end


end

--获取指定位置的技能槽等级
function KG_HERO_TYPE:GetSkillSlotLvByIndex(index)
	for k,v in pairs(self.m_tbSkillSlot) do
		if k == index then 
			return v.level
		end
	end

	return 0;
end

--@function: 获取装备索引
function KG_HERO_TYPE:GetEquipSuit()
	-- 第几套装备和位置对应关系
	return self:GetEquipSuitByPos(self:GetPos());
end

--@function: 获取位置对应的装备
function KG_HERO_TYPE:GetEquipSuitByPos(nPos)
	-- 第几套装备和位置对应关系
	return gf_GetEquipSuitByPos(nPos);
end

--@function: 获取英雄品质
function KG_HERO_TYPE:GetQuality()
	return self.m_nQuality;
end

function KG_HERO_TYPE:SetQuality(nQuality)
	self.m_nQuality = nQuality or 0;
end

--@function: 是否品质达到最大了
function KG_HERO_TYPE:IsMaxQuality()
	local nMax = KGC_HERO_FACTORY_TYPE:getInstance():GetMaxQuality();
	return self.m_nQuality >= nMax;
end

--@function: 获取英雄品质对应的资源
--@return: 名字颜色, 英雄类型品质框(圆形), 英雄列表品质框, 英雄星星品质框, 英雄类型品质2(菱形)
function KG_HERO_TYPE:GetResourceByQuality(nQuality)
	local tbConfig = l_tbQualityConfig[nQuality]
	if tbConfig then
		return tbConfig.color, tbConfig.roundpath, tbConfig.squarepath, tbConfig.starpath, tbConfig.edge
	else
		cclog("[Error]没有找到英雄(%s)品质(%s)", self:GetName(), tostring(nQuality))
	end
end

--@function: 获取英雄星级
function KG_HERO_TYPE:GetStars()
	return self.m_nStars;
end

function KG_HERO_TYPE:SetStars(nStar)
	self.m_nStars = nStar or 0;
end

--@function: 获取战斗力
--@计算公式：((攻击力*(1+暴击率)*(1+穿透率)*命中率) * (生命值/(1-减伤比)/闪避率))/100
function KG_HERO_TYPE:GetFightPoint()
--[[
	local n1 = self:GetAttack()*(1+self:GetCritRate())*(1+self:GetPenetrationRate())*self:GetHitRate()
	local nDefRate = self:GetDefendRate(self:GetAttack())	-- 减伤比
	local nTemp = (1-nDefRate) * self:GetDodgeRate();
	local n2 = 0;
	if nTemp ~= 0 then
		n2 = self:GetHP() / nTemp;
	end
	cclog("[获取战斗力]攻击力: %d", self:GetAttack())
	cclog("[获取战斗力]暴击率: %d", self:GetCritRate())
	cclog("[获取战斗力]穿透率: %d", self:GetPenetrationRate())
	cclog("[获取战斗力]命中率：%d", self:GetHitRate())
	cclog("[获取战斗力]生命值：%d", self:GetHP())
	cclog("[获取战斗力]减伤比：%d", self:GetDefendRate(self:GetAttack()))
	cclog("[获取战斗力]闪避率：%d", self:GetDodgeRate())
	print(n1, n2, nTemp)
	local nFP = math.floor((n1 * n2)/100);
]]
	local nFP = self:GetAttack() + self:GetDefend() + self:GetHP();
	return nFP;
end

--@function: 获取等级成长数据
--@return:　生命值、攻击力、防御力
function KG_HERO_TYPE:GetLevelGrowing(nLevel)
	local nLevel = nLevel or 1;
	local nHP, nAttack, nDefend = self:GetALevelGrowing();
	-- local nHP = nHP * (nLevel-1), nAttack*(nLevel-1), nDefend*(nLevel-1);
	return nHP, nAttack, nDefend;
end

--@function：一级的等级成长数据
function KG_HERO_TYPE:GetALevelGrowing()
	local nID = self:GetID();
	local tbConfig = l_tbCharacterConfig[nID];
	if not tbConfig or not tbConfig.grow_base then
		cclog("[Error]配置表没有等级成长数据(nID-%s)", tostring(nID));
		return 0, 0, 0;
	end
	-- x, 血基础值, 攻防基础值
	local x, nHPBase, nADBase = unpack(tbConfig.grow_base);
	local nHPRate, nAtkRate, nDefRate = self:GetStarGrowing(self:GetStars());
	local nLevel = self:GetLevel();
	-- 公式: 武将自然属性=武将成长率*等级*成长基础值+X*成长基础值
	-- 第一个字段的顺序是 {X，血的基础值，攻（防）基础值}  第二个字段是{血，攻，防}
	local nHP = math.floor(nHPRate * nLevel * nHPBase + x * nHPBase);
	local nAttack = math.floor(nAtkRate * nLevel * nADBase + x * nADBase);
	local nDefend = math.floor(nDefRate * nLevel * nADBase + x * nADBase);
	-- print("[log]等级成长计算结果: ");
	-- cclog("\tx = %d, 血基础值 = %d, 攻防基础值 = %d", x, nHPBase, nADBase);
	-- cclog("\t血量 = %d, 攻击 = %d, 防御 = %d", nHP, nAttack, nDefend);
	return nHP, nAttack, nDefend;
end

--@function: 获取星级成才数据
--@return:　生命值、攻击力、防御力
function KG_HERO_TYPE:GetStarGrowing(nStar)
	local nID = self:GetID();
	local tbConfig = l_tbCharacterConfig[nID];
	
	if not tbConfig or not tbConfig.grow_rate then
		cclog("[Error]配置表没有等级成长数据(nID-%s)", tostring(nID));
		return 0, 0, 0;
	end
	local tbStars = tbConfig.grow_rate;
	-- 配置第一个为0星的配置
	local tbData = tbStars[nStar + 1];
	if not tbData then
		cclog("[Error]没有当前星级的成长数据nID(%s), nStar(%s)", tostring(nID), tostring(nStar));
		return 0, 0, 0;
	end
	return unpack(tbData);
end

--@function: 获取品质成才数据
--@return:　生命值、攻击力、防御力
function KG_HERO_TYPE:GetQualityGrowing(nQuality)
	local nQuality = self:GetQuality();
	if nQuality <= 0 then
		return 0, 0, 0;
	end
	
	local tbConfig = l_tbHeroQualityConfig[nQuality];
	if not tbConfig then
		cclog("[Error]配置表没有品质成长数据(nQuality-%s)", tostring(nQuality));
		return 0, 0, 0;
	end
	
	local nAtk, nDef, nHP = tbConfig.hp or 0, tbConfig.def or 0, tbConfig.ap or 0;
	cclog("[log]品质成长数据:");
	cclog("\t生命值增加：%d", nHP);
	cclog("\t攻击力增加：%d", nAtk);
	cclog("\t防御力增加：%d", nDef);
	
	return nHP, nAtk, nDef;
end

--@function: 初始化套装属性
--@nAttrx: 第几个套装属性
function KG_HERO_TYPE:InitSuitAttribute(nAttr1, nAttr2, nAttr3, nAttr4, nAttr5)
	if not self.m_objSuitAttribute then
		self.m_objSuitAttribute = KGC_DATA_HERO_SUIT_ATTRIBUTE.new();
	end

	self.m_objSuitAttribute:Init(nAttr1, nAttr2, nAttr3, nAttr4, nAttr5);
end

--@function: 计算套装属性
--@nStar: 全身开启的星级
function KG_HERO_TYPE:CalcSuitAttribute(nStar)
	if not self.m_objSuitAttribute then
		return;
	end
	
	self.m_objSuitAttribute:CalculateAttribute(nStar);
end

--@function: 获取套装属性描述
function KG_HERO_TYPE:GetSuitAttributeDesc()
	if self.m_objSuitAttribute then
		return self.m_objSuitAttribute:GetSuitAttributeDesc();
	end
end

--@function: 获取某个英雄套装属性大全的描述
function KG_HERO_TYPE:GetAllSuitAttributeDesc()
	if self.m_objSuitAttribute then
		return self.m_objSuitAttribute:GetAllSuitAttributeDesc(self:GetID());
	end
end

--@function: 获取套装属性攻击力提升
--@nAtk: 当前攻击力
function KG_HERO_TYPE:GetAttackBySuitAttribute(nAtk)
	local nAdd = 0;
	if self.m_objSuitAttribute then
		nAdd = self.m_objSuitAttribute:GetAttackAdd(nAtk);
	end
	
	return nAdd;
end

--@function: 获取套装属性防御力提升
--@nDef: 当前攻击力
function KG_HERO_TYPE:GetDefendBySuitAttribute(nDef)
	local nAdd = 0;
	
	if self.m_objSuitAttribute then
		nAdd = self.m_objSuitAttribute:GetDefendAdd(nDef);
	end

	return nAdd;
end

--@function: 获取费用消耗额外值
function KG_HERO_TYPE:GetCostExtra()
	local nSub = 0;
	-- 套装属性减少
	if self.m_objSuitAttribute then
		local nSub1 = self.m_objSuitAttribute:GetCostSub(nSkillID);
		nSub = nSub + nSub1;
	end
	-- test 
	if nSub ~= 0 then
		cclog("[log]套装属性-特定技能释放消耗降低, 费用降低(%d)", nSub);
	end
	-- test end
	return nSub;
end

--@function: 获取技能槽修改协议需要的结构
function KG_HERO_TYPE:GetModifySlotStruct()
	local tbStruct = self.m_objSkillSlot:GetModifySlotStruct();
	tbStruct.heroId = self:GetID();
	return tbStruct;
end

---------------------------------------------------------
-- *** 提示相关 ***
function KG_HERO_TYPE:IsExistNewEquip()
	print("IsNewEquip ............... ");
	-- 更新当前英雄装备

	local nSuit = self:GetEquipSuit();
	local tbEquips = nil;
	if self.m_tbShip then
		tbEquips = self.m_tbShip:GetEquips();
	else
		cclog("[Error]英雄(%d)没有队伍", self:GetID());
		return;
	end
	
	local objEquips = tbEquips[nSuit]
	if not objEquips then
		cclog("[Warnint]装备对象不存在!");
		return;
	end
	local nCount = 0;
	-- 六件装备
	for _, pos in pairs(l_tbEquipPos) do
		local oldEquip = objEquips:GetAEquip(pos);
		local newEquip = me:GetBag():GetBestEquip(pos, oldEquip);
	
		if newEquip then
			nCount = nCount + 1;
		end
	end
	print("要更新的个数为：", nCount);

	return nCount > 0;
end
---------------------------------------------------------
