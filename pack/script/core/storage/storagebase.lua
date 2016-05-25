----------------------------------------------------------
-- file:	storagebase.lua
-- Author:	page
-- Time:	2015/06/02
-- Desc:	base class of various bags
----------------------------------------------------------
require "script/core/item/head"
--------------------------------
local l_tbItemTypeGenre, l_tbItemTypeDetail = def_GetItemType();
--data struct 
local TB_STRUCT_STORAGE_BASE = {
	m_nMax = 0,					--最大存储空间
	
	m_tbItems = {},				--道具表(放道具对象)
}
--------------------------------)
KGC_STORAGE_BASE_TYPE = class("KGC_STORAGE_BASE_TYPE", CLASS_BASE_TYPE, TB_STRUCT_STORAGE_BASE)
--------------------------------
--function
--------------------------------

function KGC_STORAGE_BASE_TYPE:ctor()	
	
end

function KGC_STORAGE_BASE_TYPE:Init(nMax, tbItems, tbEquips)
	if nMax then
		self:SetMaxSize(nMax)
	end
	
	self:InitItems(tbItems)
	self:InitEquips(tbEquips)
	
	self:OnInit(tbItems)
	
	--test
	-- local tbTestItems = self:GetItems()
	-- print("背包道具个数：", #tbTestItems)
	--test end
end

function KGC_STORAGE_BASE_TYPE:GetMaxSize()
	return self.m_nMax;
end

function KGC_STORAGE_BASE_TYPE:SetMaxSize(nMax)
	if type(nMax) ~= "number" then
		cclog("[Error]错误的数据类型@SetMax")
		return false;
	end
	self.m_nMax = nMax;
end


--根据服务器数据初始化
function KGC_STORAGE_BASE_TYPE:InitItems(tbDatas)
	for nIndex, tbItem in pairs(tbDatas or {}) do
		self:AddItem(nIndex, tbItem);
	end
end

--根据服务器数据初始化
function KGC_STORAGE_BASE_TYPE:InitEquips(tbDatas)
	for nIndex, tbItem in pairs(tbDatas or {}) do
		self:AddItem(nIndex, tbItem)
	end
end

function KGC_STORAGE_BASE_TYPE:GetItems()
	if not self.m_tbItems then
		self.m_tbItems = {};
	end
	
	return self.m_tbItems;
end

function KGC_STORAGE_BASE_TYPE:GetItemByID(id)
	local tbItems = self:GetItems();
	for i, item in pairs(tbItems) do
		if item.m_nID == id then
			return item
		end
	end
	return nil;
end

--@function: 更Index获取某一个道具, Index唯一
function KGC_STORAGE_BASE_TYPE:GetItemByIndex(nIndex)
	local tbItems, tbIndex = self:GetItemsHashTable();
	
	-- 道具唯一Index -->道具 + 道具在背包中的table索引
	return tbItems[nIndex], tbIndex[nIndex];
end


--@function: 获取背包使用大小
function KGC_STORAGE_BASE_TYPE:GetUsedSize()
	local iNum=0;
	local tbItems = self:GetItems();
	for i,v in ipairs(tbItems) do
		iNum=iNum+v:GetGirdSpace();
	end
	return iNum;
end

--@function: 根据服务器索引增加一个道具(道具或者装备)
--@tbItem: 服务器返回的结构
--[[
tbItem = {
	id = ,
	nNum = ,
	---------------------
	装备附加属性
	装备星级
}
]]
function KGC_STORAGE_BASE_TYPE:AddItem(nIndex, tbItem)
	local nIndex = tostring(nIndex);
	local nID = tbItem.id;
	local nNum = tbItem.num;
	if not nID then
		nID = tonumber(nIndex);
	end

	if not _SERVER then
		--临时给个提示
		--TipsViewLogic:getInstance():addItemTips(nID,nNum)
	end

	local item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(nID, nIndex, nNum)
	if item:GetTypeGenre() == l_tbItemTypeGenre.G_EQUIP then
		local nStar = tbItem.star
		local tbAttrs = {}
		tbAttrs[1] = {tbItem.a1, tbItem.n1}
		tbAttrs[2] = {tbItem.a2, tbItem.n2}
		tbAttrs[3] = {tbItem.a3, tbItem.n3}
		tbAttrs[4] = {tbItem.a4, tbItem.n4}
		
		item = KGC_ITEM_MANAGER_TYPE:getInstance():MakeEquip(nID, nIndex, tbAttrs, nStar)
	end
	
	local obj, num = self:Insert(nIndex, item)
	return obj, num;
end

--@function: 加入一个道具到背包
--@return: 返回增加的数量
function KGC_STORAGE_BASE_TYPE:Insert(nIndex, item)
	local nIndex = tostring(nIndex)
	local tbHash = self:GetItemsHashTable();
	local obj = item;
	local nAddNum = item:GetNum() or 0;
	if not tbHash[nIndex] then
		local tbItems = self:GetItems();
		table.insert(tbItems, item);
	else
		obj = tbHash[nIndex]
		-- 装备没有数量，不会叠加
		if item:GetTypeGenre() ~= l_tbItemTypeGenre.G_EQUIP then
			obj:AddNum(item:GetNum())
		end
	end
	return obj, nAddNum;
end

--@function：得到根据index作为key的table
function KGC_STORAGE_BASE_TYPE:GetItemsHashTable()
	local tbItems = self:GetItems();
	local tbRet = {}		-- 索引对应item
	local tbRet1 = {}		-- 索引对应table的索引
	-- print("[Log]#GetItemsHashTable", #tbItems)
	for i, item in pairs(tbItems) do
		local nIndex = item:GetIndex()
		if tbRet[nIndex] then
			print("[Error]出现相同索引的道具", nIndex)
		end
		tbRet[nIndex] = item;
		tbRet1[nIndex] = i;
	end
	
	--test
	-- cclog("[Log]背包情况 = (%d)", #tbItems)
	-- for k, v in pairs(tbRet) do
		-- cclog("\tindex[%d] = id(%d), (%s)", k, v:GetID(), v:GetName())
	-- end
	--test end
	return tbRet, tbRet1;
end

--@function：根据主类型获取道具信息
function KGC_STORAGE_BASE_TYPE:GetItemsByGenre(nType)
	local tbItems = self:GetItems();
	local tbRet = {}
	for i, item in pairs(tbItems) do
		if item:GetTypeGenre() == nType then
			table.insert(tbRet, item)
		end
	end
	
	return tbRet;
end

--@function：根据副类型获取道具信息
function KGC_STORAGE_BASE_TYPE:GetItemsByDetail(nType)
	local tbItems = self:GetItems();
	local tbRet = {}
	for i, item in pairs(tbItems) do
		if item:GetTypeDetail() == nType then
			table.insert(tbRet, item)
		end
	end
	
	return tbRet;
end

--@function: 减少某个道具数量
function KGC_STORAGE_BASE_TYPE:SubItem(nIndex, nNum)
	local nIndex = tostring(nIndex)
	local item, nTableIndex = self:GetItemByIndex(nIndex)
	if item then
		local nLeft = item:SubNum(nNum)

		--TipsViewLogic:getInstance():subItemTips(item:GetID(),nNum)

		cclog("[Log]@SubItem道具(%s)减少(%d), 剩余(%d)", nIndex, nNum, nLeft)
		if nLeft <= 0 then
			self:SubItemByTableIndex(nTableIndex)
			item:Delete();
		end
	else
		cclog("[Error]删除的道具不存在@SubItem(%s, %s)", tostring(nIndex), tostring(nNum))
	end
end

--@function: 通过ID减少某个道具数量
function KGC_STORAGE_BASE_TYPE:SubItemByID(nID, nNum)
	local item = self:GetItemByID(nID);
	if item then
		self:SubItem(item:GetIndex(), nNum);
	else
		cclog("[Error]删除的道具不存在@SubItemByID(%s, %s)", tostring(nID), tostring(nNum))
	end
end

--@function: 根据table索引, 删除table内容, nIndex是一个数字
function KGC_STORAGE_BASE_TYPE:SubItemByTableIndex(nIndex)
	local tbItems = self:GetItems();
	print("[Log]删除前，背包总个数为：", #tbItems)
	if type(nIndex) == "number" and nIndex > 0 and nIndex <= #tbItems then
		table.remove(tbItems, nIndex);
	else
		cclog("[Error]删除道具出现问题@SubItemByTableIndex(nIndex(%s))", tostring(nIndex))
	end
	
	local tbItems = self:GetItems();
	print("[Log]删除后，背包总个数为：", #tbItems)
end

--@function: 获取某个类型最好的装备
--@nType: 某种类型的装备
function KGC_STORAGE_BASE_TYPE:GetBestEquip(nType, oldEquip)
	local tbEquips = self:GetItemsByDetail(nType);
	
	local fnIsValid = function(equip, oldEquip)
		if not equip then
			return false;
		end
		if equip:IsEquip() then
			return false;
		end
		if oldEquip and oldEquip:GetFightPoint() >= equip:GetFightPoint() then
			return false;
		end
		return true;
	end
	-- 获取没有被穿上，并且比当前装备战斗力大
	local tbRet = {};
	for _, equip in pairs(tbEquips) do
		-- 没有被穿上，并且比当前装备战斗力大
		if fnIsValid(equip, oldEquip) then
			table.insert(tbRet, equip);
		end
	end
	
	-- 按照战斗力排序
	local fnCmp = function(a, b)
		return a:GetFightPoint() > b:GetFightPoint();
	end
	table.sort(tbRet, fnCmp);
	
	--test
	-- cclog("[log]部位(%s)的装备为：", tostring(nType));
	-- for k, equip in pairs(tbRet) do
		-- print("\t", k, equip:GetName(), equip:GetFightPoint());
	-- end
	--test end
	return tbRet[1];
end
----------------------------------------------------------
--test
function KGC_STORAGE_BASE_TYPE:TestPrintStorage()
	local tbItems = self:GetItemsHashTable();
	local nCount = 0;
	for index, item in pairs(tbItems) do
		nCount = nCount + 1;
		cclog("\t[%d] = %s, 数量(%d)", index, item:GetName(), item:GetNum())
	end
	print("背包道具总数量：", nCount);
end
