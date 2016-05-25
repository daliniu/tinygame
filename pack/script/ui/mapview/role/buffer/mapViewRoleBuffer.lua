--buffer（地图探索中角色身上的buffer）
require("script/core/configmanager/configmanager");
local buffConfigFile = mconfig.loadConfig("script/cfg/map/buffexp")

MapViewRoleBuffer = class("MapViewRoleBuffer",function()
	return cc.Node:create()
end,TB_MAP_VIEW_ROLE_BUFFER)

MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_PER		=	1;		--减少移动消耗（百分比）
MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_VALUE	=	2;		--减少移动消耗（值）
MapViewRoleBuffer.TYPE_ADD_MOVE_CON_PER			=	3;		--增加移动消耗（百分比)
MapViewRoleBuffer.TYPE_ADD_REWARD_PER			=	4;		--奖励加成(百分比)
MapViewRoleBuffer.TYPE_REDUCE_PRICE_PER			=	5;		--降价(百分比)

local TB_MAP_VIEW_ROLE_BUFFER={
	hp,				--生命值
	role,			--角色
	id,				--id
	iType,			--类型
	spDisplay,		--显示图片
	iValue,			--值
	pConfig,		--配置
}

function MapViewRoleBuffer:create()
	self = MapViewRoleBuffer.new()
	return self
end

function MapViewRoleBuffer:ctor()
	self.hp = 1
	
end

function MapViewRoleBuffer:initAttr()
	-- body
end

function MapViewRoleBuffer:reduceLive(iValue)
	self.hp = self.hp - iValue
	if self.hp <=0 then 
		--移除自身
		
	end
end

function MapViewRoleBuffer:initConfig(id)
	id = tonumber(id)
	self.pConfig = buffConfigFile[id]
end


-----------------------------------------------------------------------------------------
----减少移动消耗（百分比）
MV_RoleBuffer_reduceMoveConPer = class("MV_RoleBuffer_reduceMoveConPer",function()
	return MapViewRoleBuffer:create()
end)

function MV_RoleBuffer_reduceMoveConPer:create(role,id,ihp)
	self = MV_RoleBuffer_reduceMoveConPer:new()
	self.role = role
	self.id = id
	self.hp = ihp;
	self:initAttr()
	return self
end

function MV_RoleBuffer_reduceMoveConPer:initAttr()
	-- body
	self:initConfig(self.id)
	self.iValue = (self.pConfig.EffectArg/100)
	self.iType = MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_PER
	if self.hp==nil then 
		self.hp = self.pConfig.TimeArg;
	end

	-- local resNum= ccui.Text:create()
 --    self:addChild(resNum)
 --    resNum:setFontSize(20)
 --    resNum:setString("移动消耗减少(百分比)")
 --   	resNum:setPositionY(100)
end

-------------------------------------------------------------------------------------------
--减少移动消耗（值）
MV_roleBuffer_reduceMoveConValue = class("MV_roleBuffer_reduceMoveConValue",function()
	return MapViewRoleBuffer:create()
end)

function MV_roleBuffer_reduceMoveConValue:create(role,id,ihp)
	self = MV_roleBuffer_reduceMoveConValue:new()
	self.role = role
	self.id = id
	self.hp = ihp;
	self:initAttr()
	return self
end

function MV_roleBuffer_reduceMoveConValue:initAttr()
	self:initConfig(self.id)
	self.iValue = self.pConfig.EffectArg
	self.iType = MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_VALUE
	if self.hp==nil then 
		self.hp = self.pConfig.TimeArg;
	end	

	-- local resNum= ccui.Text:create()
 --    self:addChild(resNum)
 --    resNum:setFontSize(20)
 --    resNum:setString("移动消耗减少(值)")
 --   	resNum:setPositionY(100)
end


-------------------------------------------------------------------------------------------
--增加移动消耗（值)
MV_roleBuffer_addMoveConValue = class("MV_roleBuffer_addMoveConValue",function()
	return MapViewRoleBuffer:create()
end)

function MV_roleBuffer_addMoveConValue:create(role,id,ihp)
	self = MV_roleBuffer_addMoveConValue:new()
	self.role = role
	self.id = id
	self.hp = ihp;
	self:initAttr()
	return self
end

function MV_roleBuffer_addMoveConValue:initAttr()
	self:initConfig(self.id)
	self.iValue = self.pConfig.EffectArg
	if self.hp==nil then 
		self.hp = self.pConfig.TimeArg;
	end	

	-- local resNum= ccui.Text:create()
 --    self:addChild(resNum)
 --    resNum:setFontSize(20)
 --    resNum:setString("移动消耗增加(值)")
 --   	resNum:setPositionY(100)
end

-------------------------------------------------------------------------------------------
--增加移动消耗（百分比)
MV_roleBuffer_addRewardPer = class("MV_roleBuffer_addRewardPer",function()
	return MapViewRoleBuffer:create()
end)

function MV_roleBuffer_addRewardPer:create(role,id,ihp)
	self = MV_roleBuffer_addRewardPer:new()
	self.role = role
	self.id = id
	self.hp = ihp;
	self:initAttr()
	return self
end

function MV_roleBuffer_addRewardPer:initAttr()
	self:initConfig(self.id)
	self.iValue = (self.pConfig.EffectArg/100)
	self.iType = MapViewRoleBuffer.TYPE_ADD_MOVE_CON_PER
	if self.hp==nil then 
		self.hp = self.pConfig.TimeArg;
	end	

	-- local resNum= ccui.Text:create()
 --    self:addChild(resNum)
 --    resNum:setFontSize(20)
 --    resNum:setString("移动消耗增加(百分比)")
 --   	resNum:setPositionY(100)
end

-------------------------------------------------------------------------------------------
--降价(百分比)
MV_roleBuffer_reducePricePer = class("MV_roleBuffer_reducePricePer",function()
	return MapViewRoleBuffer:create()
end)

function MV_roleBuffer_reducePricePer:create(role,id,ihp)
	self = MV_roleBuffer_reducePricePer:new()
	self.role = role
	self.id = id
	self.hp = ihp;
	self:initAttr()
	return self
end

function MV_roleBuffer_reducePricePer:initAttr()
	self:initConfig(self.id)
	self.iValue = self.pConfig.EffectArg
	if self.hp==nil then 
		self.hp = self.pConfig.TimeArg;
	end
		
end