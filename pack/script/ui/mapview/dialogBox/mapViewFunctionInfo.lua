
require("script/core/configmanager/configmanager");
local monsterBoxFile=mconfig.loadConfig("script/cfg/battle/monsterbox");
local monsterFile =mconfig.loadConfig("script/cfg/battle/monster");
local modelFile = mconfig.loadConfig("script/cfg/client/model");
local rewardFile = mconfig.loadConfig("script/cfg/pick/drop");
local itemFile = mconfig.loadConfig("script/cfg/pick/item");
local goldIconFile = mconfig.loadConfig("script/cfg/client/icon");
local signFile = mconfig.loadConfig("script/cfg/map/sign")

require("script/ui/publicview/EquipInfoTips");


local TB_MAP_VIEW_FUNCTION_INFO={
	
	functionChooseLayer = nil,

	pButtonItem 	=	nil,		--远程按钮
	pNeedItem  		=	nil,		--需求
	pRewardItem 	=	nil,		--奖励
	pDropItem 		=	nil,		--掉落
	pEnemeyItem 	=	nil,		--的敌人

	pLab_name,			--名字
	panel_info,			--信息
	panel_need,			--需求
	panel_type02,		--类型2
	panel_button,		--按钮
	panel_enemy,

	iType,			--类型参数
	buttonTab,		--按钮

	elementIndexPos =nil,		--元素位置
	element,					--元素

	sTextInfo =nil,		--文字信息
}



MapViewFunctionInfo = class("MapViewFunctionInfo",function()
	return cc.Node:create()
end,TB_MAP_VIEW_FUNCTION_INFO)

function MapViewFunctionInfo:create(functionChooseLayer)
	self = MapViewFunctionInfo.new();
	self.functionChooseLayer = functionChooseLayer;
	self:initBaseAttr();
	return self;
end

function MapViewFunctionInfo:ctor()


end

function MapViewFunctionInfo:OnExit()
	self:cleanDate()
end

function MapViewFunctionInfo:cleanDate()
	if pButtonItem ~=nil then 
		self.pButtonItem:release()
		self.pButtonItem = nil;
	end

	if pNeedItem ~= nil then 
		self.pNeedItem:release()
		self.pNeedItem = nil;
	end

	if pRewardItem ~= nil then 
		self.pRewardItem:release()
		self.pRewardItem = nil;
	end

	if pDropItem ~= nil then 
		self.pDropItem:release()
		self.pDropItem = nil;
	end

	if pEnemeyItem ~= nil then 
		self.pEnemeyItem:release()
		self.pEnemeyItem = nil;
	end
end

function MapViewFunctionInfo:initBaseAttr()


	if self.pWidget == nil then 
		self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewFCInfoPanel.json")
	    self.pWidget:setPositionX(-375);
	    self:addChild(self.pWidget)

	end

	--名称
	self.pLab_name=self.pWidget:getChildByName("lab_name");
	self.pLab_name.orgPos = cc.p(self.pLab_name:getPositionX(),self.pLab_name:getPositionY())
	--内容
	self.panel_info = self.pWidget:getChildByName("Panel_text");
	self.panel_info.orgPos = cc.p(self.panel_info:getPositionX(),self.panel_info:getPositionY())	
	--需要
	self.panel_need = self.pWidget:getChildByName("Panel_need");
	self.panel_need.orgPos = cc.p(self.panel_need:getPositionX(),self.panel_need:getPositionY())	
	--按钮
	self.panel_button = self.pWidget:getChildByName("Panel_button");
	self.panel_button.orgPos = cc.p(self.panel_button:getPositionX(),self.panel_button:getPositionY())	
	
	--类型2
	self.panel_type02 = self.pWidget:getChildByName("Panel_type2");
	self.panel_type02.orgPos = cc.p(self.panel_type02:getPositionX(),self.panel_type02:getPositionY())		

	--敌人
	self.panel_enemy =self.panel_type02:getChildByName("Panel_enemy");
	self.panel_enemy.orgPos = cc.p(self.panel_enemy:getPositionX(),self.panel_enemy:getPositionY())


    self.pButtonItem = self.panel_button:getChildByName("btn_item")
    self.pButtonItem:retain()
    self.pButtonItem:removeFromParent()

    self.pNeedItem = self.panel_need:getChildByName("Panel_itme");
    self.pNeedItem:retain()
    self.pNeedItem:removeFromParent()
 

    self.pEnemeyItem = self.panel_enemy:getChildByName("Panel_enemyItem");
    self.pEnemeyItem:retain();
    self.pEnemeyItem:removeFromParent();



end

function MapViewFunctionInfo:updaetAttr()
	self.panel_need:setPosition(self.panel_need.orgPos);
	self.panel_info:setPosition(self.panel_info.orgPos);
	self.panel_type02:setPosition(self.panel_type02.orgPos);
	self.panel_enemy:setPosition(self.panel_enemy.orgPos);
	self.panel_button:setPosition(self.panel_button.orgPos);

	self.panel_need:setVisible(true);
	self.panel_info:setVisible(true);
	self.panel_type02:setVisible(true);
	self.panel_enemy:setVisible(true);
	self.panel_button:setVisible(true);

end



function MapViewFunctionInfo:setInfo(var,iType)

	if var==nil then 
		return;
	end

	self.element = var;
	self.iType = iType;
	self.buttonTab = buttonTab;

	self:updaetAttr();

	self.panel_button:removeAllChildren();
	self.panel_enemy:getChildByName("list"):removeAllChildren();

	self.elementIndexPos = var.indexPos;

	--需求(前置条件)
	self:setNeed(var)
	--名字
	self:setName(var)
	--类型
	self:setPanel(iType)
end


function MapViewFunctionInfo:setPanel(iType)
	if iType == MapViewElementBase.INFO_PANEL_TYPE01 then 
		--self:setType01(self.element);
	elseif iType == MapViewElementBase.INFO_PANEL_TYPE02 then
		self:setType02(self.element);
	elseif  iType == MapViewElementBase.INFO_PANEL_TYPE03 then
		self:setType03(self.element);
	end
end

function MapViewFunctionInfo:setName(var)
	self.pLab_name:setString(var:getNameString())

end

function MapViewFunctionInfo:setTextInfo(sInfo)
	self.textInfo = sInfo;
	--内容
	self:setText()
end

function MapViewFunctionInfo:setText()
	if self.textInfo==nil then
		self.textInfo=""
	end
	self.panel_info:getChildByName("lab_info"):setString(self.textInfo)
end




function MapViewFunctionInfo:setType02(var)

	local monsterboxid = self:getMonsterDispalyID(var);

	if monsterboxid== nil then 
		return;
	end

	local posID = monsterBoxFile[(monsterboxid)].Pos5
	local modelid = monsterFile[(posID)].modelid
	local iconPath = modelFile[modelid].icon_square
	local fightValue =monsterBoxFile[(monsterboxid)].FightingForce

	local _enemy = self.pEnemeyItem:clone();
	self.panel_enemy:getChildByName("list"):addChild(_enemy);
	_enemy:getChildByName("img_icon"):loadTexture(iconPath)

	--战斗力
	local fightPanel =  self.panel_enemy:getChildByName("Panel_fight");
	local fightlab_text = fightPanel:getChildByName("lab_text")
	fightlab_text:setString(fightValue);

	self:setFightValueColor(fightValue);
end

function MapViewFunctionInfo:setFightValueColor(fightValue)
	local fightPanel =  self.panel_enemy:getChildByName("Panel_fight");
	fightPanel:setVisible(true);
	--战力颜色
	local playerFight =  me:GetFightPoint()
	local iType = playerFight/fightValue

	local pColor = nil;
	if iType >1.3 then 
		pColor = cc.c3b(0,255,0);
	elseif iType <=1.3 and iType>0.8 then
		pColor = cc.c3b(240,226,192);
	elseif iType <=0.8 then
		pColor = cc.c3b(255,0,0);
	end

	if pColor ~=nil then
		local fightlab_text = fightPanel:getChildByName("lab_text")
		fightlab_text:setColor(pColor);
	end

end


function MapViewFunctionInfo:setType03(var)
	self.panel_type02:setVisible(false);
	self.panel_info:setPositionX(self.panel_info:getPositionX()-90);
	local lab_info = self.panel_info:getChildByName("lab_info");
	lab_info:setContentSize(cc.size(450,95));
end


function MapViewFunctionInfo:setButtones(buttonTab,textTab)

	local functionName=nil;
	local function function_ok(sender,event)
	    if event == ccui.TouchEventType.ended then
        	functionName(self.functionChooseLayer,sender.element)
        	self:closeLayer()
        end
    end

	if buttonTab ~= nil then
		for j,btVar in pairs(buttonTab) do
			local btn = self.pButtonItem:clone()
			self.panel_button:addChild(btn)
			--位置
			btn:setPositionX(btn:getPositionX()+(j-1)*150)
			--点击事件
			btn:addTouchEventListener(function_ok)
			btn.element = self.element;
			functionName = self:getFunction(btVar) ---函数名
			--按钮文字
			if textTab ~=nil then 
				local textInfo = textTab[j]
				if textInfo ~= nil then
					btn:setTitleText(textInfo)
				end
			end
			
		end
	end
end

function MapViewFunctionInfo:setNeedDisplay(bRet)
	self.panel_need:setVisible(bRet);	
end


function MapViewFunctionInfo:setNeed(var)
	self.panel_need:setVisible(false);		
	--if var.pConfig.Precondition == nil then 
	--	self.panel_need:setVisible(false);		
	--else
		--for k,v in pairs(var.pConfig.Precondition) do
			-- local iType =v[1];
			-- local iPref = v[2];

			-- --只显示战斗力的需求
			-- if iType ==2 then
			-- 	local needPanel =self.pNeedItem:clone();
			-- 	needPanel:setPositionX(needPanel:getPositionX()+(k-1)*140)
			-- 	self.panel_need:addChild(needPanel)

			-- 	local pText = needPanel:getChildByName("lab_text")
			-- 	local pImg = needPanel:getChildByName("img_icon");

			-- 	if iType == 1 then 				--团队等级 
			-- 		pImg:loadTexture(goldIconFile[7].iconpath)
			-- 		pText:setString(iPref)
			-- 	elseif iType ==2 then 			--战斗力
			-- 		pImg:loadTexture(goldIconFile[6].iconpath)
			-- 		pText:setString(iPref)
			-- 	elseif iType == 3 then 			--标记(任务道具)
			-- 		pText:setString("1");
			-- 		local pConfig = signFile[iPref];
			-- 		pImg:loadTexture(pConfig.Pic);
			-- 		pText:setString(pConfig.Name)
			-- 	end
			-- end
		--end
	--end

end

function MapViewFunctionInfo:setDate(bHoke,sText1,bRew,sText2)
	local Panel_date = self.pWidget:getChildByName("Panel_date")
	local img_guaji = Panel_date:getChildByName("img_guaji");
	local img_jiangli = Panel_date:getChildByName("img_jiangli");
	Panel_date:setVisible(true);
	if bHoke == true then 			--挂机
		img_guaji:setVisible(true);
	end
	
	if bRew ==true then 		--奖励
		img_jiangli:setVisible(true);
	end

	if type(sText1)=="string" then
		local lab_text= img_guaji:getChildByName("lab_text")
		lab_text:setString(sText1);
	end

	if type(sText2)=="string" then
		local lab_text= img_jiangli:getChildByName("lab_text")
		lab_text:setString(sText2);
	end
	


end


function MapViewFunctionInfo:getMonsterDispalyID(var)
	if var.subType == MapViewElementBase.TYPE_HOOK_NORMAL then 
		return var.pConfig.Boss;
	elseif var.subType == MapViewElementBase.TYPE_HOOK_AtONCE then 
		return var.pConfig.BossLimit;
	elseif var.subType == MapViewElementBase.TYPE_ENEMY_CONTINUOUS then
		return var.pConfig.Monster[1];
	end

	return var.pConfig.Monster;

end


function MapViewFunctionInfo:getFunction(var)
	return self.functionChooseLayer:getFunctionWithType(var) ---函数名
end

function MapViewFunctionInfo:getElementIndexPos()
	return self.elementIndexPos;
end

--设置名字颜色//
function MapViewFunctionInfo:setNameTextColor(rgb)
	self.pLab_name:setColor(rgb)
end



---道具提示
function MapViewFunctionInfo:addItemTips(id)
	local propTips = PropsAttrTips:create(id);
	self:addChild(propTips);
end



---打开新窗口
function MapViewFunctionInfo:addNewViewButton(string)

	local function function_ok(sender,event)
	    if event == ccui.TouchEventType.ended then
	    	local pLayer = self.element:getEnterFunctionSub(self.functionChooseLayer)
	    	if pLayer ~= nil then
	    		self.functionChooseLayer:addNewDialogBoxNodeWithNotClean(pLayer)
	    		self:closeLayer();
	    	end
        end
    end

    local btn = self.pButtonItem:clone()
	self.panel_button:addChild(btn)
	--位置
	btn:setPositionX(btn:getPositionX()+(1-1)*150)
	--点击事件
	btn:addTouchEventListener(function_ok)
	if string~=nil then 
		btn:setTitleText(string)
	end
	
end


--添加动画
function MapViewFunctionInfo:addFadeAnimation(fTime)
	self:textAnimation(self.pLab_name,fTime);
	self:textAnimation(self.panel_info:getChildByName("lab_info"),fTime);
end

--动画测试
function MapViewFunctionInfo:textAnimation(pText,fTime)
	fTime=fTime*0.8
	pText:setOpacity(0);
	local pFadeAction  = cc.FadeIn:create(0.3);
	local pDealy = cc.DelayTime:create(fTime);
	pText:runAction(cc.Sequence:create(pDealy,pFadeAction));
end