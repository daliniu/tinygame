----------------------------------------------------------
-- file:	contract.lua
-- Author:	page
-- Time:	2015/02/09 16:35
-- Desc:	契约技能
--			
----------------------------------------------------------
require "script/core/skill/common/base"
----------------------------------------------------------
--data struct
local TB_DATA_SKILL_CONTRACT = {
	--config
	------------------------------------
	m_szName = "召唤技",
	------------------------------------
	m_nRet = 0,					--契约生物召唤结果：召唤结果类型
	m_tbRet = nil,				--契约生物召唤结果：召唤结果具体数据(用于播放效果)
}

KGC_SKILL_CONTRACT_TYPE = class("KGC_SKILL_CONTRACT_TYPE", KGC_SKILL_BASE_TYPE, TB_DATA_SKILL_CONTRACT)

local l_tbHitType = def_GetHitTypeData();
local l_tbSkillCastRet = def_GetSkillCastRetData();
local l_tbTargetSelectMethod,l_tbTSMName = def_GetTargetSelectMethondDATA();
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_CONTRACT_TYPE:ctor()
end
--
function KGC_SKILL_CONTRACT_TYPE:OnInit(tbInfo)
	self:SetHitType(l_tbHitType.HIT_DIFF)
	
	-- test 
	-- if self:GetID() == 30004 then
		-- self:SetPro(100)
	-- elseif self:GetID() == 30002 or self:GetID() == 30008 then
		-- self:SetPro(0)
	-- end
	-- test end
end

--筛选目标
function KGC_SKILL_CONTRACT_TYPE:GetTargetPos(nPos, tbTargets)
	if not gf_IsValidPos(nPos) then
		cclog("[Warning]无效的位置(%s) @KGC_SKILL_CONTRACT_TYPE:GetTarget", tostring(nPos))
		return nil;
	end
	
	--最大3列
	local MAX_COL = 3;
	local tbRetPos = {};
	
	local nSelectType = self:GetSelectType()
	cclog("Test: GetTargetPos-筛选目标方式：%s", l_tbTSMName[nSelectType])
	if nSelectType == l_tbTargetSelectMethod.M_DEFAULT then
		local nTarPos = (nPos - 1)% MAX_COL + 1;
		table.insert(tbRetPos, nTarPos);
	elseif nSelectType == l_tbTargetSelectMethod.M_POS then
		tbRetPos = self:GetSelectPos() or {}
	end
	
	return tbRetPos;
end

function KGC_SKILL_CONTRACT_TYPE:SpecialSkill(launcher, defend)
	local tbFightShip = launcher:GetFightShip();
	local tbArg = self:GetEffectArgs();
	local nModID = tbArg[1];
	local tbPos = self:GetTargetPos(launcher:GetPos());
-- print("SpecialSkill:1 ", collectgarbage("count"))
	--m_tbRet 用作UI表现, 是直接召唤出来还是进入/移除队列等
	self.m_nRet, self.m_tbRet = tbFightShip:CreateContract(nModID, tbPos);
-- print("SpecialSkill:2", collectgarbage("count"))
	print("创建契约生物返回的结果为：", self.m_nRet)
	local tbRet = {}
	for _, tbData in ipairs(self.m_tbRet) do
		local n, data = unpack(tbData)
		print("data", data, data and data.GetElem)
		table.insert(tbRet, data);
	end
	
	local npc = tbFightShip:GetHeroByPos(tbPos[1]);
	return self.m_nRet, npc;--, tbRet;
end

function KGC_SKILL_CONTRACT_TYPE:GetAction(tbArg)
	local action = nil
	--if szName == "move" then
		local spaMove = cc.Spawn:create(cc.DelayTime:create(0.5), cc.DelayTime:create(2))
		action = spaMove;
	--end
	
	return action;
end

--ui
if not _SERVER then

function KGC_SKILL_CONTRACT_TYPE:UIRunAttack(tbRetLau, uiLayer, fnAfterAttack, fnMoveBack, nCastRet)
	print("[延时]开始攻击释放动作 ............................ ", self:GetName(),  os.time())
	local fightHero = self:GetHeros()[1];
	local launcher = nil
	for k, v in ipairs(tbRetLau) do
		if v:GetSrc() then
			launcher = v;
			break;
		end
	end
	if not launcher then
		cclog("[Warning]攻击者来源没有找到！@KGC_SKILL_CONTRACT_TYPE.RunAttack")
		return;
	end
	--更新费用
	local nCamp, nPos = launcher:GetKey();
	local tbCost = {}
	tbCost[nCamp] = launcher:GetCost();
	uiLayer:UpdateCost(tbCost)
	
	print("释放技能英雄位置：", launcher:GetPos(), self:GetCaster():GetPos())

	local fnUpdateContract = function()
		if launcher then
			cclog("攻击结果数据个数：nRet(%s), #self.m_tbRet = %d", tostring(nRet), #(self.m_tbRet or {}))
			for _, tbData in ipairs(self.m_tbRet) do
				local nRet, data = unpack(tbData)
				print(nRet, data)
				if nRet == l_tbSkillCastRet.SUCCESS then
					local nPos = data:GetElem():GetPos();
					local contract = data:GetElem()
					print(string.format("在位置%d刷契约生物", contract:GetPos()))

					if uiLayer and contract then
						uiLayer:UpdateHero(contract)
					end
				elseif nRet == l_tbSkillCastRet.RETRY then
					print("RETRY ... ")
					local queue = data:GetObj()
					queue:PlayEffect(data, uiLayer);
				else
					print("[Error]召唤契约生物失败!")
				end
			end
		else
			print("攻击者 is nil@contract")
		end
	end
	
	local fnCallBack = function()
		print("[延时]攻击动作完成 ............................ ", self:GetName(), os.time())
		fnUpdateContract();
		
		--删掉多重施法脚底特效
		-- print("KGC_SKILL_CONTRACT_TYPE fnCallBack================", nCastRet, l_tbSkillCastRet.MAGIC)
		if nCastRet == l_tbSkillCastRet.MAGIC then		--多重施法特效
			self:UIRemoveEffect(20002);
		end
		
		fnAfterAttack();
		-- if fnMoveBack then
			-- fnMoveBack()
		-- end
	end
	
	if uiLayer then
		local nCamp, nPos = launcher:GetKey()
		local arm = uiLayer:GetArmature(nCamp, nPos)
		local szAnimation1 = self:UIGetAnimation("attack");
		local szAnimation = "summon"

		local function fnAnimationEvent(armatureBack,movementType,movementID)
			if not (movementID == szAnimation) then
				return;
			end
			
			if movementType == ccs.MovementEventType.complete then
				-- arm:setColor(255, 255, 255)
				fnCallBack();
				armatureBack:getAnimation():setMovementEventCallFunc(function() end)
			end
		end
		
		local function fnSpineAnimationEvent(event)
			-- print(tostring(arm), string.format("[spine] %d complete: %d", 
                              -- event.trackIndex, 
                              -- event.loopCount), os.clock())
			if event.animation == szAnimation then
				print("contract-动作做完, next ... ")
				arm:addAnimation(0, 'standby', true)
				-- 没有受击动作
				-- fnCallBack();
				
				if fnMoveBack then
					fnMoveBack()
				end
				-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
			end
		end
		
		local fnOnFrameEvent = function( bone,evt,originFrameIndex,currentFrameIndex)
			-- print("fnOnFrameEvent@contract", bone,evt,originFrameIndex,currentFrameIndex)
			if evt == "defend" then
				-- print(111, tostring(bone),evt,originFrameIndex,currentFrameIndex, bone:getName())
				fnCallBack();
				
				-- arm:getAnimation():setFrameEventCallFunc(function() end)
			end
		end
		
		local fnSpineFrameEvent = function(event)
			-- print("fnSpineFrameEvent", event, event.eventData.name, event.eventData.intValue, event.eventData.floatValue, event.eventData.stringValue)
			if event.eventData.name == "defend" then
				fnCallBack();
				-- arm:unregisterSpineEventHandler(sp.EventType.ANIMATION_EVENT)
			end
		end
		
		if arm then
			if arm.getAnimation then
				print("setFrameEventCallFunc @contract ", szAnimation)
				arm:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
				arm:getAnimation():setFrameEventCallFunc(fnOnFrameEvent)
				arm:getAnimation():play(szAnimation)
			else
				print("[registerSpineEventHandler] contract 1", szAnimation, os.clock())
				arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
				arm:registerSpineEventHandler(fnSpineAnimationEvent, sp.EventType.ANIMATION_COMPLETE)
				print("[registerSpineEventHandler] contract 2", szAnimation)
				arm:registerSpineEventHandler(fnSpineFrameEvent, sp.EventType.ANIMATION_EVENT)
				
				-- arm:addAnimation(0, szAnimation, true)
				arm:setAnimation(0, szAnimation, false)
			end
		end

		if arm then
			local node = uiLayer:GetNode(nCamp, nPos)
			-- self:AddEffectByID(node, 1)
			-- af_BindEffect2Node(node, 1)
			-- local action = cc.Sequence:create(cc.DelayTime:create(0.5), )
		end
		
	end
	
	-- fnUpdateContract();
end

--注意是.而不是:
function KGC_SKILL_CONTRACT_TYPE.RunDefendAni(sender, tbArg)
end

function KGC_SKILL_CONTRACT_TYPE:UIRunDefend(nTurn, tbLauncher, tbDefend, tbRetState, uiLayer, fnCallBack)
	print("contract UIRunDefend ... ", fnCallBack)
	fnCallBack();
end

end
----------------------------------------------------------

----------------------------------------------------------
--test
----------------------------------------------------------
