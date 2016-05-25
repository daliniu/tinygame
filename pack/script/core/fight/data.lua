----------------------------------------------------------
-- file:	fight.lua
-- Author:	page
-- Time:	2015/01/31 14:19
-- Desc:	战斗系统需要的数据
--			
----------------------------------------------------------
-- require "script/core/fight/__init__"
require "script/lib/definefunctions"
require "script/core/npc/head"
require "script/core/fight/constract_queue"
require "script/core/fight/state_queue"
----------------------------------------------------------
local l_tbFSIndex, l_tbFightState = def_GetFightStateData()
local l_tbCamp = def_GetFightCampData();
local l_tbPos = def_GetPosData();
local l_tbCondID, l_tbCondName = def_GetConditionData();
local l_tbCondLevel = def_GetCondLevel();
local l_tbSkillCastRet = def_GetSkillCastRetData();
local l_tbSpeStateID, l_tbSpeStateName = def_GetSpecialStateData();
local l_tbStateShowType = def_GetStateShowType();
local l_tbStateCheckType, l_tbStateCheckTypeName = def_GetStateCheckType();
local l_tbConfigOthers = require ("script/cfg/other/config")

--1. 战斗过程数据
----------------------------------------
--(1)fight role

local TB_DATA_FIGHTING_HERO = {
	hero = nil,
	ship = nil, 
	tbFightInfo = {
		nPos = 0,								--位置信息，有可能被击到别的位置
		nHP= 0,									--血量
		nMaxHP = 0,								--最大血量(战斗过程会变化)
		nCost = 0,								--费用
		nState = 0,								--状态{死亡}
		tbState = {},							--状态表
		tbNpcAttribute = {						--特殊一些魔法属性:buff类
			--在前还是后，直接作为属性类的一个成员
		nCARate = 0,							--反击概率
		nVamEff = 0,							--吸血效率
		},
		
		--属性
		nAtk = 0,				--攻击力
		nDef = 0,				--防御力
		-- nAc = 0,				--减伤比(减伤比是计算来的,只存一个就好了)
		-- nPL = 0,				--穿透等级(伤害加深比)
		-- nCL = 0,				--暴击等级(暴击率)
		-- nTL = 0,				--韧性等级(免爆率)
		-- nHL = 0,				--命中等级(命中率)
		-- nDL = 0,				--闪避等级(闪避率)
		-- nCAL = 0,				--反击等级(反击率)
		-- nVL = 0,				--吸血等级(吸血率)
		
		nPR = 0,				--伤害加深比
		nCR = 0,				--暴击率
		nTR = 0,				--免爆率
		nHR = 0,				--命中率
		nDR = 0,				--闪避率
		nCAR = 0,				--反击率
		nVR = 0,				--吸血率
		
		-- nHLF = 100,				--命中率调整系数
		-- nDLF = 100,				--闪避率调整系数
		-- nCLF = 100,				--暴击率调整系数
		-- nTLF = 100,				--免爆率调整系数
		-- nAtkF = 4,				--减伤比调整系数
		-- nPLF = 100,				--穿透率调整系数
		-- nCALF = 10,				--反击率调整系数
		-- nVLF = 10,				--吸血率调整系数
	},
	--魔法属性队列
	m_StateQueue = nil,
}

KGC_DATA_FIGHTING_NPC_TYPE = class("KGC_DATA_FIGHTING_NPC_TYPE", KGC_OBS_OBJECT_BASE_TYPE, TB_DATA_FIGHTING_HERO)

function KGC_DATA_FIGHTING_NPC_TYPE:ctor()
	--状态
	self.m_StateQueue = KGC_STATE_QUEUE_BASE_TYPE.new();
end

function KGC_DATA_FIGHTING_NPC_TYPE:Init(hero, ship)	
	self.hero = hero;
	self:SetFightShip(ship)
	
	self:SetPos(hero:GetPos())
	self:SetHP(hero:GetHP())
	self:SetMaxHP(hero:GetHP())
	-- self:SetCost(hero:GetCost())
	self:SetState(l_tbFSIndex.LIFE, l_tbFightState[l_tbFSIndex.LIFE].ALIVE)
	self:SetState(l_tbFSIndex.ATTACKABLE, true);
	
	--设置属性
	self:SetAttack(hero:GetAttack());
	self:SetDefend(hero:GetDefend())
	-- self:SetPR(hero:GetPR())
	self:SetCR(hero:GetCritRate())
	self:SetDR(hero:GetDodgeRate())
	self:SetPR(hero:GetPenetrationRate())
	
	self.m_StateQueue:SetNpc(self);
	print("fight npc init: ", hero:GetName(), ship:GetCamp(), tostring(self))
	self:AttachSubject(g_CondTrigger, hero, ship:GetCamp())
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetFightInfo()
	if not self.tbFightInfo then
		self.tbFightInfo = gf_CopyTable(TB_DATA_FIGHTING_HERO.tbFightInfo)
	end
	
	return self.tbFightInfo;
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetPos()
	return self:GetFightInfo().nPos;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetPos(nPos)
	self:GetFightInfo().nPos = nPos;
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetHP()
	-- print("fight npc ,hp = ", self:GetFightInfo().nHP, self:GetName())
	return self:GetFightInfo().nHP;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetHP(nHP)
	-- print("fight npc, hp = ", nHP, self:GetName())
	nHP = nHP or 0
	self:GetFightInfo().nHP = nHP;
	
	self:GetFightShip():UpdateHP()
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetMaxHP()
	local tbFight = self:GetFightInfo()
	return tbFight.nMaxHP;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetMaxHP(nHP)
	local tbFight = self:GetFightInfo()
	tbFight.nMaxHP = nHP or 0;
end

-- function KGC_DATA_FIGHTING_NPC_TYPE:GetCost()
	-- return self:GetFightInfo().nCost;
-- end

-- function KGC_DATA_FIGHTING_NPC_TYPE:SetCost(nCost)
	-- nCost = nCost
	-- self:GetFightInfo().nCost = nCost;
-- end

-- function KGC_DATA_FIGHTING_NPC_TYPE:GetState()
	-- return self:GetFightInfo().nState;
-- end

-- function KGC_DATA_FIGHTING_NPC_TYPE:SetState(nState)
	-- nState = nState or 0
	-- if type(nState) ~= "number" or nState > KGC_NAMESPACE_FIGHT.STATE_FIGHT_END then
		-- cclog("[Error]状态数值错误！")
		-- return false;
	-- end
	-- self:GetFightInfo().nState = nState;
	-- return true;
-- end

function KGC_DATA_FIGHTING_NPC_TYPE:GetStateTable()
	local tbFight = self:GetFightInfo()
	if not tbFight.tbState then
		tbFight.tbState = {};
	end
	return tbFight.tbState;
end

--@function: 获取状态
function KGC_DATA_FIGHTING_NPC_TYPE:GetState(nType)
	nType = nType or 0;
	if type(nType) ~= "number" then
		cclog("[Error]状态类型不是数字！")
		return false;
	end
	if nType < 0 or nType > l_tbFSIndex.SUM then
		cclog("[Error]状态索引不在有效范围内(%d)", nType);
		return false;
	end
	local tbState = self:GetStateTable()
	return tbState[nType]
end

--@function: 设置状态
function KGC_DATA_FIGHTING_NPC_TYPE:SetState(nType, nState)
	if type(nType) ~= "number" then
		cclog("[Error]状态类型不是数字！")
		return false;
	end
	if nType < 0 or nType > l_tbFSIndex.SUM then
		cclog("[Error]状态索引不在有效范围内(%d)", nType);
		return false;
	end
	
	-- if type(nState) ~= "number" then
		-- cclog("[Error]状态数值错误！")
		-- return false;
	-- end
	--英雄不死之身 = =
	local bRet = true;					
	if self:GetHeroObj():IsHero()  then
		if nState == l_tbFightState[l_tbFSIndex.LIFE].DEAD then
			bRet = false;
		end
	end
	
	--不直接判断nState：nState也可以是false等值
	if bRet then
		local tbState = self:GetStateTable()
		tbState[nType] = nState;
	end
	return true;
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetHeroObj()
	return self.hero;
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetFightShip()
	return self.ship;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetFightShip(tbShip)
	self.ship = tbShip;
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetCARate()
	local tbFight = self:GetFightInfo()
	return tbFight.nCARate or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetCARate(nRate)
	nRate = nRate or 0;
	local tbFight = self:GetFightInfo()
	tbFight.nCARate = nRate;
end

--@function: 获取吸血效率
function KGC_DATA_FIGHTING_NPC_TYPE:GetVamEff()
	local tbFight = self:GetFightInfo()
	return tbFight.nVamEff or 0;
end

--@function: 设置吸血效率
function KGC_DATA_FIGHTING_NPC_TYPE:SetVamEff(nEff)
	nEff = nEff or 0;
	local tbFight = self:GetFightInfo()
	tbFight.nVamEff = nEff;
end

function KGC_DATA_FIGHTING_NPC_TYPE:Death()	
	self:SetState(l_tbFSIndex.LIFE, l_tbFightState[l_tbFSIndex.LIFE].DEAD)
	
	--生物队列没有反应,在CondUpdate中RemoveMemeber
	-- if not self:GetHeroObj():IsHero() then
		-- self:GetFightShip():RemoveMember(self)
	-- end
	
	cclog("(%s)npc死亡: 是否英雄(%s), 位置(%d), 条件ID(%d)", self:GetName(), tostring(self:GetHeroObj():IsHero()), self:GetPos(), l_tbCondID.DEAD)
	cclog("[消息]%s(%s)发送死亡消息, 自己接收(CondUpdate)", self:GetName(), tostring(self))
	local tbRet = g_CondTrigger:Notify(self, l_tbCondID.DEAD)
	
	return tbRet;
end

function KGC_DATA_FIGHTING_NPC_TYPE:CondUpdate(obj, id)
	cclog("条件(%s)触发(%s)fight/data npc:CondUpdate, obj(%s) == self(%s) => %s", l_tbCondName[id], self:GetName(), tostring(obj), tostring(self), tostring(obj == self))
	if obj == self and id == l_tbCondID.DEAD then		-- 死亡
		local ship = self:GetFightShip();
		cclog("英雄(位置：%d)收到死亡广播前：队伍个数(%d)", self:GetPos(), #ship:GetHeros())
		ship:RemoveMember(self)
		cclog("英雄(位置：%d)收到死亡广播前: 队伍个数(%d)", self:GetPos(), #ship:GetHeros())
		
		local queue = ship:GetQueue(self:GetPos())
		print(string.format("队列还有生物：%s个", tostring(queue and queue:GetSize())))
		if queue and queue:GetSize() > 0 then
			local npc, data = queue:Pop()
			ship:AddMember(npc)
			print("队列npc, data, 位置, data, data.GetElem", npc, npc and npc:GetPos(), data, data and data.GetElem)
			-- return {self, data};
			return data;
		end
	end
	
	--不在场上的生物不触发
	if not self:GetState(l_tbFSIndex.JOIN) then
		return;
	end
	
	cclog("角色阵营:%d, 角色位置：%d", self:GetFightShip():GetCamp(), self:GetPos())
	local tbTriggerSkills = self:GetHeroObj():GetTriggerSkills() or {};
	local tbSkills = {}
	
	if not g_tbTriggerSkills then
		g_tbTriggerSkills = {}
	end
	
	for _, skill in ipairs(tbTriggerSkills) do
		local tbArgs = skill:GetEffectArgs();
		--己方还是敌方
		local nCamp = tbArgs[8] or 0
		
		if id == skill:GetCondID() then
			cclog("触发技能:%s，触发释放技能条件%s(%d)", skill:GetName(), l_tbCondName[id], id)
			if id == l_tbCondID.FAITH then
				-- 获取技能的受击对象
				local tbTargets = obj:GetTargetObj();
				for _, v in pairs(tbTargets or {}) do
					cclog("检查英雄%s触发信念：是否触发(%s)", v:GetHeroObj():GetName(), tostring(v == self));
					if v == self then
						-- 设置技能释放者
						skill:SetHeros({self})
						table.insert(g_tbTriggerSkills, skill);
					end
				end
			else
				local nSkillCamp = obj:GetCaster():GetFightShip():GetCamp();
				local nSelfCamp = self:GetFightShip():GetCamp();
				cclog("技能阵营(%d), 角色自己阵营(%d), 触发条件阵营(%d)", nSkillCamp, nSelfCamp, nCamp)
				if (nCamp == l_tbCamp.MINE and (nSkillCamp == nSelfCamp)) or
					(nCamp == l_tbCamp.ENEMY and (nSkillCamp ~= nSelfCamp)) then
					skill:SetHeros({self});
					table.insert(g_tbTriggerSkills, skill);
				end
			end
		end
	end
	cclog("条件(%s)触发技能个数(%d)", l_tbCondName[id], #(g_tbTriggerSkills or {}))
	
	-- return tbTriggerSkills;
end

--状态系列
function KGC_DATA_FIGHTING_NPC_TYPE:GetStateQueue()
	return self.m_StateQueue;
end

--@function: 状态检测统一接口
--@nType: 状态检测类型(和状态带的效果类型有相同和不同之处)
--@return: 生效的状态-->状态生效处理逻辑
function KGC_DATA_FIGHTING_NPC_TYPE:StateCheck(skill, nType, nValue)
	if nType == l_tbStateCheckType.SHIELD then
		return self:GetSubDamage(skill, nType, nValue);
	elseif nType == l_tbStateCheckType.ATTACK or
		nType == l_tbStateCheckType.DEFEND then
		return self:CalcState(nType, nValue);
	elseif nType == l_tbStateCheckType.FLY or
		nType == l_tbStateCheckType.TAUNT or
		nType == l_tbStateCheckType.DEXTERITY or
		nType == l_tbStateCheckType.IMMUNE or
		nType == l_tbStateCheckType.EXILE or
		nType == l_tbStateCheckType.STUN or
		nType == l_tbStateCheckType.FLAG then
		return self:FindState(nType)
	end
end

--@function: 
function KGC_DATA_FIGHTING_NPC_TYPE:FindState(nType)
	local queue = self:GetStateQueue()
	local tbElem = queue:GetAll()
	for _, elem in ipairs(tbElem) do
		local bRet, state = elem:IsPropertyExist(nType)
		if bRet then
			elem:Work();
			return bRet, {elem};
		end
	end
	
	return false;
end

function KGC_DATA_FIGHTING_NPC_TYPE:CalcState(nType)
	local queue = self:GetStateQueue();
	local tbElem = queue:GetAll()
	local nSum = 0;
	local tbState = {};
	for _, elem in ipairs(tbElem) do
		local nValue = elem:CalcValue(nType) or 0;
		if type(nValue) == "number" and nValue ~= 0 then
			nSum = nSum + nValue
			elem:Work();
			table.insert(tbState, elem);
		end
	end
	cclog("(%s) CalcValue总数为：%d", l_tbStateCheckTypeName[nType], nSum)
	return nSum, tbState;
end

--@function: 获取减伤
function KGC_DATA_FIGHTING_NPC_TYPE:GetSubDamage(skill, nType, nVal)
	local queue = self:GetStateQueue();
	local tbElem = queue:GetAll()
	local nSum = 0;
	local tbState = {};
	local tbRet = {}
	local nLeft = nVal or 0;
	for _, elem in ipairs(tbElem) do
		local nValue = elem:CalcValue(nType) or 0;
		if type(nValue) == "number" and nValue ~= 0 then
			nSum = nSum + nValue
			
			--注意：下面这种写法表示数值大于0的时候，状态才生效
			if nLeft > 0 then
				local bRet, data = elem:Work(nLeft, nValue);
				if data then
					data:SetTriggerConID(l_tbCondID.GET_HURT)
					table.insert(tbRet, data);
					table.insert(tbState, elem);
					nLeft = nLeft - nValue
				end
			end
		end
	end
	if skill then
		print("skill AddRetState", skill, #tbRet)
		skill:AddStateRet(tbRet)
	end
	cclog("(%s) GetSubDamage总数为：%d", l_tbStateCheckTypeName[nType], nSum)
	return nSum, tbState;
end

--@function: 获取防御力
function KGC_DATA_FIGHTING_NPC_TYPE:GetDefend()
	local tbInfo = self:GetFightInfo()
	return tbInfo.nDef;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetDefend(nDefense)
	local tbInfo = self:GetFightInfo()
	tbInfo.nDef = nDefense or 0;
end

--@function: 获取攻击力
function KGC_DATA_FIGHTING_NPC_TYPE:GetAttack(skill)
	local tbInfo = self:GetFightInfo()
	local nAttack = tbInfo.nAtk;
	
	--状态
	-- local queue = self:GetStateQueue();
	-- local tbElem = queue:GetAll()
	-- local nSum = 0;
	-- for _, elem in ipairs(tbElem) do
		-- nSum = nSum + elem:GetAttackAmend()
	-- end
	local nSum = self:StateCheck(skill, l_tbStateCheckType.ATTACK)
	--test
	print("战斗力前后变化：", nAttack, nAttack + nSum)
	--test end
	return nAttack + nSum;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetAttack(nAttack)
	local tbInfo = self:GetFightInfo()
	tbInfo.nAtk = nAttack or 0;
end

--@function: 伤害加深比
function KGC_DATA_FIGHTING_NPC_TYPE:GetPR()
	local tbFight = self:GetFightInfo();
	return tbFight.nPR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetPR(nPR)
	local tbFight = self:GetFightInfo();
	tbFight.nPR = nPR or 0;
end

--@function: 暴击率
function KGC_DATA_FIGHTING_NPC_TYPE:GetCR()
	local tbFight = self:GetFightInfo();
	return tbFight.nCR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetCR(nCR)
	local tbFight = self:GetFightInfo();
	tbFight.nCR = nCR or 0;
end

--@function: 免爆率
function KGC_DATA_FIGHTING_NPC_TYPE:GetTR()
	local tbFight = self:GetFightInfo();
	return tbFight.nTR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetTR(nTR)
	local tbFight = self:GetFightInfo();
	tbFight.nTR = nTR or 0;
end

--@function: 命中率
function KGC_DATA_FIGHTING_NPC_TYPE:GetHR()
	local tbFight = self:GetFightInfo();
	return tbFight.nHR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetHR(nHR)
	local tbFight = self:GetFightInfo();
	tbFight.nHR = nHR or 0;
end

--@function: 闪避率
function KGC_DATA_FIGHTING_NPC_TYPE:GetDR()
	local tbFight = self:GetFightInfo();
	return tbFight.nDR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetDR(nDR)
	local tbFight = self:GetFightInfo();
	tbFight.nDR = nDR or 0;
end

--@function: 反击率
function KGC_DATA_FIGHTING_NPC_TYPE:GetCAR()
	local tbFight = self:GetFightInfo();
	return tbFight.nCAR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetCAR(nCAR)
	local tbFight = self:GetFightInfo();
	tbFight.nCAR = nCAR or 0;
end

--@function: 吸血率
function KGC_DATA_FIGHTING_NPC_TYPE:GetVR()
	local tbFight = self:GetFightInfo();
	return tbFight.nVR or 0;
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetVR(nVR)
	local tbFight = self:GetFightInfo();
	tbFight.nVR = nVR or 0;
end

--@function: 减伤比计算公式(launcher-->self)
-- function KGC_DATA_FIGHTING_NPC_TYPE:GetDefendRate(launcher)
	-- local tbFight = self:GetFightInfo()
	-- local nRate = 0;
	-- local nDividend = self:GetDefend();

	-- if tbFight.nAtkF ~= 0 then
		-- nDividend = nDividend + launcher:GetAttack()/tbFight.nAtkF
	-- end
	-- if nDividend ~= 0 then
		-- nRate = self:GetDefend()/nDividend;
	-- end
	-- print(nRate, "减伤比计算公式：", self:GetDefend(), nDividend, launcher:GetAttack(), tbFight.nAtkF, self:GetDefend())
	-- --保留一位小数
	-- return gf_GetPreciseDecimal(nRate, 1)
-- end

function KGC_DATA_FIGHTING_NPC_TYPE:UnInit()
	-- print("OnExit UnInit ... ", self:GetPos(), self:GetHeroObj():GetName())
	local queueState = self:GetStateQueue();
	queueState:UIUnInit();
end

--ui
if not _SERVER then
function KGC_DATA_FIGHTING_NPC_TYPE:CondUpdateUI(data, uiWidget, nID)
	-- print("UpdateUI...", data, nID, data and data.GetElem)
	if nID == l_tbCondID.DEAD then
		local queue = self:GetFightShip():GetQueue(self:GetPos())
		queue:CondUpdateUI(data, uiWidget, nID)
	end
	-- local queue
	print("[Log]NPC触发回调CondUpdateUI end ...")
end

function KGC_DATA_FIGHTING_NPC_TYPE:UIInitStateQueue(panel, fightview)
	local queue = self:GetStateQueue()
	queue:UIInit(panel, fightview)
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetStateQueueFlag()
	local queue = self:GetStateQueue()
	return queue:GetFlag();
end

function KGC_DATA_FIGHTING_NPC_TYPE:ChangeFullState()
	-- local tbHeros = self:GetFightShip:GetHeros()
	local queue = self:GetStateQueue()
	print("ChangeFullState-nFlag", queue:GetFlag())
	if queue:GetFlag() == 1 then
		queue:ShowNormal()
	else
		queue:ShowFull()
	end
end

function KGC_DATA_FIGHTING_NPC_TYPE:SetStateVisible(bVisible)
	local bVisible = bVisible or false;
	local queue = self:GetStateQueue()
	queue:SetVisible(bVisible)
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetStateVisible()
	local queue = self:GetStateQueue()
	return queue:GetVisible()
end

function KGC_DATA_FIGHTING_NPC_TYPE:GetName()
	return self:GetHeroObj():GetName() or "";
end

end

--(2)fight ship

local TB_DATA_FIGHTING_SHIP = {
	--config
	m_nMaxQueue = l_tbConfigOthers.nMaxContractQueue,			--契约生物队列最大长度
	----------------------------------------
	m_Ship = nil, 								--保存依赖关系
	m_nHP = 0,
	m_nCost = 0,
	m_nMaxCost = 0,								--最大费用
	m_nMaxCostAdd = 0,							-- 属性增加的最大费用量
	m_tbCost = {								--费用变化数据
		nBefore = 0,								-- 改变之前的数量
		nChange = 0,								-- 改变的数量
	},
	m_tbHeros = {},								-- 保存战斗过程中NPC
	m_tbInitHeros = {},							-- 保存初始化时候的NPC
	m_nCamp = 0,								--阵营
	m_tbQueue = {								--契约生物队列
		--[pos] = nil,
	},			
}


KGC_DATA_FIGHTING_SHIP_TYPE = class("KGC_DATA_FIGHTING_SHIP_TYPE", KGC_DATA_BASE_TYPE, TB_DATA_FIGHTING_SHIP)

function KGC_DATA_FIGHTING_SHIP_TYPE:ctor()
end

function KGC_DATA_FIGHTING_SHIP_TYPE:Init(tbShip)
	self.m_Ship = tbShip;
	self.m_tbHeros = {};
	self.m_tbInitHeros = {};
	--2015/02/09 : 共用血条和费用
	self.m_nHP = 0
	self.m_nCost = 0;
	self.m_nMaxCost = 0;
	self.m_nMaxCostAdd = 0;
	
	if tbShip then
		local tbHeros = tbShip:GetHeros() or {}
		for _, hero in pairs(tbHeros) do
			cclog("\t初始化英雄(%s), 位置(%d)", hero:GetName(), hero:GetPos())
			local heroData = KGC_DATA_FIGHTING_NPC_TYPE.new()
			heroData:Init(hero, self)
			table.insert(self.m_tbInitHeros, heroData)
			self:AddMember(heroData)
		end
	end
	print("Init...", #self.m_tbHeros, self.m_nHP)
	self:UpdateHP();
	--end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetFightData(tbShip)
	if not self.m_tbFightData then
		self.m_tbFightData = {}
	end
	return self.m_tbFightData[tbShip];
end

function KGC_DATA_FIGHTING_SHIP_TYPE:SortHerosByPos(tbHeros)
	tbHeros = tbHeros or {}
	local fnCompare = function(a, b)
		if a:GetPos() < b:GetPos() then return true; end
	end

	table.sort(tbHeros, fnCompare)
end

function KGC_DATA_FIGHTING_SHIP_TYPE:ReOrderHeros()
	self:SortHerosByPos(self.m_tbHeros)
end

function KGC_DATA_FIGHTING_SHIP_TYPE:UpdateHP()
	self.m_nHP = 0
	for k, v in pairs(self.m_tbHeros) do
		if v:GetHeroObj():IsBloodShare() then
			-- cclog("\t(%s), hp = %d", v:GetName(), v:GetHP())
			self.m_nHP = self.m_nHP + v:GetHP();
		end
	end
	-- print("ship updateHP, hp = ", self.m_nHP)
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetHP()
	-- print("fight ship, hp = ", self.m_nHP)
	return self.m_nHP;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetMaxHP()
	local nHP = 0;
	for _, hero in pairs(self.m_tbHeros) do
		if hero:GetHeroObj():IsBloodShare() then
			nHP = nHP + hero:GetMaxHP()
		end
	end
	cclog("[Log]当前最大血量：%d, 初始最大雪落下: %d@GetMaxHP", nHP, self.m_Ship:GetMaxHP())

	return nHP;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetCost()
	return self.m_nCost;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:SetCost(nCost)
	if type(nCost) == "number" then
		self.m_nCost = nCost;
	end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetMaxCost()
	-- 加上属性增加的费用
	local nAdd = self:GetMaxCostAdd() or 0;
	return self.m_nMaxCost + nAdd;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:SetMaxCost(nCost)
	local nCost = nCost or 0;
	self.m_nMaxCost = nCost;
end

--@function: 获取 属性等增加最大费用量的增加值
function KGC_DATA_FIGHTING_SHIP_TYPE:GetMaxCostAdd()
	return self.m_nMaxCostAdd;
end

--@function: 设置 属性等增加最大费用量的增加值
function KGC_DATA_FIGHTING_SHIP_TYPE:SetMaxCostAdd(nCost)
	local nCost = nCost or 0;
	self.m_nMaxCostAdd = nCost;
end

--@function: 增加 属性等增加最大费用量的增加值
function KGC_DATA_FIGHTING_SHIP_TYPE:AddMaxCostAdd(nCost)
	local nCost = nCost or 0;
	local nOld = self:GetMaxCostAdd();
	self:SetMaxCostAdd(nCost + nOld);
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetTempCostTable()
	-- print("[费用]GetTempCostTable", self.m_tbCost)
	if not self.m_tbCost then
		self.m_tbCost = {};
		self.m_tbCost.nBefore = 0;
		self.m_tbCost.nChange = 0;
	end
	-- print("[费用]before, nChange", self.m_tbCost.nBefore, self.m_tbCost.nChange)
	return self.m_tbCost;
end

--@function: 改变水晶特效需要的数据(改变之前的数量, 最大费用改变量)
function KGC_DATA_FIGHTING_SHIP_TYPE:SetTempCost(nCostBefore, nCostChange)
	cclog("[log]费用扣除情况@SetTempCost: nCostBefore(%d), nCostChange(%d)", nCostBefore, nCostChange)
	local tbCost = self:GetTempCostTable();
	tbCost.nBefore = nCostBefore or 0;
	tbCost.nChange = nCostChange or 0;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetTempCost()
	local tbCost = self:GetTempCostTable();
	return tbCost.nBefore, tbCost.nChange;
end

--@function: 针对每个ncp都有费用的更新方式
-- function KGC_DATA_FIGHTING_SHIP_TYPE:UpdateCost()
	-- local nCost = 0;
	-- for _, v in pairs(self.m_tbHeros) do
		-- if v:GetHeroObj():IsHero() and v:GetCost() > nCost then	
			-- nCost = v:GetCost();
		-- end
	-- end
	-- self.m_nCost = nCost;
-- end

--@function: 契约生物召唤位置确定
--@param: 	 释放技能英雄位置
--@return:   0-失败; 1-召唤成功并且立马创建;2-召唤成功入队列
function KGC_DATA_FIGHTING_SHIP_TYPE:GetContractPos(tbPos)
	local tbRetPos = {}
	local tbHash = {}

	for k, v in pairs(self.m_tbHeros) do
		tbHash[v:GetPos()] = true;
	end
	
	local nRet = l_tbSkillCastRet.FAILED;
	for _, nTarPos in ipairs(tbPos) do
		local queue = self:GetQueue(nTarPos);
		print("队列大小：", queue and queue:GetSize())
		if not tbHash[nTarPos] then
			nRet = l_tbSkillCastRet.SUCCESS;
			table.insert(tbRetPos, {nRet, nTarPos})
			cclog("[test]位置%d直接召唤契约生物", nTarPos)
		elseif queue and queue:GetSize() >= self.m_nMaxQueue then
			cclog("[test]位置%d召唤契约生物失败", nTarPos)
		else
			nRet = l_tbSkillCastRet.RETRY;
			table.insert(tbRetPos, {nRet, nTarPos})
			cclog("[test]位置%d契约生物入队列", nTarPos)
		end

	end
	return nRet, tbRetPos;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:CreateContract(nModID, tbPos)
	
	for _, nPos in pairs(tbPos or {}) do
		if not gf_IsValidPos(nPos) then
			cclog("[Error]position is invalid!@CreateContract")
			return false;
		end
	end
	
	if not nModID then
		return false;
	end
	
	local tbRet = {}
	local nRet, tbRetPos = self:GetContractPos(tbPos)
	
	if nRet == l_tbSkillCastRet.FAILED or #tbRetPos <= 0 then
		return l_tbSkillCastRet.FAILED, tbRetPos;
	end
	
	--notify: 参数是tbPos，而不是tbRetPos
	local tbContract = self:CreateNpc(nType, nModID, tbPos)
	
	for k, ret in ipairs(tbRetPos) do 
		local contract = tbContract[k]
		local n, pos = unpack(ret)
		if n == l_tbSkillCastRet.RETRY then
			print("契约生物位置有人！", pos, self.m_tbQueue[pos])
			if not self.m_tbQueue[pos] then
				self.m_tbQueue[pos] = KGC_QUEUE_BASE_TYPE.new()
			end
			local data = self.m_tbQueue[pos]:Push(contract)
			
			--结果数据
			table.insert(tbRet, {n, data})
		elseif n == l_tbSkillCastRet.SUCCESS then
			self:AddMember(contract)
			local data = KGC_QUEUE_RESULT_BASE_TYPE.new()
			
			--结果数据
			data:Init(nil, contract)
			table.insert(tbRet, {n, data})
		end
	end

	return nRet, tbRet;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:CreateNpc(nType, nModID, tbPos)
	nType = nType or 1
	local tbType2Npc = {
		[1] = KG_HERO_TYPE,
		[2] = KGC_CONTRACT_BIOLOGY_TYPE,
	}
	nType = 2;
	
	local tbNpc = {}
	for _, nPos in ipairs(tbPos) do
		local tbData = {}
		tbData.heroId = nModID;
		tbData.pos = nPos;
		local npc = tbType2Npc[nType].new()
		npc:Init(tbData)
		-- print("契约生物信息，位置:", npc:GetPos())
		npc:SetShip(self.m_Ship)
		local npcFight = self:CreateFightNpc(npc)
		table.insert(tbNpc, npcFight);
	end
	return tbNpc;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:CreateFightNpc(npc)
	local npcFight = KGC_DATA_FIGHTING_NPC_TYPE.new()
	npcFight:Init(npc, self)
	npcFight:SetFightShip(self)

	npcFight:SetState(l_tbFSIndex.ATTACKABLE, true)
	return npcFight;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:AddMember(fightNpc)
	table.insert(self.m_tbHeros, fightNpc)

	fightNpc:SetState(l_tbFSIndex.JOIN, true)
	
	--英雄不触发进场
	if fightNpc:GetHeroObj():IsHero() then
		return ;
	end
	
	--进场
	print("触发条件：进场")
	if fightNpc and not fightNpc:GetHeroObj():IsHero() then
		-- local tbRet = g_CondTrigger:Notify(fightNpc, l_tbCondID.ENTER)
		local tbSkills = fightNpc:GetHeroObj():GetTriggerSkills();
		print("触发技能个数：", #(tbSkills or {}))
		for _, skill in ipairs(tbSkills) do
			local nConID = skill:GetCondID()
			if nConID == l_tbCondID.ENTER then
				if not g_tbTriggerSkills then
					g_tbTriggerSkills = {}
				end
				skill:SetHeros({fightNpc});
				fightNpc:SetState(l_tbFSIndex.ATTACKABLE, true)
				table.insert(g_tbTriggerSkills, skill);
			end
		end
		print("成功触发技能个数：", #(g_tbTriggerSkills or {}))
	end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:RemoveMember(npc)
	for k, v in pairs(self.m_tbHeros) do
		if v == npc then
			npc:DetachSubject(g_CondTrigger)
			npc:SetState(l_tbFSIndex.JOIN, false)
			table.remove(self.m_tbHeros, k);
			break;
		end
	end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetHeros()
	if not self.m_tbHeros then
		self.m_tbHeros = {};
	end
	return self.m_tbHeros;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetHeroByPos(nPos)
	for _, hero in pairs(self.m_tbHeros) do
		if nPos == hero:GetPos() then
			return hero;
		end
	end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:ForEachProcessHeros(obj, fnProcess, ...)
	local tbArg = {...}
	print("@ForEachProcessHeros-tbArg", obj, tbArg[1], tbArg[2], #self.m_tbInitHeros)
	-- for _, tbHero in pairs(self.m_tbHeros) do
	for _, tbHero in pairs(self.m_tbInitHeros) do
		if tbHero and type(fnProcess) == "function" then
			fnProcess(obj, tbHero, ...)
		end
	end
end

function KGC_DATA_FIGHTING_SHIP_TYPE:SetCamp(nCamp)
	if type(nCamp) ~= "number" then
		cclog("[Error]阵营类型错误！")
		return false;
	end
	self.m_nCamp = nCamp;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetCamp()
	return self.m_nCamp;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:GetQueue(nPos)
	local queue = nil;
	print("GetQueue", nPos, gf_IsValidPos(nPos), self.m_tbQueue[nPos])
	if gf_IsValidPos(nPos) then
		queue = self.m_tbQueue[nPos];
	end
	return queue;
end

function KGC_DATA_FIGHTING_SHIP_TYPE:RemoveSummons()
	for i = #(self.m_tbHeros), 1, -1 do
		local npc = self.m_tbHeros[i]
		if npc:GetHeroObj():IsSummon() then
			npc:DetachSubject(g_CondTrigger)
			npc:SetState(l_tbFSIndex.JOIN, false)
			table.remove(self.m_tbHeros, i);
		end
	end
end

--@function: 删除ship数据前释放
function KGC_DATA_FIGHTING_SHIP_TYPE:UnInit()
	local tbHeros = self:GetHeros();
	for _, hero in pairs(tbHeros) do
		hero:UnInit();
		hero:DetachSubject(g_CondTrigger);
		hero:SetState(l_tbFSIndex.JOIN, false);
	end
end

--test
function KGC_DATA_FIGHTING_SHIP_TYPE:TestPrintHeros()
	local tbHeros = self:GetHeros() or {}
	print("英雄总数：", #tbHeros)
	for _, v in pairs(tbHeros) do
		cclog("位置:%d", v:GetPos())
	end
end
----------------------------------------
--2.规则配置(写文件就要读写)
TB_SKILL_PROBABILITY = {
	--{最大费用，1费概率， 2费概率，3费概率，4费概率, 5费概率, 6费概率}
	[0] = {16.6, 16.6, 16.6, 16.6, 16.6, 16.7},	
	[1] = {100, 0, 0, 0, 0, 0},
	[2] = {25,75, 0, 0, 0, 0},
	[3] = {5, 20, 75, 0, 0, 0},
	[4] = {0, 5, 20, 75, 0, 0},
	[5] = {0, 0, 5, 20, 75, 0},
	[6] = {0, 0, 0, 5, 20, 75},
}
----------------------------------------

----------------------------------------
--3.tbProduct
local TB_DATA_FIGHT_PRODUCTS = {
	m_tbData = {
		--[[一个结果
		{
			m_nRound = ,
			m_tbCost = {},
			m_tbState = {},
			m_ShipLauncher,
			m_ShipDefend,
			m_tbAttack = {},
			m_tbDefend = {
				--{},
			},
			m_tbSrc = {角色, 技能释放结果},		--触发本技能的相关信息：用于决定释放特效是否播放
			m_nRet = 0,			--本次技能的释放结果
		}]]
	},
	m_tbCost = {
		--[[
		[1] = {
			[camp] = {cost, maxcost};
		},
		]]
	},
	m_tbRound = {
		--[[
		[1] = {
			tbState = {},
		},
		]]
	},
}
KGC_Data_FightProducts_Type = class("KGC_Data_FightProducts_Type", CLASS_BASE_TYPE, TB_DATA_FIGHT_PRODUCTS)
function KGC_Data_FightProducts_Type:ctor()
	self.m_tbData = {}
end

function KGC_Data_FightProducts_Type:Check(tbElem)
	return true;
end

function KGC_Data_FightProducts_Type:AddElem(tbElem)
	if not self:Check(tbElem) then
		return;
	end
	if not self.m_tbData then
		self.m_tbData = {}
	end
	table.insert(self.m_tbData, tbElem)
	print("[fight/data]#self.m_tbData", #self.m_tbData)
end

function KGC_Data_FightProducts_Type:CreateElem(tbAttackers, tbTargets)
	local tbElem = {}
	if type(tbAttackers) ~= "table" or type(tbTargets) ~= "table" then
		cclog("[Error]Data Error @ CreateElem()");
		return;
	end
	assert(#tbAttackers > 0)
	tbElem.m_tbAttack = tbAttackers;
	tbElem.m_tbDefend = tbTargets;
	return tbElem;
end

function KGC_Data_FightProducts_Type:AddTarget(obj, target)
	if type(obj) ~= "table" or type(target) ~= "table" then
		cclog("[Error]Data Error!@AddTarget");
		return;
	end
	if not obj.m_tbDefend then
		obj.m_tbDefend = {};
	end
	table.insert(obj.m_tbDefend, target);
end

function KGC_Data_FightProducts_Type:CreateATarget(nPos, nCurHP, nHP, nDamage, skill, nSkillDamage)	
	if not nPos or not nCurHP or not nHP or not nDamage then
		cclog("[Error]Data Error!@CreateTargets()");
		return;
	end
	
	local target = {}
	target[1] = nPos;
	target[2] = {nCurHP, nHP, nDamage}
	target[3] = {skill, nSkillDamage}
	return target;
end

function KGC_Data_FightProducts_Type:CreateAttackers(tbAttackers)
	return tbAttackers;
end

function KGC_Data_FightProducts_Type:CreateTargets(tbTargets, shipDefend)
	tbTargets = tbTargets or {}
	for k, v in pairs(tbTargets) do
		local nPos = v:GetPos();
		--共用血量单独处理
		local hero = shipDefend:GetHeroByPos(nPos)
		local data = v:GetData()
	end
	return tbTargets;
end

--@function: 保存战斗过程数据
--@tbRet: {本次技能释放结果, 上一次技能相关信息}; 上一次的结果，决定本技能的一些操作！ 例如：连携、多重施法
function KGC_Data_FightProducts_Type:Add(shipLauncher, tbRetLau, shipDefend, tbRetDef, nRound, tbRetState, tbRet)
	if not tbRetLau and not tbRetDef then
		return;
	end
	local tbTargets = self:CreateTargets(tbRetDef, shipDefend) or {}
	local tbAttackers = self:CreateAttackers(tbRetLau);
	local tbElem = self:CreateElem(tbAttackers, tbTargets)
	assert(shipLauncher.m_tbHeros)
	assert(shipDefend.m_tbHeros)

	tbElem.m_tbState = self:AddRetState(tbRetState)

	local tbRet = tbRet or {}			--{本次释放技能的结果，上一次释放技能的结果}
	local nRet, tbSrc = unpack(tbRet);
	
	tbElem.m_nRound = nRound or 0;
	tbElem.m_tbSrc = tbSrc;
	tbElem.m_nRet = nRet;
	
	-- self:AddCost(shipLauncher, shipDefend);
	self:AddElem(tbElem)
	-- cclog("[结果]第%d轮技能释放结果：%s", self:GetTotalNum(), tostring(nCastRet))
	cclog("[fight/data]fight-data-AddRetState after:", "当前轮数：%d **********************************************************" .. self:GetTotalNum())
end

function KGC_Data_FightProducts_Type:SetCost(nRound, shipLauncher, shipDefend)
	if not nRound then
		cclog("[Error]nRound is Error@AddCost")
		return;
	end
	
	local tbCost = self:GetCost(nRound);
	local nCamp1 = shipLauncher:GetCamp()
	local nCamp2 = shipDefend:GetCamp()
	
	local nCurrentCostL = shipLauncher:GetCost()
	local nMaxCostL = shipLauncher:GetCost();
	local nBeforeL, nChangeL = shipLauncher:GetTempCost();
	nBeforeL, nChangeL = nBeforeL or 0, nChangeL or 0;
	
	local nCurrentCostD = shipDefend:GetCost()
	local nMaxCostD = shipDefend:GetCost();
	local nBeforeD, nChangeD = shipDefend:GetTempCost();
	nBeforeD, nChangeD = nBeforeD or 0, nChangeD or 0
	
	--{当前费用，最大费用，费用变化之前费用，费用变化量}
	tbCost[nCamp1] = {nCurrentCostL, nMaxCostL, nBeforeL, nChangeL}
	tbCost[nCamp2] = {nCurrentCostD, nMaxCostD, nBeforeD, nChangeD};

end

function KGC_Data_FightProducts_Type:GetCost(nRound)
	if not nRound then
		cclog("[Error]nRound is Error@AddCost")
		return {};
	end
	
	if not self.m_tbCost then
		self.m_tbCost = {}
	end
	
	if not self.m_tbCost[nRound] then
		self.m_tbCost[nRound] = {}
	end
	return self.m_tbCost[nRound]
end

function KGC_Data_FightProducts_Type:AddRetState(tbRet)
	print("fight-data-AddRetState", tbRet, #(tbRet or {}), "当前轮数：" .. self:GetTotalNum())
	tbRet = tbRet or {}
	local tbState = {};
	for _, ret in ipairs(tbRet) do
		table.insert(tbState, ret)
	end
	return tbState;
end

function KGC_Data_FightProducts_Type:GetRetState(nTurn)
	print("GetRetState, nTurn", nTurn)
	local tbData = self:GetOneData(nTurn)
	return tbData.m_tbState;
end

function KGC_Data_FightProducts_Type:InsertRetState(nTurn, tbRet)
	print("InsertRetState, nTurn：", nTurn, tbRet)
	tbRet = tbRet or {}
	print("self.m_tbData[nTurn], 个数", self.m_tbData[nTurn], #(self.m_tbData[nTurn] or {}))
	local tbData = self:GetOneData(nTurn)
	print("tbData,个数", tbData, #(tbData or {}))
	if type(tbData) ~= "table" then
		if self.m_tbData[0] ~= "table" then
			self.m_tbData[0] = {};
		end
		tbData = self.m_tbData[0]
	end
	if not tbData.m_tbState then
		tbData.m_tbState = {}
	end
	for _, ret in ipairs(tbRet) do
		table.insert(tbData.m_tbState, ret)
	end
end


function KGC_Data_FightProducts_Type:InsertRetStateByRound(nRound, tbRet)
	-- print("InsertRetStateByRound, nRound：", nRound, tbRet)
	tbRet = tbRet or {}
	-- print("self.m_tbRound[nRound], 个数", self.m_tbRound[nRound], #(self.m_tbRound[nRound] or {}))
	local tbData = self:GetOneRoundData(nRound)
	-- cclog("[轮数计数]当前轮数：tbData,个数", #(tbData or {}), %d)

	if not tbData.tbState then
		tbData.tbState = {}
	end
	for _, ret in ipairs(tbRet) do
		table.insert(tbData.tbState, ret)
	end
end

function KGC_Data_FightProducts_Type:GetRetStateByRound(nRound)
	print("GetRetState, nTurn", nRound)
	local tbData = self:GetOneRoundData(nRound)
	return tbData.tbState;
end

--@function: 每个角色带费用方式
-- function KGC_Data_FightProducts_Type:AddCost(shipLauncher, shipDefend)
	-- local tbCost = {};
	-- for _, hero in pairs(shipLauncher:GetHeros()) do
		-- table.insert(tbCost, {hero:GetPos(), hero:GetCost()})
	-- end
	-- for _, hero in pairs(shipDefend:GetHeros()) do
		-- table.insert(tbCost, {hero:GetPos(), hero:GetCost()})
	-- end
	-- return tbCost;
-- end

function KGC_Data_FightProducts_Type:GetTotalNum()
	if not self.m_tbData then
		self.m_tbData = {}
	end
	return #self.m_tbData;
end

function KGC_Data_FightProducts_Type:GetOneRoundData(nRound)
	assert(nRound)
	if not self.m_tbRound then
		self.m_tbRound = {};
	end
	if not self.m_tbRound[nRound] then
		self.m_tbRound[nRound] = {};
	end
	return self.m_tbRound[nRound]
end

function KGC_Data_FightProducts_Type:GetOneData(nTurn)
	assert(nTurn)
	-- if nTurn == 0 then
		-- if not self.m_tbData[nTurn] then
			-- self.m_tbData[nTurn] = {}
		-- end
	-- end
	return self.m_tbData[nTurn] or {}
end

function KGC_Data_FightProducts_Type:GetCastRet(nTurn)
	local tbData = self:GetOneData(nTurn)
	if not tbData.m_tbSrc then
		tbData.m_tbSrc = {};
	end
	return tbData.m_tbSrc[2];
end

function KGC_Data_FightProducts_Type:GetDefends(nTurn)
	local tbData = self:GetOneData(nTurn)
	return tbData.m_tbDefend;
end

function KGC_Data_FightProducts_Type:GetDefendPos(defend)
	assert(defend)
	return defend[1]
end

--@return: nCurHP, nMaxHP, nDamage
function KGC_Data_FightProducts_Type:GetDamageInfo(defend)
	assert(defend)
	return unpack(defend[2])
end

function KGC_Data_FightProducts_Type:GetLaunchers(nTurn)
	local tbData = self:GetOneData(nTurn)
	return tbData.m_tbAttack;
end

function KGC_Data_FightProducts_Type:GetLauncherPos(launcher)
	assert(launcher)
	return launcher[1]
end

function KGC_Data_FightProducts_Type:GetSkill(launcher)
	assert(launcher)
	return launcher[2]
end

-- function KGC_Data_FightProducts_Type:GetShip(nTurn)
	-- local tbData = self:GetOneData(nTurn)
	-- return tbData.m_ShipLauncher, tbData.m_ShipDefend;
-- end

function KGC_Data_FightProducts_Type:GetRound(nTurn)
	local tbData = self:GetOneData(nTurn)
	return tbData.m_nRound;
end
----------------------------------------
--3.技能圆桌

local TB_DATA_FIGHT_SKILL_SLOT = {
	--技能槽：配置技能
	m_tbSkillSlot = {
		-- [费用] = {skill1, skill2};0 表示普攻
		--[1] = {},
	},
	
	-- 普通技能, 结构同上
	m_tbNormalSkill = {
	},
	
	m_tbHeros = {},
	m_tbPro = {},				--每个圆桌的非普攻概率总和
}

KGC_DATA_FIGHT_SKILL_SLOT_TYPE = class("KGC_DATA_FIGHT_SKILL_SLOT_TYPE", CLASS_BASE_TYPE, TB_DATA_FIGHT_SKILL_SLOT)

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:ctor()
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:Insert(skill, hero)
	if type(skill.IsSkill) == "function" and skill:IsSkill() then
		local nCost = skill:GetCost()
		local nCamp = hero:GetFightShip():GetCamp();
		-- print("Insert slot 技能费用：", nCost)

		skill:SetHeros({hero})
		self:Add(nCost, skill)
		table.insert(self.m_tbHeros, hero);
	end
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:Add(nCost, skill)
	if not skill then
		cclog("[Error]技能槽插入一个空的技能!");
		return;
	end

	local tbSkills = self:GetSlotSkill(nCost);
	if skill:IsNormal() then
		tbSkills = self:GetNormalSkill(nCost);
	end
	--check
	if not self:IsExisted(nCost, skill) then
		table.insert(tbSkills, skill)
		cclog("是否普通(%s): 成功插入一条技能(%d), 技能槽个数(%d)", tostring(skill:IsNormal()), skill:GetID(), #tbSkills)
	end
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:IsExisted(nCost, skill)
	-- print("IsExisted...")
	local tbSkills = self.m_tbSkillSlot[nCost] or {}
	for k, v in pairs(tbSkills) do
		--ID和英雄一样
		if v:IsSkill() and v:IsSameSkill(skill) then
			cclog("[Warning]skill is Existed!id(%d)", v:GetID())
			return true;
		end
	end
	return false;
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:FillNormal(heros, nCost)
	if type(heros) ~= "table" then
		return;
	end
	
	local nPro = self:GetSlotPro(nCost);
	print("普攻填充-nCost, nPro, #heros", nCost, nPro, #heros)
	--普攻概率根据当前可行动的英雄决定
	--if self.m_nPro and self.m_nPro < 100 then
	if nPro < 100 then
		print("[log]开始填充技能圆盘");
		if #heros > 0 then
			local fPro = math.floor((100 - nPro)/#heros);
			local fTotalPro = 0
			for nIndex, hero in pairs(heros) do
				local nSkillPro = 0;
				if nIndex == #heros then
					nSkillPro = 100-fTotalPro;
				else
					fTotalPro = fTotalPro + fPro;
					nSkillPro = fPro;
				end
				local tbSkills = hero:GetHeroObj():GetNormalSkill() or {};
				for _, skill in pairs(tbSkills) do
					skill:SetPro(nSkillPro);
					self:Insert(skill, hero)
				end
			end
		end
	end
end

--@function: 获取圆盘技能总概率(角色技能槽技能、固定技能、合作技能)
function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:GetSlotPro(nCost)
	nCost = nCost or 0;
	local nPro = 0;
	if not self.m_tbSkillSlot[nCost] then
		self.m_tbSkillSlot[nCost] = {}
	end
	for k, v in pairs(self.m_tbSkillSlot[nCost]) do
		nPro = nPro + v:GetPro()
		--test
		print(k, v:GetName(), v:GetID(), v:GetPro());
		--test end
	end
	print("[log]圆盘技能总概率为:", nPro)
	return nPro;
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:RandomSkill(nCost)
	if not nCost then
		nCost = 0;
	end

	--普攻概率根据当前可行动的英雄决定
	--test
	print(string.format("技能圆桌为(当前费用 = %d):", nCost))
	self:TestPrintSlot()
	--test end
	local tbSkills = self.m_tbSkillSlot[nCost]
	local skill = self:RandASkill(tbSkills)
	--普攻填充
	if not skill then
		print("没有随机到技能，普攻代替！")
		skill = self:RandASkill(self:FindNormalSkill(nCost))
	end
	
	return skill;
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:RandASkill(tbSkills)
	
	if type(tbSkills) ~= "table" then
		return nil
	end
	--page@2015/04/16 排序：客户端和服务端顺序不一样
	local fnCompare = function(a, b)
		if a:GetID() < b:GetID() then return true; end
	end
	table.sort(tbSkills, fnCompare);
	
	print(string.format("技能总数: (%d) @RandASkill", #tbSkills))
	local tbPro = {}
	local tbHash = {}
	local testLog = ""
	local nPro = 0;
	for k, v in pairs(tbSkills) do
		if v and v.IsSkill and v:IsSkill() then
			table.insert(tbHash, v)
			
			nPro = nPro + v:GetPro();
			if nPro > 100 then
				table.insert(tbPro, 100 - (nPro - v:GetPro()))
				break;
			else
				table.insert(tbPro, v:GetPro())
			end
			
			--test
			local testHero = v:GetHeros()[1]
			testLog = "位置：" .. testHero:GetPos() .. " (技能ID：" .. v:GetID() .. ", 技能释放概率：" .. v:GetPro() .. "), "
			print(testLog)
		end
	end
	
	if nPro < 100 then
		table.insert(tbPro, 100 - nPro); 
	end

	--test
	if DEBUG_SEED then
		local szLog = "RandASkill: gf_GetRandomIndexEx\n";
		tst_write_file("tst_random_function.txt", szLog);
	end
	--test end
	--支持小数
	local nIndex = gf_GetRandomIndexEx(tbPro)
	--testLog
	print("随机到的索引为 " .. nIndex)
	--test end
	return tbHash[nIndex];
end

--@function: 找到一个普通技能
function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:FindNormalSkill(nCost)
	local nCost = nCost or 0;
	print("FindNormalSkill", nCost)
	local tbSkills = self:GetNormalSkill(nCost);
	-- npc的普攻获取
	if #tbSkills <= 0 then
		tbSkills = self:GetNormalSkill(0);
	end
	
	--test
	print("填充的普通技能：", #tbSkills);
	for _, skill in pairs(tbSkills) do
		cclog("普通技能：%s(%d), 费用：%d, 概率：%f", skill:GetName(), skill:GetID(), skill:GetCost(), skill:GetPro());
	end
	--test end
	return tbSkills;
end

--@function: 获取技能槽技能
function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:GetSlotSkill(nCost)
	assert(nCost)
	if not self.m_tbSkillSlot then
		self.m_tbSkillSlot = {}
	end
	if not self.m_tbSkillSlot[nCost] then
		self.m_tbSkillSlot[nCost] = {}
	end
	return self.m_tbSkillSlot[nCost];
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:GetNormalSkill(nCost)
	local nCost = nCost or 0;

	if not self.m_tbNormalSkill then
		self.m_tbNormalSkill = {};
	end
	
	if not self.m_tbNormalSkill[nCost] then
		self.m_tbNormalSkill[nCost] = {};
	end

	return self.m_tbNormalSkill[nCost];
end

--@function: 根据技能ID在技能槽中找某个技能, 如果没有就随机
function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:GetSkillByID(nID, nCost)
	local skill = nil;
	for nCost, tbSkills in pairs(self.m_tbSkillSlot) do
		for k, v in pairs(tbSkills) do
			if v and v.IsSkill and v:IsSkill() then
				if nID == v:GetID() then
					skill = v;
					break;
				end
			end
		end
	end
	
	if not skill then
		print("没有随机到技能，普攻代替！")
		skill = self:RandomSkill(nCost)
	end
	
	return skill;
end

function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:SaveHero(hero)
	if hero and hero.IsHero and hero:IsHero() then
		table.insert(m_tbHeros, hero)
	end
end

--test
function KGC_DATA_FIGHT_SKILL_SLOT_TYPE:TestPrintSlot()
	for k, v in pairs(self.m_tbSkillSlot) do
		local szSkill = "[" .. k .. "] = {"
		if type(v) == "table" then 
			for k1, v1 in pairs(v) do
				szSkill = szSkill .. v1:GetID() .. ","
			end
		end
		szSkill = szSkill .. "}"
		print(szSkill)
	end
	
	print("普通技能：")
	for k, v in pairs(self.m_tbNormalSkill) do
		local szSkill = "[" .. k .. "] = {"
		if type(v) == "table" then 
			for k1, v1 in pairs(v) do
				szSkill = szSkill .. v1:GetID() .. ","
			end
		end
		szSkill = szSkill .. "}"
		print(szSkill)
	end
end

--test end
---------------------------------------------------------------------
--结果基类
--struct
local TB_RESULT_QUEUE_BASE_STRUCT = {
	obj = nil,			--具体的状态队列对象
	elem = nil,
	nConID = 0,			--触发状态的条件ID
}

KGC_QUEUE_RESULT_BASE_TYPE = class("KGC_QUEUE_RESULT_BASE_TYPE", KGC_DATA_BASE_TYPE, TB_RESULT_QUEUE_BASE_STRUCT)

function KGC_QUEUE_RESULT_BASE_TYPE:ctor()
end

function KGC_QUEUE_RESULT_BASE_TYPE:Init(obj, elem)
	self:SetObj(obj);
	self:SetElem(elem);
end

function KGC_QUEUE_RESULT_BASE_TYPE:SetObj(obj)
	self.obj = obj;
end

function KGC_QUEUE_RESULT_BASE_TYPE:GetObj()
	return self.obj;
end

function KGC_QUEUE_RESULT_BASE_TYPE:SetElem(elem)
	self.elem = elem;
end

function KGC_QUEUE_RESULT_BASE_TYPE:GetElem()
	return self.elem;
end

function KGC_QUEUE_RESULT_BASE_TYPE:SetTriggerConID(nID)
	self.nConID = nID or 0;
end

function KGC_QUEUE_RESULT_BASE_TYPE:GetTriggerConID()
	return self.nConID;
end

--(1)状态队列结果类

--struct
local TB_RESULT_STATE_QUEUE_STRUCT = {
	nType = 0,			--结果类型(增加、溢出)
	obj = nil,		--具体的状态队列对象
	elem = nil,
	bRet = false,		--操作结果
	
	--自定义数据
	data = nil,
}

KGC_STATE_QUEUE_RESULT_TYPE = class("KGC_STATE_QUEUE_RESULT_TYPE", KGC_QUEUE_RESULT_BASE_TYPE, TB_RESULT_STATE_QUEUE_STRUCT)

function KGC_STATE_QUEUE_RESULT_TYPE:ctor()
end

function KGC_STATE_QUEUE_RESULT_TYPE:GetTBType()
	local tbType = {
		ADD				= 1,	--增加操作
		SUB				= 2,	--移除操作
		REP				= 3,	--替换操作
	}
	return tbType;
end

function KGC_STATE_QUEUE_RESULT_TYPE:Init(nType, obj, elem, data)
	self:SetType(nType);
	self:SetObj(obj);
	self:SetElem(elem);
	
	--自定义数据
	self:SetData(data)
end

function KGC_STATE_QUEUE_RESULT_TYPE:SetType(nType)
	self.nType = nType;
end

function KGC_STATE_QUEUE_RESULT_TYPE:GetType()
	return self.nType;
end

function KGC_STATE_QUEUE_RESULT_TYPE:SetResult(bRet)
	self.bRet = bRet;
end

function KGC_STATE_QUEUE_RESULT_TYPE:GetResult()
	return self.bRet;
end

function KGC_STATE_QUEUE_RESULT_TYPE:SetData(data)
	self.data = data;
end

function KGC_STATE_QUEUE_RESULT_TYPE:GetData()
	return self.data;
end

--(2)契约生物队列结果类
--struct
local TB_RESULT_STATE_QUEUE_STRUCT = {
	nType = 0,			--结果类型(增加、溢出)
	obj = nil,			--具体的状态队列对象
	elem = nil,
	bRet = false,		--操作结果
	size = 0,			--队列大小
}

KGC_CONSTRACT_QUEUE_RESULT_TYPE = class("KGC_CONSTRACT_QUEUE_RESULT_TYPE", KGC_QUEUE_RESULT_BASE_TYPE, TB_RESULT_STATE_QUEUE_STRUCT)

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:ctor()
	local tbTemp = gf_CopyTable(TB_RESULT_STATE_QUEUE_STRUCT)
	for k, v in pairs(tbTemp) do
		self[k] = v;
	end
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:GetTBType()
	local tbType = {
		ADD				= 1,	--增加操作
		SUB				= 2,	--移除操作
	}
	return tbType;
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:Init(nType, obj, elem, size)
	self:SetType(nType);
	self:SetObj(obj);
	self:SetElem(elem);
	self:SetSize(size);
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:SetType(nType)
	self.nType = nType;
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:GetType()
	return self.nType;
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:SetSize(size)
	self.size = size or 0;
end

function KGC_CONSTRACT_QUEUE_RESULT_TYPE:GetSize()
	return self.size;
end
----------------------------------------
--test

