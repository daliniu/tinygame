
--[[
	afkObj:{mapid,uid,guajiid}
	buffList:[{},{}]
	ap:200
]]--

--地图有一份特殊的背包数据
--[[


]]--

local worldmapConfigFile = mconfig.loadConfig("script/cfg/map/worldmap")

local TB_STRUCT_MAP_INFO={

	-- curMapID,		--当前地图id
	afkObj ={},				--当前挂机点
	-- lastAfkTime,		--上一次挂机时间
	-- afkList,			--挂机点列表
	buffList,			--buffer
	ap,					--团队体力

	currentNormalNodeID,		--当前普通副本的节点id
	--[[--   [openNode] = {
        [123] = {
            [process] = 98, // 当前节点进度
            [compAward] = 0,    // 节点通关宝箱是否领取 0--没有领，1--领了
        }
    }--]]--
	openNormalNodeTab={},		--普通副本已开启的节点
	timeingNormalNodeTab={}; 	--正在计时的普通副本
}

KGC_MAP_INFO_CLASS = class("KGC_MAP_INFO_CLASS",nil,TB_STRUCT_MAP_INFO);



function KGC_MAP_INFO_CLASS:create()
	self = KGC_MAP_INFO_CLASS.new();
	return self;
end


function KGC_MAP_INFO_CLASS:InitDate()

    local funCall = function(tbArg)

    	local curMapId 		= tbArg.curMapId;
    	local supply 		= tbArg.supply;
    	local bufferList 	= tbArg.buffList;
    	local curAfker 		= tbArg.curAfker;

    	self.ap=100;												--团队体力
    	if tbArg.curMapId~=nil then
    		if tbArg.curMapId == 0 then
    			MapViewLogic:getInstance().currentMapID =1;
    		else
    			MapViewLogic:getInstance().currentMapID = tbArg.curMapId;	--所在地图id
    			MapViewLogic:getInstance().maxMap = MapViewLogic:getInstance().currentMapID;
    		end
    	end
 		self.afkObj			= curAfker;								--当前挂机点数据
 		self.buffList		= bufferList;							--buffer
    end

    --g_Core.communicator.loc.getMapBaseInfo(funCall);	

end



-- --@function: 获取挂机点ID
function KGC_MAP_INFO_CLASS:GetMapID()
	if self.afkObj==nil then 
		return nil;
	end
	return self.afkObj.mapid;
end

function KGC_MAP_INFO_CLASS:SetMapID(nID)
	if self.afkObj==nil then 
		return nil;
	end	
	self.afkObj.mapid = nID or 0;
end

--@function：获取挂机点ID
function KGC_MAP_INFO_CLASS:GetFightPointID()
	if self.afkObj==nil then 
		return nil;
	end	
	return self.afkObj.guajiid;
end

function KGC_MAP_INFO_CLASS:SetFightPointID(nID)
	if self.afkObj==nil then 
		return nil;
	end	
	self.afkObj.guajiid = nID or 0;
end

--uid
function KGC_MAP_INFO_CLASS:GetFightPointUID()
	if self.afkObj==nil then 
		return nil;
	end	
	return self.afkObj.uid;
end

function KGC_MAP_INFO_CLASS:SetFightPointUID(nID)
	if self.afkObj==nil then 
		return nil;
	end	
	self.afkObj.uid = nID or 0;
end

--获取当前挂机点所有信息
function KGC_MAP_INFO_CLASS:GetCurAfker()
	return self.afkObj
end


-- function KGC_MAP_INFO_CLASS:GetAfkList()
-- 	return self.afkList;
-- end

function KGC_MAP_INFO_CLASS:GetBufferList()
	return self.buffList;
end

function KGC_MAP_INFO_CLASS:InitBuffDate(tbDate)
	self.buffList = tbDate;
end


function KGC_MAP_INFO_CLASS:GetTeamHp()
	return self.ap or 0
end

function KGC_MAP_INFO_CLASS:SetTeamHp(fValue)
	self.ap = fValue;
end

function KGC_MAP_INFO_CLASS:SetCurrentNoramlNodeID(id)
	self.currentNormalNodeID = id;
end

function KGC_MAP_INFO_CLASS:GetCurrentNoramlNodeID()
	return self.currentNormalNodeID;
end


---普通副本已开启的节点
function KGC_MAP_INFO_CLASS:AddNormalOpenNode(id)
	if self.openNormalNodeTab ==nil then 
		self.openNormalNodeTab={};
	end

	for k,v in pairs(self.openNormalNodeTab) do
		if tostring(id) == tostring(k) then 
			return;
		end
	end
	
	self.openNormalNodeTab[tostring(id)]={process=0,compAward=0};

end

function KGC_MAP_INFO_CLASS:CleanNoramOpenNode()
	self.openNormalNodeTab={};
end

function KGC_MAP_INFO_CLASS:GetNoramlOpenNode()
	return self.openNormalNodeTab;
end

function KGC_MAP_INFO_CLASS:SetNoramlOpenNode(pTab)
	self.openNormalNodeTab=pTab;
end


--设置当前节点已完成
function KGC_MAP_INFO_CLASS:setNodeFinish(nodeid)
	local nodeInfo = worldmapConfigFile[nodeid]
	if nodeInfo == nil then
		return;
	end
	self:AddNormalOpenNode(nodeInfo.Next)
end


-------普通副本正在计时的节点
function KGC_MAP_INFO_CLASS:SetTimeingNormalNode(pTab)
	self.timeingNormalNodeTab=pTab;
end

function KGC_MAP_INFO_CLASS:GetTimeingNormalNode(pTab)
	return self.timeingNormalNodeTab;
end


---检测节点是否已经开启
function KGC_MAP_INFO_CLASS:isNodeOpen(id)
	
	for k,v in pairs(self.openNormalNodeTab) do
		if tostring(k) == tostring(id) then 
			return true;
		end
	end

	print("aaaaaaaaaa")
	for k,v in pairs(self.timeingNormalNodeTab) do
		print("bbbbbbbbbb")
		print(k)
		if tostring(k) == tostring(id) then 
			return true;
		end
	end	

	return false;
end
