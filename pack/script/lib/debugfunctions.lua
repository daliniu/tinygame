----------------------------------------------------------
-- file:	debugfunctions.lua
-- Author:	page
-- Time:	2015/03/03 
-- Desc:	一些调试要用的函数
----------------------------------------------------------
--是否调试模式
DEBUG_VERSION = false
--是否关闭网络
DEBUG_CLOSED_NETWORK = false;
-- 是否服务端
-- _SERVER = false
--调试随机种子
_DEBUG_ = false;
-- 调试内存泄漏
DEBUG_MEMORY_LEAK = true;
-- 开启测试客户端和服务端随机种子
-- DEBUG_SEED = true;

function dbf_SwitchFlag()
	local szPre = "";
	if DEBUG_VERSION == true then
		DEBUG_VERSION = false
		szPre = "关闭";
	else
		DEBUG_VERSION = true;
		szPre = "打开";
	end
	TipsViewLogic:getInstance():addMessageTipsEx(50000, szPre);
	
	-- 打印
	local printT = print;
	function _print(...)
		if not DEBUG_VERSION then
			printT(...);
		end
	end
	print = _print;
	
	-- display FPS
	local director = cc.Director:getInstance()
	director:setDisplayStats(DEBUG_VERSION)
end

function dbf_GetFlag()
	return DEBUG_VERSION;
end

if not _SERVER then

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if cc.PLATFORM_OS_WINDOWS == targetPlatform then
	print("/****************************************************/")
	print("/*********************windows***********************/");
	print("/****************************************************/")
	DEBUG_VERSION_PC = true;
end

end

-- 统计随机函数调用次数
g_nTestCount = 0;

----------------------------------------------------------------
--[[
                   _ooOoo_
                  o8888888o
                  88" . "88
                  (| -_- |)
                  O\  =  /O
               ____/`---'\____
             .'  \\|     |//  `.
            /  \\|||  :  |||//  \
           /  _||||| -:- |||||-  \
           |   | \\\  -  /// |   |
           | \_|  ''\---/''  |   |
           \  .-\__  `-`  ___/-. /
         ___`. .'  /--.--\  `. . __
      ."" '<  `.___\_<|>_/___.'  >'"".
     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
     \  \ `-.   \_ __\ /__ _/   .-` /  /
======`-.____`-.___\_____/___.-`____.-'======
                   `=---='
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         佛祖保佑       永无BUG
]]