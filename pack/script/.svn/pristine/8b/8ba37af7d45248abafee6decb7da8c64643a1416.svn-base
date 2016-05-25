require("script/ui/itemcomview/itemcomlayer")
require("script/class/class_base_ui/class_base_logic")

local cjson = require('cjson.core')
local l_tbUIUpdateType = def_GetUIUpdateTypeData();




ItemComLogic = class("ItemComLogic",KGC_UI_BASE_LOGIC, TB_STRUCT_BAG_VIEW_LOGIC);

function ItemComLogic:getInstance()
    if ItemComLogic.m_pLogic == nil then
        ItemComLogic.m_pLogic = ItemComLogic:create()
        GameSceneManager:getInstance():insertLogic(ItemComLogic.m_pLogic)
    end
	
    return ItemComLogic.m_pLogic
end

function ItemComLogic:Init()

end

function ItemComLogic:create()
    local _logic = ItemComLogic.new()
    _logic:Init()
    return _logic
end

function ItemComLogic:initLayer(parent,id,itemID)
    if self.pLayer then
    	return
    end

    self.pLayer = ItemComLayer:create(itemID);
    self.pLayer.id = id;
    parent:addChild(self.pLayer)

end

function ItemComLogic:closeLayer()
    if self.pLayer then
		GameSceneManager:getInstance():removeLayer(self.pLayer.id);
		self.pLayer=nil
	end
end

--请求合成物品
function ItemComLogic:reqCom(item,composeid,num)

    local fnCallBack = function(tbArg)
        self:rspCom(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.item = tonumber(item);
    tbReqArg.composeid = tonumber(composeid);
    tbReqArg.num = tonumber(num);
    g_Core.communicator.loc.compose(tbReqArg,fnCallBack);

end

--合成物品返回
function ItemComLogic:rspCom(pDate)
    local targetID  = pDate.target;
    local num       = pDate.num;
    local costings  = cjson.decode(pDate.costings);

    local tbItem ={};
    tbItem.id = targetID;
    tbItem.num = num;
    me.m_Bag:AddItem(targetID,tbItem);

    --消耗
    for k,v in pairs(costings) do
         me.m_Bag:SubItem(tonumber(k),v);
    end

    --更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_BAG)

    self:closeLayer();

end

