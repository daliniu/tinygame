var Luanode = require('../../cmodule/luanode.node');
var utils = require('../utils');

var lua = new Luanode.LuaState('luanode');

// lua.doFile('luamodule/init.lua');

lua.setGlobal('_SERVER', 1);	// 设置服务器标记

module.exports = lua;

// lua.setGlobal('key', 123)
// lua.getGlobal('key') = 123
// lua.close()          = 0/errcode/yield
// lua.getName()        = luanode
// lua.push(123)
// lua.pop()
// lua.getTop()         = topvalue
// lua.setTop(10)
// lua.replace(-2)
// lua.status()         = 0/errcode/yield
// lua.collectGarbage(Luanode.GC.STOP)
// lua.doFile('luamodule/init.lua')       = {}
// lua.doString('local a = 1; print(a);') = {}
// lua.call('char_getCharInfo', 1000)     = {}

// Luanode.INFO.VERSION
// Luanode.INFO.VERSION_NUM
// Luanode.INFO.COPYRIGHT
// Luanode.INFO.AUTHORS

// Luanode.STATUS.YIELD
// Luanode.STATUS.ERRRUN
// Luanode.STATUS.ERRSYNTAX
// Luanode.STATUS.ERRMEM
// Luanode.STATUS.ERRERR

// Luanode.GC.STOP
// Luanode.GC.RESTART
// Luanode.GC.COLLECT
// Luanode.GC.COUNT
// Luanode.GC.COUNTB
// Luanode.GC.STEP
// Luanode.GC.SETPAUSE
// Luanode.GC.SETSTEPMUL
