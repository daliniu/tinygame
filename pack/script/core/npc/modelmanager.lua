----------------------------------------------------------
-- file:	modelmanager.lua
-- Author:	page
-- Time:	2015/07/23 11:47
-- Desc:	模型加载统一
----------------------------------------------------------
require("script/core/configmanager/configmanager");
local l_tbNpcModels = mconfig.loadConfig("script/cfg/client/model")

--data struct 
local TB_STRUCT_MODEL_MANAGER = {
	m_Instance = nil;
	
	m_tbModelArmatures = {},			-- 骨骼缓存
	m_nSize = 0;
}
--------------------------------)
KGC_MODEL_MANAGER_TYPE = class("KGC_MODEL_MANAGER_TYPE", CLASS_BASE_TYPE, TB_STRUCT_MODEL_MANAGER)
--------------------------------
--function
--------------------------------

function KGC_MODEL_MANAGER_TYPE:ctor()	
	
end
--------------------------------------------------------------
function KGC_MODEL_MANAGER_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_MODEL_MANAGER_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end

function KGC_MODEL_MANAGER_TYPE:Init()

end

--@function: 更加模版ID创建NPC的骨骼动画
--@nModelID: 模版ID, 参考配置表model
function KGC_MODEL_MANAGER_TYPE:CreateNpc(nModelID)
	print("KGC_MODEL_MANAGER_TYPE:CreateHero ", nModelID)

	if not nModelID then
		return nil;
	end
	
	local armature = nil;

	local szJson, szAtlas = l_tbNpcModels[nModelID].json, l_tbNpcModels[nModelID].atlas
	print("szJson, szAtlas", szJson, szAtlas)
	
	local armModel = self:GetArmatureByModeID(nModelID)
	if not armModel then
		armature = sp.SkeletonAnimation:create(szJson, szAtlas, 1)
		armature:retain();	-- 缓存：非常重要！
		self:AddModelArmature(nModelID, armature)
		armModel = armature;
	end
	armature = sp.SkeletonAnimation:createWithData(armModel);

	armature:update(0);
	local rect = armature:getBoundingBox();
	
	return armature;
end

--@function: 保存加载的spine骨骼动画，只加载一次，加载太慢
function KGC_MODEL_MANAGER_TYPE:GetModelArmatures()
	if not self.m_tbModelArmatures then
		self.m_tbModelArmatures = {};
	end
	
	return self.m_tbModelArmatures;
end

--@function: 
function KGC_MODEL_MANAGER_TYPE:AddModelArmature(nNpcID, armature)
	if not nNpcID or not armature then
		return;
	end
	
	local tbArmatures = self:GetModelArmatures();
	if not tbArmatures[nNpcID] then
		self.m_nSize = self.m_nSize + 1;
		print("增加骨骼，总个数为：", self.m_nSize)
	end
	tbArmatures[nNpcID] = armature;
end

--@function: 根据模版ID获取骨骼动画
function KGC_MODEL_MANAGER_TYPE:GetArmatureByModeID(nNpcID)
	local tbArmatures = self:GetModelArmatures();
	return tbArmatures[nNpcID]
end

--@function: 获取可播放的动画
function KGC_MODEL_MANAGER_TYPE:GetAnimation(nModelID)
	local tbAnimations = {"attack", "attack01", "summon"};
	return tbAnimations;
end

--@function: 是否播放出场动画"appear"
function KGC_MODEL_MANAGER_TYPE:IsAppear(nModelID)
	local tbConfig = l_tbNpcModels[nModelID]
	if tbConfig then
		return (1 == tbConfig.ifappear), tbConfig.appeareffect;
	end
	
	return false;
end
----------------------------------------------------------
--test