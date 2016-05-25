--走进触发功能
require("script/core/configmanager/configmanager");
local monsterBoxFile=mconfig.loadConfig("script/cfg/battle/monsterbox");
local monsterFile =mconfig.loadConfig("script/cfg/battle/monster");
local modelFile = mconfig.loadConfig("script/cfg/client/model");
local rewardFile = mconfig.loadConfig("script/cfg/pick/drop");
local itemFile = mconfig.loadConfig("script/cfg/pick/item");
local goldIconFile = mconfig.loadConfig("script/cfg/client/icon");
local signFile = mconfig.loadConfig("script/cfg/map/sign");

require("script/ui/publicview/EquipInfoTips");


local TB_MAP_VIEW_DIALOG_DETAIL_INFO={
	
	functionChooseLayer = nil,

	pButtonItem 	=	nil,		--远程按钮
	pNeedItem  		=	nil,		--需求
	pRewardItem 	=	nil,		--奖励
	pDropItem 		=	nil,		--掉落
	pEnemeyItem 	=	nil,		--的敌人

	pLab_name,			--名字
	panel_info,			--信息
	panel_need,			--需求
	panel_type01,		--类型1
	panel_type02,		--类型2
	panel_button,		--按钮
	panel_reward,
	panel_drop,
	panel_enemy,

	iType,		--类型参数
	buttonTab,		--按钮

	elementIndexPos =nil,		--元素位置
	element,		--元素

	sTextInfo =nil,		--文字信息
}



MapViewDialogDetailInfo = class("MapViewDialogDetailInfo",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end,TB_MAP_VIEW_DIALOG_DETAIL_INFO)

function MapViewDialogDetailInfo:create(functionChooseLayer)
	self = MapViewDialogDetailInfo.new();
	self.functionChooseLayer = functionChooseLayer;
	self:initBaseAttr();
	return self;
end

function MapViewDialogDetailInfo:ctor()


end

function MapViewDialogDetailInfo:OnExit()
	self:cleanDate()
end

function MapViewDialogDetailInfo:cleanDate()
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

function MapViewDialogDetailInfo:initBaseAttr()

	local function fun_close(sender,event)
		if event == ccui.TouchEventType.ended then
			self:runAction(cc.RemoveSelf:create())
		end
	end


	if self.pWidget == nil then 
		self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewFCNormalButton.json")
	    self:addChild(self.pWidget)

	    local btn_close = self.pWidget:getChildByName("btn_close")
	    btn_close:addTouchEventListener(fun_close)
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
	--类型1
	self.panel_type01 = self.pWidget:getChildByName("Panel_type1");
	self.panel_type01.orgPos = cc.p(self.panel_type01:getPositionX(),self.panel_type01:getPositionY())		
	--类型2
	self.panel_type02 = self.pWidget:getChildByName("Panel_type2");
	self.panel_type02.orgPos = cc.p(self.panel_type02:getPositionX(),self.panel_type02:getPositionY())		

	--奖励
	self.panel_reward =self.panel_type01:getChildByName("Panel_reward")
	self.panel_reward.orgPos = cc.p(self.panel_reward:getPositionX(),self.panel_reward:getPositionY())
	--掉落
	self.panel_drop = self.panel_type01:getChildByName("Panel_drop");
	self.panel_drop.orgPos = cc.p(self.panel_drop:getPositionX(),self.panel_drop:getPositionY())	
	--敌人
	self.panel_enemy =self.panel_type02:getChildByName("Panel_enemy");
	self.panel_enemy.orgPos = cc.p(self.panel_enemy:getPositionX(),self.panel_enemy:getPositionY())


    self.pButtonItem = self.panel_button:getChildByName("btn_item")
    self.pButtonItem:retain()
    self.pButtonItem:removeFromParent()

    self.pNeedItem = self.panel_need:getChildByName("Panel_itme");
    self.pNeedItem:retain()
    self.pNeedItem:removeFromParent()

    self.pRewardItem = self.panel_reward:getChildByName("Panel_rewardItem");
    self.pRewardItem:retain()
    self.pRewardItem:removeFromParent()

    self.pDropItem = self.panel_drop:getChildByName("Panel_dropItem")
    self.pDropItem:retain()
    self.pDropItem:removeFromParent()    

    self.pEnemeyItem = self.panel_enemy:getChildByName("Panel_enemyItem");
    self.pEnemeyItem:retain();
    self.pEnemeyItem:removeFromParent();

end

function MapViewDialogDetailInfo:updaetAttr()
	self.panel_need:setPosition(self.panel_need.orgPos);
	self.panel_info:setPosition(self.panel_info.orgPos);
	self.panel_type01:setPosition(self.panel_type01.orgPos);
	self.panel_type02:setPosition(self.panel_type02.orgPos);
	self.panel_reward:setPosition(self.panel_reward.orgPos);
	self.panel_drop:setPosition(self.panel_drop.orgPos);
	self.panel_enemy:setPosition(self.panel_enemy.orgPos);
	self.panel_button:setPosition(self.panel_button.orgPos);

	self.panel_need:setVisible(true);
	self.panel_info:setVisible(true);
	self.panel_type01:setVisible(true);
	self.panel_type02:setVisible(true);
	self.panel_reward:setVisible(true);
	self.panel_drop:setVisible(true);
	self.panel_enemy:setVisible(true);
	self.panel_button:setVisible(true);

end



function MapViewDialogDetailInfo:setInfo(var,iType)

	if var==nil then 
		return;
	end

	self.element = var;
	self.iType = iType;
	self.buttonTab = buttonTab;

	self:updaetAttr();

	self.panel_reward:getChildByName("list"):removeAllChildren();
	self.panel_drop:getChildByName("list"):removeAllChildren();
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


function MapViewDialogDetailInfo:setPanel(iType)
	if iType == MapViewElementBase.INFO_PANEL_TYPE01 then 
		self:setType01(self.element);
	elseif iType == MapViewElementBase.INFO_PANEL_TYPE02 then
		self:setType02(self.element);
	elseif  iType == MapViewElementBase.INFO_PANEL_TYPE03 then
		self:setType03(self.element);
	end
end

function MapViewDialogDetailInfo:setName(var)
	self.pLab_name:setString(var:getNameString())
end

function MapViewDialogDetailInfo:setTextInfo(sInfo)
	self.textInfo = sInfo;
	--内容
	self:setText()	
end

function MapViewDialogDetailInfo:setText()
	if self.textInfo==nil then
		self.textInfo=""
	end
	self.panel_info:getChildByName("lab_info"):setString(self.textInfo)
end


function MapViewDialogDetailInfo:setType01(var)
	self.panel_type02:setVisible(false);

	local function fun_addItemTips(sender,event)
		if event == ccui.TouchEventType.ended then
			self:addItemTips(sender.itemAttr);
		end
	end


	if var.pConfig.Reward == nil then
		return;
	else
		_rewardConfig =rewardFile[(var.pConfig.Reward)]

		--是否有奖励
		if _rewardConfig.IfShowR then
			local _index =0
			local _space =100;
			if _rewardConfig.Money~=0 and _rewardConfig.Money~=nil then
				local _reward = self.pRewardItem:clone();
				self.panel_reward:getChildByName("list"):addChild(_reward);
				_reward:setPositionX(_reward:getPositionX()+_index*_space);
				_reward:getChildByName("lab_name"):setString(_rewardConfig.Money);
				_reward:getChildByName("img_icon"):loadTexture(goldIconFile[2].iconpath)
				

				_index=_index+1
			end

			if _rewardConfig.Experience ~= 0 and _rewardConfig.Experience ~= nil then
				local _reward = self.pRewardItem:clone();
				self.panel_reward:getChildByName("list"):addChild(_reward);
				_reward:setPositionX(_reward:getPositionX()+_index*_space);
				_reward:getChildByName("lab_name"):setString(_rewardConfig.Experience);
				_reward:getChildByName("img_icon"):loadTexture(goldIconFile[5].iconpath)

				_index=_index+1
			end

			if _rewardConfig.AP ~= 0 and _rewardConfig.AP ~= nil then
				local _reward = self.pRewardItem:clone();
				self.panel_reward:getChildByName("list"):addChild(_reward);
				_reward:setPositionX(_reward:getPositionX()+_index*_space);
				_reward:getChildByName("lab_name"):setString(_rewardConfig.AP);
				_reward:getChildByName("img_icon"):loadTexture(goldIconFile[4].iconpath)

				_index=_index+1
			end

			if _rewardConfig.Experience2 ~= 0 and _rewardConfig.Experience2 ~= nil then
				local _reward = self.pRewardItem:clone();
				self.panel_reward:getChildByName("list"):addChild(_reward);
				_reward:setPositionX(_reward:getPositionX()+_index*_space);
				_reward:getChildByName("lab_name"):setString(_rewardConfig.Experience2);
				_reward:getChildByName("img_icon"):loadTexture(goldIconFile[1].iconpath)

				_index=_index+1
			end

			if _rewardConfig.Sign ~= 0 and _rewardConfig.Sign ~=nil then
				local _reward = self.pRewardItem:clone();
				self.panel_reward:getChildByName("list"):addChild(_reward);
				_reward:setPositionX(_reward:getPositionX()+_index*_space);

				local pConfig = signFile[_rewardConfig.Sign];

				_reward:getChildByName("lab_name"):setString(pConfig.Name);
				_reward:getChildByName("img_icon"):loadTexture(pConfig.Pic)
				_index=_index+1
			end

		else
			self.panel_drop:setPositionY(self.panel_drop.orgPos.y+50);			
			self.panel_reward:setVisible(false)
		end

		--是否有掉落
		if _rewardConfig.ShowItem then 
			local _space = 130;
			local _index =0;
			for k,v in pairs(_rewardConfig.ShowItem) do
				local _drop = self.pDropItem:clone();
				_drop.itemAttr = v;
				_drop:addTouchEventListener(fun_addItemTips)
				self.panel_drop:getChildByName("list"):addChild(_drop);
				_drop:setPositionX(_drop:getPositionX()+_index*_space);
				_drop:getChildByName("img_icon"):loadTexture(itemFile[(v)].itemIcon)
				_drop:getChildByName("Panel_star"):setVisible(false);
				_index=_index+1;
			end

		else
			self.panel_drop:setVisible(false);

		end

	end

end


function MapViewDialogDetailInfo:setType02(var)
	self.panel_type01:setVisible(false);

	local monsterboxid = self:getMonsterDispalyID(var);

	if monsterboxid== nil then 
		return;
	end

	local monsterTab = {}
	for i = 1, 6 do
		monsterTab[i] = monsterBoxFile[(monsterboxid)]['Pos'..i]
	end


	local _space = 130;
	local _index =0;
	for k,v in pairs(monsterTab) do
		local modelid = monsterFile[(v)].modelid
		local iconPath = modelFile[modelid].icon_square

		local _enemy = self.pEnemeyItem:clone();
		self.panel_enemy:getChildByName("list"):addChild(_enemy);
		_enemy:setPositionX(_enemy:getPositionX()+_index*_space);

		_enemy:getChildByName("img_icon"):loadTexture(iconPath)

		_index=_index+1
	end

end

function MapViewDialogDetailInfo:setType03(var)
	self.panel_type01:setVisible(false);
	self.panel_type02:setVisible(false);
end


function MapViewDialogDetailInfo:setButtones(buttonTab,textTab)

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


function MapViewDialogDetailInfo:setNeed(var)
	if var.pConfig.Precondition == nil then 
		self.panel_need:setVisible(false);		
	else
		for k,v in pairs(var.pConfig.Precondition) do
			local iType =v[1];
			local iPref = v[2];

			local needPanel =self.pNeedItem:clone();
			needPanel:setPositionX(needPanel:getPositionX()+(k-1)*140)
			self.panel_need:addChild(needPanel)

			local pText = needPanel:getChildByName("lab_text")
			local pImg = needPanel:getChildByName("img_icon");

			if iType == 1 then 				--团队等级 
				pImg:loadTexture(goldIconFile[7].iconpath)
				pText:setString(iPref)
			elseif iType ==2 then 			--战斗力
				pImg:loadTexture(goldIconFile[6].iconpath)
				pText:setString(iPref)
			elseif iType == 3 then 			--标记(任务道具)
				pText:setString("1");
				local pConfig = signFile[iPref];
				pImg:loadTexture(pConfig.Pic);
				pText:setString(pConfig.Name)
			end
		end
	end

end

function MapViewDialogDetailInfo:setDate(bHoke,sText1,bRew,sText2)
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

	if bHoke == false then
		img_jiangli:setPositionX(img_jiangli:getPositionX()-165)
	end



end


function MapViewDialogDetailInfo:getMonsterDispalyID(var)
	if var.subType == MapViewElementBase.TYPE_HOOK_NORMAL then 
		return var.pConfig.Boss;
	elseif var.subType == MapViewElementBase.TYPE_HOOK_AtONCE then 
		return var.pConfig.BossLimit;
	elseif var.subType == MapViewElementBase.TYPE_ENEMY_CONTINUOUS then
		return var.pConfig.Monster[1];
	end

	return var.pConfig.Monster;

end


function MapViewDialogDetailInfo:getFunction(var)
	return self.functionChooseLayer:getFunctionWithType(var) ---函数名
end

function MapViewDialogDetailInfo:getElementIndexPos()
	return self.elementIndexPos;
end

--设置名字颜色//
function MapViewDialogDetailInfo:setNameTextColor(rgb)
	self.pLab_name:setColor(rgb)
end



---道具提示
function MapViewDialogDetailInfo:addItemTips(id)
	local propTips = PropsAttrTips:create(id);
	self:addChild(propTips);
end

--添加动画
function MapViewDialogDetailInfo:addFadeAnimation(fTime)
	self:textAnimation(self.pLab_name,fTime);
	self:textAnimation(self.panel_info:getChildByName("lab_info"),fTime);
end

--动画测试
function MapViewDialogDetailInfo:textAnimation(pText,fTime)
	fTime=fTime*0.8
	pText:setOpacity(0);
	local pFadeAction  = cc.FadeIn:create(0.3);
	local pDealy = cc.DelayTime:create(fTime);
	pText:runAction(cc.Sequence:create(pDealy,pFadeAction));
end