----------------------------------------------------------
-- file:	class_base.lua
-- Author:	page
-- Time:	2015/01/23
-- Desc:	基类
--			(1)只实现了构造函数ctor, new功能
--			(2)只是c++概念上类的定义，所以不能调用自己的函数；同时使用类需要new一个对象来操作
--			(3)一般使用步骤：base = class();test = class(base);obj = test.new();--useage
----------------------------------------------------------
--[[
function gf_CopyTable(tbOrg)
    local tbSaveExitTable = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object;
        elseif tbSaveExitTable[object] then	--检查是否有循环嵌套的table
            return tbSaveExitTable[object];
        end
        local tbNewTable = {};
        tbSaveExitTable[object] = tbNewTable;
        for index, value in pairs(object) do
            tbNewTable[_copy(index)] = _copy(value);	--要考虑用table作索引的情况
        end
        return setmetatable(tbNewTable, getmetatable(object));
    end
    return _copy(tbOrg);
end

_class_storate = {}

--创建类定义的函数
function _class(super, arg, classname)
	local test_base_type_def = {}
	--ctor == false和nil相差这么大？大概是重载了__newindex函数
	test_base_type_def.ctor = false;
	test_base_type_def.super = super
	test_base_type_def.name = classname
	
	--！！！注意：一定是要type.new()用法
	test_base_type_def.new = function(...)
		local tbNew = {}
		--下面的块只做了一件事：就是把类定义从父类到当前子类的所有ctor一一调用一遍
		do
			local create
			create = function(c, ...)
				if c.super then
					create(c.super, ...)
				end
				
				if c.ctor then
					c.ctor(tbNew, ...)
				end
			end
			create(test_base_type_def, ...)
			
			if type(arg) == "table" then
				local tbTemp = gf_CopyTable(arg) or {}
				for k, v in pairs(tbTemp) do
					test_base_type_def[k] = v;
				end
			end
		end
		setmetatable(tbNew, {__index = _class_storate[test_base_type_def]})
		return tbNew;
	end
	
	--防止定义类调用函数
	local vtbl = {}
	
	_class_storate[test_base_type_def] = vtbl;
	
	setmetatable(test_base_type_def, {__newindex = 
		function(t, k, v)
			vtbl[k] = v;
		end
	})
	
	--new出来的对象一开始是没有vbtl的，只有新加成员的时候才有
	--new出来的对象也是可以添加自己新成员变量和函数的
	--同时还可以调用new他出来的定义类的函数，就是c++中对象调用类函数
	if super then
		setmetatable(vtbl, {__index = 
			function(t, k)
				local ret = _class_storate[super][k]
				vtbl[k] = ret;
				return ret;
			end
		})
	end
	
	return test_base_type_def
end
]]


function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--Create an class.
function class(classname, super, args)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1
		--自定义成员变量
		cls.__args = args;

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
			-- 复制传进来的参数，覆盖父类对象, 影响父类的ctor函数(eg:bUpdate)
			if type(args) == "table" then
				for k, v in pairs(clone(args)) do
					instance[k] = v;
				end
			end
			
            instance.class = cls
			
			local __create
			__create = function(c, ...)
				if c.super then
					__create(c.super, ...)
				end
				
				-- if type(c.__args) == "table" then
					-- for k, v in pairs(clone(c.__args)) do
						-- instance[k] = v;
					-- end
				-- end

				if c.ctor then
					c.ctor(instance, ...)
				end
			end

			__create(instance, ... )
			
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls
		--自定义成员变量
		cls.__args = args;

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls

			local __create
			__create = function(c, ...)
				if c.super then
					__create(c.super, ...)
				end

				if type(c.__args) == "table" then
					for k, v in pairs(clone(c.__args)) do
						instance[k] = v;
					end
				end
					
				if c.ctor then
					c.ctor(instance, ...)
				end
			end

			__create(instance, ...)
            return instance
        end
    end
			
    return cls
end





CLASS_BASE_TYPE = class();

function CLASS_BASE_TYPE:GetClassName()
	return self.__cname;
end
-------------------------------------------------------------------
-- *usage*
-- 1. new_type = class(CLASS_BASE_TYPE)
-- 2. define new_type function;eg: function new_type:print_test() end
-- 3. define function new_type:init() --construct new member end
-- 4. obj = new_type:new()
-- 5. obj:init();
-- eg:
-- KG_UIFight = class(CLASS_BASE_TYPE)
-- function KG_UIFight:init(tbArg) 
	-- self.nState = tbArg.nState or 0;
	-- self.tbData = tbArg.tbData or {};
-- end
-- g_uiFight = KG_UIFight:new()
-- g_uiFight:init();
-------------------------------------------------------------------
