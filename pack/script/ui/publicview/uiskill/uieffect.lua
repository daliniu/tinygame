----------------------------------------------------------
-- file:	uieffect.lua
-- Author:	page
-- Time:	2015/05/20 (5.20-->qm ^_^)
-- Desc:	读取技能表现部分的配置表类
--			
----------------------------------------------------------
local l_tbConfigShow = require("script/cfg/client/skillshowout")
--data struct
local TB_SKILL_UI_SHOW_BASE_DATA = {
	m_Skill = nil,					--所属技能
	
	m_tbMovs = {					--动作
		szLau,							--攻击者动作
		szDef,							--被攻击者动作
		
	},
	m_szLauMov,					--攻击者动作
	m_tbDefMov = {				--被攻击者动作
		szMov = "",					--动作名字
		nType = 0,					--动作开始参数类型
		nArg = 0,					--动作开始参数数值
	},
	
	m_tbEffects = {				--特效
		[1] = {
			nID = 0,				--特效ID
			tbInfo = {				--特效数据
				szPath = "",			--路径
				szArmature = "",		--动画资源
				szAnimation = "",		--动画名字
			},			
			nScale = 1,				--特效缩放
			nRotation = 0,			--旋转角度
			nTimes = 0,				--播放次数
			nInterval = 0,			--重复间隔时间(ms)
			nStartType = 0,			--起始参数
			nStartArg = 0,			--起始数值
			nPosType = 0,			--特效位置类型(1-己方;2-敌方;3-屏幕正中)
			szBone = "",			--特效绑定骨骼
		},
		[2] = {
			nID = 0,				--特效ID
			tbInfo = {				--特效数据
				szPath = "",			--路径
				szArmature = "",		--动画资源
				szAnimation = "",		--动画名字
			},
			nScale = 1,				--特效缩放
			nRotation = 0,			--旋转角度
			nTimes = 0,				--播放次数
			nInterval = 0,			--重复间隔时间(ms)
			nStartType = 0,			--起始参数
			nStartArg = 0,			--起始数值
			nPosType = 0,			--特效位置类型(1-己方;2-敌方;3-屏幕正中)
			szBone = "",			--特效绑定骨骼
		},
	},
}

KGC_SKILL_UI_SHOW_BASE_TYPE = class("KGC_SKILL_UI_SHOW_BASE_TYPE", CLASS_BASE_TYPE, TB_SKILL_UI_SHOW_BASE_DATA)
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_UI_SHOW_BASE_TYPE:ctor(skill)
	self.m_Skill = skill;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:Init(nID)
	local tbInfo = l_tbConfigShow[nID]
	-- print("Init@KGC_SKILL_UI_SHOW_BASE_TYPE", nID, tbInfo)
	if tbInfo then
		self:SetLauncherMoveData(tbInfo.selfmove);
		self:SetDefendMoveData(tbInfo.targetmove, tbInfo.howtmovestar, tbInfo.tmovedate);
		self:SetEffectData(1, tbInfo.effectid1, tbInfo.eff1_re, tbInfo.eff1_betweentime, tbInfo.eff1_start, tbInfo.eff1_date, tbInfo.eff1_onwho, tbInfo.eff1_onwhere, tbInfo.eff1_scale)
		self:SetEffectData(2, tbInfo.effectid2, tbInfo.eff2_re, tbInfo.eff2_betweentime, tbInfo.eff2_start, tbInfo.eff2_date, tbInfo.eff2_onwho, tbInfo.eff2_onwhere, tbInfo.eff2_scale)
	end
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetSkill()
	return self.m_Skill;
end

--@function: 设置攻击者动作
function KGC_SKILL_UI_SHOW_BASE_TYPE:SetLauncherMoveData(szMov)
	if not szMov or szMov == 0 then
		szMov = "";
	end
	self.m_szLauMov = szMov or "";
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetLauncherMoveData()
	return self.m_szLauMov;
end

--@function: 设置被攻击者动作
function KGC_SKILL_UI_SHOW_BASE_TYPE:SetDefendMoveData(szMov, nType, nArg)
	local tbData = self:GetDefendMoveData();
	
	local szMov = szMov or "";
	if szMov == 0 then
		szMov = "";
	end
	
	tbData.szMov = szMov or "";
	tbData.nType = nType or 0;
	tbData.nArg = nArg or 0;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetDefendMoveData()
	if not self.m_tbDefMov then
		self.m_tbDefMov = {};
	end
	return self.m_tbDefMov;
end

--@function: 设置特效数据
--@参数看最上面m_tbEffects中的注释
function KGC_SKILL_UI_SHOW_BASE_TYPE:SetEffectData(nIndex, nID, nTimes, nInterval, nStartType, nStartArg, nPosType, szBone, nScale)
	local nIndex = nIndex or 0;
	local tbEffect = self:CreateAEffect(nID, nTimes, nInterval, nStartType, nStartArg, nPosType, szBone, nScale);
	local tbEffects = self:GetEffectData()
	tbEffects[nIndex] = tbEffect;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:CreateAEffect(nID, nTimes, nInterval, nStartType, nStartArg, nPosType, szBone, nScale)
	local tbEffect = {};
	tbEffect.nID = nID or 0;
	tbEffect.nTimes = nTimes or 1;
	tbEffect.nInterval = nInterval or 0;
	tbEffect.nStartType = nStartType or 0;
	tbEffect.nStartArg = nStartArg or 0;
	tbEffect.nPosType = nPosType or 0;
	tbEffect.szBone = szBone or "";
	tbEffect.nScale = nScale or 1;
	
	--读取特效配置表
	local tbConfig = require("script/cfg/client/effect")
	--test: 只读配置表里面的表元素是不是也是只读的：NO！
	-- if tbConfig[nID] then
		-- tbConfig[nID].effectid = 40002
	-- end
	--test end
	local tbInfo = tbConfig[nID]
	if tbInfo then
		if not tbEffect.tbInfo then
			tbEffect.tbInfo = {};
		end
		tbEffect.tbInfo.szPath = tbInfo.effectpath
		tbEffect.tbInfo.szArmature = tbInfo.armature
		tbEffect.tbInfo.szAnimation = tbInfo.mov
	end
	
	return tbEffect;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectData()
	if not self.m_tbEffects then
		self.m_tbEffects = {};
	end
	
	return self.m_tbEffects;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectByIndex(nIndex)
	local nIndex = nIndex or 0;
	local tbEffects = self:GetEffectData()
	return tbEffects[nIndex]
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectIDByIndex(nIndex)
	local tbEffect = self:GetEffectByIndex(nIndex) or {}
	return tbEffect.nID;
end

--@function: 获取播放动画所需要的三个参数
function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectInfoAt(nIndex)
	local tbEffect = self:GetEffectByIndex(nIndex)
	local szPath, szArmature, szAnimation = nil, nil, nil
	if tbEffect then
		local tbInfo = tbEffect.tbInfo;
		szPath = tbInfo.szPath;
		szArmature = tbInfo.szArmature;
		szAnimation = tbInfo.szAnimation;
	end
	return szPath, szArmature, szAnimation;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectBone(nIndex)
	local tbEffect = self:GetEffectByIndex(nIndex) or {}
	return tbEffect.szBone;
end

function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectScale(nIndex)
	local tbEffect = self:GetEffectByIndex(nIndex) or {}
	return tbEffect.nScale;
end

--@function: 获取特效放置的类型
function KGC_SKILL_UI_SHOW_BASE_TYPE:GetEffectPosType(nIndex)
	local tbEffect = self:GetEffectByIndex(nIndex) or {}
	return tbEffect.nPosType;
end

--@function: 骨骼动画特效
function KGC_SKILL_UI_SHOW_BASE_TYPE:GetPlayEffect(nIndex, fnCallBack)
	local nIndex = nIndex or 1;
	local szFileName, szArmature, szAnimation = self:GetEffectInfoAt(nIndex)
	print("GetPlayEffect", nIndex, szFileName, szArmature, szAnimation)
	--!!!question:一开始就加上去
	--test
	print("addArmatureFileInfo @ GetPlayEffect");
	--test end
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(szFileName)
	local armature = ccs.Armature:create(szArmature)
	
	local nScale = armature:getScale()
	local function fnAnimationEvent(armatureBack,movementType,movementID)
		if movementType == ccs.MovementEventType.complete then
			if movementID == szAnimation then
				if fnCallBack then
					fnCallBack();
				end
				armature:setVisible(false);
				armature:getAnimation():stop();
				armature:removeFromParent(true)
			end
		end
	end
	if armature then
		armature:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
		armature:getAnimation():play(szAnimation, -1, 0);
	end
	return armature;
end