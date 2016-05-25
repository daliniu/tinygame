#!/usr/bin/lua

function gf_CopyTable(tbOrg)
    local tbSaveExitTable = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object;
        elseif tbSaveExitTable[object] then --检查是否有循环嵌套的table
            return tbSaveExitTable[object];
        end
        local tbNewTable = {};
        tbSaveExitTable[object] = tbNewTable;
        for index, value in pairs(object) do
            tbNewTable[_copy(index)] = _copy(value);    --要考虑用table作索引的情况
        end
        return setmetatable(tbNewTable, getmetatable(object));
    end
    return _copy(tbOrg);
end

function formJson(file, lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix..k.." : "..szSuffix
        if type(v) == "table" then
            file:write(formatting.."\n")
            formJson(file, v, indent + 1)
            file:write(szPrefix.."},".."\n")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            file:write(formatting..szValue..",".."\n")
        end
    end
end

function generatefile(filename, tbProto, dir)
    local prefix, suffix
    prefix = "/*\n" .. "Don\'t modify this file manually!\n" .. "*/\n" .. "var _p = {\n"
    suffix = "\n};\n" .. "module.exports = _p;\n"

    print('generatefile = ', dir, filename)

    local luaFile = io.open(dir .. '/' .. filename .. '.js', 'w')
    luaFile:write(prefix)
    formJson(luaFile, tbProto, 1)
    luaFile:write(suffix)
    luaFile:close()
end

local lfs = require('lfs')

function walkPath(path, dest)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." and file ~= '.svn' then
            local f = path .. '/' .. file
            if f ~= 'temp/cfg/client' then
                local attr = lfs.attributes(f)
                if attr.mode == 'file' then
                    local name, type = string.match(file, '(%a*).(%a*)')
                    if type == 'lua' then
                        local t = require(path .. '/' .. name)
                        generatefile(name, t, dest)
                    end
                else
                    lfs.mkdir(dest .. '/' .. file)
                    walkPath(f, dest .. '/' .. file)
                end
            end
        end
    end
end

walkPath('temp/cfg', 'temp/js')
