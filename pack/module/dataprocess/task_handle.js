var async = require('async');
var nodeUUID = require('node-uuid');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');

//==============================主线任务===========================
// 增加新任务进任务池
exports.addNewTask = function(area, uuid, tasklist, callback) {
	tiny.redis.sadd(utils.redisKeyGen(area, uuid, 'taskPool'), tasklist, callback);
};

// 把任务从任务池移入完成池
exports.moveTaskToDone = function(area, uuid, taskID, callback) {
	tiny.redis.smove(utils.redisKeyGen(area, uuid, 'taskPool'),
		utils.redisKeyGen(area, uuid, 'taskDonePool'), taskID, callback);
};

// 判断任务是否在当前任务池
exports.isInTaskPool = function(area, uuid, taskID, callback) {
	tiny.redis.sismember(utils.redisKeyGen(area, uuid, 'taskPool'), taskID, callback);
};

// 获取玩家任务池
exports.getAllTask = function(area, uuid, callback) {
	tiny.redis.smembers(utils.redisKeyGen(area, uuid, 'taskPool'), callback);
};

exports.setScheduleMark = function(key, value, callback) {
	tiny.redis.set(utils.redisKeyGen("", "scheduleTask", key), value, callback);
};
