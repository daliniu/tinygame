----------------------------------------------------------
-- file:	resultsublayer.lua
-- Author:	page
-- Time:	2015/09/22 11:30
-- Desc:	召唤英雄面板二级界面类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")

local TB_STRUCT_SUMMON_RESULT_SUBLAYER={
	m_pLayout = nil,				-- UI界面
	
	m_nHeroID = 0,					-- 召唤的英雄
	
	m_action = nil,					-- 界面动画
}

KGC_HERO_SUMMON_RESULTL_SUBLAYER = class("KGC_HERO_SUMMON_RESULTL_SUBLAYER", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_SUMMON_RESULT_SUBLAYER)

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:OnExit()
	print("KGC_HERO_SUMMON_RESULTL_SUBLAYER:OnExit ... ");
	if self.m_action then
		self.m_action:stop();
	end
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:ctor()
	
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:initAttr(tbArg)
	local tbArg = tbArg or {}
	self.m_nHeroID = tbArg[1]

	if not self.m_nHeroID then
		return;
	end
	self:LoadScheme();
	
	self:CreatEffect();
end

--@function: 加载UI文件
function KGC_HERO_SUMMON_RESULTL_SUBLAYER:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_SUMMON_RESULT_PATH)
    self:addChild(self.m_pLayout)

	local fnOK = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	local btnOK = self.m_pLayout:getChildByName("btn_confirm");
	btnOK:addTouchEventListener(fnOK);
	
	-- 人物面板
	local pnlHeroBg = self.m_pLayout:getChildByName("pnl_herobg");
	pnlHeroBg:setVisible(false);
	local pnlHero = pnlHeroBg:getChildByName("pnl_character");
	local fnTouchHero = function(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:TouchHero(sender);
		end
	end
	pnlHero:addTouchEventListener(fnTouchHero)
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:CreatEffect()
	local pnlHeroBg = self.m_pLayout:getChildByName("pnl_herobg");
	pnlHeroBg:setVisible(false);
	local fnCallBack = function()
		pnlHeroBg:setVisible(true);
		local pnlHero = pnlHeroBg:getChildByName("pnl_character");
		local hero = me:GetHeroByID(self.m_nHeroID);
		if hero then
			self:LoadHero(hero:GetModelID(), pnlHero);
			self:UpdateHero(hero, pnlHeroBg);
		else
			cclog("[Error]没有找到英雄(%s)", tostring(self.m_nHeroID));
		end
		
		-- 二师兄加的烂动画，妈蛋
		self.m_action = ccs.ActionManagerEx:getInstance():playActionByName("ui_hero_summon.json", "summon")
	end
	
	local tbEffectConfig = af_GetEffectModifyInfo(1005) or {};
	local nEffectID, tbPos, nScale = unpack(tbEffectConfig);
	local nLayerID = self.m_pParent:GetLayerID();		-- for 特效
	local effect = af_BindEffect2Node(self.m_pLayout, nEffectID, nil, nScale, fnCallBack, {nil, nil, nLayerID});
	if tbPos then
		effect:setPosition(cc.p(unpack(tbPos)));
	end
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:LoadHero(nID, pnlHero)
	local armature = KGC_MODEL_MANAGER_TYPE:getInstance():CreateNpc(nID);
	print("KGC_HERO_SUMMON_RESULTL_SUBLAYER:LoadHero ... ", armature)
	if pnlHero and armature then
		armature:setName("armature");
		--按比例缩放
		local armSize = armature:getContentSize();
		local pnlHeroSize = pnlHero:getContentSize();
		local rect = armature:getBoundingBox();
		local nScaleX = pnlHeroSize.width/rect.width;
		local scaleY = pnlHeroSize.height/rect.height;
		local nScale = nScaleX
		if scaleY > nScale then
			nScale = scaleY;
		end
		armature:setScale(2);
		pnlHero:addChild(armature, 1)
		armature:setPosition(cc.p(pnlHeroSize.width/2, 0));
	end

	armature:setAnimation(0, 'standby', true)
	return armature;
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:UpdateStars(svStars, nStar, szStarBg)
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

--@function: 更新英雄信息
function KGC_HERO_SUMMON_RESULTL_SUBLAYER:UpdateHero(hero, widget)
	print("KGC_HERO_SUMMON_RESULTL_SUBLAYER:UpdateHero...");
	if not widget or not hero then
		return;
	end
	
	local pnlInfo = widget:getChildByName("pnl_chaname");
	
	local lblName = pnlInfo:getChildByName("lbl_name");				-- 英雄名字
	local svStars = pnlInfo:getChildByName("sv_stars");				-- 英雄星级
	local imgTypeBg = pnlInfo:getChildByName("img_typebg")			-- 英雄类型底框
	local imgType = imgTypeBg:getChildByName("img_type")			-- 英雄类型
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local szType = hero:GetHeroTypeResource();
	local tbColor, szTypeBg, szHeroBg, szStarBg, szTypeBg2 = hero:GetResourceByQuality(nQuality)
	lblName:setString(hero:GetName());
	self:UpdateStars(svStars, nStar, szStarBg)
	imgTypeBg:loadTexture(szTypeBg);
	imgType:loadTexture(szType);
end

function KGC_HERO_SUMMON_RESULTL_SUBLAYER:TouchHero(widget)
	local tbAnimations = KGC_MODEL_MANAGER_TYPE:getInstance():GetAnimation();
	local szAnimation = tbAnimations[math.random(#tbAnimations)]
	
	local arm = widget:getChildByName("armature");
	if arm then
		if arm._is_using then
			return;
		end
		
		-- 标记正在动作
		arm._is_using = true
		
		arm:registerSpineEventHandler(function (event)
			if event.animation == szAnimation then
				arm:setAnimation(0, "standby", true);
				arm._is_using = nil;
			end
		end, sp.EventType.ANIMATION_COMPLETE)
  
		arm:setAnimation(0, szAnimation, false)
	end
end