// var async = require('async');
// var nodeUUID = require('node-uuid');

// var tiny = require('../../tiny');
// var utils = require('../utils');
// var Const = require('../const');

/*
// 挂机信息
AfkInfo
{
	curAfker: {mapid, uid, guajiid}
	beginAfkTime : 12423
	lastNorAfk : {mapid, uid, guajiid}
	afkList: {
		[mapid] = {
			[uid] = 1,
		},
	}
}
*/

// 创建默认地图列表
// var defaultAfkInfo = function() {
// 	var afk = {
// 		"curAfker" : { "mapid" : 0, "uid" : 0, "guajiid" : 0 },
// 		"beginAfkTime" : 0,
// 		"lastNorAfk" : { "mapid" : 0, "uid" : 0, "guajiid" : 0 },
// 		"afkList" : {},
// 		"afkVictoryTime" : { "rewardCount" : 0, "scoreTime" : 1},
// 	};
// 	return afk;
// };

// exports.getAfkInfo = function(area, uuid, callback) {
// 	tiny.redis.get(utils.redisKeyGen(area, uuid, 'afk'), function(err, data) {
// 		if (err) {
// 			callback(err);
// 		} else {
// 			callback(null, data);
// 		}
// 	});
// };

// exports.setAfkInfo = function(area, uuid, afk, callback) {
// 	tiny.redis.set(utils.redisKeyGen(area, uuid, 'afk'), afk, callback);
// };



