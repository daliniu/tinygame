require("script/ui/mapview/role/buffer/mapViewRoleBufferFactory")
require("script/ui/mapview/effect/mapViewGetResTips")
require("script/core/configmanager/configmanager");

local ruleConfig = mconfig.loadConfig("script/cfg/client/map_rule");
local buffConfigFile = mconfig.loadConfig("script/cfg/map/buffexp");

local STRING_IDLE ="standby"
local STRING_RUN ="run"
local STRING_WALK ="walk"


MapViewRole = class("MapViewRole",function()
    return cc.Node:create()
end,TB_MAP_VIEW_ROLE)

local TB_MAP_VIEW_ROLE={
    lastPos                 =nil,     --上一次移动前所处的位置
    lastIndexPos            =nil,     --上一次的index
    isMoving                =nil,     --移动过程中玩家不能发布新的移动命令
    display                 =nil,     --显示精灵
    currentPointIndex       =nil,     --当前位置
    visionField             =nil,     --视野
    maxPerStep              =nil,     --每次最大移动步数
    physical                =nil,     --体力
    lastGetInBuildingUID    =nil,     --上一次进入的建筑uid
    lastOnHookPointUID      =nil,     --上一个挂机点
    currentOnHookPointUID   =nil,     --当前的挂机点
    teamHPMax               =nil,     --队伍最大生命值
    bufferNode              =nil,     --buffer节点
    bufferEffect            =nil,     --buff特效
}

function MapViewRole:create()
    self = MapViewRole:new()
    self:initAttr()
    return self
end


function MapViewRole:ctor()
    
end

function MapViewRole:setCurrentPosIndex(PointIndex)
    self:updateLastPos();
    if PointIndex==nil then
        return;
    end
    if self.currentPointIndex then
        self.lastIndexPos = cc.p(self.currentPointIndex.x,self.currentPointIndex.y);
    else
        self.lastIndexPos = cc.p(PointIndex.x,PointIndex.y);
    end
    self.currentPointIndex = cc.p(PointIndex.x,PointIndex.y);
end


function MapViewRole:initAttr()

    self.visionField    =   3;
    self.isMoving       =   false;
    self.maxPerStep     =   ruleConfig.MAX_STEPS;
    self.physical       =   me:GetAP();
    self.teamHPMax      =   100;

    self.display = sp.SkeletonAnimation:create("res/ANI/model/hero/action_hero_01/action_hero_01.json", 
                                                    "res/ANI/model/hero/action_hero_01/action_hero_01.atlas", 1);
    self:addChild(self.display)

    self:playAnimation(STRING_IDLE)

    self.bufferNode = cc.Node:create()
    self:addChild(self.bufferNode)
end

function MapViewRole:updatePhysical()
    self.physical = me:GetAP();
end

function MapViewRole:getPosIndex()
    return self.currentPointIndex
end

--设置位置
function MapViewRole:setPositionWithTitle(indexPoint,position,tileSize)
    -- body
    self:setCurrentPosIndex(indexPoint)
    local pos = cc.p(position.x,position.y);
    local titleSize = tileSize;
    pos.x = pos.x + titleSize.width*0.5
    pos.y = pos.y + titleSize.height*0.5
    self:setPosition(pos)
end

--移动开始
function MapViewRole:setMoveBegin(length)
    self.isMoving=true;
    local sType = STRING_WALK;
    if type(length) == "number" 
        and length>4 then 
        sType = STRING_RUN;
    end

    self:playAnimation(sType)

end

--移动完成
function MapViewRole:setMoveFinish()
    self.isMoving = false;
    self:playAnimation(STRING_IDLE)
    self:setAnimationSpeed(1);
end

--添加buffer
function MapViewRole:addBuffer(id)

    
    local pBuffer = MapViewRoleBufferFactory:getInstance():createBuffer(id,self)
    if pBuffer~=nil then 
        self.bufferNode:addChild(pBuffer)
    end


    --特效
    local function fun_playFinished(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.bufferEffect:removeFromParent();
            self.bufferEffec=nil
        end
    end

    if self.bufferEffect ==nil then 
		--test
		print("addArmatureFileInfo @ addBuffer");
		--test end
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ANI/effect/effect_map_buff_02/effect_map_buff_02.ExportJson");
        self.bufferEffect = ccs.Armature:create("effect_map_buff_02")
        self:addChild(self.bufferEffect);
        self.bufferEffect:setAnchorPoint(cc.p(0.5,0))
        self.bufferEffect:getAnimation():setMovementEventCallFunc(fun_playFinished)
        self.bufferEffect:getAnimation():playWithIndex(0);
    end
end


--更新buffer
function MapViewRole:updateBuffer(pTab)
    self.bufferNode:removeAllChildren();

    if pTab~=nil then
        for k,v in pairs(pTab) do
            local pBuffer = MapViewRoleBufferFactory:getInstance():createBuffer(v.id,self,v.value)
            if pBuffer~=nil then
                self.bufferNode:addChild(pBuffer)
            end
        end
    end

end

--删除buffer
function MapViewRole:removeBuffer()
    -- body
end

--购买物品特效
function MapViewRole:addBuyItemEffect(id,num)
    num = tonumber(num)
    local pEffect = MapViewBuyItemEffect:create(id,num)
    pEffect:setPosition(cc.p(self:getPositionX(),self:getPositionY()))
    self:getParent():addChild(pEffect)
    pEffect:setLocalZOrder(self:getLocalZOrder())
end


--获取团队体力剩余
function MapViewRole:getTeamHpPro()
    return me:GetTeamHp()/self.teamHPMax
end

--获取团队体力值
  function MapViewRole:getTeamHpValue()
    return me:GetTeamHp();
  end

--步骤消耗计算
function MapViewRole:physicalComputing(pathTab)
    local bufferTb = self.bufferNode:getChildren()
    local bVelue = 0;
    for i,var in pairs(bufferTb) do
        var.lsHp = var.hp;
    end

    local tabRet ={};

    for k,v in pairs(pathTab) do
        local iValue = v;
        for i,var in pairs(bufferTb) do
            if var.lsHp > 0 then
                if var.iType == MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_PER then
                    iValue = iValue*(1-var.iValue)
                elseif var.iType == MapViewRoleBuffer.TYPE_REDUCE_MOVE_CON_VALUE then
                    iValue = iValue-var.iValue
                elseif var.iType == MapViewRoleBuffer.TYPE_ADD_MOVE_CON_PER then
                    iValue = iValue*(1+var.iValue)
                end
                var.lsHp=var.lsHp-1;
            end
        end
        bVelue=bVelue+iValue;
        table.insert(tabRet,iValue);
    end

    return bVelue ,tabRet;
end

--更新上一次所处的位置
function MapViewRole:updateLastPos()
    self.lastPos = cc.p(self:getPosition());
end

--上一次所处的位置
function MapViewRole:getLastPos()
    if self.lastPos==nil then
        self.lastPos = cc.p(self:getPosition());
    end
    return self.lastPos;
end

--设置图片透明度
function MapViewRole:setDisplayOp(fValue)
    self.display:setOpacity(fValue);
end

--设置半透明图片
function MapViewRole:setMaskImag()
    self.display:removeFromParent();

    self.display = cc.Sprite:create("res/map/maprole_mask.png");
    self.display:setAnchorPoint(cc.p(0.5,0.0))
    self:addChild(self.display)
    
end


--播放动画
function MapViewRole:playAnimation(animString)
    self.display:setToSetupPose();
    self.display:setAnimation(0, animString, true)
end

--动画播放速度
function MapViewRole:setAnimationSpeed(value)
    self.display:setTimeScale(value)
end

--设置角色方向
function MapViewRole:setDirection(iDir)
    if self.display == nil then 
        return;
    end
    self.display:setScaleX(iDir);
end

--获取buff对时间的影响
function MapViewRole:getMoveTimeEffectByBuff(index,fMoveTime)
    local bufferTb = self.bufferNode:getChildren()

    local fValue =fMoveTime ;
    for i,var in pairs(bufferTb) do
        if index <= var.hp then
             fValue = fValue - fValue*tonumber(var.pConfig.SpeedUp)*0.01
        end
    end
    return fValue;
end

--检测角色是否在屏幕之内
function MapViewRole:isInScreen()
    local objWorldPos = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
    local screenSize = cc.p(750,1334)

    if objWorldPos.x>0 and objWorldPos.x<screenSize.x and 
        objWorldPos.y>0 and objWorldPos.y<screenSize.y then 
        return true;
    end

    return false;

end