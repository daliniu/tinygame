var tiny = require('../../tiny');
var Luanode = require('../../cmodule/luanode.node');
var utils = require('../utils');
var Chanllenge = require('../config/exploration/monsterchal');
var lua = require('../lua/lua');

// 战斗模块
exports.fightEnemy = function(monsterid, playerInfo, callback) {
	var result,
		playerRateHP = 0,
		seed;

	if (monsterid === undefined) {
		callback("don't match monsterid " + monsterid);
		return;
	}

	seed = utils.randomInt(1, 90071992);

	result = 2;
	tiny.log.trace('monsterid = ', monsterid);
	try {
		lua.setGlobal('_SEED', seed);
		lua.setGlobal('_INFO1', playerInfo);
		lua.setGlobal('_INFO2', monsterid);
		lua.doFile('script/core/minifight/svrfight.lua');

		result = lua.getGlobal('RESULT');
		playerRateHP = lua.getGlobal('HPRATE');
		tiny.log.trace("fightEnemy = ", monsterid, result, seed, playerRateHP);

		callback(null, result, seed);
	} catch (err) {
		tiny.log.debug(err.stack);
		callback(err.stack);
	}
};

// pvp战斗
exports.fightPvp = function(playerInfo1, playerInfo2, callback) {
	var result = 2, seed;

	seed = utils.randomInt(1, 90071992);

	try {
		lua.setGlobal('_PVP', 1);
		lua.setGlobal('_SEED', seed);
		lua.setGlobal('_INFO1', playerInfo1);
		lua.setGlobal('_INFO2', playerInfo2);
		lua.doFile('script/core/minifight/svrfight.lua');

		result = lua.getGlobal('RESULT');
		tiny.log.trace("fightPvp = ", result, seed);

		callback(null, result, seed);
	} catch (err) {
		tiny.log.debug(err.stack);
		callback(err.stack);
	}
};
