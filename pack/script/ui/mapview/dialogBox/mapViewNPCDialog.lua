require("script/core/configmanager/configmanager");
local npcwordConfigFile = mconfig.loadConfig("script/cfg/map/npcword");
local modelConfigFile = mconfig.loadConfig("script/cfg/client/model");

local TB_MAP_VIEW_NPC_DIALOG ={
	wordIndex = 1,
	wordTab =nil,
}

MapViewNPCDialog = class("MapViewNPCDialog",function()
	return cc.Node:create()
end,TB_MAP_VIEW_NPC_DIALOG)

function MapViewNPCDialog:create(functionChooseLayer,pElement)
	self = MapViewNPCDialog.new();
	self.functionChooseLayer = functionChooseLayer;
	self.pElement = pElement;
	self:initAttr();
	return self;
end

function MapViewNPCDialog:ctor()


	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/mapViewNpcDialog.json")
    self:addChild(self.pWidget)

    local function fun_close(sender,event)
        if event == ccui.TouchEventType.ended then
            self:gotoNextWord();
        end
    end

    self.pWidget:addTouchEventListener(fun_close)

    self.text_info = self.pWidget:getChildByName("lab_info");
    self.imgLeft = self.pWidget:getChildByName("img_01");
    self.imgRight = self.pWidget:getChildByName("img_02");
    self.lbl_name = self.pWidget:getChildByName("lbl_name");

end

function MapViewNPCDialog:initAttr()
	self.wordIndex = 1;
	self.wordTab = self.pElement.pConfig.WordAndPic;

	self:gotoNextWord();

end


function MapViewNPCDialog:gotoNextWord()
	if self.wordIndex > #self.wordTab then 
		self:removeFromParent();
		return;
	end


	local textID = self.wordTab[self.wordIndex][1];
	local modelID = self.wordTab[self.wordIndex][2];
	local leftOrRight = self.wordTab[self.wordIndex][3]; -- 1左边，2右边


	local mondelConfig = modelConfigFile[modelID]

	self.text_info:setString(npcwordConfigFile[textID].Word);
	if leftOrRight == 1 then 
		self.imgRight:setVisible(false);
		self.imgLeft:setVisible(true);
		self.imgLeft:loadTexture(mondelConfig.img_cha)
		self.lbl_name:setString(mondelConfig.modelname);
	else
		self.imgRight:setVisible(true);
		self.imgLeft:setVisible(false);
		self.imgRight:loadTexture(mondelConfig.img_cha)
		self.lbl_name:setString(mondelConfig.modelname);
	end




	self.wordIndex= self.wordIndex+1;
	

	--动画
	self:addFadeAnimation(0.1)
end

--添加动画
function MapViewNPCDialog:addFadeAnimation(fTime)
	self:textAnimation(self.text_info,fTime);
end

--动画测试
function MapViewNPCDialog:textAnimation(pText,fTime)
	fTime=fTime*0.8
	pText:setOpacity(0);
	local pFadeAction  = cc.FadeIn:create(0.3);
	local pDealy = cc.DelayTime:create(fTime);
	pText:runAction(cc.Sequence:create(pDealy,pFadeAction));
end