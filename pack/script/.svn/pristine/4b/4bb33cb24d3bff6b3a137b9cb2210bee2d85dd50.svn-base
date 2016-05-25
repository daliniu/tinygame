require("script/ui/loginview/loginview")
require("script/class/class_base_ui/class_base_logic")
require("script/core/configmanager/configmanager");

local TB_STRUCT_LOGINLOGIC = {
}

LoginViewLogic=class("LoginViewLogic", KGC_UI_BASE_LOGIC, TB_STRUCT_LOGINLOGIC)

LoginViewLogic.test01=1

function LoginViewLogic:getInstance()
	if LoginViewLogic.m_pLogic==nil then
        LoginViewLogic.m_pLogic=LoginViewLogic:create()
		GameSceneManager:getInstance():insertLogic(LoginViewLogic.m_pLogic)
	end
	return LoginViewLogic.m_pLogic
end

function LoginViewLogic:create()
    local _logic = LoginViewLogic.new()
    return _logic
end

function LoginViewLogic:initLayer(parent,id)
	print("11111111111111111111111111111111111", self.m_pLayer);
    if self.m_pLayer then
    	return;
    end
	self:ReadConfigFromJson("settings/server_list.json")
		
    self.m_pLayer=KG_UILogin.new()
	self.m_pLayer:init();
	
    self.m_pLayer.id=id
    parent:addChild(self.m_pLayer)
end

function LoginViewLogic:closeLayer()
	print("22222222222222222222222222222", self.m_pLayer);
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function LoginViewLogic:updateLayer(iType)

end

function LoginViewLogic:onLogin(bRet, data)
	--登录成功
	if bRet then
		local function fnCallBack()
			-- test
			tst_open_log_file();
			tst_print_lua_table(data);
			-- test end
			
			cclog("[Log]登录成功!账户: %s, 区服: %s", tostring(g_Core.authInfo), tostring(g_Core.area))
			g_Core:init(data);

    		UserGuideLogic:getInstance():initUserGuide(GameSceneManager:getInstance().userGuideNode)  --用户指导层			

			-- 请求离线奖励
			FightViewLogic:getInstance():ReqFightRewardOffLine();
			

			--请求邮件列表
			EmailLogic:getInstance():reqEmailList();

			--地图信息
			me:InitMap();

			self:closeLayer()
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAIN,0)
			
			
			-- 请求离线挂机奖励进度(各个界面显示)
			-- FightViewLogic:getInstance():ReqRewardMoreCount();

		end
		-- 异步加载资源(11为预加载资源总数)
		-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_PROGRESS, {5, fnCallBack});
		-- 图片 + spine + 特效
		local nTotal = 22;
		self.m_pLayer:RegisterProgressEvent(nTotal, fnCallBack);
		local fnLoad = function()
			local fnLoad3 = function()
				self:LoadSpine();
			end
			
			local fnLoad2 = function()
				self:LoadImages(fnLoad3);
			end
			
			local fnLoad1 = function()
				self:LoadEffect(fnLoad2);
			end
			
			fnLoad1();
		end

		fnLoad();
	else
		print("[Log]登录失败")
		local szErr = tostring(data);
		if self.m_pLayer then
			self.m_pLayer:LoginFailed(szErr)
		end
	end
end

function LoginViewLogic:ReadConfigFromJson(szFile)
	if not szFile then
		return;
	end
	local cjson = require("cjson.core")
	
	local fileUtils = cc.FileUtils:getInstance()
	local szData = fileUtils:getStringFromFile(szFile);
	
	local data = cjson.decode(szData)
	self.m_tbAreas = data;

end

function LoginViewLogic:GetAreasData()
	return self.m_tbAreas or {};
end

--@function: 预加载图片资源
function LoginViewLogic:LoadImages(fnCallBack)
	print("LoadImages ................. ")
	
	local tbImages = {
		[1] = "res/ui/05_mainUI/05_bg_mainbg_01.png",
		[2] = "res/ui/01_battleselectcha/battlescene/01_bg_waterland_01a.png",
		
		-- [3] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_010.png",
		-- [4] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_011.png",
		-- [5] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_012.png",
		-- [6] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_013.png",
		-- [7] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_014.png",
		-- [8] = "res/ANI/effect/effect_uniteskill_down_01/effect_uniteskill_down_015.png",
		
		-- [9] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_010.png",
		-- [10] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_011.png",
		-- [11] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_012.png",
		-- [12] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_013.png",
		-- [13] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_014.png",
		-- [14] = "res/ANI/effect/effect_uniteskill_up_01/effect_uniteskill_up_015.png",
	}
	
	local nCount = 0;
	local function imgLoaded(texture)
		print("texturename:", texture:getName())
		if self.m_pLayer then
			self.m_pLayer:UpdateProgress();
		end
		
		nCount = nCount + 1;
		if nCount >= #tbImages and fnCallBack then
			fnCallBack();
		end
	end
	
	for _, szImage in pairs(tbImages) do
		cc.Director:getInstance():getTextureCache():addImageAsync(szImage, imgLoaded)
		UserGuideLogic:getInstance():addTextName(szImage);
	end
end

--@function: 预加载spine骨骼动画
function LoginViewLogic:LoadSpine()
	print("LoadSpine ... ");
	local tbSpines = {
		[1] = 1001,
		[2] = 1002,
		[3] = 1003,
		[4] = 1012,
		[5] = 1014,
		[6] = 1016,
		[7] = 2007,
	};
	local scheduler = cc.Director:getInstance():getScheduler()
	local nCount = 0;
	local schedulerSpine = nil;
	local fnLoadSpine = function()
		nCount = nCount + 1;
		local nModelID = tbSpines[nCount];
		KGC_MODEL_MANAGER_TYPE:getInstance():CreateNpc(nModelID);
		if self.m_pLayer then
			self.m_pLayer:UpdateProgress();
		end
		if nCount >= #tbSpines and schedulerSpine then
			scheduler:unscheduleScriptEntry(schedulerSpine);
		end
	end
	
	schedulerSpine = scheduler:scheduleScriptFunc(fnLoadSpine, 0.03, false);
	print("LoadSpine end. ");
end

--@function：预加载特效
function LoginViewLogic:LoadEffect(fnCallBack)
	print("LoadEffect ... start");
	local l_tbEffectConfig = mconfig.loadConfig("script/cfg/client/effect")
	-- percent范围 = [0, 1]
	local fnEffectLoaded = function(percent)
		print("fnCallBack", percent);
		if self.m_pLayer then
			self.m_pLayer:UpdateProgress();
		end
		if percent >= 1 and fnCallBack then
			fnCallBack();
		end
	end
	-- # 13
	local tbEffectID = {60004, 10015, 10020, 10021, 10016, 20009, 20028,
		20011, 20014, 20012, 10013, 20016, 10003,
	};
	-- local tbEffectID = {60004, 60040, 60041, 10015, 10020, 10021, 10016, 20009, 20028,
		-- 20011, 20014, 20012, 10013, 20016, 10003,
	-- };
	for _, nEffID in pairs(tbEffectID) do
		print("LoadEffect", nEffID);
		local tbInfo = l_tbEffectConfig[tostring(nEffID)];
		if tbInfo then
			local szFileName = tbInfo.effectpath;
			UserGuideLogic:getInstance():addEffectName(szFileName,nEffID);
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(szFileName, fnEffectLoaded)
		end
	end
	print("LoadEffect end.");
end

--@function: 登录失败
-- function LoginViewLogic:LoginFailed()
	-- if self.m_pLayer then
		-- self.m_pLayer:LoginFailed(szErr)
	-- end
-- end

--@function: 注册
function LoginViewLogic:RegisterMessageCallBack()
	-- 初始化接受消息协议
	local fnCallBack = function(tbArg)
		print("被踢下线...")
		g_Core:closeNetwork()
		NetworkLogic:getInstance():kickNetwork()
	end
	g_Core.communicator.client.kickClientOffline(fnCallBack);
end
