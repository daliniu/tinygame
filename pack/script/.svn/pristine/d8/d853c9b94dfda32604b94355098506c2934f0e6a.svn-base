require "script/class/class_base.lua"
require "script/ui/resource"

--data struct
local TB_UI_BASE_STRUCT = {
	--config
	m_szJsonFile = nil,			-- 界面对应的json文件
	m_bUpdate = false,			-- 是否updae
	---------------------------------------------------
	m_pLayout = nil,			-- layout
	m_nID = 0,	

	m_tbSubLayers = {},
	
	m_tbActions = {},			-- 界面上的动画
	
	m_m_pMainBtnLayer = nil,	-- 下面一排按钮
}

KGC_UI_BASE_LAYER = class("KGC_UI_BASE_LAYER",function()
    return cc.Layer:create()
end, TB_UI_BASE_STRUCT)

KGC_UI_BASE_LAYER.id=0;


function KGC_UI_BASE_LAYER:ctor()
	local function fnUpdate(dt)
		self:Update(dt);
	end

	if self.m_bUpdate then
		self:scheduleUpdateWithPriorityLua(fnUpdate, 0)
	end
	
	local fnNodeEvent = function(tag)
		-- print("exit-tag: ", tag, self.__cname)
		if tag == "exit" then
			self:Exit();
		end
	end
	self:registerScriptHandler(fnNodeEvent)
	
	-- 加载json对应的界面
	if self.m_szJsonFile then
		self.m_pLayout = ccs.GUIReader:getInstance():widgetFromJsonFile(self.m_szJsonFile);
		self:addChild(self.m_pLayout);
	end
end

function KGC_UI_BASE_LAYER:create()
    self = KGC_UI_BASE_LAYER.new()
    self:playBackgroundMusic();
    return self
end

function KGC_UI_BASE_LAYER:display()
	self:setScale(1);
	self:setVisible(true);

	self:playBackgroundMusic();
end

function KGC_UI_BASE_LAYER:hide()
	self:setScale(0.001);
	self:setVisible(false);
end

function KGC_UI_BASE_LAYER:playBackgroundMusic()

	
end


function KGC_UI_BASE_LAYER:closeLayer()
	GameSceneManager:getInstance():removeLayer(self.id)
end

--@function: 获取类名字
function KGC_UI_BASE_LAYER:GetClassName()
	return self.__cname;
end

--@function: 兼容之前的ui
-- function KGC_UI_BASE_LAYER:GetLayer()
	-- return self;
-- end

function KGC_UI_BASE_LAYER:Update(dt)
	-- print("update.. ", dt)
end

--@function: 统一播放UI动画
--@szName: 文件名(不需要任何路径)
--@szAction: UI动画的动画名字
--@fnCallBack: 要求先转成cc.CallFunc:create()对象;
function KGC_UI_BASE_LAYER:PlayUIAction(szName, szAction, fnCallBack)
	if not szName or not szAction then
		return;
	end

	local action = ccs.ActionManagerEx:getInstance():playActionByName(szName, szAction, fnCallBack);
	if not action then
		return;
	end

	-- 用文件名+动画 标识key的唯一性
	self:AddAction(szName .. szAction, action);
	return action;
end

--@function: 添加动画管理
--@szKey: 一个action对应一个key
function KGC_UI_BASE_LAYER:AddAction(szKey, action)
	if not action then
		return;
	end
	if not self.m_tbActions then
		self.m_tbActions = {};
	end
	-- 一个界面动画可能播放多次, 所以不用table.insert
	self.m_tbActions[szKey] = action;
end

--@function: 清理动画
function KGC_UI_BASE_LAYER:ClearAction()
	for _, action in pairs(self.m_tbActions or {}) do
		if action then
			action:stop();
		end
	end
	self.m_tbActions = {};
end

--@function: 界面退出
function KGC_UI_BASE_LAYER:Exit()
	-- 动画处理：宕机
	self:ClearAction();

	self:OnExit();
	
	-- 界面退出去之后清资源
	-- cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames();
    -- cc.Director:getInstance():getTextureCache():removeUnusedTextures();
end

function KGC_UI_BASE_LAYER:OnExit()
	
end

--@function: 获取界面在GameSceneManager中的ID
function KGC_UI_BASE_LAYER:GetLayerID()
	print("当前界面id为：", self.id);
	return self.id;
end

function KGC_UI_BASE_LAYER:CloseSubLayer(layer)
	local tbSubLayers = self:GetSubLayers();
	local bTestFlag = false;
	for k, v in pairs(tbSubLayers) do
		if layer == v then
			bTestFlag = true;
			table.remove(tbSubLayers, k);
			break;
		end
	end
	if bTestFlag then
		cclog("[Log]%s成功移除二级界面(%s)", self:GetClassName(), layer:GetClassName());
	else
		cclog("[Error]没有二级界面需要移除(%s)", layer:GetClassName());
	end
	
	self:OnCloseSubLayer(layer);
end

function KGC_UI_BASE_LAYER:OnCloseSubLayer(layer)
	
end

--@function: 增加一个二级界面
function KGC_UI_BASE_LAYER:AddSubLayer(layer)
	if not layer then
		cclog("[Error]二级界面为空!@AddSubLayer");
		return;
	end
	self:addChild(layer);
	
	local tbSubLayers = self:GetSubLayers();
	table.insert(tbSubLayers, layer);
end

--@function: 更新sublayer
function KGC_UI_BASE_LAYER:UpdateSubLayer(nID, tbArg)
	local tbSubLayers = self:GetSubLayers();
	for _, layer in pairs(tbSubLayers) do
		layer:OnUpdateLayer(nID, tbArg);
	end
	
	self:OnUpdateSubLayer();
end

--@function: 更新sublayer之后，自己处理；子类重载这个函数自行处理
function KGC_UI_BASE_LAYER:OnUpdateSubLayer()
end

function KGC_UI_BASE_LAYER:GetSubLayers()
	if not self.m_tbSubLayers then
		self.m_tbSubLayers = {};
	end
	return self.m_tbSubLayers;
end

function KGC_UI_BASE_LAYER:AddMainButton()
	local btnMainLayer = require("script/ui/publicview/mainbuttonview");
	self.m_pMainBtnLayer = btnMainLayer:create()
    self:AddSubLayer(self.m_pMainBtnLayer)
end

function KGC_UI_BASE_LAYER:GetMainButton()
	return self.m_pMainBtnLayer;
end

--@function: 更新提示
function KGC_UI_BASE_LAYER:UpdateRemind()
	-- 主按钮
	local layer = self:GetMainButton();
	if layer then
		layer:UpdateRemind();
	end
	
	self:OnUpdateRemind();
end

--@function: 更新提示子类重载操作
function KGC_UI_BASE_LAYER:OnUpdateRemind()
end