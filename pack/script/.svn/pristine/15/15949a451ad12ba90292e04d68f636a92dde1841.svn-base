--minifight模块，用于战斗计算
module("minifight", package.seeall)

-- local socket = require("socket.core")

local osprint = print
print = function(...)
	if not _SERVER then
		local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
			osprint(...);
			return;
		end
	end
	
	local f = io.open('minifight', 'a+')
	f:write(table.concat({...}, '\t') .. '\n')
	f:close()
end


require("script/core/minifight/minidef")
require("script/core/minifight/minifunc")
require("script/core/minifight/fighter")
require("script/core/configmanager/configmanager");

local tbMonster = mconfig.loadConfig("script/cfg/battle/monster")
local tbMonsterBox = mconfig.loadConfig("script/cfg/battle/monsterbox")
local tbSkill = mconfig.loadConfig("script/cfg/skills/skills")
local tbSkillResult = mconfig.loadConfig("script/cfg/skills/skillresults")
local tbStatus = mconfig.loadConfig("script/cfg/skills/status")
local tbStatusType = mconfig.loadConfig("script/cfg/skills/statustype")

--对阵血量贴图
function printHP(fightManager)
	local tbStr = {}
	local meHp = fightManager.fighters[minidef.ME].totalHP
	local obsHp = fightManager.fighters[minidef.OBS].totalHP
	print('################################')
	table.insert(tbStr, '敌方        '..obsHp..'\n')
	table.insert(tbStr, '(4)----\t')
	table.insert(tbStr, '(5)----\t')
	table.insert(tbStr, '(6)----\n')

	for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
		if fightManager.fighters[minidef.OBS][i] then
			table.insert(tbStr, '('..i..')'..fightManager.fighters[minidef.OBS][i].nHP..'\t')
		else
			table.insert(tbStr, '('..i..')'..'----\t')
		end
	end
	table.insert(tbStr, '\n\n')

	for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
		if fightManager.fighters[minidef.ME][i] then
			table.insert(tbStr, '('..i..')'..fightManager.fighters[minidef.ME][i].nHP..'\t')
		else
			table.insert(tbStr, '('..i..')'..'----\t')
		end
	end
	table.insert(tbStr, '\n')

	table.insert(tbStr, '(4)----\t')
	table.insert(tbStr, '(5)----\t')
	table.insert(tbStr, '(6)----\n')
	table.insert(tbStr, '我方        '..meHp)

	print(table.concat(tbStr))
	print('################################')
end

--开始战斗
function startFight(fighter1, fighter2, seed)
	minifunc.setSeed(seed)

	local ST = os.clock()
	local ct = os.clock()
	if type(fighter1) ~= 'table' or type(fighter2) ~= 'table' then
		print('战斗数据为空', fighter1, fighter2)
		return
	end
	local fightManager = createManager(fighter1, fighter2)
	fightManager.data = {}
	local co = coroutine.create(function (fightManager)
		--战斗主循环
		for i = minidef.BEGIN_TURN, minidef.MAX_TURN do
			doTurn(fightManager, i)
		end
	end)

	-- ff = print
	-- print = function()

	-- end

	local _, tb = coroutine.resume(co, fightManager)
	if tb then
		-- print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
		-- minifunc.printTable(fightManager.data)
		-- print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
		-- minifunc.printTable(tb)
		-- print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
		table.insert(fightManager.data[#fightManager.data].op, tb)
	end

	if fightManager.winner == 0 then
		--后手胜利
		if fightManager.black == minidef.ME then
			fightManager.winner = minidef.OBS
		else
			fightManager.winner = minidef.ME
		end
	end
	-- print = ff
	print(getCampName(minidef.ME), '剩余血量 = ', fightManager.fighters[minidef.ME].totalHP, getCampName(minidef.OBS), '剩余血量 = ', fightManager.fighters[minidef.OBS].totalHP)
	print('持续', fightManager.turn, '回合', '先手方 = ', getCampName(fightManager.black), 'winner = ', getCampName(fightManager.winner))
	print('耗时 = ', os.clock() - ST, os.clock() - ct)

	minifunc.printTable(fightManager.data)
	return fightManager.data, fightManager.winner, math.floor(fightManager.fighters[minidef.ME].totalHP / fightManager.fighters[minidef.ME].MaxHP * 100)
end

--创建战斗管理器
function createManager(fighter1, fighter2)
	local fightManager = {
		fighters = {
			[minidef.ME] = fighter1,
			[minidef.OBS] = fighter2,
		},
		turn = 0,
		winner = 0,
		black = 0,
	}

	--随机先手
	fightManager.black = minifunc.random(1, minidef.CAMP_NUM)

	print('双方血量 =', '我方', fightManager.fighters[minidef.ME].totalHP, '对方', fightManager.fighters[minidef.OBS].totalHP)
	print('先手方 =', getCampName(fightManager.black))

	return fightManager
end

--一轮战斗过程
function doTurn(fightManager, turn)
	print('$$$$$$$$$$$$$$$$$$$$', turn, '回合开始$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
	fightManager.turn = turn
	fightManager.data[turn] = {}
	fightManager.data[turn].tCost = {}
	fightManager.data[turn].tCost[minidef.ME] = getTurnCost(fightManager, minidef.ME)
	fightManager.data[turn].tCost[minidef.OBS] = getTurnCost(fightManager, minidef.OBS)
	fightManager.data[turn].op = {}
	fightManager.data[turn].tEndBuff = {}

	--处理释放技能队列
	local tb = condAllProcess(fightManager, minidef.CONDITION_TYPE.TURN_BEGIN)
	for i = 0, #tb do
		table.insert(fightManager.data[turn].op, tb[i])
	end

	--先手方后排
	print('先手方英雄行动$$$$$$$$', getCampName(fightManager.black))
	doHero(fightManager, fightManager.black, turn)
	--后手方后排
	if fightManager.black == minidef.ME then
		print('后手方英雄行动$$$$$$$$$$', getCampName(minidef.OBS))
		doHero(fightManager, minidef.OBS, turn)
	else
		print('后手方英雄行动$$$$$$$$$$', getCampName(minidef.ME))
		doHero(fightManager, minidef.ME, turn)
	end

	--先手方前排
	print('先手方生物行动$$$$$$$$$', getCampName(fightManager.black))
	doSummon(fightManager, fightManager.black, turn)
	--后手方前排
	print('后手方生物行动$$$$$$$$$$')
	if fightManager.black == minidef.ME then
		print('后手方生物行动$$$$$$$$$$', getCampName(minidef.OBS))
		doSummon(fightManager, minidef.OBS, turn)
	else
		print('后手方生物行动$$$$$$$$$$', getCampName(minidef.ME))
		doSummon(fightManager, minidef.ME, turn)
	end

	--处理回合结束条件队列
	tb = condAllProcess(fightManager, minidef.CONDITION_TYPE.TURN_END)
	for i = 0, #tb do
		table.insert(fightManager.data[turn].op, tb[i])
	end
	updateCond(fightManager)
	checkEndFight(fightManager)
	print('$$$$$$$$$$$$$$$$$$$$', turn, '回合结束$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
end

--英雄行动
function doHero(fightManager, camp, turn)
	fightManager.SkillQueue = {}
	fightManager.castSkill = 0
	--[[
		id
		cost
		camp
		idx
		type
	]]

	local tb = {}
	tb.type = minidef.OP_TYPE.skill
	tb.camp = camp

	--随机技能费用
	local cost = randomSkillCost(fightManager, camp)
	local comboIndex, combo = 0, {}
	print('第'..turn..'轮', '英雄行动方', getCampName(camp), '随机技能cost = ', cost)
	tb.skillcost = cost
	--优先判断是否释放合体技能
	if fightManager.fighters[camp].combo[cost] then
		comboIndex = minifunc.getRandomIndex(fightManager.fighters[camp].combo[cost].prop)
	end
	if comboIndex > 0 then
		combo = tbSkill[fightManager.fighters[camp].combo[cost].skill[comboIndex]]
	end

	if #combo > 0 then
		--释放合体技能
		print('释放合体技能', '释放者', combo[2], '技能id', combo[1])
		tb.bcombo = true
		tb.comboheropos = {}
		local comboHero = tbSkill[combo[1]].combo
		local markOK = true
		for j = 1, #comboHero do
			local find = false
			for i = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT do
				if fightManager.fighter[camp][i] and fightManager.fighter[camp][i].id == comboHero[j] then
					table.insert(tb.comboheropos, i)
					if not(fightManager.fighter[camp][i].statusMark[minidef.STATUS_TYPE.DIZZ]) then
						find = true
					end
				end
			end
			if not(find) then
				markOK = false
				break
			end
		end

		if markOK then
			castSkill(fightManager, camp, combo[2], combo[1], tb)
		else
			tb.bcast = false
		end
	else
		randomCostSkill(fightManager, camp, cost, minidef.TARGET_TYPE.HERO, tb)
	end
end

--生物行动
function doSummon(fightManager, camp, turn)
	fightManager.SkillQueue = {}
	fightManager.castSkill = 0
	--前排按照123行动

	for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
		if fightManager.fighters[camp][i] then
			--判断是否眩晕
			if not(condDizz(fightManager, camp, i)) then
				local tb = {}
				tb.type = minidef.OP_TYPE.skill
				tb.camp = camp
				randomCostSkill(fightManager, camp, nil, minidef.TARGET_TYPE.SUMMON, tb, i)
			end
		end
	end
end

--按照费用释放技能
function randomCostSkill(fightManager, camp, cost, type, tOP, pos, rein)
	if type == minidef.TARGET_TYPE.HERO then
		if fightManager.fighters[camp].roundSkill[cost] then
			local skillIdx, skillid, idx = 0, 0, 0
			skillIdx = minifunc.getRandomIndex(fightManager.fighters[camp].roundSkill[cost].prop)
			if skillIdx > 0 then
				skillid = fightManager.fighters[camp].roundSkill[cost].skill[skillIdx][1]
				idx = fightManager.fighters[camp].roundSkill[cost].skill[skillIdx][2]
				minifunc.printTable(fightManager.fighters)
				if fightManager.fighters[camp][idx].statusMark[minidef.STATUS_TYPE.DIZZ] then
					--释放普通攻击
					castNormalAtk(fightManager, camp, tOP)
				else
					--释放主动技能
					print(getCampName(camp), '英雄', idx, '释放主动技能', '技能id', skillid)

					castSkill(fightManager, camp, idx, skillid, tOP, rein)
				end
			else
				--释放普通攻击
				castNormalAtk(fightManager, camp, tOP)
			end
		else
			--释放普通攻击
			castNormalAtk(fightManager, camp, tOP)
		end
	else
		local skillIdx, skillid = 0, 0
		if fightManager.fighters[camp][pos].roundSkill then
			skillIdx = minifunc.getRandomIndex(fightManager.fighters[camp][pos].roundProp)
			if skillIdx > 0 then
				skillid = fightManager.fighters[camp][pos].roundSkill[skillIdx]
				--释放主动技能
				print(getCampName(camp), '生物', pos, '释放普通攻击', '技能id', skillid)
				castSkill(fightManager, camp, pos, skillid, tOP, rein)
			else
				--释放普通攻击
				local normalatkid = getNormalAtk(fightManager.fighters[camp][pos].normalattack, fightManager.turn)
				if normalatkid then
					print(getCampName(camp), '生物', pos, '释放普通攻击', '技能id', normalatkid)
					castSkill(fightManager, camp, pos, normalatkid, tOP)
				end
			end
		else
			--释放普通攻击
			local normalatkid = getNormalAtk(fightManager.fighters[camp][pos].normalattack, fightManager.turn)
			if normalatkid then
				print(getCampName(camp), '生物', pos, '释放普通攻击', '技能id', normalatkid)
				castSkill(fightManager, camp, pos, normalatkid, tOP)
			end
		end
	end
end

--获取普攻技能
function getNormalAtk(normalTable, cost)
	if type(normalTable) == 'table' then
		if normalTable[cost] then
			return normalTable[cost]
		else
			return normalTable[minidef.MAX_COST]
		end
	else
		return nil
	end
end

--释放普通攻击
function castNormalAtk(fightManager, camp, tOP)
	local atkid, tbIdx, ret = 0, {}, 0
	for i = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT do
		if fightManager.fighters[camp][i] and
		   not(fightManager.fighters[camp][i].statusMark[minidef.STATUS_TYPE.DIZZ]) then
			table.insert(tbIdx, i)
		end
	end
	if #tbIdx > 0 then
		ret = minifunc.random(1, #tbIdx)
		local atkid = getNormalAtk(fightManager.fighters[camp][tbIdx[ret]].normalattack, fightManager.turn)
		if atkid then
			print(getCampName(camp), '英雄', tbIdx[ret], '释放普通攻击', '技能id', atkid)
			castSkill(fightManager, camp, tbIdx[ret], atkid, tOP)
		end
	else
		print(getCampName(camp), '英雄普攻释放错误')
	end
end

--获取本回合cost
function getTurnCost(fightManager, camp)
	local cost = fightManager.fighters[camp].addCost + fightManager.turn
	if cost > minidef.MAX_COST then
		return minidef.MAX_COST
	end
	return cost
end

--随机此轮技能费用
function randomSkillCost(fightManager, camp)
	local cost = fightManager.fighters[camp].addCost + fightManager.turn
	if cost > minidef.MAX_COST then
		return minifunc.getRandomIndex(minidef.SKILL_PRO[0])
	else
		return minifunc.getRandomIndex(minidef.SKILL_PRO[cost])
	end
end

--释放一个技能
function castSkill(fightManager, camp, idx, skillid, tb, rein)
	tb.pos = idx
	tb.skillid = skillid
	tb.bcast = true

	if fightManager.castSkill > minidef.MAX_CAST_SKILL then
		tb.bcast = false
		fightManager.castSkill = fightManager.castSkill + 1
		table.insert(fightManager.data[fightManager.turn].op, tb)
		return
	end

	if skillid and fightManager.fighters[camp][idx] then
		local effect = tbSkillResult[tbSkill[skillid].skillresultsid].effecttype
		local targetCamp = getObsCamp(camp)
		local campType = tbSkill[skillid].camp
		if campType == 1 then
			targetCamp = camp
		end

		--处理释放技能条件
		tb.beforeSearchBuff = {}
		local buff = condMe(fightManager, minidef.CONDITION_TYPE.CAST, camp, idx)	--自身
		for i = 0, #buff do
			table.insert(tb.beforeSearchBuff, buff[i])
		end
		buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_CAST, camp, idx)	--友方
		for i = 0, #buff do
			table.insert(tb.beforeSearchBuff, buff[i])
		end
		buff = condCampAll(fightManager, minidef.CONDITION_TYPE.OBS_CAST, getObsCamp(camp))	--敌方
		for i = 0, #buff do
			table.insert(tb.beforeSearchBuff, buff[i])
		end

		--处理释放指定技能条件
		if effect == minidef.SKILL_EFFECT.COMMON then	--普攻
			buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_HERO_NORMAL_ATK, camp, idx)
		elseif effect == minidef.SKILL_EFFECT.MUTIL then
			buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_HERO_MUTIL, camp, idx)
		elseif effect == minidef.SKILL_EFFECT.CALL then
			buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_HERO_CALL, camp, idx)
		else
			buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_HERO_MAGIC, camp, idx)
		end

		for i = 0, #buff do
			table.insert(tb.beforeSearchBuff, buff[i])
		end

		--寻找目标
		local tbTarget = searchTarget(fightManager, camp, targetCamp, idx, skillid, effect)
		if #tbTarget <= 0 then
			print('技能没有找到目标')
			fightManager.castSkill = fightManager.castSkill + 1
			table.insert(fightManager.data[fightManager.turn].op, tb)
			return
		end
		print('目标 = ', table.concat(tbTarget, ','))
		tb.target = {}
		for i = 1, #tbTarget do
			tb.target[tbTarget[i]] = {}
			tb.target[tbTarget[i]].tcamp = targetCamp
			tb.target[tbTarget[i]].bingo = true
		end

		--处理技能命中前条件队列
		-- condProcess(fightManager, minidef.CONDITION_TYPE.BETARGET, idx, tbTarget, camp)
		if effect == minidef.SKILL_EFFECT.ATTACK or
		   effect == minidef.SKILL_EFFECT.KILL or
		   effect == minidef.SKILL_EFFECT.COMMON then
			--计算命中，去掉target中未命中的索引
			local miss = calcBingo(fightManager, camp, targetCamp, idx, skillid, tbTarget, effect)
			for j = 1, #miss do
				if tb.target[miss[j]] then
					tb.target[miss[j]].bingo = false
				end
			end
		end

		if #tbTarget <= 0 then
			print('所有目标都未命中')
			fightManager.castSkill = fightManager.castSkill + 1
			table.insert(fightManager.data[fightManager.turn].op, tb)
			return
		end
		print('命中的目标 = ', getCampName(targetCamp), table.concat(tbTarget, ','))

		--产生技能效果（多重施法、连携）
		skillEffect(fightManager, camp, targetCamp, idx, skillid, tbTarget, tb, rein)
	end
	fightManager.castSkill = fightManager.castSkill + 1
	table.insert(fightManager.data[fightManager.turn].op, tb)

	--处理技能队列
	if #fightManager.SkillQueue ~= 0 then
		local tOP = {}
		tOP.type = minidef.OP_TYPE.queueskill
		local nextSkill = fightManager.SkillQueue[1]
		table.remove(fightManager.SkillQueue, 1)
		tOP.camp = nextSkill.camp
		if nextSkill.id then
			castSkill(fightManager, nextSkill.camp, nextSkill.idx, nextSkill.id, tOP, true)
		else
			if nextSkill.cost then
				randomCostSkill(fightManager, nextSkill.camp, nextSkill.cost, nextSkill.type, tOP, nextSkill.idx, true)
			end
		end
	end
end

--添加技能队列
function addSkillQueue(fightManager, cost, camp, idx, id)
	local skillBag = {}
	--[[
		id
		cost
		camp
		idx
		type
	]]
	skillBag.id = id
	skillBag.cost = cost
	skillBag.camp = camp
	skillBag.idx = idx
	skillBag.type = fightManager.fighters[camp][idx].type

	table.insert(fightManager.SkillQueue, skillBag)
end

--寻找目标
function searchTarget(fightManager, camp, targetCamp, idx, skillid, effect)
	local target = {}
	local type = tbSkill[skillid].target
	local range = tbSkill[skillid].rangetype

	print('寻找目标类型', type, '范围', range)

	if type == minidef.SEARCH_TYPE.DEFAULT then
		searchDefault(fightManager, camp, targetCamp, idx, target, range)
	elseif type == minidef.SEARCH_TYPE.POS then
		local tbPos = tbSkill[skillid].pos
		for _, v in pairs(tbPos) do
			if effect == minidef.SKILL_EFFECT.CALL then	--召唤技能不考虑目标位置不存在fighter
				table.insert(target, v)
			else
				if fightManager.fighters[targetCamp][v] then
					table.insert(target, v)
				end
			end
		end
	elseif type == minidef.SEARCH_TYPE.SELF then
		table.insert(target, idx)
	elseif type == minidef.SEARCH_TYPE.OBS_SUMMON then
		local tar = idx
		if tar > minidef.P_HEAD_RIGHT then
			tar = idx - minidef.P_HEAD_RIGHT
		end
		if fightManager.fighters[targetCamp][tar] then
			table.insert(target, tar)
		end
	elseif type == minidef.SEARCH_TYPE.MAX_SUMMON then
		local cost, tar = 0, 0
		for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].cost > cost then
				cost = fightManager.fighters[targetCamp][i].cost
				tar = i
			end
		end
		if tar > 0 then
			table.insert(target, tar)
		end
	elseif type == minidef.SEARCH_TYPE.MIN_SUMMON then
		local cost, tar = 100, 0
		for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].cost < cost then
				cost = fightManager.fighters[targetCamp][i].cost
				tar = i
			end
		end
		if tar > 0 then
			table.insert(target, tar)
		end
	elseif type == minidef.SEARCH_TYPE.COST_UP_SUMMON then
		local cost = tbSkill[skillid].costarg
		for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].cost >= cost then
				table.insert(target, i)
			end
		end
	elseif type == minidef.SEARCH_TYPE.COST_DOWN_SUMMON then
		local cost = tbSkill[skillid].costarg
		for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].cost <= cost then
				table.insert(target, i)
			end
		end
	elseif type == minidef.SEARCH_TYPE.RANDOM then
		local tbTemp = {}
		for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
			if fightManager.fighters[targetCamp][i] then
				table.insert(tbTemp, i)
			end
		end
		if #tbTemp > 0 then
			local ret = minifunc.random(1, #tbTemp)
			table.insert(target, tbTemp[ret])
		end
	elseif type == minidef.SEARCH_TYPE.MIN_HP then	--寻找目标血量低于某个值只对生物有效
		local rate, temp, tar = 100, 100, 0
		for i = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT do
			temp = fightManager.fighters[targetCamp][i].nHP / fightManager.fighters[targetCamp][i].nMaxHP
			if fightManager.fighters[targetCamp][i] and temp < rate then
				rate = temp
				tar = i
			end
		end
		if tar > 0 then
			table.insert(target, tar)
		end
	elseif type == minidef.SEARCH_TYPE.OBS_HERO then
		local tar = idx
		if tar < minidef.P_BACK_LEFT then
			tar = idx + minidef.P_HEAD_RIGHT
		end
		if fightManager.fighters[targetCamp][tar] then
			table.insert(target, tar)
		end
	elseif type == minidef.SEARCH_TYPE.SELF_HEAD then
		if idx > minidef.P_HEAD_RIGHT then
			if effect == minidef.SKILL_EFFECT.CALL then	--召唤技能不考虑目标位置不存在fighter
				table.insert(target, idx - minidef.P_HEAD_RIGHT)
			else
				if fightManager.fighters[targetCamp][idx - minidef.P_HEAD_RIGHT] then
					table.insert(target, v)
				end
			end
		end
	end

	if #target == 0 then
		searchDefault(fightManager, camp, targetCamp, idx, target, range)
	end
	return target
end

--默认寻找目标方式
function searchDefault(fightManager, camp, targetCamp, idx, target, range)
	local tar1, ret = idx, 0
	if tar1 > minidef.P_HEAD_RIGHT then
		tar1 = tar1 - minidef.P_HEAD_RIGHT
	end

	--判断飞行和嘲讽
	if fightManager.fighters[camp][idx].statusMark[minidef.STATUS_TYPE.FLY] then
		--检查对面是否存在飞行嘲讽
		local find = false
		for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].statusMark[minidef.SEARCH_TYPE.RIDICULE] and
			   fightManager.fighters[targetCamp][i].statusMark[minidef.SEARCH_TYPE.FLY] then
				ret = i
				find = true
				break
			end
		end
		if not(find) then
			if fightManager.fighters[targetCamp][tar1] and
			   fightManager.fighters[targetCamp][tar1].statusMark[minidef.STATUS_TYPE.FLY] then
				ret = tar1
			else
				if fightManager.fighters[targetCamp][tar1 + minidef.P_HEAD_RIGHT] then
					ret = tar1 + minidef.P_HEAD_RIGHT
				else
					--对面生物、英雄的顺序找一个
					for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
						if fightManager.fighters[targetCamp][i] then
							ret = i
							break
						end
					end
				end
			end
		end
	else
		--检查对面嘲讽
		local find = false
		for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
			if fightManager.fighters[targetCamp][i] and
			   fightManager.fighters[targetCamp][i].statusMark[minidef.SEARCH_TYPE.RIDICULE] then
				ret = i
				find = true
				break
			end
		end
		if not(find) then
			if fightManager.fighters[targetCamp][tar1] then	--对位生物
				ret = tar1
			elseif fightManager.fighters[targetCamp][tar1 + minidef.P_HEAD_RIGHT] then	--对位英雄
				ret = tar1 + minidef.P_HEAD_RIGHT
			else
				--对面生物、英雄的顺序找一个
				for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
					if fightManager.fighters[targetCamp][i] then
						ret = i
						break
					end
				end
			end
		end
	end

	if ret > 0 then	--处理攻击范围
		if range == minidef.SEARCH_RANGE_ROW then
			local sb, se = 0, 0
			if ret < minidef.P_BACK_LEFT then
				sb, se = minidef.P_HEAD_LEFT, minidef.P_HEAD_RIGHT
			else
				sb, se = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT
			end
			for i = sb, se do
				if fightManager.fighters[targetCamp][i] then
					table.insert(target, i)
				end
			end
		elseif range == minidef.SEARCH_RANGE_LINE then
			if ret < minidef.P_BACK_LEFT then
				table.insert(target, ret)
				table.insert(target, ret + minidef.P_HEAD_RIGHT)
			else
				table.insert(target, ret)
				table.insert(target, ret - minidef.P_HEAD_RIGHT)
			end
		else
			table.insert(target, ret)
		end
	end
end

--计算命中
function calcBingo(fightManager, camp, targetCamp, myIdx, skillid, tbTarget)
	local miss = {}
	print('计算命中率', '有', #tbTarget, '个目标', table.concat(tbTarget, ','))
	local bingoType = tbSkill[skillid].hittype
	if bingoType == minidef.BINGO.MUST then	--必中
		print('技能id', skillid, '命中类型为必中')
		return miss
	end

	local hiter, hit = 0, 0
	for i = #tbTarget, 1, -1 do
		print('命中循环', i, tbTarget[i])
		print('攻击者等级 = ', fightManager.fighters[camp][myIdx].nLVL, '受击者等级 = ', fightManager.fighters[targetCamp][tbTarget[i]].nLVL)
		hiter = fighter.getHiters(fightManager.fighters[camp][myIdx].nLVL,
						fightManager.fighters[targetCamp][tbTarget[i]].nLVL)
		if bingoType == minidef.BINGO.MISS then
			print('技能命中率为计算闪避', '攻击者的命中率为', fightManager.fighters[camp][myIdx].nHit, '受击者的闪避率为', fightManager.fighters[targetCamp][tbTarget[i]].nDog)
			hit = fighter.getHitValue1(fightManager.fighters[camp][myIdx].nHit,
						fightManager.fighters[targetCamp][tbTarget[i]].nDog, hiter)
		elseif bingoType == minidef.BINGO.NO_MISS then
			print('技能命中率为不计算闪避', '攻击者的命中率为', fightManager.fighters[camp][myIdx].nHit)
			hit = fighter.getHitValue2(fightManager.fighters[camp][myIdx].nHit, hiter)
		end
		local rand = minifunc.random(1, 100) * 0.01
		print('命中率 = ', hit, '攻击者的命中系数', hiter, '随机结果', rand)
		if rand > hit then	--未命中
			print('未命中的目标', tbTarget[i])
			table.insert(miss, tbTarget[i])
			table.remove(tbTarget, i)
		end
	end
	return miss
end

--产生技能效果
function skillEffect(fightManager, camp, targetCamp, idx, skillid, tbTarget, tb, rein)
	local resultid = tbSkill[skillid].skillresultsid
	local effect = tbSkillResult[resultid].effecttype
	local skill_lvl = fightManager.fighters[camp][idx].tbSkill[skillid].lvl
	local bCrit, bDead, bHurt, bCurl, bImm = false, false, false, false, false
	printHP(fightManager)

	--先计算效果
	for _, target in ipairs(tbTarget) do
		if effect == minidef.SKILL_EFFECT.ATTACK then
			local red = fighter.getRedAllValue(
							fightManager.fighters[targetCamp][target].nRed,
							fightManager.fighters[targetCamp][target].nDef,
							fightManager.fighters[camp][idx].nAfk)
			local atk = fighter.getAttackDamage(
							fightManager.fighters[camp][idx].nAfk,
							red, fightManager.fighters[camp][idx].nPen)
			local arg1 = tbSkillResult[resultid].arg1
			local arg2 = tbSkillResult[resultid].arg2
			local arg3 = tbSkillResult[resultid].arg3
			local damage = skill_lvl * arg1 + arg2 + atk * arg3
			print('类型1攻击', 'B减伤比 = ', red, 'A的攻击伤害 = ', atk, '参数', arg1, arg2, arg3, '最终计算伤害 = ', damage)
			bImm, bCrit, bDead, bHurt = hurt(fightManager, camp, idx, targetCamp, target, damage, fightManager.fighters[targetCamp][target].type, tb, skillid)
			checkEndFight(fightManager, tb)
		elseif effect == minidef.SKILL_EFFECT.CURL then
			local arg1 = tbSkillResult[resultid].arg1
			local arg2 = tbSkillResult[resultid].arg2
			if fightManager.fighters[targetCamp][target].type == minidef.TARGET_TYPE.HERO then
				tb.target[target].ball = true
				local curlValue = math.floor(skill_lvl * arg1 + fightManager.fighters[targetCamp].MaxHP * arg2)
				fightManager.fighters[targetCamp].totalHP = curl(
									fightManager.fighters[targetCamp].totalHP,
									fightManager.fighters[targetCamp].MaxHP,
									curlValue
									)
				tb.target[target].value = curlValue
				tb.target[target].hp = fightManager.fighters[targetCamp].totalHP
				tb.target[target].maxhp = fightManager.fighters[targetCamp].MaxHP
			else
				tb.target[target].ball = false
				local curlValue = math.floor(skill_lvl * arg1 + fightManager.fighters[targetCamp][target].nMaxHP * arg2)
				fightManager.fighters[targetCamp][target].nHP = curl(
									fightManager.fighters[targetCamp][target].nHP,
									fightManager.fighters[targetCamp][target].nMaxHP,
									curlValue
									)
				tb.target[target].value = curlValue
				tb.target[target].hp = fightManager.fighters[targetCamp][target].nHP
				tb.target[target].maxhp = fightManager.fighters[targetCamp][target].nMaxHP
			end
			bCurl = true
		elseif effect == minidef.SKILL_EFFECT.MUTIL then
			--rein为多重施法或者连携或者状态触发技能进来，如果下一个技能类型为多重施法或者连携不添加技能队列
			if not(rein) then
				local skillcost = {}
				for i = 1, minidef.MAX_SKILL_MUTIL_NU do
					local cost = tbSkillResult[resultid]['arg'..i]
					if cost > 0 then
						addSkillQueue(fightManager, cost, camp, idx)
						table.insert(skillcost, cost)
					end
				end
				tb.target[target].skillcost = skillcost
			end
		elseif effect == minidef.SKILL_EFFECT.KILL then
			local red = fighter.getRedAllValue(
								fightManager.fighters[targetCamp][target].nRed,
								fightManager.fighters[targetCamp][target].nDef,
								fightManager.fighters[camp][idx].nAfk)
			local atk = fighter.getAttackDamage(
								fightManager.fighters[camp][idx].nAfk,
								red, fightManager.fighters[camp][idx].nPen)
			if target > minidef.P_HEAD_RIGHT then	--打英雄
				local arg1 = tbSkillResult[resultid].arg1[2]
				local arg2 = tbSkillResult[resultid].arg2[2]
				local arg3 = tbSkillResult[resultid].arg3[2]
				local damage = skill_lvl * arg1 + arg2 + atk * arg3
				print('类型4杀生物打英雄', 'B减伤比 = ', red, 'A的攻击伤害 = ', atk, '参数', arg1, arg2, arg3, '最终计算伤害 = ', damage)
				bImm, bCrit, bDead, bHurt = hurt(fightManager, camp, idx, targetCamp, target, damage, minidef.TARGET_TYPE.HERO, tb, skillid)
				checkEndFight(fightManager, tb)
			else
				local arg1 = tbSkillResult[resultid].arg1[1]
				local arg2 = tbSkillResult[resultid].arg2[1]
				local arg3 = tbSkillResult[resultid].arg3[1]
				local damage = skill_lvl * arg1 + fightManager.fighters[targetCamp][target].nMaxHP * arg2 + atk * arg3
				print('类型4杀生物打生物', 'B减伤比 = ', red, 'A的攻击伤害 = ', atk, '参数', arg1, arg2, arg3, '最终计算伤害 = ', damage)
				bImm, bCrit, bDead, bHurt = hurt(fightManager, camp, idx, targetCamp, target, damage, minidef.TARGET_TYPE.SUMMON, tb, skillid)
				checkEndFight(fightManager, tb)
			end
		elseif effect == minidef.SKILL_EFFECT.ADD then
			local cost = tbSkillResult[resultid].arg1
			fightManager.fighters[targetCamp].addCost = fightManager.fighters[targetCamp].addCost + cost
			tb.target[target].addCost = cost
		elseif effect == minidef.SKILL_EFFECT.CALL then
			local success = false
			local monsterid = tbSkillResult[resultid].arg1
			tb.target[target].bSuc = success
			tb.target[target].summonid = monsterid
			if idx > minidef.P_HEAD_RIGHT then	--只有英雄释放召唤才处理
				local pos = idx - minidef.P_HEAD_RIGHT
				local temp = fightManager.fighters[targetCamp][target]
				if temp then
					local num = 1
					while temp.next do
						temp = temp.next
						num = num + 1
					end
					if num < minidef.MAX_SUMMON_QUEUE_NUM then
						tb.target[target].bInQueue = true
						temp.next = fighter.initTemplete(nil, tbMonster[monsterid], monsterid, minidef.TARGET_TYPE.SUMMON)
					else
						print('生物超出队列上限')
					end
				else
					success = true
					tb.target[target].bSuc = success
					fightManager.fighters[targetCamp][target] = fighter.initTemplete(nil, tbMonster[monsterid], monsterid, minidef.TARGET_TYPE.SUMMON)
					--处理生物进场
					tb.target[target].enterBuff = {}
					local buff = condMe(fightManager, minidef.CONDITION_TYPE.SUMMON_ENTER, targetCamp, target)	--自身
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
					buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_ENTER, targetCamp, target)	--友方
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
					buff = condCampAll(fightManager, minidef.CONDITION_TYPE.OBS_ENTER, getObsCamp(targetCamp))	--敌方
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
				end

				if not(success) then
					if not(rein) then	--重进的召唤不成功也不能触发连携
						--连携
						local cost = randomSkillCost(fightManager, camp, fightManager.turn)
						addSkillQueue(fightManager, cost, camp, idx)

						tb.target[target].bRein = true
						tb.target[target].skillcost = cost
					end
				end
			end
		elseif effect == minidef.SKILL_EFFECT.COPY then
			--复制如果对应位置已经存在怪则不处理
			if idx > minidef.P_HEAD_RIGHT then	--只有英雄释放复制才处理
				local pos = idx - minidef.P_HEAD_RIGHT
				if not(fightManager.fighters[camp][pos]) and
				   fightManager.fighters[targetCamp][target].type == minidef.TARGET_TYPE.SUMMON then
					fightManager.fighters[camp][pos] = minifunc.copyTable(fightManager.fighters[targetCamp][target])
					print(getCampName(camp), '生物', pos, '从',  target, getCampName(targetCamp), '复制而来')
					tb.target[target].copycamp = camp
					tb.target[target].copypos = pos
					tb.target[target].summonid = fightManager.fighters[camp][pos].id
					tb.target[target].enterBuff = {}
					--处理生物进场
					local buff = condMe(fightManager, minidef.CONDITION_TYPE.SUMMON_ENTER, camp, pos)	--自身
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
					buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_ENTER, camp, pos)	--友方
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
					buff = condCampAll(fightManager, minidef.CONDITION_TYPE.OBS_ENTER, getObsCamp(camp))	--敌方
					for i = 0, #buff do
						table.insert(tb.target[target].enterBuff, buff[i])
					end
				end
			end
		elseif effect == minidef.SKILL_EFFECT.STATUS then
			local buff = judgeStatus(resultid, fightManager, targetCamp, target, skillid, skill_lvl)
			tb.target[target].addBuff = buff
		elseif effect == minidef.SKILL_EFFECT.COMMON then
			local red = fighter.getRedAllValue(
							fightManager.fighters[targetCamp][target].nRed,
							fightManager.fighters[targetCamp][target].nDef,
							fightManager.fighters[camp][idx].nAfk)
			local atk = fighter.getAttackDamage(
							fightManager.fighters[camp][idx].nAfk,
							red, fightManager.fighters[camp][idx].nPen)
			local arg1 = tbSkillResult[resultid].arg1
			local arg2 = tbSkillResult[resultid].arg2
			local arg3 = tbSkillResult[resultid].arg3
			local damage = skill_lvl * arg1 + arg2 + atk * arg3
			print('类型8攻击', 'B减伤比 = ', red, 'A的攻击伤害 = ', atk, '参数', arg1, arg2, arg3, '最终计算伤害 = ', damage)
			bImm, bCrit, bDead, bHurt = hurt(fightManager, camp, idx, targetCamp, target, damage, fightManager.fighters[targetCamp][target].type, tb, skillid)
			checkEndFight(fightManager, tb)
		end

		--只有攻击类和治疗技能才带状态跟驱散
		if not(bImm) and not(bDead) and
		   (effect == minidef.SKILL_EFFECT.ATTACK or
		   effect == minidef.SKILL_EFFECT.COMMON or
		   effect == minidef.SKILL_EFFECT.CURL or
		   effect == minidef.SKILL_EFFECT.KILL) then
			local buff = judgeStatus(resultid, fightManager, targetCamp, target, skillid, skill_lvl, bCrit)
			tb.target[target].skillBuff = buff

			--最后计算驱散
			local dis = tbSkillResult[resultid].dispel
			if dis then
				buff = eraseStatus(fightManager, targetCamp, target, dis, skillid)
				tb.target[target].skillDis = buff
			end
		end
	end
	if bHurt then	--触发造成伤害
		tb.hurtBuff = {}
		local buff = condMe(fightManager, minidef.CONDITION_TYPE.HURT, camp, idx)
		for i = 0, #buff do
			table.insert(tb.hurtBuff, buff[i])
		end
	end
	if bCurl then	--触发治疗状态
		tb.curlBuff = {}
		local buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_CURL, camp, idx)
		for i = 0, #buff do
			table.insert(tb.curlBuff, buff[i])
		end
	end
	checkEndFight(fightManager, tb)
	printHP(fightManager)
end

--判断状态并添加
function judgeStatus(resultid, fightManager, targetCamp, target, skillid, skill_lvl, bCrit)
	local buff = {}
	local status = tbSkillResult[resultid].status
	if type(status) == 'table' then
		local statusCond = tbSkillResult[resultid].statuscondition
		if statusCond == minidef.STATUS_CREATE_COND.BINGO then	--命中即产生
			buff = createStatus(fightManager, targetCamp, target, status, skillid, skill_lvl)
		elseif statusCond == minidef.STATUS_CREATE_COND.CRIT then	--产生暴击产生
			if bCrit then
				buff = createStatus(fightManager, targetCamp, target, status, skillid, skill_lvl)
			end
		end
	end
	return buff
end

--治疗
function curl(curHP, maxHP, curlValue)
	curHP = curHP + curlValue
	if curHP > maxHP then
		return maxHP
	end
	return curHP
end

--造成伤害
function hurt(fightManager, camp, idx, targetCamp, target, damage, type, tb, skillid, status)
	local bImmu, bCrit, bDead, bShield = false, false, false, false
	tb.target[target].bCrit = false
	tb.target[target].bImmu = false
	tb.target[target].bShield = false

	if not(status) then	--如果是状态产生伤害，不计算暴击
		--计算暴击
		local criter = fighter.getCriters(
								fightManager.fighters[camp][idx].nLVL,
								fightManager.fighters[targetCamp][target].nLVL
								)
		local crit = fighter.getCritValue(
								fightManager.fighters[camp][idx].nCrit,
								fightManager.fighters[targetCamp][target].nTen, criter
								)
		local rand = minifunc.random(1, 100) * 0.01
		print('暴击率 = ', crit, '攻击者的暴击系数', criter, '随机结果', rand)
		if rand <= crit then	--暴击
			print('暴击！！！')
			damage = damage * 2
			bCrit = true
			tb.target[target].bCrit = bCrit
		end
	end

	print('hurt伤害', damage)
	--判断是否免疫
	bImmu = condImmu(fightManager, targetCamp, target)
	tb.target[target].bImmu = bImmu
	if bImmu then
		print('免疫了')
		return true
	end

	--触发护盾
	damage, bShield = condShield(fightManager, targetCamp, target, damage)
	--伤害下取整
	print('伤害下取整 = ', damage, math.floor(damage))
	damage = math.floor(damage)
	tb.target[target].bShield = bShield
	tb.target[target].damage = damage
	if damage <= 0 then
		return false, bCrit, bDead, false
	end

	if type == minidef.TARGET_TYPE.SUMMON then
		--攻击的是生物
		tb.target[target].ball = false	--是否是敌方全体
		if status then
			print('持续伤害状态对', getCampName(targetCamp), '生物', target, '造成', damage, '伤害')
		else
			print(getCampName(camp), idx, '对', getCampName(targetCamp), '生物', target, '造成', damage, '伤害')
		end
		fightManager.fighters[targetCamp][target].nHP = fightManager.fighters[targetCamp][target].nHP - damage

		if fightManager.fighters[targetCamp][target].nHP < 0 then
			fightManager.fighters[targetCamp][target].nHP = 0
		end
		tb.target[target].hp = fightManager.fighters[targetCamp][target].nHP
		tb.target[target].maxhp = fightManager.fighters[targetCamp][target].nMaxHP

		if fightManager.fighters[targetCamp][target].nHP <= 0 then
			print(getCampName(targetCamp), '生物', target, '死亡')
			bDead = true
			--处理生物死亡条件
			-- condMe(fightManager, minidef.CONDITION_TYPE.DEAD, targetCamp, target)	--自身，亡语效果存在问题
			local buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_DEAD, targetCamp, target)	--友方
			for i = 1, #buff do
				table.insert(tb.target[target].deadBuff, buff[i])
			end
			if fightManager.fighters[targetCamp][target].next then	--生物队列还有
				fightManager.fighters[targetCamp][target] = fightManager.fighters[targetCamp][target].next
				print(getCampName(targetCamp), '生物', target, '队列新生物上场')
				tb.target[target].newSummonid = fightManager.fighters[targetCamp][target].id

				--处理生物进场
				buff = condMe(fightManager, minidef.CONDITION_TYPE.SUMMON_ENTER, targetCamp, target)	--自身
				for i = 1, #buff do
					table.insert(tb.target[target].enterBuff, buff[i])
				end
				buff = condCampAllExceptMe(fightManager, minidef.CONDITION_TYPE.OUR_ENTER, targetCamp, target)	--友方
				for i = 1, #buff do
					table.insert(tb.target[target].enterBuff, buff[i])
				end
				buff = condCampAll(fightManager, minidef.CONDITION_TYPE.OBS_ENTER, getObsCamp(targetCamp))	--敌方
				for i = 1, #buff do
					table.insert(tb.target[target].enterBuff, buff[i])
				end
			else
				fightManager.fighters[targetCamp][target] = nil
			end
		else
			if not(status) then
				--没死处理受伤条件
				local buff = condMe(fightManager, minidef.CONDITION_TYPE.BE_DAMAGE, targetCamp, target)
				for i = 1, #buff do
					table.insert(tb.target[target].damageBuff, buff[i])
				end
			end
		end
		tb.target[target].bDead = bDead
	else
		tb.target[target].ball = true
		if status then
			print('持续伤害状态对', getCampName(targetCamp), '方英雄', target, '造成', damage, '伤害')
		else
			print(getCampName(camp), idx, '对', getCampName(targetCamp), '英雄', '造成', damage, '伤害')
		end
		fightManager.fighters[targetCamp].totalHP = fightManager.fighters[targetCamp].totalHP - damage
		tb.target[target].hp = fightManager.fighters[targetCamp].totalHP
		tb.target[target].maxhp = fightManager.fighters[targetCamp].MaxHP

		if fightManager.fighters[targetCamp].totalHP < 0 then
			fightManager.fighters[targetCamp].totalHP = 0
		else
			if not(status) then
				--没死处理受伤条件
				local buff = condMe(fightManager, minidef.CONDITION_TYPE.BE_DAMAGE, targetCamp, target)
				for i = 1, #buff do
					table.insert(tb.target[target].damageBuff, buff[i])
				end
			end
		end
	end

	return false, bCrit, bDead, true
end

--检查战斗是否结束
function checkEndFight(fightManager, tb)
	if fightManager.fighters[minidef.ME].totalHP <= 0 then
		fightManager.winner = minidef.OBS
		printHP(fightManager)
		coroutine.yield(tb)
	end

	if fightManager.fighters[minidef.OBS].totalHP <= 0 then
		fightManager.winner = minidef.ME
		printHP(fightManager)
		coroutine.yield(tb)
	end
end

--获取敌对阵营
function getObsCamp(camp)
	if camp == minidef.ME then
		return minidef.OBS
	else
		return minidef.ME
	end
end

function getCampName(camp)
	if camp == minidef.ME then
		return '我方'
	else
		return '敌方'
	end
end

--===================== 条件队列相关函数 =========================
--触发全体
function condAllProcess(fightManager, condition)
	local tb = {}
	--9001\9002
	-- 先遍历友方状态
	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		if fightManager.fighters[minidef.ME][i] then
			local status = fightManager.fighters[minidef.ME][i].status
			for j = #status, 1, -1 do
				local condID = tbStatus[status[j].id].triggercondition
				if condition == condID then
					local op = activeStatus(fightManager, minidef.ME, i, status[j], j)
					table.insert(tb, op)
					-- checkEndFight(fightManager)
				end
			end
		end
	end

	-- 再遍历敌方状态
	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		if fightManager.fighters[minidef.OBS][i] then
			local status = fightManager.fighters[minidef.OBS][i].status
			for j = #status, 1, -1 do
				local condID = tbStatus[status[j].id].triggercondition
				if condition == condID then
					local op = activeStatus(fightManager, minidef.OBS, i, status[j], j)
					-- table.insert(fightManager.data[fightManager.turn].op, op)
					-- checkEndFight(fightManager)
					table.insert(tb, op)
				end
			end
		end
	end
	return tb
end

--触发除触发者外的所有友方
function condCampAllExceptMe(fightManager, condition, camp, idx)
	local tb = {}
	--9003\9004\9005\9006\9009\9013\9015\9018
	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		if idx ~= i and fightManager.fighters[camp][i] then
			local status = fightManager.fighters[camp][i].status
			for j = #status, 1, -1 do
				local condID = tbStatus[status[j].id].triggercondition
				if condition == condID then
					-- activeStatus(fightManager, camp, i, status[j], j)
					local op = activeStatus(fightManager, camp, i, status[j], j)
					table.insert(tb, op)
					-- checkEndFight(fightManager)
				end
			end
		end
	end
	return tb
end

--触发敌方所有英雄和生物
function condCampAll(fightManager, condition, camp)
	local tb = {}
	--9008\9016
	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		if fightManager.fighters[camp][i] then
			local status = fightManager.fighters[camp][i].status
			for j = #status, 1, -1 do
				local condID = tbStatus[status[j].id].triggercondition
				if condition == condID then
					-- activeStatus(fightManager, camp, i, status[j], j)
					-- checkEndFight(fightManager)
					local op = activeStatus(fightManager, camp, i, status[j], j)
					table.insert(tb, op)
				end
			end
		end
	end
	return tb
end

--触发自身
function condMe(fightManager, condition, camp, idx)
	local tb = {}
	--9010\9011\9012\9014\9017
	if fightManager.fighters[camp][idx] then
		local status = fightManager.fighters[camp][idx].status
		for j = #status, 1, -1 do
			local condID = tbStatus[status[j].id].triggercondition
			if condition == condID then
				-- activeStatus(fightManager, camp, i, status[j], j)
				-- checkEndFight(fightManager)
				local op = activeStatus(fightManager, camp, i, status[j], j)
				table.insert(tb, op)
			end
		end
	end
	return tb
end

--触发免疫
function condImmu(fightManager, camp, idx)
	local bImmu = false
	if fightManager.fighters[camp][idx].statusMark[minidef.STATUS_TYPE.IMMUNITY] then
		local status = fightManager.fighters[camp][idx].status
		for i = #status, 1, -1 do
			local effect = tbStatus[status[i].id].effecttype
			if effect == minidef.STATUS_TYPE.IMMUNITY then
				bImmu = true
				desStatusTime(fightManager.fighters[camp][idx], status, i)
				break
			end
		end
	end
	return bImmu
end

--触发眩晕
function condDizz(fightManager, camp, idx)
	local bDizz = false
	if fightManager.fighters[camp][idx].statusMark[minidef.STATUS_TYPE.DIZZ] then
		bDizz = true
	end
	return bDizz
end

--触发护盾
function condShield(fightManager, camp, idx, damage)
	local newDamage, bShield = damage, false
	if fightManager.fighters[camp][idx].statusMark[minidef.STATUS_TYPE.SHIELD] then
		local status = fightManager.fighters[camp][idx].status
		for i = #status, 1, -1 do
			local effect = tbStatus[status[i].id].effecttype
			if effect == minidef.STATUS_TYPE.SHIELD then
				local arg1 = tbStatus[status.id].arg1
				local arg2 = tbStatus[status.id].arg2
				local arg3 = tbStatus[status.id].arg3
				local reserve = 0
				if fightManager.fighters[camp][idx].type == minidef.TARGET_TYPE.HERO then
					reserve = arg1 * status.lvl + arg2 + arg3 * fightManager.fighters[camp].MaxHP
				else
					reserve = arg1 * status.lvl + arg2 + arg3 * fightManager.fighters[camp][idx].nMaxHP
				end
				print('触发', getCampName(camp), idx, '护盾抵御', reserve, '伤害')
				newDamage = damage - reserve
				if newDamage < 0 then
					newDamage = 0
				end
				bShield = true
				desStatusTime(fightManager.fighters[camp][idx], status, i)
				break
			end
		end
	end
	return newDamage, bShield
end

--处理状态生效，只处理共存类型的
function activeStatus(fightManager, camp, idx, status, statusPos)
	local effect = tbStatus[status.id].effecttype
	local lvl = status.lvl

	local op = {}
	op.type = minidef.OP_TYPE.buff
	op.camp = camp
	op.pos = idx
	op.id = status.id
	op.value = {}
	op.skillid = nil
	op.dis = desStatusTime(fightManager.fighters[camp][idx], status, statusPos)	--优先减少次数，避免死循环

	if effect == minidef.STATUS_TYPE.ADD then
		local attributes = tbStatus[op.id].arg1
		local values = tbStatus[op.id].arg2
		for pos, attr in pairs(attributes) do
			local value = values[pos]
			local bAll = false
			if type(value) == 'number' then
				if attr == minidef.STATUS_ADD_PROPERTY.ATK then
					fightManager.fighters[camp][idx].nAfk = fightManager.fighters[camp][idx].nAfk + value * lvl
				elseif attr == minidef.STATUS_ADD_PROPERTY.DEF then
					fightManager.fighters[camp][idx].nDef = fightManager.fighters[camp][idx].nDef + value * lvl
				elseif attr == minidef.STATUS_ADD_PROPERTY.CRIT then
					fightManager.fighters[camp][idx].nCrit = fightManager.fighters[camp][idx].nCrit + value * lvl
				elseif attr == minidef.STATUS_ADD_PROPERTY.DOG then
					fightManager.fighters[camp][idx].nDog = fightManager.fighters[camp][idx].nDog + value * lvl
				elseif attr == minidef.STATUS_ADD_PROPERTY.MAX_HP then
					if fightManager.fighters[camp][idx].type == minidef.TARGET_TYPE.HERO then
						fightManager.fighters[camp].MaxHP = fightManager.fighters[camp].MaxHP + math.floor(value * lvl)
						bAll = true
					else
						fightManager.fighters[camp][idx].nMaxHP = fightManager.fighters[camp][idx].nMaxHP + math.floor(value * lvl)
					end
				end
				if bAll then
					op.value[attr] = { value * lvl, bAll, fightManager.fighters[camp].totalHP, fightManager.fighters[camp].MaxHP }
				else
					op.value[attr] = { value * lvl, bAll, fightManager.fighters[camp][idx].nHP, fightManager.fighters[camp][idx].nMaxHP }
				end
			end
		end
	elseif effect == minidef.STATUS_TYPE.REDUCE then
		local attributes = tbStatus[op.id].arg1
		local values = tbStatus[op.id].arg2
		for pos, attr in pairs(attributes) do
			local value = values[pos]
			local bAll, nV = false, 0
			if type(value) == 'number' then
				if attr == minidef.STATUS_ADD_PROPERTY.ATK then
					fightManager.fighters[camp][idx].nAfk, nV = fighter.desAttrValue(fightManager.fighters[camp][idx].nAfk, value * lvl)
				elseif attr == minidef.STATUS_ADD_PROPERTY.DEF then
					fightManager.fighters[camp][idx].nDef, nV = fighter.desAttrValue(fightManager.fighters[camp][idx].nDef, value * lvl)
				elseif attr == minidef.STATUS_ADD_PROPERTY.CRIT then
					fightManager.fighters[camp][idx].nCrit, nV = fighter.desAttrValue(fightManager.fighters[camp][idx].nCrit, value * lvl)
				elseif attr == minidef.STATUS_ADD_PROPERTY.DOG then
					fightManager.fighters[camp][idx].nDog, nV = fighter.desAttrValue(fightManager.fighters[camp][idx].nDog, value * lvl)
				elseif attr == minidef.STATUS_ADD_PROPERTY.MAX_HP then
					if fightManager.fighters[camp][idx].type == minidef.TARGET_TYPE.HERO then
						fightManager.fighters[camp].MaxHP, nV = fighter.desAttrValue(fightManager.fighters[camp].MaxHP, math.floor(value * lvl))
						if fightManager.fighters[camp].totalHP > fightManager.fighters[camp].MaxHP then
							fightManager.fighters[camp].totalHP = fightManager.fighters[camp].MaxHP
						end
						bAll = true
					else
						fightManager.fighters[camp][idx].nMaxHP, nV = fighter.desAttrValue(fightManager.fighters[camp][idx].nMaxHP, math.floor(value * lvl))
						if fightManager.fighters[camp][idx].nHP > fightManager.fighters[camp][idx].nMaxHP then
							fightManager.fighters[camp][idx].nHP = fightManager.fighters[camp][idx].nMaxHP
						end
					end
				end
				if bAll then
					op.value[attr] = { nV, bAll, fightManager.fighters[camp].totalHP, fightManager.fighters[camp].MaxHP }
				else
					op.value[attr] = { nV, bAll, fightManager.fighters[camp][idx].nHP, fightManager.fighters[camp][idx].nMaxHP }
				end
			end
		end
	-- elseif effect == minidef.STATUS_TYPE.SUSTAIN then
		-- local arg1 = tbStatus[buff.nBuffId].arg1
		-- local arg2 = tbStatus[buff.nBuffId].arg2
		-- local damage = arg1 * lvl + arg2
		-- local  bImmu, bCrit, bDead, bHurt, bShield, realDamage = hurt(fightManager, nil, nil, camp, idx, damage, fightManager.fighters[camp][idx].type, nil, true)
	elseif effect == minidef.STATUS_TYPE.SKILL then
		local skillid = tbStatus[op.id].arg1
		addSkillQueue(fightManager, nil, camp, idx, skillid)
		op.skillid = skillid
	end

	return op
end

--减少状态生效次数
function desStatusTime(fighter, status, pos)
	if status.times then
		if status.times - 1 <= 0 then
			removeStatus(fighter, pos)
			return true
		else
			status.times = status.times - 1
		end
	end
	return false
end

--更新条件队列
function updateCond(fightManager)
	--所有状态的持续回合数减少1
	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		if fightManager.fighters[minidef.ME][i] then
			local status = fightManager.fighters[minidef.ME][i].status
			for i = #status, 1, -1 do
				if status[i].duration then
					if status[i].duration - 1 <= 0 then
						local id = removeStatus(fightManager.fighters[minidef.ME][i], i)
						table.insert(fightManager.data[fightManager.turn].tEndBuff, { minidef.ME, i, id })
					else
						status[i].duration = status[i].duration - 1
					end
				end
			end
		end
		if fightManager.fighters[minidef.OBS][i] then
			local status = fightManager.fighters[minidef.OBS][i].status
			for i = #status, 1, -1 do
				if status[i].duration then
					if status[i].duration - 1 <= 0 then
						local id = removeStatus(fightManager.fighters[minidef.OBS][i], i)
						table.insert(fightManager.data[fightManager.turn].tEndBuff, { minidef.OBS, i, id })
					else
						status[i].duration = status[i].duration - 1
					end
				end
			end
		end
	end
end

--删除状态
function removeStatus(fighter, pos)
	local status = fighter.status
	local id = status[pos].id
	local effect = tbStatus[id].effecttype
	if tbStatusType[effect].coexist == minidef.STATUS_COEXIST.NO or
	   tbStatusType[effect].coexist == minidef.STATUS_COEXIST.UP then
		fighter.statusMark[effect] = false
	end
	table.remove(status, pos)
	return id
end

--创建技能附带状态
function createStatus(fightManager, targetCamp, target, tbStatusID, skillid, skill_lvl)
	local buff = {}
	if fightManager.fighters[targetCamp][target] then
		for i = 1, #tbStatusID do
			if tbStatus[tbStatusID[i]] then
				if (fighter.addStatus(fightManager.fighters[targetCamp][target], tbStatusID[i], skill_lvl)) then
					table.insert(buff, tbStatusID[i])
				end
			end
		end
	end
	return buff
end

--驱散
function eraseStatus(fightManager, targetCamp, target, dis, skillid)
	local dis_nature, num, dis_num, ret = dis[1], dis[2], 0, {}
	if dis_nature > 0 then
		local status = fightManager.fighters[targetCamp][target].status
		for i = #status, 1, -1 do
			local effect = tbStatus[status[i].id].effecttype
			local nature = tbStatusType[effect].statustype
			local distype = tbStatusType[effect].disperse
			if nature == dis_nature and distype == minidef.STATUS_DIS.OK then
				local id = removeStatus(fightManager.fighters[targetCamp][target], i)
				table.insert(ret, id)
				dis_num = dis_num + 1
				print('技能', skillid, '驱散了', getCampName(targetCamp), '目标', target, '的状态', status[i].id)
			end
			if num ~= 0 and dis_num >= num then
				break
			end
		end
	end
	return ret
end

--===================== 条件队列相关函数end =========================

-- for id1, _ in pairs(tbMonsterBox) do
	-- for id2, _ in pairs(tbMonsterBox) do
		-- startFight(fighter.createFromMonsterBox(id1), fighter.createFromMonsterBox(id2))
	-- end
-- end
-- startFight(fighter.createFromMonsterBox(9005), fighter.createFromMonsterBox(9005))
