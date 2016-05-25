----------------------------------------------------------
-- file:	timefunctions.lua
-- Author:	page
-- Time:	2015/09/23
-- Desc:	扩展lua未提供的时间处理函数

-- @游戏脚本·Tiny项目组
-- @金山软件股份有限公司，copyright 2015
----------------------------------------------------------

--@function: 得到秒数对应的(小时:分钟:秒数)字符串形式(00:00:00)
function tf_FormatSecond(nSecond)
	local nSecond = nSecond or 0;
	local nHour = math.floor(nSecond / 3600)
	local nTemp = nSecond % 3600
	local nMin = math.floor(nTemp / 60)
	local nSec = nTemp % 60

	local szFormat = string.format("%02d:%02d:%02d", nHour, nMin, nSec)
	return szFormat;
end

--@function: 日期时间对应的字符串
function tf_FormatFileNameWithTime()
	local szFormat = os.date("%Y_%m_%d.log", os.time());
	return szFormat;
end

--@function: 获取两个时间点的时间差(tbTime2 - tbTime1)
--@tbTime:
--[[
	year = 2015, 	-- 表示年
	month = 12, 	-- 表示月
	day = 8,		-- 表示日期
	hour = 20,		-- 表示小时
	min = 46,		-- 表示分钟
	sec = 08,		-- 表示秒
	isdst = false,	-- 表示是否夏令时
]]
function tf_DiffWithTime(tbTime1, tbTime2)
	local tbTime1 = tbTime1 or {};
	local tbTime2 = tbTime2 or {};

	local nNow = os.time();
	local tbNow = os.date("*t", nNow);
	local tbTimeFull1 = {
		year = tbTime1.year or tbNow.year,
		month = tbTime1.month or tbNow.month,
		day = tbTime1.day or tbNow.day,
		hour = tbTime1.hour or tbNow.hour,
		min= tbTime1.min or tbNow.min,
		sec= tbTime1.sec or tbNow.sec,
		isdst = false
	}

	local tbTimeFull2 = {
		year = tbTime2.year or tbNow.year,
		month = tbTime2.month or tbNow.month,
		day = tbTime2.day or tbNow.day,
		hour = tbTime2.hour or tbNow.hour,
		min= tbTime2.min or tbNow.min,
		sec= tbTime2.sec or tbNow.sec,
		isdst = false
	}

	local nTime1 = os.time(tbTimeFull1);
	local nTime2 = os.time(tbTimeFull2);

	local nDiff = os.difftime(nTime2, nTime1);

	return nDiff;
end

--@function: 获取当前时间与当天指定时间点的倒计时字符串
function tf_FormatWithTime(nHour, nMin, nSec)
	local tbTime = {
		hour = nHour or 0,
		min= nMin or 0,
		sec= nSec or 0,
	}
	local nDiff = tf_DiffWithTime(nil, tbTime);
	return tf_FormatSecond(nDiff);
end
