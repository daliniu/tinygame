require("script/core/configmanager/configmanager");
local SystemOpenFile =mconfig.loadConfig("script/cfg/commons/systemlevel");

local TAB_SYSTEM_OPEN={
	
}

SystemOpen = class("SystemOpen");


SystemOpen.SYS_MAP			=	1;		--地图系统
SystemOpen.SYS_ACTIVE		=	2;		--活动系统
SystemOpen.SYS_MISSION		=	3;		--任务系统
SystemOpen.SYS_FORING		=	4;		--打造系统
SystemOpen.SYS_TEAM 		=	5;		--队伍系统
SystemOpen.SYS_BAG			=	6;		--背包系统
SystemOpen.SYS_AFK			=	7;		--挂机系统
SystemOpen.SYS_HANDBOOK		=	8;		--召唤新英雄
SystemOpen.SYS_LINEUP		=	9;		--布阵
SystemOpen.SYS_PICKUP		=	10;		--淬炼
SystemOpen.SYS_MAIN			=	11;		--首页
SystemOpen.SYS_SHOP			=	111;	--商店

function SystemOpen:getInstance()
	if SystemOpen.m_pLogic == nil then 
		SystemOpen.m_pLogic = SystemOpen:create();
	end

	return SystemOpen.m_pLogic;
end

function SystemOpen:create()
	local _logic = SystemOpen.new();
	_logic:initAttr();
	return _logic;
end


function SystemOpen:initAttr()
	local verSource =  cc.FileUtils:getInstance():getStringFromFile("res/shader/FogShader.vsh")
    local fragSource = cc.FileUtils:getInstance():getStringFromFile("res/shader/example_greyScale.fsh")
    local glProgam = cc.GLProgram:createWithByteArrays(verSource, fragSource)
    self.glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgam)

    self.normalGLProgramstate =  cc.Sprite:create():getGLProgramState();

end


function SystemOpen:getSystemIsOpen(systemID)

	if true then 
		return true;
	end

	if SystemOpenFile ==nil then
		return true;
	end
	local systemConfig = SystemOpenFile[systemID];
	if systemConfig == nil then
		return true;
	end

	if systemConfig.Openlevel > me:GetLevel() then
		return false;
	end

	return true;

end


function SystemOpen:setDisTouch(pWidget)
    pWidget:getVirtualRenderer():setGLProgramState(self.glprogramstate)	
    for k,v in pairs(pWidget:getChildren()) do
    	if v:getVirtualRenderer()~=nil then 
    		v:getVirtualRenderer():setGLProgramState(self.glprogramstate)
    	end	
    end
end

function SystemOpen:setAbleTouch(pWidget)
    pWidget:getVirtualRenderer():setGLProgramState(self.normalGLProgramstate)	
    for k,v in pairs(pWidget:getChildren()) do
    	if v:getVirtualRenderer()~=nil then
    		v:getVirtualRenderer():setGLProgramState(self.normalGLProgramstate)
    	end
    end

end

function SystemOpen:fun_updateLock(pWidget,bRet,iType)
	local pLockImg = pWidget:getChildByName("img_lock");
	if bRet == false then 
		pLockImg:setVisible(true);
	else
		pLockImg:setVisible(false);
	end
	
end