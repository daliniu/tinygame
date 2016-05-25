----------------------------------------------------------
-- file:	class_data_base.lua
-- Author:	page
-- Time:	2015/03/19
-- Desc:	设计模式 基类
----------------------------------------------------------
require "script/class/class_base"

--主题基类

--struct
local TB_DP_SUBJECT_STRUCT = {
	--增加一个优先级的设定，因为要求结算的时候英雄和宠物有优先级区分
	m_tbObservers = {
		--[level] = {}
	},
}

KGC_DP_SUBJECT_BASE_TYPE = class("KGC_DP_SUBJECT_BASE_TYPE", CLASS_BASE_TYPE, TB_DP_SUBJECT_STRUCT)

local l_tbCondID, l_tbCondName = def_GetConditionData();


function KGC_DP_SUBJECT_BASE_TYPE:ctor()
	if not self.m_tbObservers then
		self.m_tbObservers = {}
	end
	
end

--@function: 主题通知所有观察者更新数据
--@param: obj-条件触发的对象; id-条件ID
function KGC_DP_SUBJECT_BASE_TYPE:Notify(obj, id)
	print("[主题通知]@Notify触发条件: ", obj, id, l_tbCondName[id])
	self:TestPrint();
	--notify: 用ipairs就有一个时间顺序
	local tbRet = {}
	for level, tbObs in ipairs(self.m_tbObservers) do
		-- cclog("level(%d), #tbObs(%d)", level, #tbObs)
		-- for _, observer in ipairs(tbObs) do
		--这种写法为了保证先进来的先处理
		local i = 1;
		--增加的这一轮不处理
		local nStartMax = #tbObs						
		while i <= #tbObs and i <= nStartMax do
			local nOld = #tbObs;
			observer = tbObs[i]
			-- print("level, observer, classname", level, tostring(observer), observer:GetClassName(), #tbObs)
			local ret = observer:CondUpdate(obj, id);
			if ret then
				ret:SetTriggerConID(id)
				table.insert(tbRet, ret);
			end
			-- print("i, #tbObs, nOld", i, #tbObs, nOld)
			--observer没有被删除，处理所有都需要+1
			if #tbObs >= nOld then
				i = i + 1;
			end
		end
	end
	
	--最后再来处理索引为0的
	if type(self.m_tbObservers[0]) == "table" then
		-- print("#self.m_tbObservers[0]", #self.m_tbObservers[0])
		for _, observer in ipairs(self.m_tbObservers[0]) do
			local ret = observer:CondUpdate(obj, id);
			if ret then
				ret:SetTriggerConID(id)
				table.insert(tbRet, ret);
			end
		end
	end
	
	print("[主题通知]通知完毕之后结果个数(@KGC_DP_SUBJECT_BASE_TYPE:Notify)", #(tbRet))
	return tbRet;
end

function KGC_DP_SUBJECT_BASE_TYPE:NotifyUI(tbRet, uiWidget, id)
	cclog("触发条件播放效果个数(%d), 触发条件ID(%s)-(%s)", #(tbRet or {}), tostring(id), l_tbCondName[id])
	--notify: 用ipairs就有一个时间顺序
	tbRet = tbRet or {}
	--data结构：
	for _, data in ipairs(tbRet) do	
		if data.GetElem then
			local obj = data:GetElem();
			if obj then
				obj:CondUpdateUI(data, uiWidget, id)
			else
				cclog("obj是无效的@NotifyUI")
			end
		else
			print("[Warning]没有GetElem函数, data为空才会导致!")
		end
	end
end

function KGC_DP_SUBJECT_BASE_TYPE:Attach(observer, level)
	-- print("@KGC_DP_SUBJECT_BASE_TYPE:Attach", level, tostring(observer))
	level = level or 0;
	if level == 0 then
		cclog("[Warning]level is 0!")
	end
	
	if not self.m_tbObservers then
		self.m_tbObservers = {}
	end

	--把空的表补上：ipairs
	for i=1, level do 
		if not self.m_tbObservers[i] then
			self.m_tbObservers[i] = {};
		end
	end

	--
	if observer:IsAObserver() then
		if not self.m_tbObservers[level] then
			self.m_tbObservers[level] = {};
		end
		table.insert(self.m_tbObservers[level], observer);
	end
end

function KGC_DP_SUBJECT_BASE_TYPE:Detach(observer)
	-- print("@KGC_DP_SUBJECT_BASE_TYPE:Detach", tostring(observer))
	level = level or 0;
	if observer:IsAObserver()then-- and type(self.m_tbObservers[level]) == "table" then
		-- for nIndex, obs in ipairs(self.m_tbObservers[level]) do
			-- if obs == observer then
				-- table.remove(self.m_tbObservers, nIndex);
			-- end
		-- end
		
		for level, tbObs in ipairs(self.m_tbObservers) do
			for nIndex, obs in ipairs(tbObs) do
				print("level, nIndex", level, nIndex, #tbObs, obs == observer)
				if obs == observer then
					print("找到要删除的观察者！", nIndex)
					table.remove(tbObs, nIndex);
					break;
				end
			end
		end
		
		--最后再来处理索引为0的
		if type(self.m_tbObservers[0]) == "table" then
			for _, obs in ipairs(self.m_tbObservers[0]) do
				if obs == observer then
					print("找到要删除的观察者！", nIndex)
					table.remove(self.m_tbObservers[0], nIndex);
					break;
				end
			end
		end
	end
end

function KGC_DP_SUBJECT_BASE_TYPE:TestPrint()
	print("[观察者模式]打印主题对应的观察者 Subjects ... ")
	local nTestCount = 0;
	for level, tbObs in ipairs(self.m_tbObservers) do
		for _, observer in ipairs(tbObs) do
			if observer then
				nTestCount = nTestCount + 1;
				cclog("\tlevel(%d): %s - %s", level, tostring(observer), observer:GetName())
			end
		end
	end
	
	--最后再来处理索引为0的
	if type(self.m_tbObservers[0]) == "table" then
		for _, observer in ipairs(self.m_tbObservers[0]) do
			if observer then
				print("\tlevel(0):", observer, observer:GetName())
				nTestCount = nTestCount + 1;
			end
		end
	end
	print("[观察者模式]主题持有观察者总数目：", nTestCount)
	if nTestCount > 12 then
		cclog("[Warning]观察者太多，是不是有没用的数据没有删除!");
	end
end
----------------------------------------------------------
--观察者基类

--struct
local TB_DP_OBSERVER_STRUCT = {
}

KGC_DP_OBSERVER_BASE_TYPE = class("KGC_DP_OBSERVER_BASE_TYPE", CLASS_BASE_TYPE, TB_DP_OBSERVER_STRUCT)
local l_tbCamp = def_GetFightCampData();
local l_tbCondLevel = def_GetCondLevel();

function KGC_DP_OBSERVER_BASE_TYPE:ctor()
end

function KGC_DP_OBSERVER_BASE_TYPE:AttachSubject(subject, hero, nCamp)
	-- print("观察者绑定主题", subject, hero, nCamp)
	if subject then
		if hero then
			if hero:IsHero() then
				if nCamp == l_tbCamp.MINE then
					subject:Attach(self, l_tbCondLevel.MINE_HERO)
				else
					subject:Attach(self, l_tbCondLevel.ENEMY_HERO)
				end
			else
				if nCamp == l_tbCamp.MINE then
					subject:Attach(self, l_tbCondLevel.MINE_NPC)
				else
					subject:Attach(self, l_tbCondLevel.ENEMY_NPC)
				end
			end
		else
			subject:Attach(self)
		end
		-- subject:TestPrint()
	end
end

function KGC_DP_OBSERVER_BASE_TYPE:GetName()
	return "observer"
end

function KGC_DP_OBSERVER_BASE_TYPE:DetachSubject(subject)
	if subject then
		subject:Detach(self)
	end
end

function KGC_DP_OBSERVER_BASE_TYPE:IsAObserver()
	return true;
end

function KGC_DP_OBSERVER_BASE_TYPE:CondUpdate(obj, id)
end

function KGC_DP_OBSERVER_BASE_TYPE:CondUpdateUI(arg, uiWidget, id)
end

-----------------------------------------------------------------------------------------------
--条件对象基类
--struct
local TB_SUB_CONDITION_STRUCT = {
}

KGC_SUB_CONDITION_BASE_TYPE = class("KGC_SUB_CONDITION_BASE_TYPE", KGC_DP_SUBJECT_BASE_TYPE, TB_SUB_CONDITION_STRUCT)

function KGC_SUB_CONDITION_BASE_TYPE:ctor()
end

----------------------------------------------------------
--触发对象基类

--struct
local TB_OBS_OBJECT_STRUCT = {
}

KGC_OBS_OBJECT_BASE_TYPE = class("KGC_OBS_OBJECT_BASE_TYPE", KGC_DP_OBSERVER_BASE_TYPE, TB_OBS_OBJECT_STRUCT)

function KGC_OBS_OBJECT_BASE_TYPE:ctor()
end