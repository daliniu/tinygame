----------------------------------------------------------
-- file:	fight.lua
-- Author:	page
-- Time:	2015/01/28 15:34
-- Desc:	战斗系统的逻辑中心fight center
--
----------------------------------------------------------
-- if _SERVER then
function _nonprint(...)
	if _DEBUG_ then
		local tb = {...}
		local f = io.open("fight.txt", "a+")
		for k, v in pairs(tb) do
			f:write(tostring(v) .. ",")
		end
		f:write("\n")
		f:close()
	end
	-- print(...)
end
-- print = _nonprint;

-- end
-- if _SERVER then
require "script/lib/basefunctions"
require "script/lib/debugfunctions"
-- end

require "script/core/fight/data"
require "script/core/skill/head"
require "script/class/class_dp_base"
require "script/core/player/head"
require "script/core/reward/rewardmanager";
----------------------------------------------------------
local l_tbFSIndex, l_tbFightState = def_GetFightStateData()
local l_tbCamp = def_GetFightCampData();
local l_tbSkillCastRet = def_GetSkillCastRetData();
local l_tbCondID, l_tbCondName = def_GetConditionData();
local l_tbHeroBox = require("script/cfg/client/herobox");

--data struct
local TB_FIGHTHALL_DATA = {
	--config
	m_nMaxTurn = 10,			--最大的战斗回合
	m_nLoseControlTurn = 7,		--该轮开始拼人品
	m_nCostAdd = 1,				--每回合费用+1
	m_nMaxCost = 6,				--费用最大值
	------------------------------------
	--战斗过程数据
	m_tbEnemy,					--地方原始数据
	m_tbFighter = {},
	m_nCurRound = 0,			--当前回合数
	m_nFirst = 0,				--记录谁先手(随机数会变化，不能用函数了)
	m_tbProducts = {},			--战斗结果数据
	m_tbSkillPro = TB_SKILL_PROBABILITY,
	m_LastAttacker = 0,			--每轮最后释放技能一方
	m_nWinCamp = 0,				--胜利阵营
	
	m_nCounter = 0,				-- 战斗技术
}

KGC_FightHall = class("KGC_FightHall", CLASS_BASE_TYPE, TB_FIGHTHALL_DATA)
----------------------------------------
--function
----------------------------------------
function KGC_FightHall:ctor()
	
end

function KGC_FightHall:Init(tbMine, tbEnemy)
	print("++++++++++++++++++++++++++++++++++++")
	cclog("开始初始化战斗环境(Init) ")
	print("Init:1", collectgarbage("count"))
	--每一场战斗都有一个全局条件触发器
	--注意：在初始化战斗数据之前!!!
	g_CondTrigger = KGC_SUB_CONDITION_BASE_TYPE.new()
	
	self.m_tbFighter = {}
	--重新包装战斗需要的数据，包括临时数据的初始化
	self:AddData(l_tbCamp.MINE, tbMine);
	self:AddData(l_tbCamp.ENEMY, tbEnemy);
	
	--test
	print("FightHall Init end ... ");
	-- tbData1:TestPrintHeros();
	-- tbData2:TestPrintHeros();
	--test end
	collectgarbage("collect")
	print("Init:1", collectgarbage("count"))
	print("++++++++++++++++++++++++++++++++++++")
end

--@function: 增加数据
function KGC_FightHall:AddData(nCamp, tbData)
	cclog("[Log]初始化阵营(%d), tbData(%s).@AddData...........", nCamp, tostring(tbData))
	if not self.m_tbFighter then
		self.m_tbFighter = {};
	end
	if not gf_IsValidCamp(nCamp) then
		cclog("[Error]阵营错误(nCamp = %s)", tostring(nCamp))
		return;
	end

	--重新包装战斗需要的数据，包括临时数据的初始化
	local tbShip = KGC_DATA_FIGHTING_SHIP_TYPE.new()
	tbShip:Init(tbData)
	tbShip:SetCamp(nCamp)
	self.m_tbFighter[nCamp] = tbShip
	
	--test
	-- tbShip:TestPrintHeros();
	--test end
end

function KGC_FightHall:Clear()
	self.m_nCurRound = 0;
	self.m_nFirst = 0;
	self.m_tbProducts = nil;
	self.m_LastAttacker = 0;
	self.m_nWinCamp = 0;
	
	local tbShips = self:GetShips();
	for _, ship in pairs(tbShips) do
		ship:UnInit();
	end
	
	-- 新手指引技能配置表记录初始化
	self.m_tbFightWithConfig = {};
	self.m_tbFightWithConfig.tbSkills = {};
	self.m_tbFightWithConfig.tbSkills[l_tbCamp.MINE] = 0;
	self.m_tbFightWithConfig.tbSkills[l_tbCamp.ENEMY] = 0;
end

function KGC_FightHall:ClearEnemy()
	self:AddData(l_tbCamp.ENEMY, nil);
end

--先手判断
function KGC_FightHall:GetAttackOrder(tbMine, tbEnemy)
	print("判断先手：", self.m_nHeroBoxID);
	-- 根据配置觉得谁先手
	if self.m_nHeroBoxID then
		local tbConfig = l_tbHeroBox[self.m_nHeroBoxID];
		local nFirstCamp = tbConfig.first;
		self.m_nFirst = self.FIGHT_ORDER_MINE_FIRST;
		if nFirstCamp == l_tbCamp.ENEMY then
			self.m_nFirst = self.FIGHT_ORDER_ENEMY_FIRST;
			return tbEnemy, tbMine, self.m_nFirst
		end
		return tbMine, tbEnemy, self.m_nFirst;
	end

	--test
	if DEBUG_SEED then
		local szLog = "GetAttackOrder\n";
		tst_write_file("tst_random_function.txt", szLog);
	end
	--test end
	local nRandom = gf_Random(100)
	self.m_nFirst = self.FIGHT_ORDER_MINE_FIRST;
	if nRandom >= 50 then
		self.m_nFirst = self.FIGHT_ORDER_ENEMY_FIRST;
		return tbEnemy, tbMine, self.m_nFirst;
	end
	return tbMine, tbEnemy, self.m_nFirst;
end

function KGC_FightHall:FightBefore()
	--每次都把环境重置
	self.m_nCurRound = 1;
	self.m_nFirst = 0;
	self.m_tbProducts = KGC_Data_FightProducts_Type.new();
	return self:GetAttackOrder(self.m_tbFighter[l_tbCamp.MINE], self.m_tbFighter[l_tbCamp.ENEMY]);
end

--@function：战斗之后
function KGC_FightHall:FightAfter()
	--清理掉战斗过程中的召唤的生物
	local tbShips = self:GetShips();
	for nCamp, ship in pairs(tbShips) do
		ship:RemoveSummons();
	end
	
	self:AddCounter(1);
end

function KGC_FightHall:GetShips()
	return self.m_tbFighter
end

--@param: tbTargets为所有攻击目标table
--@param: nNum为攻击目标返回攻击目标个数
--@规则 ：默认对位攻击，即先寻同行，从前到后。再从上到下按照前面的顺序
function KGC_FightHall:GetTarget(tbTargets, tbAttackers, nNum, heros, skill)
	if type(heros) == "table" then
		-- local lau = skill:GetLauncher()
		local lau = skill:GetCaster()
		return skill:GetTarget(lau, tbTargets, tbAttackers)
	end
	------------------------------------------
	--多个英雄合作技的时候，如何选取对位攻击？
	nPos = heros[1]:GetPos()
	------------------------------------------
	local getRow = function(nPos)
		local MAX_ROW = 3
		nPos = nPos or 1;
		local nRow = nPos%MAX_ROW
		if nRow == 0 then 
			nRow = MAX_ROW;
		end
		return nRow
	end
	local getCol = function(nPos)
		local MAX_ROL = 3;
		nPos = nPos or 1
		local nCol = (math.floor((nPos-1)/MAX_ROL))%MAX_ROL + 1
		return nCol;
	end
	
	local getOrderByPos = function(nPos, tbTargets)
		local MAX_MAGIC = 3
		local MAX_NUM = MAX_MAGIC * MAX_MAGIC;
		local tbOrder = {}
		local bIsEnemy = false
		local nTargetPos = nPos + MAX_NUM
		if nPos > MAX_NUM then
			bIsEnemy = true;
			nTargetPos = nPos - MAX_NUM
		end

		local tbRows = {}
		local nRow = getRow(nTargetPos)
		table.insert(tbRows, nRow)
		for i=1, MAX_MAGIC do
			if i ~= nRow then
				table.insert(tbRows, i);
			end
		end


		for _, row in ipairs(tbRows) do
			for i=1, MAX_MAGIC do
				local nNewPos = (i-1)*MAX_MAGIC + row
				if nTargetPos > MAX_NUM then
					nNewPos = (i+2)*MAX_MAGIC + row;
				end
				table.insert(tbOrder, nNewPos);
			end
		end
		return tbOrder;
	end

	local targets = {}
	local nMax = 999;---???question:放一个最大值
	if type(tbTargets) ~= "table" then
		cclog("[Error]tbTargets is not table!@GetTarget()")
		return false, nMax;
	end
	local tbOrder = getOrderByPos(nPos, tbTargets)
	local tbHashTargets = {}
	for _, target in pairs(tbTargets) do
		local pos = target:GetPos()
		tbHashTargets[pos] = target;
	end

	for _, pos in pairs(tbOrder) do
		local hero = tbHashTargets[pos]

		-- if hero and hero:GetState() == KGC_NAMESPACE_FIGHT.STATE_FIGHT_ALIVE then
		local nType, tbState = l_tbFSIndex.LIFE, l_tbFightState[l_tbFSIndex.LIFE]
		if hero and hero:GetState(nType) == tbState.ALIVE then
			table.insert(targets, hero)
			return targets, nIndex;
		end
	end

	return false, nMax;
end

--@function: 构造技能圆桌并且返回概率
function KGC_FightHall:ConstructSkillTable(heros, tbShip)
	if not tbShip then
		return;
	end
	
	heros = heros or {}
	-- 技能槽技能构造圆桌
	local slot = KGC_DATA_FIGHT_SKILL_SLOT_TYPE.new()
	for _, hero in pairs(heros) do
		if hero then
			-- tst_PrintTime(4000)
			local skillSlot = hero:GetHeroObj():GetSlot();
			-- tst_PrintTime(4002)
			for _, skill in pairs(skillSlot) do
				if skill and skill.IsSkill and skill:IsSkill() then
					slot:Insert(skill, hero)
				end
			end


			--合作技能
			local skillCombo = hero:GetHeroObj():GetComboSkill();
			for _, skill in pairs(skillCombo) do
				if skill and skill.IsSkill and skill:IsSkill() then
					slot:Insert(skill, hero)
				end
			end
		end
	end
-- tst_PrintTime(3001)
	-- 普攻技能概率计算
	slot:FillNormal(heros)

	--圆桌随机
	local tbPro = self.m_tbSkillPro[1]
	if self.m_nCurRound >= self.m_nLoseControlTurn then
		tbPro = self.m_tbSkillPro[0]
	else
		--找到最大费用的概率
		local nMaxIndex = 1;
		for k, v in pairs(self.m_tbSkillPro) do
			if tbShip:GetCost() >= k and k > nMaxIndex then
				nMaxIndex = k;
				tbPro = v;
			end
		end
	end

	return slot, tbPro;
end

function KGC_FightHall:RandomSkill(heros, tbShip, nCost)
	if not tbShip then
		return false;
	end

	local slot, tbPro = self:ConstructSkillTable(heros, tbShip);
	--test
	if DEBUG_SEED then
		local szLog = "RandomSkill:gf_GetRandomIndex\n";
		tst_write_file("tst_random_function.txt", szLog);
	end
	--test end
	--如果已经指定费用了,就不随机了(eg:多重施法)
	local nCost = nCost;
	if not nCost then
		nCost = gf_GetRandomIndex(tbPro)
	end
	-- print("随机费用为：", nCost)
-- tst_PrintTime(3002)
	return slot:RandomSkill(nCost)
end

--@function：根据ID播放指定技能
function KGC_FightHall:GetSkillByID(heros, tbShip, nID)
	if not tbShip then
		return false;
	end

	local slot, tbPro = self:ConstructSkillTable(heros, tbShip);
	local nCost = gf_GetRandomIndex(tbPro)
	
	return slot:GetSkillByID(nID, nCost);
end

--
function KGC_FightHall:GetAttackerByPos(tbHeros, nPos)
	nPos = nPos or 1;
	if type(tbHeros) ~= "table" then
		return {};
	end
	local tbAttacker = {}
	local i = 1

	--[[
	(1)每次都是从上次遍历的位置之后开始找
	(2)三个角色当作一个整体一次性取出来
	修改：
	(1)2015/05/15: 人先动，生物后动
	]]

	--bFlag: 是否查找英雄
	local fnFindCircle = function(tbHeros, bFlag)
		local tbFind = {}
		local bIsHero = false;
		
		for i=1, #tbHeros do
			hero = tbHeros[i]
			if (not bFlag) or (bFlag and hero:GetHeroObj():IsBloodShare()) then
				if hero:GetState(l_tbFSIndex.ATTACKABLE) == true and hero:GetState(l_tbFSIndex.LIFE) == l_tbFightState[l_tbFSIndex.LIFE].ALIVE then
					local obj = hero:GetHeroObj()
					if obj:IsBloodShare() then
						table.insert(tbFind, hero)
						--把所有英雄一起找出来
						bIsHero = true;
					elseif not bIsHero then
						table.insert(tbFind, hero)
						break;
					end
				end
			end
		end
		
		return tbFind;
	end

	--先找英雄, 再找生物(需求：英雄先动，再是生物)
	tbAttacker = fnFindCircle(tbHeros, true)
	if #tbAttacker <= 0 then
		tbAttacker = fnFindCircle(tbHeros)
	end
	
	return tbAttacker, i;

end

function KGC_FightHall:GetAttackerByObj(tbHeros, launcher)
	if type(tbHeros) ~= "table" then
		return {};
	end
	local tbAttacker = {}
	for _, npc in ipairs(tbHeros) do
		if npc == launcher then
			-- print("找到了相同的攻击者, 正确！")
			table.insert(tbAttacker, npc)
		end
	end
	if #tbAttacker <= 0 then
		print("[Error]大大的错误！竟然没有找到相同的攻击者！")
	end
	
	-- table.insert(tbAttacker, launcher)
	return tbAttacker;
end

function KGC_FightHall:GetAttackerAndSet(tbHeros, nPos)
	local tbAttacker, i = self:GetAttackerByPos(tbHeros, nPos)

	if type(tbAttacker) ~= "table" then
		return;
	end

	return tbAttacker, i;
end

function KGC_FightHall:AfterAttack(tbAttacker, tbFirst, tbSecond)		
	print("设置状态，英雄个数：", #tbAttacker)
	for _, hero in pairs(tbAttacker) do
		print("英雄位置：", hero:GetPos())
		hero:SetState(l_tbFSIndex.ATTACKABLE, false);
	end
	
	if self:IsOver(tbFirst, tbSecond) then
		print("Game Over!!!")
		return true;
	end
	return false;
end

--@param: tbAttacker攻击方
--@param：tbTarget 被攻击方
--@nPos：攻击方的几号位攻击
--@products:结果数据类对象
--@tbSrc：{触发本技能的角色(连携、多重施法释放者), 触发本技能的类型(标记是否是重新释放技能)}
function KGC_FightHall:Attack(tbAttacker, tbTarget, nPos, products, tbSrc, nCost, skillSrc)
	if not tbAttacker or not tbTarget then
		cclog("[Error]没有战斗数据！(No Fight Data)")
		return;
	end
	local tbAttackerHeros = tbAttacker:GetHeros()
	local tbTargetHeros = tbTarget:GetHeros()
	cclog("[Fight]攻击者个数(%d) vs 受击者个数(%d)", #tbAttackerHeros, #tbTargetHeros)
	if type(tbAttacker) ~= "table" or type(tbTarget) ~= "table" then
		cclog("[Error]没有角色数据！(No Heros Data @ Attack)")
		return;
	end
	
	local heros, i = self:GetAttackerAndSet(tbAttackerHeros, nPos) or {};
	if skillSrc then
		-- heros = {skillSrc:GetLauncher()}
		heros = {skillSrc:GetCaster()}
		cclog("[log]已经有技能了:%s", skillSrc:GetName());
	end

	--test
	print("[Warning]GetAttackerAndSet nNum(可行动人数):", #heros)
	-- tst_PrintTime(2000)
	--test end
	local tbLauncher, tbDefend, tbRetState, nRet = nil, nil, nil, l_tbSkillCastRet.SUCCESS;
	local launcher = nil
	local skill = skillSrc
	if #heros > 0 then
		self.m_LastAttacker = tbAttacker;
		-- tst_PrintTime(2001)
		--选定技能
		if not skill then
			if self.m_nHeroBoxID then
				skill = self:GetConfigSkill(heros, tbAttacker);
			else
				skill = self:RandomSkill(heros, tbAttacker, nCost);
			end
		end
		-- tst_PrintTime(2002)
		local attackers = heros;	--skill:GetHeros();
		--确定技能来源
		-- launcher = skill:GetLauncher()
		launcher = skill:GetCaster()
		print("[Fight]随机到的技能英雄位置为：", launcher:GetPos())
		local tbLaunchers = self:GetAttackerByObj(tbAttackerHeros, launcher)
		-- print("攻击者状态：", launcher:GetState(l_tbFSIndex.LIFE), #tbLaunchers)
		if #tbLaunchers <= 0 then
			return false;
		end
		local targets, nCamp = self:GetTarget(tbTargetHeros, tbAttackerHeros, 1, heros, skill)

		skill:SetSrcInfo(tbSrc)
		if tbSrc or self:CheckCast(tbAttacker, launcher, tbTarget, targets, skill) then
			--释放技能(包括一系列公式计算，这些都丢给技能计算)，返回结果
			if type(targets) == "table" and #targets > 0 then
				-- tst_PrintTime(2003)
				tbLauncher, tbDefend, tbRetState, nRet = g_SkillManager:CastSkill(attackers, targets, skill)
				-- tst_PrintTime(2004)
			else
				cclog("[Warning]技能目标对象不存在或者错误!");
			end
			tbAttacker:UpdateHP();
			tbTarget:UpdateHP();
if not _SERVER then
			local shipDef = tbTarget
			if nCamp == l_tbCamp.MINE then
				shipDef = tbAttacker;
			end
			products:Add(tbAttacker, tbLauncher, shipDef, tbDefend, self.m_nCurRound, tbRetState, {nRet, tbSrc})
end
			--test
			local nDamage = 0
			if tbDefend and #tbDefend > 0 then
				local data = tbDefend[1]:GetData()
				if data then
					_, _, _, nDamage = data:GetDamage();
				end
			end
			if type(targets) == "table" then
				local target = targets[1]
				local testStr = hero:GetPos() .. "-->"
				if target then
					local hero = launcher
					testStr = testStr .. target:GetPos() .. "  " .. skill:GetID() .. "(" .. nDamage .. ")"
					testStr = testStr .. self:TestGetHerosHP(tbAttackerHeros) .. ", "
					testStr = testStr .. self:TestGetHerosHP(tbTargetHeros)
				end
				print(testStr)
			else
				print(hero:GetPos() .. "--> ?")
			end
			--test end
		end
	end
		
	--@return: 攻击源, 位置, 技能释放结果, 需要设置标记的英雄，需要一些数据的技能对象
	return launcher, i, nRet, heros, skill;
end

--@function: 攻击完整一套，包括触发技能和连携在内算一次
--@Noitfy:每一次攻击Attack()都要检查是否结束
function KGC_FightHall:AttackOneTime(tbAttacker, tbTarget, nPos, products, nCastRet, nCost, skillSrc)
	--test
	tst_PrintTime(3);
	print("内存消耗aaa：", collectgarbage("count"))
	local nStartTime = os.clock();
	--test end
	local launcher, i, nRet, heros, skill = self:Attack(tbAttacker, tbTarget, nPos, products, nCastRet, nCost, skillSrc)
	
	if self:AfterAttack({}, tbAttacker, tbTarget) then
		return launcher, i, nRet, heros;
	end
	
	-- tst_PrintTime(1000)
	--再次释放技能
	if not skillSrc then
		if nRet == l_tbSkillCastRet.MAGIC then
			print("多重施法！")
			if skill then
				local tbCost = skill:GetMulCost()
				local tbMagicSkills = {}
				for k, v in ipairs(tbCost) do
					print("多重施法-费用", v)
					local tbSrc = {launcher, nRet}
					local _, _, _, _, skillmagic = self:Attack(tbAttacker, tbTarget, i, products, tbSrc, v)
					if skillmagic then
						table.insert(tbMagicSkills, skillmagic);
					end
					if self:AfterAttack({}, tbAttacker, tbTarget) then
						skill:SetSubSkills(tbMagicSkills)
						return launcher, i, nRet, heros;
					end
				end
				print("magic skills, ", tbMagicSkills, #(tbMagicSkills or {}))
				--多重施法保存接下来的技能(技能存有释放者)
				skill:SetSubSkills(tbMagicSkills)
			end

		elseif nRet ~= l_tbSkillCastRet.SUCCESS then
			print("重新释放技能(选择的攻击源位置)", launcher and launcher:GetPos(), nRet)
			self:AfterAttack({launcher}, tbAttacker, tbTarget)
			local tbSrc = {launcher, l_tbSkillCastRet.RETRY}
			self:Attack(tbAttacker, tbTarget, i, products, tbSrc)
			
			if self:AfterAttack({}, tbAttacker, tbTarget) then
				return launcher, i, nRet, heros;
			end
		end
	end

	--处理触发技能
	if g_tbTriggerSkills then
		print("处理触发技能, 个数：", #g_tbTriggerSkills)
		local tbSkills = g_tbTriggerSkills or {};
		g_tbTriggerSkills = {};
		print("开始处理触发技能 .............................", #tbSkills)
		for _, skill in ipairs(tbSkills) do
			cclog("触发技能(%s)触发！", skill:GetName())
			table.remove(tbSkills)
			self:Attack(tbAttacker, tbTarget, 1, products, nil, nil, skill)
			
			if self:AfterAttack({}, tbAttacker, tbTarget) then
				return launcher, i, nRet, heros;
			end
		end
		print("处理触发技能结束 .............................")
		g_tbTriggerSkills = {};
	end
	
	--test
	tst_PrintTime(4);
	print("内存消耗bbb：", collectgarbage("count"))
	local nEndTime = os.clock();
	print("********** 攻击一次的时间：", nEndTime - nStartTime)
	--test end
	return launcher, i, nRet, heros;
end

--@function: 释放技能条件判断
--@objAttackShip: 技能释放者团队
--@objAttacker: 技能释放者NPC/英雄
--@objTargetShip: 技能受击者团队
--@tbObjTargets: 技能受击者英雄table
--@skill: 技能
function KGC_FightHall:CheckCast(objAttackShip, objAttacker, objTargetShip, tbObjTargets, skill)
	local nDeductCost = self:GetDeductCost(objAttacker, skill);
	--保存
	objAttackShip:SetTempCost(objAttackShip:GetCost(), 0)
	--扣除费用
	local nLeft = objAttackShip:GetCost() - nDeductCost;
	print(string.format("扣除费用：%d, 剩余：%d", nDeductCost, nLeft))
	if nLeft < 0 then
		cclog("[Warning]费用不足，不能够释放该技能!");
		return false;
	end
	objAttackShip:SetCost(nLeft)
	
	return true;
end

--@param: tbFirst:先手；tbSecond:后手
function KGC_FightHall:CalcATurn(tbFirst, tbSecond, products)
	local nStartTime = os.clock();
	tst_PrintTime(1);
	print("内存消耗xxx：", collectgarbage("count"))
	if not tbFirst or not tbSecond or not products then
		print("[Error]没有战斗数据！(No Fight Data)")
		return;
	end
	--记录每一轮开始前的费用
	products:SetCost(self.m_nCurRound, tbFirst, tbSecond)
	local tbFirHeros = tbFirst:GetHeros()
	local tbSecHeros = tbSecond:GetHeros()
	if type(tbFirHeros) ~= "table" or type(tbSecHeros) ~= "table" then
		print("[Error]没有角色数据！(No Heros Data @CalATurn)")
		return;
	end
	--回合开始
	local tbStartRet = g_CondTrigger:Notify(self, l_tbCondID.ROUND_START)
if not _SERVER then
	--放在前一回合的最后一轮中
	local nTurn = products:GetTotalNum();
	-- products:InsertRetStateByRound(nTurn, tbStartRet);
	products:InsertRetStateByRound(self.m_nCurRound, tbStartRet);
end
	--???question:打完之前数据再做一次检测,是否有攻击和被攻击的对象？
	--???question:直接放到IsOver那里好了
	local nFirHeros = #tbFirHeros or 0;
	local nSecHeros = #tbSecHeros or 0;
	print("====================================", self.m_nCurRound)
	print("m_nCurRound(人数1, 人数2)", nFirHeros, nSecHeros)
	--记录本轮有没有出手
	self.m_LastAttacker = nil

	local tbHeros1 = self:GetAttackerByPos(tbFirHeros) or {}
	local tbHeros2 = self:GetAttackerByPos(tbSecHeros) or {}
	local launcher1, nPos1, nRet1
	local launcher2, nPos2, nRet2

	local nRet = l_tbSkillCastRet.FAILED;
	local nCount = 0;
	
	-- g_nTestTicks = 2;
	-- print(g_nTestTicks, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", os.clock())
	while  #tbHeros1 > 0 or #tbHeros2 > 0 do
		print("/**/turn of Round:", nCount .. "/" .. self.m_nCurRound)
		print(">>>>>>---------------------->>>>>>", nCount)
		for k, v in pairs(tbFirHeros) do
			print("攻击前英雄位置：", v:GetPos())
		end
		launcher1, nPos1, nRet, tbHeros1 = self:AttackOneTime(tbFirst, tbSecond, nPos1, products)
		if self:AfterAttack(tbHeros1, tbFirst, tbSecond) then
			break;
		end

		print("<<<<<<------------------------<<<<<<", nCount)
		for k, v in pairs(tbSecHeros) do
			cclog("攻击前英雄位置(%d)", v:GetPos())
		end
		launcher2, nPos2, nRet2, tbHeros2 = self:AttackOneTime(tbSecond, tbFirst, nPos2, products)
		if self:AfterAttack(tbHeros2, tbFirst, tbSecond) then
			break;
		end
		
		tbHeros1 = self:GetAttackerByPos(tbFirHeros, nPos1) or {}
		tbHeros2 = self:GetAttackerByPos(tbSecHeros, nPos2) or {}
		-- print("#tbHeros1, #tbHeros2", #tbHeros1, #tbHeros2)
		nCount = nCount + 1;
	end

	--回合结束
	local tbRet = g_CondTrigger:Notify(self, l_tbCondID.ROUND_END)
if not _SERVER then
--	for _, data in pairs(tbRet) do
--		data:SetTriggerConID(l_tbCondID.ROUND_END)
--	end
	local nTurn = products:GetTotalNum();
	-- products:InsertRetState(nTurn, tbRet);
	products:InsertRetStateByRound(self.m_nCurRound, tbRet);
	
	g_nTestTicks = 2;
	print(g_nTestTicks, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", os.clock())
	print("内存消耗yyy：", collectgarbage("count"))
	local nEndTime = os.clock();
	print("@@@@@@@@@@@@@@@@@@@@@@一轮时间：", nEndTime - nStartTime)
end

end

function KGC_FightHall:IsAllDead(tbFightData)
	if type(tbFightData) ~= "table" then
		print("[Error]IsAllDead Data Error!")
		return true;
	end

	local bRet = false
	cclog("@IsAllDead, 阵营(%d), hp = %d", tbFightData:GetCamp(), tbFightData:GetHP())
	if tbFightData:GetHP() <= 0 then
		bRet = true;
	end

	return bRet;
end

--???question:名字要不要再改下
--@funtion:判断是否结束，谁输谁赢
function KGC_FightHall:IsOver(tbFirst, tbSecond)
	if type(tbFirst) ~= "table" or type(tbSecond) ~= "table" then
		print("[Error]Data Error(IsOver)!")
		return true;
	end
	return self:IsAllDead(tbFirst) or self:IsAllDead(tbSecond);
end

function KGC_FightHall:WhoWins(tbFirst, tbSecond)
	tbFirst = tbFirst or {}
	tbSecond = tbSecond or {}
	local bFirDead = self:IsAllDead(tbFirst)
	local bSecDead = self:IsAllDead(tbSecond)

	local nRet = self.FIGHT_RESTULT_NONE;
	local winner = nil
	if bSecDead then
		nRet = self.FIGHT_MINE_SHIP_WIN;
		winner = tbFirst;
	else --先手死了或者后手没死都是后手赢
		nRet = self.FIGHT_ENEMY_SHIP_WIN;
		winner = tbSecond;
	end

	--若出现双方同时角色全灭，轮到释放技能的角色一方胜利
	if bFirDead and bSecDead then
		if self.m_LastAttacker == tbFirst then
			nRet = self.FIGHT_MINE_SHIP_WIN
			winner = tbFirst;
		elseif self.m_LastAttacker == tbSecond then
			nRet = self.FIGHT_ENEMY_SHIP_WIN;
			winner = tbSecond;
		end
	end

	--
	if self.m_nFirst == self.FIGHT_ORDER_ENEMY_FIRST then
		nRet = (self.FIGHT_ENEMY_SHIP_WIN+self.FIGHT_MINE_SHIP_WIN) - nRet;
	end
	print("who is winer: ", winner:GetCamp())
	return winner:GetCamp();
end

function KGC_FightHall:RefreshPerTurn(tbFirst, tbSecond)
	----------------------------------------------
	--每一轮攻击之前,重新排序
	tbFirst:ReOrderHeros()
	tbSecond:ReOrderHeros()

	--清标记
	self:RefreshShip(tbFirst)
	self:RefreshShip(tbSecond)

	-- tbFirst:UpdateCost()
	-- tbSecond:UpdateCost();
	tbFirst:UpdateHP();
	tbSecond:UpdateHP();
end

function KGC_FightHall:RefreshShip(tbFightShip)
	assert(tbFightShip);
	if type(tbFightShip) ~= "table" then
		return;
	end
	for index, hero in pairs(tbFightShip:GetHeros()) do
		hero:SetState(l_tbFSIndex.ATTACKABLE, true)
		-- local nCost = hero:GetCost() + self.m_nCostAdd;
		-- if nCost > self.m_nMaxCost then
			-- nCost = self.m_nMaxCost;
		-- end
		-- if hero:GetHeroObj():IsHero() then
			-- hero:SetCost(nCost);
		-- else
			-- hero:SetCost(0)
		-- end
	end

	self:UpdateCost(tbFightShip);
end

function KGC_FightHall:UpdateCost(tbFShip)
	local nCostTemp = tbFShip:GetCost();
	local nAdd = self.m_nCostAdd or 1;

	local nCurRound = self.m_nCurRound;
	local nCost = nCurRound;
	if nCost > self.m_nMaxCost then
		nCost = self.m_nMaxCost;
		nAdd = 0;
	end
	print("UpdateCost ......................", nCost, nCurRound);
	tbFShip:SetMaxCost(nCost)
	
	local nCurMaxCost = tbFShip:GetMaxCost();
	--保存增加特效需要的数据
	tbFShip:SetTempCost(nCostTemp, nAdd);

	print("updatecost", nCost, nCurMaxCost, nAdd)
	-- 每一轮开始费用都填满
	tbFShip:SetCost(nCurMaxCost)
end

g_nTestTicks = 1;
function KGC_FightHall:Fight(nSeed, nRewardID)
	print("内存消耗0：", collectgarbage("count"))
	--test
	local tmStart = os.time()
	local nStartTime = os.clock();
	--test end
	--每次战斗前清理数据
	self:Clear();
	print("内存消耗1：", collectgarbage("count"))
	local tbFirst, tbSecond = self:FightBefore();
	local products = self.m_tbProducts;
	
	--战斗循环
	print("/**********************************************************************/")
	print("start fight .................", self.m_nCurRound, self.m_nMaxTurn)
	while self.m_nCurRound <= self.m_nMaxTurn do
		self:RefreshPerTurn(tbFirst, tbSecond)
		--放在前面检查
		if self:IsOver(tbFirst, tbSecond) then
			print("[Log]****************Game Over!!!****************")
			break;
		end

		self:CalcATurn(tbFirst, tbSecond, products)
		self.m_nCurRound = self.m_nCurRound + 1;
	end
	
	self.m_nWinCamp = self:WhoWins(tbFirst, tbSecond)
	self:FightAfter();
	
	if DEBUG_SEED then
		--test
		if DEBUG_SEED then
			local szLog1 = self.m_nWinCamp .. ", " .. tostring(nSeed) .. ", " .. (g_nTestCount or 0) .. "\n";
			tst_write_file("tst_result.txt", szLog1);
			
			local szLog2 = "over:" .. self.m_nWinCamp .. ", " .. tostring(nSeed) .. ", " .. (g_nTestCount or 0) .. "\n";
			tst_write_file("tst_random_function.txt", szLog2);
			
			local szLog3 = "over:" .. self.m_nWinCamp .. ", " .. tostring(nSeed) .. ", " .. (g_nTestCount or 0) .. "\n";
			tst_write_file("tst_random.txt", szLog3);
		end
		--test end
		g_nTestCount = 0;
	end
if _SERVER then
	g_nWinner = self.m_nWinCamp;
	-- 剩余血量百分比
	local fnGetLeftHP = function(nLeft, nMax)
		local nLeft = nLeft or 0;
		local nRet = 0;
		if nMax and nMax > 0 then
			nRet = nLeft/nMax;
			if nRet < 0 then
				nRet = 0;
			end
		else
			nRet = 0;
		end
		return nRet;
	end
	local nMineMaxHP = self.m_tbFighter[l_tbCamp.MINE]:GetMaxHP();
	local nMineLeftHP = self.m_tbFighter[l_tbCamp.MINE]:GetHP()
	g_nMineHPRate = fnGetLeftHP(nMineLeftHP, nMineMaxHP);
	
	local nEnemyMaxHP = self.m_tbFighter[l_tbCamp.ENEMY]:GetMaxHP();
	local nEnemyLeftHP = self.m_tbFighter[l_tbCamp.ENEMY]:GetHP()
	g_nEnemyHPRate = fnGetLeftHP(nEnemyLeftHP, nEnemyMaxHP)
end
	--test
	local tmEnd = os.time()
	local nEndTime = os.clock();
	print("战斗耗时：", tmEnd - tmStart, nEndTime - nStartTime)
	
	print("内存消耗2：", collectgarbage("count"))
	collectgarbage("collect")
	print("内存消耗3：", collectgarbage("count"))
	collectgarbage("collect")
	print("内存消耗3.1：", collectgarbage("count"))
	--test end
	return self.m_nWinCamp, products;
end

function KGC_FightHall:GetProducts()
	return self.m_tbProducts;
end

function KGC_FightHall:GetWinner()
	return self.m_nWinCamp;
end

function KGC_FightHall:getInstance()
	if not KGC_FightHall._instance then
		KGC_FightHall._instance = KGC_FightHall.new();
	end
	
	return KGC_FightHall._instance;
end

function KGC_FightHall:AddCounter(nNum)
	local nNum = nNum or 1;
	self.m_nCounter = self.m_nCounter + 1;
end

function KGC_FightHall:GetCounter()
	if not self.m_nCounter then
		self.m_nCounter = 0;
	end
	return self.m_nCounter;
end

--@function: 获取某个英雄对应技能要扣除的费用
function KGC_FightHall:GetDeductCost(npc, skill)
	local nCost = 0;
	if skill then
		nCost = skill:GetCost();
	end
	
	-- 英雄状态改变费用消耗值
	if npc then
		-- 注意：返回值是带正负的, 只管加上去就好了
		local nChange = npc:GetHeroObj():GetCostExtra();
		nCost = nCost + nChange;
	end
	
	if nCost <= 0 then
		nCost = 0;
	end
	cclog("[log]技能费用消耗(%d) --> 结果消耗(%d)", skill:GetCost(), nCost);
	return nCost;
end

function KGC_FightHall:FightWithConfig(nSeed, nRewardID, nHeroBoxID)
	--每次战斗前清理数据
	self:Clear();
	self.m_nHeroBoxID = nHeroBoxID;
	
	local tbFirst, tbSecond = self:FightBefore();
	local products = self.m_tbProducts;
	--战斗循环
	print("/**********************************************************************/")
	print("start fight with config .................", nHeroBoxID, self.m_nCurRound, self.m_nMaxTurn)
	while self.m_nCurRound <= self.m_nMaxTurn do
		self:RefreshPerTurn(tbFirst, tbSecond)
		--放在前面检查
		if self:IsOver(tbFirst, tbSecond) then
			print("[Log]****************Game Over!!!****************")
			break;
		end

		self:CalcATurn(tbFirst, tbSecond, products)
		self.m_nCurRound = self.m_nCurRound + 1;
	end
	
	self.m_nWinCamp = self:WhoWins(tbFirst, tbSecond)
	self:FightAfter();

	return self.m_nWinCamp, products;
end

--@function: 走配置表释放技能(新手指引)
--@notify: 每一回合放指定费用的技能，1回合1费，2回合2费 ...
function KGC_FightHall:GetConfigSkill(heros, tbShip)
	if not self.m_tbFightWithConfig then
		self.m_tbFightWithConfig = {};
		self.m_tbFightWithConfig.tbSkills = {};
		self.m_tbFightWithConfig.tbSkills[l_tbCamp.MINE] = 0;
		self.m_tbFightWithConfig.tbSkills[l_tbCamp.ENEMY] = 0;
	end
	local nCamp = tbShip:GetCamp();
	local tbConfig = l_tbHeroBox[self.m_nHeroBoxID] or {};
	local tbSkillIDs = tbConfig.skills_1 or {};
	if nCamp == l_tbCamp.ENEMY then
		tbSkillIDs = tbConfig.skills_2 or {};
	end
	tst_print_lua_table(tbSkillIDs);
	
	-- 统计用
	self.m_tbFightWithConfig.tbSkills[nCamp] = self.m_tbFightWithConfig.tbSkills[nCamp] + 1;
	local nID = 0;
	--召唤物不配置
	if heros and heros[1] and not heros[1]:GetHeroObj():IsSummon() then
		print("[log]不是召唤物，读取配置表技能！");
		nID = tbSkillIDs[self.m_tbFightWithConfig.tbSkills[nCamp]];
	end
	local skill = self:GetSkillByID(heros, tbShip, nID);
	
	-- local skill = self:RandomSkill(heros, tbShip, self.m_nCurRound);
	--test
	print("[log]GetConfigSkill得到的技能ID为：", self.m_nCurRound, nID, self.m_tbFightWithConfig.tbSkills[nCamp], skill:GetName(), skill:GetCost());
	--test end
	return skill;
end
----------------------------------------------------------
--数据结构

----------------------------------------------------------
--宏定义
KGC_FightHall.FIGHT_RESTULT_NONE = 0		--平局
KGC_FightHall.FIGHT_MINE_SHIP_WIN = 1		--我方赢
KGC_FightHall.FIGHT_ENEMY_SHIP_WIN = 2		--敌方赢

KGC_FightHall.FIGHT_ORDER_MINE_FIRST = 1	--我方先手
KGC_FightHall.FIGHT_ORDER_ENEMY_FIRST = 2	--敌方先手

----------------------------------------------------------
--
KGC_FIGHT_MANAGER_TYPE = class("KGC_FIGHT_MANAGER_TYPE", CLASS_BASE_TYPE, TB_FIGHTHALL_DATA)
function KGC_FIGHT_MANAGER_TYPE:CreateFightHall()
	self.m_FightHall = KGC_FightHall.new()
	return self.m_FightHall;
end

function KGC_FIGHT_MANAGER_TYPE:GetFightHall()
	return self.m_FightHall;
end

local TB_FIGHTHALL_MANGER_DATA = {
	m_FightHall = false;
}
--relization
g_FightMgr = KGC_FIGHT_MANAGER_TYPE.new(TB_FIGHTHALL_MANGER_DATA)
----------------------------------------------------------
--test
----------------------------------------------------------
function KGC_FightHall:TestGetHerosHP(tbHeros)
	local str = "{"
	for k, hero in pairs(tbHeros) do
		str = str .. hero:GetHP() .. ","
	end
	str = str .. "}"
	return str;
end
--===================================_SERVER============================================
if _SERVER then

function KGC_FightHall:Start(nRand, player, enemy, nRewardID)
	-- print("$$$$$$$$$$$$$$$$$$$", nRand, player, enemy)
	-- tst_print_lua_table(player);
	-- tst_print_lua_table(enemy);
	gf_SetRandomSeed(nRand)
	local objPlayer = g_PlayerFactory:CreatePlayer(player)
	local objEnemy = g_PlayerFactory:CreatePlayer(enemy)

	-- for i = 1, 10 do
		self:Init(objPlayer, objEnemy)
		-- local seed = gf_Random(100000)
		-- gf_SetRandomSeed(seed)
		self:Fight(nRand, nRewardID)
	-- end
end

function KGC_FightHall:StartFightWithMonster(nSeed, player, nMBID, nRewardID)
	gf_SetRandomSeed(nSeed)
	
	local objPlayer = g_PlayerFactory:CreatePlayer(player)
	local objEnemy = g_PlayerFactory:CreateMonsterBox(nMBID)
	self:Init(objPlayer, objEnemy)
	self:Fight(nSeed, nRewardID)
	
	return true;
end

if not _SERVER_Fight then
_SERVER_Fight = KGC_FightHall.new()
end
-- DEBUG_SEED = true;
-- _SERVER_Fight:Start(_SERVER_randseed, _SERVER_player, _SERVER_enemy);
_SERVER_Fight:StartFightWithMonster(_SERVER_nSeed, _SERVER_player, _SERVER_nMBID, _SERVER_nRewardID);
end
--===================================_SERVER  END=======================================
