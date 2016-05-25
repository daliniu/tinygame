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

// 刷新日常任务接口
exports.refreshDailyTask = function() {

};
