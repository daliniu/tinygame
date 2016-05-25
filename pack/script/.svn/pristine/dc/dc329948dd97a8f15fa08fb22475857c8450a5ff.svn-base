----------------------------------------------------------
-- file:	data.lua
-- Author:	page
-- Time:	2015/03/12 11:04
-- Desc:	战斗系统需要的数据
--			
----------------------------------------------------------
require "script/class/class_data_base"
----------------------------------------------------------

----------------------------------------
--1.受击者数据格式
local TB_DATA_DEFEND_SAVE_INFO = {
	[1] = 0,									--位置(key)
	nCamp = 0,									--阵营[阵营+位置-->唯一]
	npc = nil,									--npc对象
	skill = nil,								--技能对象
	bCrit = false,								--是否暴击
	data = nil,									--类型数据(攻击、治疗、多重施法)
	bHit = true,								-- 是否命中
	tbDamage = {
		nCurHP= 0,								--当前血量
		nTotHP = 0,								--总血量
		nDamage = 0,							--伤害量
	},	
	--反击
	bCA = false,								--是否反击
	tbCADamage = {
		nCurHP= 0,								--当前血量
		nTotHP = 0,								--总血量
		nDamage = 0,							--伤害量
	},
	
	tbSpecial = {
		nID = 0,								--状态ID
	},
}

KGC_DATA_DEFEND_SAVE_TYPE = class("KGC_DATA_DEFEND_SAVE_TYPE", CLASS_BASE_TYPE, TB_DATA_DEFEND_SAVE_INFO)

function KGC_DATA_DEFEND_SAVE_TYPE:ctor()

end

function KGC_DATA_DEFEND_SAVE_TYPE:Init(bHit, pos, nCamp, npc, skill, bCrit, bCA, data, tbDamage)
	self:SetHit(bHit);
	self:SetPos(pos)
	self:SetCamp(nCamp);
	self:SetNpc(npc)
	self:SetSkill(skill)
	self:SetCrit(bCrit)
	self:SetCA(bCA)
	self:SetData(data);
	-- self:SetDamage(unpack(tbDamage or {}))
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetHit(bHit)
	self.bHit = bHit or false;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetHit()
	return self.bHit;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetPos(nPos)
	self[1] = nPos or 0;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetPos()
	return self[1]
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetCamp(nCamp)
	self.nCamp = nCamp or 0;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetCamp()
	return self.nCamp
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetKey()
	return self:GetCamp(), self:GetPos();
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetNpc(npc)
	self.npc = npc;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetNpc()
	return self.npc;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetSkill(skill)
	self.skill = skill;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetSkill()
	return self.skill;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetCrit(bCrit)
	self.bCrit = bCrit or false;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetCrit()
	return self.bCrit;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetCA(bCA)
	self.bCA = bCA or false;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetCA()
	return self.bCA;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetData(data)
	self.data = data or nil;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetData()
	return self.data;
end

-- function KGC_DATA_DEFEND_SAVE_TYPE:SetDamage(nCurHP, nTotHP, nDamage)
	-- if not self.tbDamage then
		-- self.tbDamage = {}
	-- end
	-- -- print("SetDamage", nCurHP, nTotHP, nDamage)
	-- self.tbDamage.nCurHP = nCurHP or 0;
	-- self.tbDamage.nTotHP = nTotHP or 0;
	-- self.tbDamage.nDamage = nDamage or 0;
-- end

-- function KGC_DATA_DEFEND_SAVE_TYPE:GetDamage()
	-- if not self.tbDamage then
		-- self.tbDamage = {}
	-- end
	-- -- print("GetDamage", self.tbDamage.nCurHP, self.tbDamage.nTotHP, self.tbDamage.nDamage)
	-- return self.tbDamage.nCurHP, self.tbDamage.nTotHP, self.tbDamage.nDamage;
-- end

function KGC_DATA_DEFEND_SAVE_TYPE:SetSpecial(nID)
	if not self.tbSpecial then
		self.tbSpecial = {}
	end
	self.tbSpecial.nID = nID;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetSpecial()
	return self.tbSpecial;
end

function KGC_DATA_DEFEND_SAVE_TYPE:SetCADamage(nCurHP, nTotHP, nDamage)
	if not self.tbCADamage then
		self.tbCADamage = {}
	end
	self.tbCADamage.nCurHP = nCurHP or 0;
	self.tbCADamage.nTotHP = nTotHP or 0;
	self.tbCADamage.nDamage = nDamage or 0;
end

function KGC_DATA_DEFEND_SAVE_TYPE:GetCADamage()
	if not self.tbCADamage then
		self.tbCADamage = {}
	end
	
	return self.tbCADamage.nCurHP, self.tbCADamage.nTotHP, self.tbCADamage.nDamage;
end

----------------------------------------
--2. 攻击者数据格式
local TB_DATA_LAUNCHER_SAVE_INFO = {
	[1] = 0,									--位置(key)
	nCamp = 0,									--阵营
	npc = nil,									--npc对象
	skill = nil,								--技能对象
	bCrit = false,								--是否暴击
	bSrc = false,								--是否为技能来源
	nVam = 0,									--吸血量
	tbCost = {},								--当前费用(费用,释放技能之前的最大费用,改变之前的费用, 改变量, 释放技能之后的最大费用)

	--反击伤害
	tbDamage = {
		nCurHP= 0,								--当前血量
		nTotHP = 0,								--总血量
		nDamage = 0,							--伤害量
	},
}

KGC_DATA_LAUNCHER_SAVE_TYPE = class("KGC_DATA_LAUNCHER_SAVE_TYPE", CLASS_BASE_TYPE, TB_DATA_LAUNCHER_SAVE_INFO)

function KGC_DATA_LAUNCHER_SAVE_TYPE:ctor()
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:Init(pos, nCamp, npc, skill, bCrit, bCA, nVam, tbDamage)
	self:SetPos(pos)
	self:SetCamp(nCamp);
	self:SetNpc(npc)
	self:SetSkill(skill)
	self:SetCrit(bCrit)
	self:SetCA(bCA)
	self:SetVam(nVam)
	self:SetDamage(unpack(tbDamage or {}))
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetPos(nPos)
	self[1] = nPos or 0;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetPos()
	return self[1]
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetCamp(nCamp)
	self.nCamp = nCamp or 0;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetCamp()
	return self.nCamp
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetKey()
	return self:GetCamp(),self:GetPos();
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetNpc(npc)
	self.npc = npc;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetNpc()
	return self.npc;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetSkill(skill)
	self.skill = skill;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetSkill()
	return self.skill;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetCrit(bCrit)
	self.bCrit = bCrit or false;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetCrit()
	return self.bCrit;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetCA(bCA)
	self.bCA = bCA or false;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetCA()
	return self.bCA;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetSrc(bSrc)
	self.bSrc = bSrc or false;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetSrc()
	return self.bSrc;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetVam(nVam)
	self.nVam = nVam or 0;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetVam()
	return self.nVam;
end

--@function: 	用来在技能释放过程中显示技能
--@nCost:		当前费用
--@nMax:		最大费用
--@tbTempCost:	{nBefore:改变之前的费用, nChange:费用改变数量}
function KGC_DATA_LAUNCHER_SAVE_TYPE:SetCost(nCost, nMaxOld, nBefore, nChange, nMaxNew)
	self.tbCost = {nCost or 0, nMaxOld or 0, nBefore or 0, nChange or 0, nMaxNew or 0};
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetCost()
	return self.tbCost;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:SetDamage(nCurHP, nTotHP, nDamage)
	if not self.tbDamage then
		self.tbDamage = {}
	end
	self.tbDamage.nCurHP = nCurHP or 0;
	self.tbDamage.nTotHP = nTotHP or 0;
	self.tbDamage.nDamage = nDamage or 0;
end

function KGC_DATA_LAUNCHER_SAVE_TYPE:GetDamage()
	if not self.tbDamage then
		self.tbDamage = {}
	end
	
	return self.tbDamage.nCurHP, self.tbDamage.nTotHP, self.tbDamage.nDamage;
end
