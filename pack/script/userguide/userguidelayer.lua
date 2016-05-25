require("script/class/class_base_ui/class_base_layer")
require("script/ui/publicview/storyanimationlayer")
require("script/ui/publicview/IntroduceLayer")
require("script/core/configmanager/configmanager");

local guidetalkFile = mconfig.loadConfig("script/cfg/client/guidetalk");

local USER_GUIDE_LAYER_TB={
	currentNewIndex =nil,
	currentSystemIndex =nil,
	pAnimationLayer =nil,		--动画层
	pChildNode =nil,
}

UserGuideLayer = class("UserGuideLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end,USER_GUIDE_LAYER_TB)


function UserGuideLayer:create()
	self = UserGuideLayer.new();
	self.currentNewIndex = UserGuideLogic:getInstance().currentNewIndex;
	self.currentSystemIndex =  UserGuideLogic:getInstance().currentSystemIndex;
    self:initAttr();
	return self;
end

function UserGuideLayer:ctor()
 
	self.pChildNode = cc.Node:create();
	self:addChild(self.pChildNode);

	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/userguide.json")
    self:addChild(self.pWidget)
    self.pWidget:setGlobalZOrder(100)

end


function UserGuideLayer:initAttr()
	self:initAttr_new();
	self:initAttr_UQ();
	self:initAttr_eq();
	self:initAttr_map();
	self:initAttr_forging();
	self:initAttr_upStar();
	self:initAttr_hero1();
	self:initAttr_hero2();
	self:initAttr_lineUp();
	self:initAttr_hookPoint();
	self:initAttr_chestBox();
end

function UserGuideLayer:initAttr_new()
	if self.currentNewIndex == UserGuideLogic.step01 then 
		self:setNoTouch();
		self.pChildNode:addChild(IntroduceLayer:create(handler(UserGuideLogic:getInstance(), UserGuideLogic:getInstance().newTouchIntroduceCallBack)))
		self:setDialog(nil);
	elseif self.currentNewIndex == UserGuideLogic.step02 then
		self:setAllScreenTouch();
		self:setDialog("每一场战斗结束后，都会自动搜索敌人，战斗不会因为任何原因而终止");
	elseif self.currentNewIndex == UserGuideLogic.step021 then 
		self:setDialog(nil);
		local fnCall = function()
			UserGuideLogic:getInstance():touchLogic();
		end
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnCall)));
	elseif self.currentNewIndex == UserGuideLogic.step022 then 
		self:setNoTouch();
		self:addAnimation("res","animation02.json","Animation0",UserGuideLogic:getInstance().newTouchAnmaCallBack,UserGuideLogic:getInstance());
		self:setDialog(nil);
	elseif self.currentNewIndex == UserGuideLogic.step023 then
		self:setNoTouch();
		self:addAnimation("res","animation03.json","Animation0",UserGuideLogic:getInstance().newTouchAnmaCallBack,UserGuideLogic:getInstance());
		self:setDialog(nil);
	elseif self.currentNewIndex == UserGuideLogic.step03 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[1].words);
	elseif self.currentNewIndex == UserGuideLogic.step04 then 
		self:setPointTouch(cc.p(370,65));
	elseif self.currentNewIndex == UserGuideLogic.step05 then 
		self:setPointTouch(cc.p(98,56));
	elseif self.currentNewIndex == UserGuideLogic.step06 then
		self:setPointTouch(cc.p(656,1172));
	elseif self.currentNewIndex == UserGuideLogic.step07 then
		self:setPointTouch(cc.p(600,25));
	end
end

--英雄生品
function UserGuideLayer:initAttr_UQ()
	if self.currentSystemIndex==nil then 
		return;
	end
	if self.currentSystemIndex == UserGuideLogic.sys_uq_step_a then
		self:setPointTouch(cc.p(82,1279));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step00 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[6].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step01 then 
		self:setPointTouch(cc.p(227,62));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step02 then
		self:setPointTouch(cc.p(375,757));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step03 then 
		self:setPointTouch(cc.p(270,720));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step04 then  
		self:setPointTouch(cc.p(375,181));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step05 then 
		self:setPointTouch(cc.p(375,266));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step06 then
		self:setPointTouch(cc.p(342,867));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step07 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_uq_step08 then
		self:setPointTouch(cc.p(100,450));
	end
end

--穿装备
function UserGuideLayer:initAttr_eq()
	if self.currentSystemIndex==nil then 
		return;
	end
	if self.currentSystemIndex == UserGuideLogic.sys_equi_step_a then
		self:setPointTouch(cc.p(82,1279));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step00 then 
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[5].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step01 then 
		self:setPointTouch(cc.p(230,60));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step02 then
		self:setPointTouch(cc.p(647,468));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step03 then 
		self:setPointTouch(cc.p(87,1280));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step04 then 
		self:setPointTouch(cc.p(530,67));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step05 then 
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step06 then 
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_equi_step07 then 	
		self:setPointTouch(cc.p(100,450));
	end
end


--f地图
function UserGuideLayer:initAttr_map()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_map_step00 then

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step01 then
		self:setPointTouch(cc.p(510,56));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02 then
		self:setPointTouch(cc.p(600,350));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step02_01 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[2].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step03 then
		self:setPointTouch(cc.p(308,228));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step04 then
		self:setAllScreenTouch();
		self:setDialog("行走需要消耗步数");
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step05 then
		self:setPointTouch(cc.p(360,700));
		
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step06 then
		self:setPointTouch(cc.p(604,776));

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step07 then
		self:setPointTouch(cc.p(450,676));

	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step08 then
		self:setPointTouch(cc.p(84,1288));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step09 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_step10 then	
		self:setPointTouch(cc.p(100,450));
	end
end

--锻造
function UserGuideLayer:initAttr_forging()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_forging_step_a then
		self:setPointTouch(cc.p(82,1279));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step00 then 
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[7].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step01 then
		self:setPointTouch(cc.p(690,894));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step02 then
		self:setPointTouch(cc.p(223,198));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step03 then
		self:setPointTouch(cc.p(526,198));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step04 then
		self:setPointTouch(cc.p(87,1280));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step05 then
		self:setPointTouch(cc.p(509,55));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step06 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step07 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step08 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step09 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_forging_step10 then
		self:setPointTouch(cc.p(100,450));
	end
end


--升星和淬炼]
function UserGuideLayer:initAttr_upStar()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_upStar_step_a then
		self:setPointTouch(cc.p(82,1279));	
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step00 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[8].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step01 then
		self:setPointTouch(cc.p(220,70));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step02 then
		self:setPointTouch(cc.p(434,383));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step03 then
		self:setPointTouch(cc.p(200,853));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step04 then
		self:setPointTouch(cc.p(575,960));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step05 then
		self:setPointTouch(cc.p(250,900));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step06 then
		self:setPointTouch(cc.p(444,680));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step07 then
		self:setPointTouch(cc.p(375,222));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step08 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step09 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_upStar_step10 then
		self:setPointTouch(cc.p(100,450));
	end

end

--第一次获得英雄
function UserGuideLayer:initAttr_hero1()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_hero1_step_a then
		self:setPointTouch(cc.p(82,1279));		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step00 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[3].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step01 then
		self:setPointTouch(cc.p(685,1008));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step02 then
		self:setPointTouch(cc.p(375,785));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step03 then
		self:setPointTouch(cc.p(371,347));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step04 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step05 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step06 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step07 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step08 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step09 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero1_step10 then
		self:setPointTouch(cc.p(100,450));
	end
end

--第二次获取英雄
function UserGuideLayer:initAttr_hero2()
	if self.currentSystemIndex==nil then 
		return;
	end
	if self.currentSystemIndex == UserGuideLogic.sys_hero2_step_a then
		self:setPointTouch(cc.p(82,1279));		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step00 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[9].words);		
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step01 then
		self:setPointTouch(cc.p(685,1012));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step02 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step03 then
		self:setPointTouch(cc.p(375,785));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step04 then
		self:setPointTouch(cc.p(365,350));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step05 then
		self:setPointTouch(cc.p(230,62));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step06 then
		self:setPointTouch(cc.p(374,533));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step07 then
		self:setPointTouch(cc.p(583,1039));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step08 then
		self:setPointTouch(cc.p(455,636));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step09 then
		self:setPointTouch(cc.p(690,1175));
	elseif self.currentSystemIndex == UserGuideLogic.sys_hero2_step10 then
		self:setPointTouch(cc.p(100,450));
	end
end


--阵容教学
function UserGuideLayer:initAttr_lineUp()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_lineUp_step00 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[4].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step01 then
		self:setPointTouch(cc.p(230,60));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step02 then
		self:setPointTouch(cc.p(374,533));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step03 then
		self:setPointTouch(cc.p(163,989));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step04 then
		self:setPointTouch(cc.p(293,642));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step05 then
		self:setPointTouch(cc.p(690,1175));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step06 then
		self:setPointTouch(cc.p(530,67));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step07 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step08 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step09 then
		self:setPointTouch(cc.p(100,450));
	elseif self.currentSystemIndex == UserGuideLogic.sys_lineUp_step10 then
		self:setPointTouch(cc.p(100,450));
	end
end


--挂机点教学
function UserGuideLayer:initAttr_hookPoint()
	if self.currentSystemIndex==nil then 
		return;
	end


	if self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint01 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint02 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint03 then
		self:setPointTouch(cc.p(375,785));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint04 then
		self:setPointTouch(cc.p(690,1175));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint05 then
		self:setPointTouch(cc.p(220,73));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint06 then
		self:setPointTouch(cc.p(374,533));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint07 then
		self:setPointTouch(cc.p(583,1039));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint08 then
		self:setPointTouch(cc.p(419,642));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint09 then
		self:setPointTouch(cc.p(690,1175));
	elseif self.currentSystemIndex == UserGuideLogic.sys_map_hookpoint10 then
		self:setPointTouch(cc.p(100,450));
	end
end


--战斗宝箱教学
function UserGuideLayer:initAttr_chestBox()
	if self.currentSystemIndex==nil then 
		return;
	end

	if self.currentSystemIndex == UserGuideLogic.sys_chestBox_000 then
		self:setAllScreenTouch();
		self:setDialog(guidetalkFile[10].words);
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_001 then
		self:setPointTouch(cc.p(370,65));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_002 then
		self:setPointTouch(cc.p(60,1270));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_003 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_004 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_005 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_006 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_007 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_008 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_009 then
		self:setPointTouch(cc.p(679,1020));
	elseif self.currentSystemIndex == UserGuideLogic.sys_chestBox_010 then
		self:setPointTouch(cc.p(679,1020));
	end

end


function UserGuideLayer:addAnimation(filePath,fileName,animationName,callBack,callBackClass)
	self.pAnimationLayer = StoryAnimationLayer:create(filePath,fileName,animationName,callBack,callBackClass);
	self.pChildNode:addChild(self.pAnimationLayer);
end

function UserGuideLayer:setDialog(szDialog)
	local pnlPointTouch = self.pWidget:getChildByName("Panel_pointTouch")
	pnlPointTouch:setVisible(false)
	pnlPointTouch:setScale(0.001)
	
	local pnlAllTouch = self.pWidget:getChildByName("Panel_allTouch")
	local lblDialog = pnlAllTouch:getChildByName("lbl_dialog");
	local panelImg = pnlAllTouch:getChildByName("Panel_img");

	if not lblDialog then
		return;
	end
	if szDialog then
		panelImg:setVisible(true);
		lblDialog:setVisible(true);
		lblDialog:setString(szDialog);
	else
		lblDialog:setVisible(false);
		panelImg:setVisible(false);
	end
end

function UserGuideLayer:setNoTouch()
	local Panel_allTouch = self.pWidget:getChildByName("Panel_allTouch")
	local Panel_pointTouch = self.pWidget:getChildByName("Panel_pointTouch")
	Panel_pointTouch:setVisible(false)
	Panel_pointTouch:setScale(0.001)
	Panel_allTouch:setVisible(false)
	Panel_allTouch:setScale(0.001)
end


function UserGuideLayer:setAllScreenTouch()
	local Panel_allTouch = self.pWidget:getChildByName("Panel_allTouch")
	local Panel_pointTouch = self.pWidget:getChildByName("Panel_pointTouch")
	Panel_pointTouch:setVisible(false)
	Panel_pointTouch:setScale(0.001)

	local function fun_touch(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            UserGuideLogic:getInstance():touchLogic();
        end
    end

	Panel_allTouch:addTouchEventListener(fun_touch)
	Panel_allTouch:setGlobalZOrder(1000)
end


function UserGuideLayer:setPointTouch(pos)
	local Panel_pointTouch = self.pWidget:getChildByName("Panel_pointTouch")
	local Panel_allTouch = self.pWidget:getChildByName("Panel_allTouch")
	Panel_allTouch:setVisible(false)
	Panel_allTouch:setScale(0.001)

	local function fun_touch(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            UserGuideLogic:getInstance():touchLogic();
        end
    end

	local Panel_touch = Panel_pointTouch:getChildByName("Panel_touch")
	Panel_touch:setPosition(cc.p(pos.x-50,pos.y-50))
	Panel_touch:addTouchEventListener(fun_touch);
	Panel_touch:setGlobalZOrder(1000)


	local jingling = sp.SkeletonAnimation:create("res/ANI/model/hero/action_hero_jingling_01/action_hero_jingling_01.json", 
                                                    "res/ANI/model/hero/action_hero_jingling_01/action_hero_jingling_01.atlas", 1);
	jingling:setAnimation(0, "standby", true)
	jingling:setPosition(cc.p(50,50))
	Panel_touch:addChild(jingling);

	local  quan = Panel_touch:getChildByName("img_star");
	quan:runAction(cc.RepeatForever:create(cc.RotateBy:create(3.0,360)));

end
