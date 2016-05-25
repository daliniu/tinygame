----------------------------------------------------------
-- file:	rewardlogic.lua
-- Author:	page
-- Time:	2015/08/29 14:51
-- Desc:	通关奖励界面逻辑管理类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_logic")
require("script/ui/rewardview/rewardlayer")
require("script/ui/rewardview/reward_custom_layer")

local l_tbRewardLayerType = {
	RLT_PASS = 1,			-- 通关奖励界面
	RLT_CUSTOM = 2,			-- 通用奖励界面
	RLT_MAX = 3,
}

local TB_STRUCT_REWARD_LAYER_LOGIC = {
	m_pLogic = nil,
	m_tbLayers = {},
}

KGC_REWARD_LAYER_LOGIC_TYPE=class("KGC_REWARD_LAYER_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_REWARD_LAYER_LOGIC)


function KGC_REWARD_LAYER_LOGIC_TYPE:getInstance()
	if not KGC_REWARD_LAYER_LOGIC_TYPE.m_pLogic then
        KGC_REWARD_LAYER_LOGIC_TYPE.m_pLogic = KGC_REWARD_LAYER_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_REWARD_LAYER_LOGIC_TYPE.m_pLogic)
	end
	return KGC_REWARD_LAYER_LOGIC_TYPE.m_pLogic
end

function KGC_REWARD_LAYER_LOGIC_TYPE:create()
    local _logic = KGC_REWARD_LAYER_LOGIC_TYPE.new()
    return _logic
end

--@function: 打开界面方式
--[[
@tbArgs = {
	[1] = nType,			-- 不同的奖励界面类型
	[2] = tbData,		-- 传给界面的参数
}

@eg:
(1)打开通用奖励界面(类型2)
* 参数类型如下
GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_REWARD, {2, {tbCurrency, tbItems}});
*local tbCurrency = {}
tbCurrency["gold"] = nGold;
tbCurrency["heroexp"] = nExp;
tbCurrency["teamexp"] = nExpTeam;
tbCurrency["ap"] = nAP;
* tbItems
]]
function KGC_REWARD_LAYER_LOGIC_TYPE:initLayer(parent,id, tbArgs)
	local nType, tbData = unpack(tbArgs or {});
	local tbLayers = self:GetAllLayers();
    if tbLayers[nType] then
    	return;
    end

	local layer = nil;
	if nType == l_tbRewardLayerType.RLT_PASS then
		layer = KGC_REWARD_LAYER_TYPE.new()
	else
		layer = KGC_UI_REWARD_CUSTOM_LAYER_TYPE.new();
	end
	if not layer then
		return;
	end
	tbLayers[nType] = layer;
	layer:Init(tbData);
	layer.id = id
	parent:addChild(layer)
end

function KGC_REWARD_LAYER_LOGIC_TYPE:closeLayer(nType)
	local tbLayers = self:GetAllLayers();
	if tbLayers[nType] then
		GameSceneManager:getInstance():removeLayer(tbLayers[nType].id);
		tbLayers[nType] = nil
	end
end

function KGC_REWARD_LAYER_LOGIC_TYPE:GetAllLayers()
	if not self.m_tbLayers then
		self.m_tbLayers = {};
	end
	return self.m_tbLayers;
end