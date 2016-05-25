----------------------------------------------------------
-- file:	heroskillsublayer.lua
-- Author:	峰猴
-- Time:	long long ago
-- Desc:	技能面板二级界面类
-- Modify:	page@2015/09/12 11:01 星期六(^_^)
----------------------------------------------------------
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/configmanager/configmanager");
local l_tbSublayerType = def_GetHeroSublayerType();

local TB_STRUCT_HERO_SKILL_SUBLAYER={
	heroID,
	pSkillGrooveItem,
	pSkillItem,
	pSkillList,
	m_tbSkillPanel = {},		--技能面板
	
	m_tbBasePos = nil,				-- 技能槽面板参考坐标
	m_nBaseHeight = nil,			-- 技能槽高度
}

KGC_HERO_SKILL_SUBLAYER = class("KGC_HERO_SKILL_SUBLAYER", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_HERO_SKILL_SUBLAYER)

function KGC_HERO_SKILL_SUBLAYER:OnExit()
	self.pSkillGrooveItem:release();
	self.pSkillGrooveItem=nil;
end

function KGC_HERO_SKILL_SUBLAYER:ctor()
	
end

function KGC_HERO_SKILL_SUBLAYER:initAttr(tbArg)
	local tbArg = tbArg or {}
	self.m_hero = tbArg[1]
	
	self:LoadScheme();
	self:UpdateHeroInfo(self.m_hero);
	self:LoadSkills(self.m_hero);
end

--@function: 加载UI文件
function KGC_HERO_SKILL_SUBLAYER:LoadScheme()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_HERO_SKILL_PATH)
    self:addChild(self.pWidget)
    self.pWidget:setContentSize(1,1);
	self.m_pnlMain = self.pWidget:getChildByName("pnl_main");
	
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:closeLayer();
		end
	end
	local btnClose = self.m_pnlMain:getChildByName("btn_close");
	btnClose:addTouchEventListener(fnClose);

    self.pSkillGrooveItem = self.pWidget:getChildByName("Panel_item")
    self.pSkillGrooveItem:removeFromParent();
   	self.pSkillGrooveItem:retain();
	self.pSkillGrooveItem:getPosition();
	local posWorld = self.pSkillGrooveItem:convertToWorldSpace(cc.p(0, 0));
	local size = self.pSkillGrooveItem:getContentSize();
	self.m_nBaseHeight = size.height;

   	self.pSkillList = self.m_pnlMain:getChildByName("Panel_skillList");
	local posRef = self.pSkillList:convertToNodeSpace(posWorld);
	self.m_tbBasePos = posRef;
end

function KGC_HERO_SKILL_SUBLAYER:LoadSkills(hero)
	if not hero then
		return;
	end

	local pAllSkill = hero:GetAllSkillObjs();						-- 所有学会的技能
	local pAllSlotskill = hero:GetSlotSkillObjs();					-- 能放入技能槽的技能
	local skillLvUpconfig = mconfig.loadConfig("script/cfg/skills/skilllevelup")

	local function fnChooseSkill(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			if sender:getChildByName("img_gou"):isVisible() then 
				sender:getChildByName("img_gou"):setVisible(false)
			else
				sender:getChildByName("img_gou"):setVisible(true)
				hero:SwapSlotAt(sender.cost,1,sender.skill);		--设置技能
				self:LoadSkills(self.m_hero);
				
				-- 请求更改技能槽技能
				local tbStruct = hero:GetModifySlotStruct();
				KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqModifySkillSlot(tbStruct);
			end 
        end 
	end

	local function fun_bIsSlot(skillid)
		for i,v in pairs(pAllSlotskill) do
			if skillid == v[1].m_nID then 
				return true;
			end
		end
		return false;
	end

	local function fun_updateSkill(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			local nHeroID = self.m_hero:GetID();
			KGC_HERO_LIST_LOGIC_TYPE:getInstance():ReqUpdateSkillSlot(nHeroID,sender.slotID)
		end
	end

	local function fnSkillTips(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:ShowSkillTips(sender);
		end
	end

	local fOff = self.m_nBaseHeight+15 or 150
	local tbBasePos = self.m_tbBasePos or {x = -29, y = 646};
	-- 6个技能槽
	for i = 1,6 do
		local pSkillGroopInfo = pAllSkill[i];
		local bAbleUse = true
		if not pSkillGroopInfo then 
			bAbleUse = false
		end
		local pGroove = self:getIndexElement(self.pSkillList,i)
		if not pGroove then 
			pGroove = self.pSkillGrooveItem:clone()
			self.pSkillList:addChild(pGroove);
		end
		pGroove.index = i;
		pGroove:setPositionX(tbBasePos.x)
		pGroove:setPositionY(tbBasePos.y - (i-1)*fOff)

		--标签
		local AtlasLabel_lv = pGroove:getChildByName("AtlasLabel_lv");
		AtlasLabel_lv:setString(i);
		--金币
		local lab_gold = pGroove:getChildByName("lab_gold")
		--等级
		local lab_lv = pGroove:getChildByName("lab_lv")
		--升级按钮
		local img_upgrade = pGroove:getChildByName("img_upgrade")
		img_upgrade:addTouchEventListener(fun_updateSkill);
		img_upgrade.slotID = i;

		if bAbleUse then
			local lvUpCfgEle =skillLvUpconfig[i]
			local lv = hero:GetSkillSlotLvByIndex(i)
			local gold = lv*lvUpCfgEle.cost[2]+lvUpCfgEle.cost[1]
			lab_gold:setString(gold);
			lab_lv:setString("LV."..lv);
		else
			lab_gold:setString("0");
			lab_lv:setString("LV.".."0");
		end

		--技能
		if bAbleUse ==true then 
			for j=1,2 do
				local skill = pSkillGroopInfo[j]
				local szItemName = "Panel_skillItem" .. j;
				local skillItem = pGroove:getChildByName(szItemName);
				if skill == nil then
					if skillItem  then 
						skillItem:setScale(0.0001)
						skillItem:setVisible(false);
					end
				else
					if skillItem then 
						skillItem:setScale(1)
						skillItem:setVisible(true);
					end
				end
				
				if skillItem and skill then
					skillItem.index = j;
					local bSlot = fun_bIsSlot(skill.m_nID)

					--选择技能
					local Panel_button = skillItem:getChildByName("Panel_button")
					Panel_button.skill = skill;
					Panel_button.cost = i;
					Panel_button:addTouchEventListener(fnChooseSkill)

					--技能名称
					local lab_name = skillItem:getChildByName("lab_name")
					lab_name:setString(skill.m_szName)

					--触发概率
					local lab_gailv = skillItem:getChildByName("lab_gailv")
					lab_gailv:setString(skill:GetPro() .. "%")

					--图标
					local img_icon = skillItem:getChildByName("img_icon")
					img_icon:loadTexture(skill.m_szIcon)

					if bSlot ==true then 
						Panel_button:getChildByName("img_gou"):setVisible(true)
					else
						Panel_button:getChildByName("img_gou"):setVisible(false)
					end
					
					-- 弹技能tips
					local imgSkill = skillItem:getChildByName("img_bounding");
					imgSkill.skill = skill;
					imgSkill:setTouchEnabled(true);
					imgSkill:addTouchEventListener(fnSkillTips);
				end

			end
		else
			for j=1,2 do
				local szItemName = "Panel_skillItem" .. j;
				local skillItem = pGroove:getChildByName(szItemName);
				if skillItem then 
					skillItem:setScale(0.0001)
					skillItem:setVisible(false);
				end
			end
		end
	end
end

function KGC_HERO_SKILL_SUBLAYER:UpdateHeroInfo(hero)
	if not hero then
		return;
	end
	local imgHeroEye = self.m_pnlMain:getChildByName("img_heroeye");
	local imgTypeBg = imgHeroEye:getChildByName("img_typebg");
	local imgType = imgTypeBg:getChildByName("img_type");
	local svStars = imgHeroEye:getChildByName("sv_star");
	local lblName = imgHeroEye:getChildByName("lbl_heroname");
	
	local nQuality = hero:GetQuality();
	local nStar = hero:GetStars()
	local tbColor, szTypeBg, szHeroBg, szStarBg = hero:GetResourceByQuality(nQuality)
	local r, g, b = unpack(tbColor or {255, 255, 255});
	local szIconS, szIconR, szIconP = hero:GetHeadIcon();
	
	imgTypeBg:loadTexture(szTypeBg);
	imgHeroEye:loadTexture(szIconP);
	self:UpdateStars(svStars, nStar, szStarBg)
	lblName:setString(hero:GetName());
	lblName:setColor(cc.c3b(r,g,b));
end

function KGC_HERO_SKILL_SUBLAYER:UpdateStars(svStars, nStar, szStarBg)
	if svStars and nStar then
		for i = 1, 5 do
			local szName = "img_starbg0" .. i
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

function KGC_HERO_SKILL_SUBLAYER:getIndexElement(pParent,iIndex)
	local pAllChild = pParent:getChildren();
	for i,var in pairs(pAllChild) do
		if var.index == iIndex then 
			return var;
		end
	end
end

--@function: 主界面更新通知二级界面更新
function KGC_HERO_SKILL_SUBLAYER:OnUpdateLayer(nID, tbArg)
	print("OnUpdateLayer ... ", self:GetClassName(), nID, tbArg);
	if nID == l_tbSublayerType.LT_SKILL then
		local hero = (tbArg or {})[1];
		if hero then
			self:LoadSkills(hero);
		else
			cclog("[Warning]KGC_HERO_SKILL_SUBLAYER:OnUpdateLayer, 英雄信息为空(%s)", tostring(tbArg));
		end
	end
end

--@function: 显示技能tips
function KGC_HERO_SKILL_SUBLAYER:ShowSkillTips(widget)
	if not widget then
		return;
	end
	local skill = widget.skill;
	if skill then
		local layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_SKILL_TIPS_PATH)
		self:addChild(layout);
		local fnClose = function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				layout:runAction(cc.RemoveSelf:create())
			end
		end
		layout:addTouchEventListener(fnClose);
		
		-- 解析
		local lblName = layout:getChildByName("lbl_skillname");
		local lblType = layout:getChildByName("lbl_skilltype");
		local lblDesc = layout:getChildByName("lbl_info");
		
		lblName:setString(skill:GetName());
		lblDesc:setString(skill:GetDesc());
	end
end