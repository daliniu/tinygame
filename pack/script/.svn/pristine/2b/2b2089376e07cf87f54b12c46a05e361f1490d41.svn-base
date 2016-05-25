----------------------------------------------------------
-- file:	factory.lua
-- Author:	page
-- Time:	2015/12/02 16:02 
-- Desc:	pvp竞技场数据处理工厂
----------------------------------------------------------
--data struct 
local TB_STRUCT_ARENA_FACTORY = {
	m_Instance = nil;
	----------------------------------
	-- 1. 日赛
	m_bArenaNormalSignup = false,		-- 是否报名
	m_nArenaNormalTimes = 0,			-- 可以报名的次数
	m_nArenaMasterScore = 0,			-- 大师积分
	m_nArenaDailyTickets = 0,			-- 日赛门票
	m_nArenaNormalWinCount = 0,			-- 已经胜利的场数统计
	m_tbRewardFlag = {},				-- 宝箱领取标记
	m_nArenaNormalFightCount = 0,		-- 战斗次数
	
	-- 2. 日锦标赛
	m_bDailySignup = false,				-- 是否已经报名
	m_tbDailyChipsFightInfo = {},			-- 筹码赛战斗数据
	m_tbDailyEightFightInfo = {},		-- 八强赛战斗数据
	m_nArenaDailyChipsTurn = 0,			-- 筹码赛自己打了多少轮
	m_nArenaDailyChipsMaxTurn = 0,		-- 筹码赛最大轮
	m_nArenaDailyChipsRank = 0,			-- 筹码赛阶段的排名
	
	m_nArenaDailyEightTurn = 0,			-- 八强赛自己打了多少轮
	m_nArenaDailyEightMaxTurn = 4,		-- 八强赛最大轮(已固定)
	m_tbDailyEightPlayers = {},			-- 八强赛八个玩家数据
	m_EightCamp = {},					-- 分一下上下阵营, 方便显示
	m_tbDailyEightRank = {},			-- 八强赛四强轮的一个排名(用于面板显示)
	m_tbDailyEightSelfFightInfo = {},	-- 八强赛自己战斗的数据
}
--------------------------------)
KGC_ARENA_FACTORY_TYPE = class("KGC_ARENA_FACTORY_TYPE", CLASS_BASE_TYPE, TB_STRUCT_ARENA_FACTORY)
--------------------------------
--function
--------------------------------

function KGC_ARENA_FACTORY_TYPE:ctor()	
	
end
--------------------------------------------------------------
function KGC_ARENA_FACTORY_TYPE:Init(tbArg)
	--test
	-- self:UnpackDailyChipsFightInfo({});
	--test end
end

--@function: 单例
function KGC_ARENA_FACTORY_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_ARENA_FACTORY_TYPE.new();
		self.m_Instance:Init();
	end
	return self.m_Instance;
end

--@function: 数据解包
function KGC_ARENA_FACTORY_TYPE:UnpackData(tbNormal, tbDaily, tbWeekly)
	self:UnpackNormalData(tbNormal);
	self:UnpackDailyData(tbNormal, tbDaily);
	self:UnpackWeeklyData(tbNormal, tbWeekly);
end

--@function: 日竞技赛数据解包
function KGC_ARENA_FACTORY_TYPE:UnpackNormalData(tbData)
	if not tbData then
		cclog("[Waning]没有日竞技赛数据解包!");
		return;
	end

	-- 常规赛次数
	local nTimes = tonumber(tbData.ticketN);
	self:SetArenaNormalTimes(nTimes);
	
	-- 大师积分
	local nMasterScore = tonumber(tbData.ticketDay);
	self:SetArenaMasterScore(nMasterScore);
	
	-- 日赛门票
	local nTickets = tonumber(tbData.ticketWeek);
	self:SetArenaDailyTickets(nTickets);
	
	-- 标记
	local nStartMark = tonumber(tbData.startMark);
	self:SetArenaNormalSignup(nStartMark);		
	print("[log]日常赛，是否报名：", nStartMark == 1);
	
	-- 宝箱领取标记
	local nIsGet1 = tonumber(tbData.box1);
	local nIsGet2 = tonumber(tbData.box2);
	local nIsGet3 = tonumber(tbData.box3);
	self:SetArenaNormalRewardFlag(nIsGet1, nIsGet2, nIsGet3);
	print("[log]日常赛，宝箱领取标记：", nIsGet1, nIsGet2, nIsGet3);
	
	-- 战斗次数
	local nFightCount = tonumber(tbData.fightCount);
	self:SetArenaNormalFightCount(nFightCount);
	print("[log]日常赛，战斗次数：", nFightCount);
	
	-- 对战玩家(机器人)数据
	local tbFightInfo = tbData.fightInfoListSng;
	self:UnpackNormalFightInfo(tbFightInfo);
end

--@function: 日锦标赛数据解包
function KGC_ARENA_FACTORY_TYPE:UnpackDailyData(tbNormalData, tbDailyData)
	if not tbNormalData and not tbDailyData then
		cclog("[Waning]没有日锦标赛数据解包!");
		return;
	end
	
	-- 报名标志
	local nMark = tbNormalData.dayMark;
	self:SetDailySignup(nMark == 1);				-- 1表示已经报名
end

--@function: 周锦标赛数据解包
function KGC_ARENA_FACTORY_TYPE:UnpackWeeklyData(tbData)
	
end

--@function: pvpinfo数据解包
function KGC_ARENA_FACTORY_TYPE:UnpackNormalFightInfo(tbData)
	if not tbData then
		return;
	end
	self.m_tbNormalFightInfo = {};
	
	local nWinCount = 0;
	for index, data in pairs(tbData or {}) do
		-- 自己构造数据结构
		local tbFightInfo = {};
		local playerData = data.enemy;
		local player = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData);
		local nResult = data.result;
		local nMasterScore = data.ticketDay;
		
		tbFightInfo.index = index;					-- 服务器传过来的索引(服务器)
		tbFightInfo.result = nResult;				-- 战斗结果(1-胜利)
		tbFightInfo.masterscore = nMasterScore;		-- 大师积分奖励
		tbFightInfo.player = player;				-- 对应的玩家对象
		table.insert(self.m_tbNormalFightInfo, tbFightInfo);
		cclog("normal fight info: vs %s, result = %s, fp = %d", player:GetUuid(), tostring(nResult), player:GetFightPoint());
		
		-- 统计已经打赢了几场
		if nResult == 1 then
			nWinCount = nWinCount + 1;
		end
	end
	
	-- 根据战斗力排序
	local fnCompare = function(a, b)
		local player1 = a.player;
		local player2 = b.player;
		if player1 and player2 then
			local nFP1 = player1:GetFightPoint() or 0;
			local nFP2 = player2:GetFightPoint() or 0;
			return nFP1 < nFP2;
		end
		
		return false;
	end
	table.sort(self.m_tbNormalFightInfo, fnCompare);
	
	print("UnpackNormalFightInfo，玩家个数：", nWinCount);
	self:SetArenaNormalWinCount(nWinCount);
end

--------------------
-- 日常规赛(竞技赛)
--@function: 设置常规赛次数
function KGC_ARENA_FACTORY_TYPE:SetArenaNormalTimes(nTimes)
	self.m_nArenaNormalTimes = nTimes or 0;
end

function KGC_ARENA_FACTORY_TYPE:GetArenaNormalTimes()
	return self.m_nArenaNormalTimes;
end

--@function: 增加拥有的大师积分
function KGC_ARENA_FACTORY_TYPE:AddArenaMasterScore(nNum)
	local nAdd = nNum or 0;
	local nCur = self:GetArenaMasterScore();
	nCur = nCur + nAdd;
	if nCur < 0 then
		nCur = 0;
	end
	self:SetArenaMasterScore(nCur);
end

--@function: 设置拥有的大师积分
function KGC_ARENA_FACTORY_TYPE:SetArenaMasterScore(nNum)
	self.m_nArenaMasterScore = nNum or 0;
end

function KGC_ARENA_FACTORY_TYPE:GetArenaMasterScore()
	return self.m_nArenaMasterScore;
end

--@function: 设置日赛门票
function KGC_ARENA_FACTORY_TYPE:SetArenaDailyTickets(nNum)
	self.m_nArenaDailyTickets = nNum or 0;
end

function KGC_ARENA_FACTORY_TYPE:GetArenaDailyTickets()
	return self.m_nArenaDailyTickets;
end

--@function: 日赛胜场
function KGC_ARENA_FACTORY_TYPE:SetArenaNormalWinCount(nCount)
	self.m_nArenaNormalWinCount = nCount or 0;
end

function KGC_ARENA_FACTORY_TYPE:GetArenaNormalWinCount()
	return self.m_nArenaNormalWinCount;
end

--@function: 战斗次数
function KGC_ARENA_FACTORY_TYPE:SetArenaNormalFightCount(nCount)
	local nCount = nCount or 0;
	self.m_nArenaNormalFightCount = nCount;
end

function KGC_ARENA_FACTORY_TYPE:AddArenaNormalWinCount()
	local nCurCount = self.m_nArenaNormalFightCount;
	self:SetArenaNormalFightCount(nCurCount + 1);
end

function KGC_ARENA_FACTORY_TYPE:GetArenaNormalFightCount()
	-- 配置表总共可以打的次数
	local nCurCount = self.m_nArenaNormalFightCount or 0;
	local nMaxFightCount = 6;
	local nLeftCount = nMaxFightCount - nCurCount;
	return nLeftCount, nMaxFightCount;
end

--@function: 是否已经报名
function KGC_ARENA_FACTORY_TYPE:IsArenaNormalSignup()
	return self.m_bArenaNormalSignup;
end

function KGC_ARENA_FACTORY_TYPE:SetArenaNormalSignup(nStartMark)
	local bSignup = (nStartMark == 1);	-- 1表示已经报名
	self.m_bArenaNormalSignup = bSignup or false;
end

--@function: 是否已经报名
function KGC_ARENA_FACTORY_TYPE:GetArenaNormalRewardFlag()
	if not self.m_tbRewardFlag then
		self.m_tbRewardFlag = {};
	end
	return self.m_tbRewardFlag;
end

--@function: 宝箱领取标记(0未领取, 1领取)
function KGC_ARENA_FACTORY_TYPE:SetArenaNormalRewardFlag(nIsGet1, nIsGet2, nIsGet3)
	local tbRewardGet = self:GetArenaNormalRewardFlag();
	
	tbRewardGet[1] = nIsGet1;
	tbRewardGet[2] = nIsGet2;
	tbRewardGet[3] = nIsGet3;
end

--@function: 宝箱领取标记
function KGC_ARENA_FACTORY_TYPE:SetArenaNormalRewardFlagByIndex(nIndex, nIsGet)
	local tbRewardGet = self:GetArenaNormalRewardFlag();
	tbRewardGet[nIndex] = nIsGet;
end

--@function
function KGC_ARENA_FACTORY_TYPE:GetNormalFightInfo()
	return self.m_tbNormalFightInfo;
end

--@function: 更新一个玩家胜利或者失败
--@nIndex: 用在table中的index来更新
function KGC_ARENA_FACTORY_TYPE:UpdateNormalFightInfo(nIndex, nResult)
	local tbFightInfo = self:GetNormalFightInfo();
	for k, data in pairs(tbFightInfo) do
		local index = data.index;
		if index == nIndex then
			cclog("[log]打完一场更新玩家(index:%s)的结果(%s)@UpdateNormalFightInfo", tostring(nIndex), tostring(nResult));
			data.result = nResult or 0;
			
			-- 胜利次数也加1
			local nCurCount = self:GetArenaNormalWinCount();
			self:SetArenaNormalWinCount(nCurCount+1);
			
			break;
		end
	end
	
	-- test 
	local tbFightInfo = self:GetNormalFightInfo();
	for i, data in pairs(tbFightInfo) do
		local player = data.player;
		local nResult = data.result;
		print(i, player:GetUuid(), nResult);
	end
	-- test end
end
--------------------
-- 日锦标赛
--@function: 日锦标赛是否已经报名
function KGC_ARENA_FACTORY_TYPE:SetDailySignup(bSignup)
	self.m_bDailySignup = bSignup or false;
end

function KGC_ARENA_FACTORY_TYPE:IsDailySignup()
	return self.m_bDailySignup;
end

--@function: 打了多少轮
--@nStage: 阶段 1-筹码赛阶段；2-八强赛阶段
function KGC_ARENA_FACTORY_TYPE:SetArenaDailyTurn(nStage, nTurn, nMaxTurn)
	if nStage == 1 then
		self.m_nArenaDailyChipsTurn = nTurn or 0;
		self.m_nArenaDailyChipsMaxTurn = nMaxTurn or 0;
	elseif nStage == 2 then
		self.m_nArenaDailyEightTurn = nTurn or 0;
		self.m_nArenaDailyEightMaxTurn = nMaxTurn or 4;
	end
end

--@function: 当前阶段总共打了多少回合
--@return: turn-自己打了多少回合；maxturn-总共多少回合
function KGC_ARENA_FACTORY_TYPE:GetArenaDailyTurn(nStage)
	if nStage == 1 then	-- 日赛筹码赛
		return self.m_nArenaDailyChipsTurn, self.m_nArenaDailyChipsMaxTurn;
	elseif nStage == 2 then
		return self.m_nArenaDailyEightTurn, self.m_nArenaDailyEightMaxTurn;
	end	
end

--@function: 设置筹码赛时候的排名
function KGC_ARENA_FACTORY_TYPE:SetDailyChipsRank(nRank)
	self.m_nArenaDailyChipsRank = nRank or 0;
end

function KGC_ARENA_FACTORY_TYPE:GetDailyChipsRank()
	return self.m_nArenaDailyChipsRank;
end

--@function：是否进入8强
function KGC_ARENA_FACTORY_TYPE:IsInEight()
	return self.m_nArenaDailyChipsRank <= 8;
end

--@function: pvpinfo数据解包：筹码赛
function KGC_ARENA_FACTORY_TYPE:UnpackDailyChipsFightInfo(tbData, nMaxTurn)
	if not tbData then
		return;
	end
	self.m_tbDailyChipsFightInfo = {};
	
	-- test 
	local _, tbData = self:TestCreateFightInfo();
	local nMaxTurn = math.random(10);
	-- test end

	local nTurn = 0;
	for _, data in pairs(tbData or {}) do
		local playerData1 = data.player1;
		local player1 = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData1);
		local playerData2 = data.player2;
		local player2 = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData2);
		local nWinner = data.winner;
		local nSeed = data.seed;
		local tbReward = data.fightReward;
		table.insert(self.m_tbDailyChipsFightInfo, {player1, player2, nSeed, nWinner});
		nTurn = nTurn + 1;
	end
	--test
	if nTurn >= nMaxTurn then
		nTurn = nMaxTurn;
	end
	--test end
	self:SetArenaDailyTurn(1, nTurn, nMaxTurn);
end

--@function: pvpinfo数据解包: 八强赛
function KGC_ARENA_FACTORY_TYPE:UnpackDailyEightFightInfo(tbData, nRank)
	-- test 
	local tbData, nChipsRank, nTurn = self:TestCreateEightFightInfo();
	-- local nRank = math.random(100) > 50 and 8 or 1000;
	-- test end
	
	if not tbData then
		return;
	end
	local tbPlayersData = tbData.playerInfoList;
	if not tbPlayersData then
		cclog("[Error]没有八强的玩家数据!@KGC_ARENA_FACTORY_TYPE");
		return;
	end
	self.m_tbDailyEightPlayers = {};
	self.m_tbDailyEightFightInfo = {};
	self.m_EightCamp = {};
	-- self.m_tbDailyEightFightInfo.m_tbSelfData = {};
	
	-- 筹码赛时候的排名
	self:SetDailyChipsRank(nChipsRank);
	
	-- 八强玩家数据
	for _, playerData in pairs(tbPlayersData) do
		local player = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData);
		self.m_tbDailyEightPlayers[player:GetUuid()] = player;
	end
	
	-- 八强对战数据(从决赛开始解析, 能得到对位关系)
	-- nTurn: 表示是第几轮的数据, 用于自己战斗的时候获取数据方便
	local fnUnpack = function(nTurn, data, bInitCamp)
		local bInitCamp = bInitCamp or false;
		local playerData1 = data.player1 or {};
		local nUuid1 = playerData1.uuid;
		local playerData2 = data.player2 or {};
		local nUuid2 = playerData2.uuid;
		local nWinner = data.winner;
		local nSeed = data.seed;
		local tbReward = data.fightReward;
		
		-- 决赛的两个玩家各自为一个阵营
		if bInitCamp then
			print("fnUnpack", nUuid1, nUuid2, me:GetUuid());
			self:SetEightCamp(nUuid1, 1);
			self:SetEightCamp(nUuid2, 2);
		else
			self:InitEightCamp(nUuid1, nUuid2);
		end
		local tbRet = {nUuid1, nUuid2, nSeed, nWinner};
		-- 是不是自己
		if nUuid1 == me:GetUuid() or nUuid2 == me:GetUuid() then
			self:AddDailyEightSelfFightInfo(nTurn, tbRet);
		end
		
		return tbRet;
	end

	-- 倒过来解析: 是为了计算阵营
	-- 第4轮：决赛轮
	self.m_tbDailyEightFightInfo[1] = {};
	for k, data in pairs(tbData.fightInfoList1) do
		local tbFightInfo = fnUnpack(4, data, true);
		self.m_tbDailyEightFightInfo[1][k] = tbFightInfo;
	end
	
	-- 第3轮：冠亚轮
	self.m_tbDailyEightFightInfo[2] = {};
	for k, data in pairs(tbData.fightInfoList2) do
		local tbFightInfo = fnUnpack(3, data);
		self.m_tbDailyEightFightInfo[2][k] = tbFightInfo;
	end
	
	-- 第2轮：四强轮(这一轮做一个排序-->八强战斗面板上面要用到)
	self.m_tbDailyEightFightInfo[3] = {};
	for k, data in pairs(tbData.fightInfoList4) do
		local tbFightInfo = fnUnpack(2, data);
		self.m_tbDailyEightFightInfo[3][k] = tbFightInfo;
	end
	
	-- 第1轮: 排位轮
	self.m_tbDailyEightFightInfo[4] = {};
	for _, data in pairs(tbData.fightInfoList8) do
		local tbFightInfo = fnUnpack(1, data);
		-- 排位轮不需要放进八强赛对阵面板上
		-- table.insert(self.m_tbDailyEightFightInfo[4], tbFightInfo);
	end
	
	self:SetArenaDailyTurn(2, nTurn);
	cclog("[log]nChipsRank: %d, nSelfTurn: %s", nChipsRank, tostring(nTurn));
end

function KGC_ARENA_FACTORY_TYPE:GetDailyChipsFightInfo()
	return self.m_tbDailyChipsFightInfo;
end

--@function：初始化八强阵营, 北(上)州区和南(下)州区
--@nUuid: 要查找的阵营
--@nRefUuid：参考的阵营(1-上; 2-下)
function KGC_ARENA_FACTORY_TYPE:InitEightCamp(nUuid1, nUuid2)
	if not nUuid1 and not nUuid2 then
		return;
	end
	
	if not self.m_EightCamp then
		self.m_EightCamp = {};
	end
	
	-- 用其中一个初始化另外一个阵营为相同的阵营
	local nCamp1 = self.m_EightCamp[nUuid1];
	local nCamp2 = self.m_EightCamp[nUuid2];
	if nCamp1 and not nCamp2 then
		self:SetEightCamp(nUuid2, nCamp1);
	elseif nCamp2 and not nCamp1 then
		self:SetEightCamp(nUuid1, nCamp2);
	end
end

function KGC_ARENA_FACTORY_TYPE:SetEightCamp(nUuid, nCamp)
	if not self.m_EightCamp then
		self.m_EightCamp = {};
	end
	self.m_EightCamp[nUuid] = nCamp;
end

--@function: 当前是哪一个阶段，阶段的哪一步
function KGC_ARENA_FACTORY_TYPE:GetCurrentStage()
	local tbTime = {
		hour = 11,
		min = 31,
		sec = 0,
	}
	
	local nInterval = 30;	--(s)
	local nWait = 30;		--筹码赛到八强赛等待时间(s)
	local nDiff = tf_DiffWithTime(tbTime)
	-- 5分钟一个阶段
	
	local nChipsTurn, nChipsMaxTurn = self:GetArenaDailyTurn(1);
	local nChipsTime = nChipsMaxTurn * nInterval + nWait;
	
	local nEightTurn, nEightMaxTurn = self:GetArenaDailyTurn(2);
	local nEightTime = nChipsTime + nInterval * nEightMaxTurn;
	
	local nStage = 0;
	local nStep = 0;
	if nDiff > 0 and nDiff < nChipsTime then		-- 筹码赛阶段
		nStage = 1;
		nStep = math.floor(nDiff/(1*nInterval)) + 1;
	elseif nDiff >= nChipsTime and nDiff < nEightTime then					-- 八强赛阶段
		nStage = 2;
		nStep = math.floor((nDiff-nChipsTime)/(1*nInterval)) + 1;
	end
	--test
	-- local tbDailyFightInfo = self:GetDailyFightInfo();
	-- nStage = math.random(#(tbDailyFightInfo or {}));
	-- print("GetCurrentStage: ", nStage);
	--test
	-- print(111, nDiff, nChipsTime, nStage, nStep);
	-- 计算是否在当前阶段中
	
	return nStage, nStep;
end

--@function: 保存与自己相关的八强赛数据
function KGC_ARENA_FACTORY_TYPE:AddDailyEightSelfFightInfo(nTurn, tbData)
	local tbSelfFightInfo = self:GetDailyEightSelfFightInfo();
	tbSelfFightInfo[nTurn] = tbData;
end

--@function: 获取与自己相关的八强赛数据
function KGC_ARENA_FACTORY_TYPE:GetDailyEightSelfFightInfo()
	if not self.m_tbDailyEightSelfFightInfo then
		self.m_tbDailyEightSelfFightInfo = {};
	end
	return self.m_tbDailyEightSelfFightInfo;
end

--@function: 是否需要进入战斗界面
--@nSelfTurn: 自己战斗了多少回合
--@nStep: 当前阶段的哪一个步骤
function KGC_ARENA_FACTORY_TYPE:IsFight(nStage, nSelfTurn, nStep)
	local nTurn = 0;
	if nStage == 1 then				-- 筹码赛阶段
		-- 有一个等待时间
		nTurn = nSelfTurn + 1;
	elseif nStage == 2 then			-- 八强赛阶段
		nTurn = nSelfTurn;
	end
	
	if nStep <= nTurn then
		return true;
	end
	
	return false;
end

--@function: 获取当前八强赛数据
function KGC_ARENA_FACTORY_TYPE:GetDailyEightFightInfo()
	-- 四强轮
	local tbFightInfo4 = self.m_tbDailyEightFightInfo[3];
	
	-- 冠亚轮
	local tbFightInfo2;
	local tbFightInfo2 = self.m_tbDailyEightFightInfo[2];
	
	-- 决赛轮
	local tbFightInfo1;
	local tbFightInfo1 = self.m_tbDailyEightFightInfo[1];
	
	return tbFightInfo4, tbFightInfo2, tbFightInfo1;
end

--@function: 获取当前八强赛玩家数据
function KGC_ARENA_FACTORY_TYPE:GetDailyEightFightPlayers()
	return self.m_tbDailyEightPlayers;
end

--@function: 获取当前战斗界面的两个数据
--@return: 返回的数据是玩家对象
function KGC_ARENA_FACTORY_TYPE:GetDailyFightInfo()
	local nStage, nStep = self:GetCurrentStage();
	local nTurn, nMaxTurn = self:GetArenaDailyTurn(nStage);
	if nStage == 1 then
		local tbFightInfo = self:GetDailyChipsFightInfo();
		if nStep <= nTurn then
			return tbFightInfo[nStep];
		end
	elseif nStage == 2 then
		local tbSelfFightInfo = self:GetDailyEightSelfFightInfo();
		local tbPlayers = self:GetDailyEightFightPlayers();
		if tbSelfFightInfo[nStep] then
			local nUuid1, nUuid2, nSeed, nWinner = unpack(tbSelfFightInfo[nStep]);
			
			local playerData1 = tbPlayers[nUuid1];
			local player1 = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData1);
			local playerData2 = tbPlayers[nUuid2];
			local player2 = KGC_PLAYER_FACTORY_TYPE:getInstance():CreatePlayer(playerData2);
			local tbFightInfo = {player1, player2, nSeed, nWinner};
			
			return tbFightInfo;
		end
	end
end
------------------------------------------------------
--test

function KGC_ARENA_FACTORY_TYPE:TestCreateFightInfo()
 -- 日赛
	local tbFightInfo = {};
	local nMax = math.random(6);
	print("随机玩家个数 ... nMax: ", nMax);
	for i = 1, nMax do
		local tbData = {};
		tbData.enemy = g_tbTestPlayerInfo;
		tbData.result = 2;
		tbData.ticketDay = 100;
		table.insert(tbFightInfo, tbData);
	end
	
	local tbDailyFightInfo = {};
	-- 日锦标赛
	if not self.m_tbTestData then
		self.m_tbTestData = {}
	end
	local nTimeStamp = tonumber(os.date("%d", os.time()));
	if not self.m_tbTestData.tbDailyFightInfo or self.m_tbTestData.nTimeStamp1 ~= nTimeStamp  then
		self.m_tbTestData.tbDailyFightInfo = {};
		tbDailyFightInfo = self.m_tbTestData.tbDailyFightInfo;
		self.m_tbTestData.nTimeStamp1 = nTimeStamp;
		local nMax = math.random(10);
		print("随机筹码赛场数 ... nMax: ", nMax);
		for i = 1, nMax do
			local tbData = {};
			tbData.player1 = g_tbTestPlayerInfo;
			tbData.player2 = g_tbTestPlayerInfo;
			tbData.seed = 2;
			tbData.winner = math.random(2);
			table.insert(tbDailyFightInfo, tbData);
		end
	else
		print("[log]筹码赛用老数据：");	
		tbDailyFightInfo = self.m_tbTestData.tbDailyFightInfo;
	end

	return tbFightInfo, tbDailyFightInfo;
end

function KGC_ARENA_FACTORY_TYPE:TestCreateEightFightInfo()
	if not self.m_tbTestData then
		self.m_tbTestData = {}
	end
	
	local nTimeStamp = tonumber(os.date("%d", os.time()));
	if not self.m_tbTestData.tbEightFightInfo or self.m_tbTestData.nTimeStamp ~= nTimeStamp  then
		self.m_tbTestData.tbEightFightInfo = {};
		self.m_tbTestData.nTimeStamp = nTimeStamp;
	else
		local nChipsRank = self:GetDailyChipsRank();
		local nTurn = self:GetArenaDailyTurn(2);
		print("[log]八强用老数据.", nChipsRank, nTurn);
		
		return self.m_tbTestData.tbEightFightInfo, nChipsRank, nTurn;
	end
	-- 日锦标赛
	local tbEightFightInfo = self.m_tbTestData.tbEightFightInfo;
	math.randomseed(os.time());
	local nRandom = math.random(100);
	local bInEight = (nRandom > 50) and true or false;
	local nChipsRank = 1000;
	local nMax = 8;
	local nSelfTurn = 0;
	if bInEight then
		nChipsRank = 8;
		nMax = nMax - 1;
		nSelfTurn = 1;
	end
	print("随机数", nRandom, "随机八强赛玩家个数：", nMax, "是否进八强：", bInEight);
	
	tbEightFightInfo.playerInfoList = {};
	for i = 1, nMax do
		local nUuid = "uuid" .. i;
		local player = gf_CopyTable(g_tbTestPlayerInfo);
		player.uuid = nUuid;
		table.insert(tbEightFightInfo.playerInfoList, player);
	end
	if bInEight then
		table.insert(tbEightFightInfo.playerInfoList, gf_CopyTable(g_tbTestPlayerInfo));
	end
	
	-- fightInfoList8
	tbEightFightInfo.fightInfoList8 = {};
	local tbWinner8 = {};
	for i = 1, 4 do
		local tbData = {};
		local player1 = tbEightFightInfo.playerInfoList[i]
		local player2 = tbEightFightInfo.playerInfoList[9-i]
		tbData.player1 = {uuid = player1.uuid, area = 1};
		tbData.player2 = {uuid = player2.uuid, area = 1};
		tbData.seed = os.time();
		local nWinner = math.random(2)
		tbData.winner = nWinner;
		tbWinner8[i] = nWinner;
		
		table.insert(tbEightFightInfo.fightInfoList8, tbData);
	end
	
	-- fightInfoList4
	tbEightFightInfo.fightInfoList4 = {};
	local tbWinner4 = {};
	for i = 1, 4 do
		local tbData = {};
		local player1 = tbEightFightInfo.playerInfoList[i]
		local player2 = tbEightFightInfo.playerInfoList[9-i]
		tbData.player1 = {uuid = player1.uuid, area = 1};
		tbData.player2 = {uuid = player2.uuid, area = 1};
		tbData.seed = os.time();
		local nWinner = math.random(2)
		tbData.winner = nWinner;
		tbWinner4[i] = nWinner;
		-- 自己排名
		if i == 1 and nWinner % 2 == 0 then
			-- nRank = 4;
			nSelfTurn = nSelfTurn + 1;
		end
		print("fightInfoList4: ", player1.uuid, player2.uuid, tbData.seed, nWinner);
		table.insert(tbEightFightInfo.fightInfoList4, tbData);
	end
	
	-- fightInfoList2
	tbEightFightInfo.fightInfoList2 = {};
	local tbWinner2 = {};
	for i = 1, 2 do
		local tbData = {};
		local nIndex1 = i;
		if tbWinner4[nIndex1] % 2 == 0 then
			nIndex1 = 9 - nIndex1;
		end
		local player1 = tbEightFightInfo.playerInfoList[nIndex1]
		
		local nIndex2 = i + 2;
		if tbWinner4[nIndex2] % 2 == 0 then
			nIndex2 = 9 - nIndex2;
		end
		local player2 = tbEightFightInfo.playerInfoList[nIndex2]
		
		tbData.player1 = {uuid = player1.uuid, area = 1};
		tbData.player2 = {uuid = player2.uuid, area = 1};
		tbData.seed = os.time();
		local nWinner = math.random(2)
		tbData.winner = nWinner;
		local nWinIndex = (nWinner % 2 == 0) and nIndex2 or nIndex1;
		tbWinner2[i] = {nWinner, nWinIndex};
		
		-- 自己排名
		if nIndex1 == 1 and tbWinner4[nIndex1] == 2 and nWinner ~= 2 then
			-- nRank = 2;
			nSelfTurn = nSelfTurn + 1;
		end
		print("fightInfoList2: ", player1.uuid, player2.uuid, tbData.seed, nWinner);
		table.insert(tbEightFightInfo.fightInfoList2, tbData);
	end
	
	-- fightInfoList1
	tbEightFightInfo.fightInfoList1 = {};
	for i = 1, 1 do
		local tbData = {};
		local nIndex1 = 2*i-1;
		local nWinIndex1 = tbWinner2[nIndex1][2];
		local player1 = tbEightFightInfo.playerInfoList[nWinIndex1]
		
		local nIndex2 = 2*i;
		local nWinIndex2 = tbWinner2[nIndex2][2];
		local player2 = tbEightFightInfo.playerInfoList[nWinIndex2]
		
		tbData.player1 = {uuid = player1.uuid, area = 1};
		tbData.player2 = {uuid = player2.uuid, area = 1};
		tbData.seed = os.time();
		local nWinner = math.random(2)
		tbData.winner = nWinner;
		
		-- 自己排名
		if tbWinner2[nIndex1][2] == 8 and nWinner ~= 2 then
			-- nRank = 1;
			nSelfTurn = nSelfTurn + 1;
		end
		print("fightInfoList1: ", player1.uuid, player2.uuid, tbData.seed, nWinner);
		table.insert(tbEightFightInfo.fightInfoList1, tbData);
	end
	
	print("[log]TestCreateEightFightInfo end.", tbEightFightInfo, nChipsRank, nSelfTurn);
	return tbEightFightInfo, nChipsRank, nSelfTurn;
end

g_tbTestPlayerInfo = {
	 ["level"] = 50,
	 ["uuid"] = "test023",
	 ["teamList"] = {
		 ["10013"] = {
			 ["level"] = 50,
			 ["star"] = 1,
			 ["skillSlotList"] = {
				 ["4"] = {
					 ["level"] = 1,
				 },
				 ["1"] = {
					 ["level"] = 2,
				 },
				 ["5"] = {
					 ["level"] = 1,
				 },
				 ["2"] = {
					 ["level"] = 2,
				 },
				 ["6"] = {
					 ["level"] = 1,
				 },
				 ["3"] = {
					 ["level"] = 1,
				 },
			 },
			 ["suitId2"] = 63,
			 ["heroId"] = 10013,
			 ["suitId1"] = 61,
			 ["pos"] = 4,
			 ["suitId3"] = 64,
			 ["quality"] = 0,
			 ["suitId4"] = 64,
			 ["curExp"] = 5358,
			 ["suitId5"] = 64,
		 },
		 ["10004"] = {
			 ["level"] = 28,
			 ["star"] = 1,
			 ["skillSlotList"] = {
				 ["4"] = {
					 ["level"] = 1,
				 },
				 ["1"] = {
					 ["level"] = 1,
				 },
				 ["5"] = {
					 ["level"] = 1,
				 },
				 ["2"] = {
					 ["level"] = 1,
				 },
				 ["6"] = {
					 ["level"] = 1,
				 },
				 ["3"] = {
					 ["level"] = 1,
				 },
			 },
			 ["suitId2"] = 17,
			 ["heroId"] = 10004,
			 ["suitId1"] = 17,
			 ["pos"] = 6,
			 ["suitId3"] = 20,
			 ["quality"] = 0,
			 ["suitId4"] = 18,
			 ["curExp"] = 3375,
			 ["suitId5"] = 17,
		 },
		 ["10003"] = {
			 ["level"] = 50,
			 ["star"] = 1,
			 ["skillSlotList"] = {
				 ["4"] = {
					 ["level"] = 1,
				 },
				 ["1"] = {
					 ["level"] = 1,
				 },
				 ["5"] = {
					 ["level"] = 1,
				 },
				 ["2"] = {
					 ["level"] = 1,
				 },
				 ["6"] = {
					 ["level"] = 1,
				 },
				 ["3"] = {
					 ["level"] = 1,
				 },
			 },
			 ["suitId2"] = 13,
			 ["heroId"] = "10003",
			 ["suitId1"] = 12,
			 ["pos"] = 5,
			 ["suitId3"] = 14,
			 ["quality"] = 1,
			 ["suitId4"] = 15,
			 ["curExp"] = 6443,
			 ["suitId5"] = 14,
		 },
	 },
	 ["equipList"] = {
		 ["2"] = {
			 ["14474831229752800"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110103,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14474870914212300"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110104,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14476450424007100"] = {
				 ["star"] = 0,
				 ["n2"] = 10,
				 ["id"] = 10128,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = 3,
				 ["a2"] = 2,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = 0,
				 ["a3"] = 0,
				 ["n1"] = 999,
			 },
			 ["14476450066282900"] = {
				 ["star"] = 0,
				 ["n2"] = 10,
				 ["id"] = 10104,
				 ["n3"] = 99,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = 3,
				 ["a2"] = 2,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = 0,
				 ["a3"] = 1,
				 ["n1"] = 999,
			 },
		 },
		 ["1"] = {
			 ["14484188353335000"] = {
				 ["star"] = 0,
				 ["n2"] = 25,
				 ["id"] = 10103,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = 5,
				 ["a2"] = 6,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = 0,
				 ["a3"] = 0,
				 ["n1"] = 70,
			 },
			 ["14484188353345700"] = {
				 ["star"] = 0,
				 ["n2"] = 234,
				 ["id"] = 10109,
				 ["n3"] = 111,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = 1,
				 ["a2"] = 4,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = 0,
				 ["a3"] = 3,
				 ["n1"] = 11,
			 },
			 ["14474830623462000"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110103,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14484188353356000"] = {
				 ["star"] = 0,
				 ["n2"] = 999,
				 ["id"] = 10155,
				 ["n3"] = 22,
				 ["n4"] = 11,
				 ["sn"] = 0,
				 ["a1"] = 1,
				 ["a2"] = 3,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = 2,
				 ["a3"] = 4,
				 ["n1"] = 11,
			 },
		 },
		 ["3"] = {
			 ["14474871468835000"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110101,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14478470416077400"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110102,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14474864469226600"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110103,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
			 ["14478470727050300"] = {
				 ["star"] = 0,
				 ["n2"] = 0,
				 ["id"] = 110106,
				 ["n3"] = 0,
				 ["n4"] = 0,
				 ["sn"] = 0,
				 ["a1"] = -1,
				 ["a2"] = -1,
				 ["num"] = 1,
				 ["sa"] = 0,
				 ["ss"] = 0,
				 ["a4"] = -1,
				 ["a3"] = -1,
				 ["n1"] = 0,
			 },
		 },
	 },
	 ["userName"] = "test023",
 }