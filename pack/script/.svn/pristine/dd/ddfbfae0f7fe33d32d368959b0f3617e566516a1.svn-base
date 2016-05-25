----------------------------------------------------------
-- file:	actionfunctions
-- Author:	page
-- Time:	2015/03/30
-- Desc:	一些动作的通用函数，比如特效
----------------------------------------------------------
require "script/lib/basefunctions"
require "script/lib/testfunctions"
require("script/core/configmanager/configmanager");
----------------------------------------------------------
local l_tbEffectConfig = mconfig.loadConfig("script/cfg/client/effect")
local l_tbEffectDecoration = mconfig.loadConfig("script/cfg/client/decorationeffect")
local l_tbAudioConfig = mconfig.loadConfig("script/cfg/client/audio");

if not _SERVER_ then

--@function: 例子效果
function af_CreateParticle(szFileName)
	local particle = cc.ParticleSystemQuad:create(szFileName)
	if particle then
		return particle;
	end
end

--@function: 骨骼动画特效
--@tbArgs:
--[[
     *         loop < 0 : use the value from MovementData get from flash design panel
     *         loop = 0 : this animation is not loop
     *         loop > 0 : this animation is loop
	 
	 * nLayerID: 特效播放
--]]
function af_GetEffectByID(nID, fnCallBack, tbArgs)
	local nDuration, nLoop, nLayerID = unpack(tbArgs or {})
	local tbInfo = l_tbEffectConfig[nID]
	if not tbInfo then
		cclog("[Log]没有这个ID(%s)的特效, 播放失败", tostring(nID))
		if fnCallBack then
			fnCallBack();
		end
		return;
	end
	-- 音效ID
	local nAudioID = tbInfo.audio;
	local tbAudioInfo = l_tbAudioConfig[nAudioID];
	
	local szFileName, szArmature, szAnimation = tbInfo.effectpath, tbInfo.armature, tbInfo.mov
	--test
	print("addArmatureFileInfo @ af_GetEffectByID", nID, szFileName);
	--test end
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(szFileName)
	local armature = ccs.Armature:create(szArmature)
	
	local nScale = armature:getScale()
	print("af_GetEffectByID nScale", nID, nScale, tostring(armature), nDuration, nLoop)

	-- test
	-- print("****************************************11111");
	-- tst_print_textures_cache();
	-- print("****************************************11111");
	-- test
	local function fnAnimationEvent(armatureBack,movementType,movementID)
		if movementType == ccs.MovementEventType.complete then
			if movementID == szAnimation then
				if fnCallBack then
					fnCallBack();
				end
				armature:setVisible(false);
				armature:getAnimation():stop();
				armature:removeFromParent(true)
				print("删除特效", nID)
				
				-- 放完释放掉
				local tbIgnoreID = {
					[10013] = true,
					[10015] = true,
					[20008] = true,
					[20012] = true,
					[20028] = true,
					[20009] = true,
				}
				if not tbIgnoreID[nID] then
					-- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(szFileName);
					-- cc.Director:getInstance():getTextureCache():removeUnusedTextures();
					-- print("****************************************2222");
					-- tst_print_textures_cache();
					-- print("****************************************2222");
				end
				-- g_tbEffectUnUsed[szFileName] = true;
			end
		end
	end
	if armature then
		armature:getAnimation():setMovementEventCallFunc(fnAnimationEvent)
		armature:getAnimation():play(szAnimation, nDuration or -1, nLoop or -1);
		
		-- 播放音效
		if tbAudioInfo then
			local szPath = tbAudioInfo.path;
			AudioManager:getInstance():playEffect(szPath, nLayerID);
		end
	end
	return armature;
end

--@function: 绑定特效
--@node：node-绑定到的节点
--@nID：nID-特效ID
--@tbNodeArgs：-父节点的相关参数{位置百分比{0.5, 0.5}, localZOrder}
--@tbEffArgs:特效本身部分参数{duration, loop, nLayerID}
function af_BindEffect2Node(node, nID, tbNodeArgs, nScale, fnCallBack, tbEffArgs)
	cclog("绑定特效(%d)到节点node(%s-%s)", nID, tostring(node), node:getName())
	local nScale = nScale or false;
	local tbNodeArgs = tbNodeArgs or {}
	local tbEffArgs = tbEffArgs or {}
	
	local effect = af_GetEffectByID(nID, fnCallBack, tbEffArgs);
	if not node or not effect then
		return;
	end
	
	local sizeNode = node:getContentSize();
	local x = sizeNode.width * 0.5;
	local y = sizeNode.height * 0.5;
	
	local xPro, yPro  = unpack(tbPro or {0.5, 0.5})
	x = sizeNode.width * xPro;
	y = sizeNode.height * yPro;
	--end
	local point = tbNodeArgs[1]
	if point then
		x = sizeNode.width * point[1]
		y = sizeNode.height * point[2]
	end
	effect:setPosition(cc.p(x, y))

	local nLocalZOrder = tbNodeArgs[2] or 1
	--默认特效要求在上面显示
	node:addChild(effect, nLocalZOrder)
	
	if nScale then
		effect:setScale(nScale)
	else
		local sizeEffect = effect:getContentSize();
		local nEffectScale = sizeNode.width/sizeEffect.width;
		local nEffectScaleH = sizeNode.height/sizeEffect.height;

		if nEffectScale < nEffectScaleH then
			nEffectScale = nEffectScaleH;
		end
		print("af_BindEffect2Node", nID, sizeNode.width, sizeEffect.width, nEffectScale, effect:getScale())
		effect:setScale(nEffectScale)
	end
	
	return effect;
end



function lableNumAnimation(pWidget,numBegin,numEnd,fTime)
	
	-- pWidget:setString(tostring(numEnd));

	-- if true then 
	-- 	return;
	-- end

	local offNum = 0;

	local function fun_addNum(node,tab)
		local iNum = tonumber(pWidget:getString())
		iNum = iNum + offNum;
		if offNum>0 then 
			if iNum >= numEnd then 
				iNum=numEnd;
			end
		end

		if offNum<0 then 
			if iNum <= numEnd then 
				iNum=numEnd;
			end
		end

		pWidget:setString(tostring(iNum))

	end

	local function fun_setNum(node,tab)
		pWidget:setString(tostring(numEnd));
	end

	pWidget:stopAllActions();
	local offsetTime = 0.1;
	if numBegin == nil then
		numBegin = tonumber(pWidget:getString());
	end
	local iCount = fTime/offsetTime
	offNum = math.floor((numEnd - numBegin)/(iCount));
	if math.abs(offNum)<=1 then
		pWidget:setString(tostring(numEnd))
		return;
	end



	local actionTab ={};
	for i=1,iCount do
		local fTime =offsetTime;
		if i==1 then 
			fTime = 0;
		end
		local pCallBack =cc.CallFunc:create(fun_addNum,{});
		local actionTime = cc.DelayTime:create(fTime)
		local pSqueAction = cc.Sequence:create(actionTime,pCallBack)
		table.insert(actionTab,pSqueAction);
	end
	local setAction = cc.CallFunc:create(fun_setNum,{});
	table.insert(actionTab,setAction);
	local pAction= cc.Sequence:create(actionTab);
	pWidget:runAction(pAction);

end

--@function: 获取一般特效定制信息
--@nID: 定制信息ID
function af_GetEffectModifyInfo(nID)
	local tbConfig = l_tbEffectDecoration[nID];
	if tbConfig then
		local nEffectID = tbConfig.eff_id;
		local tbPos = tbConfig.position;
		local nScale = tbConfig.scale;
		return {nEffectID, tbPos, nScale};
	end
end


--进度条循环动画
function af_expLoopEffectAnimation(m_BarExp)
	local EffectNode1 = af_GetEffectByID(60043);
	m_BarExp:addChild(EffectNode1);
	EffectNode1:setPositionY(5);

	local expWidth = m_BarExp:getContentSize().width;

	local function fun_addMoveAnimation(node,table)
		node:setPositionX(0);
		local value = m_BarExp:getPercent()*0.01;
		local fMoveDis = value*expWidth-20;
		local pAction = cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(fMoveDis,0)),
											cc.CallFunc:create(fun_addMoveAnimation,{}));
		node:runAction(pAction);
	end

	local value = m_BarExp:getPercent()*0.01;
	local fMoveDis = value*expWidth-20;
	
	local pAction = cc.Sequence:create(cc.MoveBy:create(1.0,cc.p(fMoveDis,0)),
										cc.CallFunc:create(fun_addMoveAnimation,{}));
	EffectNode1:runAction(pAction);
end



end