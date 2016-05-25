require("script/ui/forgingview/forginglayer")
require("script/ui/forgingview/forgingeffectlayer")
require("script/class/class_base_ui/class_base_logic")
require("script/core/configmanager/configmanager");

local makeConfigFile = mconfig.loadConfig("script/cfg/equip/make")
local itemConfigFile = mconfig.loadConfig("script/cfg/pick/item")

local cjson = require "cjson.core"
local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local TB_STRUCT_FORGING_LOGIC={

    resTab      =   {},         --资源消耗tab
    bookTab     =   {},         --卷轴消耗

    m_tbUpdateTypes = {             
        l_tbUIUpdateType.EU_BAG
    },    
}

ForgingLogic = class("ForgingLogic",KGC_UI_BASE_LOGIC, TB_STRUCT_FORGING_LOGIC);

function ForgingLogic:getInstance()
    if ForgingLogic.m_pLogic == nil then
        ForgingLogic.m_pLogic = ForgingLogic:create()
        GameSceneManager:getInstance():insertLogic(ForgingLogic.m_pLogic)
    end
	
    return ForgingLogic.m_pLogic
end

function ForgingLogic:Init()

end

function ForgingLogic:create()
    local _logic = ForgingLogic.new()
    _logic:Init()
    return _logic
end

function ForgingLogic:initLayer(parent,id,itemID)
    if self.pLayer then
    	return
    end

    self.pLayer = ForgingLayer:create();
    self.pLayer.id = id;
    parent:addChild(self.pLayer)

    -- 设置主界面底部按钮底框可见
    KGC_MainViewLogic:getInstance():ShowMenuBg();
end

function ForgingLogic:closeLayer()
    if self.pLayer then
		GameSceneManager:getInstance():removeLayer(self.pLayer.id);
		self.pLayer=nil
	end

    -- 设置主界面底部按钮底框不可见
    KGC_MainViewLogic:getInstance():HideMenuBg();
end


function ForgingLogic:OnUpdateLayer(iType, tbArg)
    if self.pLayer ==nil then 
        return;
    end
	
	if iType == l_tbUIUpdateType.EU_AFKERREWARD then
		if self.pLayer.m_pMainBtnLayer then
			local nPercent = (tbArg or {})[1] or 0;
			self.pLayer.m_pMainBtnLayer:SetRewardProgress(0, nPercent);
		end
    elseif iType == l_tbUIUpdateType.EU_SEARCH then
        if self.pLayer.m_pMainBtnLayer then
            local nSearchT = (tbArg or {})[1] or 0;
            self.pLayer.m_pMainBtnLayer:StartSearch(nSearchT);
        end
    elseif iType == l_tbUIUpdateType.EU_FIGHTHP then
        if self.pLayer.m_pMainBtnLayer then
            local nSelfHp = (tbArg or {})[1] or 0;
            local nEnemyHp = (tbArg or {})[2] or 0;
            self.pLayer.m_pMainBtnLayer:SetFightHp(nSelfHp, nEnemyHp);
        end
    elseif iType == l_tbUIUpdateType.EU_FIGHTRESULT then
        if self.pLayer.m_pMainBtnLayer then
            local bWin = (tbArg or {})[1] or false;
            local tReward = (tbArg or {})[2] or {};
            self.pLayer.m_pMainBtnLayer:SetResult(bWin, tReward);
        end
	end
end



---消息处理

--请求锻造
function ForgingLogic:reqForging(itemlist)

    local fnCallBack = function(tbArg)
        self:rspForging(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.scrollList = itemlist;
    g_Core.communicator.loc.makeEquip(tbReqArg,fnCallBack);

end

--请求锻造返回
function ForgingLogic:rspForging(pDate)
    -- body
    local equip = pDate.equipList;
    --增加新道具
    for k,v in pairs(equip) do
        me:GetBag():AddItem(k, v);
        TipsViewLogic:getInstance():addItemTips(v.id,v.num);
    end

    --消耗
    for k,v in pairs(self.resTab) do  
        me.m_Bag:SubItem(k,v);
    end

    --卷轴
    for k,v in pairs(self.bookTab) do
         me.m_Bag:SubItem(k,v);
    end

    --添加特效表现层
    local posTab = self.pLayer:getItemPositionTab();
    local effectLayer = ForgingEffectLayer:create(equip,posTab)
    self.pLayer:addChild(effectLayer);

    --更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG)
    
    self.pLayer:cleanLayer();
end
