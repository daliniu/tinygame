----------------------------------------------------------
-- file:	herolineupsublayer.lua
-- Author:	page
-- Time:	2015/09/07 11:42
-- Desc:	英雄布阵二级界面类
----------------------------------------------------------
require("script/ui/lineupview/lineuplayer")
local TB_STRUCT_FIGHT_LINEUP_LAYER = {
	-- config
	m_szJsonFile = CUI_JSON_LINEUP_PATH,		-- 界面对应的json文件
	-------------------------------------------------
	m_fnCallBack = nil,							-- 回调函数
}

KGC_FIGHT_LINEUP_LAYER_TYPE = class("KGC_FIGHT_LINEUP_LAYER_TYPE", KGC_LINEUP_LAYER_TYPE, TB_STRUCT_FIGHT_LINEUP_LAYER)

function KGC_FIGHT_LINEUP_LAYER_TYPE:ctor()
end

--@function: 重载初始化函数
function KGC_FIGHT_LINEUP_LAYER_TYPE:OnInit(tbArg)
	local fnCallBack = (tbArg or {})[1];
	if type(fnCallBack) == "function" then
		self.m_fnCallBack = fnCallBack;
	end	
end

--@function: 重载加载自己部分的界面
function KGC_FIGHT_LINEUP_LAYER_TYPE:OnLoadScheme()
	if not self.m_pLayout then
		cclog("[Error]界面UI错误！@KGC_FIGHT_LINEUP_LAYER_TYPE:OnLoadScheme");
		return;
	end
	
	local fnStart = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
            self:StartFight();
        end
	end
	local btnStart = self.m_pLayout:getChildByName("btn_start");
	btnStart:addTouchEventListener(fnStart);
end

function KGC_FIGHT_LINEUP_LAYER_TYPE:OnExit()

end

function KGC_FIGHT_LINEUP_LAYER_TYPE:StartFight()
	print("11111111111111111111111111", self.m_fnCallBack);
	if self.m_fnCallBack then
		self.m_fnCallBack();
	end
	KGC_LINEUP_LOGIC_TYPE:getInstance():closeLayer();
end