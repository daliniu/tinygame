----------------------------------------------------------
-- file:	herolistlogic.lua
-- Author:	page
-- Time:	2015/09/07
-- Desc:	英雄列表界面逻辑类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_logic")
require("script/ui/heroinfoview/herolistlayer")

local l_tbUIUpdateType = def_GetUIUpdateTypeData();
local l_tbSublayerType = def_GetHeroSublayerType();
local cjson = require("cjson.core")

local TB_STRUCT_HERO_LIST_LOGIC ={
    m_pLayer=nil,
    m_pLogic=nil,
}

KGC_HERO_LIST_LOGIC_TYPE = class("KGC_HERO_LIST_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_HERO_LIST_LOGIC)

function KGC_HERO_LIST_LOGIC_TYPE:getInstance()
    if not KGC_HERO_LIST_LOGIC_TYPE.m_pLogic then
        KGC_HERO_LIST_LOGIC_TYPE.m_pLogic = KGC_HERO_LIST_LOGIC_TYPE.new()
        KGC_HERO_LIST_LOGIC_TYPE.m_pLogic:initAttr()
    end
    return KGC_HERO_LIST_LOGIC_TYPE.m_pLogic;
end

function KGC_HERO_LIST_LOGIC_TYPE:initAttr()

end


function KGC_HERO_LIST_LOGIC_TYPE:initLayer(parent,id)
    if self.m_pLayer then
        return
    end
    self.m_pLayer = KGC_HERO_LIST_LAYER_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id;
    parent:addChild(self.m_pLayer)
	
	-- 设置主界面底部按钮底框可见
	KGC_MainViewLogic:getInstance():ShowMenuBg();
	MapViewLogic:getInstance():ShowMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(true);
end

function KGC_HERO_LIST_LOGIC_TYPE:closeLayer()
    if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil;
	end
	
	-- 设置主界面底部按钮底框不可见
	KGC_MainViewLogic:getInstance():HideMenuBg();
	MapViewLogic:getInstance():HideMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(false);
end

--@function: 向服务器请求英雄布阵
--@nHeroID: 要换上的英雄ID(可以是阵上或者未上阵英雄)
--@nDstPos: 要换到的阵上位置
function KGC_HERO_LIST_LOGIC_TYPE:ReqHeroLineup(nHeroID, nDstPos, tbWidgets)
	local fnCall = function(tbArg)
		local nRet = tbArg.isOk or 0;
		print("[协议接收]英雄布阵返回结果...", nRet)
		self:OnRspHeroLineup(nRet, tbWidgets);
	end
	
	local tbArgReq = {};
	tbArgReq.posDst = nDstPos;
	tbArgReq.heroId = nHeroID;
	cclog("[协议发送]请求英雄布阵：heroId(%s), posDst(%s)", tostring(nHeroID), tostring(nDstPos));
	g_Core.communicator.loc.makeHeroLineup(tbArgReq, fnCall);
end

--@function:服务器回调英雄布阵结果
function KGC_HERO_LIST_LOGIC_TYPE:OnRspHeroLineup(nRet, tbWidgets)
	local nRet = tonumber(nRet or 0);
	if nRet == 1 then
		if self.m_pLayer then
			-- 1: 布阵界面;
			self.m_pLayer:UpdateSubLayer(l_tbSublayerType.LT_LINEUP, tbWidgets);
			
			-- 主界面也需要更新
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_ARMATURE);
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY);
		end
	else
		TipsViewLogic:getInstance():addMessageTips(12201);
	end
end

--@function: 向服务器请求英雄升星
--@nDstPos: 要换到的阵上位置
--@nStar: 当前星级
function KGC_HERO_LIST_LOGIC_TYPE:ReqHeroUpStar(nHeroID)
	local fnCall = function(tbArg)
		local tbHeroInfo = tbArg.heroInfo;
		print("[协议接收]英雄升星返回结果...", tbHeroInfo)
		tst_print_lua_table(tbArg);
		
		-- 客户端数据处理
		KGC_HERO_FACTORY_TYPE:getInstance():ProcessStarResult(tbHeroInfo);
		if self.m_pLayer then
			-- 2：升星更新
			self.m_pLayer:UpdateSubLayer(l_tbSublayerType.LT_STAR);
		end
		
		-- 更新背包
		GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG);
	end
	
	local tbArgReq = {};
	tbArgReq.heroId = nHeroID;
	cclog("[协议发送]请求英雄升星：heroId(%s)", tostring(nHeroID));
	g_Core.communicator.loc.upgradeHeroStar(tbArgReq, fnCall);
end

--@function: 向服务器请求英雄升品
--@nDstPos: 要换到的阵上位置
function KGC_HERO_LIST_LOGIC_TYPE:ReqHeroUpQuality(nHeroID)
	local fnCall = function(tbArg)
		local tbHeroInfo = tbArg.heroInfo;
		print("[协议接收]英雄升品返回结果...", tbHeroInfo)
		tst_print_lua_table(tbArg);
		
		-- 客户端数据处理
		KGC_HERO_FACTORY_TYPE:getInstance():ProcessQualityResult(tbHeroInfo);
		if self.m_pLayer then
			-- 2：升品更新
			self.m_pLayer:UpdateSubLayer(l_tbSublayerType.LT_QUALITY);
		end
	end
	
	local tbArgReq = {};
	tbArgReq.heroId = nHeroID;
	cclog("[协议发送]请求英雄升品：heroId(%s)", tostring(nHeroID));
	g_Core.communicator.loc.upgradeHeroQuality(tbArgReq, fnCall);
end

--@function: 向服务器请求洗练套装属性
function KGC_HERO_LIST_LOGIC_TYPE:ReqRefreshSuitAttribute(nHeroID, tbLock)
	local fnCall = function(tbArg)
		local tbHeroInfo = tbArg.heroInfo;
		print("[协议接收]英雄套装属性洗练返回结果...", tbHeroInfo)
		tst_print_lua_table(tbArg);
		
		-- 客户端数据处理
		KGC_HERO_FACTORY_TYPE:getInstance():ProcessRefreshResult(tbHeroInfo);
		if self.m_pLayer then
			self.m_pLayer:UpdateSubLayer(l_tbSublayerType.LT_REFRESH);
		end
	end
	
	local tbLock = tbLock or {};
	local tbArgReq = {};
	tbArgReq.heroId = nHeroID or 0;
	tbArgReq.lock1 = tbLock[1] or 0;
	tbArgReq.lock2 = tbLock[2] or 0;
	tbArgReq.lock3 = tbLock[3] or 0;
	tbArgReq.lock4 = tbLock[4] or 0;
	tbArgReq.lock5 = tbLock[5] or 0;
	
	local szLogLock = tbArgReq.lock1 .. "-" .. tbArgReq.lock2 .. "-" .. tbArgReq.lock3 .. "-" .. tbArgReq.lock4 .. "-" .. tbArgReq.lock5
	cclog("[协议发送]请求英雄套装属性洗练：heroId(%s), lock(%s)", tostring(nHeroID), szLogLock);
	g_Core.communicator.loc.washHero(tbArgReq, fnCall);
end

--@function: 更换装备服务器返回
function KGC_HERO_LIST_LOGIC_TYPE:OnRspChangeEquicpCallBack()
	if self.m_pLayer then
		self.m_pLayer:UpdateHeros();
	end
end
--------------------------------------------------------------------------------------
--@function:设置当前英雄
function KGC_HERO_LIST_LOGIC_TYPE:SetCurHero(nModID)
	self.currentHeroID = nModID;
end

--获取玩家所有英雄
function KGC_HERO_LIST_LOGIC_TYPE:getAllHeroes()
    -- return HeroControl:getInstance():getAllHeroes()
	return me:GetAllHeros();
end

--获取指定的英雄
function KGC_HERO_LIST_LOGIC_TYPE:getHeroInfo(id)
    return HeroControl:getInstance():getHeroInfo(id)
end

--装备技能
function KGC_HERO_LIST_LOGIC_TYPE:equipSkill(heroID,skillID)
    HeroControl:getInstance():equipSkill(heroID,skillID)
end


--获取指定阶段的技能
function KGC_HERO_LIST_LOGIC_TYPE:getHeroAllSkillWithStage(heroID,index)
    return HeroControl:getInstance():getHeroAllSkillWithStage(heroID,index)
end


--获取指定费率的技能
function KGC_HERO_LIST_LOGIC_TYPE:getHeroCurrentSkillWithExpend(heroID,index)
    return HeroControl:getInstance():getHeroCurrentSkillWithExpend(heroID,index)

end

--获取指定基恩的信息
function KGC_HERO_LIST_LOGIC_TYPE:getSkillInfo(id)
    return SkillConfigure:getInstance():getSkillInfo(id)
end

--取消英雄的某一技能
function KGC_HERO_LIST_LOGIC_TYPE:cancleHeroSkill(heroID,skillID)
    -- body
    HeroControl:getInstance():cancleSkill(heroID,skillID)
end

--获取英雄所有技能 
function KGC_HERO_LIST_LOGIC_TYPE:getHeroAllSkill(heroID)
    -- return HeroControl:getInstance():getHeroAllSkill(heroID);
	local hero = me:GetHeroByID(heroID)
	return hero:GetAllSkillObjs();
end

--@function: 保存装备界面保存的装备信息
--@nSlot: 当前装备部位
--@hero：当前装备的英雄, 和sSlot可以计算当前的装备是什么
--@selectedequip: 选中的装备索引
--@equipNew: 新装备
function KGC_HERO_LIST_LOGIC_TYPE:SetEquipChangeTempData(nSlot, hero, nIndex, equipNew)
	KGC_EQUIP_LOGIC_TYPE:getInstance():SetEquipChangeTempData(nSlot, hero, nIndex, equipNew)
end




--@function: 请求升级技能槽
function KGC_HERO_LIST_LOGIC_TYPE:ReqUpdateSkillSlot(heroid,slotID)
    -- g_Core:send(5007,{["heroId"]=heroid,["slotId"]=slotID});
	local fnCallBack = function(tbArg)
		local tbHeroInfo = tbArg.heroInfo;
		local nHeroID = tbHeroInfo.heroId;
		local tbSkillSlotInfo = tbHeroInfo.skillSlotList;
		cclog("[协议接收]升级技能槽返回：heroId(%s)", tostring(tbHeroInfo.heroId));
		self:OnRspUpdateSkillSlot(nHeroID, tbSkillSlotInfo);
	end
	
	local tbArgReq = {};
	tbArgReq.heroId = heroid;
	tbArgReq.slotId = slotID;
	cclog("[协议发送]请求升级技能槽：heroId(%s), slotId(%s)", tostring(heroid), tostring(slotID));
	g_Core.communicator.loc.upgradeSkillSlot(tbArgReq, fnCallBack);
end

--@function: 请求升级技能槽返回
function KGC_HERO_LIST_LOGIC_TYPE:OnRspUpdateSkillSlot(nHeroID, tbSkillSlotInfo)
    local hero = me:GetHeroByID(nHeroID)

    hero:InitSKillSlot(tbSkillSlotInfo);

    if self.m_pLayer then 
        self.m_pLayer:UpdateSubLayer(l_tbSublayerType.LT_SKILL, {hero});
    end
end