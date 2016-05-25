require("script/class/class_base_ui/class_base_layer")
require("script/ui/mapchooseview/layer/mapChooseHookPointInfo");
require("script/ui/mapchooseview/layer/mapChooseMapInfo");

MapChooseMapBase = class("MapChooseMapBase",function()
	return KGC_UI_BASE_LAYER:create()
end)

function MapChooseMapBase:create()
	self = MapChooseMapBase.new();
	return self;
end


function MapChooseMapBase:openMap(id)
	MapViewLogic:getInstance():openMap(id);
end

--图片变灰
function MapChooseMapBase:setImagGray(pWidget)
   	pWidget:getVirtualRenderer():setGLProgramState(SystemOpen:getInstance().glprogramstate)
end

--添加英雄头像
function MapChooseMapBase:addPlayerHead(panel)
    local pNode = cc.Node:create();
    local spBg = cc.Sprite:create("res/ui/16_mapchoose/16_bg_herocover_01.png");
    local spHead = cc.Sprite:create("res/ui/16_mapchoose/16_hero_face_01.png");
    pNode:addChild(spHead);
    pNode:addChild(spBg);
    pNode:setPosition(cc.p(100,200));

    panel:addChild(pNode);


    local pAnimUp = cc.EaseSineInOut:create(cc.MoveBy:create(1.0,cc.p(0,10)));
    local pAnimDown =cc.EaseSineInOut:create(cc.MoveBy:create(1.0,cc.p(0,-10)));
    local pAction = cc.RepeatForever:create(cc.Sequence:create(pAnimUp,pAnimDown));
    pNode:runAction(pAction);

end


function MapChooseMapBase:fun_map()
	local pPanel = MapChooseMapInfo:create();
	self:addChild(pPanel);
end

function MapChooseMapBase:fun_afk()
	local pPanel = MapChooseHookPointInfo:create();
	self:addChild(pPanel);
end