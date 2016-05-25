require("script/class/class_base_ui/class_base_sub_layer")

local TB_STORY_ANIMATION_LAYER = {
	fileName =nil,
	filePath =nil,
	animationName = nil,
	animationAciton =nil,
	functionCallBack =nil,
	functionCallBackClass =nil,
}

StoryAnimationLayer = class("StoryAnimationLayer",KGC_UI_BASE_SUB_LAYER,TB_STORY_ANIMATION_LAYER)

function StoryAnimationLayer:create(filePath,fileName,animationName,functionCallBack,functionCallBackClass)
	self = StoryAnimationLayer.new();
	self.fileName 			= 	fileName;
	self.animationName 		= 	animationName;
	self.filePath 			= 	filePath;
	self.functionCallBack 	=	functionCallBack;
	self.functionCallBackClass	= functionCallBackClass;
	self:initAttr();
	return self;
end

function StoryAnimationLayer:OnEixt()
	if self.animationAction~=nil then 
		self.animationAction:stop();
	end
end

function StoryAnimationLayer:ctor()

end

function StoryAnimationLayer:initAttr()

	local function funCallBack()
		if self.functionCallBack~=nil and 
			self.functionCallBackClass~=nil then 
			self.functionCallBack(self.functionCallBackClass);
		end
	end


	self.pWidget=ccs.GUIReader:getInstance():widgetFromJsonFile(self.filePath.."/"..self.fileName)
    self:addChild(self.pWidget)

    self.animationAction = ccs.ActionManagerEx:getInstance():playActionByName(self.fileName, self.animationName,cc.CallFunc:create(funCallBack))

end