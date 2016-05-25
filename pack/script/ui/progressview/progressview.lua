----------------------------------------------------------
-- file:	progressview.lua
-- Author:	page
-- Time:	2015/08/13 17:54
-- Desc:	过度进度条
----------------------------------------------------------
require "script/ui/resource"
----------------------------------------------------------
--data struct
local TB_STRUCT_PROGRESS_VIEW = {
	--config
	m_szFile = CUI_JSON_PROGRESS,			--界面文件路径
	
	--界面
	m_Layout = nil,							--保存界面结构root
	
	m_schedule = nil,						-- 定时器
	m_nTimes = 0,							-- 当前次数
	m_nMaxTimes = 0,						-- 总的次数
}

KGC_PROGRESS_VIEW_TYPE = class("KGC_PROGRESS_VIEW_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_PROGRESS_VIEW)
--------------------------------
--ui function
--------------------------------
function KGC_PROGRESS_VIEW_TYPE:ctor()
	
end

function KGC_PROGRESS_VIEW_TYPE:Init()
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(self.m_szFile)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	
	local progressBar = self.m_Layout:getChildByName("progressbar")
	local imgHead = progressBar:getChildByName("img_head")
	local lblPercent = progressBar:getChildByName("lbl_percent");
	--notify: ProgressTimer的接口为setPercentage
	progressBar:setPercent(0);
	lblPercent:setString(0);

	-- 定时器更新进度条
	--[[
	local nTimer = 0;
	local nTotal = 5;
	local fnLoadingCallback = function(sender)
		nTimer = nTimer + 1;									--每进到这个函数一次，让m_loadedSp + 1  
  
		local nPercent = (nTimer / nTotal) * 100
		if nPercent > 100 then
			nPercent = 100;
		end						

		progressBar:setPercent(nPercent);					--更新进度条  
	end
	local scheduler = cc.Director:getInstance():getScheduler()
	self.m_schedule = scheduler:scheduleScriptFunc(fnLoadingCallback, 1, false)
	]]
	
end

function KGC_PROGRESS_VIEW_TYPE:UpdateProgress()
	local progressBar = self.m_Layout:getChildByName("progressbar")
	local imgHead = progressBar:getChildByName("img_head")
	local lblPercent = progressBar:getChildByName("lbl_percent");

	-- 定时器更新进度条
	local nTimes = self.m_nTimes + 1;
	self.m_nTimes = nTimes;
	local nTotal = self.m_nMaxTimes or 1;
	
	local nPercent = (nTimes / nTotal) * 100
	if nPercent > 100 then
		nPercent = 100;
	end						
	progressBar:setPercent(nPercent);					--更新进度条
	lblPercent:setString(math.floor(nPercent));
	
	if nTimes >= nTotal then
		self.m_fnCallBack();
		KGC_PROGRESS_VIEW_LOGIC_TYPE:getInstance():closeLayer();
	end
end

--@function: 注册进度条事件
--@nTimes: 进度条分段
--@fnCallBack: 进度条满时候回调函数
function KGC_PROGRESS_VIEW_TYPE:RegisterEvent(nTimes, fnCallBack)
	if not fnCallBack then
		return false;
	end
	self.m_nMaxTimes = nTimes or 0;
	self.m_fnCallBack = fnCallBack;
	
	return true;
end

function KGC_PROGRESS_VIEW_TYPE:LoadingFinished()
	local scheduler = cc.Director:getInstance():getScheduler()
	if self.m_schedule then
		scheduler:unscheduleScriptEntry(self.m_schedule)
	end
end

function KGC_PROGRESS_VIEW_TYPE:OnExit()

end


--------------------------------
