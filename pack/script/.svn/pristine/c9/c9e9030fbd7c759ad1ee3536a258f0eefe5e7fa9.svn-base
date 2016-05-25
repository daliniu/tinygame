--========文件定义==================================--
--文件名：string.lua
--作者：yfeng
--创建日期：2004-6-1
--最后修改日期：2005-1-24
--功能叙述：
--	扩展lua未提供的字符串处理函数
--
--游戏脚本·剑侠情缘网络版
--金山软件股份有限公司，copyright 1992-2005
--==================================================--

--========函数定义==================================--
--函数原形：replace(str,pattern,s)
--作者：yfeng
--创建日期：2005-1-27
--最后修改日期：2005-1-27
--功能叙述：
--	用字符串s替换字符串str中的pattern
--参数：
--	str：源字符串n
--	pattern：要替换的字符串
--	s：替换pattern的字符串
--返回值：
--	替换后的字符串。
--用例：
--	无
--==================================================--
function sf_Replace(str,pattern,s)
	if pattern == s then	--预防死循环
		return str
	end;
	local nMaxLoop = string.len(str)
	local nLoop = 0;
	local startS,endS = string.find(str,pattern)
	while(startS) do	
		if nLoop > nMaxLoop then
			print("[函数库出错]:replace循环次数太大了，防止死循环，强行退出");
			return ""
		end;
		str = string.sub(str,1,startS-1)..s..string.sub(str,endS+1,string.len(str))
		startS,endS = string.find(str,pattern)
		nLoop = nLoop + 1;
	end
	return str
end
--把带颜色信息的字符串转变为可供Say和Talk使用的字符串
--szString：原字符串
--tbColorInfo：颜色信息。格式{标记头,标记尾,颜色英文单词}，例子如下：
--tbColorInfo = 
--{
--	[1] = {"{y","}","yellow"},
--	[2] = {"{g","}","green"},
--	[3] = {"{r","}","red"},
--}
function sf_ConvertColorString(szString,tbColorInfo)
	tbColorInfo = tbColorInfo or g_tbColorInfo;
	for i=1, table.getn(tbColorInfo) do
		szString = sf_Replace(szString,tbColorInfo[i][1],"<color="..tbColorInfo[i][3]..">");
		szString = sf_Replace(szString,tbColorInfo[i][2],"<color>");
	end;
	return szString;
end;
--删除标记，比如去掉字符串中所有<color>标记
--sTagS:标记的头，如"<"
--sTagE:标记的尾，如">"
--加上参数检查，如果不符合条件则返回空串
function sf_RemoveTag(sString,sTagS,sTagE)
	if sString == nil or type(sString) ~= "string" then
		return ""
	end
	local sSubStr = "";
	local nTagSIndex = string.find(sString,sTagS,1);
	local nTagEIndex = string.find(sString,sTagE,1);
	local nMaxLoop = string.len(sString)
	local nLoop = 0;
	while nTagSIndex ~= nil and nTagEIndex ~= nil do
		if nLoop >= nMaxLoop then
			print("[函数库出错]:sf_RemoveTag循环次数太大了，防止死循环，强行退出");
			return "";
		end;
		sSubStr = string.sub(sString,nTagSIndex,nTagEIndex)
		sString = sf_Replace(sString,sSubStr,"")
		nTagSIndex = string.find(sString,sTagS,nTagSIndex);
		if nTagSIndex ~= nil then
			nTagEIndex = string.find(sString,sTagE,nTagSIndex);
		end;
		nLoop = nLoop + 1;
	end;
	return sString
end;
--========函数定义==================================--
--函数原形：split(str,splitor)
--作者：yfeng
--创建日期：2004-6-1
--最后修改日期：2004-6-1
--功能叙述：
--	把字符串str用分裂符splitor分裂成数组形式
--参数：
--	str：被分裂的字符串
--	splitor：分裂符,如果该参数没有，默认为＂,＂
--返回值：
--	被分裂的数组．如果字符串str中没有包含分裂符splitor，
--则返回的数组只有１个元素，元素内容就是str本身．
--用例：
--	local s = "aaa,bbb,ccc,ddd"
--	local arr = splite(s,",")
--	则，arr的内容为：
--	arr[1]：aaa
--	arr[2]：bbb
--	arr[3]：ccc
--	arr[4]：ddd
--==================================================--
function sf_split(str,splitor)
	if(splitor==nil) then
		splitor=","
	end
	local strArray={}
	local strStart=1
	local splitorLen = string.len(splitor)
	local index=string.find(str,splitor,strStart,true)
	if(index==nil) then
		strArray[1]=str
		return strArray
	end
	local i=1
	while index do
		strArray[i]=string.sub(str,strStart,index-1)
		i=i+1
		strStart=index+splitorLen
		index = string.find(str,splitor,strStart,true)
	end
	strArray[i]=string.sub(str,strStart,string.len(str))
	return strArray
end

function sf_Split(str,splitor)
	return split(str,splitor);
end;


--========函数定义==================================--
--函数原形：sf_RemoveEndSpace(str)
--作者：tanzi
--创建日期：2010-6-18
--最后修改日期：2010-6-18
--功能叙述：
--	把字符串末尾的空格去掉
--参数：
--	str：目标字符串
--返回值：
--	返回目标字符串去掉末尾所有空格的结果
--  如果目标字符串是空值，则返回该空值
--==================================================--
function sf_RemoveEndSpace(str)
	local space = " "
	local strStart = 1
	local strLength = string.len(str)
	if str == nil or str == "" then
		return str
	end
	for i = strLength, strStart, -1 do
		strEnd = string.sub(str, i)
		if strEnd == space then
			str = string.sub(str, strStart, (i - 1))
		else
			break
		end
	end
	return str
end
--替换空格
function sf_ReplaceSpace(szString,nWide)
	nWide = nWide or 0;
	szString = szString or "";
	if nWide == 0 or nWide == 4 then
		szString = sf_Replace(szString,"    ",TWO_WORD_WIDE_STR);		--先处理四个空格
	end;
	if nWide == 0 or nWide == 2 then
		szString = sf_Replace(szString,"  ",WORD_WIDE_STR);	--再处理两个空格
	end;
	if nWide == 0 or nWide == 1 then
		szString = sf_Replace(szString," ",SPACE_WIDE_STR);	--再处理一个空格。但愿这种字符串替换处理效率较高。
	end;
	return szString;
end;

-- 去掉行首和行尾的空格
function sf_trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

--===Say面板排版函数===皆是单行操作===多于一行常规方法添加========
local LINE_PX_SIZE = 300;
local LINE_LETTER_NUM = 42;--line space number

function sf_space(nSpaceNum)
	local szSpace = "";
	if nSpaceNum > LINE_LETTER_NUM then return ""; end
	while nSpaceNum > 0 do
		szSpace = szSpace.." ";
		nSpaceNum = nSpaceNum - 1;
	end
	return szSpace;
end

--添加指定数量的新行
function sf_NewLine(szSrc, nNewLineCount)
	szSrc = szSrc or "";
	nNewLineCount = nNewLineCount or 1;
	for i = 1, nNewLineCount do
		szSrc = szSrc.."\n";
	end
	
	return szSrc;
end

--将文字居中
function sf_Center(szSrc, szAppend)
	szSrc = szSrc or "";
	szAppend = szAppend or "";
	
	local nAppendSize = string.len(szAppend);
	if nAppendSize > LINE_LETTER_NUM - 2 then return false; end
	
	local nSpaceNum = math.floor((LINE_LETTER_NUM - nAppendSize) / 2);
	local szPrefix = sf_space(nSpaceNum);
	local szPostfix = szPrefix;
	szSrc = szSrc..string.format("%s%s%s\n", szPrefix, szAppend, szPostfix);
	
	return szSrc;
end

--添加分隔符
function sf_SplitLine(szSrc, nLineSize)
	if nLineSize > LINE_LETTER_NUM then return; end
	szSrc = szSrc or "";
	nLineSize = nLineSize or 0;
	nLineSize = nLineSize > 0 and nLineSize * 2 or LINE_LETTER_NUM;
	local nSpaceNum = math.floor((LINE_LETTER_NUM - nLineSize) / 2);
	
	local szSplitLine = "";
	--/2 for wchar
	for i = 1, math.floor(nLineSize / 2) do
		szSplitLine = szSplitLine.."─";
	end
	local szPrefix = sf_space(nSpaceNum);
	local szPostfix = szPrefix;
	szSrc = szSrc..string.format("%s%s%s\n", szPrefix, szSplitLine, szPostfix);
	
	return szSrc;
end

--添加指定左对齐的文字
function sf_LeftAlign(szSrc, szAppend, nSpaceNum)
	szSrc = szSrc or "";
	szAppend = szAppend or "";
	-- * 2 for wchar
	nSpaceNum = type(nSpaceNum) == "number" and nSpaceNum * 2 or 0;
	
	local nAppendSize = string.len(szAppend);
	if string.len(szAppend) + nSpaceNum > LINE_LETTER_NUM then return false; end
	
	local szPrefix = sf_space(nSpaceNum);
	local szPostfix = sf_space(LINE_LETTER_NUM - nAppendSize - nSpaceNum);
	szSrc = szSrc..string.format("%s%s%s\n", szPrefix, szAppend, szPostfix);
	
	return szSrc;
end

--添加指定右对齐的文字
function sf_RightAlign(szSrc, szAppend, nSpaceNum)
	szSrc = szSrc or "";
	szAppend = szAppend or "";
	nSpaceNum = type(nSpaceNum) == "number" and nSpaceNum * 2 or 0;
	
	local nAppendSize = string.len(szAppend);
	if string.len(szAppend) + nSpaceNum > LINE_LETTER_NUM then return false; end
	
	local szPrefix = sf_space(LINE_LETTER_NUM - nAppendSize - nSpaceNum);
	local szPostfix = sf_space(nSpaceNum);	
	szSrc = szSrc..string.format("%s%s%s\n", szPrefix, szAppend, szPostfix);
	
	return szSrc;
end
