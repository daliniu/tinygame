----------------------------------------------------------
-- file:	rewardmanager.lua
-- Author:	page
-- Time:	2015/06/01 16:26 节日快乐 ^_^
-- Desc:	奖励管理类
--			
----------------------------------------------------------
require("script/core/configmanager/configmanager");
--local l_tbMapReward = mconfig.loadConfig("script/cfg/pick/drop")
----------------------------------------------------------
--data struct
local TB_STRUCT_REWARD_MANAGER = {
	m_Instance = nil;
}

KGC_REWARD_MANAGER_TYPE = class("KGC_REWARD_MANAGER_TYPE", CLASS_BASE_TYPE, TB_STRUCT_REWARD_MANAGER)

----------------------------------------
--function
----------------------------------------
function KGC_REWARD_MANAGER_TYPE:ctor()
end
--

--@function: 单实例(就这个用小写, 其他程序习惯了)
function KGC_REWARD_MANAGER_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_REWARD_MANAGER_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end
----------------------------------------------------------
function KGC_REWARD_MANAGER_TYPE:Init()
	
end

--@function: 获取奖励信息
-- function KGC_REWARD_MANAGER_TYPE:GetReward(nID)
	-- print("[Log]开始给奖励@GetReward...", nID)
	-- local tbConfig = l_tbMapReward[nID]

	-- if not tbConfig then
		-- cclog("[Error]错误的奖励ID@GetReward(%s)", tostring(nID))
		-- return false;
	-- end
	
	-- local nGold, nExp, nExpTeam, nAP, nSign, nDropID = tbConfig.Money, tbConfig.Experience, tbConfig.Experience2, tbConfig.AP, tbConfig.Sign, tbConfig.Drop;
	
	-- -- 返回：金币、英雄经验、团队经验、体力、掉落包ID
	-- cclog("[log]奖励ID(%s)对应的奖励：金币(%d)、英雄经验(%d)、团队经验(%d)、体力(%d)、标记(%s)、掉落包ID(%s)", tostring(nID), nGold, nExp, nExpTeam, nAP, tostring(nSign), tostring(nDropID));
	-- return nGold, nExp, nExpTeam, nAP, nSign, nDropID;
-- end

--@function: 增加奖励给玩家
--@nID: 奖励ID
--@tbItems: 服务器传回来的掉落包
--@return: 返回：金币、经验、体力、道具对象
-- function KGC_REWARD_MANAGER_TYPE:AddRewardByID(nID, tbItems)
	
	-- local nGold, nExp, nExpTeam, nAP, nSign, nDropID = self:GetReward(nID);
	
	-- if not nGold then 
		-- cclog("[Error]奖励配置表错误！");
		-- return false;
	-- end
	
	-- local tbObjs = self:AddReward(nGold, nExp, nAP, tbItems);
	
	-- return true, nGold, nExp, nExpTeam, nAP, nSign, tbObjs;
-- end

--@function: 增加奖励给玩家
--@return: tbArg是服务端传过来的结构
--[[
tbArg = {
	gold = 
	diamond = 
	team_exp = 
	itemList = {},
	equipList = {},
}
]]
function KGC_REWARD_MANAGER_TYPE:AddReward(tbArg)
	local tbArg = tbArg or {};
	local tbItems = {};
	tbItems.itemList = tbArg.itemList;
	tbItems.equipList = tbArg.equipList;
	local nGold = tonumber(tbArg.gold or 0);
	local nDiamond = tonumber(tbArg.diamond or 0);
	local nTeamExp = tonumber(tbArg.team_exp or 0);
	-- local nAP = tonumber(tbArg.team_exp or 0);
	cclog("[log]KGC_REWARD_MANAGER_TYPE:AddReward: ");
	tst_print_lua_table(tbArg);
	
	local tbCurrency = {};
	if nGold > 0 then
		local szKey, nNum = self:AddGold(nGold);
		tbCurrency[szKey] = nNum;
	end
	
	if nTeamExp > 0 then
		local szKey, nNum = self:AddTeamExp(nTeamExp);
		tbCurrency[szKey] = nNum;
	end
	-- me:AddAP(nAP);
	
	-- 增加道具
	local tbItemAdd = self:AddItem(tbItems);

	return tbCurrency, tbItemAdd;
end

--@function: 增加奖励 -- 道具
--@return: 道具 = {{id1, num1}, {id2, num2}, ...}
function KGC_REWARD_MANAGER_TYPE:AddItem(tbItems)
	local tbItems = tbItems or {};
	
	local tbItemAdd = {};
	for nIndex, tbData in pairs(tbItems.itemList or {}) do
		local item, num = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbItemAdd, {item, num});
	end
	
	for nIndex, tbData in pairs(tbItems.equipList or {}) do
		local item, num = me:GetBag():AddItem(nIndex, tbData);
		table.insert(tbItemAdd, {item, num});
	end

	return tbItemAdd;
end

--@function: 增加奖励 -- 金币
function KGC_REWARD_MANAGER_TYPE:AddGold(nNum)
	me:AddGold(nNum);

	return "gold", nNum;
end

--@function: 增加奖励 -- 个人经验
function KGC_REWARD_MANAGER_TYPE:AddHeroExp(nNum)
	me:AddExp(nNum);

	return "heroexp", nNum;
end

--@function: 增加奖励 -- 团队经验
function KGC_REWARD_MANAGER_TYPE:AddTeamExp(nNum)
	-- 暂时还没改
	me:AddExp(nNum);
	
	return "teamexp", nNum;
end

--@function: 增加奖励 -- 行动力
function KGC_REWARD_MANAGER_TYPE:AddAP(nNum)
	me:AddAP(nNum);

	return "ap", nNum;
end

--@function: 增加奖励 -- 钻石
function KGC_REWARD_MANAGER_TYPE:AddDiamond(nNum)
	local nNum = nNum or 0;
	me:AddDiamond(nNum);

	return "rmb", nNum;
end

--@function: 增加奖励 -- 大师积分
function KGC_REWARD_MANAGER_TYPE:AddMasterScore(nNum)
	local nNum = nNum or 0;
	-- me:AddDiamond(nNum);

	return "masterscore", nNum;
end

--@function: 增加奖励 -- 日赛门票
function KGC_REWARD_MANAGER_TYPE:AddDailyTicket(nNum)
	local nNum = nNum or 0;
	-- me:AddDiamond(nNum);

	return "normalticket", nNum;
end
----------------------------------------------------------
--test
----------------------------------------------------------
