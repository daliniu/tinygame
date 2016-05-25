/*

邮件系统：
邮件系统支持单人邮件和系统邮件两类
完整邮件结构：
{ 邮件id、发件人、收件人、内容、附件、区服、邮件领取截止时间 }

发送单人邮件
1、申请邮件id
2、添加邮件头
3、添加邮件text
4、添加id进玩家邮件池
5、判断玩家是否在线，如果在线给玩家推送邮件头

发送系统邮件
1、申请邮件id
2、添加邮件头
3、添加邮件text
4、对指定区服玩家推送邮件（暂时不主动推，看看需求）

玩家登陆时从系统邮件池收取邮件，已经收取过的邮件不再收取

邮件领取操作将玩家邮件池中的邮件move到已领取池

玩家登陆时
1、从系统邮件池收取邮件
2、把未领取的邮件头列表发给玩家
*/
var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var MailConst = Const.MAIL;
var tiny = require('../../tiny');
var utils = require('../utils');
var rpc = require('../net/mdp/remote_proxy');
var async = require('async');
var moment = require('moment');
var mailHandle = require('../dataprocess/mail_handle');
var equipHandle = require('../dataprocess/equip_handle');
var playerHandle = require('../dataprocess/player_handle');
var Item = require('../config/pick/item');
var bag = require('../bag/bag');

// 初始化rpc调用器
var	communicator = rpc.initServer('conn');
var	communicatorOnly = rpc.initServer('conn');

// 发送单人邮件
var sendPersonMail = function(inArgs, onResponse, current) {
	tiny.log.trace("sendPersonMail", "hah ");
	var name, svr, zoneid, msg = inArgs.msg, mailHead = {};
	async.waterfall([
		// 获取玩家的uuid
		function(callback) {
			tiny.log.trace("sendPersonMail", "hah 1");
			name = msg.accept;
			zoneid = msg.zone;
			svr = msg.svr;
			if (name && zoneid && svr) { // 检查 zoneid 和 svr 是否合法
				tiny.log.trace("sendPersonMail", "hah 2");
				tiny.redis.getUUIDfromName("1"+"|"+name, function(err, uuid) {
					if (err) {
						tiny.log.trace("sendPersonMail", "hah 2 err", err);
						callback(err);
					} else {
						if (uuid) {
							tiny.log.trace("sendPersonMail", "hah 66", uuid);
							callback(null, 1, uuid);
						} else {
							tiny.log.trace("sendPersonMail", "hah 22 err", uuid);
							callback('uuid is null', zoneid + '|' + svr + '|' + name);
						}
					}
				});
			} else {
				tiny.log.trace("sendPersonMail", "hah 3");
				callback('name or zoneid or svr null', zoneid + '|' + svr + '|' + name);
			}
		},
		// 申请新的mailid
		function(area, uuid, callback) {
			tiny.log.trace('3333333333333');
			mailHandle.createNewMailID(function(err, newID) {
				tiny.log.trace('3333333333333  1');
				if (err) {
					tiny.log.trace('3333333333333  2', err);
					callback(err);
				} else {
					tiny.log.trace('3333333333333  3');
					callback(null, area, uuid, newID);
				}
			});
		},
		// 添加邮件头
		function(area, uuid, newID, callback) {
			if (newID) {
				var time = 10 * 24 * 60 * 60;
				tiny.log.trace('3333333333333 4', newID);
				mailHead.id = newID;
				mailHead.sender = msg.sender;
				mailHead.title = msg.title;
				mailHead.attach = msg.attach;
				mailHandle.addMailHeadEx(area, newID, mailHead, time, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, area, uuid, newID, mailHead);
					}
				});
			} else {
				tiny.log.trace('3333333333333  8888');
				callback('sendPersonMail newID is null');
			}
		},
		// 添加邮件text
		function(area, uuid, newID, mailHead, callback) {
			var time = 10 * 24 * 60 * 60,
				text = msg.text || "";
			mailHandle.addMailTextEx(area, newID, text, time, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, area, uuid, newID, mailHead);
				}
			});
		},
		// 添加id进玩家邮件池
		function(area, uuid, newID, mailHead, callback) {
			mailHandle.addNewMail(area, uuid, newID, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, area, uuid, mailHead);
				}
			});
		},
		// 检查玩家是否在线，在线就推
		function(area, uuid, mailHead, callback) {
			tiny.log.trace('4444444444444');
			tiny.redis.getOnlineInfo(area, uuid, function(err, onlineInfo) {
				tiny.log.trace('4444444444444  1');
				if (err) {
					tiny.log.trace('4444444444444 err', err);
					callback(ErrCode.GET_ONLINEINFO_ERROR, err);
				} else {
					tiny.log.trace('4444444444444   1');
					callback(null, onlineInfo, mailHead);
				}
			});
		},
		// 发送邮件
		function(onlineInfo, mailHead, callback) {
			tiny.log.trace('5555555555');
			var recvInArgs = {};
			recvInArgs.yourSessionId = onlineInfo.sessionId;
			recvInArgs.msg = mailHead;
			tiny.log.debug("sendPersonMail|recvInArgs", JSON.stringify(recvInArgs), JSON.stringify(onlineInfo));
			communicatorOnly.setServer(onlineInfo.connId).pushMailToClient(recvInArgs, {});
			tiny.log.trace('5555555555  1');
			callback(null, null);
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error("sendPersonMail", err, errStr);
		} else {
			tiny.log.info('sendPersonMail ok', zoneid, svr, name, JSON.stringify(mailHead));
		}
	});
};

// 发送系统邮件
var sendGlobalMail = function(inArgs, onResponse, current) {
	tiny.log.trace("sendGlobalMail", "hah ");
	var msg = inArgs.msg, mailHead = {}, zoneid, svr;
	async.waterfall([
		// 获取区服
		function(callback) {
			tiny.log.trace("sendGlobalMail", "hah 1");
			zoneid = msg.zone;
			svr = msg.svr;
			if (zoneid && svr) { // 检查 zoneid 和 svr 是否合法
				tiny.log.trace("sendGlobalMail", "hah 2");
				callback(null, svr);
			} else {
				tiny.log.trace("sendGlobalMail", "hah 3");
				callback('zoneid or svr null', zoneid + '|' + svr);
			}
		},
		// 申请新的mailid
		function(area, callback) {
			tiny.log.trace('3333333333333');
			mailHandle.createNewMailID(function(err, newID) {
				tiny.log.trace('3333333333333  1');
				if (err) {
					tiny.log.trace('3333333333333  2', err);
					callback(err);
				} else {
					tiny.log.trace('3333333333333  3');
					callback(null, area, newID);
				}
			});
		},
		// 添加邮件头
		function(area, newID, callback) {
			if (newID) {
				var time = 10 * 24 * 60 * 60;
				tiny.log.trace('3333333333333 4', newID);
				mailHead.id = newID;
				mailHead.sender = msg.sender;
				mailHead.title = msg.title;
				mailHead.attach = msg.attach;
				mailHandle.addMailHeadEx(area, newID, mailHead, time, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, area, newID, mailHead);
					}
				});
			} else {
				tiny.log.trace('3333333333333  8888');
				callback('sendGlobalMail newID is null');
			}
		},
		// 添加邮件text
		function(area, newID, mailHead, callback) {
			var time = 10 * 24 * 60 * 60,
				text = msg.text || "";
			mailHandle.addMailTextEx(area, newID, text, time, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, area, newID, mailHead);
				}
			});
		},
		// 指定区服推送
		function(area, newID, mailHead, callback) {
			// 推送新邮件
			callback(null, null);
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error("sendGlobalMail", err, errStr);
		} else {
			tiny.log.info('sendGlobalMail ok', JSON.stringify(mailHead));
		}
	});
};

// 收取邮件
var ReceiveMail = function(inArgs, onResponse, current) {
	tiny.log.trace("ReceiveMail", "hah ");
	var outArgs = {}, i;
	outArgs.mailList = {};
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
		// 从系统邮件池拉取邮件
		function(session, callback) {
			mailHandle.recvGlobalMail(session.area, session.uuid, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, session);
				}
			});
		},
		// 获取玩家邮件池列表
		function(session, callback) {
			mailHandle.getAllNewMail(session.area, session.uuid, function(err, list) {
				if (err) {
					callback(err);
				} else {
					callback(null, session, list);
				}
			});
		},
		// 获取邮件头
		function(session, list, callback) {
			mailHandle.getMailHeads(session.area, list, function(err, mailList) {
				if (err) {
					callback(err);
				} else {
					callback(null, list, mailList);
				}
			});
		},
		// 整理邮件头内容并发送客户端
		function(list, mailList, callback) {
			for (i = 0; i < mailList.length; ++i) {
				if (mailList[i]) {
					outArgs.mailList[list[i]] = mailList[i];
				}
			}
			callback(null, null);
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error("ReceiveMail", err, errStr);
		} else {
			tiny.log.info("ErrCode.SUCCESS = ", ErrCode.SUCCESS, JSON.stringify(outArgs));
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

var getMailText = function(inArgs, onResponse, current) {
	tiny.log.trace("getMailText", "hah ");
	var outArgs = {}, mailID = inArgs.mailID;
	outArgs.text = "";
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
		// 根据mailID获取邮件text
		function(session, callback) {
			mailHandle.getMailText(session.area, mailID, function(err, text) {
				if (err) {
					callback(err);
				} else {
					if (text) {
						outArgs.text = text;
					}
					callback(null, null);
				}
			});
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error("getMailText", err, errStr);
		} else {
			tiny.log.info("ErrCode.SUCCESS = ", ErrCode.SUCCESS, JSON.stringify(outArgs));
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

var getMailAttach = function(inArgs, onResponse, current) {
	tiny.log.trace("getMailAttach", "hah ");
	var outArgs = {}, mailID = inArgs.mailID;
	outArgs.isOK = 0;
	outArgs.attach = {};
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
		// 判断邮件是否可以领取
		function(session, callback) {
			mailHandle.isInMailPool(session.area, session.uuid, mailID, function(err, ret) {
				if (err) {
					callback(err);
				} else {
					if (ret === 1) {
						callback(null, session);
					} else {
						callback(ErrCode.MAIL_NOT_FOUND, 'mail not found in mail pool:' + mailID);
					}
				}
			});
		},
		// 获取邮件head信息
		function(session, callback) {
			mailHandle.getMailHeads(session.area, [mailID], function(err, list) {
				if (err) {
					callback(err);
				} else {
					if (list && list.length > 0 && list[0]) {
						callback(null, session, list[0]);
					} else {
						callback(ErrCode.MAIL_HEAD_NOT_FOUND, 'mail head not found:' + mailID);
					}
				}
			});
		},
		// 获取背包数据
		function(session, mailHead, callback) {
			tiny.log.trace("getMailAttach", "333", mailHead, JSON.stringify(mailHead));
			equipHandle.getBagList(session.area, session.uuid, function(err, bagList) {
				if (err) {
					callback(ErrCode.GET_BAG_ERROR, err);
				} else {
					callback(null, session, mailHead, bagList);
				}
			});
		},
		// 获取玩家baseinfo
		function(session, mailHead, bagList, callback) {
			tiny.log.trace("getMailAttach", "4444");
			playerHandle.getBaseInfo(session.area, session.uuid, function(err, baseInfo) {
				if (err) {
					callback(ErrCode.GET_BASEINFO_ERROR, err);
				} else {
					callback(null, session, mailHead, bagList, baseInfo);
				}
			});
		},
		// 领取附件
		function(session, mailHead, bagList, baseInfo, callback) {
			var attach = mailHead.attach, i;
			tiny.log.trace("getMailAttach", attach, JSON.stringify(mailHead));
			if (attach) {
				for (i in attach) {
					if (attach.hasOwnProperty(i)) {
						tiny.log.trace('getMailAttach', i);
						if (i === 'gold') {
							tiny.log.trace("getMailAttach", "gold", attach[i], parseInt(attach[i], 10), baseInfo.gold, utils.addValue(baseInfo.gold + parseInt(attach[i], 10)));
							baseInfo.gold = utils.addValue(baseInfo.gold + parseInt(attach[i], 10));
						}
						if (i === 'diamond') {
							tiny.log.trace("getMailAttach", "diamond", attach[i], parseInt(attach[i], 10), baseInfo.diamond, utils.addValue(baseInfo.diamond + parseInt(attach[i], 10)));
							baseInfo.diamond = utils.addValue(baseInfo.diamond + parseInt(attach[i], 10));
						}
						if (Item.hasOwnProperty(i)) {
							tiny.log.trace("getMailAttach", "Item", i, parseInt(attach[i], 10));
							if (!bag.addItem(i, parseInt(attach[i], 10), bagList)) {
								tiny.log.error('getMailAttach', 'attach get item error', i, attach[i]);
							}
							tiny.log.trace("getMailAttach", "Item", "success", i, parseInt(attach[i], 10));
						}
					}
				}
			}
			callback(null, session, mailHead, bagList, baseInfo);
		},
		// 保存baseinfo
		function(session, mailHead, bagList, baseInfo, callback) {
			tiny.log.trace("getMailAttach", "5555");
			playerHandle.setBaseInfo(session.area, session.uuid, baseInfo, function(err) {
				if (err) {
					callback(ErrCode.SAVE_BASEINFO_ERROR, err);
				} else {
					callback(null, session, mailHead, bagList);
				}
			});
		},
		// 保存背包
		function(session, mailHead, bagList, callback) {
			tiny.log.trace("getMailAttach", "666");
			equipHandle.setBagList(session.area, session.uuid, bagList, function(err) {
				if (err) {
					callback(ErrCode.SAVE_BAG_ERROR, err);
				} else {
					callback(null, session, mailHead);
				}
			});
		},
		// 把领取的邮件move到已领取邮件池
		function(session, mailHead, callback) {
			tiny.log.trace("getMailAttach", "7777", mailID);
			mailHandle.moveMail(session.area, session.uuid, mailID, function(err) {
				if (err) {
					callback(err);
				} else {
					outArgs.isOK = 1;
					outArgs.attach = mailHead.attach;
					callback(null, null);
				}
			});
		}
	], function(err, errStr) {
		if (err) {
			tiny.log.error("getMailAttach", err, errStr);
		} else {
			tiny.log.info("ErrCode.SUCCESS = ", ErrCode.SUCCESS, JSON.stringify(outArgs));
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

module.exports = {
"sendPersonMail" : sendPersonMail,
"sendGlobalMail" : sendGlobalMail,
"ReceiveMail" : ReceiveMail,
"getMailText" : getMailText,
"getMailAttach" : getMailAttach
};
