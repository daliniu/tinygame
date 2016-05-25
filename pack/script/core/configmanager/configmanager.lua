module("mconfig", package.seeall)
----------------------------------------------------------
-- file:	configmanager.lua
-- Author:	page
-- Time:	2015/12/25 19:24 
-- Desc:	配置表管理工具
----------------------------------------------------------

tbAllConfig = {}			-- 所有配置,key为文件名

--@function: 加载配置表
--@bNotMetatable：是否用元表的方式
function loadConfig(szFileName, bNotMetatable)
	if not tbAllConfig then
		tbAllConfig = {};
	end
	
	if szFileName then
		if not tbAllConfig[szFileName] then
			local tbTemp = require(szFileName);
			local tbConfig = {};
			-- 配置表的key都转成字符串统一
			for k, v in pairs(tbTemp) do
				tbConfig[tostring(k)] = v;
			end
			
			tbAllConfig[szFileName] = tbConfig;
		end
		
		local tbConfig = tbAllConfig[szFileName];
		local t = nil;
		if bNotMetatable then
			t = tbConfig;
		else
			t = {};
			local mt = {__index = function(table, key)
				if key then
					local key = tostring(key);
					return tbConfig[key];
				end
			end};
			
			setmetatable(t, mt);
		end
			
		return t;
	end
end
