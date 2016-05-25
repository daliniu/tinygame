--打造特效界面
require("script/class/class_base_ui/class_base_sub_layer")
require("script/core/configmanager/configmanager");

local ItemConfiFile = mconfig.loadConfig("script/cfg/pick/item");
local QualityEdge = mconfig.loadConfig("script/cfg/client/quality_edge");
local QualityBase = mconfig.loadConfig("script/cfg/client/quality_basic");


local TB_FORGING_EFFECT_LAYER ={
	pTab =nil,
	pItem =nil,
	pList = nil,
	startPosTab =nil;
}

local posTab01  =	{{274,692}};
local posTab02  =	{{23,692},{525,692}};
local posTab03  =	{{274,933},{23,451},{525,451}};
local posTab04  =	{{23,933},{525,933},{23,451},{525,451}};
local posTab05	=	{{23,933},{525,933},{23,451},{525,451},{274,692}};


ForgingEffectLayer = class("ForgingEffectLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)

function ForgingEffectLayer:create(pTab,startPosTab)
	self = ForgingEffectLayer.new();
	self.pTab = pTab
	self.startPosTab = startPosTab;
	self:initAttr();
	return self
end

function ForgingEffectLayer:OnExit()
	self.pItem:release();
	self.pItem=nil;
end

function ForgingEffectLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/forgingEffectView.json")
    self:addChild(self.pWidget)

	--关闭按钮
    local function fun_close(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            self:addFlyToBagAnim();
            --self:closeLayer();
        end
    end

    local function fun_setAbleTouch(node,pTab)
    	self:setButtonDisplay(true);
    end


    local btn_close = self.pWidget:getChildByName("btn_close");
    btn_close:addTouchEventListener(fun_close)
    self:setButtonDisplay(false);

    local pCallBging  = cc.CallFunc:create(fun_setAbleTouch);
    local pSqueAction = cc.Sequence:create(cc.DelayTime:create(10),pCallBging)
    self:runAction(pSqueAction);


    self.pItem = self.pWidget:getChildByName("Panel_item")
    self.pItem:retain();
    self.pItem:removeFromParent();

    self.pList = self.pWidget:getChildByName("Panel_list")


end

function ForgingEffectLayer:initAttr()

	local function fun_bgTouch(sender,eventType)

		local touchPosBegin = sender:getTouchBeganPosition();
		local touchPosMove = sender:getTouchMovePosition();
		local touchPosEnd = sender:getTouchEndPosition();

		if eventType==ccui.TouchEventType.ended then

		elseif eventType == ccui.TouchEventType.began then

		elseif eventType == ccui.TouchEventType.moved	 then

		elseif eventType == ccui.TouchEventType.canceled then 

		end
	end


	function fun_local_addEfect(pNode,pTab)
		local pAnim = af_GetEffectByID(60009);
		pAnim:setPosition(cc.p(100,100));
		pAnim:setLocalZOrder(10);
		pNode:addChild(pAnim);
	end


	function fun_itemTouch(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			
			if sender:getChildByName("Image_mask"):isVisible()== true then 
				sender:getChildByName("Image_mask"):setVisible(false);
			else
				--装备tips
				local tips = PropsAttrTips:create(sender.id);
				self:addChild(tips);
			end
			

			---检测是否全部点完
			local bAllCard = true;
			local pTab = self.pList:getChildren();
			for k,v in pairs(pTab) do
				local icon = v:getChildByName("Image_mask");
				if icon:isVisible()== true then 
					bAllCard = false;
				end
			end
			if bAllCard == true then
				self:setButtonDisplay(true);
			end

		end
	end

	function fun_addGlow(pNode,pTable)
		local quality = pTable[1];
		local colorTab = QualityBase[quality].color

		local pAnim01 = af_GetEffectByID(60011);
		pAnim01:setPosition(cc.p(100,100));
		pAnim01:setColor(cc.c3b(colorTab[1],colorTab[2],colorTab[3]));
		pNode:addChild(pAnim01);

		-- local pAnim02 = af_GetEffectByID(60012);
		-- pAnim02:setPosition(cc.p(100,100));
		-- pAnim02:setColor(cc.c3b(colorTab[1],colorTab[2],colorTab[3]));
		-- pNode:addChild(pAnim02);
	end

	local function fun_addItem()
		local iNum=0;
		for k,v in pairs(self.pTab) do
			iNum=iNum+1;
		end
		local index = 1;

		for k,v in pairs(self.pTab) do
			local _item  = self.pItem:clone();
			self.pList:addChild(_item);
			_item.id = v.id;
			_item:addTouchEventListener(fun_itemTouch);
			local curPos = cc.p(self.startPosTab[index].x,self.startPosTab[index].y)
			curPos.x = curPos.x - _item:getContentSize().width*0.5;
			curPos.y = curPos.y - _item:getContentSize().height*0.5;
			_item:setPosition(curPos)
			if iNum == 1 then
				local pos=posTab01[index]
				_item.targetPos = cc.p(pos[1]-self.pList:getPositionX(),pos[2]-self.pList:getPositionY());
			elseif iNum == 2 then
				local pos=posTab02[index]
				_item.targetPos = cc.p(pos[1]-self.pList:getPositionX(),pos[2]-self.pList:getPositionY());		
			elseif iNum == 3 then
				local pos=posTab03[index]
				_item.targetPos = cc.p(pos[1]-self.pList:getPositionX(),pos[2]-self.pList:getPositionY());
			elseif iNum == 4 then
				local pos=posTab04[index]
				_item.targetPos = cc.p(pos[1]-self.pList:getPositionX(),pos[2]-self.pList:getPositionY());
			elseif iNum == 5 then
				local pos=posTab05[index]
				_item.targetPos = cc.p(pos[1]-self.pList:getPositionX(),pos[2]-self.pList:getPositionY());
			end

			--图片
			local itemIcon = ItemConfiFile[v.id].itemIcon;
			_item:getChildByName("Image_icon"):loadTexture(itemIcon);

			--品质框
			local iQua = ItemConfiFile[v.id].itemQuality
			local quaFile = QualityEdge[1]["qualitytype"..iQua]
			_item:getChildByName("Image_bg"):loadTexture(quaFile);

			self.pWidget:addTouchEventListener(fun_bgTouch);


			local fShakeTime = 0.05;
			local fShakeDis = 50;
			local pActionShake = cc.Sequence:create(cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis),
																						math.random(fShakeDis))),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis)*-1,
																						math.random(fShakeDis)*-1)),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis),
																						math.random(fShakeDis))),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis)*-1,
																						math.random(fShakeDis)*-1)),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis),
																						math.random(fShakeDis))),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis)*-1,
																						math.random(fShakeDis)*-1)),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis),
																						math.random(fShakeDis))),
													cc.MoveBy:create(fShakeTime,cc.p(math.random(fShakeDis)*-1,
																						math.random(fShakeDis)*-1))
													);

			local fTime =1;
			local pAction =  cc.Sequence:create(cc.MoveTo:create(fTime,cc.p(350-self.pList:getPositionX(),
																				710-self.pList:getPositionY())),
													cc.CallFunc:create(fun_local_addEfect,{}),
													pActionShake,
													cc.MoveTo:create(fTime,_item.targetPos),
													cc.CallFunc:create(fun_addGlow,{iQua}));
			_item:runAction(pAction);
			

			index = index+1;
		end
	end

	local function fun_addAnim02(pNode,pTab)
		for k,v in pairs(self.startPosTab) do
			local pAnim = af_GetEffectByID(60008)
			self.pList:addChild(pAnim);
			pAnim:setPosition(v)
		end
	end


	---坐标变换
	for k,v in pairs(self.startPosTab) do
		v.x = v.x-self.pList:getPositionX();
		v.y = v.y-self.pList:getPositionY();
	end


	--第一段动画
	for k,v in pairs(self.startPosTab) do
		local pAnim = af_GetEffectByID(60013)
		self.pList:addChild(pAnim);
		pAnim:setPosition(v)
		local pAction = cc.Sequence:create(cc.DelayTime:create(1.0),cc.RemoveSelf:create())
		pAnim:runAction(pAction);
	end

	--第二段
	local pAction02 = cc.Sequence:create(cc.DelayTime:create(0.9),cc.CallFunc:create(fun_addAnim02,{}));
	self:runAction(pAction02);

	--第三段
	local pAction03 = cc.Sequence:create(cc.DelayTime:create(0.9),cc.CallFunc:create(fun_addItem,{}));
	self:runAction(pAction03);

end



function ForgingEffectLayer:addFlyToBagAnim()
	local fTime =0.5;

	local iNum=0;
	for k,v in pairs(self.pTab) do
		iNum=iNum+1;
	end

	local index  =1;
	for i=1,iNum do
		local pEffect =  af_GetEffectByID(60007);
		self:addChild(pEffect);
		local pos;
		if iNum == 1 then
			pos=posTab01[index]
		elseif iNum == 2 then 
			pos=posTab02[index]	
		elseif iNum == 3 then 
			pos=posTab03[index]	
		elseif iNum == 4 then 
			pos=posTab04[index]
		elseif iNum == 5 then
			pos=posTab05[index]
		end

		pEffect:setPosition(cc.p(pos[1],pos[2]));
		pEffect:runAction(cc.MoveTo:create(fTime,cc.p(645,65)))
		index=index+1;
	end


	local pAction  = cc.Sequence:create(cc.DelayTime:create(fTime),cc.RemoveSelf:create());
	self:runAction(pAction);

end


function ForgingEffectLayer:setButtonDisplay(bRet)

	local btn_close = self.pWidget:getChildByName("btn_close");

	if bRet == true then 
		btn_close:setTouchEnabled(true);
		btn_close:setVisible(true);
	else 
		btn_close:setTouchEnabled(false);
		btn_close:setVisible(false);
	end



end