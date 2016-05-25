----------------------------------------------------------
-- file:	state_base.lua
-- Author:	page
-- Time:	2015/03/19 16:58
-- Desc:	状态 基类
----------------------------------------------------------
require "script/class/class_dp_base"
local l_tbStateResults = require("script/cfg/statusresults")
local l_tbStatesShowout = require "script/cfg/client/stateshowout"
-- local l_tbStatesResultConfig = require("script/cfg/statusresults")

local l_tbCondID, l_tbCondName = def_GetConditionData();
local l_tbStateShowType = def_GetStateShowType();
local l_tbStateCheckType = def_GetStateCheckType();
local l_tbCamp = def_GetFightCampData();


--data struct
local TB_STATE_BASE_STRUCT = {
	m_nID	= 0,				--状态ID
	m_szName = "",				--状态的名称
	m_szIcon = "",				--状态图标
	m_szDesc = "",				--状态的描述
	m_nPosNeg = 0,				--状态正负面
	m_nMaxFloor	= 0,			--叠加参数()
	m_nFloor = 0,				--已经叠加次数
	m_nRepType = 0,				--替换参数
	m_nDisType = 0,				--消失条件
	m_nMaxRound = 0,			--持续回合数
	m_nRound = 0,				--已经持续回合数
	m_nMaxTimes = 0,			--生效次数
	m_nTimes = 0,				--已经生效次数
	m_tbSkillID = {},			--子技能ID
	m_tbCondID = {},			--触发状态的条件ID
	m_bCanDispel = false,		--是否可驱散
	m_nRetID = 0,				--状态效果ID
	m_tbShowData = {				--状态效果配置数据
		nID = 0,					--状态效果ID
		nType = 0,					--状态效果类型
		tbArgs = {},				--参数
	},
	m_tbTriggerData = {			--触发数据
		tbInfo = {},				--{子技能ID, 子状态ID}	
		nCondID = 0,				--触发条件ID
	},
	
	m_tbID = nil,
	m_tbName = nil,
	--config: 配置死的根据ID查
	-- m_tbResult = l_tbStateResults,
	--------------------------------------
	m_nQueue = nil,				--属于哪个队列
	m_Trigger = nil,			--保存释放的技能源
	m_Npc = nil,				--状态所在的NPC，区分释放状态的NPC对象
	m_BoneEffect = nil,			--绑定特效的骨骼
	--------------------------------------
	--ui
	m_tbUIEffectData = {		--状态的特效
		nEffID = 0,					--特效ID
		szPos = "",					--绑定的骨骼位置
		nZOrder = 0,				--显示成绩
		nScale = 1,					--显示缩放大小
		nSpeed = 0,					--特效播放速度
		tbPro = nil,				--位置百分比{0.5, 0.5}
	},
}

KGC_STATE_BASE_TYPE = class("KGC_STATE_BASE_TYPE", KGC_OBS_OBJECT_BASE_TYPE, TB_STATE_BASE_STRUCT)
local l_tbSpeStateID, l_tbSpeStateName = def_GetSpecialStateData();

function KGC_STATE_BASE_TYPE:ctor()
	self.m_tbID = l_tbSpeStateID;
	self.m_tbName = l_tbSpeStateName;
	
	--所有状态都是会在回合结束的时候结算的
	self.m_tbCondID = {l_tbCondID.HIT, l_tbCondID.ROUND_END, l_tbCondID.ROUND_START};
end

function KGC_STATE_BASE_TYPE:Init(nID, tbConfig, skill)
	print("state init: ", nID, tbConfig, skill);
	self.m_nID = nID;
	self.m_Trigger = skill;
	-- self.m_Npc = skill:GetNpc();
	
	--读取配置表
	if type(tbConfig) == "table" then
		self:SetName(tbConfig.name)
		self:SetDesc(tbConfig.desc)
		self:SetIcon(tbConfig.icon)
		self:SetShowData(tbConfig.staturesultsid)
		self:SetPosNeg(tbConfig.statustype)
		self:SetMaxFloor(tbConfig.overlapping)
		self:SetRepType(tbConfig.replace)
		self:SetMaxRound(tbConfig.duration)
		self:SetMaxTimes(tbConfig.effectivetimes)
		
		self:SetTriggerInfo(tbConfig.triggerresultid, tbConfig.triggercondition)
		
	end
	
	--初始化表现配置表
	self:UIInitEffectShow(self:GetID());
	
	self:OnInit()
end

function KGC_STATE_BASE_TYPE:OnInit()
end

function KGC_STATE_BASE_TYPE:GetErrorDesc(szFormat, ... )
	local szErr = string.format("[状态:%s]", self:GetName())
	string.format(szErr .. szFormat, ...)
end

function KGC_STATE_BASE_TYPE:CondUpdate(obj, id)
	-- print("条件触发：", obj, id, l_tbCondName[id])
	for k, v in ipairs(self.m_tbCondID) do
		if id == v then
			return self:OnCondUpdate(obj, id)
		end
	end
	print("CondUpdate end.")
end

function KGC_STATE_BASE_TYPE:OnCondUpdate(obj, id)
	cclog("(当前状态:%s)回合结束，条件ID为：%s, %s", self:GetName(), tostring(id), tostring(l_tbCondID.ROUND_END))
	if id == l_tbCondID.ROUND_END then
		local bRet, data =  self:AddRound()
		-- return {bRet, data}
		return data
	elseif id == l_tbCondID.ROUND_START then
		print("回合开始，处理状态！")
	end
		
	local nCondID = self:GetTriggerCondID();
	local nSkillID = self:GetTriggerSkillID()
	local nStateID = self:GetTriggerStateID();
	cclog("状态(%s),触发条件ID(%d) -- 当前条件ID(%d)， 触发状态(%d)", self:GetName(), tostring(nCondID), tostring(id), nStateID)
	if nCondID > 0 and nStateID > 0 then
		if id == nCondID then
			--释放触发条件需要判断阵营
			local tbArgs = self:GetShowArgs();
			local nCamp = tbArgs[8] or l_tbCamp.MINE;	--默认是己方
			local nSkillCamp = obj:GetCaster():GetFightShip():GetCamp();
			local nSelfCamp = self:GetNpc():GetFightShip():GetCamp();
			
			if (nCamp == l_tbCamp.MINE and (nSkillCamp == nSelfCamp)) or
				(nCamp == l_tbCamp.ENEMY and (nSkillCamp ~= nSelfCamp)) then
				local queue = self:GetQueue()
				local npc = queue:GetNpc();
				local state = g_StateManager:CreateState(nStateID, npc, self)
				if state then
					local bRet, data = state:Cast(npc)
					if data then
						data:SetTriggerConID(id)
					end
					return data;
				end
			end
		end
	end
	print("OnCondUpdate end.")
end

function KGC_STATE_BASE_TYPE:GetSame(queue)
	if queue then
		local tbRet = queue:GetByID(self:GetID()) or {}
		if #tbRet > 0 then
			return true, tbRet;
		else
			cclog("[Warning]队列中什么有没有@KGC_STATE_BASE_TYPE:GetSame")
		end
	else
		cclog("[Warning]队列为空@KGC_STATE_BASE_TYPE:GetSame")
	end
	
	return false, {};
end

function KGC_STATE_BASE_TYPE:SetQueue(queue)
	self.m_nQueue = queue;
end

function KGC_STATE_BASE_TYPE:GetQueue()
	return self.m_nQueue;
end

--@function: 是否可叠加
function KGC_STATE_BASE_TYPE:IsCanAdd()
	return self:GetMaxFloor() > 1;
end

--@function: 状态的叠加检测
function KGC_STATE_BASE_TYPE:CheckAndAdd(queue, tbState)
	local nMax = self:GetMaxFloor() or 0;
	local nFloor = self:GetFloor() or 0;
	local szErr = ""
	if nMax > nFloor then
		if #tbState > 1 then
			cclog("[Error]可叠加的状态不只一个！！(%d)", #tbState)
			szErr = self:GetErrorDesc("[Error]可叠加的状态不只一个！！(%d)", #tbState)
		end
		self:AddFloor()
		
		--具体叠加什么，和具体状态性质有关
		self:OnAdd(tbState)
		
		--叠加完，替换旧的
		if queue then
			local bRet, data, szErr = queue:Replace(self)
			if bRet then
				print("状态叠加成功")
				return true, data;
			else
				print("状态叠加失败")
				szErr = self:GetErrorDesc("队列替换失败, 没有找到可替换的状态")
			end
		else
			szErr = self:GetErrorDesc("队列不存在")
		end
	else
		szErr = self:GetErrorDesc("超过了最大可叠加层数")
	end
	--test
	cclog(szErr or "nil")
	return false, data, szErr;
end

function KGC_STATE_BASE_TYPE:OnAdd()
end

--@function: 状态的替换检测
function KGC_STATE_BASE_TYPE:CheckAndReplace(queue, tbState)
	local data
	if queue then
		local bRet, data, szErr = queue:Replace(self)
		if bRet then
			cclog("状态(%s)替换成功", self:GetName())
			return true, data, szErr;
		end
	end
	cclog("状态%s替换失败!", self:GetName())
	return false;
end

--@function: 状态的共存检测
function KGC_STATE_BASE_TYPE:CheckAndCoexist(queue, tbState)
	local bRet, data
	if queue then
		bRet, data = queue:Push(self)
		cclog("状态(%s)共存完毕！", self:GetName())
	end
	return bRet, data;
end

function KGC_STATE_BASE_TYPE:CheckAndRepCoe(queue, tbState)
	local nRepType = self:GetRepType();
	local bRet = false;
	local data = nil;
	if nRepType == 0 then
		print("不可替换!")
		bRet = false;
	elseif nRepType == 1 then
		bRet, data = self:CheckAndReplace(queue, tbState)
	elseif nRepType == 2 then
		bRet, data = self:CheckAndCoexist(queue, tbState)
	end
	
	return bRet, data;
end

--@function: 状态的释放
function KGC_STATE_BASE_TYPE:Cast(npc)
	local queue = npc:GetStateQueue();
	self:SetNpc(npc)
	--logic 
	local bSame, tbState = self:GetSame(queue)
	cclog("开始释放状态(%s)给Npc(位置:%d)", self:GetName(), npc:GetPos())
	local bRet, data
	if bSame then
		if type(tbState) == "table" then
			if self:IsCanAdd() then
				print("叠加")
				-- tst_PrintTime(16002)
				bRet, data = self:CheckAndAdd(queue, tbState)
				-- tst_PrintTime(16003)
			else
				print("替换和共存")
				-- tst_PrintTime(16004)
				bRet, data = self:CheckAndRepCoe(queue, tbState)
				-- tst_PrintTime(16005)
			end
		end
	else				--队列
		print("队列")
		-- local queue = npc:GetStateQueue();
		bRet, data = queue:Push(self)
	end
	--result
	-- print("state cast", bRet, data)
	local testQueu = npc:GetStateQueue();
	print("npc状态队列大小为：", testQueu:GetSize())
	if bRet then
		cclog("[State]添加观察主题, 状态(%s)", self:GetName())
		self:AttachSubject(g_CondTrigger, npc:GetHeroObj(), npc:GetFightShip():GetCamp())
	end
	cclog("[%s]logic触发, 生效结果:%s", self:GetName(), tostring(bRet))
	
	return bRet, data
end

--@function: 消失
function KGC_STATE_BASE_TYPE:Disappear()
	cclog("(%s)我该消失了...", self:GetName())
	local queue = self:GetQueue()
	assert(queue)
	
	--取消观察
	print("取消观察者身份!")
	self:DetachSubject(g_CondTrigger)
	
	return queue:Remove(queue:Find(self:GetID()))
end

--@function: 叠加
--@return: false-叠加失败(不可叠加); true-叠加成功
function KGC_STATE_BASE_TYPE:AddFloor()
	local nRet = self.m_nFloor + 1;
	if nRet > self.m_nMaxFloor then
		return false;
	end
	
	self.m_nFloor = nRet;
	return true;
end

--@function: 持续回合数减少
function KGC_STATE_BASE_TYPE:AddRound()
	--0 is forver
	if self:GetMaxRound() == 0 then
		return;
	end
	local nRound = self.m_nRound + 1;
	local bRet, data = false, nil;
	if nRound > self:GetMaxRound() then
		bRet, data = self:Disappear();
	end
	
	self.m_nRound = nRound;
	cclog("(状态:%s)持续回合数为：%s", self:GetName(), tostring(nRound))
	return bRet, data;
end

--@function: 生效
function KGC_STATE_BASE_TYPE:Work()
	cclog("状态(%s)生效了", self:GetName())
	--0 is forver
	if self:GetMaxTimes() == 0 then
		return;
	end
	
	local nTimes = self:AddTimes();
	local bRet, data = false, nil;
	if nTimes > self:GetMaxTimes() then
		bRet, data = self:Disappear();
	end

	print("持续次数为：", nTimes, bRet, data)
	return bRet, data;
end

function KGC_STATE_BASE_TYPE:GetID()
	return self.m_nID;
end


function KGC_STATE_BASE_TYPE:GetRepType()
	return self.m_nRepType;
end

function KGC_STATE_BASE_TYPE:SetRepType(nType)
	self.m_nRepType = nType or 0;
end

function KGC_STATE_BASE_TYPE:GetMaxFloor()
	return self.m_nMaxFloor;
end

function KGC_STATE_BASE_TYPE:SetMaxFloor(nFloor)
	self.m_nMaxFloor = nFloor or 0;
end

function KGC_STATE_BASE_TYPE:GetMaxRound()
	return self.m_nMaxRound;
end

function KGC_STATE_BASE_TYPE:SetMaxRound(nRound)
	self.m_nMaxRound = nRound or 0;
end

function KGC_STATE_BASE_TYPE:GetMaxTimes()
	return self.m_nMaxTimes;
end

function KGC_STATE_BASE_TYPE:SetMaxTimes(nTimes)
	self.m_nMaxTimes = nTimes or 0;
end

function KGC_STATE_BASE_TYPE:AddTimes()
	if not self.m_nTimes then
		self.m_nTimes = 0;
	end
	self.m_nTimes = self.m_nTimes + 1;
	return self.m_nTimes;
end

function KGC_STATE_BASE_TYPE:SetTimes(nTimes)
	self.m_nTimes = nTimes or 0;
end

function KGC_STATE_BASE_TYPE:GetFloor()
	return self.m_nFloor;
end

function KGC_STATE_BASE_TYPE:IsTaunt()
	return false;
end

function KGC_STATE_BASE_TYPE:GetName()
	return self.m_szName;
end

function KGC_STATE_BASE_TYPE:SetName(szName)
	self.m_szName = szName or "";
end

function KGC_STATE_BASE_TYPE:SetDesc(szDesc)
	self.m_szDesc = szDesc or "";
end

function KGC_STATE_BASE_TYPE:GetDesc()
	return self.m_szDesc;
end

function KGC_STATE_BASE_TYPE:SetIcon(szIcon)
	self.m_szIcon = szIcon or "";
end

function KGC_STATE_BASE_TYPE:GetIcon()
	return self.m_szIcon;
end

function KGC_STATE_BASE_TYPE:SetPosNeg(nType)
	self.m_nPosNeg = nType or 0;
end

function KGC_STATE_BASE_TYPE:GetPosNeg()
	return self.m_nPosNeg;
end

function KGC_STATE_BASE_TYPE:GetTrigger()
	return self.m_Trigger;
end

function KGC_STATE_BASE_TYPE:GetNpc()
	return self.m_Npc;
end

function KGC_STATE_BASE_TYPE:SetNpc(npc)
	self.m_Npc = npc;
end

function KGC_STATE_BASE_TYPE:SetShowData(nID)
	-- print(111, nID)
	if not nID or nID <= 0 then
		return false;
	end
	local tbData = self:GetShowData();
	-- local tbConfig = require("script/cfg/statusresults")
	local tbInfo = l_tbStateResults[nID]
	
	if tbInfo then
		-- print("SetShowData", nID, tbInfo, tbInfo.id, tbInfo.effecttype)
		-- cclog("[状态属性]初始化%s, 效果类型", self:GetName(), tbInfo.effecttype)
		tbData.nID = nID or 0;
		tbData.nType = tbInfo.effecttype;
		if not tbData.tbArgs then
			tbData.tbArgs = {};
		end
		tbData.tbArgs[1] = tbInfo.arg1;
		tbData.tbArgs[2] = tbInfo.arg2;
		tbData.tbArgs[3] = tbInfo.arg3;
		tbData.tbArgs[4] = tbInfo.arg4;
		tbData.tbArgs[5] = tbInfo.arg5;
		tbData.tbArgs[6] = tbInfo.arg6;
		tbData.tbArgs[7] = tbInfo.arg7;
	end
end

function KGC_STATE_BASE_TYPE:GetShowData()
	if not self.m_tbShowData then
		self.m_tbShowData = {};
	end
	return self.m_tbShowData;
end

function KGC_STATE_BASE_TYPE:GetShowID()
	local tbData = self:GetShowData();
	return tbData.nID;
end

function KGC_STATE_BASE_TYPE:GetShowType()
	local tbData = self:GetShowData();
	-- print("GetShowType", self:GetID())
	return tbData.nType;
end

function KGC_STATE_BASE_TYPE:GetShowArgs()
	local tbData = self:GetShowData();
	return tbData.tbArgs;
end

function KGC_STATE_BASE_TYPE:SetTriggerInfo(tbTriggerInfo, nCondID)
	local tbData = self:GetTriggerInfo();
	tbData.tbInfo = tbTriggerInfo or {};
	tbData.nCondID = nCondID or 0;
	
	if nCondID and nCondID > 0 then
		table.insert(self.m_tbCondID, nCondID);
	end
end

function KGC_STATE_BASE_TYPE:GetTriggerInfo()
	if not self.m_tbTriggerData then
		self.m_tbTriggerData = {}
	end
	return self.m_tbTriggerData;
end

function KGC_STATE_BASE_TYPE:GetTriggerSkillID()
	local tbData = self:GetTriggerInfo();
	local tbInfo = tbData.tbInfo or {}
	return tbInfo[1] or 0;
end

function KGC_STATE_BASE_TYPE:GetTriggerStateID()
	local tbData = self:GetTriggerInfo();
	local tbInfo = tbData.tbInfo or {}
	return tbInfo[2] or 0;
end

function KGC_STATE_BASE_TYPE:GetTriggerCondID()
	local tbData = self:GetTriggerInfo();
	return tbData.nCondID or 0;
end

--@function: 状态是否存在某种效果
--@说明: 有ShowType和CheckType的区别-->CalcValue
--			ShowType:程序定义
--			CheckType:用户需求
function KGC_STATE_BASE_TYPE:IsPropertyExist(nType)
	if nType == l_tbStateCheckType.FLY then
		return self:GetShowType() == l_tbStateShowType.FLY;
	elseif nType == l_tbStateCheckType.TAUNT then
		return self:GetShowType() == l_tbStateShowType.TAUNT;
	elseif nType == l_tbStateCheckType.DEXTERITY then
		return self:GetShowType() == l_tbStateShowType.DEXTERITY;
	elseif nType == l_tbStateCheckType.IMMUNE then
		return self:GetShowType() == l_tbStateShowType.IMMUNE;
	elseif nType == l_tbStateCheckType.EXILE then
		return self:GetShowType() == l_tbStateShowType.EXILE;
	elseif nType == l_tbStateCheckType.STUN then
		return self:GetShowType() == l_tbStateShowType.STUN;
	elseif nType == l_tbStateCheckType.FLAG then
		return self:GetShowType() == l_tbStateShowType.FLAG;
	end
	
	return false;
end

--@function: 状态某种效果的数值结算
function KGC_STATE_BASE_TYPE:CalcValue(nType)	
	if nType == l_tbStateCheckType.SHIELD then
		return self:GetSubDamage();
	elseif nType == l_tbStateCheckType.ATTACK then
		return self:GetAttackAmend();
	end
end

function KGC_STATE_BASE_TYPE:GetSubDamage()
	local nSubDamage = 0;
	local tbArgs = self:GetShowArgs();
	local nArg1 = tbArgs[1] or 0;
	local nArg2 = tbArgs[2] or 0;
	local nArg3 = tbArgs[3] or 1;
	local nArg4 = tbArgs[4] or 1;
	if nArg3 ==0 then
		nArg3 = 1;
	end
	if nArg4 == 0 then
		nArg4 = 1;
	end
	print("护盾减伤计算：", self:GetName(), self:GetID(), self:GetShowType(), l_tbStateShowType.SHIELD)
	if self:GetShowType() == l_tbStateShowType.SHIELD then
		--技能等级默认为1
		local nLevel = 1;
		local skill = self:GetTrigger();
		if skill and skill.IsSkill then
			nLevel = skill:GetLevel() or 1;
		end
		local nTest1 = 0;	--待定属性1
		-- local nTest3 = 1;	--待定属性3
		nSubDamage = (nArg1 * nLevel + nArg2 + nTest1/nArg3) / nArg4;
		-- print(111, nSubDamage, nArg1, nArg2, nArg3, nArg4, nLevel, nTest1, nTest3)
	end
	
	return nSubDamage;
end

--@function: 获取属性
function KGC_STATE_BASE_TYPE:GetProperty(nType)
	local nProperty = 0;
	print(self:GetName(), "GetProperty", self:GetShowType(), l_tbStateShowType.ADDPROPERTY, self:GetID())
	if not (self:GetShowType() == l_tbStateShowType.ADDPROPERTY or self:GetShowType() == l_tbStateShowType.SUBPROPERTY) then
		return nProperty;
	end

	local tbArgs = self:GetShowArgs()
	-- 注意：增加属性的配置表前两个是table
	local tbArg1 = tbArgs[1] or 0;
	local tbArg2 = tbArgs[2] or 0;
	local nArg3 = tbArgs[3] or 1;
	if nArg3 ==0 then
		nArg3 = 1;
	end
	
	local nTest1 = 0;
	local fnCalc = function(nArg2)
		local nLevel = 1;
		local skill = self:GetTrigger();
		if skill and skill.IsSkill then
			nLevel = skill:GetLevel() or 1;
		end
			
		local nValue = nArg2 * nLevel + nTest1/nArg3;
		if self:GetShowType() == l_tbStateShowType.SUBPROPERTY then
			nValue = -1 * nValue
		end
		return nValue;
	end
	for k, v in pairs(tbArg1 or {}) do
		local nPropertyType = v;
		local nArg2 = tbArg2[k] or 0;
		if nPropertyType == nType then
			nProperty = nProperty + fnCalc(nArg2);
		end
	end
	print("GetProperty, 属性增减：", nProperty)
	return nProperty;
end

--@function: 获取伤害改变(+/-)
function KGC_STATE_BASE_TYPE:GetAttackAmend()
	--8001和l_tbStateCheckType.ATTACK 以及配置表三者统一
	local nAmend = self:GetProperty(8001)
	print("攻击力受状态影响数值为：", nAmend)
	return nAmend;
end

function KGC_STATE_BASE_TYPE:IsState()
	return true;
end
-----ui-----
function KGC_STATE_BASE_TYPE:CondUpdateUI(data, widget, id)
	cclog("状态(%s-%s-%d)的界面更新@KGC_STATE_BASE_TYPE:CondUpdateUI", self:GetName(), tostring(id), data:GetTriggerConID())
	local elem = data:GetElem();
	for k, v in ipairs(self.m_tbCondID) do
		if v == id and id == data:GetTriggerConID() then
			self:OnCondUpdateUI(data, widget, id)
		end
	end
end

function KGC_STATE_BASE_TYPE:OnCondUpdateUI(data, widget, id)
	--队列特效
	local queue = self:GetQueue()
	if queue then
		queue:UIUpdate(self, data)
	end
end

function KGC_STATE_BASE_TYPE:UIInitEffectShow(nID)
	local tbInfo = l_tbStatesShowout[nID]
	if tbInfo then
		self:UISetEffectData(tbInfo.effectid, tbInfo.position, tbInfo.zorder, tbInfo.scale, tbInfo.speed, tbInfo.position2);
	end
end

function KGC_STATE_BASE_TYPE:UISetEffectData(nEffID, szPos, nZOrder, nScale, nSpeed, tbPro)
	local tbData = self:UIGetEffectData();
	tbData.nEffID = nEffID or 0;
	tbData.szPos = szPos or "";
	tbData.nZOrder = nZOrder or 0;
	tbData.nScale = nScale or 1;
	tbData.nSpeed = nSpeed or 0;
	tbData.tbPro = tbPro;
end

function KGC_STATE_BASE_TYPE:UIGetEffectData()
	if not self.m_tbUIEffectData then
		self.m_tbUIEffectData = {}
	end
	
	return self.m_tbUIEffectData;
end

function KGC_STATE_BASE_TYPE:UIGetEffectID()
	local tbData = self:UIGetEffectData();
	return tbData.nEffID;
end

function KGC_STATE_BASE_TYPE:UIGetEffectPosition()
	local tbData = self:UIGetEffectData();
	return tbData.szPos;
end

function KGC_STATE_BASE_TYPE:UIGetEffectZOrder()
	local tbData = self:UIGetEffectData();
	return tbData.nZOrder;
end

function KGC_STATE_BASE_TYPE:UIGetEffectScale()
	local tbData = self:UIGetEffectData();
	return tbData.nScale;
end

function KGC_STATE_BASE_TYPE:UIGetEffectSpeed()
	local tbData = self:UIGetEffectData();
	return tbData.nSpeed;
end

function KGC_STATE_BASE_TYPE:UIGetEffectPosPro()
	local tbData = self:UIGetEffectData();
	return tbData.tbPro;
end

function KGC_STATE_BASE_TYPE:UIAddEffect(fightview)
	if not fightview then
		return false;
	end
	local npc = self:GetNpc()
	local nCamp = npc:GetFightShip():GetCamp();
	local nPos = npc:GetPos()
	local nZOrder = self:UIGetEffectZOrder();
	local nScale = self:UIGetEffectScale();
	local tbPro = self:UIGetEffectPosPro();
	
	local arm = fightview:GetArmature(nCamp, nPos)
	print("[状态特效]添加状态特效 ... ", self:GetName(), arm)
	if arm then
		local bone = nil
		if arm.getBone then
			arm:getBone(self:UIGetEffectPosition())
		end
		print("[状态特效]bone", bone, tostring(self.m_BoneEffect))
		bone = nil;
		if not self.m_BoneEffect then
			if bone then
				local effect = af_GetEffectByID(self:UIGetEffectID())
				self.m_BoneEffect  = ccs.Bone:create("state_effect")
				self.m_BoneEffect:addDisplay(effect, 0)
				--设置是否跟随骨骼一起移动
				self.m_BoneEffect:setIgnoreMovementBoneData(true)
				--显示骨骼上绑定的内容(这里是粒子特效，换装也是同样的接口)
				self.m_BoneEffect:changeDisplayWithIndex(0, true)
				--设置层级关系
				self.m_BoneEffect:setLocalZOrder(1)
				-- Layer22为骨骼动画中想绑定的骨骼，设置为该骨骼为粒子特效所在骨骼的父骨骼
				arm:addBone(self.m_BoneEffect, self:UIGetEffectPosition())
			else
				-- local node = fightview:GetStillNode(nCamp, nPos);
				local node = fightview:GetNode(nCamp, nPos);
				local nLayerID = fightview:GetLayerID();		-- for 特效
				local effect = af_BindEffect2Node(node, self:UIGetEffectID(), {tbPro, nZOrder}, nScale, nil, {nil, -1, nLayerID})
				self.m_BoneEffect = effect
			end
		end
		print("[状态特效]self.m_BoneEffect", tostring(self.m_BoneEffect))
	end
end

function KGC_STATE_BASE_TYPE:UIRemoveEffect()
	cclog("[状态特效](%s)移除特效, %s", self:GetName(), tostring(self.m_BoneEffect))
	if self.m_BoneEffect then
		self.m_BoneEffect:removeFromParent(true)
		cclog("[状态特效]移除特效m_BoneEffect(%s) ", self:GetName())
		self.m_BoneEffect = nil;
	end
end
-------------------------------------------------------------
--test
function KGC_STATE_BASE_TYPE:TestPrint()
	print "state base ... "
end