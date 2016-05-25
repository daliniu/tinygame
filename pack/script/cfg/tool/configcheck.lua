------------------------------------------------------------
-- file:	configcheck.lua
-- Author:	page
-- Time:	2015/10/12 09:54 
-- Desc:	配置表检查工具
------------------------------------------------------------

local l_tbSkill = require("script/cfg/skills.lua");
local l_tbSkillResult = require("script/cfg/skillresults.lua");
local l_tbSkillShowout = require("script/cfg/client/skillshowout.lua");

-- 技能表相关检查
function check_skill()
	print("开始检测技能表 ... ");
	-- tst_print_lua_table(l_tbSkill);
	local bRet = true;
	for nSkillID, tbData in pairs(l_tbSkill) do
		if not l_tbSkillShowout[nSkillID] then
			print("[Error]在skillshowout表中没有ID", nSkillID);
			bRet = false;
		end
		
		local nResultID = tbData.skillresultsid;
		if not l_tbSkillResult[nResultID] then
			print("[Error]在skillresults表中没有ID", nResultID);
			bRet = false;
		end
	end
	
	print("技能表检测完成.");
	return bRet;
end

local l_tbCharacter = require("script/cfg/character.lua");
local l_tbMonster = require("script/cfg/monster.lua");
local l_tbSummons = require("script/cfg/summons.lua");
local l_tbModel = require("script/cfg/client/model.lua");

-- 角色表(英雄、怪物、召唤物)相关检查
function check_model()
	print("开始检测角色表 ... ");
	local bRet = true;
	for nID, tbData in pairs(l_tbCharacter) do
		local nModelID = tbData.modelid;
		if not l_tbModel[nModelID] then
			bRet = false;
			local szLog = string.format("[Error]在英雄character表中没有英雄(%d)模型(%d)", nID, nModelID);
			print(szLog);
		end
		
		local bTemp = check_model_skill(nID, tbData, true);
		if not bTemp then
			bRet = false;
		end
	end
	
	for nID, tbData in pairs(l_tbMonster) do
		local nModelID = tbData.modelid;
		if not l_tbModel[nModelID] then
			bRet = false;
			local szLog = string.format("[Error]在英雄character表中没有怪物(%d)模型(%d)", nID, nModelID);
			print(szLog);
		end
		
		local bTemp = check_model_skill(nID, tbData);
		if not bTemp then
			bRet = false;
		end
	end
	
	for nID, tbData in pairs(l_tbSummons) do
		local nModelID = tbData.modelid;
		if not l_tbModel[nModelID] then
			bRet = false;
			local szLog = string.format("[Error]在英雄character表中没有召唤物(%d)模型(%d)", nID, nModelID);
			print(szLog);
		end
		
		local bTemp = check_model_skill(nID, tbData);
		if not bTemp then
			bRet = false;
		end
	end
	print("角色表检测完成.");
	return bRet;
end

-- 检测角色的技能配置是否有问题
function check_model_skill(nNpcID, tbData, bFlag)
	if not tbData then
		print("[Error]");
		return;
	end
	local bRet = true;
	local tbNormalSkill = tbData.skillid or {};
	local bExistNormal = false;
	for _, nID in pairs(tbNormalSkill) do
		if not l_tbSkill[nID] and nID ~= 0 then
			local szLog = string.format("[Error]英雄(%d)普攻技能(%d)在技能表中没有", nNpcID, nID);
			print(szLog);
			bRet = false;
		elseif nID > 0 then
			local nCost = l_tbSkill[nID].cost;
			local nType = l_tbSkill[nID].type;
			if nType == 0 and nCost == 0 then
				bExistNormal = true;
			end
		end
	end
	-- 非英雄的普通技能检测
	if not bFlag then
		if not bExistNormal then
			local szLog = string.format("[Error]NPC(%d)没有普通技能", nNpcID);
			print(szLog);
			bRet = false;
		end
	end
	
	-- 触发技能
	local tbCondSkill = tbData.conskillid or {};
	for _, nID in pairs(tbCondSkill) do
		if not l_tbSkill[nID] and nID ~= 0 then
			local szLog = string.format("[Error]英雄(%d)触发技能(%d)在技能表中没有", nNpcID, nID);
			print(szLog);
			bRet = false;
		end
	end
	
	-- 英雄技能不一样的检测
	if bFlag then
		-- 英雄普攻技能
		local tbNormalSkill = tbData.commonskillid or {};
		local tbCostCheck = {};
		for _, nID in pairs(tbNormalSkill) do
			if not l_tbSkill[nID] and nID ~= 0 then
				local szLog = string.format("[Error]英雄(%d)普攻技能(%d)在技能表中没有", nNpcID, nID);
				print(szLog);
				bRet = false;
			else
				local nCost = l_tbSkill[nID].cost;
				local nType = l_tbSkill[nID].type;
				if nType ~= 0 then
					local szLog = string.format("[Error]英雄(%d)普攻技能(%d)类型不正确(%s)", nNpcID, nID, tostring(nType));
					print(szLog);
					bRet = false;
				end
				tbCostCheck[nCost] = nID;
			end
		end
		for i=1, 6 do
			if not tbCostCheck[i] then
				local szLog = string.format("[Error]英雄(%d)普攻技能没有%d费用的", nNpcID, i);
				print(szLog);
				bRet = false;
			end
		end
		
		-- 英雄技能槽技能
		for i = 1, 12 do
			local n1 = math.floor((i-1)/2) + 1;
			local n2 = (i-1)%2 + 1;
			local szSkill = "skill" .. n1 .. "_" .. n2;
			local tbSkill = tbData[szSkill]
			if not tbSkill then
				local szLog = string.format("[Error]英雄(%d)技能(%s)没有配满", nNpcID, szSkill);
				print(szLog);
			else
				local nSkillID = tbSkill[1];
				if not l_tbSkill[nSkillID] then
					bRet = false;
					local szLog = string.format("[Error]在英雄表中没有英雄(%d)技能(%d)@%s", nNpcID, nSkillID, szSkill);
					print(szLog);
				end
			end
		end
	end
	return bRet;
end

function check()
	print("/***************************************************/");
	print("/**********************配置表检查*******************/");
	print("/***************************************************/");
	-- 1. 技能表检测
	local bRet1 = check_skill();
	-- 2. 角色表检测
	local bRet2 = check_model();
	
	print("/**********************检查结束********************/");
	return bRet1 and bRet2;
end


-------------------------------------------------------------
-- print(check())