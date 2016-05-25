var Const = require("../../module/const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var async = require('async');
var utils = require('../../module/utils');
var rpc = require('../../module/net/mdp/remote_proxy');

// 初始化rpc调用器
var	communicator = rpc.initServer('conn');
var	communicatorOnly = rpc.initServer('conn');

// 私聊
exports.sendMyMsgToYou = function(inArgs, onResponse, current) {
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err, {area : 'null', uuid : 'null'});
				} else {
					callback(null, session);
				}
			});
		},
		// 获取私聊对方onlineInfo
		function(session, callback) {
			tiny.redis.getOnlineInfo(inArgs.area, inArgs.uuid, function(err, onlineInfo) {
				if (err) {
					callback(ErrCode.GET_ONLINEINFO_ERROR, err, session);
				} else {
					callback(null, session, onlineInfo);
				}
			});
		},
		// 发送消息
		function(session, onlineInfo, callback) {
			var recvInArgs = {};
			recvInArgs.uuid = session.uuid;
			recvInArgs.area = session.area;
			recvInArgs.yourSessionId = onlineInfo.sessionId;
			recvInArgs.msg = inArgs.msg;
			recvInArgs.type = inArgs.type;
			tiny.log.debug("sendMyMsgToYou|recvInArgs", JSON.stringify(recvInArgs), JSON.stringify(onlineInfo));
			communicatorOnly.setServer(onlineInfo.connId).pushMsgToClient(recvInArgs, current, function(recvOutArgs) {
				if (recvOutArgs && recvOutArgs.retCode === ErrCode.SUCCESS) {
					callback(null, null, session, recvOutArgs.state);
				} else {
					callback(recvOutArgs.retCode, "call rpc pushMsgToClient fail", session);
				}
			});
		}
	], function(errCode, errStr, session, state) {
		var outArgs = {};
		if (errCode) {
			tiny.log.error("sendMyMsgToYou", session.area, session.uuid, errCode, errStr);
			outArgs.state = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.state = state;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

// 队伍聊
exports.sendMyMsgInMyTeam = function(inArgs, onResponse, current) {
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err, {area : 'null', uuid : 'null'});
				} else {
					callback(null, session);
				}
			});
		},
		// 获取频道onlineInfo
		function(session, callback) {
			tiny.redis.getChannelOnlineInfo(inArgs.area, inArgs.uuid, inArgs.channelId, function(err, onlineInfo) {
				if (err) {
					callback(ErrCode.GET_ONLINEINFO_ERROR, err, session);
				} else {
					callback(null, session, onlineInfo);
				}
			});
		},
		// 发送消息
		function(session, onlineInfo, callback) {
			var recvInArgs = {};
			recvInArgs.uuid = session.uuid;
			recvInArgs.area = session.area;
			recvInArgs.sessionIdList = onlineInfo.sessionIdList;
			recvInArgs.msg = inArgs.msg;
			recvInArgs.type = inArgs.type;
			tiny.log.debug("sendMyMsgInMyTeam|recvInArgs", JSON.stringify(recvInArgs), JSON.stringify(onlineInfo));
			communicator.broadcast.pushMsgToClientChannel(recvInArgs, current, function(recvOutArgs) {
				if (recvOutArgs && recvOutArgs.retCode === ErrCode.SUCCESS) {
					callback(null, null, session, recvOutArgs.state);
				} else {
					callback(recvOutArgs.retCode, "call rpc pushMsgToClientChannel fail", session);
				}
			});
		}
	], function(errCode, errStr, session, state) {
		var outArgs = {};
		if (errCode) {
			tiny.log.error("sendMyMsgInMyTeam", session.area, session.uuid, errCode, errStr);
			outArgs.state = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.state = state;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

// 区服聊
exports.sendMyMsgInArea = function(inArgs, onResponse, current) {
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err, {area : 'null', uuid : 'null'});
				} else {
					callback(null, session);
				}
			});
		},
		// 发送消息
		function(session, callback) {
			var recvInArgs = {};
			recvInArgs.uuid = session.uuid;
			recvInArgs.area = session.area;
			recvInArgs.msg = inArgs.msg;
			recvInArgs.type = inArgs.type;
			tiny.log.debug("sendMyMsgInArea|recvInArgs", JSON.stringify(recvInArgs));
			communicator.broadcast.pushMsgToClientArea(recvInArgs, current, function(recvOutArgs) {
				tiny.log.debug("pushMsgToClientArea", JSON.stringify(recvOutArgs));
			});
			callback(null, null, session, Const.LOGIN_ON);
		}
	], function(errCode, errStr, session, state) {
		var outArgs = {};
		if (errCode) {
			tiny.log.error("sendMyMsgInArea", session.area, session.uuid, errCode, errStr);
			outArgs.state = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.state = state;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

// 公告
exports.sendAnnounce = function(inArgs, onResponse, current) {
	async.waterfall([
		// 获取session
		function(callback) {
			tiny.redis.getSession(current.sessionId, function(err, session) {
				if (err) {
					callback(ErrCode.GET_SESSION_ERROR, err, {area : 'null', uuid : 'null'});
				} else {
					callback(null, session);
				}
			});
		},
		// 发送消息
		function(session, onlineInfo, callback) {
			var recvInArgs = {};
			recvInArgs.uuid = session.uuid;
			recvInArgs.area = session.area;
			recvInArgs.msg = inArgs.msg;
			recvInArgs.type = inArgs.type;
			tiny.log.debug("sendAnnounce|recvInArgs", JSON.stringify(recvInArgs), JSON.stringify(onlineInfo));
			communicator.broadcast.pushMsgToClientAnnounce(recvInArgs, current, function(recvOutArgs) {
				if (recvOutArgs && recvOutArgs.retCode === ErrCode.SUCCESS) {
					callback(null, null, session, recvOutArgs.state);
				} else {
					callback(recvOutArgs.retCode, "call rpc pushMsgToClientAnnounce fail", session);
				}
			});
		}
	], function(errCode, errStr, session, state) {
		var outArgs = {};
		if (errCode) {
			tiny.log.error("sendAnnounce", session.area, session.uuid, errCode, errStr);
			outArgs.state = Const.LOGIN_OFF;
			onResponse(errCode, current, inArgs, outArgs);
		} else {
			outArgs.state = state;
			onResponse(ErrCode.SUCCESS, current, inArgs, outArgs);
		}
	});
};

exports.sendMsgToServer = function(inArgs, onResponse, current) {
	// 获取uuid， area
	// 获取对方的conn, sessionId
	// 发送消息
	// 返回发送状态

	// 获取uuid， area
	// 获取群所有成员的conn, sessionId
	// 发送消息
	// 返回发送状态

	//tiny.log.debug("sendMsgToServer", JSON.stringify(inArgs));
	if (inArgs.type === Const.IM_MY_MSG_TO_YOU) {
		// 私聊
		exports.sendMyMsgToYou(inArgs, onResponse, current);
	} else if (inArgs.type === Const.IM_MY_MSG_IN_MY_TEAM) {
		// 队伍聊
		exports.sendMyMsgInMyTeam(inArgs, onResponse, current);
	} else if (inArgs.type === Const.IM_MY_MSG_IN_AREA) {
		// 区服聊
		exports.sendMyMsgInArea(inArgs, onResponse, current);
	} else if (inArgs.type === Const.IM_ANNOUNCE) {
		// 公告
		exports.sendAnnounce(inArgs, onResponse, current);
	} else {
		// 类型错误
		onResponse(ErrCode.FAILURE, current, inArgs, {retCode : ErrCode.FAILURE});
	}

};
