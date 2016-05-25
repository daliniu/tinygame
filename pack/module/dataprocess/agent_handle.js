var playerHandle = require('./player_handle');
var equipHandle = require('./equip_handle');
var heroHandle = require('./hero_handle');
var afkHandle = require('./afk_handle');
var mapHandle = require('./map_handle');
var pvpHandle = require('./pvp_handle');
var util = require('util');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var ErrCode = Const.CLIENT_ERROR_CODE;
var DataCheck = require('./data_check');
var HandleGen = require('./handle_gen');

/*
dataKey
{
uuid : 1234,
area : 1,
bagList  : key,
baseInfo : key,
}

dataValue
{
bagList  : value,
baseInfo : value,
heroInfo : value,
}
getDataInfo(dataKey, callback)

*/

var getTeamHeroList = function(funcName, dataKey, dataValue, callback) {
	var heroIds;
	if (dataKey.rTeamHeroList(funcName) && dataValue.baseInfo) {
		tiny.log.debug("getTeamHeroList");
		// 转换上阵英雄列表
		heroIds = playerHandle.getHeroIdsFromPosList(dataValue.baseInfo.posList);
		// 取上阵英雄列表
		heroHandle.getTeamHeroList(dataKey.area, dataKey.uuid, heroIds, function(err, teamHeroList) {
			if (err) {
					callback(ErrCode.DATA_GET_TEAMHEROLIST_ERROR);
			} else {
				// 设置teamList数据position
				dataValue.teamHeroList = playerHandle.transPosListToTeamList(dataValue.baseInfo.posList, teamHeroList);
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

var setTeamHeroList = function(funcName, dataKey, dataValue, callback) {
	var heroInfoList = {}, i;
	if (dataKey.wTeamHeroList(funcName) && dataValue.teamHeroList) {
		tiny.log.debug("setTeamHeroList");
		for (i in dataValue.teamHeroList) {
			if (dataValue.teamHeroList.hasOwnProperty(i)) {
				dataValue.teamHeroList[i].pos = 0;
				heroInfoList[i] = utils.setObject(dataValue.teamHeroList[i]);
			}
		}
		heroHandle.setHeroInfoList(dataKey.area, dataKey.uuid, heroInfoList, function(err) {
			if (err) {
					callback(ErrCode.DATA_SET_TEAMHEROLIST_ERROR);
			} else {
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

var getPvpSng = function(funcName, dataKey, dataValue, callback) {
	if (dataKey.rPvpSng(funcName) && dataValue.baseInfo) {
		tiny.log.debug("getPvpSng");
		pvpHandle.getPvpSng(dataValue.baseInfo, function(err, pvpSng) {
			if (err) {
				callback(ErrCode.DATA_GET_PVPSNG_ERROR);
			} else {
				dataValue.pvpSng = pvpSng;
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

var setPvpSng = function(funcName, dataKey, dataValue, callback) {
	if (dataKey.wPvpSng(funcName) && dataValue.baseInfo) {
		tiny.log.debug("setPvpSng");
		pvpHandle.setPvpSng(dataValue.baseInfo, function(err) {
			if (err) {
				callback(ErrCode.DATA_SET_PVPSNG_ERROR);
			} else {
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

// get all
exports.getDataValue = function(funcName, dataKey, callback) {
	var dataValue = {}, readHandle = [];
	readHandle.push(function(cb) {
						cb(null, funcName, dataKey, dataValue);
					});
	// before
	readHandle = readHandle.concat(HandleGen.getReadFuncHandle());
	// after
	readHandle.push(function(funcName, dataKey, dataValue, cb) {
						getPvpSng(funcName, dataKey, dataValue, cb);
					});
	readHandle.push(function(funcName, dataKey, dataValue, cb) {
						getTeamHeroList(funcName, dataKey, dataValue, cb);
					});

	//tiny.log.debug("getDataValue", JSON.stringify(dataValue), JSON.stringify(readHandle), JSON.stringify(HandleGen.readFuncHandle));
	async.waterfall(readHandle, function(err) {
		if (err) {
			callback(err);
		} else {
			//tiny.log.debug("getDataValue", JSON.stringify(dataValue));
			callback(null, dataValue);
		}
	});
};

// set all
exports.setDataValue = function(funcName, dataKey, dataValue, callback) {
	var writeHandle = [];
	writeHandle.push(function(cb) {
						cb(null, funcName, dataKey, dataValue);
					});
	// before
	writeHandle = writeHandle.concat(HandleGen.getWriteFuncHandle());
	// after
	writeHandle.push(function(funcName, dataKey, dataValue, cb) {
						setPvpSng(funcName, dataKey, dataValue, cb);
					});
	writeHandle.push(function(funcName, dataKey, dataValue, cb) {
						setTeamHeroList(funcName, dataKey, dataValue, cb);
					});
	async.waterfall(writeHandle, function(err) {
		if (err) {
			callback(err);
		} else {
			//tiny.log.debug("setDataValue", JSON.stringify(dataValue));
			callback(null, dataValue);
		}
	});
};

var bindFunCallback = function(inArgs, onResponse, current) {
	var outArgs, dataKey, obj = this;

	// 检查DataCheck
	if (!DataCheck.isInit()) {
		tiny.log.debug("convertDataCheck");
		DataCheck.convertDataCheck();
	}

	// 检查HandleGen
	if (!HandleGen.isInit()) {
		tiny.log.debug("convertfuncHandle");
		HandleGen.convertfuncHandle();
	}

	// 验证配置表是否正确
	if (!DataCheck.isFunction(obj.objFunc)) {
		tiny.log.error("DataConfig error",obj.objFunc);
		onResponse(ErrCode.DATA_CONFIG_ERROR, current, inArgs, {});
		return;
	}

	async.waterfall([
		// 获取session
		function(callback) {
			// 判断是否需要取session
			if (DataCheck.isSession(obj.objFunc)) {
				tiny.log.debug("getSession", JSON.stringify(inArgs));
				tiny.redis.getSession(current.sessionId, function(err, session) {
					if (err) {
						dataKey = new DataCheck.DataKey(0, 0);
						callback(ErrCode.GET_SESSION_ERROR, err);
					} else {
						dataKey = new DataCheck.DataKey(session.area, session.uuid);
						inArgs.uuid = session.uuid;
						inArgs.area = session.area;
						dataKey = DataCheck.getSingleKey(inArgs, dataKey, obj.objFunc);
						callback(null);
					}
				});
			} else {
				dataKey = new DataCheck.DataKey();
				callback(null);
			}
		},
		// 取数据
		function(callback) {
			tiny.log.debug("get");
			exports.getDataValue(obj.objFunc, dataKey, function(errCode, dataValue) {
				if (errCode) {
					tiny.log.error(obj.objFunc, "getDataValue", errCode);
					callback(errCode);
				} else {
					callback(null, dataValue);
				}
			});
		},
		// 业务逻辑
		function(dataValue, callback) {
			tiny.log.debug("do");
			dataValue.area = inArgs.area;
			dataValue.uuid = inArgs.uuid;
			outArgs = obj.objImp[obj.objFunc](dataValue, inArgs, dataKey);
			if (!outArgs.retCode) {
				outArgs.retCode = ErrCode.SUCCESS;
			}
			if (outArgs.retCode === ErrCode.SUCCESS || outArgs.retCode > ErrCode.RETCODE_NEED_UNPACK) {
				//tiny.log.debug("logic", JSON.stringify(outArgs));
				callback(null, dataValue);
			} else {
				callback(outArgs.retCode);
			}
		},
		// 保存数据
		function(dataValue, callback) {
			tiny.log.debug("set");
			exports.setDataValue(obj.objFunc, dataKey, dataValue, function(errCode) {
				if (errCode) {
					tiny.log.error(obj.objFunc, "setDataValue", errCode);
					callback(errCode);
				} else {
					callback(null);
				}
			});
		},
	], function(errCode) {
		if (errCode) {
			tiny.log.error(obj.objFunc, dataKey.uuid, dataKey.area, errCode);
			outArgs = {};
			outArgs.retCode = errCode;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			if (!outArgs.retCode) {
				outArgs.retCode = ErrCode.SUCCESS;
			}
			onResponse(outArgs.retCode, current, inArgs, outArgs);
		}
	});
};

exports.bindImp = function(obj, imp) {
	var funcName;
	if (obj && imp) {
		for (funcName in imp) {
			if (imp.hasOwnProperty(funcName)) {
				obj[funcName] = bindFunCallback.bind({objImp : imp, objFunc : funcName});
			}
		}
	}
};
