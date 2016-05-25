----------------------------------------------------------
-- file:	class.lua
-- Author:	page
-- Time:	2015/03/25 15:49
-- Desc:	状态队列 基类
----------------------------------------------------------
require "script/class/class_dp_base"
require "script/class/class_data_base"

--struct
local TB_STATE_QUEUE_BASE_STRUCT = {
	m_tbElem = {},				--存储结构
	m_Npc = nil,				--所属对象
	--config
	m_nMaxSize = 6,				--队列存储大小
	
	--ui
	m_UIList = nil,				--UI用到的ListView对象
	m_UIPanel = nil,			--状态控件
	m_UIImgStateL = nil,		--小于三个状态时候的底图显示
	m_UIImgStateH = nil,		--多于三个状态时候的底图显示
	m_UIScvState = nil,			--所有状态
	
	m_tbUIStates = {},			--UI表现要用到的状态
	m_nCurIndex = 0,			--当前显示的状态索引在tbUIStates
	m_bVisble = 0,				--UI显示状态(0, 默认; 1, 全部)
}

KGC_STATE_QUEUE_BASE_TYPE = class("KGC_STATE_QUEUE_BASE_TYPE", KGC_DP_SUBJECT_BASE_TYPE, TB_STATE_QUEUE_BASE_STRUCT)

local g_nTestStateIndex = 0;
function KGC_STATE_QUEUE_BASE_TYPE:ctor()
	--test
	self.m_nTestIndex = g_nTestStateIndex
	g_nTestStateIndex = g_nTestStateIndex + 1
	-- print("状态队列 ctor ... 自身唯一索引: ", self.m_nTestIndex)
	
end

function KGC_STATE_QUEUE_BASE_TYPE:IsNull()
	if type(self.m_tbElem) == "table" and #self.m_tbElem > 0 then
		return false;
	end
	
	return true;
end

function KGC_STATE_QUEUE_BASE_TYPE:GetByID(nID)
	local tbRet = {};
	cclog("[State-Queue]获取同一ID的所有状态@GetByID: 状态ID(%d);自身唯一索引(%d);所属npc位置(%d);池子大小(%d)", nID, self.m_nTestIndex, self:GetNpc():GetPos(),#self.m_tbElem)
	--notify:ipairs
	for _, elem in ipairs(self.m_tbElem) do
		print("[State-Queue]", nID, elem:GetID())
		if elem:GetID() == nID then
			table.insert(tbRet, elem)
		end
	end
	
	return tbRet;
end

function KGC_STATE_QUEUE_BASE_TYPE:Replace(elem)
	local bRet, data = false, nil
	if elem then
		local nIndex = self:Find(elem:GetID())
		self.m_tbElem[nIndex] = elem;
		bRet = true;
		
		--替换成功，设置状态所属队列
		elem:SetQueue(self)
		
		--结果数据
		data = KGC_STATE_QUEUE_RESULT_TYPE.new()
		local nType = data:GetTBType().REP;
		data:Init(nType, self, elem, bRet)
	else
		cclog("[Warning]替换内容为空@KGC_STATE_QUEUE_BASE_TYPE:Replace")
	end

	local szErr = string.format("要替换的状态ID(%s)不存在", tostring(nID));
	return false, data, szErr
end

function KGC_STATE_QUEUE_BASE_TYPE:Push(elem)
	if not self.m_tbElem then
		self.m_tbElem = {}
	end
	local bRet = false;
	local size = self:GetSize()
	if size < self.m_nMaxSize then
		self:Insert(elem)
		bRet = true;
	else
		local old = nil;
		--notify:ipairs
		for k, v in ipairs(self.m_tbElem) do
			if v:IsCanReplace() then
				old = v;
			end
		end
		if old then
			self:Pop()
			self:Insert(elem)
			bRet = true;
			cclog("[State-Queue]替换老的状态！")
		else
			cclog("[State-Queue]队列所有状态都不可以替换！")
		end
	end
	
	--结果数据
	local data = KGC_STATE_QUEUE_RESULT_TYPE.new()
	local nType = data:GetTBType().ADD;
	data:Init(nType, self, elem, bRet)
	
	return bRet, data;
end

function KGC_STATE_QUEUE_BASE_TYPE:Pop()
	--先进先出
	local elem, data = self:Remove()

	-- local tbRet = {self, {2, elem, self:GetSize()}}
	return elem, data;
end

function KGC_STATE_QUEUE_BASE_TYPE:Insert(elem)
	table.insert(self.m_tbElem, elem);
	elem:SetQueue(self)
	cclog("[State-Queue]插入队列成功(新的大小：%d)", self:GetSize())
end

function KGC_STATE_QUEUE_BASE_TYPE:Find(nID)
	--notify:ipairs
	for index, elem in ipairs(self.m_tbElem) do
		if elem:GetID() == nID then
			return index, elem;
		end
	end
	
	cclog("[Warning]队列中没有找到ID(%s)的状态!@Find", tostring(nID))
	return nil;
end

function KGC_STATE_QUEUE_BASE_TYPE:Remove(nIndex)
	nIndex = nIndex or 1;
	local elem = table.remove(self.m_tbElem, nIndex)
	if not elem then
		return false, nil;
	end
	cclog("[State-Queue]移除状态(%s)队列成功(新的大小：%d)", elem:GetName(), self:GetSize())
	
	--结果数据
	local data = KGC_STATE_QUEUE_RESULT_TYPE.new()
	local nType = data:GetTBType().SUB;
	data:Init(nType, self, elem, nIndex)
	
	return true, data;
end

function KGC_STATE_QUEUE_BASE_TYPE:GetSize()
	if not self.m_tbElem then
		self.m_tbElem = {}
	end
	return #self.m_tbElem;
end

function KGC_STATE_QUEUE_BASE_TYPE:SetNpc(npc)
	self.m_Npc = npc;
	-- print("state setnpc 所属npc位置:", npc:GetPos())
end

function KGC_STATE_QUEUE_BASE_TYPE:GetNpc()
	return self.m_Npc;
end

function KGC_STATE_QUEUE_BASE_TYPE:GetAll()
	return self.m_tbElem;
end

-------UI-------

function KGC_STATE_QUEUE_BASE_TYPE:UIInit(panel, fightview)
	self.m_UIPanel = panel;
	self.m_FightView = fightview;
	
	self:Clear()
	if panel then
		-- self.m_UIImgStateL = panel:getChildByName("img_statebg_low")
		-- self.m_UIImgStateH = panel:getChildByName("img_statebg_high")
		self.m_UIImgState = panel:getChildByName("img_statebg")
		self.m_UIScvState = panel:getChildByName("scrollview_stateinfo")
	end
	
	local pnlState = ccui.Helper:seekWidgetByName(self.m_UIPanel, "pnl_normal_state")
	--test
	self.m_tbTestIcon = {
		[60001] = "res/ui/temp/states/state_14.jpg",
		[60002] = "res/ui/temp/states/state_08.jpg",
		[60003] = "res/ui/temp/states/state_17.jpg",
		[60004] = "res/ui/temp/states/state_04.jpg",
		[60005] = "res/ui/temp/states/state_35.jpg",
		[60006] = "res/ui/temp/states/state_39.jpg",
	}
	--test end
end

function KGC_STATE_QUEUE_BASE_TYPE:UIUnInit()
	self:Clear()
	
	self.m_UIList = nil;
	self.m_UIListElem = nil;
	self.m_UIPanel = nil;
	
	-- print("UIUnInit ... ", self.m_SchedulerUpdate)
	if self.m_SchedulerUpdate then
		local scheduler = cc.Director:getInstance():getScheduler()
		scheduler:unscheduleScriptEntry(self.m_SchedulerUpdate)
	end
	
	--所有队列取消订阅
	-- print("取消订阅，英雄位置：", self:GetNpc():GetPos())
	for _, v in pairs(self.m_tbUIStates) do
		-- print("state", v:GetName())
		v:Disappear();
		v:UIRemoveEffect();
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:UIUpdate(state, data)
	local nType = data:GetType()
	local l_tbType = data:GetTBType()
	print("英雄位置：", self:GetNpc():GetPos())
	if nType == l_tbType.ADD then
		print("队列增加一个图标")
		self:UIInsert(state)
	elseif nType == l_tbType.SUB then
		local nIndex = data:GetData() or 0;
		cclog("队列移出索引为(%d)的图标", nIndex)
		self:UIRemove(nIndex)
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:Clear()
	if self.m_UIList then
		self.m_UIList:removeAllItems();
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:SetFlag(nFlag)
	self.m_nFlag = nFlag or 0;
end

function KGC_STATE_QUEUE_BASE_TYPE:GetFlag()
	return self.m_nFlag;
end

function KGC_STATE_QUEUE_BASE_TYPE:UIInsert(state)
	print("UIInsert ... ")
	local list = self.m_UIList;
	
	local tbTestIcon = self.m_tbTestIcon;
		
	if state then
		if not self.m_tbUIStates then
			self.m_tbUIStates = {};
		end
		
		table.insert(self.m_tbUIStates, state);
		--第一次插入的时候调用定时器函数
		if #self.m_tbUIStates == 1 then
			-- local fnUpdate = function()
					-- if self.m_nCurIndex > #self.m_tbUIStates or self.m_nCurIndex <= 0 then
						-- self.m_nCurIndex = 1;
					-- end
					-- local state = self.m_tbUIStates[self.m_nCurIndex]
					-- if state then
						-- local pnlState = ccui.Helper:seekWidgetByName(self.m_UIPanel, "pnl_normal_state")
						-- local imgIcon = ccui.Helper:seekWidgetByName(pnlState, "img_state")
						-- local szImage = tbTestIcon[state:GetID()]
						-- print("UIInsert", self.m_UIPanel, imgIcon)
						-- if imgIcon then
							-- imgIcon:setVisible(true)
							-- imgIcon:loadTexture(szImage)
						-- end

					-- end
					-- self.m_nCurIndex = self.m_nCurIndex + 1;
			-- end
			-- if not self.m_SchedulerUpdate then
				-- local scheduler = cc.Director:getInstance():getScheduler()
				-- self.m_SchedulerUpdate = scheduler:scheduleScriptFunc(fnUpdate, 2, false);
			-- end
			-- self:SetNormalVisible(true)
		end
	end
	-- if list and state then
		-- local szImage = tbTestIcon[state:GetID()]
		
		-- local elem = self.m_UIListElem;
		-- elem:loadTexture(szImage)
		-- elem:setVisible(true)
		-- if elem then
			-- list:setItemModel(elem)
		-- end
		
		-- list:pushBackDefaultItem();		
		-- elem:setVisible(false)
	-- end
	self:UpadateStateEffect();
	print("UIInsert ...  end, 个数：", #self.m_tbUIStates)
end

function KGC_STATE_QUEUE_BASE_TYPE:UIRemove(nIndex)
	local list = self.m_UIList;
	print("移除状态，索引为", nIndex, #self.m_tbUIStates)
	local state = table.remove(self.m_tbUIStates, nIndex)
	print("state", state)
	-- if state then
		state:UIRemoveEffect();
	-- end
	
	if #self.m_tbUIStates <= 0 then
		-- if self.m_SchedulerUpdate then
			-- local scheduler = cc.Director:getInstance():getScheduler()
			-- scheduler:unscheduleScriptEntry(self.m_SchedulerUpdate)
		-- end
		-- self:SetNormalVisible(false);
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:SetNormalVisible1(bVisible)
	local bVisible = bVisible or false;
	print("SetNormalVisible", bVisible, #(self.m_tbUIStates or {}))
	local pnlState = ccui.Helper:seekWidgetByName(self.m_UIPanel, "pnl_normal_state")

	if #(self.m_tbUIStates or {}) > 0 then
		pnlState:setVisible(bVisible)
		local imgIcon = ccui.Helper:seekWidgetByName(pnlState, "img_state")
		imgIcon:setVisible(bVisible)
		print("imgIcon:getName()", imgIcon:getName(), imgIcon:getTag())

		local state = self.m_tbUIStates[1]
		local tbTestIcon = self.m_tbTestIcon;
		
		local szImage = tbTestIcon[state:GetID()]
		print("szImage", szImage, state, state:GetID())
		imgIcon:loadTexture(szImage)
	else
		pnlState:setVisible(false)
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:SetFullVisible1(bVisible)
	local bVisible = bVisible or false;
	print("SetFullVisible", bVisible, #(self.m_tbUIStates or {}))
	local nNum = #(self.m_tbUIStates or {})
	local nMax = 6;
	
	local tbTestIcon = self.m_tbTestIcon;
				
	-- self:SetNormalVisible(false);
	for i=1, nMax do
		local szName = "pnl_full_state_" .. i;
		local pnlState = ccui.Helper:seekWidgetByName(self.m_UIPanel, szName)
		if pnlState then
			if i <= nNum then
				pnlState:setVisible(bVisible);
				local imgState = ccui.Helper:seekWidgetByName(pnlState, "img_state")
				local txtState = ccui.Helper:seekWidgetByName(pnlState, "text_state")
				local state = self.m_tbUIStates[i]
				local szImage = tbTestIcon[state:GetID()]
				local szName = state:GetName() or "";
				imgState:loadTexture(szImage)
				txtState:setString(szName)
			else
				pnlState:setVisible(false);
			end
		end
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:ShowNormal1()
	self:SetFlag(0)
	self:SetNormalVisible(true)
	self:SetFullVisible(false)
	
end

function KGC_STATE_QUEUE_BASE_TYPE:ShowFull1()
	self:SetFlag(1)
	self:SetFullVisible(true)
	self:SetNormalVisible(false)
end

function KGC_STATE_QUEUE_BASE_TYPE:SetVisible(bVisible)
	local bVisible = bVisible or false;
	self.m_bVisble = bVisible;
	
	local nNum = #(self.m_tbUIStates or {})
	self.m_UIImgState:setVisible(bVisible);

	
	local nMax = 6;
	local tbTestIcon = self.m_tbTestIcon;
				
	-- print("nNum = ", nNum)
	for i=1, nMax do
		local szName = "pnl_stateinfo_" .. i;
		local pnlState = ccui.Helper:seekWidgetByName(self.m_UIPanel, szName)
		if pnlState then
			if i <= nNum then
				pnlState:setVisible(bVisible);
				local imgStateIcon = ccui.Helper:seekWidgetByName(pnlState, "img_skillicon")
				local txtStateName = ccui.Helper:seekWidgetByName(pnlState, "text_skillname")
				local txtStateDesc = ccui.Helper:seekWidgetByName(pnlState, "text_stateinfo")
				local state = self.m_tbUIStates[i]
				local szImage = tbTestIcon[state:GetID()]
				local szName = state:GetName() or "";
				local szDesc = state:GetDesc() or "";
				imgStateIcon:loadTexture(szImage)
				txtStateName:setString(szName)
				txtStateDesc:setString(szDesc);
			else
				pnlState:setVisible(false);
			end
		end
	end
end

function KGC_STATE_QUEUE_BASE_TYPE:GetVisible()
	return self.m_bVisble;
end

function KGC_STATE_QUEUE_BASE_TYPE:RemoveElemEffect()
end

--更新特效
function KGC_STATE_QUEUE_BASE_TYPE:UpadateStateEffect()
	local tbEffects = {};
	print("[状态特效]UpadateStateEffect", self.m_tbUIStates)
	for _, state in ipairs(self.m_tbUIStates or {}) do
		local szPos = state:UIGetEffectPosition();
		if szPos and string.len(szPos) > 0  then
			if not tbEffects[szPos] then
				tbEffects[szPos] = {};
			end
			table.insert(tbEffects[szPos], state);
		end
	end
	
	local fnCompare = function(a, b)
		if a:UIGetEffectID() > b:UIGetEffectID() then
			return true;
		end
	end
	--按照zorder排序
	for szPos, tbStates in pairs(tbEffects) do
		table.sort(tbStates, fnCompare)
		cclog("[状态特效]位置(%s)的状态个数为:%d", szPos, #(tbStates or {}))
		if #tbStates > 0 then
			for i, state in ipairs(tbStates) do
				if i == 1 then
					state:UIAddEffect(self.m_FightView);
				else
					state:UIRemoveEffect();
				end
			end
		end
	end
	
	print("[状态特效]UpadateStateEffect end.", #tbEffects)
end

---------------------------------------------------------------------