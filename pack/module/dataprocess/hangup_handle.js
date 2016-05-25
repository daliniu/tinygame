var util = require('util');
var EventEmitter = require('events').EventEmitter;
var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var Afkreward = require('../config/map/afkreward');
var playerHandle = require('./player_handle');
var bag = require('../bag/bag');

// var convertItemBox = function(box) {
// 	var i;
// 	for (i in box) {
// 		if (box.hasOwnProperty(i)) {
// 			box[i].itemid = utils.jsonToArray(box[i].itemid);
// 		}
// 	}
// 	//tiny.log.error('box..................', JSON.stringify(box));
// 	return box;
// };
// var Itembox = convertItemBox(require('../config/pick/itembox'));
/*
//挂机信息
HangUpInfo
{
	地图ID
	挂机点ID
	开始时间
}
*/

// 创建挂机信息
// exports.createHangUpInfo = function(area, uuid, callback) {
// 	var hangUpInfo = {
// 		mapId : 0,
// 		pointId : 0,
// 		beginTime : 0,
// 		isOnline  : 0
// 	};
// 	exports.setHangUpInfo(area, uuid, hangUpInfo, callback);
// };

// // 获取挂机信息
// exports.getHangUpInfo = function(area, uuid, callback) {
// 	tiny.redis.get(utils.redisKeyGen(area, uuid, 'hang'), function(err, data) {
// 		if (err) {
// 			callback(err);
// 		} else {
// 			if (data) {
// 				callback(null, data);
// 			} else {
// 				tiny.log.debug('getHangUpInfo|createHangUpInfo', area, uuid);
// 				// 创建挂机信息
// 				exports.createHangUpInfo(area, uuid, callback);
// 			}
// 		}
// 	});
// };

// 保存挂机信息
// exports.setHangUpInfo = function(area, uuid, hangUpInfo, callback) {
// 	tiny.redis.set(utils.redisKeyGen(area, uuid, 'hang'), hangUpInfo, callback);
// };

exports.getOnlineProfit = function(area, uuid, pointId, callback) {
	// 计算挂机信息
	// 计算金钱
	// 计算经验
	// 计算道具
	// 在线奖励金钱=（单次战斗时长/在线奖励间隔）* 单次奖励金钱数量（onlinegold）
	// 在线奖励经验=（单次战斗时长/在线奖励间隔）* 单次奖励经验数量（onlineexp）
	var fightTime, gold, exp, now = Date.now(), num, weightScope = [],
		indexScope = [], itemScope, itemId, splitList = {}, index;
	// 获取挂机信息
	exports.getHangUpInfo(area, uuid, function(err, hangUpInfo) {
		var i, j;
		if (err) {
			callback(err);
		} else {
			// 计算逻辑
			if (!hangUpInfo.beginTime) {
				// 起始时间为空预设为60s
				fightTime = 0;
			} else {
				fightTime = Math.floor((now - hangUpInfo.beginTime));
			}
			num = Math.floor(fightTime / Afkreward[pointId].onlineinterval);
			gold =  num * Afkreward[pointId].onlinegold;
			exp = num * Afkreward[pointId].onlineexp;
			// 随机道具盒子ID
			for (i in Afkreward[pointId].onlineitem) {
				if (Afkreward[pointId].onlineitem.hasOwnProperty(i)) {
					indexScope.push(Afkreward[pointId].onlineitem[i][1]);
					weightScope.push(Afkreward[pointId].onlineitem[i][2]);
				}
			}
			// 根据奖励次数随机道具，在线逻辑
			for (j = 0; j < num; j++) {
				// 随机道具盒子ID
				index = utils.randomScope(indexScope, weightScope);
				// 道具盒子数组
				itemScope = Itembox[index].itemid;
				// 检查道具盒子长度
				if (itemScope.length <= 0) {
					callback('itemScope wrong');
					return;
				}
				// 随机道具ID
				itemId = utils.randomArrayN(itemScope, 1);
				// 生成道具列表
				if (!splitList.hasOwnProperty(itemId)) {
					splitList[itemId] = {};
					splitList[itemId].num = 1;
				} else {
					splitList[itemId].num = splitList[itemId].num + 1;
				}
				splitList[itemId].id = itemId;

			}
			// 保存挂机时间
			hangUpInfo.beginTime = now;
			// 保存挂机信息
			exports.setHangUpInfo(area, uuid, hangUpInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, splitList, gold, exp);
				}
			});
		}
	});
};

exports.calOfflineProfit = function(pointId, hangUpInfo) {
	var offTime, gold, exp, now = Date.now(), num, count, itemScope, itemId, splitList = {}, i;
	// 计算逻辑
	tiny.log.error("..........beginTime", JSON.stringify(hangUpInfo));
	if (!hangUpInfo.beginTime) {
		// 起始时间为空预设为60s
		offTime = 0;
	} else {
		offTime = Math.floor((now - hangUpInfo.beginTime));
		if (offTime > Const.OFF_LINE_LIMIT_TIME) {
			offTime = Const.OFF_LINE_LIMIT_TIME;
		}
	}
	num = Math.floor(offTime / (Afkreward[pointId].offlineinterval + Afkreward[pointId].searchtime));
	gold =  num * Afkreward[pointId].offlinegold;
	exp = num * Afkreward[pointId].offlineexp;
	// 随机道具盒子ID
	for (i in Afkreward[pointId].offlineitem) {
		if (Afkreward[pointId].offlineitem.hasOwnProperty(i)) {
			// 奖励次数
			count = Math.floor(Afkreward[pointId].offlineitem[i][2] * num / 100);
			// 道具盒子数组
			itemScope = Itembox[Afkreward[pointId].offlineitem[i][1]].itemid;
			// 检查道具盒子长度
			if (itemScope.length <= 0) {
				return null;
			}
			// 随机道具ID
			itemId = utils.randomArrayN(itemScope, 1);
			splitList[itemId] = {};
			splitList[itemId].num = count;
			splitList[itemId].id = itemId;
		}
	}
	// 保存挂机时间
	hangUpInfo.beginTime = now;

	return {"gold" : gold, "exp" : exp, "splitList" : splitList, "time" : offTime};
};

exports.calOnlineProfit = function(pointId, hangUpInfo) {
	var fightTime, gold, exp, now = Date.now(), num, weightScope = [],
		indexScope = [], itemScope, itemId, splitList = {}, i, j, index;
	// 计算逻辑
	if (!hangUpInfo.beginTime) {
		// 起始时间为空预设为60s
		fightTime = 0;
	} else {
		fightTime = Math.floor((now - hangUpInfo.beginTime));
	}
	num = Math.floor(fightTime / Afkreward[pointId].onlineinterval);
	gold =  num * Afkreward[pointId].onlinegold;
	exp = num * Afkreward[pointId].onlineexp;
	// 随机道具盒子ID
	for (i in Afkreward[pointId].onlineitem) {
		if (Afkreward[pointId].onlineitem.hasOwnProperty(i)) {
			indexScope.push(Afkreward[pointId].onlineitem[i][1]);
			weightScope.push(Afkreward[pointId].onlineitem[i][2]);
		}
	}
	// 根据奖励次数随机道具，在线逻辑
	for (j = 0; j < num; j++) {
		// 随机道具盒子ID
		index = utils.randomScope(indexScope, weightScope);
		// 道具盒子数组
		itemScope = Itembox[index].itemid;
		// 检查道具盒子长度
		if (itemScope.length <= 0) {
			return null;
		}
		// 随机道具ID
		itemId = utils.randomArrayN(itemScope, 1);
		// 生成道具列表
		if (!splitList.hasOwnProperty(itemId)) {
			splitList[itemId] = {};
			splitList[itemId].num = 1;
		} else {
			splitList[itemId].num = splitList[itemId].num + 1;
		}
		splitList[itemId].id = itemId;
	}
	// 保存挂机时间
	hangUpInfo.beginTime = now;

	return {"gold" : gold, "exp" : exp, "splitList" : splitList};
};

exports.modHangUpInfo = function(area, uuid, func, callback) {
	// 获取挂机信息
	exports.getHangUpInfo(area, uuid, function(err, hangUpInfo) {
		var result;
		if (err) {
			callback(err);
		} else {
			// 执行bind函数
			result = func(hangUpInfo);
			if (!result) {
				callback("get the result error");
				return;
			}
			// 保存挂机信息
			exports.setHangUpInfo(area, uuid, hangUpInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, result);
				}
			});
		}
	});
};

exports.getOfflineProfit = function(area, uuid, pointId, callback) {
	// 计算挂机信息
	// 计算金钱
	// 计算经验
	// 计算道具
	var offTime, gold, exp, now = Date.now(), num, count, itemScope, itemId, splitList = {};
	// 获取挂机信息
	exports.getHangUpInfo(area, uuid, function(err, hangUpInfo) {
		var i;
		if (err) {
			callback(err);
		} else {
			// 计算逻辑
			if (!hangUpInfo.beginTime) {
				// 起始时间为空预设为60s
				offTime = 0;
			} else {
				offTime = Math.floor((now - hangUpInfo.beginTime));
				if (offTime > Const.OFF_LINE_LIMIT_TIME) {
					offTime = Const.OFF_LINE_LIMIT_TIME;
				}
			}
			num = Math.floor(offTime / (Afkreward[pointId].offlineinterval + Afkreward[pointId].searchtime));
			gold =  num * Afkreward[pointId].offlinegold;
			exp = num * Afkreward[pointId].offlineexp;
			// 随机道具盒子ID
			for (i in Afkreward[pointId].offlineitem) {
				if (Afkreward[pointId].offlineitem.hasOwnProperty(i)) {
					// 奖励次数
					count = Math.floor(Afkreward[pointId].offlineitem[i][2] * num / 100);
					// 道具盒子数组
					itemScope = Itembox[Afkreward[pointId].offlineitem[i][1]].itemid;
					if (itemScope.length <= 0) {
						callback("itemScope wrong");
						return;
					}
					// 随机道具ID
					itemId = utils.randomArrayN(itemScope, 1);
					splitList[itemId] = {};
					splitList[itemId].num = count;
					splitList[itemId].id = itemId;
				}
			}
			// 保存挂机时间
			hangUpInfo.beginTime = now;
			// 保存挂机信息
			exports.setHangUpInfo(area, uuid, hangUpInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, splitList, gold, exp, offTime);
				}
			});
		}
	});
};
