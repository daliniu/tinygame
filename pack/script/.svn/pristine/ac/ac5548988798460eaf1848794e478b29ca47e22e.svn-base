----------------------------------------------------------
-- file:	base.lua
-- Author:	page
-- Time:	2015/02/02 10:41
-- Desc:	技能基类
--			
----------------------------------------------------------
require "script/core/skill/common/data"
require("script/core/configmanager/configmanager");

local l_tbResultConfig = mconfig.loadConfig("script/cfg/skills/skillresults")
----------------------------------------------------------
local l_tbHitType = def_GetHitTypeData();
local l_tbConfig = def_GetSkillBaseConfigData();
local l_tbPos = def_GetPosData();
local l_tbSkillCastRet = def_GetSkillCastRetData();
local l_tbTargetSelectMethod,l_tbTSMName = def_GetTargetSelectMethondDATA();
local l_tbSkillScope, l_tbSSName = def_GetSkillScopeData()
local l_tbCamp = def_GetFightCampData();
local l_tbEffect = def_GetEffectType();
local l_tbSkillType, l_tbSkillTypeName = def_GetSkillTypeData();

--data struct
local TB_SKILL_BASE_DATA = {
	--config
	------------------------------------
	m_nCost = 0,			--技能所需费用
	m_nID = 0,				--技能ID
	m_szName = "",			--技能名称
	m_szDesc = "",			--技能描述
	m_szIcon = "",			--技能图标
	m_nLevel = 0,			--技能等级
	m_nType = 0,			--技能类型(普通、契约、合作)
	m_nHitType = 0,			--命中类型
	m_nBHR = 100,			--技能基础命中参数
	m_bVam = true,			--是否吸血
	
	m_nCastType = 0,		--释放方式
	m_nCondID = 0,			--触发技能条件ID
	m_nTarCamp = 0,			--目标阵营
	m_nEffID = 0,			--技能效果类型
	m_tbEffData = {			--技能效果数据
		nID = 0,				--技能效果ID
		nType = 0,				--技能效果类型
		tbState = {				--附带状态
			nStaID = 0,				--状态ID
			nConID = 0,				--条件ID
		},
		tbArgs = {}			--参数
	},
	m_tbTargetSelect = {	--目标筛选
		nType = 0,				--方式
		tbPos = {},				--基准位置
		nCost = 0,				--目标费用
		nTarget2 = 0,			--二次目标筛选
		nRangeType = 0,			--范围类型
		nMax = 0,				--最大目标数量
	},
	
	m_tbPartner = {},		--合作者的ID
	------------------------------------
	m_Hero = nil,			--释放技能的对象
	m_tbHeros = {},			--释放技能的对象(有多个)
	m_Targets = nil,		--技能目标
	m_fPro = 0,				--释放概率(m_nfPro%)
	m_Lau = nil,			--选择的攻击源
	m_tbRetStates = {},		--搜集各种状态结果
	m_nCastRet = l_tbSkillCastRet.SUCCESS,	--上一次技能释放结果，用于决定是否重新释放
	m_nRet = l_tbSkillCastRet.FAILED;		--本次技能的释放结果
	m_tbMulCost = {},		--多重施法的费用表
	m_tbUIEffect = {},		--保存临时特效(例如多重施法脚底特效)
}

KGC_SKILL_BASE_TYPE = class("KGC_SKILL_BASE_TYPE", CLASS_BASE_TYPE, TB_SKILL_BASE_DATA)
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_BASE_TYPE:ctor()
	
end

function KGC_SKILL_BASE_TYPE:Init(tbConfig, tbInfo)
-- tst_PrintTime(7000)
	tbConfig = tbConfig or {}
	if tbConfig.nID then
		self.m_nID = tbConfig.nID
	end
	
	if tbConfig.nLevel then
		self.m_nLevel = tbConfig.nLevel or 0;
	end
	-- if tbConfig.nCost then
		-- self.m_nCost = tbConfig.nCost
	-- end
	if tbConfig.fPro then
		self.m_fPro = tbConfig.fPro;
	end
	--读取配置表
	if type(tbInfo) == "table" then
		self:SetName(tbInfo.name)
		self:SetDesc(tbInfo.desc)
		self:SetFightText(tbInfo.fighttext)
		self:SetIcon(tbInfo.icon)
		self:SetCastType(tbInfo.casttype)
		self:SetCost(tbInfo.cost)
		self:SetCondID(tbInfo.conid)
		self:SetType(tbInfo.type)
		self:SetLevel(tbInfo.level)
		self:SetPro(tbInfo.probability)
		self:SetTarCamp(tbInfo.camp)
		self:SetHitType(tbInfo.hittype)
		self:SetEffectByID(tbInfo.skillresultsid)
		
		-- 合作技能
		if type(tbInfo.combo) == "table" then
			self:SetPartner(tbInfo.combo);
		end
	end

	self:OnInit(tbInfo)
end

function KGC_SKILL_BASE_TYPE:OnInit()
	--test
	if self.m_nID == 30011 then
		print("多重施法初始化")
		self:SetPro(100)
	end
	--test end
end

--@function: 战斗逻辑
function KGC_SKILL_BASE_TYPE:Cast(launchers, targets, data)
	if type(launchers) ~= "table" or type(targets) ~= "table" then
		cclog("[Error]Data Error! @Cast()")
		return false;
	end
	
	local tbRet = {}
	
	--默认只攻击一次
	local nRet = l_tbSkillCastRet.SUCCESS;
	--launcher
	local tbRetLaus = {}
	local tbRetDefs = {}
	self.m_tbRetStates = {};			--收集各种状态
	
	-- tst_PrintTime(10000)
	--选择攻击目标
	local launcher = self:GetCaster()
	local nCostMaxOld = launcher:GetFightShip():GetMaxCost();	-- 逻辑中会增加费用上限
	
	-- tst_PrintTime(10001)
	local nTot = 0;	--总伤害(计算吸血)
	for _, def in pairs(targets) do
		-- tst_PrintTime(12000)
		--命中类型检测
		local bHit = self:IsHit(launcher, def);
		if bHit then
			--暴击检测
			local bCrit = self:IsCrit(launcher, def);
			-- tst_PrintTime(12000)
			--伤害结算
			local data, nDamage, nRetTemp = self:CalcLogic(launcher, def, bCrit)
			-- tst_PrintTime(12001)
			nRet = nRetTemp;
			nTot = nTot + nDamage;
			table.insert(tbRetDefs, data)
		else
			--miss
			print("[log]miss了");
			local data = KGC_DATA_DEFEND_SAVE_TYPE.new()
			data:Init(false, def:GetPos(), def:GetFightShip():GetCamp(), def, self)
			table.insert(tbRetDefs, data);
		end
		-- tst_PrintTime(12002)
	end
	-- tst_PrintTime(10002)
	--计算吸血
	for _, lau in pairs(launchers) do
		local data = KGC_DATA_LAUNCHER_SAVE_TYPE.new()
		local nVam = 0;
		if lau == launcher then
			if self:IsVam() then
				nVam = self:CalcVampire(launcher, nTot);
			end
		end
		data:Init(lau:GetPos(), lau:GetFightShip():GetCamp(), lau, self, bCrit, bCA, nVam);
		if lau == launcher then
			data:SetSrc(true)
			print("设置攻击者的位置为@SetSrc：", launcher:GetPos(), launcher:GetFightShip():GetCamp())
			local nBefore, nChange = lau:GetFightShip():GetTempCost();
			local nCostMaxNew = lau:GetFightShip():GetMaxCost()
			cclog("[log]skillbase(%s)当前费用：%d, 之前总费用:%d, before:%d, nChange:%d， 之后总费用: %d", self:GetName(), lau:GetFightShip():GetCost(), nCostMaxOld, nBefore or 0, nChange or 0, nCostMaxNew)
			data:SetCost(lau:GetFightShip():GetCost(), nCostMaxOld, nBefore, nChange, nCostMaxNew);
		end
		table.insert(tbRetLaus, data);
	end
	-- tst_PrintTime(10003)
	--test
	print("生成状态结果个数", #(self.m_tbRetStates or {}))
	--反击流程
	self:CalcCounterAttack(launcher, tbRetLaus, tbRetDefs)
	
	--触发技能：释放<>触发
	self:StartTriggerSkillsCondition(nil, targets);
	-- tst_PrintTime(10004)
	print("nRet", nRet)
	self.m_nRet = nRet;
	return tbRetLaus, tbRetDefs, self.m_tbRetStates, nRet;
end

--@function: 真实命中率
function KGC_SKILL_BASE_TYPE:CalcRealHitRate(launcher, defend)
	-- print("CalcRealHitRate")
	--命中修正系数(/100)
	local objLau = launcher:GetHeroObj()
	local objDef = defend:GetHeroObj()
	local nFactor = (objLau:GetLevel() - objDef:GetLevel())/100;
	local nRate = objLau:GetHitRate() - objDef:GetDodgeRate() + nFactor
	-- print("修正系数，命中率，闪避率：", nFactor, objLau:GetHitRate(), objDef:GetDodgeRate())
	
	local nMin = 0.1;
	if nRate < nMin then
		nRate = nMin;
	end
	--保留一位小数
	-- print("真实命中率:", nRate)
	return gf_GetPreciseDecimal(nRate, 3);
end

--@function: 技能命中率计算公式
function KGC_SKILL_BASE_TYPE:CalcSkillHitRate(launcher, defend)
	local objLau = launcher:GetHeroObj()
	local objDef = defend:GetHeroObj()
	--命中修正系数(/100)
	local nFactor = (objLau:GetLevel() - objDef:GetLevel())/100;
	local nRate = self.m_nBHR/100 + objLau:GetHitRate() + nFactor;
	print("CalcSkillHitRate", nRate)
	return nRate;
end

--@function: 真实暴击率
function KGC_SKILL_BASE_TYPE:CalcRealCritRate(launcher, defend)
	local objLau = launcher:GetHeroObj()
	local objDef = defend:GetHeroObj()
	--命中修正系数(/200)
	local nFactor = (objLau:GetLevel() - objDef:GetLevel())/200;
	local nRate = objLau:GetCritRate() - objDef:GetNoCritRate() + nFactor
	
	-- Page@2015/11/05 - hss 修改：0.05-->0.01
	local nMin = 0.01
	-- local nMin = 0;
	if nRate < nMin then
		nRate = nMin;
	end

	return nRate;
end

--@function: 获取合击技能的合作者
function KGC_SKILL_BASE_TYPE:GetPartner()
	if not self.m_tbPartner then
		self.m_tbPartner = {};
	end
	return self.m_tbPartner;
end

function KGC_SKILL_BASE_TYPE:SetPartner(tbConfig)
	local tbConfig = tbConfig or {};
	for _, nHeroID in pairs(tbConfig) do
		self:AddPartner(nHeroID);
	end
	
	-- test
	print("合体技能的合作伙伴为：");
	local tbPartner = self:GetPartner();
	for _, nHeroID in pairs(tbPartner) do
		print("\t", nHeroID);
	end
	-- test end
end

--@function: 增加合体技能合作伙伴
function KGC_SKILL_BASE_TYPE:AddPartner(nHeroID)
	local tbPartner = self:GetPartner();
	table.insert(tbPartner, nHeroID);
end

function KGC_SKILL_BASE_TYPE:SetHitType(nType)
	nType = nType or 0;
	self.m_nHitType = nType;
end

function KGC_SKILL_BASE_TYPE:GetHitType()
	return self.m_nHitType;
end

function KGC_SKILL_BASE_TYPE:GetPartner()
end

function KGC_SKILL_BASE_TYPE:IsSkill()
	return true;
end

function KGC_SKILL_BASE_TYPE:IsCombo()
	return false;
end

function KGC_SKILL_BASE_TYPE:GetCost()
	return self.m_nCost or 0;
end

function KGC_SKILL_BASE_TYPE:SetCost(nCost)
	self.m_nCost = nCost or 0;
end

function KGC_SKILL_BASE_TYPE:SetHeros(tbHeros)
	if type(tbHeros) ~= "table" then
		return;
	end
	
	self.m_tbHeros = tbHeros
	self.m_Hero = tbHeros[1]
end

function KGC_SKILL_BASE_TYPE:GetHeros()
	return self.m_tbHeros;
end

--@function: 获取技能释放者
function KGC_SKILL_BASE_TYPE:GetCaster()
	return self.m_Hero;
end

function KGC_SKILL_BASE_TYPE:GetNpc()
	return self.m_Hero;
end

function KGC_SKILL_BASE_TYPE:SetPro(pro)
	pro = pro or 0;
	self.m_fPro = pro;
end

function KGC_SKILL_BASE_TYPE:GetPro()
	return self.m_fPro;
end

function KGC_SKILL_BASE_TYPE:GetID()
	return self.m_nID;
end

function KGC_SKILL_BASE_TYPE:GetName()
	return self.m_szName;
end

function KGC_SKILL_BASE_TYPE:SetName(szName)
	self.m_szName = szName or "";
end

function KGC_SKILL_BASE_TYPE:SetDesc(szDesc)
	self.m_szDesc = szDesc or "";
end

function KGC_SKILL_BASE_TYPE:GetDesc()
	return self.m_szDesc;
end

function KGC_SKILL_BASE_TYPE:SetFightText(szText)
	self.m_szFightText = szText or "";
end

--@function: 战斗界面的播报显示
function KGC_SKILL_BASE_TYPE:GetFightText()
	return self.m_szFightText;
end

function KGC_SKILL_BASE_TYPE:SetIcon(szIcon)
	self.m_szIcon = szIcon or "";
end

function KGC_SKILL_BASE_TYPE:GetIcon()
	return self.m_szIcon;
end

function KGC_SKILL_BASE_TYPE:SetCastType(nType)
	nType = nType or 0;
	self.m_nCastType = nType;
end

function KGC_SKILL_BASE_TYPE:GetCastType()
	return self.m_nCastType;
end

function KGC_SKILL_BASE_TYPE:SetCondID(nCondID)
	self.m_nCondID = nCondID or 0;
end

function KGC_SKILL_BASE_TYPE:GetCondID()
	return self.m_nCondID;
end

function KGC_SKILL_BASE_TYPE:SetType(nType)
	self.m_nType = nType or 0;
end

function KGC_SKILL_BASE_TYPE:GetType()
	return self.m_nType;
end

function KGC_SKILL_BASE_TYPE:SetLevel(nLevel)
	self.m_nLevel = nLevel or 0;
end

function KGC_SKILL_BASE_TYPE:GetLevel()
	return self.m_nLevel;
end

function KGC_SKILL_BASE_TYPE:SetTarCamp(nCamp)
	self.m_nTarCamp = nCamp or 0;
end

function KGC_SKILL_BASE_TYPE:GetTarCamp()
	return self.m_nTarCamp;
end

function KGC_SKILL_BASE_TYPE:SetEffectByID(nID)
	-- tst_PrintTime(9000)
	self.m_nEffID = nEffectType or 0;
	-- tst_PrintTime(9001)
	local tbEffect = l_tbResultConfig[nID]
	if not tbEffect then
		print("[Error]配置表错误或者ID错误, nID = ", nID)
	end
	local tbData = self:GetEffectData();
	tbData.nID = tbEffect.id
	tbData.nType = tbEffect.effecttype;
	-- print("SetEffectByID", tbData.nType)
	-- print("GetEffectType", self:GetEffectType());
	tbData.tbState = tbData.tbState or {}
	if type(tbEffect.status) == "table" then
		tbData.tbState.nStaID = tbEffect.status[1] or 0;
		tbData.tbState.nConID = tbEffect.status[2] or 0;
	end
	tbData.tbDisPel = tbEffect.dispel;
	tbData.tbArgs[1] = tbEffect.arg1
	tbData.tbArgs[2] = tbEffect.arg2
	tbData.tbArgs[3] = tbEffect.arg3
	tbData.tbArgs[4] = tbEffect.arg4
	tbData.tbArgs[5] = tbEffect.arg5
	tbData.tbArgs[6] = tbEffect.arg6
	tbData.tbArgs[7] = tbEffect.arg7
	tbData.tbArgs[8] = tbEffect.arg8
	-- tst_PrintTime(9002)
end

function KGC_SKILL_BASE_TYPE:GetEffectData()
	if not self.m_tbEffData then
		self.m_tbEffData = {}
	end
	return self.m_tbEffData;
end

function KGC_SKILL_BASE_TYPE:GetEffectID()
	local tbData = self:GetEffectData()
	return tbData.nID;
end

function KGC_SKILL_BASE_TYPE:GetEffectType()
	local tbData = self:GetEffectData()
	return tbData.nType;
end

function KGC_SKILL_BASE_TYPE:GetEffectArgs()
	local tbData = self:GetEffectData()
	return tbData.tbArgs;
end

function KGC_SKILL_BASE_TYPE:GetEffectState()
	local tbData = self:GetEffectData()
	return tbData.tbState.nStaID, tbData.tbState.nConID;
end

function KGC_SKILL_BASE_TYPE:IsSameSkill(skill)
	--首先比较ID
	if skill:IsSkill() and skill:GetID() == self:GetID() then
		local heros1 = self:GetHeros()
		local heros2 = skill:GetHeros()

		local tbPos1, tbPos2 = {}, {}
		for _, hero in pairs(heros1) do
			-- print("heros1, pos", hero:GetPos())
			table.insert(tbPos1, hero:GetPos())
		end
		table.sort(tbPos1)
		for _, hero in pairs(heros2) do
			-- print("heros2, pos", hero:GetPos())
			table.insert(tbPos2, hero:GetPos())
		end
		table.sort(tbPos2)
		if #tbPos1 == #tbPos2 then
			local nCount = 0;
			for i=1, #tbPos1 do
				if tbPos1[i] ~= tbPos2[i] then
					break;
				end
				nCount = nCount + 1;
			end
			if nCount == #tbPos1 then
				return true;
			end
		end
	end
	return false;
end

--@function: 判断技能是否是普通技能
function KGC_SKILL_BASE_TYPE:IsNormal()
	local nType = self:GetType();
	if l_tbSkillType.NORMAL_0 == nType then
		return true;
	end
	
	return false;
end

--@function: 获取技能类型对应的名字-->技能面板
function KGC_SKILL_BASE_TYPE:GetTypeName()
	local nType = self:GetType();
	return l_tbSkillTypeName[nType] or "";
end
----------------------------------------------------------

--relization

----------------------------------------------------------
--test
----------------------------------------------------------