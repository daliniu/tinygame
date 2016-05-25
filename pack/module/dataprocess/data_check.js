var utils = require('../utils');
var tiny = require('../../tiny');

var convertDataConfig = function(_data) {
	var i, dataConfig = {};
	for (i in _data) {
		if (_data.hasOwnProperty(i)) {
			dataConfig[_data[i].funcName] = _data[i];
			delete dataConfig[_data[i].funcName].id;
		}
	}
	return dataConfig;
};

var _init = false;

var DataConfig;
var DataKey = function(_area, _uuid) {
	this.area = _area;
	this.uuid = _uuid;
};

var bindReadFunc = function(funcName) {
	var func = this;
	return DataConfig[funcName]["is" +func] && DataConfig[funcName]["is" +func][1];
};

var bindWriteFunc = function(funcName) {
	var func = this;
	return DataConfig[funcName]["is" +func] && DataConfig[funcName]["is" +func][2];
};

var bindSpFunc = function(dataValue) {
	var spStr = this, strs = [], ret, i;
	strs = spStr.split(".");
	if (strs.length === 0) {
		return undefined;
	}
	ret = dataValue;
	for (i = 0; i < strs.length; i++) {
		if (ret.hasOwnProperty(strs[i])) {
			ret = ret[strs[i]];
		}
	}
	tiny.log.debug("bindSpFunc", spStr, JSON.stringify(strs), JSON.stringify(ret), ret);
	return ret;
};

var convertDataCheck = function() {
	var j, func;
	DataConfig = convertDataConfig(require('../config/DataConfig'));
	if (DataConfig.hasOwnProperty("setting")) {
		for (j in DataConfig.setting) {
			if (DataConfig.setting.hasOwnProperty(j)) {
				if (j !== "isSession"
					&& j !== "funcName") {
					func = j.substring(2);
					console.log("func", j, func);
					// 生成函数
					DataKey.prototype["r" + func] = bindReadFunc.bind(func);
					DataKey.prototype["w" + func] = bindWriteFunc.bind(func);
				}
			}
		}
	}
	_init = true;
};

// 检查是否有session
exports.isSession = function(funcName) {
	return DataConfig[funcName].isSession;
};

// 检查是否合法函数
exports.isFunction = function(func) {
	return DataConfig.hasOwnProperty(func);
};

// 设置前端获取到的key值
exports.getSingleKey = function(inArgs, dataKey, func) {
	var i, config = DataConfig.setting;
	for (i in config) {
		if (config.hasOwnProperty(i)) {
			if (utils.isObject(config[i])) {
				if (config[i][3] && inArgs[config[i][3]]) {
					tiny.log.debug("getSingleKey", config[i][3]);
					dataKey[config[i][3]] = inArgs[config[i][3]];
				}
				if (DataConfig[func] && DataConfig[func][i] && DataConfig[func][i][3]) {
					if (!DataKey.prototype["sp" + func]) {
						tiny.log.debug("getSingleKey sp", DataConfig[func][i][3], func);
						DataKey.prototype["sp" + func] = bindSpFunc.bind(DataConfig[func][i][3]);
					}
				}
			}
		}
	}
	return dataKey;
};

exports.isInit = function() {
	return _init;
};

exports.getDataConfig = function(){
	return DataConfig;
};

exports.DataKey = DataKey;
exports.convertDataCheck = convertDataCheck;
