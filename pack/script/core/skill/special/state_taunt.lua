----------------------------------------------------------
-- file:	state_base.lua
-- Author:	page
-- Time:	2015/03/19 16:58
-- Desc:	嘲讽状态特效
----------------------------------------------------------
require "script/core/skill/special/state_base"

local l_tbCondID = def_GetConditionData();

--data struct
local TB_STATE_TAUNT_STRUCT = {
	m_tbCondID = {l_tbCondID.ROUND_END},
}

KGC_STATE_TAUNT_TYPE = class("KGC_STATE_TAUNT_TYPE", KGC_STATE_BASE_TYPE, TB_STATE_TAUNT_STRUCT)

function KGC_STATE_TAUNT_TYPE:ctor()
	--从配置表读取相关信息
	self.m_tbCondID = {l_tbCondID.HIT, }
	self.m_nID = self.m_tbID.TAUNT;
	self.m_szName = self.m_tbName[self.m_nID]
	self.m_nRound = 1;							--当前回合算第一回合
	--test
	self.m_nMaxRound = 3;
	--test end
end

function KGC_STATE_TAUNT_TYPE:CondUpdate(obj, id)
	print("回合结束，条件ID为：", id, l_tbCondID.ROUND_END)
	if id == l_tbCondID.ROUND_END then
		local bRet, data =  self:AddRound()
		return {bRet, data}
	end
end

function KGC_STATE_TAUNT_TYPE:IsTaunt()
	return true;
end

--ui
function KGC_STATE_TAUNT_TYPE:OnCondUpdateUI(arg, widget, id)
	--播放自己的特效
	
	
	--队列特效
	local queue = self:GetQueue()
	if queue then
		queue:UIUpdate(arg)
	end
end