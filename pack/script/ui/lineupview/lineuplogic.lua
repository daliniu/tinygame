----------------------------------------------------------
-- file:	lineuplogic.lua
-- Author:	page
-- Time:	2016/01/12
-- Desc:	布阵界面逻辑类
----------------------------------------------------------
require("script/class/class_base_ui/class_base_logic")
require("script/ui/lineupview/fight_lineuplayer")
local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local TB_STRUCT_LINEUP_LOGIC ={

}

KGC_LINEUP_LOGIC_TYPE = class("KGC_LINEUP_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_LINEUP_LOGIC)

function KGC_LINEUP_LOGIC_TYPE:getInstance()
    if not KGC_LINEUP_LOGIC_TYPE.m_pLogic then
        KGC_LINEUP_LOGIC_TYPE.m_pLogic = KGC_LINEUP_LOGIC_TYPE.new()
        KGC_LINEUP_LOGIC_TYPE.m_pLogic:initAttr()
		GameSceneManager:getInstance():insertLogic(KGC_LINEUP_LOGIC_TYPE.m_pLogic)
    end
    return KGC_LINEUP_LOGIC_TYPE.m_pLogic;
end

function KGC_LINEUP_LOGIC_TYPE:initAttr()

end

--@function
--@usage：传入回调函数，点布阵界面的开战调用这个回调函数
--[[
local fnCallBack = function()
	-- do something ...
end
GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP, {fnCallBack});
]]
function KGC_LINEUP_LOGIC_TYPE:initLayer(parent,id, tbArg)
    if self.m_pLayer then
        return
    end

	if tbArg then
		self.m_pLayer = KGC_FIGHT_LINEUP_LAYER_TYPE.new()
	else
		self.m_pLayer = KGC_LINEUP_LAYER_TYPE.new()
	end
	self.m_pLayer:Init(tbArg);
	
    self.m_pLayer.id = id;
    parent:addChild(self.m_pLayer)
end

function KGC_LINEUP_LOGIC_TYPE:closeLayer()
    if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil;
	end
end

function KGC_LINEUP_LOGIC_TYPE:OnUpdateLayer(iType, tbArg)
	local tbArg = tbArg or {}
	if self.m_pLayer then
		if iType == l_tbUIUpdateType.EU_AFKERREWARD then
			if self.m_pLayer.m_pMainBtnLayer then
				local nPercent = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:SetRewardProgress(0, nPercent);
			end
		elseif iType == l_tbUIUpdateType.EU_SEARCH then
			if self.m_pLayer.m_pMainBtnLayer then
				local nSearchT = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:StartSearch(nSearchT);
			end
		elseif iType == l_tbUIUpdateType.EU_FIGHTHP then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local nSelfHp = (tbArg or {})[1] or 0;
	            local nEnemyHp = (tbArg or {})[2] or 0;
	            self.m_pLayer.m_pMainBtnLayer:SetFightHp(nSelfHp, nEnemyHp);
	        end
	    elseif iType == l_tbUIUpdateType.EU_FIGHTRESULT then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local bWin = (tbArg or {})[1] or false;
	            local tReward = (tbArg or {})[2] or {};
	            self.m_pLayer.m_pMainBtnLayer:SetResult(bWin, tReward);
	        end
		end
	end
end

--@function: 向服务器请求英雄布阵
--@nHeroID: 要换上的英雄ID(可以是阵上或者未上阵英雄)
--@nDstPos: 要换到的阵上位置
function KGC_LINEUP_LOGIC_TYPE:ReqHeroLineup(nHeroID, nDstPos, tbWidgets)
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
function KGC_LINEUP_LOGIC_TYPE:OnRspHeroLineup(nRet, tbWidgets)
	local nRet = tonumber(nRet or 0);
	if nRet == 1 then
		if self.m_pLayer then
			-- 1: 布阵界面;
			self.m_pLayer:UpdateLineup(tbWidgets);
			
			-- 主界面也需要更新
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_ARMATURE);
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY);
			GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_LINEUP);
		end
	else
		TipsViewLogic:getInstance():addMessageTips(12201);
	end
end