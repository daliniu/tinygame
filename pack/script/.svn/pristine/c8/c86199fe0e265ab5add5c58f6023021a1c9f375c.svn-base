require("script/ui/bagview/bagview")
require("script/class/class_base_ui/class_base_logic")

local cjson = require "cjson.core"

local l_tbUIUpdateType = def_GetUIUpdateTypeData();

local TB_STRUCT_BAG_VIEW_LOGIC={
    m_pLayer = nil,
    m_currentTabIndex = 1,      --当前标签页

    lastSellTab=nil,        --请求卖掉的道具集合
}

KGC_BagViewLogic=class("KGC_BagViewLogic", KGC_UI_BASE_LOGIC, TB_STRUCT_BAG_VIEW_LOGIC)


function KGC_BagViewLogic:getInstance()
    if KGC_BagViewLogic.m_pLogic == nil then
        KGC_BagViewLogic.m_pLogic = KGC_BagViewLogic:create()
        GameSceneManager:getInstance():insertLogic(KGC_BagViewLogic.m_pLogic)
    end
	
    return KGC_BagViewLogic.m_pLogic
end

function KGC_BagViewLogic:Init()

end

function KGC_BagViewLogic:create()
    local _logic = KGC_BagViewLogic.new()
    _logic:Init()
    return _logic
end

function KGC_BagViewLogic:initLayer(parent,id)
    if self.m_pLayer then
    	return
    end

    self.m_pLayer = KGC_BagView:create();
    self.m_pLayer.id = id;
	self.m_pLayer.flag = true
    parent:addChild(self.m_pLayer)
	--位置信息
	--self.m_pLayer:setPosition(cc.p(0, 150))
	
	-- 设置主界面底部按钮底框可见
	KGC_MainViewLogic:getInstance():ShowMenuBg();
	MapViewLogic:getInstance():ShowMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(true);
end

function KGC_BagViewLogic:closeLayer()
	if self.m_pLayer then
		local nID = self.m_pLayer.id
		GameSceneManager:getInstance():removeLayer(nID);
		
		self.m_pLayer = nil;
	end
	
	-- 设置主界面底部按钮底框不可见
	KGC_MainViewLogic:getInstance():HideMenuBg();
	MapViewLogic:getInstance():HideMenuBg();
	FightViewLogic:getInstance():SetPlayerInfoVisible(false);
end

function KGC_BagViewLogic:OnUpdateLayer(iType, tbArg)
	if self.m_pLayer ==nil then 
		return;
	end

	if iType == l_tbUIUpdateType.EU_BAG then 
		if self.m_pLayer.iState == 1 then 
			self:selfUpDate();
		end
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
	end
end

function KGC_BagViewLogic:selfUpDate()
	self.m_pLayer:updateSelf();
	self.m_pLayer:initCap();
	-- 更新背包界面上的二级界面
	self.m_pLayer:UpdateSubLayer();
end


-----------------------------------------------------协议相关---------------------
--请求出售物品
function KGC_BagViewLogic:reqSell(sellItemTab)
    self.lastSellTab = {}
    for k,v in pairs(sellItemTab) do
    	self.lastSellTab[k] = v;
    end

    local fnCallBack = function(tbArg)
        self:rspSell(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.sellgroup = sellItemTab;
    g_Core.communicator.loc.sellItemGroup(tbReqArg,fnCallBack);

end

--请求出售物品返回
function KGC_BagViewLogic:rspSell(pDate)

    local cost = pDate.cost;  --加的金币数量
    --加钱
    me:AddGold(cost);

    --减少物品
    for k,v in pairs(self.lastSellTab) do
        me.m_Bag:SubItem(tostring(k),v);
    end

    --更新界面信息
   	GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)

    self:selfUpDate();
end


--请求使用道具
function KGC_BagViewLogic:reqUseItem(nItemID, nHeroID)
	local fnCallback = function(tbArg)
		tst_print_lua_table(tbArg);
		print("[协议接收]使用道具 ... ");
		self:rspUseItem(nItemID, tbArg);
	end
	
	local tbArgReq = {};
	tbArgReq.item = nItemID;
	tbArgReq.heroId = nHeroID;
	print("[协议发送]使用道具 ... ");
	g_Core.communicator.loc.useItem(tbArgReq, fnCallback);
end

--使用道具
function KGC_BagViewLogic:UseItem(itemid)
	-- page@2015/10/07 根据使用道具的类型2判断作细化处理
	local itemTemp = KGC_ITEM_MANAGER_TYPE:getInstance():MakeItem(itemid);
	if not itemTemp then
		cclog("[Error]道具ID错误(%s)", tostring(itemid));
		return;
	end
	
	local fnReqUseItem = function(nHeroID)
		local nHeroID = nHeroID or 0;
		self:reqUseItem(itemid, nHeroID);
	end
	
	-- 根据道具类型作细化处理
	if itemTemp:IsExpItem() then		-- 个人经验道具
		KGC_HERO_SELECT_SUBLAYER_TYPE:create(self.m_pLayer, {fnReqUseItem});
	else								-- 默认处理方式
		fnReqUseItem();
	end
end

--请求使用道具返回
function KGC_BagViewLogic:rspUseItem(nItemID, tbData)
	if not nItemID or not tbData then
		cclog("[Error]道具使用返回数据为nil");
	end
    local itemid = nItemID;
    local baseinfo = tbData.baseInfo;
	local bagitem = tbData.bagItem;

	--消耗道具
	me.m_Bag:SubItem(tostring(itemid),1);

	--更新玩家基础信息
	me:SetGold(baseinfo.gold)
	me:SetAP(baseinfo.action)
	me:SetDiamond(baseinfo.diamond)
	me:AddLevel(baseinfo.level-me:GetLevel())	--等级特殊处理
	me:SetExp(baseinfo.curExp)
	
	-- 更新英雄新
	if tbData.heroInfoList then
		for id, data in pairs(tbData.heroInfoList) do
			local hero = me:GetHeroByID(tonumber(id));
			if hero then
				-- hero:Init(data);
				-- 经验和等级
				hero:SetExp(data.curExp);
				hero:SetLevel(data.level);
			end
		end
	end

	--增加道具和装备
	--道具
	if bagitem.itemList ~= nil then 
		for k,v in pairs((bagitem.itemList))do
			me.m_Bag:AddItem(k,v);
			if v.id ==nil then 
				v.id =k;
			end
			TipsViewLogic:getInstance():addItemTips(v.id,v.num)
		end
	end

	--装备
	if bagitem.equipList ~= nil then 
		for k,v in pairs((bagitem.equipList)) do
			me.m_Bag:AddItem(k,v);
			if v.id ==nil then 
				v.id =k;
			end
			TipsViewLogic:getInstance():addItemTips(v.id,v.num)
		end
	end

	local plog = me.m_Bag:GetItems();
	
    --更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)

    self:selfUpDate();
end

--@function：请求拆分
--@tbList: 所有装备的index的table{index1, index2, ...}
function KGC_BagViewLogic:reqSplit(tbList)
	local fnCallback = function(tbItems, nGold)
		self:OnRspSplit(tbItems, nGold);
	end
	KGC_EQUIP_LOGIC_TYPE:getInstance():reqSplit(tbList, fnCallback)
end

function KGC_BagViewLogic:OnRspSplit(tbItems, nMoney)
	KGC_EQUIP_LOGIC_TYPE:getInstance():OnRspSplit(tbItems, nMoney, self.m_pLayer)

	--更新界面信息
    GameSceneManager:getInstance():updateLayer(l_tbUIUpdateType.EU_MONEY)

    self:selfUpDate();
end

function KGC_BagViewLogic:reqBatchSplit(pTab)
	-- body
	local tbList = {}
	for index, num in pairs(pTab) do
		table.insert(tbList, index);
	end
	
	if #tbList <= 0 then
		return;
	end
	
	self:reqSplit(tbList)
end


--请求扩展背包
function KGC_BagViewLogic:reqExtendBag()

    local fnCallBack = function(tbArg)
        self:rspExtendBag(tbArg);
    end

    local tbReqArg = {};
    tbReqArg.uuid = me:GetUuid();
    tbReqArg.area = me:GetArea();
    g_Core.communicator.loc.unlockBag(tbReqArg,fnCallBack);

end

--请求扩展背包返回
function KGC_BagViewLogic:rspExtendBag(pDate)
	local iMax = pDate.max
	me.m_Bag:SetMaxSize(iMax);

	if self.m_pLayer~= nil then 
		self.m_pLayer:initCap();  --更新界面
	end
end