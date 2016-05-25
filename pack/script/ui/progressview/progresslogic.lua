----------------------------------------------------------
-- file:	progresslogic.lua
-- Author:	page
-- Time:	2015/08/13 
-- Desc:	过度进度条界面逻辑管理类
----------------------------------------------------------
require("script/ui/progressview/progressview")
require("script/class/class_base_ui/class_base_logic")

local TB_STRUCT_PROGRESS_VIEW_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
	
	m_nTimesAuto = 0,			-- 自动更新进度条：最大次数
	m_scheduleAuto = nil,		-- 自动更新进度条：调度器
}

KGC_PROGRESS_VIEW_LOGIC_TYPE=class("KGC_PROGRESS_VIEW_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_PROGRESS_VIEW_LOGIC)


function KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance()
	if not KGC_PROGRESS_VIEW_LOGIC_TYPE.m_pLogic then
        KGC_PROGRESS_VIEW_LOGIC_TYPE.m_pLogic = KGC_PROGRESS_VIEW_LOGIC_TYPE:create()
		GameSceneManager:getInstance():insertLogic(KGC_PROGRESS_VIEW_LOGIC_TYPE.m_pLogic)
	end
	return KGC_PROGRESS_VIEW_LOGIC_TYPE.m_pLogic
end

function KGC_PROGRESS_VIEW_LOGIC_TYPE:create()
    local _logic = KGC_PROGRESS_VIEW_LOGIC_TYPE.new()
    return _logic
end

function KGC_PROGRESS_VIEW_LOGIC_TYPE:initLayer(parent,id, tbArgs)
    if self.m_pLayer then
    	return;
    end
	
    self.m_pLayer = KGC_PROGRESS_VIEW_TYPE.new()
	self.m_pLayer:Init();
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
	
	local nMax, fnCallBack = unpack(tbArgs or {})
	self.m_pLayer:RegisterEvent(nMax, fnCallBack)
	self.m_nTimesAuto = nMax or 0;
end

function KGC_PROGRESS_VIEW_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function KGC_PROGRESS_VIEW_LOGIC_TYPE:OnCallBack()
	if self.m_pLayer then
		self.m_pLayer:LoadingFinished();
		self:closeLayer();
	end
end

--@function: 
function KGC_PROGRESS_VIEW_LOGIC_TYPE:Update()
	if self.m_pLayer then
		self.m_pLayer:UpdateProgress();
	end
end

--@function: 
function KGC_PROGRESS_VIEW_LOGIC_TYPE:AutoUpdate()
	local nMaxTimes = self.m_nTimesAuto or 0;
	
	if self.m_scheduleAuto then
		return;
	end
	
	local scheduler = cc.Director:getInstance():getScheduler()
	local nCount = 0;
	local fnCallBack = function()
		self:Update()
		nCount = nCount + 1;
		if nCount > nMaxTimes then
			if self.m_scheduleAuto then
				scheduler:unscheduleScriptEntry(self.m_scheduleAuto);
				self.m_scheduleAuto = nil;
			end
		end
	end
	
	
	self.m_scheduleAuto = scheduler:scheduleScriptFunc(fnCallBack, 0.1, false)
end