--战斗播报层
require "script/class/class_base_ui/class_base_layer"

local l_tbSkillConfig = mconfig.loadConfig("script/cfg/skills/skills")
local l_tbSkillResultConfig = mconfig.loadConfig("script/cfg/skills/skillresults")
local l_tbBroadCast = mconfig.loadConfig("script/cfg/client/broadcast");
local l_tbFightTextConfig = mconfig.loadConfig("script/cfg/client/action/fighttext");
local l_tbCamp = def_GetFightCampData();
local l_tbEffect = def_GetEffectType();

local TB_FIGHT_RECORD_LAYER_STRUCT = 
{
	m_node = nil,		--json ui基节点	
	m_svText = nil,		--记录面板
	m_lblNpcName = nil,	--npc名字
	m_tbRichTexts = nil,--保存副文本
}

FightRecordLayer = class("FightRecordLayer", KGC_UI_BASE_LAYER, TB_FIGHT_RECORD_LAYER_STRUCT)

function FightRecordLayer:create()
	local pRecord = FightRecordLayer.new()
	return pRecord
end

function FightRecordLayer:ctor()
	self:initUI()
end

function FightRecordLayer:initUI()
	self.m_node = ccs.GUIReader:getInstance():widgetFromJsonFile(CUI_JSON_FIGHT_TXT_PATH)	
	self:addChild(self.m_node)

	self.m_svText = self.m_node:getChildByName("sv_text")
	self.m_svText:scrollToBottom(0, false)
	self.m_lblNpcName = self.m_svText:getChildByName("lbl_npc_name")
	local pnlTurn = self.m_svText:getChildByName("pnl_turn")
	pnlTurn:setVisible(false);
end

--@function: 插入一个播报到战斗界面中
--@szHead: 头标识
--@tbTexts: 播报内容
--@nCamp: 阵营-头标识显示在左边还是右边
--@bFlag: 是否显示头(长度还是根据前面szHead确定), 默认显示
function FightRecordLayer:InsertText(szHead, tbTexts, nCamp, bFlag)
	local nCamp = nCamp or 0;
	local tbPics = {
		[l_tbCamp.MINE] = l_tbFightTextConfig.szPath1,
		[l_tbCamp.ENEMY] = l_tbFightTextConfig.szPath2,
		[0] = l_tbFightTextConfig.szPath2,
	}
	
	local sizeWin = VisibleRect:getVisibleRectType();
	local width = l_tbFightTextConfig.nWidth or 500; 		-- 固定宽度为500
	local height = 10;		-- 初始化高度为100
	local rx, ry, rw, rh = unpack(l_tbFightTextConfig.tbCapInsets or {10, 10, 5, 22})
	local backGround = ccui.ImageView:create(tbPics[nCamp]);
	local nLeftFixedWidth = l_tbFightTextConfig.nFixedWidth;
	backGround._camp = nCamp;
	backGround:ignoreContentAdaptWithSize(false);
	backGround:setScale9Enabled(true);
	backGround:setCapInsets(cc.rect(rx, ry, rw, rh));

	backGround:setContentSize(cc.size(width, height))
	self.m_svText:addChild(backGround);
	
	local lblNpcName = self.m_lblNpcName:clone();
	lblNpcName:setVisible(true);
	lblNpcName:setLocalZOrder(-1);				-- 名字在战斗文字下层
	
	if bFlag then
		lblNpcName:setVisible(false);
	end
	local szNpcName = "";
	if szHead then
		szNpcName = "【" .. szHead .. "】"
	end
	lblNpcName:setString(szNpcName);
	backGround:addChild(lblNpcName);
	-- 重要：每一个聊天气泡从(0.5, 0)这个地方放置, 更方便计算
	backGround:setAnchorPoint(cc.p(0.5, 0))
	
	local sizeName = lblNpcName:getContentSize()
	local sizeBg = backGround:getContentSize();
	-- local x2 = sizeName.width + sizeBg.width/2
	-- page@2015/11/13 名字占固定宽度-->左对齐
	local x2 = sizeBg.width/2 + nLeftFixedWidth;
	if nCamp == l_tbCamp.MINE then
		-- x2 = sizeName.width + sizeBg.width/2
		--颜色(蓝)
		local r, g, b = unpack(l_tbFightTextConfig.tbColorBlue or {0, 153, 255})
		lblNpcName:setColor(cc.c3b(r, g, b));
	elseif nCamp == l_tbCamp.ENEMY then
		-- x2 = sizeWin.width - x2;
		--颜色(红)
		local r, g, b = unpack(l_tbFightTextConfig.tbColorRed or {255, 110, 0})
		lblNpcName:setColor(cc.c3b(r, g, b));
	elseif nCamp == 3 then
		x2 = sizeWin.width/2;
	else
		lblNpcName:setColor(cc.c3b(255, 0, 255));
	end
	--[[
		注：
		* 底框气泡做了一次翻转做了翻转, 0点坐标在尾部
		* 名字的坐标根据固定长度和名字长度计算得到
	--]]
	-- local x1 = sizeBg.width + sizeName.width/2;
	local x1 = sizeBg.width + (nLeftFixedWidth - sizeName.width/2);
	
	lblNpcName:setPosition(cc.p(x1, sizeBg.height/2))
	backGround:setPosition(cc.p(x2, -30));
	
	backGround:setScaleX(-1)
	lblNpcName:setScaleX(-1)
	
	local richText = ccui.RichText:create()
	richText:setVisible(false);
	local nWidthModify = l_tbFightTextConfig.nWidthModify or 25;
	richText:setContentSize(cc.size(width - nWidthModify, height))

	-- notify: 必须从小到大顺序填写
	for tag, tbItems in ipairs(tbTexts or {}) do
		local item = nil;
		local nType = tbItems[1];
		local r, g, b = unpack(tbItems[2])
		local nOpacity = tbItems[3]
		local szText = tbItems[4];
		local nFontSize = tbItems[6]
		if nType == 1 then
			item = ccui.RichElementText:create(tag, cc.c3b(r, g, b), nOpacity, szText, "Helvetica", nFontSize)
		elseif nType == 3 then		-- 自定义节点
			item = ccui.RichElementCustomNode:create(tag, cc.c3b(r, g, b), nOpacity, szText)
		end
		if item then
			richText:pushBackElement(item);
		end
	end
	
	local size = backGround:getContentSize();
	richText:setPosition(cc.p(size.width/2, size.height/2))
	richText:setName("richtext")
	-- 文本框需要在旋转一次才正常
	richText:setScaleX(-1)
	backGround:addChild(richText)
	
	-- 现在下一帧把最大长度调整一下
	local fnUpdate = function()
		local sizeRichText = richText:getVirtualRendererSize();
		local nWidthNew = sizeRichText.width + nWidthModify;
		
		if not self.m_tbRichTexts then
			self.m_tbRichTexts = {}
		end
		table.insert(self.m_tbRichTexts, backGround);
		
		-- page@2015/10/10 播报第一个出来太早了
		backGround:setVisible(false);
		
		self:RefreshText();
		
		backGround:setVisible(true);
	end
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(fnUpdate)))
end

function FightRecordLayer:RefreshText()
	local height = 100;		-- 初始化高度为100
	local fnMove = function()
		if not self.m_tbRichTexts then
			self.m_tbRichTexts = {}
		end

		local nTotal = #self.m_tbRichTexts;
		local posYS = l_tbFightTextConfig.nStartHeight or 30;	-- 起始高度
		local nMax = l_tbFightTextConfig.nMaxNums or 8;			-- 最大显示的战斗数据
		local nInterval = l_tbFightTextConfig.nSpace or 5;		-- 间隔
		local nLeftFixedWidth = l_tbFightTextConfig.nFixedWidth;
		
		-- 先放在最下面，再整体向上移动
		local fnModify = function(node)
			local nCamp = node._camp;
			local richtextPre = node:getChildByName("richtext");
			richtextPre:setVisible(true);
			local sizeRichText = richtextPre:getVirtualRendererSize();
			local nRichH = sizeRichText.height;
			if nRichH <= 0 then
				nRichH = height;
			end

			local nHeightModify = l_tbFightTextConfig.nHeightModify or 25;
			local nHeightNew = nRichH + nHeightModify;
			local nWidthModify = 36;
			local nWidthNew = sizeRichText.width + nWidthModify;
			node:setContentSize(cc.size(nWidthNew, nHeightNew))
			richtextPre:setPosition(cc.p(nWidthNew/2, nHeightNew/2))
			if nCamp == 3 then
				-- richtext锚点是(0.5, 0.5)
				richtextPre:setPosition(cc.p(nWidthNew/2, nHeightNew/2))
			end
			
			local lblNpcName = node:getChildByName("lbl_npc_name")
			local sizeName = lblNpcName:getContentSize()
			--[[
				注：
				* 底框气泡做了一次翻转做了翻转, 0点坐标在尾部
				* 名字的坐标根据固定长度和名字长度计算得到
			--]]
			local x0 = nWidthNew + (nLeftFixedWidth - sizeName.width/2);
			-- local x0 = nWidthNew + sizeName.width/2;
			lblNpcName:setPosition(cc.p(x0, nHeightNew/2));
			
			local sizeSvText = self.m_svText:getContentSize();
			-- page@2015/11/13 名字占固定宽度-->左对齐
			-- local x2 = sizeName.width + nWidthNew/2
			local x2 = nWidthNew/2 + nLeftFixedWidth;
			if nCamp == 3 then
				x2 = sizeSvText.width/2;
			end
			node:setPositionX(x2)

			return nHeightNew + nInterval;
		end
		
		--所有都重新调整大小(渲染getVirtualRendererSize才会得到真正的大小)
		local nYAdd = 0;
		for i= nTotal, 1, -1 do
			local node = self.m_tbRichTexts[i]
			if i > nTotal - nMax then	
				local h = fnModify(node)
				local posX, posY = node:getPosition();
				posY = posYS + nYAdd;
				node:setPositionY(posY);
				nYAdd = nYAdd + h;
			else
				self.m_svText:removeChild(node, true);
			end
		end
		
		for i = nTotal, 1, -1 do
			if i <= nTotal - nMax then
				table.remove(self.m_tbRichTexts, i);
			end
		end
		
	end
	
	-- 注意：延时getVirtualRendererSize的值才会刷新
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(fnMove)))
end

--@function: 插入系统播报
--@nType: 区分不同的播报类型, eg: 1000-奖励
function FightRecordLayer:InsertSystemText(nType, tbArg)
	local tbTextConfig = l_tbBroadCast[nType]
	if not tbTextConfig then
		cclog("[Error]播报配置错误!@UpdateText(效果类型(%s))", tostring(nType))
		return;
	end
	
	-- 默认文本配置
	local tbNormal = tbTextConfig.textcolour;
	local tbNormalColour = tbNormal[1]
	local nNormalOpacity = tbNormal[2]
	local nNormalFontSize = tbNormal[3]
	
	if nType == 1000 then			-- 战斗奖励
		local tbTexts = {};
		local nWinner, nGoldAdd, nExpAdd = unpack(tbArg or {});
		-- 1. 
		local szResult = (nWinner == 1) and "战斗胜利, " or "战斗失败, ";
		local ret1 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szResult, nil, nNormalFontSize)
		table.insert(tbTexts, ret1);
		-- 2.
		local szText1 = tbTextConfig.text1
		local ret2 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText1, nil, nNormalFontSize)
		table.insert(tbTexts, ret2);
		-- 3.
		local tbGoldConfig = tbTextConfig.skillnamecolour
		local szGold = tostring(nGoldAdd or 0);
		local ret3 = self:ConstructText(1, tbGoldConfig[1], tbGoldConfig[2], szGold, nil, tbGoldConfig[3])
		table.insert(tbTexts, ret3);
		-- 4.
		local szText2 = " ," .. tbTextConfig.text2
		local ret4 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText2, nil, nNormalFontSize)
		table.insert(tbTexts, ret4);
		-- 5.
		local tbExpConfig = tbTextConfig.effectrangecolour;
		local szExp = tostring(nExpAdd or 0);
		local ret5 = self:ConstructText(1, tbExpConfig[1], tbExpConfig[2], szExp, nil, tbExpConfig[3])
		table.insert(tbTexts, ret5);

		self:InsertText("系统", tbTexts)
	end
end

function FightRecordLayer:UpdateFightRecord(nCamp, nPos, nSkillId, nCost, tTarget, nHeroId, sHeroName)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	local nValue
	if not tSkillInfo then
		cclog("error: wrong skill id = %s", tostring(nSkillId))
		return
	end
	
	local szRange = self:GetRangeStrById(nSkillId)
	local nEffectType = l_tbSkillResultConfig[tSkillInfo.skillresultsid].effecttype
		
	for pos, target in pairs(tTarget) do			
		if not szRange or tSkillInfo.rangetype == 0 then --单体
			szRange = target.sHeroName
		end
		nValue = target.damage or nValue
	end		
	
	-- 召唤
	if nEffectType == l_tbEffect.E_CALL then				
		if tSkillInfo.target == 1 or tSkillInfo.target == 12 then
			szRange = (nPos - 3) .. "号位"
		elseif tSkillInfo.target == 2 then
			szRange = ""
			for i, v in ipairs(tSkillInfo.pos) do
				szRange = szRange .. v .. "号位"
			end
		end		
	end

	local szAttacker = sHeroName
	local szSkill = self:GetSkillNameById(nSkillId)
	
	local nDMin, nDMax = 9999999, 0
	nValue = nValue or 0
	local nDamage = math.floor(nValue)
	if nDamage < nDMin then
		nDMin = nDamage;
	end
	if nDamage > nDMax then
		nDMax = nDamage;
	end
	local szDamage = tostring(nDMax);
	if nDMax > nDMin then
		szDamage = nDMin .. "~" .. nDMax;
	end

	local tbTextConfig = l_tbBroadCast[nEffectType]
	if not tbTextConfig then
		cclog("[Error]播报配置错误!@UpdateText(效果类型(%s))", tostring(nEffectType))
		return;
	end
	
	-- 默认文本配置
	local tbNormal = tbTextConfig.textcolour;
	local tbNormalColour = tbNormal[1]
	local nNormalOpacity = tbNormal[2]
	local nNormalFontSize = tbNormal[3]
	
	local tbTexts = {}
	-- 第一个：说明文字1
	local szText1 = tbTextConfig.text1
	local nCastType = tSkillInfo.casttype
	if nCastType == 1 then
		szText1 = l_tbFightTextConfig.tbCastText[1]
	elseif nCastType == 2 then
		szText1 = l_tbFightTextConfig.tbCastText[2]
	end
	local ret1 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText1, nil, nNormalFontSize)
	table.insert(tbTexts, ret1);
	
	-- 第二个：费用图片
	local imgCost = ccui.ImageView:create(l_tbFightTextConfig.szPath3)
	imgCost:ignoreContentAdaptWithSize(false);
	local nW, nH = unpack(l_tbFightTextConfig.tbContentSize);
	imgCost:setContentSize(cc.size(nW, nH))
	local lblNumber = ccui.TextBMFont:create()
	lblNumber:setFntFile(l_tbFightTextConfig.szPath4);
	lblNumber:setString(nCost);
	lblNumber:setScale(l_tbFightTextConfig.nFontScale)
	local sizeImage = imgCost:getContentSize();
	lblNumber:setPosition(cc.p(sizeImage.width/2, sizeImage.height/2))
	imgCost:addChild(lblNumber);
	local retImage1 = self:ConstructText(3, tbNormalColour, nNormalOpacity, imgCost)
	table.insert(tbTexts, retImage1);
	
	-- 第二个：技能名字
	-- print("szSkill = ", szSkill)
	local tbSkillConfig = tbTextConfig.skillnamecolour
	local ret2 = self:ConstructText(1, tbSkillConfig[1], tbSkillConfig[2], szSkill, nil, tbSkillConfig[3])
	table.insert(tbTexts, ret2);
	
	-- 第三个：说明文字2
	local szText2 = " ," .. tbTextConfig.text2
	print("szText2 = ", szText2);
	local ret3 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText2, nil, nNormalFontSize)
	table.insert(tbTexts, ret3);
	
	-- 第四个：范围类型
	local tbSkillConfig = tbTextConfig.effectrangecolour
	print("szRange = ", szRange);
	local ret4 = self:ConstructText(1, tbSkillConfig[1], tbSkillConfig[2], szRange, nil, tbSkillConfig[3])
	table.insert(tbTexts, ret4);
	
	-- 第五个：说明文字3
	local szText3 = tbTextConfig.text3
	local ret5 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText3, nil, nNormalFontSize)
	table.insert(tbTexts, ret5);
	
	-- 第六个：效果
	local szEffect = ""
	local tbSkillConfig = tbTextConfig.effectcolour
	if nEffectType == l_tbEffect.E_ATK or nEffectType == l_tbEffect.E_CURE or nEffectType == l_tbEffect.E_COMMON then
		szEffect = szDamage;
	else
		local tSkillInfo = l_tbSkillConfig[nSkillId]
		szEffect = tSkillInfo.fighttext
	end
	local ret6 = self:ConstructText(1, tbSkillConfig[1], tbSkillConfig[2], szEffect, nil, tbSkillConfig[3])
	table.insert(tbTexts, ret6);
	
	-- 第七个：说明文字4
	local szText4 = tbTextConfig.text4
	local ret7 = self:ConstructText(1, tbNormalColour, nNormalOpacity, szText4, nil, nNormalFontSize)
	table.insert(tbTexts, ret7);
	self:InsertText(szAttacker, tbTexts, nCamp)
	
	print("[Log]更新战斗播报文字 end ... ")
end

function FightRecordLayer:ConstructText(nType, tbColour, nOpacity, content, szFont, nFontSize)
	local tbRet = {};
	local r, g, b = unpack(tbColour or {255, 255, 255})
	
	tbRet[1] = nType or 1;
	tbRet[2] = {r, g, b}
	tbRet[3] = nOpacity or 255
	tbRet[4] = content
	tbRet[5] = szFont or "Helvetica"
	tbRet[6] = nFontSize or 26
	return tbRet;
end

function FightRecordLayer:GetRangeStrById(nSkillId)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	if tSkillInfo then
		local eRangeType = tSkillInfo.rangetype
		local _, l_tbSSName = def_GetSkillScopeData()
		return l_tbSSName[eRangeType]
	end
end

function FightRecordLayer:GetSkillNameById(nSkillId)
	local tSkillInfo = l_tbSkillConfig[nSkillId]
	if tSkillInfo then
		return tSkillInfo.name
	end
end

function FightRecordLayer:InsertRoundStart(nRound)
	local pnlTurn = self.m_svText:getChildByName("pnl_turn")
	local tbTexts = {}
	local panel = pnlTurn:clone();
	local bmlRound = panel:getChildByName("bml_round_2")
	bmlRound:setString(nRound)
	panel:setVisible(true);
	local item = self:ConstructText(3, {255, 255, 255}, 255, panel)
	table.insert(tbTexts, item);
	self:InsertText(nil, tbTexts, 3, true)
end