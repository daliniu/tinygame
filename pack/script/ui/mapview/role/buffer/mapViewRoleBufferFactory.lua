--buffer工厂
require("script/ui/mapview/role/buffer/mapViewRoleBuffer")
require("script/core/configmanager/configmanager");

local buffexpFile = mconfig.loadConfig("script/cfg/map/buffexp")

MapViewRoleBufferFactory = class("MapViewRoleBufferFactory")

MapViewRoleBufferFactory.pFactory =nil

function MapViewRoleBufferFactory:getInstance()
	if MapViewRoleBufferFactory.pFactory ==nil then 
		MapViewRoleBufferFactory.pFactory = MapViewRoleBufferFactory.new()
	end
	return MapViewRoleBufferFactory.pFactory
end

function MapViewRoleBufferFactory:createBuffer(id,role,ivalue)

	local pConfig = buffexpFile[id]
	local iType = pConfig.Effecttype;
	local pBuffer = nil

	if iType == MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_PER then
		pBuffer =MV_RoleBuffer_reduceMoveConPer:create(role,id,ivalue)
		
	elseif iType == MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_VALUE then
		pBuffer =MV_roleBuffer_reduceMoveConValue:create(role,id,ivalue)
		
	elseif iType == MapViewRoleBuffer.TYPE_ADD_MOVE_CON_PER	then
		pBuffer =MV_roleBuffer_addMoveConValue:create(role,id,ivalue)
		
	elseif iType == MapViewRoleBuffer.TYPE_ADD_REWARD_PER then 
		pBuffer =MV_roleBuffer_addRewardPer:create(role,id,ivalue)
		
	elseif iType == MapViewRoleBuffer.TYPE_REDUCE_PRICE_PER then
		pBuffer =MV_roleBuffer_reducePricePer:create(role,id,ivalue)
	end

	return pBuffer
end