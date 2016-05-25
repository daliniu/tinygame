----------------------------------------------------------
-- file:	player.lua
-- Author:	page
-- Time:	2014/12/02
-- Desc:	角色的接口文件
----------------------------------------------------------
if not _SERVER then
require "script/core/head"
require "script/core/player/statistics"
require "script/core/email/email"
require "script/core/map/mapinfo"
end

require "script/core/npc/head"
require "script/core/storage/head"
require "script/core/player/data"
require("script/core/configmanager/configmanager");
--------------------------------
--define
--------------------------------
local l_tbLevelUpExp = mconfig.loadConfig("script/cfg/player/experience");

local l_tbUIUpdateType
if not _SERVER then
l_tbUIUpdateType = def_GetUIUpdateTypeData();
end

--data struct
local TB_STRUCT_SHIP = {
	m_szAccount = "",	--账户名
	m_szName = "",		--队伍名字
	m_nID = false,		--队伍ID
	m_tbHeros = {},		--队伍角色(已上阵)
	m_tbAllHeros = {},	--所有角色(是否上阵,是否拥有)
	m_nLv = 1,			--等级
	
	m_nExp = 0,			--队伍经验
	m_nTeamHp = 0,		--团队血量

	m_map		=nil,		--地图信息

	m_email    =nil,		--邮件信息
	
	m_Bag = nil,		--背包信息
	m_KitBag = nil,		--工具箱信息
	m_tbEquips = {		--装备信息
		--[1] = {id, pos, lvl},
	},

	m_tbComboSkills = {},	--组合技能
	
	--临时数据
	m_nTempAddExp = 0;	--增加经验返回
	
	m_Afk = nil,		-- 挂机统计数据
}


KGC_SHIP_BASE_TYPE = class("KGC_SHIP_BASE_TYPE", CLASS_BASE_TYPE, TB_STRUCT_SHIP)

--------------------------------
--function
--------------------------------
function KGC_SHIP_BASE_TYPE:ctor()
end

--[[
tbArg = {
	["lvl"] = 12,
	["diamond"] = 21312,
	["gold"] = 123,
	["vip"] = 23,
	["uuid"]
	["area"]
	["bagList"] = {
		["max"] = 20,
		["item"] = {
			[1] = {
				["id"] = 12312,
				["num"] = 2,
			},
			[2] = {
				["id"] = 123312,
				["num"] = 123,
			},
		},
	},
	["teamList"] = {
		[1] = {
			["id"] = 213,
			["lvl"] = 12,
			["modelid"] = 23234,
			["exp"] = 12341243,
			["pos"] = 0,
			["skill"] = {
				[1] = {
					["id"] = 30001,
					["lvl"] = 1,
					["pos"] = 1,
				},
				[2] = {
					["id"] = 30002,
					["lvl"] = 1,
					["pos"] = 2,
				},
			},
		},
		[2] = {

		},
	},
	["equip"] = {
		[1] = {
			["id"] = 123,
			["pos"] = 2,
			["lvl"] = 12,
		}
	}
}
]]

--init
function KGC_SHIP_BASE_TYPE:init(tbArg)
	self:Clear()
	
	--服务器数据初始化
	if type(tbArg) == "table" then
		self:SetLevel(tbArg.level or 1)
		self:InitHeros(tbArg.teamList);
		self:SetExp(tbArg.curExp)
		self:InitBag(tbArg.bagList)
		self:InitEquips(tbArg.equipList)	-- 初始化装备(在bag之后)
		
if not _SERVER then
		self:InitKitBag(nil);			--工具箱
		self:InitEmail(nil);			--邮件
end
	end
	
	self:OnInit(tbArg);
	print("test: KGC_SHIP_BASE_TYPE:init end.", #self.m_tbHeros)
end

--OnInit
function KGC_SHIP_BASE_TYPE:OnInit(tbArg)
	
end

--@function: 获取在阵上的英雄
--@Notify: 当然也可以直接返回m_tbHeros，主要是我不相信那边的nHeroID是不是有序的
--@修改须知：使用接口的地方会使用ipairs
function KGC_SHIP_BASE_TYPE:GetHeros()
	local tbHeros = {}
	for _, hero in pairs(self.m_tbHeros) do
		table.insert(tbHeros, hero)
	end
	--page@2015/04/16 排序：客户端和服务端顺序不一样
	local fnCompare = function(a, b)
		if a:GetPos() < b:GetPos() then return true; end
	end
	table.sort(tbHeros, fnCompare);
	return tbHeros;
end

--@function: 根据英雄ID获取某个英雄
function KGC_SHIP_BASE_TYPE:GetHeroByID(nID)
	if not nID then
		return;
	end
	local nID = tonumber(nID);
	local tbHeros = self:GetAllHeros();
	for _, hero in ipairs(tbHeros) do
		-- print("GetHeroByID: ", nID, hero:GetID(), nID == hero:GetID())
		if hero:GetID() == nID then
			return hero;
		end
	end
	cclog("[Warning]根据ID(%s)没有找到英雄", tostring(nID));
end

--@function: 增加一个英雄, 检测是否已经有了
function KGC_SHIP_BASE_TYPE:AddHero(heroNew)
	if not heroNew then
		cclog("[Error]英雄对象为nil@AddHero");
		return;
	end
	local tbAllHeros = self:GetAllHeros();
	local bIsExit = false;
	for _, hero in pairs(tbAllHeros) do
		if hero:GetID() == heroNew:GetID() then
			bIsExit = true;
			break;
		end
	end
	if not bIsExit then
		table.insert(self.m_tbAllHeros, heroNew);
		cclog("[Log]增加一个英雄：ID(%d), 名字(%s), 阵上(%s), 总数(%d)", heroNew:GetID(), heroNew:GetName(), tostring(heroNew:IsOn()), #self.m_tbAllHeros);
	else
		cclog("[Warning]该英雄已经存在(%s)", heroNew:GetID());
	end
end

function KGC_SHIP_BASE_TYPE:GetAllHeros()
	-- print("GetAllHeros, 所有英雄个数：", #(self.m_tbAllHeros or {}))
	if not self.m_tbAllHeros then
		self.m_tbAllHeros = {};
	end
	return self.m_tbAllHeros;
end

--???question:！！！重要:退出登录的数据清除
function KGC_SHIP_BASE_TYPE:uninit()
end

function KGC_SHIP_BASE_TYPE:GetMaxHP()

	local nHP = 0;
	for _, hero in pairs(self.m_tbHeros) do
		if hero:IsHero() then
			nHP = nHP + hero:GetHP()
		end
	end
	return nHP;
end

-- function KGC_SHIP_BASE_TYPE:GetCost()
	-- return self.m_nCost;
-- end

-- function KGC_SHIP_BASE_TYPE:UpdateCost()
	-- local nCost = 0;
	-- for _, v in pairs(self.m_tbHeros) do
		-- if v:IsHero() and v:GetCost() > nCost then
			-- nCost = v:GetCost();
		-- end
	-- end
	-- self.m_nCost = nCost;
-- end

function KGC_SHIP_BASE_TYPE:Clear()
	self.m_tbHeros = {}
end

--@function: 插入一个英雄到上阵table中, 同时保证合体技能处理
function KGC_SHIP_BASE_TYPE:Insert(nPos, npc)
	local old = nil
	for _, hero in pairs(self.m_tbHeros) do
		if hero:GetPos() == nPos then
			if hero and hero ~= npc then
				hero:OnHeroRemove()
			end
			old = hero;
			break;
		end
	end
	-- 从表中删除
	if old then
		for index, hero in pairs(self.m_tbHeros) do
			if hero:GetID() == old:GetID() then
				table.remove(self.m_tbHeros, index);
				break;
			end
		end
	end
	
	npc:SetPos(nPos)
	table.insert(self.m_tbHeros, npc)
	npc:OnHeroInsert();
end

--@function: 根据上阵位置获取英雄对象
function KGC_SHIP_BASE_TYPE:GetNpcByPos(nPos)
	local tbNpcs = self:GetHeros()
	local target = nil;
	if not gf_IsValidPos(nPos) then
		cclog("[Error]位置无效!@GetNpcByPos(%s)", tostring(nPos));
		return target;
	end
	for _, npc in pairs(tbNpcs) do
		if npc:GetPos() == nPos then
			target = npc;
			break;
		end
	end
	
	return target;
end

--@notice: partner包括释放者本身
function KGC_SHIP_BASE_TYPE:IsPartnerIn(tbPartner)
	print("[log]合体技能-判断是否有合作伙伴 ... ");
	tbPartner = tbPartner or {}
	local heros = self:GetHeros();
	local tbHash = {}
	for _, hero in pairs(heros) do
		local id = hero:GetID()

		tbHash[id] = true;
	end
	local bRet = true;
	for _, id in pairs(tbPartner) do
		print("id: ", id)
		if not tbHash[id] then
			bRet = false;
			break;
		end
	end
	print("结果：", bRet);
	return bRet;
end

function KGC_SHIP_BASE_TYPE:AddPartnerSkill(tbPartner, skill)
	tbPartner = tbPartner or {}
	local heros = self:GetHeros();
	local tbHash = {}
	for _, hero in pairs(heros) do
		local id = hero:GetID()
		tbHash[id] = hero;
	end

	for _, id in pairs(tbPartner) do
		local hero = tbHash[id]
		if hero then
			hero:AddComboSkill(skill)
		end
	end
end

function KGC_SHIP_BASE_TYPE:RemovePartnerSkill(tbPartner, skill)
	tbPartner = tbPartner or {}
	local heros = self:GetHeros();
	local tbHash = {}
	for _, hero in pairs(heros) do
		local id = hero:GetID()
		tbHash[id] = hero;
	end

	for _, id in pairs(tbPartner) do
		local hero = tbHash[id]
		if hero then
			hero:RemoveComboSkill(skill)
		end
	end
end

function KGC_SHIP_BASE_TYPE:CreateNpc()
	local npc = KG_HERO_TYPE.new();
	return npc;
end

--@function: 初始化英雄信息
function KGC_SHIP_BASE_TYPE:InitHeros(tbHeros)
	print("InitHeros ... ")
	local nIndex = 1;
	if type(tbHeros) == "table" then
		for nHeroID, tbData in pairs(tbHeros) do
			local tbHero = self:CreateNpc();
			tbHero:Init(tbData)
			tbHero:SetShip(self);
			local nPos = tbHero:GetPos()
			if gf_IsValidPos(nPos) then
				self:Insert(nPos, tbHero)
			end
			
			-- tbHero:SetID(nIndex)
			-- nIndex = nIndex + 1;
			--all heros
			-- table.insert(self.m_tbAllHeros, tbHero);
			self:AddHero(tbHero);
		end
	end
end

--@function: 初始化背包
function KGC_SHIP_BASE_TYPE:InitBag(tbBag)
	--创建空的背包
	self.m_Bag = KGC_BAG_TYPE.new();
	
	if type(tbBag) ~= "table" then
		cclog("[Error]背包信息错误！@InitBag")
		return;
	end
	
	self.m_Bag:Init(tbBag.max, tbBag.itemList, tbBag.equipList)
end

--@function：初始化装在身上的装备
function KGC_SHIP_BASE_TYPE:InitEquips(tbEquips)
	if not tbEquips then
		return;
	end
	
	-- 数据清空
	for k, v in pairs(self.m_tbEquips) do
		if v then
			v:ClearData();
		end
	end
	self.m_tbEquips = {};
	
	-- print("[Log]KGC_SHIP_BASE_TYPE:InitEquips ... ")
	-- 注：这里只有3套装备, 即为对应的索引
	for nSuit = 1, 3 do
		-- 服务器js传过来的是字符串，服务端传进来的参数还是数值
		local tbEquip = tbEquips[tostring(nSuit)] or tbEquips[nSuit];
		local equipSlot = KGC_PLAYER_EQUIP_SLOT_TYPE.new(nSuit, self);
		equipSlot:SetIndex(nSuit);
		
		if tbEquip then
			for nIndex, tbInfo in pairs(tbEquip) do
				local nID = tbInfo.id;
				local equip = self:AddEquip(nIndex, tbInfo);
				
				-- cclog("[Log]装备信息: 第%d套, 索引(%d), 装备ID(%d)", nSuit, nIndex, nID)
				-- 如果道具增加成功才可以(保证不会同一件装备在不同位置)
				if equip then
					local nDetail = equip:GetTypeDetail();
					equipSlot:SwapEquip(nDetail, equip, nil)
				end
			end
		end
		
		self.m_tbEquips[nSuit] = equipSlot;
		--test
		-- cclog("InitEquips: 第%d套装备结束 ... (%s)", nSuit, tostring(equipSlot))
		-- self.m_Bag:TestPrintStorage();
		--test end
	end
end

function KGC_SHIP_BASE_TYPE:InitKitBag(tbBag)
	self.m_KitBag = KGC_BAG_TYPE.new();
	
	if type(tbBag) ~= "table" then
		cclog("[Error]工具箱信息错误！@InitBag")
		return;
	end
	
	self.m_KitBag:Init(tbBag.max, tbBag.item)	
end

function KGC_SHIP_BASE_TYPE:InitAfkStatistics()
	self.m_Afk = KGC_AFK_STATISTICS_BASE_TYPE.new();
end

function KGC_SHIP_BASE_TYPE:GetBag()
	return self.m_Bag;
end

function KGC_SHIP_BASE_TYPE:GetKitBag()
	return self.m_KitBag;
end

function KGC_SHIP_BASE_TYPE:GetEquips()
	return self.m_tbEquips;
end

--@function: 设置帐号名
function KGC_SHIP_BASE_TYPE:SetAccount(szAccount)
	self.m_szAccount = szAccount or "";
end

function KGC_SHIP_BASE_TYPE:GetAccount()
	return self.m_szAccount;
end

--@function: 设置等级
function KGC_SHIP_BASE_TYPE:SetLevel(nLevel)
	self.m_nLv = nLevel or 0;
end

function KGC_SHIP_BASE_TYPE:GetLevel()
	return self.m_nLv;
end

function KGC_SHIP_BASE_TYPE:AddLevel(nLevel)
	if type(nLevel) ~= "number" then
		cclog("[Error]参数类型不正确！@AddLevel")
		return;
	end
	if nLevel == 0 then
		return;
	end
	self:SetLevel(self:GetLevel() + nLevel)
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_UPGRADE, nLevel);
end

--@function: 给英雄增加经验
function KGC_SHIP_BASE_TYPE:AddHeroExp(tbPlayer, nExp)
	if type(nExp) ~= "number" then
		cclog("[Error]参数类型不正确！@AddHeroExp")
		return;
	end
	
	local tbHeros = self:GetHeros();
	local tbHash = {}
	for _, hero in ipairs(tbHeros) do
		-- hero:AddExp(tbPlayer, nExp)
		tbHash[hero:GetID()] = hero;
	end
	for heroID, tbHero in pairs(tbPlayer.teamList) do
		local hero = tbHash[tonumber(heroID)]
		if hero then
			hero:AddExp(tbHero, nExp);
		end
	end
end

--@function: 增加一个装备
--@nID: 道具ID(配置表)
--@nIndex: 索引(道具唯一索引, 服务器生成返回)
--@tbAttrs: 附加属性
--@nStar: 星级
function KGC_SHIP_BASE_TYPE:AddEquip(nIndex, tbEquip)
	local bag = self:GetBag()
	local equip = bag:AddItem(nIndex, tbEquip)
	return equip;
end

--@function：获取队伍经验
function KGC_SHIP_BASE_TYPE:GetExp()
	return self.m_nExp;
end

function KGC_SHIP_BASE_TYPE:SetExp(nExp)
	self.m_nExp = nExp or 0;
end

--@function：增加经验
function KGC_SHIP_BASE_TYPE:AddExp(nExp)
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
end

--@function: 向服务器请求增加经验
function KGC_SHIP_BASE_TYPE:ReqAddExp(nExp)
	local fnCallBack = function(tbArg)
		print("[协议返回]增加经验")
		tst_print_lua_table(tbArg);
		local tbPlayer = tbArg.playerInfo;
		local tbHero = tbArg.heroInfo;
		self:OnAddExp(tbPlayer, tbHero);

		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY);
		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG);
	end
	local tbArgReq = {};
	tbArgReq.heroId = 0;
	tbArgReq.expPlayer = nExp;
	tbArgReq.exp = nExp;
	print("[协议发送]增加经验");
	tst_print_lua_table(tbArgReq);
	g_Core.communicator.loc.upgradeHeroLevel(tbArgReq, fnCallBack);
end

function KGC_SHIP_BASE_TYPE:OnAddExp(tbPlayer, tbHero, nExp)
	if not tbPlayer and not tbHero then
		cclog("[Error]参数为空！@AddExp")
		return;
	end
	
	local nTempExp = self.m_nTempAddExp;
	if nExp then
		nTempExp = nExp;
	end
	if tbPlayer.curExp then					--增加player经验和阵上英雄经验
		local nCur = self:GetExp();
		
		--升级
		local nLevelUpExp = self:GetLevelUpExp();
		local nTotalExp = nCur + nTempExp
		while(nTotalExp >= nLevelUpExp) do
			self:AddLevel(1)
			nTotalExp = nTotalExp - nLevelUpExp;

			nLevelUpExp = self:GetLevelUpExp();
		end
		self:SetExp(nTotalExp)
		-----------------------------
		--和服务器数据校验
		local nLevelS = tbPlayer.level; 
		local nExpS = tbPlayer.curExp;
		
		if self:GetLevel() ~= nLevelS or self:GetExp() ~= nExpS then
			cclog("[Error]加经验player客户端和服务器数据不一致！等级(%d<->%d), 经验(%d<->%d)", self:GetLevel(), nLevelS, self:GetExp(), nExpS)
			self:SetExp(nExpS)
			self:SetLevel(nLevelS)
		else
			cclog("[Log]加经验验证通过!")
		end
		-----------------------------
		--增加队伍经验
		self:AddHeroExp(tbPlayer, nTempExp)
	elseif tbHero.curExp then					--增加指定英雄经验
		cclog("给指定英雄增加经验(%d)", nTempExp);
		tst_print_lua_table(tbHero);
		local tbHeros = self:GetHeros();
		local tbHash = {}
		for _, hero in ipairs(tbHeros) do
			tbHash[hero:GetID()] = hero;
		end
		
		local hero = tbHash[tonumber(tbHero.heroId)]
		if hero then
			hero:AddExp(tbHero, nTempExp);
		end
	end
end

function KGC_SHIP_BASE_TYPE:GetLevelUpExp()
	local nCurLevel = self:GetLevel();
	local nMaxExp = 10000;
	local nNeedExp = nMaxExp;
	-- 配置表experience配置的等级对应的经验即为升级的经验
	if l_tbLevelUpExp[nCurLevel] then
		nNeedExp = l_tbLevelUpExp[nCurLevel].experience or nMaxExp;
	else
		cclog("[Warning]配置表experience没有等级(%d)的配置", nCurLevel +1);
	end
	
	-- local nExp = math.pow((self:GetLevel() + 8), 3) * 2;
	print("GetLevelUpExp", self:GetLevel(), nNeedExp)
	return nNeedExp;
end

--@function: 根据英雄模版ID判断是否在阵上
function KGC_SHIP_BASE_TYPE:IsOn(nModID)
	if not nModID then
		return false;
	end
	local tbHeros = self:GetHeros()
	for _, hero in pairs(tbHeros) do
		-- print("IsOn", nModID, hero:GetID(), hero:GetID() == nModID)
		if hero:GetID() == tonumber(nModID) then
			return true;
		end
	end
	return false;
end

--初始化地图
function KGC_SHIP_BASE_TYPE:InitMap()
	if self.m_map == nil then 
		self.m_map= KGC_MAP_INFO_CLASS:create();
	end
	self.m_map:InitDate();
end

--获取地图信息
function KGC_SHIP_BASE_TYPE:GetMapInfo()
	return self.m_map;
end


--获取地图buffer信息
function KGC_SHIP_BASE_TYPE:getMapBuffList()
	return self.m_map:GetBufferList();
end

function KGC_SHIP_BASE_TYPE:SetMapBuffList(buffTab)
	return self.m_map:InitBuffDate(buffTab);
end

--初始化邮件
function KGC_SHIP_BASE_TYPE:InitEmail(data)
	if self.m_email == nil then 
		self.m_email = KGC_EMAIL_INFO_CLASS:create();
	end
	self.m_email:initDate(data);
end

--@function：获取第nSuit套装备属性值
--@nSuit: 第几套装备
--@nType: 属性类型
function KGC_SHIP_BASE_TYPE:GetEquipAttributeValue(nSuit, nType)
	return 0;
end
---------------------------------------------------
--test
function KGC_SHIP_BASE_TYPE:TestPrintPlayerData()
	print("...print player data...")
	-- tst_print_lua_table(self)
	for k, v in pairs(self) do
		if type(v) == "table" then
			for k1, v1 in pairs(v) do
				print("\t", k1, v1)
			end
		else
			print(k, v)
		end
	end
	print("...print player data end...")
end

function KGC_SHIP_BASE_TYPE:TestCreateItems()
	for i = 1, 5 do
		-- self:AddItem(10101, 1)
	end
	
	-- self:AddItem(17901, 5)
	-- self:AddItem(17902, 4)
	-- self:AddItem(17903, 3)
	-- self:AddItem(17904, 2)
	-- self:AddItem(17905, 1)
end

function KGC_SHIP_BASE_TYPE:TestPrintHeros()
	local tbHeros = self:GetHeros();
	local tbAllHeros = self:GetAllHeros();
	cclog("上阵英雄个数(%d)/(%d)全部英雄个数：", #tbHeros,  #tbAllHeros);
end
