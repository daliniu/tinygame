
var DataCheck = require("./data_check");
var tiny = require('../../tiny');
var utils = require('../utils');
var ErrCode = require('../const').CLIENT_ERROR_CODE;
var Const = require('../const');
var DataConfig;
var readFuncHandle;
var writeFuncHandle;
var _init = false;

// 玩家个人key
var genKeyPersonal = function(dataName, dataKey) {
	var key = dataName.toLowerCase();
	return utils.redisKeyGen(dataKey.area, dataKey.uuid, key);
};

// 区服key
var genKeyArea = function(dataName, dataKey) {
	var key = dataName.toLowerCase();
	return utils.redisKeyGen(dataKey.area, key, "area");
};

// 全局key
var genKeyGlobal = function(dataName) {
	var key = dataName.toLowerCase();
	return utils.redisKeyGen("all", key, "global");
};

// hset
var bindWriteFuncHandleHset = function(funcName, dataKey, dataValue, callback) {
	var dataName = this.dataName,
	    key = this.key,
	    valueName = this.valueName,
	    errCode = this.errCode,
	    genKey = this.genKey,
	    thisKey = genKey(this.dbKey, dataKey);
	//tiny.log.debug("...", dataName, funcName);
	if (dataKey["w" + dataName](funcName) && dataValue[valueName]) {
		tiny.log.debug("set" + dataName);
		//tiny.log.debug("bindWriteFuncHandleHset", dataName, valueName, thisKey, errCode);
		tiny.redis.hset(thisKey, dataKey[key], utils.setObject(dataValue[valueName]), function(err) {
			if (err) {
				callback(errCode);
			} else {
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

// set
var bindWriteFuncHandleSet = function(funcName, dataKey, dataValue, callback) {
	var dataName = this.dataName,
	    valueName = this.valueName,
	    errCode = this.errCode,
	    genKey = this.genKey,
	    thisKey = genKey(this.dbKey, dataKey);
	//tiny.log.debug("...", dataName, funcName);
	if (dataKey["w" + dataName](funcName) && dataValue[valueName]) {
		tiny.log.debug("set" + dataName);
		//tiny.log.debug("bindWriteFuncHandleSet", dataName, valueName, thisKey, errCode);
		tiny.redis.set(thisKey, dataValue[valueName], function(err) {
			if (err) {
				callback(errCode);
			} else {
				callback(null, funcName, dataKey, dataValue);
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

// get
var bindReadFuncHandleGet = function(funcName, dataKey, dataValue, callback) {
	var dataName = this.dataName,
	    valueName = this.valueName,
	    errCode = this.errCode,
	    genKey = this.genKey,
	    thisKey = genKey(this.dbKey, dataKey);
	//tiny.log.debug("...", dataName, funcName);
	if (dataKey["r" + dataName](funcName)) {
		tiny.log.debug("get" + dataName);
		//tiny.log.debug("bindReadFuncHandleGet", dataName, valueName, thisKey, errCode);
		tiny.redis.get(thisKey, function(err, readData) {
			if (err) {
				callback(errCode);
			} else {
				if (readData) {
					dataValue[valueName] = readData;
					callback(null, funcName, dataKey, dataValue);
				} else {
					callback(errCode);
				}
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

// hget
var bindReadFuncHandleHget = function(funcName, dataKey, dataValue, callback) {
	var dataName = this.dataName,
	    valueName = this.valueName,
	    errCode = this.errCode,
	    genKey = this.genKey,
	    key = this.key,
	    thisKey = genKey(this.dbKey, dataKey);
	//tiny.log.debug("...", dataName, funcName);
	if (dataKey["r" + dataName](funcName)) {
		tiny.log.debug("get" + dataName);
		if (this.default !== undefined) {
			dataKey[key] = this.default;
		}
		if (!dataKey[key] && dataKey["sp" + funcName]) {
			tiny.log.debug("sp" + funcName, key, dataKey[key]);
			dataKey[key] = dataKey["sp" + funcName](dataValue);
		}
		tiny.log.debug("bindReadFuncHandleHget", dataName, valueName, thisKey, key, dataKey[key], errCode);
		tiny.redis.hget(thisKey, dataKey[key], function(err, readData) {
			if (err) {
				callback(errCode);
			} else {
				if (readData) {
					dataValue[valueName] = utils.getObject(readData);
					callback(null, funcName, dataKey, dataValue);
				} else {
					callback(null, funcName, dataKey, dataValue);
				}
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};


// hall
var bindReadFuncHandleHall = function(funcName, dataKey, dataValue, callback) {
	var dataName = this.dataName,
	    valueName = this.valueName,
	    errCode = this.errCode,
	    genKey = this.genKey,
	    thisKey = genKey(this.dbKey, dataKey);
	//tiny.log.debug("...", dataName, funcName);
	if (dataKey["r" + dataName](funcName)) {
		tiny.log.debug("get" + dataName);
		//tiny.log.debug("bindReadFuncHandleHall", dataName, valueName, thisKey, errCode);
		tiny.redis.hgetall(thisKey, function(err, readData) {
			var i;
			if (err) {
				callback(errCode);
			} else {
				if (readData) {
					dataValue[valueName] = {};
					for (i in readData) {
						if (readData.hasOwnProperty(i)) {
							dataValue[valueName][i] = utils.getObject(readData[i]);
						}
					}
					callback(null, funcName, dataKey, dataValue);
				} else {
					callback(errCode);
				}
			}
		});
	} else {
		callback(null, funcName, dataKey, dataValue);
	}
};

var dealWithPersonalSet = function(dataName, genKey, sign, dataConfig) {
	var data = {}, errKey;
	data.dataName = dataName;
	data.valueName = dataName.substring(0, 1).toLowerCase() + dataName.substring(1);
	data.genKey = genKey;
	if (dataConfig && dataConfig[2]) {
		data.dbKey = dataConfig[2];
	}
	if (sign === "GET") {
		errKey = "DATA_GET_" + dataName.toUpperCase() + "_ERROR";
		data.errCode = ErrCode[errKey];
		if (dataConfig && dataConfig[3]) {
			tiny.log.debug("bindReadFuncHandleHget", data.dataName, data.valueName, errKey, data.dbKey, dataConfig[3]);
			data.key = dataConfig[3];
			data.default = dataConfig[4];
			readFuncHandle.push(function (funcName, dataKey, dataValue, cb) {
									bindReadFuncHandleHget.bind(data)(funcName, dataKey, dataValue, cb);
								});
		} else {
			tiny.log.debug("bindReadFuncHandleGet", data.dataName, data.valueName, errKey, data.dbKey);
			//readFuncHandle.push(function (funcName, dataKey, dataValue, cb) {
			readFuncHandle.splice(0, 0, function (funcName, dataKey, dataValue, cb) {
									bindReadFuncHandleGet.bind(data)(funcName, dataKey, dataValue, cb);
								});
		}
	} else if (sign === "SET") {
		errKey = "DATA_SET_" + dataName.toUpperCase() + "_ERROR";
		data.errCode = ErrCode[errKey];
		if (dataConfig && dataConfig[3]) {
			tiny.log.debug("bindWriteFuncHandleHset", data.dataName, data.valueName, errKey, data.dbKey, dataConfig[3]);
			data.key = dataConfig[3];
			writeFuncHandle.push(function (funcName, dataKey, dataValue, cb) {
									bindWriteFuncHandleHset.bind(data)(funcName, dataKey, dataValue, cb);
								});
		} else {
			tiny.log.debug("bindWriteFuncHandleSet", data.dataName, data.valueName, errKey, data.dbKey);
			writeFuncHandle.splice(0, 0, function (funcName, dataKey, dataValue, cb) {
			//writeFuncHandle.push(function (funcName, dataKey, dataValue, cb) {
									bindWriteFuncHandleSet.bind(data)(funcName, dataKey, dataValue, cb);
								});
		}
	} else if (sign === "HALL") {
		errKey = "DATA_GET_" + dataName.toUpperCase() + "_ERROR";
		data.errCode = ErrCode[errKey];
		tiny.log.debug("bindReadFuncHandleHall", data.dataName, data.valueName, errKey, data.dbKey);
		readFuncHandle.push(function (funcName, dataKey, dataValue, cb) {
								bindReadFuncHandleHall.bind(data)(funcName, dataKey, dataValue, cb);
							});
	} else {
		tiny.log.error("dealWithPersonalSet error sing");
	}
};

var convertfuncHandle = function() {
	var i, dataName;
	readFuncHandle = [];
	writeFuncHandle = [];
	if (!DataCheck.isInit()) {
		tiny.log.debug("convertDataCheck");
		DataCheck.convertDataCheck();
	}
	DataConfig = DataCheck.getDataConfig();
	if (DataConfig.hasOwnProperty("setting")) {
		for (i in DataConfig.setting) {
			if (DataConfig.setting.hasOwnProperty(i)) {
				if (i !== "isSession"
					&& i !== "funcName") {
					dataName = i.substring(2);
					tiny.log.debug("dataName", i, dataName, DataConfig.setting[i][1]);
					switch(DataConfig.setting[i][1]) {
						case "nan":
						case "writeYourself":
							break;
						case "personal":
						case "hashPersonal":
							dealWithPersonalSet(dataName, genKeyPersonal, "GET", DataConfig.setting[i]);
							dealWithPersonalSet(dataName, genKeyPersonal, "SET", DataConfig.setting[i]);
							break;
						case "hashAllPersonal":
							dealWithPersonalSet(dataName, genKeyPersonal, "HALL", DataConfig.setting[i]);
							break;
						case "area":
							dealWithPersonalSet(dataName, genKeyArea, "GET", DataConfig.setting[i]);
							dealWithPersonalSet(dataName, genKeyArea, "SET", DataConfig.setting[i]);
							break;
						case "global":
							dealWithPersonalSet(dataName, genKeyGlobal, "GET", DataConfig.setting[i]);
							dealWithPersonalSet(dataName, genKeyGlobal, "SET", DataConfig.setting[i]);
							break;
						default:
							tiny.log.debug("convertfuncHandle don't match", DataConfig.setting[i][1], dataName);
							break;
					}
				}
			}
		}
	}
	_init = true;
};

exports.isInit = function() {
	return _init;
};

exports.getReadFuncHandle = function() {
	return readFuncHandle;
};

exports.getWriteFuncHandle = function() {
	return writeFuncHandle;
};

exports.convertfuncHandle = convertfuncHandle;
