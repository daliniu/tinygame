----------------------------------------------------------
-- file:	magic.lua
-- Author:	page
-- Time:	2015/04/28 15:44
-- Desc:	多重施法
--			
----------------------------------------------------------
require "script/core/skill/common/base"
----------------------------------------------------------
--data struct
local TB_SKILL_MAGIC_STRUCT = {
	--config
	------------------------------------
	m_tbSubSkills = {},			--多重施法触发的技能
	------------------------------------
	
}

KGC_SKILL_MAGIC_TYPE = class("KGC_SKILL_MAGIC_TYPE", KGC_SKILL_BASE_TYPE, TB_SKILL_MAGIC_STRUCT)
local l_tbHitType = def_GetHitTypeData();
local l_tbEffectConfig = require ("script/cfg/client/action/magicconfig")
----------------------------------------
--function
----------------------------------------
function KGC_SKILL_MAGIC_TYPE:ctor()
end

--
function KGC_SKILL_MAGIC_TYPE:OnInit()
	
end

function KGC_SKILL_MAGIC_TYPE:SetSubSkills(tbMagicSkills)
	self.m_tbSubSkills = tbMagicSkills or {};
end

function KGC_SKILL_MAGIC_TYPE:GetSubSkills()
	return self.m_tbSubSkills;
end

function KGC_SKILL_MAGIC_TYPE:UIRunDefend(nTurn, tbLauncher, tbDefend, tbRetState, uiLayer, fnCallBack)
	print("magic UIRunDefend ... ", fnCallBack)
	fnCallBack();
end

function KGC_SKILL_MAGIC_TYPE:PlayFrameEventEffect(tbRetLau, uiLayer, nCastRet, fnCallBack)
	-- local src = self:GetLauncher()
	local src = self:GetCaster()
	local nCamp = src:GetFightShip():GetCamp();
	local nPos = src:GetPos();
	local nodeSrc = uiLayer:GetStillNode(nCamp, nPos);
	local nLayerID = uiLayer:GetLayerID();		-- for 特效
	
	if not nodeSrc then
		return;
	end
	
	local srcX, srcY = nodeSrc:getPosition();
	
	local skills = self:GetSubSkills() or {};
	--config
	local nFade = l_tbEffectConfig.nFade or 0.5
	local nMinSeg = l_tbEffectConfig.nMinSeg or 15
	local nStroke = l_tbEffectConfig.nStroke or 25
	local r, g, b = unpack(l_tbEffectConfig.tbColor)
	local nTime = l_tbEffectConfig.nTime
	local tbPos = l_tbEffectConfig.tbPos or {0.5, 0.2};
	local tbPosStart = l_tbEffectConfig.tbPosStart
	local tbPosEnd = l_tbEffectConfig.tbPosEnd
	
	for _, skill in pairs(skills) do
		-- local lau = skill:GetLauncher()
		local lau = skill:GetCaster()
		local nCamp = lau:GetFightShip():GetCamp();
		local nPos = lau:GetPos();
		local node = uiLayer:GetStillNode(nCamp, nPos);
		
		--拖尾("res/ui/temp/streak7.png")
		local streak = cc.MotionStreak:create(nFade, nMinSeg, nStroke, cc.c3b(r, g, b), CUI_PATH_MAGIC_STREAK)
		streak:setBlendFunc(gl.ONE, gl.ONE);	--高亮叠加
		nodeSrc:addChild(streak);
		local srcSize = nodeSrc:getContentSize();
		local posX, posY = srcSize.width * (tbPosStart[1] or 0.5), srcSize.height * (tbPosStart[2] or 1.1)
		streak:setPosition(cc.p(posX, posY))
		
		if node then
			local nodeX, nodeY = node:getPosition();
			local nodeSize = node:getContentSize();
			local x = (nodeX + nodeSize.width * (tbPosEnd[1])) - (srcX + posX) 
			local y = (nodeY + nodeSize.height * (tbPosEnd[2])) - (srcY + posY);
			local fnCall = function()
				streak:removeFromParent(true)
				
				--增加脚底特效
				local effect = af_BindEffect2Node(node, 20002, {tbPos, -1}, nil, nil, {nil, nil, nLayerID})
				skill:UIAddEffect(20002, effect)
			end
			
			local fnHit = function()
				local effect = af_BindEffect2Node(node, 40005, nil, nil, nil, {nil, nil, nLayerID})
			end
			
			local move = cc.MoveBy:create(nTime, cc.p(x, y))
			local action = cc.Sequence:create(move, cc.CallFunc:create(fnCall))
			local spa = cc.Spawn:create(action, cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnHit)))
			streak:runAction(spa);
		end
	end
end

----------------------------------------------------------

----------------------------------------------------------
--test
----------------------------------------------------------
