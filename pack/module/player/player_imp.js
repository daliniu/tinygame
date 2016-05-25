var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var playerHandle = require('../dataprocess/player_handle');
var async = require('async');
var utils = require('../utils');
var async = require('async');

function jsonToArray(_json) {
	var A = [], i;
	for (i in _json) {
		if (_json.hasOwnProperty(i)) {
			A.push(_json[i]);
		}
	}
	return A;
}

// 载入玩家信息
var loadPlayerInfo = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;

	// 检查uuid合法性
	if (!utils.checkUuid(uuid)) {
		tiny.log.error("|loadPlayerInfo|check uuid fail!");
		outArgs = {};
		outArgs.uuid = uuid;
		outArgs.loginState = Const.LOGIN_OFF;
		retCode = ErrCode.NEVER_CREATE_PLAYER;
		onResponse(retCode, current, inArgs, outArgs);
		return;
	}

	outArgs = {};
	outArgs.uuid = uuid;
	outArgs.loginState = Const.LOGIN_ON;
	async.waterfall([
		// 获取玩家信息
		function(callback) {
			playerHandle.getPlayerInfo(area, uuid, function(err, playerInfo) {
				if (err) {
					tiny.log.error("getPlayerInfo", err);
					callback(ErrCode.NEVER_CREATE_PLAYER, err);
				} else {
					callback(null, playerInfo);
				}
			});
		},
		// 注册名字对应uuid到名字池
		function(playerInfo, callback) {
			tiny.redis.setNameUUIDPair(area+'|'+uuid, uuid, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, playerInfo);
				}
			});
		},
		// 创建玩家信息
		function(playerInfo, callback) {
			if (!playerInfo) {
				playerHandle.createPlayerInfo(area, uuid, uuid, function(err, playerInfo) {
					if (err) {
						tiny.log.error("createPlayerInfo", err);
						callback(ErrCode.CREATE_PLAYER_FAILURE, err);
					} else {
						callback(null, null, playerInfo);
					}
				});
			} else {
				callback(null, null, playerInfo);
			}
		}
	],  function(errCode, errStr, playerInfo) {
		if (errCode) {
			tiny.log.error("loadPlayerInfo", errCode, errStr);
			outArgs.loginState = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.playerInfo = playerInfo;
			outArgs.loginState = Const.LOGIN_ON;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});

	//返回
	return ErrCode.SUCCESS;
};

// 载入玩家信息
var loadPlayerInfo = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;

	// 检查uuid合法性
	if (!utils.checkUuid(uuid)) {
		tiny.log.error("|loadPlayerInfo|check uuid fail!");
		outArgs = {};
		outArgs.uuid = uuid;
		outArgs.loginState = Const.LOGIN_OFF;
		retCode = ErrCode.NEVER_CREATE_PLAYER;
		onResponse(retCode, current, inArgs, outArgs);
		return;
	}

	outArgs = {};
	outArgs.uuid = uuid;
	outArgs.loginState = Const.LOGIN_ON;
	async.waterfall([
		// 获取玩家信息
		function(callback) {
			playerHandle.getPlayerInfo(area, uuid, function(err, playerInfo) {
				if (err) {
					tiny.log.error("getPlayerInfo", err);
					callback(ErrCode.NEVER_CREATE_PLAYER, err);
				} else {
					callback(null, playerInfo);
				}
			});
		},
		// 注册名字对应uuid到名字池
		function(playerInfo, callback) {
			tiny.redis.setNameUUIDPair(area+'|'+uuid, uuid, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, playerInfo);
				}
			});
		},
		// 创建玩家信息
		function(playerInfo, callback) {
			if (!playerInfo) {
				playerHandle.createPlayerInfo(area, uuid, uuid, function(err, playerInfo) {
					if (err) {
						tiny.log.error("createPlayerInfo", err);
						callback(ErrCode.CREATE_PLAYER_FAILURE, err);
					} else {
						callback(null, null, playerInfo);
					}
				});
			} else {
				callback(null, null, playerInfo);
			}
		}
	],  function(errCode, errStr, playerInfo) {
		if (errCode) {
			tiny.log.error("loadPlayerInfo", errCode, errStr);
			outArgs.loginState = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.playerInfo = playerInfo;
			outArgs.loginState = Const.LOGIN_ON;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});

	//返回
	return ErrCode.SUCCESS;
};

// 默认创建玩家信息
var createPlayerInfo = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area, userName;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;
	userName = inArgs.userName;

	// 处理逻辑
	tiny.log.debug("|createPlayerInfo|uuid:" + uuid + "|" + area);

	outArgs = {};
	outArgs.uuid = uuid;
	outArgs.loginState = Const.LOGIN_ON;

	// 创建玩家信息
	playerHandle.createPlayerInfo(area, uuid, userName, function(err, data) {
		if (err) {
			// 设置数据失败
			tiny.log.error("|createPlayerInfo|uuid:" + uuid + "|" + area + "|" + err);
			retCode = ErrCode.CREATE_PLAYER_FAILURE;
		} else {
			// 设置数据成功
			outArgs.playerInfo = data;
			retCode = ErrCode.SUCCESS;
		}
		onResponse(retCode, current, inArgs, outArgs);
	});

	//返回
	return ErrCode.SUCCESS;
};

module.exports = {
"loadPlayerInfo" : loadPlayerInfo,
"createPlayerInfo" : createPlayerInfo,
};
