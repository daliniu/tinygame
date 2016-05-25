var crypto = require('crypto');
var util = require('util');
var Chance = require('chance');
var Const = require('./const');
var tiny = require('../tiny');

module.exports.invokeCallback = function(cb) {
	if (!!cb && (typeof cb === 'function')) {
		cb.apply(null, Array.prototype.slice.call(arguments, 1));
	}
};

module.exports.args = function(_args) {
	var args = [], i;
	for (i = 0; i < _args.length; ++i) {
		args.push(_args[i]);
	}
	return args;
};

var LimitMap = function(limit) {
	this.limit = limit || 10;
	this.map = {};
	this.keys = [];
};

LimitMap.prototype.set = function(key, value) {
	var map = this.map, keys = this.keys, firstKey;
	if (!map.hasOwnProperty(key)) {
		if (keys.length >= this.limit) {
			firstKey = keys.shift();
			delete map[firstKey];
		}
		keys.push(key);
	}
	map[key] = value;
};

LimitMap.prototype.get = function(key) {
	return this.map[key];
};

LimitMap.prototype.reset = function(limit) {
	this.limit = limit || 10;
	this.map = {};
	this.keys = [];
};

LimitMap.prototype.data = function() {
	return this.map;
};

module.exports.LimitMap = LimitMap;

var chance = new Chance();

// -9007199254740992 to 9007199254740992
module.exports.randomInt = function(min, max) {
	if (min > max) {
		tiny.log.error('randomInt', 'min can not be great than max', min, max);
		return 0;
	}
	return chance.integer({min: min, max: max});
};

module.exports.randomIntN = function(min, max, n) {
	if (min > max || Math.abs(max - min + 1) < n) {
		tiny.log.error('randomInt', 'min can not be great than max', min, max);
		return 0;
	}
	return chance.unique(chance.integer, n, {min: min, max: max});
};

module.exports.randomArray = function(array) {
	return array[module.exports.randomInt(0, array.length - 1)];
};

module.exports.randomArrayN = function(_array, n) {
	if (_array.length <= n) {
		return _array.concat();
	}
	return chance.pick(_array, n);
};

module.exports.randomScope = function(index, scope) {
	return chance.weighted(index, scope);
};

module.exports.randomScopeEx = function(scope) {
	var i,
		sum = 0,
		ret = 0,
		temp = 0;
	for (i = 0; i < scope.length; ++i) {
		sum = sum + scope[i];
	}
	ret = module.exports.randomInt(1, sum);
	for (i = 0; i < scope.length; ++i) {
		temp = temp + scope[i];
		if (ret <= temp) {
			return i;
		}
	}
	return -1;
};

module.exports.randomArraySets = function(_arrays, n) {
	var i, j, sum = [], num = 0, result = [], tmp, nmax = 0;
	for (i = 0; i < _arrays.length; i++) {
		nmax = num + _arrays[i].length;
		sum.push([num, nmax]);
		num = nmax;
	}
	//console.log("1...", JSON.stringify(sum));
	if (sum.length !== 0 && num >= n) {
		tmp = module.exports.randomIntN(0, num - 1, n);
		//console.log("2...", JSON.stringify(tmp));
		for (i = 0; i < tmp.length; i++) {
			for (j = 0; j < sum.length; j++) {
				if (tmp[i] >= sum[j][0]
				&& tmp[i] < sum[j][1]) {
					result.push(_arrays[j][tmp[i] - sum[j][0]]);
					break;
				}
			}
		}
		return result;
	}
	for (i = 0; i < _arrays.length; i++) {
		result = result.concat(_arrays[i]);
	}
	return result;
};

module.exports.setSeed = function(seed) {
	if (seed) {
		chance = new Chance(seed);
	} else {
		chance = new Chance();
	}
};

module.exports.redisKeyGen = function(areaArg, uuidArg, nameArg) {
	var area = Const.REDIS_NAME[areaArg],
		uuid = Const.REDIS_NAME[uuidArg],
		name = Const.REDIS_NAME[nameArg];
	if (!area) {
		area = areaArg;
	}
	if (!uuid) {
		uuid = uuidArg;
	}
	if (!name) {
		name = nameArg;
	}
	return area + ':' + uuid + ':' + name;
};


module.exports.transCurrent = function(current) {
	var transCurrent = {};
	transCurrent.sessionId = current.sessionId;
	transCurrent.msgId = current.msgId;
	transCurrent.serverName = current.serverName;
	transCurrent.funcName = current.funcName;
	transCurrent.clientReuqest = current.clientRequest;
	transCurrent.rid = current.rid;
	return transCurrent;
};

module.exports.checkUuid = function(uuid) {
	if (uuid === undefined || uuid.length === 0) {
		return false;
	}
	return true;
};

module.exports.getObject = function(obj) {
	if (obj) {
		var a = JSON.parse(obj.toString());
		if (a !== undefined || a !== null) {
			return a;
		}
	}
	return obj;
};

module.exports.setObject = function(obj) {
	if (module.exports.isObject(obj) || module.exports.isArray(obj)) {
		return JSON.stringify(obj);
	}
	return obj.toString();
};

module.exports.bindImp = function(obj, imp) {
	var funcName;
	if (obj && imp) {
		for (funcName in imp) {
			if (imp.hasOwnProperty(funcName)) {
				obj[funcName] = imp[funcName];
			}
		}
	}
};

module.exports.checkValue = function(value) {
	var valueInt = parseInt(value, 10);
	if (isNaN(valueInt)) {
		return 0;
	}
	return valueInt;
};

module.exports.addAPValue = function(value) {
	if (value > Const.SUPPLY_AP_MAX) {
		return Const.SUPPLY_AP_MAX;
	}
	if (value < Const.SUPPLY_AP_MIN) {
		return Const.SUPPLY_AP_MIN;
	}
	return value;
};

module.exports.addValue = function(value) {
	if (value > Const.COMMON_VALUE_MAX) {
		return Const.COMMON_VALUE_MAX;
	}
	return value;
};

module.exports.jsonToArray = function(_json) {
	var A = [], i;
	for (i in _json) {
		if (_json.hasOwnProperty(i)) {
			A.push(_json[i]);
		}
	}
	return A;
};

module.exports.isObject = function(obj) {
	return Object.prototype.toString.call(obj) === '[object Object]';
};

module.exports.isNumber = function(obj) {
	return Object.prototype.toString.call(obj) === '[object Number]';
};

module.exports.isString = function(obj) {
	return Object.prototype.toString.call(obj) === '[object String]';
};

module.exports.isArray = function(obj) {
	return Object.prototype.toString.call(obj) === '[object Array]';
};

module.exports.getValueType = function(obj) {
	return Object.prototype.toString.call(obj);
};

module.exports.jsonIsEmpty = function(_json) {
	var i, isEmpty = true;
	for (i in _json) {
		if (_json.hasOwnProperty(i)) {
			isEmpty = false;
			break;
		}
	}
	return isEmpty;
};


module.exports.getDate = function() {
	return Date.now();
};

// 生成key
module.exports.userAreaKey = function(userArea) {
	return userArea.area + "|" + userArea.uuid;
};

module.exports.userAreaKey2 = function(area, uuid) {
	return area + "|" + uuid;
};
