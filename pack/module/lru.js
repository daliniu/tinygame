/*
var data  = {
	keys : [],
	map : {},
};
*/
var Const = require("./const");
var utils = require("./utils");

Array.prototype.indexOf = function(val) {
	var i;
	for (i = 0; i < this.length; i++) {
		if (this[i] === val) {
			return i;
		}
 	}
	return -1;
};

Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};

var aIndexOf = function(val, array) {
	var i;
	for (i = 0; i < array.length; i++) {
		if (array[i].uuid === val.uuid
			&& array[i].area === val.area) {
			return i;
		}
 	}
	return -1;
};

var aRemove = function(val, array) {
	var index = aIndexOf(val, array);
	if (index > -1) {
		array.splice(index, 1);
	} else {
		return -1;
	}
};

module.exports.aRemove = aRemove;
// 不在map则设置最高活跃度
// 在但未满，设置最高活跃度
// 在但满了，从最低活跃级别删除一个
/*
module.exports.lruSet = function(key, value, data) {
	var map = data.map, keys = data.keys, firstKey;
	if (!map.hasOwnProperty(key)) {
		if (keys.length >= Const.LRU_MAP_LIMIT) {
			firstKey = keys.shift();
			delete map[firstKey];
		}
	} else {
		keys.remove(key);
	}
	keys.push(key);
	map[key] = value;
};

module.exports.lruGet = function(key, data) {
	if (data.map.hasOwnProperty(key)) {
		data.keys.remove(key);
		data.keys.push(key);
		return data.map[key];
	}
	return undefined;
};

module.exports.lruCreate = function(id) {
	var data  = {
		"id" : id,
		"keys" : [],
		"map" : {},
	};
	return data;
};
*/
module.exports.lruSet = function(key, data) {
	aRemove(key, data.keys);
	data.keys.push(key);
	if (data.keys.length > Const.LRU_MAP_LIMIT) {
		data.keys.shift();
	}
	return key;
};

module.exports.lruRemove = function(key, data) {
	aRemove(key, data.keys);
};

module.exports.lruGet = function(key, data) {
	if (aRemove(key, data.keys) < 0) {
		return undefined;
	}
	data.keys.push(key);
	return key;
};

module.exports.lruCreate = function(id) {
	var data  = {
		"id" : id,
		"keys" : [],
	};
	return data;
};

/*

var data = module.exports.lruCreate(1);

module.exports.lruSet({area : "1", uuid : "a"}, data);   console.log("s 1", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "b"}, data);   console.log("s 1", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "c"}, data);   console.log("s 1", JSON.stringify(data));
console.log(module.exports.lruGet({area : "1", uuid : "b"}, data), "g 2", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "d"}, data);   console.log("s 1", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "e"}, data);   console.log("s 1", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "f"}, data);   console.log("s 1", JSON.stringify(data));
console.log(module.exports.lruGet({area : "1", uuid : "d"}, data), "g 2", JSON.stringify(data));
module.exports.lruSet({area : "1", uuid : "g"}, data);   console.log("s 1", JSON.stringify(data));

var data = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];
console.log("random", utils.randomArrayN(data, 3), data);
console.log("random", utils.randomArrayN(data, 5), data);
console.log("random", utils.randomArrayN(data, 9), data);
console.log("random", utils.randomArrayN(data, 1), data);
console.log("random", utils.randomArrayN(data, 21), data);
console.log("random", utils.randomArrayN([], 21), data);

var a = "abcde"

console.log("b", a.substring(2));
*/
