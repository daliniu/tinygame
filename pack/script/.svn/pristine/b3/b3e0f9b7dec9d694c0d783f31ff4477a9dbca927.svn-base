require("script/class/class_base_ui/class_base_sub_layer")

UserGuideCheckNode = class("UserGuideCheckNode",function()
	return cc.Node:create();
end)


function UserGuideCheckNode:create()
	self = UserGuideCheckNode.new()
	self:initAttr();
	return self;
end


function UserGuideCheckNode:initAttr()
	
	local function update(dt)
		UserGuideLogic:getInstance():creatLogic();

	end

	 self:scheduleUpdateWithPriorityLua(update, 0);

end