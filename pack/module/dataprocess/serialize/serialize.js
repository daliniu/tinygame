var SerialProto = require('./serial_proto');
var tiny = require('../../../tiny');
var checkKey = function(object, key, name) {
	if (object === undefined) {
		throw new Error(key + ' is not in object ' + name);
	}
	if (!object.hasOwnProperty(key)) {
		throw new Error(key + ' is not in object ' + name);
	}
};

// 反序列化服务端对象
exports.unserialize = function(name, object) {
	var k, i, data, unserialObject = {};
	if (!SerialProto.hasOwnProperty(name)) {
		throw new Error(name + ' is undefined in unserialize proto');
	}
	data = SerialProto[name];
	for (i = 0; i < data.length; i++) {
		if (data[i].type === "string") {
			unserialObject[data[i].value] = object[i];
		} else if (data[i].type === "map") {
			if (data[i].type1 !== "map2") {
				if (data[i].type2 === "string") {
					unserialObject[data[i].value] = object[i];
				} else {
					unserialObject[data[i].value] = {};
					for (k in object[i]) {
						if (object[i].hasOwnProperty(k)) {
							unserialObject[data[i].value][k] = exports.unserialize(data[i].type2, object[i][k]);
						}
					}
				}
			} else {
				if (data[i].type2 === "string") {
					unserialObject = object;
				} else {
					unserialObject = {};
					for (k in object) {
						if (object.hasOwnProperty(k)) {
							unserialObject[k] = exports.unserialize(data[i].type2, object[k]);
						}
					}
				}
			}

		} else if (data[i].type === "vector") {
			if (data[i].type1 !== "vector2") {
				if (data[i].type2 === "string") {
					unserialObject[data[i].value] = object[i];
				} else {
					unserialObject[data[i].value] = [];
					for (k = 0; k < object[i].length; k++) {
						unserialObject[data[i].value].push(exports.unserialize(data[i].type2, object[i][k]));
					}
				}
			} else {
				if (data[i].type2 === "string") {
					unserialObject = object;
				} else {
					unserialObject = [];
					for (k = 0; k < object[i].length; k++) {
						unserialObject.push(exports.unserialize(data[i].type2, object[k]));
					}
				}
			}

		} else if (data[i].type === "struct") {
			unserialObject[data[i].value] = exports.unserialize(data[i].type1, object[i]);
		} else {
			throw new Error(name + ' is null in unserialize proto');
		}
	}
	// 返回反序列化对象
	return unserialObject;
};

// 序列化服务端对象
exports.serialize = function(name, object) {
	var k, i, data, serialObject = [];
	if (!SerialProto.hasOwnProperty(name)) {
		throw new Error(name + ' is undefined in serialize proto');
	}
	data = SerialProto[name];
	//console.log("..........", name, JSON.stringify(data));
	for (i = 0; i < data.length; i++) {
		// 判断
		if (data[i].type === "string") {
			// 检查字段是否存在
			checkKey(object, data[i].value, name);
			serialObject.push(object[data[i].value]);
		} else if (data[i].type === "map") {
			if (data[i].type1 !== "map2") {
				// 检查字段是否存在
				// checkKey(object, data[i].value, name);
				if (data[i].type2 === "string") {
					serialObject[i] = object[data[i].value];
				} else {
					serialObject[i] = {};
					if (object.hasOwnProperty(data[i].value)) {
						for (k in object[data[i].value]) {
							if (object[data[i].value].hasOwnProperty(k)) {
								serialObject[i][k] = exports.serialize(data[i].type2, object[data[i].value][k]);
							}
						}
					}
				}
			} else {
				if (data[i].type2 === "string") {
					serialObject = object;
				} else {
					serialObject = {};
					for (k in object) {
						if (object.hasOwnProperty(k)) {
							serialObject[k] = exports.serialize(data[i].type2, object[k]);
						}
					}
				}
			}

		} else if (data[i].type === "vector") {
			if (data[i].type1 !== "vector2") {
				// 检查字段是否存在
				// checkKey(object, data[i].value, name);
				if (data[i].type2 === "string") {
					serialObject[i] = object[data[i].value];
				} else {
					serialObject[i] = [];
					if (object.hasOwnProperty(data[i].value)) {
						for (k = 0; k < object[data[i].value].length; k++) {
							serialObject[i].push(exports.serialize(data[i].type2, object[data[i].value][k]));
						}
					}
				}
			} else {
				if (data[i].type2 === "string") {
					serialObject = object;
				} else {
					serialObject = [];
					for (k = 0; k < object.length; k++) {
						serialObject.push(exports.serialize(data[i].type2, object[k]));
					}
				}
			}

		} else if (data[i].type === "struct") {
			serialObject[i] = exports.serialize(data[i].type1, object[data[i].value]);
		} else {
			throw new Error(name + ' is null in serialize proto');
		}
	}
	// 返回序列化对象
	return serialObject;
};

/*
var heroInfo = {
	"curExp" : 100,
	"level" : 100,
	"quality" : 100,
	"skillList" : [
		"12313",
		"asfwqf",
		"sss222"
	],
	"sT" : [
		{
			"level" : 1001,
		},
		{
			"level" : 1002,
		},
		{
			"level" : 1003,
		},
	],
	"sM" : {
		"100001" : "aaa",
		"100002" : "bbb",
		"100005" : "ccc",
	},
	"skillSlotList" : {
		"100001" : {
			"level" : 2001,
		},
		"100002" : {
			"level" : "234234",
		},
		"100005" : {
			"level" : 2003,
		},
	},
};
	var ss = exports.serialize('HeroInfoT', heroInfo);
	var sss = exports.unserialize('HeroInfoT', ss);
	console.log('serial.......................', ss);
	console.log('unserial.......................', sss);
*/
