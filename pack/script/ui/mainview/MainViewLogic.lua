----------------------------------------------------------
-- file:	mainviewlogic.lua
-- Author:	疯子(峰)
-- Time:	很久很久以前
-- Desc:	主界面逻辑
-------------------------------------------------------
require("script/ui/mainview/MainView")
require("script/class/class_base_ui/class_base_logic")

-------------------------------------------------------
local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local TB_STRUCT_MAIN_VIEW_LOGIC={
    -- m_pLogic = nil,
    -- m_pLayer = nil,

	m_tbUpdateTypes = {				--界面更新类型集合
		l_tbUIUpdateType.EU_MONEY,		-- 金钱类
		l_tbUIUpdateType.EU_LEVELUP,	-- 英雄升级
	},
}

KGC_MainViewLogic=class("KGC_MainViewLogic",function()
    return KGC_UI_BASE_LOGIC:create()
end, TB_STRUCT_MAIN_VIEW_LOGIC)


function KGC_MainViewLogic:getInstance()
    if KGC_MainViewLogic.m_pLogic==nil then
        KGC_MainViewLogic.m_pLogic=KGC_MainViewLogic:create()
        GameSceneManager:getInstance():insertLogic(KGC_MainViewLogic.m_pLogic)
    end
    return KGC_MainViewLogic.m_pLogic;
end

function KGC_MainViewLogic:initAttr()

end

function KGC_MainViewLogic:create()
    local _logic = KGC_MainViewLogic:new()
    _logic:initAttr()
    return _logic
end

function KGC_MainViewLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end
    self.m_pLayer = KGC_MainView.new(CUI_JSON_MAIN);
    self.m_pLayer.id=id;
    parent:addChild(self.m_pLayer)
end

function KGC_MainViewLogic:closeLayer()

end

function KGC_MainViewLogic:OnUpdateLayer(iType, tbArg)
	local tbArg = tbArg or {}
	if self.m_pLayer then
		if iType == l_tbUIUpdateType.EU_MONEY then
			self.m_pLayer:UpdateData();
			
			self.m_pLayer:UpdateSubLayer();
		elseif iType == l_tbUIUpdateType.EU_LEVELUP then
			local nPos = tbArg[1] or 0;
			print("玩家升级了！！！！！！！！！！！！")
			-- TipsViewLogic:getInstance():addMessageTips(12000);
			self.m_pLayer:UpdateLevel(nPos)
		elseif iType == l_tbUIUpdateType.EU_ARMATURE then
			self.m_pLayer:UpdateHeros()
		elseif iType == l_tbUIUpdateType.EU_AFKERREWARD then
			if self.m_pLayer.m_pMainBtnLayer then
				local nPercent = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:SetRewardProgress(0, nPercent);
			end
		elseif iType == l_tbUIUpdateType.EU_SEARCH then
			if self.m_pLayer.m_pMainBtnLayer then
				local nSearchT = (tbArg or {})[1] or 0;
				self.m_pLayer.m_pMainBtnLayer:StartSearch(nSearchT);
			end
		elseif iType == l_tbUIUpdateType.EU_FIGHTHP then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local nSelfHp = (tbArg or {})[1] or 0;
	            local nEnemyHp = (tbArg or {})[2] or 0;
	            self.m_pLayer.m_pMainBtnLayer:SetFightHp(nSelfHp, nEnemyHp);
	        end
	    elseif iType == l_tbUIUpdateType.EU_FIGHTRESULT then
	        if self.m_pLayer.m_pMainBtnLayer then
	            local bWin = (tbArg or {})[1] or false;
	            local tReward = (tbArg or {})[2] or {};
	            self.m_pLayer.m_pMainBtnLayer:SetResult(bWin, tReward);
	        end
		elseif iType == l_tbUIUpdateType.EU_REMIND then
			print("更新提示(remind) ... @KGC_MainViewLogic");
			self.m_pLayer:UpdateRemind();
		end

		self.m_pLayer:inintButtonState();
		self.m_pLayer.m_pMainBtnLayer:initButtonState();
	end
end

function KGC_MainViewLogic:ShowMenuBg()
	if self.m_pLayer then
		self.m_pLayer:SetMenuBgVisible(true);
	end
end

function KGC_MainViewLogic:HideMenuBg()
	if self.m_pLayer then
		self.m_pLayer:SetMenuBgVisible(false);
	end
end

--@function: 发送获取英雄列表请求
--@nType: 1-打开英雄列表界面(阵上);2-打开图鉴界面
function KGC_MainViewLogic:ReqHeroList(nType, tbHeros)
	local fnCallBack = function(tbArg)
		print("[接受服务器数据]协议-获取英雄列表")
		tst_print_lua_table(tbArg);
		local tbHeroList = tbArg.heroInfoList;
		local tbHeroBook = tbArg.heroBookInfo;
		me:SetAllHeros(tbHeroList);
		
		if nType == 1 then			-- 英雄列表界面
			self:OpenHeroList(tbHeroList);
		elseif nType == 2 then		-- 图鉴界面
			self:OpenHandBook(tbHeroBook, tbHeros);
		end
	end
	print("[发送请求]协议-获取英雄列表");
	g_Core.communicator.loc.getHeroInfoList(fnCallBack);
end

--@function: 打开阵上英雄界面
function KGC_MainViewLogic:OpenHeroList(tbData)
	print("获取英雄列表： ", #(tbData or {}))
	tst_print_lua_table(tbData)
	
	local nHeros = #(me:GetAllHeros() or {});
	if nHeros <= 0 then
		cclog("[Warning]没有英雄数据！");
		TipsViewLogic:getInstance():addMessageTips(12208);
		return;
	else
		GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_HEROINFO)
	end
end

--@function: 打开图鉴界面
function KGC_MainViewLogic:OpenHandBook(tbHeroBook, tbHeros)
	local tbHeros = tbHeros or {};
	--处理保证不会出现两个相同的英雄
	local tbTemp = {tonumber(tbHeroBook.heroId1), tonumber(tbHeroBook.heroId2), tonumber(tbHeroBook.heroId3)};
	
	for k, v in pairs(tbTemp) do
		if v == tbHeros[1] then
			print("[Warning]出现了相同的英雄了 ... ", tbTemp[1], tbTemp[2], tbTemp[3], tbHeros[1]);
			-- 交换
			tbTemp[1], tbTemp[k] = tbTemp[k], tbTemp[1];
			break;
		end
	end
	if tbHeros[1] then
		print("成功过替换第一个英雄", tbTemp[1], tbHeros[1]);
		tbTemp[1] = tbHeros[1];
	end

	local nTimes = tonumber(tbHeroBook.summomNums);
	local tbHeroBookEx = {tbTemp[1], tbTemp[2], tbTemp[3], nTimes};
	-- 打开界面
	GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_HANDBOOK, tbHeroBookEx)
end

--@function: 发送获取英雄列表请求
--@tbHeros: 希望界面上显示指定英雄
-- function KGC_MainViewLogic:ReqHeroListNew(tbHeros)
	
	-- local tbHeros = tbHeros or {};
	-- local fnCallBack = function(tbArg)
		-- print("[接受服务器数据]协议-获取英雄列表")
		-- tst_print_lua_table(tbArg);
		-- local tbHeroList = tbArg.heroInfoList;
		-- local tbHeroBook = tbArg.heroBookInfo;
		-- me:SetAllHeros(tbHeroList);
		
		-- --处理保证不会出现两个相同的英雄
		-- local tbTemp = {tonumber(tbHeroBook.heroId1), tonumber(tbHeroBook.heroId2), tonumber(tbHeroBook.heroId3)};
		
		-- for k, v in pairs(tbTemp) do
			-- if v == tbHeros[1] then
				-- print("[Warning]出现了相同的英雄了 ... ", tbTemp[1], tbTemp[2], tbTemp[3], tbHeros[1]);
				-- -- 交换
				-- tbTemp[1], tbTemp[k] = tbTemp[k], tbTemp[1];
				-- break;
			-- end
		-- end
		-- if tbHeros[1] then
			-- print("成功过替换第一个英雄", tbTemp[1], tbHeros[1]);
			-- tbTemp[1] = tbHeros[1];
		-- end
	
		-- local nTimes = tonumber(tbHeroBook.summomNums);
		-- local tbHeroBookEx = {tbTemp[1], tbTemp[2], tbTemp[3], nTimes};
		-- -- 打开界面
		-- GameSceneManager:getInstance():addLayer(GameSceneManager.LAYER_ID_HANDBOOK, tbHeroBookEx)
	-- end
	-- print("[发送请求]协议-获取英雄列表");
	-- g_Core.communicator.loc.getHeroInfoList(fnCallBack);
-- end