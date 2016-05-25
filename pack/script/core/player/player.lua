----------------------------------------------------------
-- file:	player.lua
-- Author:	page
-- Time:	2014/12/02
-- Desc:	角色的接口文件
----------------------------------------------------------
require "script/core/player/ship"
require("script/core/configmanager/configmanager");
--------------------------------
--define
--------------------------------
local l_tbAfkConfig = mconfig.loadConfig("script/cfg/map/afkreward")
local l_tbEquipPos = def_GetPlayerEquipPos();

--data struct
-- 继承player/ship.lua
-- ship中的成员变量直接继承(玩家和队伍共用的成员变量)
-- player只有玩家独有的成员变量
local TB_STRUCT_PLAYER = {
	m_nMaxFP = 0,		-- 最大战斗力
	m_nAP = 2000,		-- 行动力
	m_nCoin = 0,		-- 铜板
	m_nDiamond = 0,		-- 钻石
	m_nGold = 0,		-- 金币
	m_nVipLv = 0,		-- vip等级

	m_sUuid=0,			-- uuid
	m_nArea=0,			-- 区服
	m_plat='null',		-- 登录平台

	m_nEquipSuit = 0,	-- 对应哪一套装备

	m_nAfkerRewardPercent = 0,	-- 挂机宝箱进度(百分比)
}


KGC_PLAYER_TYPE = class("KGC_PLAYER_TYPE", KGC_SHIP_BASE_TYPE, TB_STRUCT_PLAYER)

--------------------------------
--function
--------------------------------
function KGC_PLAYER_TYPE:ctor()

end

--OnInit
function KGC_PLAYER_TYPE:OnInit(tbArg)
	if type(tbArg) == "table" then
		self:SetGold(tbArg.gold)
		self:SetDiamond(tbArg.diamond or 0)
		self:SetVIP(tbArg.vip)
		self:SetAP(tbArg.action)
		self:setUuid(tbArg.uuid);
		self:SetAccount(tbArg.uuid);
		self:SetArea(tbArg.area);
		self:SetName(tbArg.userName);
	end

	-- 英雄和装备初始化完之后计算
	self:CalcSuitAttribute();
end

--@function: 获取名字
function KGC_PLAYER_TYPE:GetName()
	return self.m_szName;
end

function KGC_PLAYER_TYPE:SetName(szName)
	self.m_szName = szName or "";
end

--@function: 获取行动力
function KGC_PLAYER_TYPE:GetAP()
	return self.m_nAP;
end

function KGC_PLAYER_TYPE:AddAP(iValue)
	if type(iValue) ~= "number" then
		cclog("[Error]参数类型不正确！@AddAp")
		return;
	end
	local nCur = self:GetAP();
	self:SetAP(nCur + iValue)
end

function KGC_PLAYER_TYPE:SetAP(nAP)
	if type(nAP) ~= "number" then
		cclog("[Error]参数类型不正确！@SetStep")
		return;
	end
	self.m_nAP = nAP or 0;
end

function KGC_PLAYER_TYPE:SetTeamHp(nHp)
	self.m_map:SetTeamHp(nHp)
end

function KGC_PLAYER_TYPE:GetTeamHp()
	return self.m_map:GetTeamHp();
end

--@function: 获取金币数量
function KGC_PLAYER_TYPE:GetGold()
	return self.m_nGold;
end

function KGC_PLAYER_TYPE:SetGold(nGold)
	if type(nGold) ~= "number" then
		cclog("[Error]参数类型不正确！@SetGold")
		return;
	end
	self.m_nGold = nGold or 0;
end

function KGC_PLAYER_TYPE:AddGold(nGold)
	if type(nGold) ~= "number" then
		cclog("[Error]参数类型不正确！@SetGold")
		return;
	end
	local nCur = self:GetGold();
	self:SetGold(nCur + nGold)
end

--@function: 获取砖石数量
function KGC_PLAYER_TYPE:GetDiamond()
	return self.m_nDiamond;
end

function KGC_PLAYER_TYPE:SetDiamond(nDiamond)
	if type(nDiamond) ~= "number" then
		cclog("[Error]参数类型不正确！@SetDiamond")
		return;
	end
	self.m_nDiamond = nDiamond or 0;
end

--@function: 设置VIP
function KGC_PLAYER_TYPE:SetVIP(nVIP)
	self.m_nVipLv = nVIP or 0;
end

function KGC_PLAYER_TYPE:GetVIP()
	return self.m_nVipLv;
end

function KGC_PLAYER_TYPE:setUuid(uuid)
	self.m_sUuid = uuid;
end

--uuid
function KGC_PLAYER_TYPE:GetUuid()
	return self.m_sUuid;
end

function KGC_PLAYER_TYPE:SetArea(area)
	self.m_nArea = area;
end


--区服
function KGC_PLAYER_TYPE:GetArea()
	return self.m_nArea;
end

function KGC_PLAYER_TYPE:GetPlat()
	return self.m_plat;
end

function KGC_PLAYER_TYPE:SetPlat(plat)
	self.m_plat = plat;
end

--@function：获取玩家所在地图ID
function KGC_PLAYER_TYPE:GetMapID()
	local nID = 0;
	if self.m_map then
		nID = self.m_map:GetMapID();
	end

	-- 默认地图
	if not nID or nID == 0 then
		nID = 1;
	end
	return nID;
end

--@function：获取玩家当前所在挂机点ID
function KGC_PLAYER_TYPE:GetCurrentAfkPoint()
	local nID = 0;
	if self.m_map then
		nID = self.m_map:GetFightPointID() or 0;
	end

	print("[Log]当前挂机点为: ", nID)
	return nID;
end

--@function：默认挂机点
function KGC_PLAYER_TYPE:GetDefaultAfkPoint()
	print("[Log]使用默认挂机点!")
	return 9006;
end

--@function: 获取挂机数据
function KGC_PLAYER_TYPE:GetAfkStatistics()
	if self.m_Afk then
		local nGold = self.m_Afk:GetGold();
		local nExp = self.m_Afk:GetExp();
		local nAP = self.m_Afk:GetAP();
		local tbItems = self.m_Afk:GetItems();
		local tbEquips = self.m_Afk:GetEquips();

		return nGold, nExp, nAP, tbItems, tbEquips;
	end
end

function KGC_PLAYER_TYPE:AddAfkStatistics(nGold, nExp, nAP, tbItems)
	if self.m_Afk then
		self.m_Afk:AddGold(nGold);
		self.m_Afk:AddExp(nExp);
		self.m_Afk:AddAP(nAP);
		for _, tbData in pairs(tbItems or {}) do
			self.m_Afk:AddItem(tbData)
		end
	end
end

--@function: 挂机宝箱进度保存在这里
function KGC_PLAYER_TYPE:SetAfkerRewardPercent(nPercent)
	self.m_nAfkerRewardPercent = nPercent;
end

function KGC_PLAYER_TYPE:GetAfkerRewardPercent()
	return self.m_nAfkerRewardPercent;
end
---------------------------------------------------
-- *** 英雄相关 ***

--@function: 随机挂机点怪物盒子
--@function: 指定挂机点
function KGC_PLAYER_TYPE:RandomMonsterBoxID(nAfkerPoint)
	local nID = self:GetCurrentAfkPoint();
	if nAfkerPoint then
		nID = nAfkerPoint;
	end
	if nID == 0 then
		nID = self:GetDefaultAfkPoint();
	end
	local tbPoints = l_tbAfkConfig[nID].monsterid or {}
	--test
	if DEBUG_SEED then
		local szLog = "RandomMonsterBoxID\n";
		tst_write_file("tst_random_function.txt", szLog);
	end
	--test end
	local nRand = gf_Random(#tbPoints);
	cclog("[Log]挂机点%d随机的怪物盒子ID：%d", nID, tbPoints[nRand])
	return tbPoints[nRand]
end

--@function: 交换两个位置的英雄
function KGC_PLAYER_TYPE:SwapHero(heroSrc, heroDst, nPosSrc, nPosDst)
	self:TestPrintHerosOnline();

	local nPosSrc = nPosSrc or 0;
	local nPosDst = nPosDst or 0;
	if not heroSrc and not heroDst then
		cclog("[Error]交换英雄位置的数据错误src(%s), dst(%s)", tostring(heroSrc), tostring(heroDst));
		return;
	end

	if heroSrc then
		nPosSrc = heroSrc:GetPos();
	end
	if heroDst then
		nPosDst = heroDst:GetPos();
	end
	if not gf_IsValidPos(nPosSrc) and not gf_IsValidPos(nPosDst) then
		cclog("[Error]交换位置的英雄位置都无效(%s)<-->(%s)", tostring(nPosSrc), tostring(nPosDst));
		return;
	end
	cclog("交互英雄位置：%d <--> %d", nPosSrc, nPosDst);
	-- 如果本来就在阵上, 不需要执行Insert操作
	if gf_IsValidPos(nPosSrc) and gf_IsValidPos(nPosDst) then
		if heroSrc then
			heroSrc:SetPos(nPosDst);
		end
		if heroDst then
			heroDst:SetPos(nPosSrc);
		end
	else
		local nValidPos = nPosSrc;
		local npc = heroDst;
		if not gf_IsValidPos(nValidPos) then
			nValidPos = nPosDst;
			npc = heroSrc;
		end
		if not gf_IsValidPos(nValidPos) or not npc then
			cclog("[Error]没有有效的位置或者英雄数据错误！");
		else
			self:Insert(nValidPos, npc);
		end
	end

	self:TestPrintHerosOnline();
	-- 同时更换装备位置
	local nEquipSuitSrc = 0;
	if gf_IsValidPos(nPosSrc) then
		nEquipSuitSrc = gf_GetEquipSuitByPos(nPosSrc);
	end
	local nEquipSuitDst = 0;
	if gf_IsValidPos(nPosDst) then
		nEquipSuitDst = gf_GetEquipSuitByPos(nPosDst);
	end
	-- 两个都有效才换装备位置
	if nEquipSuitSrc > 0 and nEquipSuitDst > 0 then
		self:SwapEquipSuit(nEquipSuitSrc, nEquipSuitDst);
	end
end

--@function: 获取队伍战斗力
function KGC_PLAYER_TYPE:GetFightPoint()
	local tbHeros = self:GetHeros();
	local nFP = 0;
	for _, hero in pairs(tbHeros) do
		nFP = nFP + hero:GetFightPoint();
	end
	
	-- 最大战斗力通知服务器
	local nCurMaxFP = self.m_nMaxFP or 0;
	if nFP > nCurMaxFP then
		self.m_nMaxFP = nFP;
		
		local fnCallBack = function(tbArg)
			cclog("[协议返回]最大战斗力:")
		end
		cclog("[协议发送]最大战斗力:maxPower = %s", tostring(nFP));
		local tbReqArg = {};
		tbReqArg.maxPower = nFP;
		g_Core.communicator.loc.setMaxPower(tbReqArg, fnCallBack);
	end
	
	return nFP;
end

--@function: 设置非上阵英雄
function KGC_PLAYER_TYPE:SetAllHeros(tbData)
	print("[log]AddHeroToAll ... 1");
	self:TestPrintHeros();

	local nErr = 0;
	local tbData = tbData or {}
	for heroID, tbHero in pairs(tbData) do
		local ret = self:AddHeroToAll(heroID, tbHero);
		if not ret then
			nErr = nErr + 1;
		end
	end
	
	if nErr > 3 then
		cclog("[Error]英雄数据有错误，数据不正确或者阵上英雄超过3个!");
	end
	print("[log]AddHeroToAll ... 2");
	self:TestPrintHeros();
end

--@function: 增加一个英雄(未上阵)
function KGC_PLAYER_TYPE:AddHeroToAll(heroID, tbData)
	if tbData then
		--在阵上剔除掉
		print("AddHeroToAll", heroID, self:IsOn(heroID))
		if not self:IsOn(heroID) then
			local tbHero = KG_HERO_TYPE.new()
			tbHero:Init(tbData)
			tbHero:SetShip(self);

			self:AddHero(tbHero);
			return tbHero;
		end
	end
end

--@function: 计算套装属性
function KGC_PLAYER_TYPE:CalcSuitAttribute()
	-- print("计算套装属性 ... ")
	local tbHeros = self:GetHeros();
	for _, hero in pairs(tbHeros) do
		local nSuit = hero:GetEquipSuit();
		local nStar = self:GetEquipStars(nSuit);
		hero:CalcSuitAttribute(nStar);
	end
end

--@function: 更加装备索引获取对应英雄
function KGC_PLAYER_TYPE:GetHeroByEquipSuit(nSuit)
	local nPos = gf_GetHeroPosByEquipSuit(nSuit);
	return self:GetHeroByPos(nPos);
end

function KGC_PLAYER_TYPE:GetHeroByPos(nPos)
	local tbHeros = self:GetHeros();
	for _, hero in pairs(tbHeros) do
		if nPos == hero:GetPos() then
			return hero;
		end
	end
end

--@function: 获取战斗需要的玩家数据
--[[
= {
	{},	-- hero1
	{},	-- hero2
	{	-- hero3
		pos =
		id =
		level =
		hp =
		atk =
		defense =
		reducehurt = 			-- 减伤等级
		penetrationlevel = 		-- 穿透等级
		critlevel = 			-- 暴击等级
		tenacitylevel = 		-- 韧性等级
		hitlevel = 				-- 命中等级
		dodgelevel = 			-- 闪避等级

		-- 普通技能
		normalattack = {},
		-- 技能槽技能
		skill = {},
		-- 技能槽等级
		skill_lvl = {}
	}
]]
function KGC_PLAYER_TYPE:GetHerosFightInfo()
	local tbFightInfo = {};
	local tbHeros = self:GetHeros();
	for _, hero in pairs(tbHeros) do
		local tbData = {};
		tbData.pos = hero:GetPos();
		tbData.id = hero:GetID();
		tbData.level = hero:GetLevel();
		tbData.hp = hero:GetHP();
		tbData.atk = hero:GetAttack();
		tbData.defense = hero:GetDefend();
		tbData.reducehurt = hero:GetAL();
		tbData.penetrationlevel = hero:GetPL();
		tbData.critlevel = hero:GetCL();
		tbData.tenacitylevel = hero:GetTL();
		tbData.hitlevel = hero:GetHL();
		tbData.dodgelevel = hero:GetML();

		-- 1. 普通技能
		local tbNormalSkills = hero:GetNormalSkill();
		tbData.normalattack = {};
		for _, skill in pairs(tbNormalSkills) do
			table.insert(tbData.normalattack, skill:GetID());
		end

		-- 2. 技能槽技能
		tbData.skill = {};
		local tbSlotSkills = hero:GetSlotSkillObjs();
		for nCost, tbSkills in pairs(tbSlotSkills or {}) do
			for _, skill in pairs(tbSkills or {}) do
				table.insert(tbData.skill, skill:GetID());
			end
		end

		-- 技能槽
		tbData.skill_lvl = {};
		for i = 1, 6 do
			tbData.skill_lvl[i] = hero:GetSlotLevelByCost();
		end

		table.insert(tbFightInfo, tbData);
	end
	--test
	print("/******************************/");
	print("战斗数据: ");
	tst_print_lua_table(tbFightInfo);
	print("/******************************/");
	--test end

	return tbFightInfo;
end
---------------------------------------------------
-- *** 装备相关 ***

--@function: 交换两个装备的位置, 第x套<-->第y套
--@nSrc: 装备索引
--@nDst: 装备索引
function KGC_PLAYER_TYPE:SwapEquipSuit(nSrc, nDst)
	self:TestPrintEquips();
	cclog("交换装备: %d套 <--> %d套", nSrc, nDst)
	local tbEquips = self:GetEquips();
	local tbSlotSrc = tbEquips[nSrc];
	local tbSlotDst = tbEquips[nDst];
	if tbSlotSrc and tbSlotDst then
		-- 交换
		tbEquips[nSrc], tbEquips[nDst] = tbSlotDst, tbSlotSrc;
		tbSlotSrc:SetIndex(nDst);
		tbSlotDst:SetIndex(nSrc);
	else
		cclog("[Error]有装备不存在(%s)<-->(%s)", tostring(nSrc), tostring(nDst));
	end
	self:TestPrintEquips();
end

--@function: 获取第nSuit套装备同星级
--@nSuit: 第几套装备
function KGC_PLAYER_TYPE:GetEquipStars(nSuit)
	local tbEquips = self:GetEquips();
	local tbData = tbEquips[nSuit]
	local tbSlots = nil;
	if tbData then
		tbSlots = tbData:GetEquips();
	end

	local nStar = nil;
	local nCount = 0;
	if tbSlots then
		for nType, equip in pairs(tbSlots) do
			if not nStar then
				nStar = equip:GetStars();
			end
			if nStar ~= equip:GetStars() then
				nStar = 0;
				break;
			end
			nCount = nCount + 1;
		end
	end
	nStar = nStar or 0;

	-- 需要全身都要有装备
	if nCount < l_tbEquipPos.P_MAX then
		nStar = 0;
	end

	cclog("[log]获取第(%s)套装备的全星级为：%s", tostring(nSuit), tostring(nStar));
	return nStar;
end

--@function：获取第nSuit套装备属性值
--@nSuit: 第几套装备
--@nType: 属性类型
function KGC_PLAYER_TYPE:GetEquipAttributeValue(nSuit, nType)
	local tbEquips = self:GetEquips();
	local tbData = tbEquips[nSuit]
	local tbSlots = nil;
	if tbData then
		tbSlots = tbData:GetEquips();
	end

	local nValue = 0;
	if tbSlots then
		for _, equip in pairs(tbSlots) do
			nValue = nValue + equip:GetAttributeValue(nType);
		end
	end
	-- cclog("[log]第%s套装备增加属性(%s): %s", tostring(nSuit), tostring(nType), tostring(nValue));
	return nValue;
end

--@function：获取第nSuit套装备所有属性值-->为了属性变化显示
--@nSuit: 第几套装备
function KGC_PLAYER_TYPE:GetEquipAllAttributeBySuit(nSuit)
	local tbAttrs = {};
	local tbEquips = self:GetEquips();
	local tbData = tbEquips[nSuit]
	local tbSlots = nil;
	if tbData then
		tbSlots = tbData:GetEquips();
	end

	if tbSlots then
		for _, equip in pairs(tbSlots) do
			local tbTemp = equip:GetAttributeValueTable();
			for nType, nValue in pairs(tbTemp) do
				if not tbAttrs[nType] then
					tbAttrs[nType] = 0;
				end
				if type(nValue) == "number" then
					tbAttrs[nType]  = tbAttrs[nType]  + nValue;
				end
			end
		end
	end
	--test
	-- cclog("[log]第%s装备所有属性为：", tostring(nSuit));
	-- tst_print_lua_table(tbAttrs);
	--test end
	return tbAttrs;
end

--@function：获取两组属性的差值-->为了属性变化显示
--@nSuit: 第几套装备
--@tbAttrA: 新属性；
--@tbAttrB: 旧属性
function KGC_PLAYER_TYPE:GetEquipAttributeDiff(tbAttrA, tbAttrB)
	local tbDiff = {}; -- 格式：{新属性, 旧属性}
	-- A: 新属性
	for nType, nValue in pairs(tbAttrA or {}) do
		if not tbDiff[nType] then
			tbDiff[nType] = {0, 0};
		end
		if type(nValue) == "number" then
			tbDiff[nType][1] = nValue;
		end
	end

	-- B: 旧属性
	for nType, nValue in pairs(tbAttrB or {}) do
		if not tbDiff[nType] then
			tbDiff[nType] = {0, 0};
		end
		if type(nValue) == "number" then
			tbDiff[nType][2] = nValue;
		end
	end

	--test
	-- cclog("[log]两组属性前后变化为：");
	-- tst_print_lua_table(tbDiff);
	--test end

	return tbDiff;
end

---------------------------------------------------
-- *** 提示相关 ***

--@function: 是否可锻造
function KGC_PLAYER_TYPE:IsAbleForge()
    return false;
end

--@function: 是否更新队伍
function KGC_PLAYER_TYPE:IsRemindTeam()
	local tbHeros = self:GetHeros();
	
	for _, hero in pairs(tbHeros or {}) do
		-- 是否提示装备
		print("IsRemindTeam", hero:IsExistNewEquip());
		if hero:IsExistNewEquip() then
			return true;
		end
	end
	
	return false;
end

---------------------------------------------------
-- usage
me =  KGC_PLAYER_TYPE.new()
---------------------------------------------------
--test
--打印上阵英雄信息
function KGC_PLAYER_TYPE:TestPrintHerosOnline()
	local tbHeros = me:GetHeros();
	for _, hero in ipairs(tbHeros) do
		cclog("上阵英雄信息：位置(%d), 名字(%s)", hero:GetPos(), hero:GetName())
	end
end

--打印装备信息
function KGC_PLAYER_TYPE:TestPrintEquips()
	local tbEquips = me:GetEquips();
	for i, tbSlot in pairs(tbEquips) do
		cclog("装备信息：第(%d)套, 总个数(%d)", i, tbSlot:GetEquipsNum())
	end
end
