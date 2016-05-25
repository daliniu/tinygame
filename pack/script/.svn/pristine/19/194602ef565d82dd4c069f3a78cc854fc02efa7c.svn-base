----------------------------------------------------------
-- file:	tipselement.lua
-- Author:	峰猴
-- Time:	not long ago
-- Desc:	多种消息框类
-- Modeify:
--		(1) 增加确认框 by page@2015/07/09
----------------------------------------------------------
require("script/core/configmanager/configmanager");

local l_tbStringConfig = require("script/cfg/string")
local l_tbAttributeConfig = mconfig.loadConfig("script/cfg/client/action/attributechange");

local TB_NORMAL_TIPS={pString=nil,}

----------------------------------------------------------
-- 1. 消息框
NormalTips = class("NormalTips",function()
	return cc.Node:create();
end,TB_NORMAL_TIPS);

function NormalTips:create(massageInfo)
	self = NormalTips.new();
	self.pString = massageInfo;
	self:initAttr();
	return self;
end

function NormalTips:initAttr()
	self:setPosition(cc.p(375,667))

    local pBg =  cc.Scale9Sprite:create("res/ui/04_mapwindow/04_bg_tips.png")
    pBg:setCapInsets(cc.rect(22,23,1,1));
    self:addChild(pBg);

	local textinfo= ccui.Text:create()
    self:addChild(textinfo)
    textinfo:setFontSize(20)

    textinfo:setString(self.pString)

    pBg:setPreferredSize(cc.size(textinfo:getStringLength()*20+60,65));

    self:setScale(0);
    local pAction = cc.Sequence:create(cc.ScaleTo:create(0.2,1.0),
                                         cc.DelayTime:create(1.0),
    									cc.RemoveSelf:create());

    self:runAction(pAction);
end

----------------------------------------------------------
-- 2. 确认框
local TB_STRUCT_MESSAGEBOX = {
	m_pLayout = nil,
	
	m_nMsgID = 0,				-- 消息ID
	m_fnCallBack = nil,			-- 回调函数
}

KGC_MESSAGEBOX_TYPE = class("KGC_MESSAGEBOX_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_MESSAGEBOX)

function KGC_MESSAGEBOX_TYPE:create(nMessageID, fnCallBack)
    local view = KGC_MESSAGEBOX_TYPE.new()
	view:initAttr(nMessageID, fnCallBack);
	
	return view;
end

function KGC_MESSAGEBOX_TYPE:initAttr(nMessageID, fnCallBack)
	self.m_nMsgID = nMessageID;
	self.m_fnCallBack = fnCallBack;
	self:LoadScheme();
end

function KGC_MESSAGEBOX_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_MESSAGEBOX);
	self:addChild(self.m_pLayout)
	
	local pnlMain = self.m_pLayout:getChildByName("pnl_main")
	local btnOk = pnlMain:getChildByName("btn_ok")
	local btnCancel = pnlMain:getChildByName("btn_cancel")
	local fnTouch = function(sender,eventType)
		if eventType==ccui.TouchEventType.ended then
			local bRet = false;
			if sender == btnOk then
				bRet = true;
			end
			if self.m_fnCallBack then
				self.m_fnCallBack(bRet)
			end
			self:closeLayer();
		end
	end
	btnOk:addTouchEventListener(fnTouch);
	btnCancel:addTouchEventListener(fnTouch);
	
	-- 消息显示
	local lblMsg = pnlMain:getChildByName("lbl_msg")
	local szMsg = l_tbStringConfig[self.m_nMsgID]
	lblMsg:setString(szMsg)
end

--@function: 重写关闭界面接口
function KGC_MESSAGEBOX_TYPE:closeLayer()
	self:removeFromParent(true);
end

----------------------------------------------------------
-- 1. 属性框
local TB_STRUCT_ATTRIBUTE_CHANGE = {
	m_bIgnoreLogicUpdate = true,			-- 标识是否走logci的update
	m_scheduler = nil,						-- 为了实现计数器
}
KGC_UI_ATTRIBUTE_CHANGE = class("KGC_UI_ATTRIBUTE_CHANGE",function()
	return cc.Node:create();
end,TB_STRUCT_ATTRIBUTE_CHANGE);

function KGC_UI_ATTRIBUTE_CHANGE:create(szHead, nBefore, nAfter)
	local layer = KGC_UI_ATTRIBUTE_CHANGE.new();
	layer:initAttr(szHead, nBefore, nAfter);
	return layer;
end

function KGC_UI_ATTRIBUTE_CHANGE:initAttr(szHead, nAttrBefore, nAttrAfter)
	local szHead = szHead or "";
	local nAttrBefore = nAttrBefore or 0;
	local nAttrAfter = nAttrAfter or 0;
	local nSub = nAttrAfter - nAttrBefore;
	
	-- 初始位置
	local tbStartPos = l_tbAttributeConfig.tbStartPos or {};
	local nStartX, nStartY = tbStartPos[1] or 385, tbStartPos[2] or 720;
	self:setPosition(cc.p(nStartX, nStartY))

	-- 属性条
	local szTextureAttribute = l_tbAttributeConfig.szTextureAttribute;
    local sprite =  ccui.ImageView:create(szTextureAttribute);
	local tbCapInsets = l_tbAttributeConfig.tbCapInsets or {27, 28, 1, 1};
	local tbContentSize = l_tbAttributeConfig.tbContentSize or {380, 56};
	local nOpacity = l_tbAttributeConfig.nOpacity or 50;
	sprite:setAnchorPoint(cc.p(0.5, 0.5));	-- 设置锚点在中间
    sprite:setScale9Enabled(true);
	sprite:setCapInsets(cc.rect(unpack(tbCapInsets)));
    self:addChild(sprite);
	sprite:setContentSize(cc.size(unpack(tbContentSize)));
	sprite:setOpacity(nOpacity);
	sprite:setScale(0);

	-- 文字头
	local txtHead = ccui.Text:create()
    sprite:addChild(txtHead)
	local nHeadFontSize = l_tbAttributeConfig.nHeadFontSize or 20;
	local tbHeadColor = l_tbAttributeConfig.tbHeadColor or {255, 129, 1};
	local tbHeadPos = l_tbAttributeConfig.tbHeadPos or {55, 28};
    txtHead:setFontSize(nHeadFontSize)
    txtHead:setString(szHead)
	txtHead:setColor(cc.c3b(unpack(tbHeadColor)));
	txtHead:setPosition(cc.p(unpack(tbHeadPos)));
	
	-- 数值变化前
	local txtBefore = ccui.Text:create()
    sprite:addChild(txtBefore)
	local nBeforeFontSize = l_tbAttributeConfig.nBeforeFontSize or 20;
	local tbBeforeColor = l_tbAttributeConfig.tbBeforeColor or {240, 226, 192};
	local tbBeforePos = l_tbAttributeConfig.tbBeforePos or {147, 28};
    txtBefore:setFontSize(nBeforeFontSize)
    txtBefore:setString(nAttrBefore)
	txtBefore:setColor(cc.c3b(unpack(tbBeforeColor)));
	txtBefore:setPosition(cc.p(unpack(tbBeforePos)));
	
	-- 图片(箭头)
	local szTextureArrow = l_tbAttributeConfig.szTextureArrow;
	local image1 = ccui.ImageView:create(szTextureArrow);
    sprite:addChild(image1)
	local tbArrowPos = l_tbAttributeConfig.tbArrowPos or {214, 28};
	local nArrowScale = l_tbAttributeConfig.nArrowScale or 0.3;
	image1:setPosition(cc.p(unpack(tbArrowPos)));
	image1:setScale(-1*nArrowScale);		-- 负号表示图片翻转了
	
	local tbColor = {
		[1] = {184, 255, 0},
		[2] = {237, 62, 66},
	}
	local tbAfterColor = l_tbAttributeConfig.tbAfterColor or tbColor;
	local nIndex = 1;
	if nSub < 0 then
		nIndex = 2;
	end
	-- 数值变化后(出现的时候数值设置成一样的)
	local txtAfter = ccui.Text:create()
    sprite:addChild(txtAfter);
	local nAfterFontSize = l_tbAttributeConfig.nAfterFontSize or 20;
	local tbAfterPos = l_tbAttributeConfig.tbAfterPos or {279, 28};
    txtAfter:setFontSize(nAfterFontSize)
    txtAfter:setString(nAttrBefore)
	txtAfter:setColor(cc.c3b(unpack(tbAfterColor[nIndex])));
	txtAfter:setPosition(cc.p(unpack(tbAfterPos)));
	
	-- 图片(上升or下降)
	local tbImage = l_tbAttributeConfig.tbImage;
	local tbUpDownPos = l_tbAttributeConfig.tbUpDownPos or {335, 28};
	local nUpDownScale = l_tbAttributeConfig.nUpDownScale or 0.5;
	local nIndex = 1;
	if nSub < 0 then
		nIndex = 2;
	end
	local image2 = ccui.ImageView:create(tbImage[nIndex]);
    sprite:addChild(image2)
	image2:setScale(nUpDownScale);
	image2:setPosition(cc.p(unpack(tbUpDownPos)));
	
	---------------------------------------------------------
	-- 动作(参考UI动画)
	local nTime1 = l_tbAttributeConfig.nTimeIn or 0.3;			-- 第一组动作时间：出现
	local nTime1Big = l_tbAttributeConfig.nTimeInScaleBig or 0.1;
	local nTime1Back = l_tbAttributeConfig.nTimeInScaleBack or 0.1;
	local nTime2 = l_tbAttributeConfig.nTimeDelay or 0.1;		-- 第二组动作时间：延迟
	local nTime3 = l_tbAttributeConfig.nTimeTick or 1.2;		-- 第三组动作时间：计数器变化时间
	local nTime4 = l_tbAttributeConfig.nTimeOut or 0.3;			-- 第四组动作时间：消失
	local nMaxTimes = l_tbAttributeConfig.nMaxJumpTimes or 15;	-- 计数器跳动最大次数
	
	-- 游戏设置30帧(这个最好获取当前帧数)
	local nTimes = math.floor(nTime3 * 30);
	if nTimes > nMaxTimes then
		nTimes = nMaxTimes;
	end
	
	local scheduler = cc.Director:getInstance():getScheduler()
	local fnUnScheduler = function()
		if self.m_scheduler then
			scheduler:unscheduleScriptEntry(self.m_scheduler)
			self.m_scheduler = nil;
		end
	end
	
	-- 特效完之后回调函数
	local fnCallBack = function()
		fnUnScheduler();
		self:runAction(cc.RemoveSelf:create());
		TipsViewLogic:getInstance():SubMessageNode(self);
	end
	
	-- 数值变化的特效用update函数实现
	local nAdd = math.floor(nSub/nTimes);
	if nAdd <= 0 then			
		-- 设置最小跳动为1，防止变化小的时候最后才跳动;
		nAdd = 1;
	end
	
	local nCount = 0;
	local fnUpdate = function(dt)
		nCount = nCount + 1;
		
		local nCur = nAttrAfter;
		if nSub > 0 then
			nCur = nAttrBefore + nAdd * nCount;
			if nCur > nAttrAfter or nCount >= nTimes then
				nCur = nAttrAfter;
				fnUnScheduler();
			end
		else
			nCur = nAttrBefore + nAdd * nCount;
			if nCur < nAttrAfter or nCount >= nTimes then
				nCur = nAttrAfter;
				fnUnScheduler();
			end
		end
		txtAfter:setString(nCur);
	end
	
	
	
	-- (1)出现
	local fadeTo = cc.FadeTo:create(nTime1, 255);
	local scaleTo1 = cc.ScaleTo:create(nTime1Big, 3, 1.5);
	local scaleTo2 = cc.ScaleTo:create(nTime1Back, 1, 1);
	local seq1 = cc.Sequence:create(scaleTo1, scaleTo2);
	local ac1 = cc.Spawn:create(fadeTo, seq1);
	-- (2)延迟
	local ac2 = cc.DelayTime:create(nTime2);
	
	-- (3)数值计数
	local fnTick = function()
		self.m_scheduler = scheduler:scheduleScriptFunc(fnUpdate, 0, false)
	end
	-- local moveBy3 = cc.MoveBy:create(nTime3, cc.p(0, 90));
	local fadeTo3 = cc.FadeTo:create(nTime3, 180);
	-- local scaleTo3 = cc.ScaleTo:create(nTime3, 1.2, 1.2);
	-- local ac3 = cc.Spawn:create(moveBy3, fadeTo3, scaleTo3, cc.CallFunc:create(fnTick));
	local ac3 = cc.Spawn:create(fadeTo3, cc.CallFunc:create(fnTick));
	
	-- (4)消失
	local fadeTo4 = cc.FadeTo:create(nTime4, 50);
	-- local moveBy4 = cc.MoveBy:create(nTime4, cc.p(0, 200));
	-- local scaleTo4 = cc.ScaleTo:create(nTime4, 1.65, 1.65);
	-- local ac4 = cc.Spawn:create(fadeTo4, moveBy4, scaleTo4);--cc.EaseQuarticActionIn:create
	-- local ac4 = cc.EaseQuadraticActionIn:create(cc.Spawn:create(fadeTo4, moveBy4, scaleTo4));
	local ac4 = fadeTo4;
	
    local action = cc.Sequence:create(ac1, ac2, ac3, ac4, cc.CallFunc:create(fnCallBack));
    sprite:runAction(action);
	
	-- 箭头若隐若现
	local blink = cc.Blink:create(2, 5);
	image1:runAction(blink);
	
	-- 上升or下降跳动
	local nHeight = 12;
	if nSub < 0 then
		nHeight = nHeight * -1;
	end
	local jumpBy = cc.JumpBy:create(0.3, cc.p(0,0), nHeight, 1);
	local jump = cc.Sequence:create(jumpBy, jumpBy:reverse());
	image2:runAction(cc.RepeatForever:create(jump));
end