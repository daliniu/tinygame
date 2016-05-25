var async = require('async');
var nodeUUID = require('node-uuid');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');

/*
// 邮件正文单独保存，设置时效：mailHead
text = "abcdefg"
// 邮件头单独保存，设置时效：mailText
info = { mailid, sender, accept, attach  }

// 系统邮件信息
维护一个set保存所有的系统邮件id : globalMailList

// 个人邮件信息
一个set保存未领取邮件id：mailPool
一个set保存已领取邮件id: mailGetList
*/

exports.createNewMailID = function(cb) {
	tiny.redis.incr(utils.redisKeyGen('', '', 'mailID'), function(err, res) {
		if (err) {
			cb(err);
		} else {
			cb(err, res);
		}
	});
};

//==============================个人邮件===========================
// 批量获取邮件头
exports.getMailHeads = function(area, list, callback) {
	var mailList = [], i;
	for (i = 0; i < list.length; ++i) {
		mailList.push(utils.redisKeyGen(area, 'mailHead', list[i]));
	}
	tiny.log.trace('getMailHeads', '###########', area, list, mailList);
	if (mailList.length > 0) {
		tiny.redis.mget(mailList, function(err, headList) {
			if (err) {
				callback(err);
			} else {
				callback(null, headList);
			}
		});
	} else {
		callback(null, []);
	}
};

// 获取邮件text
exports.getMailText = function(area, mailID, callback) {
	tiny.redis.get(utils.redisKeyGen(area, 'mailText', mailID), function(err, text) {
		if (err) {
			callback(err);
		} else {
			callback(null, text);
		}
	});
};

// 向玩家邮件池添加新邮件
exports.addNewMail = function(area, uuid, mailID, callback) {
	tiny.redis.sadd(utils.redisKeyGen(area, uuid, 'mailPool'), mailID, callback);
};

// 将玩家邮件池移除一封邮件到已领取池
exports.moveMail = function(area, uuid, mailID, callback) {
	tiny.redis.smove(utils.redisKeyGen(area, uuid, 'mailPool'),
		utils.redisKeyGen(area, uuid, 'mailGetList'), mailID, callback);
};

// 判断一封邮件玩家是否可以领取
exports.isInMailPool = function(area, uuid, mailID, callback) {
	tiny.redis.sismember(utils.redisKeyGen(area, uuid, 'mailPool'), mailID, callback);
};

// 获取所有玩家邮件池邮件id
exports.getAllNewMail = function(area, uuid, callback) {
	tiny.redis.smembers(utils.redisKeyGen(area, uuid, 'mailPool'), callback);
};

// 从系统邮件池拉取新邮件进玩家邮件池
exports.recvGlobalMail = function(area, uuid, callback) {
	tiny.redis.sdiff(utils.redisKeyGen(area, '', 'globalMailPool'),
		utils.redisKeyGen(area, uuid, 'mailGetList'), function(err, diff) {
			tiny.log.trace('#########', utils.redisKeyGen(area, '', 'globalMailPool'), utils.redisKeyGen(area, uuid, 'mailGetList'), err, diff);
			if (err) {
				callback(err);
			} else {
				if (diff.length > 0) {
					tiny.log.trace('#########', diff, utils.getValueType(diff));
					tiny.redis.sadd(utils.redisKeyGen(area, uuid, 'mailPool'), diff, callback);
				} else {
					callback(null);
				}
			}
	});
};

//==============================系统邮件===========================
// 添加邮件头
exports.addMailHeadEx = function(area, mailID, head, second, callback) {
	tiny.redis.setex(utils.redisKeyGen(area, 'mailHead', mailID), head, second, callback);
};

// 添加邮件text
exports.addMailTextEx = function(area, mailID, text, second, callback) {
	tiny.redis.setex(utils.redisKeyGen(area, 'mailText', mailID), text, second, callback);
};

// 添加系统邮件
exports.addGlobalMail = function(area, mailID, callback) {
	tiny.redis.sadd(utils.redisKeyGen(area, '', 'globalMailPool'), mailID, callback);
};
