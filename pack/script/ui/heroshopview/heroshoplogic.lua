----------------------------------------------------------
-- file:	heroshoplogic.lua
-- Author:	page
-- Time:	2015/09/16 16:45
-- Desc:	英雄商店面板逻辑管理类
----------------------------------------------------------
require("script/ui/heroshopview/heroshoplayer")
require("script/class/class_base_ui/class_base_logic")

local TB_STRUCT_UI_HERO_SHOP_LOGIC = {
	m_pLogic = nil,
	m_pLayer = nil,
}

KGC_HERO_SHOP_LOGIC_TYPE=class("KGC_HERO_SHOP_LOGIC_TYPE", KGC_UI_BASE_LOGIC, TB_STRUCT_UI_HERO_SHOP_LOGIC)


function KGC_HERO_SHOP_LOGIC_TYPE:getInstance()
	if not KGC_HERO_SHOP_LOGIC_TYPE.m_pLogic then
        KGC_HERO_SHOP_LOGIC_TYPE.m_pLogic = KGC_HERO_SHOP_LOGIC_TYPE.new()
		GameSceneManager:getInstance():insertLogic(KGC_HERO_SHOP_LOGIC_TYPE.m_pLogic)
	end
	return KGC_HERO_SHOP_LOGIC_TYPE.m_pLogic
end

function KGC_HERO_SHOP_LOGIC_TYPE:initLayer(parent, id, tbArg)
	local tbIDs, nTimes, nSecond = unpack(tbArg or {});
    if self.m_pLayer then
		self.m_pLayer:UpdateData(tbIDs, nTimes, nSecond);
    	return;
    end
	
    self.m_pLayer = KGC_HERO_SHOP_LAYER_TYPE.new()
	self.m_pLayer:Init(tbIDs, nTimes, nSecond);
	
    self.m_pLayer.id = id
    parent:addChild(self.m_pLayer)
end

function KGC_HERO_SHOP_LOGIC_TYPE:closeLayer()
	if self.m_pLayer then
		GameSceneManager:getInstance():removeLayer(self.m_pLayer.id);
		self.m_pLayer = nil
	end
end

function KGC_HERO_SHOP_LOGIC_TYPE:updateLayer(iType)

end

---------------------------------------------------------------
--@function: 请求英雄商店内容
--@nFlag: 1表示刷新  0 不刷新(即请求数据)
function KGC_HERO_SHOP_LOGIC_TYPE:ReqHeroShop(nFlag)
	local fnCallCallBack = function(tbArg)
		print("[协议接收]英雄商店刷新返回结果: ")
		tst_print_lua_table(tbArg);
		local tbItemIDs = {}
		tbItemIDs[1] = tbArg.shop1;
		tbItemIDs[2] = tbArg.shop2;
		tbItemIDs[3] = tbArg.shop3;
		tbItemIDs[4] = tbArg.shop4;
		tbItemIDs[5] = tbArg.shop5;
		local nTimes = tbArg.refreshNums;
		local nSecond = tbArg.time;
		
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_HEROSHOP, {tbItemIDs, nTimes, nSecond})
	end
	
	local tbArgReq = {};
	tbArgReq.isRefresh = nFlag or 0;
	cclog("[协议发送]请求英雄商店刷新：isRefresh(%s)", tostring(tbArgReq.isRefresh));
	g_Core.communicator.loc.refreshHeroShop(tbArgReq, fnCallCallBack);
end


--@function: 请求购买碎片
function KGC_HERO_SHOP_LOGIC_TYPE:ReqBuy(nShop, nItemID)
	local fnCallCallBack = function(tbArg)
		print("[协议接收]购买碎片返回结果: ")
		tst_print_lua_table(tbArg);
		local tbItems = tbArg.bagItem
		
		-- 删除材料
		local bRet = true;
		local tbMaterials = KGC_ITEM_MANAGER_TYPE:getInstance():GetComposeMaterials(nItemID) or {};
		for _, tbData in pairs(tbMaterials) do
			local nID, nNum = unpack(tbData);
			me:GetBag():SubItemByID(nID, nNum);
		end
		
		-- 增加碎片
		for nIndex, tbData in pairs(tbItems.itemList or {}) do
			local item = me:GetBag():AddItem(nIndex, tbData);
		end
		for nIndex, tbData in pairs(tbItems.equipList or {}) do
			local item = me:GetBag():AddItem(nIndex, tbData);
		end
		
		-- 刷新
		self.m_pLayer:UpdateGoodsByIndex(nShop);
	end
	
	local tbArgReq = {};
	tbArgReq.shopId = nShop or 0;
	cclog("[协议发送]请求购买碎片：shopId(%s)", tostring(tbArgReq.shopId));
	g_Core.communicator.loc.shopHero(tbArgReq, fnCallCallBack);
end