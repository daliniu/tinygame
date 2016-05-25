----------------------------------------------------------
-- file:	upgradeview.lua
-- Author:	page
-- Time:	2015/08/08 17:11
-- Desc:	升级面板
----------------------------------------------------------
require "script/ui/resource"
----------------------------------------------------------
--data struct
local TB_STRUCT_UI_UPGRADE_VIEW_VIEW = {
	--config
	m_szFile = CUI_JSON_UPGRADE,			--界面文件路径
	
	--界面
	m_Layout = nil,							--保存界面结构root
	m_bmpLevelOld = nil,					-- 旧等级
	m_bmpLevelNew = nil,					-- 新等级
	
	m_action = nil,							-- 升级动画
}

KGC_UPGRADE_VIEW_TYPE = class("KGC_UPGRADE_VIEW_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_UI_UPGRADE_VIEW_VIEW)
--------------------------------
--ui function
--------------------------------
function KGC_UPGRADE_VIEW_TYPE:ctor()
	
end

function KGC_UPGRADE_VIEW_TYPE:Init(parent, nAddLevel)
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(self.m_szFile)
	assert(self.m_Layout)
	self:addChild(self.m_Layout)
	self:LoadScheme()
	
	self:UpdateData(nAddLevel);
	
	local fnCall = function()
		self.m_action:stop();
		KGC_UPGRADE_VIEW_LOGIC_TYPE:getInstance():closeLayer();
	end
	local action = cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(fnCall));
	parent:runAction(action);
	
	self.m_action = ccs.ActionManagerEx:getInstance():playActionByName("upgrade.json", "Animation0")
end

--解析界面文件
function KGC_UPGRADE_VIEW_TYPE:LoadScheme()
	local pnlMain = self.m_Layout:getChildByName("Image_4")
	self.m_bmpLevelOld = pnlMain:getChildByName("bmp_oldlevel")
	self.m_bmpLevelNew = pnlMain:getChildByName("bmp_newlevel")
end

function KGC_UPGRADE_VIEW_TYPE:UpdateData(nAddLevel)
	local nCurLevel = me:GetLevel();
	local nOldLevel = nCurLevel - nAddLevel;
	if nOldLevel < 0 then
		nOldLevel = 0;
	end
	self.m_bmpLevelNew:setString(nCurLevel);
	self.m_bmpLevelOld:setString(nOldLevel);
end

function KGC_UPGRADE_VIEW_TYPE:OnExit()
	print("KGC_UPGRADE_VIEW_TYPE OnExit ... ")
	self.m_action:stop();
	-- ccs.ActionManagerEx:destroyInstance();
end


--------------------------------
