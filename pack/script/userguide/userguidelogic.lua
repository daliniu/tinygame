require("script/userguide/userguidelayer");
require("script/userguide/userguidechecknode")
require("script/lib/textureCacheRemove");
require("script/core/configmanager/configmanager");
-- 指引用的怪物盒子
local l_tbHeroBox = mconfig.loadConfig("script/cfg/client/herobox");
local TB_ENUM_ITEM_TYPE_GENRE_DEF ,TB_ENUM_ITEM_TYPE_DETAIL_DEF= def_GetItemType();

local TAB_USER_GUIDE_LOGIC={
	sceneManager =nil,
	pLayerParent =nil,

	currentNewIndex =nil,
	currentSystemIndex =nil,

	--临时数据
	pUQ_heroID = nil,

}

UserGuideLogic = class("UserGuideLogic", KGC_UI_BASE_LOGIC,TAB_USER_GUIDE_LOGIC);

--每加一种新手引导需要
--1，触发
--2，点击
--保存数据
--界面init



--系统引导标示
-- UserGuideLogic.new_guid			= 0;		--新手引导
-- UserGuideLogic.sys_uq 			= 0;		--生品
-- UserGuideLogic.sys_equi 		= 0; 		--装备
-- UserGuideLogic.sys_map 			= 0; 		--地图
-- UserGuideLogic.sys_forging 		= 0; 		--打造
-- UserGuideLogic.sys_upStar   	= 1;  		--升星淬炼---------------------
-- UserGuideLogic.sys_hero1 		= 0;  		--第一次招英雄
-- UserGuideLogic.sys_hero2 		= 0;  		--第二次找英雄
-- UserGuideLogic.sys_lineUp 		= 0; 		--阵容
-- UserGuideLogic.sys_hookPoint 	= 0;		--挂机点教学
-- UserGuideLogic.sys_chestBox		= 0;		--宝箱


--开篇引导
UserGuideLogic.stepOver =-1;		--结束


--开篇指引
UserGuideLogic.step01 	= 100;		--开篇
UserGuideLogic.step02 	= 200;		--第一场战斗
UserGuideLogic.step021 	= 201;		--第二场战斗
UserGuideLogic.step022 	= 202;		--第三场战斗
UserGuideLogic.step023 	= 203;		--第四场战斗
UserGuideLogic.step03 	= 300;		--
UserGuideLogic.step04 	= 400;
UserGuideLogic.step05 	= 500;
UserGuideLogic.step06 	= 600;
UserGuideLogic.step07 	= 700;


--系统引导
UserGuideLogic.sys_uq_step_a = 10098;	--英雄升级品
UserGuideLogic.sys_uq_step00 = 10099;
UserGuideLogic.sys_uq_step01 = 10100;	
UserGuideLogic.sys_uq_step02 = 10200;
UserGuideLogic.sys_uq_step03 = 10300;
UserGuideLogic.sys_uq_step04 = 10400;
UserGuideLogic.sys_uq_step05 = 10500;
UserGuideLogic.sys_uq_step06 = 10600;   
UserGuideLogic.sys_uq_step07 = 10700;
UserGuideLogic.sys_uq_step08 = 10800;
UserGuideLogic.sys_uq_step09 = 10900;
UserGuideLogic.sys_uq_step10 = 11000;

UserGuideLogic.sys_equi_step_a = 20098;
UserGuideLogic.sys_equi_step00 = 20099; 	--传装备
UserGuideLogic.sys_equi_step01 = 20100;
UserGuideLogic.sys_equi_step02 = 20200; 
UserGuideLogic.sys_equi_step03 = 20300; 
UserGuideLogic.sys_equi_step04 = 20400; 
UserGuideLogic.sys_equi_step05 = 20500; 
UserGuideLogic.sys_equi_step06 = 20600; 
UserGuideLogic.sys_equi_step07 = 20700; 
UserGuideLogic.sys_equi_step08 = 20800; 
UserGuideLogic.sys_equi_step09 = 20900; 
UserGuideLogic.sys_equi_step10 = 21000;


UserGuideLogic.sys_map_step01 		= 30100;	--开启地图
UserGuideLogic.sys_map_step02 		= 30200;
UserGuideLogic.sys_map_step02_01 	= 30201;
UserGuideLogic.sys_map_step03 = 30300;
UserGuideLogic.sys_map_step04 = 30400;
UserGuideLogic.sys_map_step05 = 30500;
UserGuideLogic.sys_map_step06 = 30600;
UserGuideLogic.sys_map_step07 = 30700;
UserGuideLogic.sys_map_step08 = 30800;
UserGuideLogic.sys_map_step09 = 30900;
UserGuideLogic.sys_map_step10 = 31000;


UserGuideLogic.sys_forging_step_a = 40098;
UserGuideLogic.sys_forging_step00 = 40099;	--装备打造
UserGuideLogic.sys_forging_step01 = 40100;	--装备打造
UserGuideLogic.sys_forging_step02 = 40200;
UserGuideLogic.sys_forging_step03 = 40300;
UserGuideLogic.sys_forging_step04 = 40400;
UserGuideLogic.sys_forging_step05 = 40500;
UserGuideLogic.sys_forging_step06 = 40600;
UserGuideLogic.sys_forging_step07 = 40700;
UserGuideLogic.sys_forging_step08 = 40800;
UserGuideLogic.sys_forging_step09 = 40900;
UserGuideLogic.sys_forging_step10 = 41000;


UserGuideLogic.sys_upStar_step_a  = 50098;
UserGuideLogic.sys_upStar_step00 = 50099;
UserGuideLogic.sys_upStar_step01 = 50100;	--装备升星和洗练
UserGuideLogic.sys_upStar_step02 = 50200;
UserGuideLogic.sys_upStar_step03 = 50300;
UserGuideLogic.sys_upStar_step04 = 50400;
UserGuideLogic.sys_upStar_step05 = 50500;
UserGuideLogic.sys_upStar_step06 = 50600;
UserGuideLogic.sys_upStar_step07 = 50700;
UserGuideLogic.sys_upStar_step08 = 50800;
UserGuideLogic.sys_upStar_step09 = 50900;
UserGuideLogic.sys_upStar_step10 = 51000;

UserGuideLogic.sys_hero2_step_a = 60098;
UserGuideLogic.sys_hero2_step00 = 60099;
UserGuideLogic.sys_hero2_step01 = 60100;	--获得新的英雄(第2次获得英雄)
UserGuideLogic.sys_hero2_step02 = 60200;
UserGuideLogic.sys_hero2_step03 = 60300;
UserGuideLogic.sys_hero2_step04 = 60400;
UserGuideLogic.sys_hero2_step05 = 60500;
UserGuideLogic.sys_hero2_step06 = 60600;
UserGuideLogic.sys_hero2_step07 = 60700;
UserGuideLogic.sys_hero2_step08 = 60800;
UserGuideLogic.sys_hero2_step09 = 60900;
UserGuideLogic.sys_hero2_step10 = 61000;


UserGuideLogic.sys_hero1_step_a = 70098;
UserGuideLogic.sys_hero1_step00 = 70099;	
UserGuideLogic.sys_hero1_step01 = 70100;	--获得英雄（第一次获得英雄）
UserGuideLogic.sys_hero1_step02 = 70200;
UserGuideLogic.sys_hero1_step03 = 70300;
UserGuideLogic.sys_hero1_step04 = 70400;
UserGuideLogic.sys_hero1_step05 = 70500;
UserGuideLogic.sys_hero1_step06 = 70600;
UserGuideLogic.sys_hero1_step07 = 70700;
UserGuideLogic.sys_hero1_step08 = 70800;
UserGuideLogic.sys_hero1_step09 = 70900;
UserGuideLogic.sys_hero1_step10 = 71000;


UserGuideLogic.sys_lineUp_step00 = 80099;
UserGuideLogic.sys_lineUp_step01 = 80100;	--阵容
UserGuideLogic.sys_lineUp_step02 = 80200;
UserGuideLogic.sys_lineUp_step03 = 80300;
UserGuideLogic.sys_lineUp_step04 = 80400;
UserGuideLogic.sys_lineUp_step05 = 80500;
UserGuideLogic.sys_lineUp_step06 = 80600;
UserGuideLogic.sys_lineUp_step07 = 80700;
UserGuideLogic.sys_lineUp_step08 = 80800;
UserGuideLogic.sys_lineUp_step09 = 80900;
UserGuideLogic.sys_lineUp_step10 = 81000;


UserGuideLogic.sys_map_hookpoint01 = 90100;	--挂机点
UserGuideLogic.sys_map_hookpoint02 = 90200;
UserGuideLogic.sys_map_hookpoint03 = 90300;
UserGuideLogic.sys_map_hookpoint04 = 90400;
UserGuideLogic.sys_map_hookpoint05 = 90500;
UserGuideLogic.sys_map_hookpoint06 = 90600;
UserGuideLogic.sys_map_hookpoint07 = 90700;
UserGuideLogic.sys_map_hookpoint08 = 90800;
UserGuideLogic.sys_map_hookpoint09 = 90900;
UserGuideLogic.sys_map_hookpoint10 = 91000;


UserGuideLogic.sys_chestBox_000 = 100099;
UserGuideLogic.sys_chestBox_001 = 100100;		--战斗宝箱
UserGuideLogic.sys_chestBox_002 = 100200;
UserGuideLogic.sys_chestBox_003 = 100300;
UserGuideLogic.sys_chestBox_004 = 100400;
UserGuideLogic.sys_chestBox_005 = 100500;
UserGuideLogic.sys_chestBox_006 = 100600;
UserGuideLogic.sys_chestBox_007 = 100700;
UserGuideLogic.sys_chestBox_008 = 100800;
UserGuideLogic.sys_chestBox_009 = 100900;
UserGuideLogic.sys_chestBox_010 = 101000;



UserGuideLogic.FirstHeroID =10013;		--第一次给的英雄
UserGuideLogic.SecondHeroID = 10002; 	--第二次给的英雄



function UserGuideLogic:getInstance()
    if UserGuideLogic.m_pLogic == nil then
        UserGuideLogic.m_pLogic = UserGuideLogic:create()
        GameSceneManager:getInstance():insertLogic(UserGuideLogic.m_pLogic)
    end
	
    return UserGuideLogic.m_pLogic
end

function UserGuideLogic:create()
    local _logic = UserGuideLogic.new()
    _logic:Init()
    return _logic
end

function UserGuideLogic:Init()
	self.sceneManager = GameSceneManager:getInstance();

	self.new_guid			= 0;		--新手引导
	self.sys_uq 			= 0;		--生品
	self.sys_equi 			= 0; 		--装备
	self.sys_map 			= 0; 		--地图
	self.sys_forging 		= 0; 		--打造
	self.sys_upStar   		= 1;  		--升星淬炼---------------------
	self.sys_hero1 			= 0;  		--第一次招英雄
	self.sys_hero2 			= 0;  		--第二次找英雄
	self.sys_lineUp 		= 0; 		--阵容
	self.sys_hookPoint 		= 0;		--挂机点教学
	self.sys_chestBox		= 0;		--宝箱



	--self.currentNewIndex = UserGuideLogic.stepOver;
	--self.currentSystemIndex = UserGuideLogic.sys_uq_step00;
end

function UserGuideLogic:OnUpdateLayer(iType)

	--打印内存
	--tst_print_textures_cache();


	--升品条件判定
	if self.sys_uq == 0 then 
		--19011 *5
		--19006 *5
		--19061 *5
		if self.currentSystemIndex == nil then
			local item01 = me.m_Bag:GetItemByID(19011);
			local item02 = me.m_Bag:GetItemByID(19006);
			local item03 = me.m_Bag:GetItemByID(19061);

			if item01 ~= nil and 
				item01:GetNum()>=5 then 
				self.currentSystemIndex = UserGuideLogic.sys_uq_step_a;
				self.pUQ_heroID = 10003;
			end

			if item02 ~= nil and 
				item02:GetNum()>=5 then 
				self.currentSystemIndex = UserGuideLogic.sys_uq_step_a;
				self.pUQ_heroID = 10002;
			end

			if item03 ~= nil and 
				item03:GetNum()>=5 then 
				self.currentSystemIndex = UserGuideLogic.sys_uq_step_a;
				self.pUQ_heroID = 10013;
			end
		end
			
	end


	--装备打造条件判定
	if self.sys_forging ==  0 then 
		if self.currentSystemIndex == nil then
			--16001*1
			--16003*1
			--15101*10
			local item01 = me.m_Bag:GetItemByID(16001);
			local item02 = me.m_Bag:GetItemByID(16003);
			local item03 = me.m_Bag:GetItemByID(15101);

			local bOpen = false;
			if item01~=nil and item01:GetNum()>=1 
				and item02~=nil and item02:GetNum()>=1
				and item03~=nil and item03:GetNum()>=10 then 
				bOpen = true;
			end

			if bOpen == true then 
				self.currentSystemIndex = UserGuideLogic.sys_forging_step_a;
			end
		end
	end


	--战斗宝箱判定
	if self.sys_chestBox == 0 and 
		self.currentSystemIndex==nil then
		if me:GetAfkerRewardPercent()==100 then
			self.currentSystemIndex = UserGuideLogic.sys_chestBox_000;
		end

	end

	--装备判定
	if self.sys_equi == 0 and 
		self.currentSystemIndex==nil then


		local item01 = me.m_Bag:GetItemByID(110101);

		if item01~=nil and 
			item01:GetNum()>=1 then 
			self.currentSystemIndex = UserGuideLogic.sys_equi_step_a;
		end

	end


end


function UserGuideLogic:initUserGuide(parent)

	if true then
		return;
	end

	self:loadDate();

	self.pLayerParent = parent;		--显示层的控制节点
	
	local checkNode = UserGuideCheckNode:create();
	self.pLayerParent:addChild(checkNode);
	
end

function UserGuideLogic:loadDate()
	-- UserGuideLogic.sys_uq 			= 0;		--生品
	-- UserGuideLogic.sys_equi 		= 0; 		--装备
	-- UserGuideLogic.sys_map 			= 0; 		--地图
	-- UserGuideLogic.sys_forging 		= 0; 		--打造
	-- UserGuideLogic.sys_upStar   	= 1;  		--升星淬炼---------------------
	-- UserGuideLogic.sys_hero1 		= 0;  		--第一次招英雄
	-- UserGuideLogic.sys_hero2 		= 0;  		--第二次找英雄
	-- UserGuideLogic.sys_lineUp 		= 0; 		--阵容
	-- UserGuideLogic.sys_hookPoint 	= 0;		--挂机点教学
	--UserGuideLogic.sys_chestBox		= 0;		--宝箱

	-- --开篇引导
	-- UserGuideLogic.stepOver =1;		--结束


	if self.sys_uq == 0 then
		self.sys_uq = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_uq",0)
	end

	if self.sys_equi == 0 then 
		self.sys_equi = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_equi",0)
	end

	if self.sys_map == 0 then 
		self.sys_map = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_map",0)
	end		
	
	if self.sys_forging == 0 then 
		self.sys_forging = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_forging",0)
	end

	if self.sys_upStar == 0 then 
		self.sys_upStar = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_upStar",0)
	end

	if self.sys_hero1 == 0 then
		self.sys_hero1 = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_hero1",0)
	end

	if self.sys_hero2 == 0 then
		self.sys_hero2 = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_hero2",0)
	end

	if self.sys_lineUp == 0 then
		self.sys_lineUp = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_lineUp",0)
	end

	if self.sys_hookPoint == 0 then
		self.sys_hookPoint = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_hookPoint",0)
	end

	if self.sys_chestBox == 0 then
		self.sys_chestBox = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."sys_chestBox",0)
	end	

	if self.new_guid == 0 then
		self.new_guid = cc.UserDefault:getInstance():getIntegerForKey(me:GetAccount().."guid".."new_guid",0)
		if self.new_guid == 1 then
			self.currentNewIndex = UserGuideLogic.stepOver
			self:removeResTest();
		end
	end

end

function UserGuideLogic:saveDate(sKey)
	cc.UserDefault:getInstance():setIntegerForKey(me:GetAccount().."guid"..sKey,1)
	cc.UserDefault:getInstance():flush()

end


function UserGuideLogic:initLayer()


end

function UserGuideLogic:removeLayer(bIsClean)
	if self.pLayer == nil then 
		return;
	end

	--self.pLayer:runAction(cc.RemoveSelf:create());
	self.pLayer:removeFromParent();
	self.pLayer=nil;
end


function UserGuideLogic:creatLogic()

	self:newPlayerCreateLogic();	--开篇引导
	--系统引导
	if self.currentNewIndex == UserGuideLogic.stepOver then
		self:systemGuide_UQ_createLogic();
		self:systemGuide_eq_createLogic();
		self:systemGuide_map_createLogic();
		self:systemGuide_forging_createLogic();
		self:systemGuide_hero2_createLogic();
		self:systemGuide_upStar_createLogic();
		self:systemGuide_hero1_createLogic();
		self:systemGuide_lineUp_createLogic();
		self:systemGuide_chestBox_createLogic();
	end
end

function UserGuideLogic:touchLogic()
	self:newTouchLogic();	--开篇引导
	--系统引导
	if self.currentNewIndex == UserGuideLogic.stepOver then
		self:systemGuide_UQ_touchLogic();
		self:systemGuide_eq_touchLogic();
		self:systemGuide_map_touchLogic();
		self:systemGuide_forging_touchLogic();
		self:systemGuide_hero2_touchLogic();
		self:systemGuide_upStar_touchLogic();
		self:systemGuide_hero1_touchLogic();
		self:systemGuide_lineUp_touchLogic();
		self:systemGuide_chestBox_touchLogic();
	end
end


function UserGuideLogic:newPlayerCreateLogic()


	--表示新手已经全部过完
	if self.currentNewIndex == UserGuideLogic.stepOver then
		return;
	end


	--空表示玩家第一次进入游戏
	if self.currentNewIndex == nil then
		self.currentNewIndex = UserGuideLogic.step01;
		self:saveDate("new_guid")
	end


	--剧情
	if self.currentNewIndex == UserGuideLogic.step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	--第一次战斗
	elseif self.currentNewIndex == UserGuideLogic.step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			local iState = FightViewLogic:getInstance():GetFightGuideStage()
			if self.pLayer == nil and iState == 1 then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end
		end
	elseif self.currentNewIndex == UserGuideLogic.step021 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			local iState = FightViewLogic:getInstance():GetFightGuideStage()
			if self.pLayer == nil and iState == 2 then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end 
		end
	elseif self.currentNewIndex == UserGuideLogic.step022 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			local iState = FightViewLogic:getInstance():GetFightGuideStage()
			if self.pLayer == nil and iState==3 then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end
		end
	elseif self.currentNewIndex == UserGuideLogic.step023 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
			local iState = FightViewLogic:getInstance():GetFightGuideStage()
			if self.pLayer == nil and iState==4 then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end
		end		

	elseif self.currentNewIndex == UserGuideLogic.step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end
		end	
	elseif self.currentNewIndex == UserGuideLogic.step04 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil and me:GetLevel()>=3 then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
				FightViewLogic:getInstance().m_pLayer.m_pMainBtnLayer:SetUpBtnVisible(true);
			else

			end
		end
	elseif self.currentNewIndex == UserGuideLogic.step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end
		end	
	elseif self.currentNewIndex == UserGuideLogic.step06 then

	elseif self.currentNewIndex == UserGuideLogic.step07 then

	end

end


function UserGuideLogic:newTouchLogic()

	if self.currentNewIndex == UserGuideLogic.step01 then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.step04
	elseif self.currentNewIndex == UserGuideLogic.step02 then
		self:removeLayer();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 2})
		self.currentNewIndex = UserGuideLogic.step021
	elseif self.currentNewIndex == UserGuideLogic.step021 then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 3})
		self.currentNewIndex = UserGuideLogic.step022
		self:removeLayer();
	elseif self.currentNewIndex == UserGuideLogic.step022 then
		self:removeLayer();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 4})
		self.currentNewIndex = UserGuideLogic.step023
	elseif self.currentNewIndex == UserGuideLogic.step023 then
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.step03
	elseif self.currentNewIndex == UserGuideLogic.step03 then
		FightViewLogic:getInstance():closeLayer(true);
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.step04
	elseif self.currentNewIndex == UserGuideLogic.step04 then
		FightViewLogic:getInstance().m_pLayer.m_pMainBtnLayer:SwitchButtonState(1,true);
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.step05
	elseif self.currentNewIndex == UserGuideLogic.step05 then
		self:removeResTest();
		FightViewLogic:getInstance().m_pLayer.m_pMainBtnLayer:SwitchButtonState(-1);
		FightViewLogic:getInstance():closeLayer();
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.stepOver
	elseif self.currentNewIndex == UserGuideLogic.step06 then

	elseif self.currentNewIndex == UserGuideLogic.step07 then

	end
end


function UserGuideLogic:newTouchAnmaCallBack()
	if self.currentNewIndex == UserGuideLogic.step01 then
		self.currentNewIndex = UserGuideLogic.step02
		self:removeLayer();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 1})
	elseif self.currentNewIndex == UserGuideLogic.step02 then
		self:removeLayer();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 2})
		self.currentNewIndex = UserGuideLogic.step021
	elseif self.currentNewIndex == UserGuideLogic.step021 then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 3})
		self.currentNewIndex = UserGuideLogic.step022
		self:removeLayer();
	elseif self.currentNewIndex == UserGuideLogic.step022 then
		self:removeLayer();
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT, {true, 4})
		self.currentNewIndex = UserGuideLogic.step023
	elseif self.currentNewIndex == UserGuideLogic.step023 then
		self:removeLayer();	
		self.currentNewIndex = UserGuideLogic.step03
	end
end

function UserGuideLogic:newTouchIntroduceCallBack()
	if self.currentNewIndex == UserGuideLogic.step01 then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
		self:removeLayer();
		self.currentNewIndex = UserGuideLogic.step04
	end
end


-----------------------------------------------------------------------英雄升品系统
function UserGuideLogic:systemGuide_UQ_createLogic()

	if self.sys_uq ==1 then
		return;
	end


	--条件判定放在update里判定

	if self.currentSystemIndex == UserGuideLogic.sys_uq_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_uq_step00;
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step00 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step02 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step03 then  
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step04 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step06 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step07 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	end

end

function UserGuideLogic:systemGuide_UQ_touchLogic()
	
	if self.currentSystemIndex == UserGuideLogic.sys_uq_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_uq_step00		
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step00 then
		self:saveDate("sys_uq")
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_uq_step01
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step01 then 
		self:saveDate("sys_uq")
		KGC_MainViewLogic:getInstance():OpenHeroList();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_uq_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step02 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		pLayer:TouchEventHeroBaseInfo(self.pUQ_heroID);

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_uq_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step03 then 
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		pLayer.m_heroInfoLayer:TouchEventQuality(nil)

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_uq_step04
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step04 then  
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		pLayer.m_heroInfoLayer.m_reinforceLayer:TouchEventUpQuality()

		self:removeLayer();
		--self.currentSystemIndex = UserGuideLogic.sys_uq_step05
		self.currentSystemIndex = nil
		self.sys_uq =1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step05 then 
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		-- pLayer.m_heroInfoLayer.m_reinforceLayer:removeFromParent();

		-- self:removeLayer();
		-- -- self.currentSystemIndex = UserGuideLogic.sys_uq_step06
		-- self.currentSystemIndex = nil
		-- self.sys_uq =1;
		-- self:saveDate("sys_uq")
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step06 then
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		-- local pHerolayer = pLayer.m_heroInfoLayer
		-- pHerolayer.m_skillLayer =  KGC_HERO_SKILL_SUBLAYER:create(pHerolayer.m_pParent, {pHerolayer.m_heroObj});

		-- self.currentSystemIndex = UserGuideLogic.sys_uq_step07
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step07 then
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		-- local pHerolayer = pLayer.m_heroInfoLayer
		-- local pSkillLayer = pHerolayer.m_skillLayer;
		-- local pGroove = pSkillLayer:getIndexElement(pSkillLayer.pSkillList,1)
		-- local szItemName = "Panel_skillItem" .. 1;
		-- local skillItem = pGroove:getChildByName(szItemName);
		-- local Panel_button = skillItem:getChildByName("Panel_button")

		-- Panel_button:getChildByName("img_gou"):setVisible(true)
		-- pSkillLayer.m_hero:SwapSlotAt(Panel_button.cost,1,Panel_button.skill);		--设置技能
		-- pSkillLayer:LoadSkills(pSkillLayer.m_hero);

		-- self:removeLayer();
		-- self.currentSystemIndex = nil
		-- self.sys_uq =1;

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step10 then

	end

end


------------------------------------------------------------------穿装备系统
function UserGuideLogic:systemGuide_eq_createLogic()

	if self.sys_equi == 1 then
		return;
	end


	-- if self.currentSystemIndex == nil then
	-- 	if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
	-- 		if me:GetLevel()>=7 then 
	-- 			self.currentSystemIndex = UserGuideLogic.sys_equi_step00;
	-- 		end
	-- 	elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
	-- 		if me:GetLevel()>=7 then 
	-- 			self.currentSystemIndex = UserGuideLogic.sys_equi_step_a;
	-- 		end
	-- 	end
	-- end


	--步骤
	if self.currentSystemIndex == UserGuideLogic.sys_equi_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_equi_step00;
		end 		
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step00 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end		
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step01 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step03 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step04 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step05 then 
		
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step06 then 

	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step07 then 

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step10 then

	end
end

function UserGuideLogic:systemGuide_eq_touchLogic()
	if self.currentSystemIndex == UserGuideLogic.sys_equi_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_equi_step00			
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step00 then
		self:saveDate("sys_equi")		
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_equi_step01	
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step01 then 
		KGC_MainViewLogic:getInstance():OpenHeroList();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_equi_step02

	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step02 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		pLayer:AutoEquip();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_equi_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step03 then 
		KGC_HERO_LIST_LOGIC_TYPE:getInstance():closeLayer();
		
		self:removeLayer();
		self.sys_equi = 1;
		self.currentSystemIndex = nil;
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step04 then 
		-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE)
		-- self:removeLayer();
		-- self.currentSystemIndex = nil;
		-- self:saveDate("sys_equi")
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step05 then 

	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step06 then 

	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step07 then 	

	end

end


-------------------------------------------------------------------开启地图教学系统
function UserGuideLogic:systemGuide_map_createLogic()

	if self.sys_map ==1 then 
		return;
	end
	
	if me:GetLevel()>=3 then
		if self.currentSystemIndex == nil then 
			self.currentSystemIndex = UserGuideLogic.sys_map_step01
		end
	end



	if self.currentSystemIndex == UserGuideLogic.sys_map_step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02 then

		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAPCHOOSE then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02_01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step03 then

		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step06 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step07 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step10 then	

	end

end


function UserGuideLogic:systemGuide_map_touchLogic()

	if self.currentSystemIndex == UserGuideLogic.sys_map_step01 then
		self:saveDate("sys_map");		
		MapViewLogic:getInstance():openMap(1);
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_map_step02_01
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02 then

		MapViewLogic:getInstance():openMap(1);
		MapChooseLogic:getInstance():closeLayer();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_map_step02_01

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02_01 then


		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_map_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step03 then

		if MapViewLogic:getInstance().pLayer.role.isMoving ==false then
			MapViewLogic:getInstance().pLayer:touchIndexPos({x=7,y=11})
			self:removeLayer();
			self.currentSystemIndex = UserGuideLogic.sys_map_step04
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step04 then

			self:removeLayer();
			self.currentSystemIndex = UserGuideLogic.sys_map_step05

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step05 then
		if MapViewLogic:getInstance().pLayer.role.isMoving ==false then
			MapViewLogic:getInstance().pLayer:touchIndexPos({x=7,y=11})
			MapViewLogic:getInstance().pLayer.ObjectMaskLayer:removeAllFunctionInfoPanel();
			self:removeLayer();
			self.currentSystemIndex = nil;
			self.sys_map = 1;
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step06 then


	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step10 then

	end

end



------------------------------------------------------------------装备打造系统
function UserGuideLogic:systemGuide_forging_createLogic()

	if self.sys_forging ==1 then 
		return;
	end

	if me:GetLevel() >= 17 then 
		if self.currentSystemIndex == nil then 
			self.currentSystemIndex = UserGuideLogic.sys_forging_step_a;
		end
	end

	if self.currentSystemIndex == UserGuideLogic.sys_forging_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_forging_step00;
		end 
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step00 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end		
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FORGING then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FORGING then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FORGING then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step06 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step10 then

	end
end

function UserGuideLogic:systemGuide_forging_touchLogic()
	if self.currentSystemIndex == UserGuideLogic.sys_forging_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_forging_step00	

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step00 then
		self:saveDate("sys_forging")		
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_forging_step01
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step01 then
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FORGING)
		self:removeLayer();

		self.currentSystemIndex = UserGuideLogic.sys_forging_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step02 then
		local pLayer = ForgingLogic:getInstance().pLayer;
		pLayer:autoSelectOp();

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_forging_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step03 then
		local pLayer = ForgingLogic:getInstance().pLayer;
		pLayer:forging();

		self:removeLayer();
		self.currentSystemIndex = nil
		self.sys_forging = 1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step04 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step05 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step06 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step10 then

	end
end


----------------------------------------------------------------------装备升星和洗练
function UserGuideLogic:systemGuide_upStar_createLogic()

	if self.sys_upStar ==1 then 
		return;
	end

	--开启条件判定


	if me:GetLevel() >= 14 then 
		if self.currentSystemIndex == nil then 
			self.currentSystemIndex = UserGuideLogic.sys_upStar_step_a;
		end
	end

	if self.currentSystemIndex == UserGuideLogic.sys_upStar_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_upStar_step00;
		end 
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step00 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end			
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end			
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step06 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step07 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step08 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step10 then

	end
end

function UserGuideLogic:systemGuide_upStar_touchLogic()
	if self.currentSystemIndex == UserGuideLogic.sys_upStar_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_upStar_step00	
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step00 then
		self:saveDate("sys_upStar")
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_upStar_step01		
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step01 then
		KGC_MainViewLogic:getInstance():OpenHeroList();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_upStar_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step02 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		local pEquWidget = pLayer.m_pnlMain:getChildByName("img_headbg");
		pLayer:EquipTouchEvent(pEquWidget)
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_upStar_step03;

	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step03 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		local quInfoLayer = pLayer.m_quInfoLayer;
		local btnPick = quInfoLayer.m_pLayout:getChildByName("pnl_equip"):getChildByName("btn_pick")
		quInfoLayer:TouchEvent(btnPick)

		self.currentSystemIndex =UserGuideLogic.sys_upStar_step04;
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step04 then
		local pLayer = KGC_EQUIP_LOGIC_TYPE:getInstance().m_tbLayer[4];
		local btn = pLayer.m_tbPages[1]:getChildByName("pnl_main"):getChildByName("img_equipbg"):getChildByName("btn_equip_2");
		pLayer:AddEquip(btn);

		self.currentSystemIndex =sys_upStar_step05
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step05 then
		local pLayer = KGC_EQUIP_LOGIC_TYPE:getInstance().m_tbLayer[4];
		pLayer.m_chooseQuLayer:ItemTouchEvent(pLayer.m_chooseQuLayer.m_svEquips.firstEq)

		self.currentSystemIndex =UserGuideLogic.sys_upStar_step06;
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step06 then
		local pLayer = KGC_EQUIP_LOGIC_TYPE:getInstance().m_tbLayer[4];
		local pPanel = pLayer.m_tbPnlAttributes[2][1]

		local nGroup = pPanel._group;
		local tbGroup = pLayer.m_tbPnlAttributes[nGroup]
		pLayer:SelectedAttribute(tbGroup, pPanel);

		self.currentSystemIndex =UserGuideLogic.sys_upStar_step07;
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step07 then
		local pLayer = KGC_EQUIP_LOGIC_TYPE:getInstance().m_tbLayer[4];
		pLayer:EquipPickAttr();
		self.currentSystemIndex =nil
		self.sys_upStar=1;

	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step10 then

	end
end



-----------------------------------------------------------------------获得第一个英雄

function UserGuideLogic:systemGuide_hero1_createLogic()
	if self.sys_hero1 ==1 then 
		return;
	end

	--开启条件判定

	if me:GetLevel() >= 5 then
		if self.currentSystemIndex == nil then 
			self.currentSystemIndex = UserGuideLogic.sys_hero1_step_a;
		end
	end


	if self.currentSystemIndex == UserGuideLogic.sys_hero1_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_hero1_step00;
		end 
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step00 then
		if self.sceneManager:getCurrentLayerID()== GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end 
		end		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step01 then
		if self.sceneManager:getCurrentLayerID()== GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else

			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HANDBOOK then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HANDBOOK then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step04 then
		self.sys_hero1=1;
		self.currentSystemIndex = UserGuideLogic.sys_lineUp_step00 		--这一步完成之后直接进入布阵界面
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step05 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step06 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step10 then

	end


end

function UserGuideLogic:systemGuide_hero1_touchLogic()
	if self.currentSystemIndex == UserGuideLogic.sys_hero1_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero1_step00		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step00 then
		self:saveDate("sys_hero1")
		self:removeLayer();
		self.currentSystemIndex =  UserGuideLogic.sys_hero1_step01
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step01 then
		-- 打开界面上显示指定英雄
		KGC_MainViewLogic:getInstance():ReqHeroList(2, {UserGuideLogic.FirstHeroID});
		self:removeLayer();
		self.currentSystemIndex =  UserGuideLogic.sys_hero1_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step02 then
		KGC_HANDBOOK_LOGIC_TYPE:getInstance():ReqRollHero(UserGuideLogic.FirstHeroID);
		self:removeLayer();
		self.currentSystemIndex =  UserGuideLogic.sys_hero1_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step03 then
		KGC_HANDBOOK_LOGIC_TYPE:getInstance():closeLayer();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero1_step04 		--这一步完成之后直接进入布阵界面
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step04 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step05 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step06 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step10 then

	end
end


----------------------------------------------------------------------获得第二个新的英雄

function UserGuideLogic:systemGuide_hero2_createLogic()

	if self.sys_hero2 ==1 then
		return;
	end



	if me:GetLevel() >= 15 then
		if self.currentSystemIndex == nil then
			self.currentSystemIndex = UserGuideLogic.sys_hero2_step_a;
		end
	end

	if self.currentSystemIndex == UserGuideLogic.sys_hero2_step_a then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end			
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			self.currentSystemIndex = UserGuideLogic.sys_hero2_step02;
		end 	

	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step00 then
		-- if self.sceneManager:getCurrentLayerID()== GameSceneManager.LAYER_ID_MAIN then
		-- 	if self.pLayer == nil then
		-- 		self.pLayer = UserGuideLayer:create();
		-- 		self.pLayerParent:addChild(self.pLayer);
		-- 	else

		-- 	end 
		-- end		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step01 then
		-- if self.sceneManager:getCurrentLayerID()== GameSceneManager.LAYER_ID_MAIN then
		-- 	if self.pLayer == nil then
		-- 		self.pLayer = UserGuideLayer:create();
		-- 		self.pLayerParent:addChild(self.pLayer);
		-- 	else

		-- 	end 
		-- end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end	
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HANDBOOK then
			if self.pLayer == nil then
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HANDBOOK then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end 
		end	
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step06 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step07 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step08 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step09 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step10 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	end
end

function UserGuideLogic:systemGuide_hero2_touchLogic()

	if self.currentSystemIndex == UserGuideLogic.sys_hero2_step_a then
		MapViewLogic:getInstance():hideLayer()
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step02		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step00 then
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step01
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step01 then
		KGC_MainViewLogic:getInstance().pLayer:SetRightButton(KGC_MainViewLogic:getInstance().pLayer.m_BtnMenu);
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step02 then
		self:saveDate("sys_hero2")
		KGC_MainViewLogic:getInstance():ReqHeroList(2, {UserGuideLogic.SecondHeroID});
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step03
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step03 then
		KGC_HANDBOOK_LOGIC_TYPE:getInstance():ReqRollHero(UserGuideLogic.SecondHeroID);
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step04
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step04 then
		KGC_HANDBOOK_LOGIC_TYPE:getInstance():closeLayer();
		self:removeLayer();
		
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step05;
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step05 then
		KGC_MainViewLogic:getInstance():OpenHeroList();

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step06;		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step06 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		-- pLayer.m_lineUpLayer = KGC_HERO_LINEUP_SUBLAYER_TYPE:create(pLayer);
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP);

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step07;	
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step07 then
		local pLayer = KGC_LINEUP_LOGIC_TYPE:getInstance().m_pLayer;
		local szName = "pnl_hero" .. 3;
		local pnlHero = pLayer.m_pnlMain:getChildByName(szName);
		pLayer:TouchHero(pnlHero);

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_hero2_step08;	
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step08 then
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		local pLayer = KGC_LINEUP_LOGIC_TYPE:getInstance().m_pLayer;
		local heroPanel=nil;
		for k,v in pairs(pLayer.m_svHeroList:getChildren()) do
			if v._hero_id == UserGuideLogic.SecondHeroID then 
				heroPanel = v;
			end
		end
		pLayer:TouchHero(heroPanel);		

		self:removeLayer();
		self.currentSystemIndex = nil;
		self.sys_hero2=1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step09 then

		-- self:removeLayer();
		-- self.currentSystemIndex = nil;
		-- self.sys_hero2=1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step10 then

	end
end


---------------------------------------------------------------------阵容上阵教学
function UserGuideLogic:systemGuide_lineUp_createLogic()
	if self.sys_lineUp ==1 then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_lineUp_step00 then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step03 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_HEROINFO then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step06 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAIN then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end

		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step10 then

	end

end

function UserGuideLogic:systemGuide_lineUp_touchLogic()
	if self.currentSystemIndex == UserGuideLogic.sys_lineUp_step00 then
		self:saveDate("sys_lineUp")		
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_lineUp_step01
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step01 then
		KGC_MainViewLogic:getInstance():OpenHeroList();
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_lineUp_step02
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step02 then
		local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		-- pLayer.m_lineUpLayer = KGC_HERO_LINEUP_SUBLAYER_TYPE:create(pLayer);
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_LINEUP);

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_lineUp_step03

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step03 then
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		local pLayer = KGC_LINEUP_LOGIC_TYPE:getInstance().m_pLayer;
		local szName = "pnl_hero" .. 1;
		local pnlHero = pLayer.m_pnlMain:getChildByName(szName);
		pLayer:TouchHero(pnlHero);

		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_lineUp_step04;
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step04 then
		-- local pLayer = KGC_HERO_LIST_LOGIC_TYPE:getInstance().m_pLayer;
		local pLayer = KGC_LINEUP_LOGIC_TYPE:getInstance().m_pLayer;
		local heroPanel=nil;
		for k,v in pairs(pLayer.m_svHeroList:getChildren()) do
			if v._hero_id == UserGuideLogic.FirstHeroID then 
				heroPanel = v;
			end
		end
		-- pLayer.m_lineUpLayer:TouchHero(heroPanel);
		pLayer:TouchHero(heroPanel);
		
		self:removeLayer();
		self.currentSystemIndex = nil;
		self.sys_lineUp =1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step05 then
		-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_MAPCHOOSE)
		-- self:removeLayer();
		-- self.currentSystemIndex = UserGuideLogic.sys_lineUp_step06;
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step06 then
		-- self:removeLayer();
		-- self.currentSystemIndex = nil;
		-- self.sys_lineUp =1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step10 then

	end
end

--------------------------------------------------------------挂机点指引
function UserGuideLogic:systemGuide_hookPoint_createLogic()
	if self.sys_hookPoint ==1 then 
		return;
	end


	if self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint01 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint02 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint03 then

		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint04 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end	
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint05 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint06 then

		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint10 then	

	end

end


function UserGuideLogic:systemGuide_hookPoint_touchLogic()

	if self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint01 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint02 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint03 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint04 then
	
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint05 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint06 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint07 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint08 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint09 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint10 then	

	end

end




----------------------------------------------------------------------宝箱指引
function UserGuideLogic:systemGuide_chestBox_createLogic()
	 if UserGuideLogic.sys_chestBox == 1 then 
	 	return;
	 end

	if self.currentSystemIndex == UserGuideLogic.sys_chestBox_000  then 
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);				
			end
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_001 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_MAP then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		elseif self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			self.currentSystemIndex = UserGuideLogic.sys_chestBox_002;
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_002 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_003 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end		

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_004 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end		

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_005 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end			

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_006 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end			

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_007 then
		if self.sceneManager:getCurrentLayerID() == GameSceneManager.LAYER_ID_FIGHT then
			if self.pLayer == nil then 
				self.pLayer = UserGuideLayer:create();
				self.pLayerParent:addChild(self.pLayer);
			else
				
			end
		end			

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_008 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_009 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_010 then


	end

end


function UserGuideLogic:systemGuide_chestBox_touchLogic()

	if self.currentSystemIndex == UserGuideLogic.sys_chestBox_000 then
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_chestBox_001
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_001 then
		self:saveDate("sys_chestBox");
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_FIGHT)
		self:removeLayer();
		self.currentSystemIndex = UserGuideLogic.sys_chestBox_002
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_002 then
		FightViewLogic:getInstance().m_pLayer:GetRewardMore();

		self:removeLayer();
		self.currentSystemIndex =nil
		self.sys_chestBox=1;
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_003 then


	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_004 then


	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_005 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_006 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_007 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_008 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_009 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_010 then


	end
end










function UserGuideLogic:removeResTest()
	
	fun_removeAnimationCache(self.animationTab);
	fun_removeTextureAndFrameCache(self.textureTab);


end


function UserGuideLogic:addEffectName(sName,nEffID)
	if self.animationTab== nil then 
		self.animationTab={};
	end

	table.insert(self.animationTab,sName);

	if self.effectConfig == nil then
		self.effectConfig = mconfig.loadConfig("script/cfg/client/effect");
	end 

	local _tb = self.effectConfig[tostring(nEffID)].texture
	if _tb ~=nil then 
		for k,v in pairs(_tb) do
			self:addTextName(v);
		end
	end

end


function UserGuideLogic:addTextName(sName)
	if self.textureTab ==nil then 
		self.textureTab={};
	end

	table.insert(self.textureTab,sName);
end