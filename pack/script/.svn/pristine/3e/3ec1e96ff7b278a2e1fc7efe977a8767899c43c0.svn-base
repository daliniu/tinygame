----------------------------------------------------------
----------------------------------------------------------
-- file:	afkstatisticsview.lua
-- Author:	page
-- Time:	2015/07/22 14:29
-- Desc:	统计面板
----------------------------------------------------------
require "script/ui/resource"
require("script/core/configmanager/configmanager");
----------------------------------------------------------
local l_tbIconConfig = mconfig.loadConfig("script/cfg/client/icon");
local l_tbString = require("script/cfg/string");

--data struct
local TB_STRUCT_UI_AFK_STATISTICS_VIEW = {
	--config
	m_MAXCOL = 4,							-- 一行最多放多少
	--------------------------------------------------------
	--界面
	m_Layout = nil,							--保存界面结构root
	
	m_svReward = nil,						-- 奖励scrollview
	m_pnlTemplate = nil,					-- 元素模版
	-- scrollview 相关配置
	m_nMaxCol = 4,								-- 一行最大放多少(默认：4)
	m_nSVMaxHeight = 0,							-- 最大高度
	m_nWidth = 0,								-- 模版宽度
	m_nHeight = 0,								-- 模版高度
	m_nWidthSpace = 0,							-- 水平方向的间隔
	m_nHeightSpace = 0,							-- 垂直方向的间隔
	m_nHeadSpaceH = 0,							-- 水平最前面间隔
	m_nHeadSpaceV = 0,							-- 垂直最前面间隔
	
	m_bPlayEffect = false,					-- 是否播放特效
	m_bFightCage = false,					-- 是否是战斗宝箱
}

KGC_AFK_STATISTICS_VIEW_TYPE = class("KGC_AFK_STATISTICS_VIEW_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_UI_AFK_STATISTICS_VIEW)
--------------------------------
--ui function
--------------------------------
function KGC_AFK_STATISTICS_VIEW_TYPE:ctor()
	
end

function KGC_AFK_STATISTICS_VIEW_TYPE:Init(tbArg)
	local tbArg = tbArg or {};
	self.m_Layout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_AFK_STATISTICS)
	assert(self.m_Layout)
	
	self.m_bPlayEffect = tbArg[1] or false;
	self.m_bFightCage = tbArg[2] or false;

	self:addChild(self.m_Layout)
	self:LoadScheme()
end

--解析界面文件
function KGC_AFK_STATISTICS_VIEW_TYPE:LoadScheme()
	local btnClose = self.m_Layout:getChildByName("btn_close")
	local fnClose = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():closeLayer();
		end
	end
	btnClose:addTouchEventListener(fnClose)
	
	if self.m_bFightCage then
		local imgTitle = self.m_Layout:getChildByName("Image_6")
		imgTitle:loadTexture("res/ui/04_mapwindow/04_txt_change_02.png")
		local imgBg = self.m_Layout:getChildByName("img_bg")
		local lblInfo = imgBg:getChildByName("lbl_info")
		lblInfo:setString(l_tbString[10003])
	end


	-- 计算scrollview需要的数据
	self.m_svReward = self.m_Layout:getChildByName("sv_reward")
	self.m_svReward:setVisible(false);
	-- self.m_svReward:setClippingEnabled(false);
	local sizeSV = self.m_svReward:getInnerContainerSize();
	self.m_nSVMaxHeight = sizeSV.height;
	self.m_pnlTemplate = self.m_svReward:getChildByName("img_item")
	self.m_pnlTemplate:setVisible(false);
	local pnlTemplateH = self.m_svReward:getChildByName("img_itemH")		-- 水平间隔计算
	local pnlTemplateV = self.m_svReward:getChildByName("img_itemV")		-- 垂直间隔计算
	pnlTemplateH:setVisible(false);
	pnlTemplateV:setVisible(false);
	local size = self.m_pnlTemplate:getContentSize();
	self.m_nWidth = size.width;
	self.m_nHeight = size.height;
	local x, y = self.m_pnlTemplate:getPosition();
	local xH, yH = pnlTemplateH:getPosition();
	local xV, yV = pnlTemplateV:getPosition();
	self.m_nWidthSpace = xH - x - size.width;
	self.m_nHeightSpace = y - yV - size.height;
	self.m_nHeadSpaceH = x;
	self.m_nHeadSpaceV = sizeSV.height - y;

	--test
	cclog("------------------------------------");
	cclog("-%3d- |                            -", self.m_nHeadSpaceH);
	cclog("      %d                           -", self.m_nHeadSpaceV);
	cclog("-     |--%3d-- |       |--------|  -", self.m_nWidth);
	cclog("-     %3d      |       |        |  -", self.m_nHeight);
	cclog("-     |        |       |        |  -");
	cclog("-     |--------| -%3d- |--------|  -", self.m_nWidthSpace);
	cclog("-         |                        -");
	cclog("-         %3d                      -", self.m_nHeightSpace);
	cclog("-         |                        -");
	cclog("-     |--------|                   -");
	cclog("-     |        |                   -");
	cclog("-     |        |                   -");
	cclog("-     |--------|                   -");
	cclog("- 最大列数:%3d                     -", self.m_nMaxCol);
	cclog("------------------------------------");
	--tesnt
	-- 背景一直播放
	self:PlayUIAction("ui_getreward.json", "bgrolling");
end

--@function: 加载奖励
--@tbCurrency: 货币类
--@tbItems: 道具类
function KGC_AFK_STATISTICS_VIEW_TYPE:LoadReward(tbData)
	print("LoadReward", #(tbData or {}));
	if not tbData then
		return;
	end
	local pnlAnimation = self.m_Layout:getChildByName("pnl_animation");
	
	-- 每一行最多放四个
	local fnTouchItem = function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- self:TouchItem(sender);
		end
	end
	
	local nMax = #tbData;
	local fnUpdate = function(i, data)
		if not data then
			return;
		end
		-- 位置调整
		local nRow = math.floor((i-1)/self.m_nMaxCol) + 1;
		local nCol = (i-1) % self.m_nMaxCol + 1;
		local szQuality, szIcon, nNum = data[1] or "", data[2] or "", data[3] or 0;
		local item = self.m_pnlTemplate:clone();
		self:UpdateItem(item, data);
		item:setVisible(true);
		local x = self.m_nHeadSpaceH + (nCol-1) * (self.m_nWidth + self.m_nWidthSpace);
		local nHeight = self.m_nHeadSpaceV + (nRow-1) * (self.m_nHeight + self.m_nHeightSpace);
		local y = self.m_nSVMaxHeight - nHeight;
		item:setPosition(cc.p(x, y));
		self.m_svReward:addChild(item);
		item:addTouchEventListener(fnTouchItem);
		
		-- 最后一个的坐标
		if i == nMax then
			local x, y = item:getPosition();
			
			-- 根据jumpToPercentVertical的公式反过来计算
			-- 最后一个和第一个的垂直距离
			local xT, yT = self.m_pnlTemplate:getPosition();
			local nDistance = yT - y;
			local sizeSV = self.m_svReward:getContentSize();
			local h = self.m_nSVMaxHeight - sizeSV.height;
			local nPercent = 100 * nDistance/h;
			--test
			-- nPercent = 0;
			print("nPercent: ", nPercent);
			--test end
			self.m_svReward:jumpToPercentVertical(nPercent);
		end
	end
	
	local fnCallBack = function()
		self.m_svReward:setVisible(true);
		for i = 1, nMax do
			fnUpdate(i, tbData[i]);
		end
		
		-- 动画panel设置不可见
		pnlAnimation:setVisible(false);
	end
	
	if self.m_bPlayEffect then
		pnlAnimation:setVisible(true);
		local nCount = 0;
		local nCircle = math.floor(nMax/self.m_MAXCOL);
		local fnCircle = function()
			nCount = nCount + 1;
			-- 再次播放的时候需要更新第m_MAXCOL个开始
			local nStartPos = self.m_MAXCOL * nCount;
			self:UpdateAnimationPanel(pnlAnimation, tbData, nStartPos);
			if nCount == nCircle then
				if self.m_acCircle then
					self.m_acCircle:setLoop(false);		-- 直接设置stop没有效果
					self.m_acCircle:stop();
					self.m_acCircle = nil;
					self:PlayUIAction("ui_getreward.json", "itemin1", cc.CallFunc:create(fnCallBack));
				end
			end
		end
		
		self:UpdateAnimationPanel(pnlAnimation, tbData);
		if nCircle > 0 then
			-- 这是一个循环播放的动画
			self.m_acCircle = self:PlayUIAction("ui_getreward.json", "itemin2", cc.CallFunc:create(fnCircle));
		else
			self:PlayUIAction("ui_getreward.json", "itemin1", cc.CallFunc:create(fnCallBack));
		end
	else
		pnlAnimation:setVisible(false);
		fnCallBack();
	end
end

--@function: 更新动画panel
function KGC_AFK_STATISTICS_VIEW_TYPE:UpdateAnimationPanel(panel, tbData, nStartPos)
	local nStartPos = nStartPos or 0;
	local tbData = tbData or {};
	if not panel then
		return;
	end
	
	for i = 1, self.m_MAXCOL do
		local data = tbData[nStartPos + i];
		local szName = "img_item" .. i;
		local imgItem = panel:getChildByName(szName);
		if data then
			self:UpdateItem(imgItem, data);
		else
			imgItem:setVisible(false);
		end
		
		-- 加特效
		local nLayerID = self:GetLayerID();			-- for 特效
		af_BindEffect2Node(imgItem, 60037, {nil, 1}, 1, nil, {nil, nil, nLayerID});
	end
end

--@function: 更新一个Item
function KGC_AFK_STATISTICS_VIEW_TYPE:UpdateItem(widget, tbData)
	if not widget or not tbData then
		cclog("[Error]控件或者要显示的对象为空");
		return;
	end
	local szQuality, szIcon, nNum = tbData[1] or "", tbData[2] or "", tbData[3] or 0;
	widget:setVisible(true);
	local imgQuality = widget:getChildByName("img_quality");	-- 品质框
	local imgIcon = widget:getChildByName("img_icon");			-- 图标
	local lblNum = widget:getChildByName("bml_num");			-- 数量
	imgQuality:loadTexture(szQuality);
	imgIcon:loadTexture(szIcon);
	lblNum:setString(nNum);
end

--@function: 更新
function KGC_AFK_STATISTICS_VIEW_TYPE:UpdateData(nGold, nExp, nAP, tbItems, nTime)
	local nGold, nExp, nAP, tbItems, nTime = nGold or 0, nExp or 0, nAP or 0, tbItems, nTime or 0;
	-- 判断是否传值：拿一个出来判断就可以了, 没有传值就显示离线挂机奖励
	-- if not nGold then
		-- nGold, nExp, nAP, tbItems, tbEquips = KGC_AFK_STATISTICS_LOGIC_TYPE:getInstance():GetAfkStatistics();
	-- end
	
	-- 构造非道具奖励
	local tbData = {}
	if nGold > 0 then
		local szIcon = gf_GetIconStructByType("gold").iconpath;
		table.insert(tbData, {"", szIcon, nGold})
	end
	
	if nAP > 0 then
		local szIcon = gf_GetIconStructByType("ap").iconpath;
		table.insert(tbData, {"", szIcon, nAP})
	end
	
	-- 道具类奖励
	for _, data in pairs(tbItems or {}) do
		local item, num = unpack(data or {});
		if item and num then
			local szQuality = item:GetQualityIcon();
			local szIcon = item:GetIcon();
			table.insert(tbData, {szQuality, szIcon, num})
		end
	end
	
	self:LoadReward(tbData)
end

function KGC_AFK_STATISTICS_VIEW_TYPE:OnExit()

end


--------------------------------
