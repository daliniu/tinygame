require("script/ui/tipsview/tipselement")
require("script/core/configmanager/configmanager");

local itemconfigfile = mconfig.loadConfig("script/cfg/pick/item")

local l_tbStringConfig = require("script/cfg/string")
local l_tbAttributeConfig = mconfig.loadConfig("script/cfg/client/action/attributechange");

local TB_TIPS_VIEW_LOGIC={
	pControl = nil,					-- 系统提示节点
	
	m_tbDataChangeNodes = {},		-- 属性变化节点
}

TipsViewLogic=class("TipsViewLogic",TB_TIPS_VIEW_LOGIC)


function TipsViewLogic:getInstance()
	if TipsViewLogic.pLogic==nil then
        TipsViewLogic.pLogic=TipsViewLogic:create()
	end

	return TipsViewLogic.pLogic
end

function TipsViewLogic:create()
    local _logic = TipsViewLogic:new()
    return _logic
end

function TipsViewLogic:initLayer(pParent)
	self.pControl = pParent;
end


--普通消息提示信息
function TipsViewLogic:addMessageTips(nMessageID)
	self:updateChild();

	local pNode = nil

	local massage = l_tbStringConfig[nMessageID]
	if massage == nil then 
		pNode = NormalTips:create(nMessageID)
	else
		pNode = NormalTips:create(massage..nMessageID)
	end

	self.pControl:addChild(pNode);
end

--普通消息提示信息
function TipsViewLogic:addMessageTipsEx(nMessageID, ...)
	self:updateChild();

	local pNode = nil

	local message = string.format(l_tbStringConfig[nMessageID], ...)
	
	if message == nil then 
		pNode = NormalTips:create(nMessageID)
	else
		pNode = NormalTips:create(message..nMessageID)
	end

	self.pControl:addChild(pNode);
end

--增加道具消息提示
function TipsViewLogic:addItemTips(id,num)
	self:updateChild();

	local itemName = itemconfigfile[tonumber(id)].itemName
	if itemName == nil then 
		itemName = id
	end

	local pmasg = "增加"..num.."个"..itemName;
	pNode = NormalTips:create(pmasg)
	self.pControl:addChild(pNode);
end

function TipsViewLogic:subItemTips(id,num)
	self:updateChild();

	local itemName = itemconfigfile[tonumber(id)].itemName
	if itemName == nil then 
		itemName = id
	end

	local pmasg = "减少"..num.."个"..itemName;
	pNode = NormalTips:create(pmasg)
	self.pControl:addChild(pNode);
end


function TipsViewLogic:updateChild()
	local pTb =self.pControl:getChildren();
	for i,var in pairs(pTb) do
		if not var.m_bIgnoreLogicUpdate then
			local pAction = cc.MoveBy:create(0.2,cc.p(0,65));
			var:runAction(pAction);
		end
	end
end

--@function: 消息提示框
function TipsViewLogic:addMessaBox(nMessageID, fnCallBack, pParent)
	local box = KGC_MESSAGEBOX_TYPE:create(nMessageID, fnCallBack)
	local posX, posY = box:getPosition();
	local size = box:getContentSize();

	box:setVisible(true)
	pParent:addChild(box);
end

--@function: 数值变化
function TipsViewLogic:addMessageDataChange(tbMessages)
	if not tbMessages then
		return;
	end
	
	self:UpdateAllNodes(self.m_tbDataChangeNodes);
	local szHead, nBefore, nAfter = unpack(tbMessages or {});
	local node = KGC_UI_ATTRIBUTE_CHANGE:create(szHead, nBefore, nAfter)
	self.m_tbDataChangeNodes[node] = true;
	-- print("增加一个节点：", tostring(node));
	
	self.pControl:addChild(node);
end

function TipsViewLogic:UpdateAllNodes(tbNodes)
	local nHeight = l_tbAttributeConfig.nHeightInterval or 80;
	local tbNodes = tbNodes or {};
	for k, v in pairs(tbNodes) do
		if v then
			local action = cc.MoveBy:create(0.1, cc.p(0, nHeight));
			k:runAction(action);
		end
	end
end

function TipsViewLogic:SubMessageNode(node)
	for k, v in pairs(self.m_tbDataChangeNodes or {}) do
		if k == node then
			-- print("删除一个节点：", tostring(node));
			self.m_tbDataChangeNodes[k] = nil;
		end
	end
	
	--test
	-- print("剩余节点：");
	-- for k, v in pairs(self.m_tbDataChangeNodes or {}) do
		-- print(111, tostring(k), tostring(v));
	-- end
	--test end
end
----------------------------------------------------------
--