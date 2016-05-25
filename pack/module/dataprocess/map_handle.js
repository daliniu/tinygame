var async = require('async');
var nodeUUID = require('node-uuid');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var mapfunc = require('../map/map');
var WorldMap = require('../config/map/worldmap');

/*
// 大地图信息
map
{
	curNode: 101	// 当前节点id
	curAfkNode: 90 	// 当前挂机节点
	lastNormalAfk : 101	// 上一个普通挂机点
	openNode: {
		nodeid: {
			process: 100
			compAward: 0/1
		}
	}
	timeNode: {
		nodeid: {
			timeStamp: moment().format(),
			waitSec: 20
		}
	}
}

// 在进入挂机点和地图完成时创建
// 地图
[nodeid]
{
	x
	y
	uidList: {
		uid: state
	}
	buff: {
		buffid: value
	}
	sign: {
		signid: 0
	}
	ap
	pass
}

// 挂机点
[nodeid]
{
	proAfkTime : moment().format()
	victoryTime : 10
	fightTime : 10
	rewardTime : 0
}
*/

exports.createGlobalMapInfo = function(area, uuid, callback) {
	var default_node = Const.MAP.DEFAULT_NODE, i,
	map = {
		curNode: default_node,	// 当前节点id
		curAfkNode: default_node, 	// 当前挂机节点
		lastNormalAfk: default_node,	// 上一个普通挂机点
		openNode: {},
		timeNode: {}
	},
	node = mapfunc.createNode(default_node), saveNode = {}, ret = {};
	map.openNode[default_node] = {
		process: 0,
		compAward: 0
	};
	saveNode[default_node] = utils.setObject(node);

	ret = mapfunc.addOpenNode(WorldMap[default_node].Next, map);
	for (i in ret) {
		if (ret.hasOwnProperty(i)) {
			saveNode[i] = utils.setObject(ret[i]);
		}
	}

	tiny.redis.set(utils.redisKeyGen(area, uuid, 'map'), map, function(e) {
		if (e) {
			callback(e);
		} else {
			tiny.redis.hmset(utils.redisKeyGen(area, uuid, 'node'), saveNode, callback);
		}
	});
};

exports.getNodeInfo = function(area, uuid, nodeid, callback) {
	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'node'), nodeid, function(err, data) {
		if (err) {
			callback(err);
		} else {
			if (data) {
				data = utils.getObject(data);
			}
			callback(null, data);
		}
	});
};

exports.saveNodeInfo = function(area, uuid, nodeid, info, callback) {
	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'node'), nodeid, utils.setObject(info), callback);
};

// exports.changeMap = function(area, uuid, mapid, callback) {
// 	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'map'), 'curMapId', utils.setObject(mapid), callback);
// };

// exports.getCurMapID = function(area, uuid, callback) {
// 	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'map'), 'curMapId', function(err, curID) {
// 		if (err) {
// 			callback(err);
// 		} else {
// 			if (curID) {
// 				curID = utils.getObject(curID);
// 			}
// 			callback(null, curID);
// 		}
// 	});
// };

// exports.getMapBuff = function(area, uuid, callback) {
// 	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'map'), 'buffList', function(err, data) {
// 		if (err) {
// 			callback(err);
// 		} else {
// 			if (data) {
// 				tiny.log.trace("getMapBuff", utils.getValueType(data));
// 				data = utils.getObject(data);
// 			}
// 			callback(null, data);
// 		}
// 	});
// };

// exports.setMapBuff = function(area, uuid, buffList, callback) {
// 	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'map'), "buffList", utils.setObject(buffList), callback);
// };

// exports.checkMapInfoExist = function(area, uuid, mapid, cb) {
// 	tiny.redis.hexists(utils.redisKeyGen(area, uuid, 'map'), mapid, cb);
// };
