----------------------------------------------------------
-- file:	class.lua
-- Author:	page
-- Time:	2015/03/23
-- Desc:	契约生物队列 基类
----------------------------------------------------------
require "script/class/class_dp_base"

--struct
local TB_QUEUE_BASE_STRUCT = {
	m_tbElem = {},				--存储结构
}

KGC_QUEUE_BASE_TYPE = class("KGC_QUEUE_BASE_TYPE", KGC_DP_SUBJECT_BASE_TYPE, TB_QUEUE_BASE_STRUCT)

function KGC_QUEUE_BASE_TYPE:ctor()
end

function KGC_QUEUE_BASE_TYPE:IsNull()
	if type(self.m_tbElem) == "table" and #self.m_tbElem > 0 then
		return false;
	end
	
	return true;
end

function KGC_QUEUE_BASE_TYPE:Push(elem)
	if not self.m_tbElem then
		self.m_tbElem = {}
	end
	
	print("契约生物队列当前个数:", #self.m_tbElem, elem)
	table.insert(self.m_tbElem, elem);
	print("push后契约生物队列当前个数:", #self.m_tbElem, elem)
	local tbRet = {}
	
	--结果数据
	local data = KGC_CONSTRACT_QUEUE_RESULT_TYPE.new()
	local nType = data:GetTBType().ADD
	data:Init(nType, self, elem, self:GetSize())
	
	return data;
end

function KGC_QUEUE_BASE_TYPE:Pop()
	--先进先出
	local elem = table.remove(self.m_tbElem, 1)
	
	--结果数据
	local data = KGC_CONSTRACT_QUEUE_RESULT_TYPE.new()
	local nType = data:GetTBType().SUB
	data:Init(nType, self, elem, self:GetSize())
	
	cclog("生物队列，弹出生物：(位置-%d), 名字-%s", elem:GetPos(), elem:GetHeroObj():GetName())
	return elem, data;
end

function KGC_QUEUE_BASE_TYPE:GetSize()
	if not self.m_tbElem then
		self.m_tbElem = {}
	end
	return #self.m_tbElem;
end

function KGC_QUEUE_BASE_TYPE:CondUpdateUI(data, uiWidget, nID)
	print("[Death]死亡通知队列...", nID)
	-- local obj, data = data:GetElem()
	self:PlayEffect(data, uiWidget)
end

function KGC_QUEUE_BASE_TYPE:PlayEffect(data, uiWidget)
	if not data then
		cclog("[Warning]播放契约生物队列特效失败, 结果数据为空")
		return;
	end
	local tbType = data:GetTBType();
	local nType = data:GetType()
	local elem = data:GetElem()
	local size = data:GetSize();
	
	print("PlayEffect, 类型：", nType, elem, size)
	if nType == tbType.ADD then
		--契约生物队列
		local nCamp = elem:GetFightShip():GetCamp();
		local nPos = elem:GetPos()
		cclog("契约生物入队列, 阵营(%s), 位置(%s)", tostring(nCamp), tostring(nPos))
		local pnlHero = uiWidget:GetWidgetHero(nCamp, nPos)
		
		local contractQueue = ccui.Helper:seekWidgetByName(pnlHero, "scv_monsterview")
		for i=1, 3 do
			local szName = "pnl_showmonster" .. i
			local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
			local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
			if i <= size then
				imgMonster:setVisible(true);
			else
				imgMonster:setVisible(false);
			end
		end
		--增加生物的一个动作
		uiWidget:PlayContractEnter(elem)
	elseif nType == tbType.SUB then
		--契约生物队列
		local nCamp = elem:GetFightShip():GetCamp();
		local nPos = elem:GetPos()
		cclog("契约生物出队列, 阵营(%s), 位置(%s)", tostring(nCamp), tostring(nPos))
		uiWidget:UpdateHero(elem)
		
		local pnlHero = uiWidget:GetWidgetHero(nCamp, nPos)
		
		local contractQueue = ccui.Helper:seekWidgetByName(pnlHero, "scv_monsterview")
		for i=1, 3 do
			local szName = "pnl_showmonster" .. i
			local pnlMonster = ccui.Helper:seekWidgetByName(contractQueue, szName)
			local imgMonster = pnlMonster:getChildByName("img_simplemonstericon")
			if i <= size then
				imgMonster:setVisible(true);
			else
				imgMonster:setVisible(false);
			end
		end
	end
end

---------------------------------------------------------------------------------