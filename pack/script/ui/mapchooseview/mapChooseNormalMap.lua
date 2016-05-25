require("script/ui/mapchooseview/mapChooseMapBase")
require("script/ui/mapchooseview/layer/mapChooseHookPointInfo");
require("script/ui/mapchooseview/layer/mapChooseMapInfo");

local worldMapFile = require("script/cfg/map/worldmap");

local MAP_CHOOSE_NORAML_MAP_TB={
	normalMapTab={},
}


MapChooseNoramlMap = class("MapChooseNoramlMap",function()
	return MapChooseMapBase:create()
end,MAP_CHOOSE_NORAML_MAP_TB)


function MapChooseNoramlMap:create()
	self = MapChooseNoramlMap.new();
    self:initAttr();
	return self;
end


function MapChooseNoramlMap:ctor()
	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile("res/chapter1.json")
    self:addChild(self.pWidget)


end

function MapChooseNoramlMap:OnExit()

end


function MapChooseNoramlMap:initAttr()

	local function fun_map(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local _layer = MapChooseMapInfo:create(sender.nodeID);
            self:addChild(_layer)
        end
	end

	local function fun_afk(sender,eventType)
        if eventType==ccui.TouchEventType.ended then
            local _layer = MapChooseHookPointInfo:create(sender.nodeID);
            self:addChild(_layer)            
        end
	end


	for k,v in pairs(worldMapFile) do
		if v.Type1 == 1 then
			table.insert(self.normalMapTab,k);
		end
	end


	local Panel_cp = self.pWidget:getChildByName("Panel_cp")
	for k,v in pairs(self.normalMapTab) do

		local item = Panel_cp:getChildByName(tostring(v))
		item.nodeID = v;
		if item~=nil then 

			local isOpen = me:GetMapInfo():isNodeOpen(v);
			if isOpen==true then 
				item:getChildByName("img_lock"):setVisible(false);
				item:setTouchEnabled(true)
			else
				item:getChildByName("img_lock"):setVisible(true);
				item:setTouchEnabled(false)
			end

			--点击事件
			if worldMapFile[v].Type2 == 1 then				--地图
				item:addTouchEventListener(fun_map);		
			elseif worldMapFile[v].Type2 == 2 then 			--挂机点
				item:addTouchEventListener(fun_afk);
			end
		end
	
	end

 --    self.pList = self.pWidget:getChildByName("ScrollView_list");

	-- local iSize = self.pList:getInnerContainerSize();

	-- self.pList:setInnerContainerSize(cc.size(iSize.width,iSize.height*2));

 --    for i,v in pairs(mapInfoConfigFile) do
 --    	local _item = self.ilandItme:clone();
 --    	self.pList:addChild(_item);
 --    	_item:setPositionY((i-1)*200+100);
 --    	_item:setTag(i);
 --    	_item:getChildByName("img"):loadTexture(mapInfoConfigFile[tostring(i)].PicMapItem);
 --    	_item:getChildByName("img_name"):loadTexture(mapInfoConfigFile[tostring(i)].PicMapName);
 --    	local iposx = i%2;
 --    	_item:setPositionX(iposx*350+70);
 --        if i == MapViewLogic:getInstance().currentMapID then 
 --            self:addPlayerHead(_item);
 --        end
 --    end


 --    self.pMapTb = self.pList:getChildren()

	-- for k,v in pairs(self.pMapTb) do
	-- 	if v:getTag()>MapViewLogic:getInstance().maxMap then 
	-- 		self:setImagGray(v:getChildren()[1]);
	-- 	end
	-- 	v:addTouchEventListener(fun_opeMap)
	-- end

	-- self:runAction(cc.CallFunc:create(onEnterDate,{}))

end

