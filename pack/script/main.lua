require "script/cocos2dx/cocos2dxInit"
--===================================_SERVER============================================
--===================================_SERVER  END=======================================
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- initialize director
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    if nil == glview then
        glview = cc.GLView:createWithRect("Demo", cc.rect(0,0,500,889.33))
        director:setOpenGLView(glview)
    end

    glview:setDesignResolutionSize(750, 1334, cc.ResolutionPolicy.SHOW_ALL)

    --turn on display FPS
    director:setDisplayStats(false)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 30)


	local schedulerID = 0
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or
       (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
       (cc.PLATFORM_OS_MAC == targetPlatform) then
		--require('debugger')()

    end

    ---------------

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    --create scene
    require("script/scene/GameSceneManager")
    local gameScene = GameSceneManager:createScene()

	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(gameScene)
	else
		cc.Director:getInstance():runWithScene(gameScene)
	end
	

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
