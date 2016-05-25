--战斗宝箱tips界面

require("script/class/class_base_ui/class_base_sub_layer")
require "script/lib/basefunctions"
require("script/core/configmanager/configmanager");

local l_tbAfkConfig = mconfig.loadConfig("script/cfg/map/afkreward")
local l_tbDropConfig = mconfig.loadConfig("script/cfg/pick/drop")
local l_tbItems = mconfig.loadConfig ("script/cfg/pick/item")
local l_tbZOrder = mconfig.loadConfig("script/cfg/client/view/localzorder")
local l_tbLocalZOrder, l_tbGlobalZOrder = l_tbZOrder.tbLocal, l_tbZOrder.tbGlobal

local TB_STRUCT_FIGHT_CAGE_LAYER = {
	m_nHomeID = 0,			--挂机点id
	m_title = nil,			--标题
	m_infoMsg = nil,		--内容信息
	m_itemList = nil,		--道具列表
	m_startX = nil,			--起始点距左边界x
	m_startY = nil,			--起始点距上边界Y
	m_xDis = nil,			--x轴距离
	m_yDis = nil,			--y轴距离
}

FightCageLayer = class("FightCageLayer", KGC_UI_BASE_SUB_LAYER, TB_STRUCT_FIGHT_CAGE_LAYER)

--@param nHomeId 挂机点id
function FightCageLayer:create(nHomeID)
	local pLayer = FightCageLayer.new(nHomeID)
	return pLayer
end

function FightCageLayer:ctor(nHomeID)
	self.m_nHomeID = nHomeID
	self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_CAGE_TIP_PATH)
	self:addChild(self.m_pLayout)
	self:initUI()
end

function FightCageLayer:initUI()
	--标题
	self.m_title = ccui.Helper:seekWidgetByName(self.m_pLayout, "lbl_tital")
	--内容
	self.m_infoMsg = ccui.Helper:seekWidgetByName(self.m_pLayout, "lbl_info")
	--道具列表
	self.m_itemList = ccui.Helper:seekWidgetByName(self.m_pLayout, "sv_itemlist")

	local item1 = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_item1")
	local item1Y = item1:getPositionY()
	local item2 = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_item2")
	local item2X = item2:getPositionX()
	local item5 = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_item5")
	local item5Y = item5:getPositionY()
	self.m_startX = item1:getPositionX()
	self.m_startY = self.m_itemList:getInnerContainerSize().height - item1:getPositionY()
	self.m_xDis = item2X - self.m_startX
	self.m_yDis = item1Y - item5Y	

	self:addEvent()
	self:addItem()
end

function FightCageLayer:addEvent()
	--点空白关闭事件
	local function closeLayer(sender, type)
		if type == ccui.TouchEventType.ended then
    		local parent = self:getParent()
			if parent and parent.setStateCheckZOrder then
				parent:setStateCheckZOrder(false)
			end
    		self:closeLayer()
    	end
	end
	self.m_pLayout:addTouchEventListener(closeLayer)
end

function FightCageLayer:addItem()
	local tAfkInfo = l_tbAfkConfig[self.m_nHomeID]
	if tAfkInfo then
		local tDropInfo = l_tbDropConfig[tAfkInfo.ScoreReward]
		if tDropInfo then
			local tReward = {}
			if tDropInfo.foreverDrop then
				for i, v in ipairs(tDropInfo.foreverDrop) do
					table.insert(tReward, v)
				end
			end
			for i = 1, 10 do
				if tDropInfo["tepy" .. i] then
					table.insert(tReward, {tDropInfo["tepy" .. i][1], tDropInfo["tepy" .. i][2]})
				end
			end

			local item = ccui.Helper:seekWidgetByName(self.m_pLayout, "img_item1"):clone()
			self.m_itemList:removeAllChildren()
			
			self.m_itemList:setInnerContainerSize(cc.size(self.m_itemList:getInnerContainerSize().width, self.m_yDis - item:getChildByName("img_quality"):getContentSize().height +  self.m_yDis * math.ceil(#tReward / 4)))
			local nScrollH = self.m_itemList:getInnerContainerSize().height
			for i, v in ipairs(tReward) do
				local itemCopy = item:clone()
				self.m_itemList:addChild(itemCopy)
				itemCopy:setPosition(cc.p(self.m_startX + self.m_xDis * ((i - 1) % 4), nScrollH - self.m_startY - self.m_yDis * math.floor((i - 1) / 4)))
				local icon = itemCopy:getChildByName("img_icon")
				local num = itemCopy:getChildByName("bml_num")
				if type(v[1]) == "number" then 	--道具
					icon:loadTexture(l_tbItems[v[1]].itemIcon)
				else  --货币
					if gf_GetIconStructByType(v[1]) then
						icon:loadTexture(gf_GetIconStructByType(v[1]).iconpath)
					end
				end		
				num:setString(v[2])	
			end
		end
	end
end