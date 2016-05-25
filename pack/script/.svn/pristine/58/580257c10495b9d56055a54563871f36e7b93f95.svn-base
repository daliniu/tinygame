require("script/class/class_base_ui/class_base_sub_layer")
require("script/ui/announcementview/announcementrichtext");

local ANNOUN_TIMELY_LAYER_TB={
	Panel_info = nil,	--信息层父物体
}

AnnounTimelyLayer = class("AnnounTimelyLayer",function()
	return KGC_UI_BASE_SUB_LAYER:create()
end)


function AnnounTimelyLayer:create()
	self = AnnounTimelyLayer.new();
	self:initAttr()
	return self;
end

function AnnounTimelyLayer:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/announcementTimelyLayer.json")
    self:addChild(self.pWidget)

    self.pLogic = AnnounTimelyLogic:getInstance()

    self.Panel_info = self.pWidget:getChildByName("Panel_info")
end


function AnnounTimelyLayer:initAttr()

end

function AnnounTimelyLayer:addNewInfo(info)
	if info ==nil then 
		return;
	end
	local function fun_nextInfo()
		self:addNewInfo(self.pLogic:getInfo())
	end


	local infoNode = cc.Node:create();
	self.Panel_info:addChild(infoNode);
	infoNode:setPositionX(self.Panel_info:getContentSize().width)

	--info
	local pTab={
					{{type="text",info="PK",size="30",color="FF0000"},
						{type="text",info="是个",size="30",color="00FF00"},
						{type="text",info="大",size="30",color="0000FF"},
						{type="text",info="SB",size="30",color="FFFFFF"},
						{type="image",width="30",height="30",src="res/ui/picture/00_pic_buff_01.png"}}
				}
	local pElement = AnnouncementRichText:create(pTab)
	infoNode:addChild(pElement)

	local iLen =pElement.length
	local fMoveTime =10;
	local fDir = (self.Panel_info:getContentSize().width+iLen)*-1;
	local moveTarget = cc.p(fDir,0)
	local pAction = cc.Sequence:create(cc.MoveBy:create(fMoveTime,moveTarget),
											cc.CallFunc:create(fun_nextInfo),
											cc.RemoveSelf:create())
	infoNode:runAction(pAction)

end

function AnnounTimelyLayer:addInfo()
	if self.Panel_info:getChildrenCount()>0 then 
		return;
	end

	local info = self.pLogic:getInfo();
	self:addNewInfo(info)

end