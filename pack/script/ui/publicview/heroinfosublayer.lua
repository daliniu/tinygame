----------------------------------------------------------
-- file:	heroinfosublayer.lua
-- Author:	page
-- Time:	2015/09/07 10:42 
-- Desc:	英雄信息二级界面类
-- Modify	(1)Page@2015/09/14 17:42 --> 多个地方调用这个界面,故移动到此
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/ui/herolistview/heroskillsublayer")
require("script/ui/herolistview/hero_reinforce_sublayer")

local TB_STRUCT_HERO_INFO_SUBLAYER={
	m_pLayout = nil,				-- 主界面
	
	m_pnlMain = nil,				-- 所有控件在这上面
	m_heroObj = 0,					-- 英雄

	m_reinforceLayer =nil,

	m_skillLayer =nil,				--技能信息
}

KGC_HERO_INFO_SUBLAYER_TYPE = class("KGC_HERO_INFO_SUBLAYER_TYPE", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_HERO_INFO_SUBLAYER)

function KGC_HERO_INFO_SUBLAYER_TYPE:ctor()

end

--@function: 重载KGC_UI_BASE_SUB_LAYER:initAttr
function KGC_HERO_INFO_SUBLAYER_TYPE:initAttr(tbArg)
	local tbArg = tbArg or {}
	local hero = tbArg[1]
	if not hero then
		return;
	end
	self.m_heroObj = hero;
	self:LoadScheme();
	
	self:UpdateBaseInfo(hero)
end

function KGC_HERO_INFO_SUBLAYER_TYPE:OnExit()

end

--@function: 加载界面
function KGC_HERO_INFO_SUBLAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_INFO_PATH)
	self:addChild(self.m_pLayout)
	
	self.m_pnlMain = self.m_pLayout:getChildByName("pnl_main")
	--关闭按钮
    local function fnClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:closeLayer()
        end
    end
	local btnClose = self.m_pnlMain:getChildByName("btn_close")
	btnClose:addTouchEventListener(fnClose)
	
	local svHeroInfo = self.m_pnlMain:getChildByName("sv_heroinfo")
	local imgBaseInfo = svHeroInfo:getChildByName("img_basicinfobg")	
	local btnQuality = imgBaseInfo:getChildByName("btn_quality");
	local btnStar = imgBaseInfo:getChildByName("btn_breakthrow");
	 local function fnTouchEventButton(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if sender == btnQuality then
				self:TouchEventQuality(sender);
			elseif sender == btnStar then
				self:TouchEventStar(sender);
			end
        end
    end
	btnQuality:addTouchEventListener(fnTouchEventButton);
	btnStar:addTouchEventListener(fnTouchEventButton);
end

function KGC_HERO_INFO_SUBLAYER_TYPE:UpdateBaseInfo(hero)
	local svHeroInfo = self.m_pnlMain:getChildByName("sv_heroinfo")
	local imgHeroEye = self.m_pnlMain:getChildByName("img_heroeye")
	
	-- 第一部分：英雄类型、星级、名字
	local imgTypeBg = imgHeroEye:getChildByName("img_typebg")		-- 英雄类型背景图(品质相关)
	local imgType = imgTypeBg:getChildByName("img_type")			-- 英雄类型图
	local svStars = imgHeroEye:getChildByName("sv_star")			-- 英雄星级
	local lblName = imgHeroEye:getChildByName("lbl_heroname")		-- 英雄名字
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	print("UpdateBaseInfo, nQuality, nStar", nQuality, nStar)
	local tbColor, szTypeBg, szHeroBg, szStarBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	
	imgHeroEye:loadTexture(szIconP);
	imgTypeBg:loadTexture(szTypeBg);
	self:UpdateStars(svStars, nStar, szStarBg)
	lblName:setString(hero:GetName())
	lblName:setColor(cc.c3b(r, g, b))
	
	-- 第二部分：战斗数据的数值类
	local imgBaseInfo = svHeroInfo:getChildByName("img_basicinfobg")		
	local bmpLevel = imgBaseInfo:getChildByName("bmp_level")				-- 等级
	local bmpExp = imgBaseInfo:getChildByName("bmp_exp")					-- 经验
	local bmpHP = imgBaseInfo:getChildByName("bmp_health")					-- 生命
	local bmpCrit = imgBaseInfo:getChildByName("bmp_critical")				-- 暴击
	local bmpAttack = imgBaseInfo:getChildByName("bmp_attack")				-- 攻击
	local bmpTenacity = imgBaseInfo:getChildByName("bmp_tenacity")			-- 韧性
	local bmpDefend = imgBaseInfo:getChildByName("bmp_defend")				-- 防御
	local bmpMiss = imgBaseInfo:getChildByName("bmp_miss")					-- 闪避
	local bmpPenetration = imgBaseInfo:getChildByName("bmp_throw")			-- 穿透
	local bmpHit = imgBaseInfo:getChildByName("bmp_hit")					-- 命中
	bmpLevel:setString(hero:GetLevel())
	local szCurExp = hero:GetExp();
	local szNextExp = hero:GetLevelUpExp();
	bmpExp:setString(szCurExp .. "/" .. szNextExp);
	bmpHP:setString(hero:GetHP());
	bmpCrit:setString(hero:GetCL());
	bmpAttack:setString(hero:GetAttack());
	bmpTenacity:setString(hero:GetTL());
	bmpDefend:setString(hero:GetDefend());
	bmpMiss:setString(hero:GetML());
	bmpPenetration:setString(hero:GetPL());
	bmpHit:setString(hero:GetHL())
	
	-- 第三部分：技能(技能槽中的技能)
	local imgSkillBg = svHeroInfo:getChildByName("img_skillinfobg")
	local tbSkills = hero:GetSlotSkillObjs();
	self:UpdateSkills(imgSkillBg, tbSkills);
end

function KGC_HERO_INFO_SUBLAYER_TYPE:UpdateStars(svStars, nStar, szStarBg)
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_starbg_" .. i
			local imgStarEmpty = svStars:getChildByName(szName)
			imgStarEmpty:setVisible(true);
			if szStarBg then
				imgStarEmpty:loadTexture(szStarBg)
			end
			local imgStarFull = imgStarEmpty:getChildByName("img_star")
			if i <= nStar then
				imgStarFull:setVisible(true);
			else
				imgStarFull:setVisible(false);
			end
		end
	end
end

function KGC_HERO_INFO_SUBLAYER_TYPE:UpdateSkills(imgSkillBg, tbSkills)
	if not imgSkillBg then
		return;
	end
	
	local fnSkill = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.m_skillLayer = KGC_HERO_SKILL_SUBLAYER:create(self.m_pParent, {self.m_heroObj});
			-- self:closeLayer();
		end
	end
	
	-- 重组一下技能
	local tbTemp = {}
	for nCost, tbSkill in pairs(tbSkills or {}) do
		for _, skill in pairs(tbSkill or {}) do
			table.insert(tbTemp, skill);
		end
	end
	
	-- 底板也可以点击
	imgSkillBg:setTouchEnabled(true);
	imgSkillBg:addTouchEventListener(fnSkill);
	
	for i = 1, 6 do
		local szPnlName = "pnl_skill" .. i;
		local pnlSkill = imgSkillBg:getChildByName(szPnlName);
		local skill = tbTemp[i];
		if skill then
			pnlSkill:setVisible(true);
			local imgIcon = pnlSkill:getChildByName("img_skillicon");
			local lblName = pnlSkill:getChildByName("lbl_skillname");
			local lblType = pnlSkill:getChildByName("lbl_skilltype");
			imgIcon:loadTexture(skill:GetIcon());
			lblName:setString(skill:GetName());
			lblType:setString(skill:GetTypeName());
		else
			pnlSkill:setVisible(false);
		end
		pnlSkill:addTouchEventListener(fnSkill);
	end
end

--@function: 升品
function KGC_HERO_INFO_SUBLAYER_TYPE:TouchEventQuality(widget)
	self.m_reinforceLayer = KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:create(self.m_pParent, {self.m_heroObj});
	self.m_reinforceLayer:ChangePage(1);
end

--@function: 突破(升星)
function KGC_HERO_INFO_SUBLAYER_TYPE:TouchEventStar(widget)
	self.m_reinforceLayer = KGC_UI_HERO_REINFORCE_SUBLAYER_TYPE:create(self.m_pParent, {self.m_heroObj});
	self.m_reinforceLayer:ChangePage(2);
end

--@function: 主界面更新通知二级界面更新
function KGC_HERO_INFO_SUBLAYER_TYPE:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	self:UpdateBaseInfo(self.m_heroObj)
end