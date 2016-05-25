module("fighter", package.seeall)

require("script/core/minifight/minidef")
require("script/core/minifight/minifunc")
require("script/core/configmanager/configmanager");

local tbMonsterBox = mconfig.loadConfig("script/cfg/battle/monsterbox")
local tbMonster = mconfig.loadConfig("script/cfg/battle/monster")
local tbSkill = mconfig.loadConfig("script/cfg/skills/skills")
local tbSkillResult = mconfig.loadConfig("script/cfg/skills/skillresults")
local tbStatus = mconfig.loadConfig("script/cfg/skills/status")
local tbStatusType = mconfig.loadConfig("script/cfg/skills/statustype")
local tbCharacter = mconfig.loadConfig("script/cfg/character/character")

function createFromMonsterBox(boxid)
	-- print('创建怪物盒子 boxid = ', boxid)

	local tbConfig = tbMonsterBox[boxid]
	if not tbConfig then
		print('配置表错误', '找不到对应的怪物盒子', boxid)
		return nil
	end
	local fighter = {}
	fighter.totalHP = 0
	fighter.MaxHP = 0
	fighter.addCost = 0
	fighter.roundSkill = {}
	fighter.combo = {}

	for i = minidef.P_HEAD_LEFT, minidef.P_BACK_RIGHT do
		local key = 'Pos' .. i
		if tbConfig[key] then
			if i > minidef.P_HEAD_RIGHT then
				fighter[i] = initTemplete(fighter, tbMonster[tbConfig[key]],
						tbConfig[key], minidef.TARGET_TYPE.HERO, i)
			else
				fighter[i] = initTemplete(fighter, tbMonster[tbConfig[key]],
						tbConfig[key], minidef.TARGET_TYPE.SUMMON, i)
			end
		end
	end

	--检查合体技能
	local combo, cost = {}, 0
	for i = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT do
		if fighter[i] then
			combo = tbMonster[fighter[i].id].comboid
			if type(combo) == 'table' then
				for _, comboid in pairs(combo) do
					cost = tbSkill[comboid].cost
					prop = tbSkill[comboid].probability
					lvl = tbSkill[comboid].level
					comboHero = tbSkill[comboid].combo
					if checkComboHero(fighter, comboHero) then
						if not(fighter.combo[cost]) then
							fighter.combo[cost] = {}
							fighter.combo[cost].skill = {}
							fighter.combo[cost].prop = {}
						end
						table.insert(fighter.combo[cost].skill, { comboid, i })
						table.insert(fighter.combo[cost].prop, prop)
					end
					fighter[i].tbSkill[comboid] = {}
					fighter[i].tbSkill[comboid].lvl = lvl
				end
			end
		end
	end

	return fighter
end


--初始化玩家
--[[
tbHeros = {
	{
		pos
		id
		level
		hp
		atk
		defense
		reducehurt			--减伤等级
		penetrationlevel	--穿透等级
		critlevel			--暴击等级
		tenacitylevel		--韧性等级
		hitlevel			--命中等级
		dodgelevel			--闪避等级

		skillid = { id, id }

		normalattack = {
			[1] = id ,
			[2] = id
			……
			[6] = id
		}

		skill_lvl = {
			[1] = lvl
			[2] = lvl
			……
			[6] = lvl
		}
	},
	{},
	{}
}
]]

function createFromPlayer(tbHeros)
	local fighter = {}
	fighter.totalHP = 0
	fighter.MaxHP = 0
	fighter.addCost = 0
	fighter.roundSkill = {}
	fighter.combo = {}
	for _, tbInfo in pairs(tbHeros) do
		local pos = tbInfo.pos
		fighter[pos] = initTemplete(fighter, tbInfo, tbInfo.id, minidef.TARGET_TYPE.HERO, pos)
	end

	--检查合体技能
	local combo, cost = {}, 0
	for i = minidef.P_BACK_LEFT, minidef.P_BACK_RIGHT do
		if fighter[i] then
			combo = tbCharacter[fighter[i].id].comboid
			if type(combo) == 'table' then
				for _, comboid in pairs(combo) do
					cost = tbSkill[comboid].cost
					prop = tbSkill[comboid].probability
					if fighter[i].skill_lvl and fighter[i].skill_lvl[cost] then
						lvl = fighter[i].skill_lvl[cost]
					else
						lvl = tbSkill[comboid].level
					end
					comboHero = tbSkill[comboid].combo
					if checkComboHero(fighter, comboHero) then
						if not(fighter.combo[cost]) then
							fighter.combo[cost] = {}
							fighter.combo[cost].skill = {}
							fighter.combo[cost].prop = {}
						end
						table.insert(fighter.combo[cost].skill, { comboid, i })
						table.insert(fighter.combo[cost].prop, prop)
					end
					fighter[i].tbSkill[comboid] = {}
					fighter[i].tbSkill[comboid].lvl = lvl
				end
			end
		end
	end

	return fighter
end

--初始化fighter模板
function initTemplete(fighter, config, id, temp_type, pos)
	local templete = {}

	templete.id = id
	templete.nLVL = config.level or 0
	templete.nMaxHP = config.hp or 0
	templete.nHP = config.hp or 0
	templete.nAfk = config.atk or 0
	templete.nDef = config.defense or 0
	templete.nRed = (config.reducehurt / 100) or 0	--减伤率
	templete.nPen = (config.penetrationlevel / 10000) or 0	--穿透率
	templete.nCrit = (config.critlevel / 10000) or 0	--暴击率
	templete.nTen = (config.tenacitylevel / 10000) or 0	--韧性率
	templete.nHit = (config.hitlevel / 10000) or 0	--命中率
	templete.nDog = (config.dodgelevel / 10000) or 0	--闪避率
	templete.tbSkill = {}
	templete.skill_lvl = config.skill_lvl

	if temp_type == minidef.TARGET_TYPE.HERO then
		--计算总血量，只算后排共用血条，前排算召唤生物，可以杀死
		fighter.totalHP =  fighter.totalHP + templete.nMaxHP
		fighter.MaxHP =  fighter.MaxHP + templete.nMaxHP
		templete.type = minidef.TARGET_TYPE.HERO

		--主动技能
		initHeroSkill(fighter, templete, config.skill, config.skill_lvl, pos)
	else
		templete.type = minidef.TARGET_TYPE.SUMMON
		--生物有费用
		templete.cost = config.cost or 0
		--生物有队列
		templete.next = nil

		--主动技能
		initSummonSkill(templete, config.skill)
	end

	--状态
	initStatus(templete, config.statusid)

	--普攻
	templete.normalattack = {}
	for i = minidef.MIN_COST, minidef.MAX_COST do
		if type(config.normalattack) == 'table' and config.normalattack[i] then
			templete.normalattack[i] = config.normalattack[i]
		else
			templete.normalattack[i] = config.normalattack
		end
		templete.tbSkill[templete.normalattack[i]] = {}
		templete.tbSkill[templete.normalattack[i]].lvl = 0
	end

	return templete
end

--检查合体英雄
function checkComboHero(fighter, comboHero)
	for i = 1, #comboHero do
		if not(fighter[minidef.P_BACK_LEFT] and fighter[minidef.P_BACK_LEFT].id == comboHero[i]) or
		   not(fighter[minidef.P_BACK_MID] and fighter[minidef.P_BACK_MID].id == comboHero[i]) or
		   not(fighter[minidef.P_BACK_RIGHT] and fighter[minidef.P_BACK_RIGHT].id == comboHero[i]) then
			return false
		end
	end
	return true
end

--生物主动技能
function initSummonSkill(templete, skills)
	local cost, prop = 0, 0
	if not(templete.roundSkill) then
		templete.roundSkill = {}
		templete.roundProp = {}
	end
	if type(skills) == 'table' then
		for k, id in pairs(skills) do
			prop = tbSkill[id].probability
			lvl = tbSkill[id].level
			table.insert(templete.roundSkill, id)
			table.insert(templete.roundProp, prop)

			templete.tbSkill[id] = {}
			templete.tbSkill[id].lvl = lvl
		end
	end
end

--英雄主动技能
function initHeroSkill(fighter, templete, skills, skill_lvl, pos)
	local cost, prop, lvl = 0, 0, 0
	if type(skills) == 'table' then
		for _, id in pairs(skills) do
			--添加主动技能圆盘
			cost = tbSkill[id].cost
			prop = tbSkill[id].probability
			if skill_lvl and skill_lvl[cost] then
				lvl = skill_lvl[cost]
			else
				lvl = tbSkill[id].level
			end
			if not(fighter.roundSkill[cost]) then
				fighter.roundSkill[cost] = {}
				fighter.roundSkill[cost].skill = {}
				fighter.roundSkill[cost].prop = {}
			end
			table.insert(fighter.roundSkill[cost].skill, { id,  pos })
			table.insert(fighter.roundSkill[cost].prop, prop)

			templete.tbSkill[id] = {}
			templete.tbSkill[id].lvl = lvl
		end
	end
end

--初始化状态
function initStatus(templete, tbStatusID)
	templete.status = {}
	templete.statusMark = {}
	if type(tbStatusID) == 'table' then
		for i = 1, #tbStatusID do
			addStatus(templete, tbStatusID[i], templete.nLVL)
		end
	end
end

--添加状态
function addStatus(fighter, statusid, skill_lvl)
	local status = fighter.status
	local status_target = tbStatus[statusid].targetactive
	local effect = tbStatus[statusid].effecttype
	local coexist = tbStatusType[effect].coexist
	if status_target == minidef.STATUS_TARGET.ALL or fighter.type == status_target then
	    if coexist == minidef.STATUS_COEXIST.NO then	--同类型直接返回
			local markPos = 0
			for i = 1, #status do
				if tbStatus[status[i].id].effecttype == effect then
					markPos = i
					break
				end
			end
			if markPos == 0 then
				return realAddStatus(fighter, status, statusid, skill_lvl)
			end
		elseif coexist == minidef.STATUS_COEXIST.UP then	--同类型高级替换低级
			local markPos, isIn = 0, false
			for i = 1, #status do
				if tbStatus[status[i].id].effecttype == effect then
					isIn = true
					if skill_lvl > status[i].lvl then
						markPos = i
						break
					end
				end
			end
			if isIn == false then
				return realAddStatus(fighter, status, statusid, skill_lvl)
			elseif (isIn == true) and markPos > 0 then
				return replaceStatus(fighter, status, statusid, markPos, skill_lvl)
			end
		elseif coexist == minidef.STATUS_COEXIST.ALL then	--共存
			return realAddStatus(fighter, status, statusid, skill_lvl)
		end
	end
	return false
end

--替换状态
function replaceStatus(fighter, status, statusid, markPos, lvl)
	local temp = {}
	temp.id = statusid
	temp.lvl = lvl
	if tbStatus[temp.id].duration ~= 0 then	--非永久状态
		temp.duration = tbStatus[temp.id].duration
	end
	if tbStatus[temp.id].effectivetimes ~= 0 then
		temp.times = tbStatus[temp.id].effectivetimes
	end
	-- print('技能', skillid, '对', getCampName(targetCamp), '目标', target, '产生了状态', temp.id, '状态等级', temp.lvl, '替换了状态', status[markPos].id)
	status[markPos] = temp
	return true
end

--真实添加状态
function realAddStatus(fighter, status, statusid, lvl)
	if #status >= minidef.MAX_STATUS_QUEUE_NUM then
		return false
	end
	local temp = {}
	temp.id = statusid
	temp.lvl = lvl
	if tbStatus[temp.id].duration ~= 0 then	--非永久状态
		temp.duration = tbStatus[temp.id].duration
	end
	if tbStatus[temp.id].effectivetimes ~= 0 then
		temp.times = tbStatus[temp.id].effectivetimes
	end
	table.insert(status, temp)
	if tbStatusType[tbStatus[temp.id].effecttype].coexist == minidef.STATUS_COEXIST.NO or
	   tbStatusType[tbStatus[temp.id].effecttype].coexist == minidef.STATUS_COEXIST.UP then
		fighter.statusMark[tbStatus[statusid].effecttype] = true
	end
	-- print('技能', skillid, '对', getCampName(targetCamp), '目标', target, '产生了状态', temp.id, '状态等级', temp.lvl)
	return true
end

--初始化合体技能
function initCombSkill(fighter, combos)
	local cost = 0
	if type(combos) == 'table' then
		for _, comboid in pairs(combos) do
			cost = tbSkill[comboid].cost
			prop = tbSkill[comboid].probability
			if not(fighter.combo[cost]) then
				fighter.combo[cost] = {}
				fighter.combo[cost].skill = {}
				fighter.combo[cost].prop = {}
			end
			table.insert(fighter.combo[cost].skill, { comboid, -1 })
			table.insert(fighter.combo[cost].prop, prop)
		end
	end
end


--===================== 属性相关函数，以下函数里，A攻击方，B受击方 =========================
--A的攻击伤害 = A的攻击力 ×（1 - B的总减伤比）×（1 + A的穿透率）
--最小伤害为1
function getAttackDamage(nAfk_a, nRedAll_b, nPen_a)
	print("getAttackDamage(nAfk_a, nRedAll_b, nPen_a) = ", nAfk_a, nRedAll_b, nPen_a)
	return math.max(nAfk_a * (1 - nRedAll_b) * (1 + nPen_a), 1)
end

--B的总减伤比 = B的减伤比 + B的防御力 /（A的攻击力 / 4 + B的防御力）
--保留一位小数
function getRedAllValue(nRed_b, nDef_b, nAfk_a)
	print("getRedAllValue(nRed_b, nDef_b, nAfk_a) = ", nRed_b, nDef_b, nAfk_a)
	return tonumber(string.format("%.1f", nRed_b + nDef_b / (nAfk_a / 4 + nDef_b)))
end

--A的命中修正系数 =（A的等级 - B的等级）/ 100
--保留一位小数
function getHiters(nLVL_a, nLVL_b)
	return tonumber(string.format("%.1f", (nLVL_a - nLVL_b) / 100))
end

--A的技能命中率1（A的真实命中率）= A的命中率 - B的闪避率 + A的命中修正系数
--保留一位小数
function getHitValue1(nHit_a, nDog_b, nHiters_a)
	return math.max(tonumber(string.format("%.1f", nHit_a - nDog_b + nHiters_a)), 0.1)
end

--A的技能命中率2 = A的命中率 + A的命中修正系数
--保留一位小数
function getHitValue2(nHit_a, nHiters_a)
	return tonumber(string.format("%.1f", nHit_a + nHiters_a))
end

--A的暴击修正系数 =（A的等级 - B的等级）/ 200
--保留一位小数
function getCriters(nLVL_a, nLVL_b)
	print(nLVL_a, nLVL_b, tonumber(string.format("%.1f", (nLVL_a - nLVL_b) / 200)))
	return tonumber(string.format("%.1f", (nLVL_a - nLVL_b) / 200))
end

--A的真实暴击率 = A的暴击率 - B的免爆率 + A的暴击修正系数
--保留一位小数，暴击伤害是直接乘2
function getCritValue(nCrit_a, nTen_b, nCriters_a)
	return math.max(tonumber(string.format("%.1f", nCrit_a - nTen_b + nCriters_a)), 0.05)
end

--减少指定属性
function desAttrValue(origin, des)
	local value = origin - des
	if value < 0 then
		return 0, origin
	else
		return value, des
	end
end
--===================== 属性相关函数end =========================

