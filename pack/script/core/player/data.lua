---------------------------------------------------------------
-- file:	data.lua
-- Author:	page
-- Time:	2015/06/30 11:56
-- Desc:	玩家一些数据：(1)装备; (2)
--			
---------------------------------------------------------------

local l_tbEquipPos = def_GetPlayerEquipPos();

local TB_STRUCT_PLAYER_EQUIP_SLOT = {
	-- 装备结构
	m_tbEquips = {
		--[1] = equip_index,
		--[2] = equip_index,
		--[3] = equip_index,
		--[4] = equip_index,
		--[5] = equip_index,
		--[6] = equip_index,
	},
	
	m_nIndex = 0,						-- 属于第几套装备
	
	m_ship = nil,						-- 战队对象
}

KGC_PLAYER_EQUIP_SLOT_TYPE = class("KGC_PLAYER_EQUIP_SLOT_TYPE", KGC_DATA_BASE_TYPE, TB_STRUCT_PLAYER_EQUIP_SLOT)

function KGC_PLAYER_EQUIP_SLOT_TYPE:ctor(nIndex, ship)
	self.m_ship = ship;
	for v, k in pairs(l_tbEquipPos) do
		self.m_tbEquips[k] = nil;
	end
	
	self:SetIndex(nIndex)
	--test
	-- cclog("KGC_PLAYER_EQUIP_SLOT_TYPE init(第%d套) ... ", nIndex)
	-- self:TestPrintEquipSlot();
	--test end
end

--@function: 更换位置上的道具
--@nPos: 位置(6个)
--@new: 新道具对象
--@old: 旧道具对象
function KGC_PLAYER_EQUIP_SLOT_TYPE:SwapEquip(nPos, new, old)
	local tbEquips = self.m_tbEquips;
	local n = self:GetIndex();
	
	local old = tbEquips[nPos]
	-- cclog("[Log]SwapEquip: 新装备(%s)-旧装备(%s), 第几套装备(%s), 部位(%s)", tostring(new), tostring(old), tostring(n), tostring(nPos))
	if new then
		tbEquips[nPos] = new:GetIndex();
		-- print("[Log]装备上的位置和副类型比较：", nPos, new:GetTypeDetail(), nPos == new:GetTypeDetail(), n)
		new:SetSuit(n)
	end
	if old then
		old:SetSuit(0)
	end
	
	--test
	-- self:TestPrintEquipSlot();
	--test end
end

function KGC_PLAYER_EQUIP_SLOT_TYPE:GetEquips()
	local tbEquips = {}
	for nSlot, nIndex in pairs(self.m_tbEquips) do
		local equip = self.m_ship:GetBag():GetItemByIndex(nIndex)
		tbEquips[nSlot] = equip;
	end
	return tbEquips;
end

--@function: 获取一件装备
function KGC_PLAYER_EQUIP_SLOT_TYPE:GetAEquip(nSlot)
	local tbEquips = self:GetEquips();
	return tbEquips[nSlot];
end

--@function: 获取当前装备属于第几套
function KGC_PLAYER_EQUIP_SLOT_TYPE:SetIndex(nIndex)
	self.m_nIndex = nIndex or 0;
	
	-- 更新所有装备的套装
	local tbEquips = self:GetEquips();
	for _, equip in pairs(tbEquips) do
		equip:SetSuit(nIndex);
	end
end

function KGC_PLAYER_EQUIP_SLOT_TYPE:GetIndex()
	return self.m_nIndex;
end

function KGC_PLAYER_EQUIP_SLOT_TYPE:ClearData()
	local tbEquips = self:GetEquips()
	for nPos, equip in pairs(tbEquips) do
		if equip then
			equip:SetSuit(0)
		end
	end
end

--@function: 获取该套装备槽总共装备了多少件装备
function KGC_PLAYER_EQUIP_SLOT_TYPE:GetEquipsNum()
	local nNum = 0;
	for nSlot, nIndex in pairs(self.m_tbEquips) do
		nNum = nNum + 1;
	end
	return nNum;
end
---------------------------------------------------------------
--test
function KGC_PLAYER_EQUIP_SLOT_TYPE:TestPrintEquipSlot()
	local tbEquips = self:GetEquips()
	local nCount = 0;
	for k, v in pairs(tbEquips) do
		cclog("[Test]装备位置：%d, 装备为：%s", k, tostring(v));
		nCount = nCount + 1;
	end
	cclog("[Test]这是第%d套装备，已经装备了%d件装备", self:GetIndex(), nCount);
end