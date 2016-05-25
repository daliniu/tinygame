----------------------------------------------------------
-- file:	reward_custom_layer.lua
-- Author:	page
-- Time:	2015/11/18 19:29
-- Desc:	通用奖励界面
----------------------------------------------------------
require "script/ui/resource"
----------------------------------------------------------
local l_tbRewardType = {
	ET_GOLD		= 1,			-- 金币
	ET_AP		= 2,			-- 行动力
}

local TB_STRUCT_REWARD_CUSTOM_VIEW = {
	--config
	m_MAXCOL = 4,								-- 一行最多放多少
	--------------------------------------------------------
	
	m_pLayout = nil,
	
	m_svReward = nil,
	m_pnlTemplate = nil,
	-- scrollview 相关配置
	m_nSVMaxHeight = 0,							-- 最大高度
	m_nWidth = 0,								-- 模版宽度
	m_nHeight = 0,								-- 模版高度
	m_nWidthSpace = 0,							-- 水平方向的间隔
	m_nHeightSpace = 0,							-- 垂直方向的间隔
	m_nHeadSpaceH = 0,							-- 水平最前面间隔
	m_nHeadSpaceV = 0,							-- 垂直最前面间隔
}

KGC_UI_REWARD_CUSTOM_LAYER_TYPE = class("KGC_UI_REWARD_CUSTOM_LAYER_TYPE", KGC_UI_BASE_LAYER, TB_STRUCT_REWARD_CUSTOM_VIEW)

function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:OnExit()
    
end

---初始化
function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:Init(tbArg)
	self:LoadScheme();
	local tbCurrency, tbItems = unpack(tbArg or {});
	self:UpdateData(tbCurrency, tbItems);
end

function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:LoadScheme()
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_REWARD_CUSTOM_PATH)
	self:addChild(self.m_pLayout)
	
	-- 点击任意位置关闭按钮
	local btnOk = self.m_pLayout:getChildByName("btn_confirm");
	btnOk:setVisible(false);
	local btnClose = self.m_pLayout:getChildByName("btn_close");
	local fnClose = function(sender,eventType)
		KGC_REWARD_LAYER_LOGIC_TYPE:getInstance():closeLayer(2);
	end
	btnOk:addTouchEventListener(fnClose);
	btnClose:addTouchEventListener(fnClose);
	
	local pnlReward = self.m_pLayout:getChildByName("pnl_rewards")
	
	-- 计算scrollview需要的数据
	self.m_svReward = pnlReward:getChildByName("sv_reward")
	self.m_svReward:setVisible(false);
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
end

--@function: 新的更新界面函数, 要求传进来的数值类奖励先拼好
--@nAPCost:  战斗消耗的补给
function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:UpdateData(tbCurrency, tbItemObjs)
	local tbItemObjs = tbItemObjs or {}
	print("KGC_UI_REWARD_CUSTOM_LAYER_TYPE:UpdateData ... ")

	-- 更新奖励
	self:UpdateReward(tbCurrency, tbItemObjs)
end

--@function: 更新奖励界面, 第一部分(经验、金币、行动力、标记)
function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:UpdateReward(tbCurrency, tbItems)
	print("UpdateReward", tbCurrency, tbItems);
	
	-- 构造非道具奖励
	local tbData = {}
	for k, v in pairs(tbCurrency or {}) do
		-- print(111, k, v);
		if v > 0 then
			local tbIcon = gf_GetIconStructByType(k) or {};
			local szIcon = tbIcon.iconpath or "";
			table.insert(tbData, {"", szIcon, v})
		end
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

--@function: 加载奖励
--@tbCurrency: tbData
function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:LoadReward(tbData)
	print("LoadReward", #(tbData or {}));
	if not tbData then
		return;
	end
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
		local nRow = math.floor((i-1)/self.m_MAXCOL) + 1;
		local nCol = (i-1) % self.m_MAXCOL + 1;
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
	end
	
	self.m_svReward:setVisible(true);
	for i = 1, nMax do
		fnUpdate(i, tbData[i]);
	end
	
end

--@function: 更新一个Item
function KGC_UI_REWARD_CUSTOM_LAYER_TYPE:UpdateItem(widget, tbData)
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