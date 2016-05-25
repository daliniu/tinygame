/*
任务系统：

服务器维护三个set
两个是非重复任务集合，一个存放已经完成的任务set，一个存放当前任务set。
判断交由客户端，服务器不做验证，因为任务迟早是要给他奖励的。
第三个set是日常任务set，这个set在玩家登陆的时候刷新。
如果距离上次登录超过刷新时间点，重新刷新日常任务set，玩家不重新登录，日常任务不刷新。

完成任务时，客户端带上新任务id，添加进当前任务池
*/
var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var utils = require('../utils');
var async = require('async');
var moment = require('moment');
var taskHandle = require('../dataprocess/task_handle');

// 领取任务接口
var getNewTask = function(inArgs, onResponse, current) {
	var tasklist = inArgs.tasklist;
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err + '|' + current.sessionId);
				} else {
					callback(null, session);
				}
			});
		},
		function(session, callback) {
			// 遍历检查每个任务是否可以领取
			callback(null, null);
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error('getNewTask', err, errStr);
			onResponse(err, current, inArgs, outArgs);
		} else {
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

// 完成任务接口
var doneTask = function(inArgs, onResponse, current) {
	var taskID = inArgs.taskID;
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err + '|' + current.sessionId);
				} else {
					callback(null, session);
				}
			});
		},
		// 检查任务是否在当前任务池
		function(session, callback) {
			callback(null, null);
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error('doneTask', err, errStr);
			onResponse(err, current, inArgs, outArgs);
		} else {
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};


module.exports = {
"getNewTask" : getNewTask,
"doneTask" : doneTask
};
