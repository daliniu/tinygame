
local RICH_TYPE_TEXT	=	"text"
local RICH_TYPE_IMAGE	=	"image"

AnnouncementRichText = class("AnnouncementRichText",function()
	return cc.Node:create()
end)


function AnnouncementRichText:create(configTab)
	self = AnnouncementRichText.new()
	self.configTab = configTab;
	self:initAttr();
	return self;
end

function AnnouncementRichText:initVar()
	self.configTab =nil;		--配置信息
	self.elementIndex = 0;		--编号
	self.length = 0;
	self.height = 0;
end

function AnnouncementRichText:ctor()
	self:initVar();
end 

function AnnouncementRichText:initAttr()
	
	local pNode = cc.Node:create();
	for k,line in pairs(self.configTab) do
		self:cleanElementIndex();
		local pLineElement = self:getLine(line)
		if pLineElement~=nil then 
			pNode:addChild(pLineElement);
		end
	end

	self:setPositionX(self.length*0.5)
	self:setPositionY(self.height*0.5);
	self:addChild(pNode);
end

function AnnouncementRichText:getLine(lineTab)
	local pLineElement = ccui.RichText:create()
	--pLineElement:ignoreContentAdaptWithSize(true);
	--pLineElement:setContentSize(cc.size(100,300))	
	for v,elementTab in pairs(lineTab) do
		--elment
		local element = nil;
		--tupe
		if elementTab.type == RICH_TYPE_TEXT then
			element = self:addTextNode(elementTab);
		elseif elementTab.type == RICH_TYPE_IMAGE then 
			element = self:addImageNode(elementTab);
		end
		--addchild
		if element~=nil then
			self:addLength(element.length)
			self:setHeight(element.height);
			pLineElement:pushBackElement(element)
		end
	end
	return pLineElement;
end

--[[
 info="内容"			--文字内容
 size="20"     			--文字大小
 color="#FFFFFFFF"		--颜色

]]--
function AnnouncementRichText:addTextNode(textConfig)
	local index 	= 	self:getElementIndex();			--编号
	local color 	= 	textConfig.color;				--颜色
	local alpha 	= 	255;							--alpha
	local info 		= 	textConfig.info;				--信息
	local fontType 	=	"Helvetica"						--字体
	local size 		= 	tonumber(textConfig.size);		--字体大小

	local length = string.len(info)*size;
	local height = size;

	local element =ccui.RichElementText:create(index,self:ConvertHexToRGB(color),alpha,info,fontType,size)
	element.length = length;
	element.height = height;

	return element;
end

--[[
src ="路径"				--资源路径
width,
height
]]--

function AnnouncementRichText:addImageNode(imgConfig)
	local index 	= self:getElementIndex();
	local color 	= cc.c3b(255, 255, 255)
	local alpha 	= 255;
	local src		= imgConfig.src;
	local width     = tonumber(imgConfig.width);
	local height 	= tonumber(imgConfig.height);


	local sp = ccui.ImageView:create();
	sp:loadTexture(src)
	if width~=nil and height~=nil then
		sp:setScaleX(width/sp:getContentSize().width)
		sp:setScaleY(height/sp:getContentSize().height)
	end

	local element = ccui.RichElementCustomNode:create(index,color,alpha,sp)

	element.length = width;
	element.height = height;

	if width==nil or height==nil then 
		element.length = sp:getContentSize().width;
		element.height = sp:getContentSize().height;
	end
	return element;

end


function AnnouncementRichText:getElementIndex()
	self.elementIndex = self.elementIndex+1;
	return 1;
end

function AnnouncementRichText:cleanElementIndex()
	self.elementIndex = 0;
end

function AnnouncementRichText:ConvertHexToRGB(hex)  
	local red = string.sub(hex, 1, 2)  
	local green = string.sub(hex, 3, 4)  
	local blue = string.sub(hex, 5, 6)  
	 
	red = tonumber(red, 16)
	green = tonumber(green, 16)
	blue = tonumber(blue, 16)
	
	return cc.c3b(red, green, blue)
end 


function AnnouncementRichText:setHeight(fValue)
	if fValue> self.height then 
		self.height = fValue;
	end
end

function AnnouncementRichText:addLength(fValue)
	self.length=self.length+fValue;
end