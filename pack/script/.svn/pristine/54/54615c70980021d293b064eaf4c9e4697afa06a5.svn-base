----------------------------------------------------------
-- file:	itemmanager.lua
-- Author:	page
-- Time:	2015/06/02
-- Desc:	manager item
----------------------------------------------------------
require "script/core/item/equip"
require("script/core/configmanager/configmanager");
--------------------------------

local l_tbComposeConfig = mconfig.loadConfig("script/cfg/equip/compose", true)
--data struct 
local TB_STRUCT_ITEM_MANAGER = {
	m_Instance = nil,	
}
--------------------------------)
KGC_ITEM_MANAGER_TYPE = class("KGC_ITEM_MANAGER_TYPE", CLASS_BASE_TYPE, TB_STRUCT_ITEM_MANAGER)
--------------------------------
--function
--------------------------------

function KGC_ITEM_MANAGER_TYPE:ctor()	
	
end

function KGC_ITEM_MANAGER_TYPE:getInstance()
	if not self.m_Instance then
		self.m_Instance = KGC_ITEM_MANAGER_TYPE.new();
		self.m_Instance:Init();
	end
	
	return self.m_Instance;
end

--------------------------------------------------------------
function KGC_ITEM_MANAGER_TYPE:Init(tbArg)
	
end


--@function: 创建一个物品
function KGC_ITEM_MANAGER_TYPE:MakeItem(nID, nIndex, nNum)
	local item = KGC_ITEM_BASE_TYPE.new(nID);

	item:Init(nIndex, nNum);
	
	return item;
end

--@function: 创建一件装备
function KGC_ITEM_MANAGER_TYPE:MakeEquip(nID, nIndex, tbAttrs, nStar)
	local equip = KGC_EQUIP_TYPE.new(nID);
	equip:Init(nIndex, tbAttrs, nStar);
	
	return equip;
end

--@function: 碎片合成需要的材料
function KGC_ITEM_MANAGER_TYPE:GetComposeMaterials(nID)
	for _, tbItem in pairs(l_tbComposeConfig) do
		local nItemID, tbMaterials = tbItem.itemId, tbItem.demandItemId
		if nItemID == nID then
			return tbMaterials;
		end
	end
end
----------------------------------------------------------
--test