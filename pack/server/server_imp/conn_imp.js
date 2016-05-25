var Const = require("../../module/const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var rpc = require('../../module/net/mdp/remote_proxy');
var utils = require('../../module/utils');
var xgSdk = require('../../module/sdk/sdk');
var LimitMap = utils.LimitMap;
var sessionMap = new LimitMap(Const.CONNECT_SERVER_LIMIT);
var hangImp = require('../../module/fight/hangup_imp');

// 本远程调用为广播调用, 获取ConnServer的玩家数量
//	callbackFunc = "adjustLoadNums";
// 	outArgs.uuid = uuid;
//	outArgs.loadNums = 100;
var playerNums = 0;
tiny.log.debug("|playerNums:" + playerNums);

var sessionMap = new LimitMap(Const.CONNECT_SERVER_LIMIT);

var setSession = function(area, uuid, sessionId) {
	sessionMap.set(uuid, {"area" : area, "sessionId" : sessionId});
};

var getSession = function(uuid) {
	return sessionMap.get(uuid);
};

var getSessionData = function() {
	return sessionMap.data();
};

// 初始化rpc调用器
var	communicator = rpc.initServer('loc');
var	clientCommunicator = rpc.initServer('client');
var connCommunicator = rpc.initServer('conn');
exports.getConnServerLoadNums = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid;

	// 获取输入参数
	uuid = inArgs.uuid;

	// 处理逻辑
	tiny.log.debug("|getConnServerLoadNums|uuid:" + uuid);

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = uuid;
	outArgs.loadNums = playerNums;
	outArgs.connName = tiny.id;
	outArgs.host = tiny.host;
	outArgs.port = tiny.port;
	onResponse(retCode, current, inArgs, outArgs);

	//返回
	return ErrCode.SUCCESS;
};

//exports.loginGame = function(inArgs) {
exports.loginGame = function(inArgs, onResponse, current) {
	// 定义变量
	var authInfo, area, code, uuid, retCode, plat;

	// 获取输入参数
	authInfo = inArgs.authInfo;
	area = inArgs.area;
	code = inArgs.code;
	plat = inArgs.plat;

	// 处理逻辑
	tiny.log.debug("loginGame|authInfo:", authInfo, area, code, plat);

	playerNums = playerNums + 1;

	// sdk验证token
	xgSdk.sdk_checkToken(inArgs, function() {
		// 验证token错误处理
		/*
		if (err) {
			tiny.log.error("sdk_checkToken", authInfo, area, plat, err, JSON.stringify(data));
			retCode = ErrCode.LOGIN_FAILURE;
			onResponse(retCode, current, inArgs, {});
			return;
		}
		// 获取uid
		inArgs.uuid = data.uid;
		*/
		inArgs.uuid = inArgs.authInfo;
		uuid = inArgs.uuid;
		tiny.redis.getOnlineInfo(area, uuid, function(err, myOnlineInfo) {
			if (!err || myOnlineInfo) {
				// 已经在的玩家踢下线
				inArgs.myOnlineInfo = myOnlineInfo;
				if (tiny.id === myOnlineInfo.connId) {
					tiny.log.debug("kickClient", inArgs.uuid, inArgs.area);
					exports.kickClient(inArgs);
				} else {
					tiny.log.debug("kickClientOffline", inArgs.uuid, inArgs.area);
					connCommunicator.setServer(myOnlineInfo.connId).kickClientOffline(inArgs, current, function(data) {
						if (!data) {
							tiny.log.debug("kickClientOffline fail", inArgs.uuid, inArgs.area);
						}
					});
				}
			}
			// 载入玩家数据
			communicator.loadPlayerInfo(inArgs, current, function(outArgs) {
				// 登录成功记录session状态进redis
				var session = {
					"connId" : tiny.id,
					"uuid" : uuid,
					"area" : area
				};
				// 添加在线信息
				tiny.redis.addOnlineInfo(area, uuid, {"sessionId" : current.sessionId, "connId" : tiny.id}, function(err) {
					if (err) {
						tiny.log.error('addOnlineInfo', current.sessionId, uuid, area);
						retCode = ErrCode.ADD_SESSION_ERROR;
						onResponse(retCode, current, inArgs, outArgs);
						return;
					}
					// 添加session信息
					tiny.redis.addSession(current.sessionId, session, function(err) {
						if (err) {
							tiny.log.error('addSession', current.sessionId, uuid, area);
							retCode = ErrCode.ADD_SESSION_ERROR;
						} else {
							retCode = ErrCode.SUCCESS;
						}
						// 保存session关系映射
						setSession(area, uuid, current.sessionId);
						// 回包
						onResponse(retCode, current, inArgs, outArgs);
					});
				});
			});
		});
	});
	//返回
	return ErrCode.SUCCESS;
};

// 退出游戏
exports.exitGame = function(inArgs, onResponse, current) {
	var retCode = ErrCode.SUCCESS;
	hangImp.setProAfkTime(inArgs.area, inArgs.uuid, function(err) {
		if (err) {
			tiny.log.debug("setProAfkTime fail");
		}
		tiny.redis.delOnlineInfo(inArgs.area, inArgs.uuid, function(err) {
			if (err) {
				retCode = ErrCode.FAILURE;
			} else {
				retCode = ErrCode.SUCCESS;
			}
			onResponse(retCode, current, inArgs, inArgs);
		});
	});
};

exports.heartBeat = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs;

	// 处理逻辑
	tiny.log.debug("heartBeat", inArgs.time);

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.time = inArgs.time;
	onResponse(retCode, current, inArgs, outArgs);

	//返回
	return ErrCode.SUCCESS;
};

// 已经在的玩家踢下线
exports.kickClient = function(inArgs) {
	clientCommunicator.kickClientOffline({"uuid" : inArgs.uuid, "area" : inArgs.area}, inArgs.myOnlineInfo.sessionId);
	clientCommunicator.closeClient(inArgs.myOnlineInfo.sessionId);
};

exports.kickClientOffline = function(inArgs, onResponse, current) {
	var retCode, outArgs;
	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = inArgs.uuid;
	outArgs.area = inArgs.area;
	// 回复调用
	onResponse(retCode, current, inArgs, outArgs);
	// 已经在的玩家踢下线
	exports.kickClient(inArgs);
};

exports.pushMsgToClient = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs;

	// 处理逻辑
	tiny.log.debug("pushMsgToClient", JSON.stringify(inArgs));

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = inArgs.uuid;
	outArgs.area = inArgs.area;
	outArgs.type = inArgs.type;
	outArgs.msg  = inArgs.msg;
	outArgs.state  = Const.LOGIN_ON;

	// 回复调用
	onResponse(retCode, current, inArgs, outArgs);

	// 回消息客户端
	clientCommunicator.recvMsgFromServer(outArgs, inArgs.yourSessionId);

	//返回
	return ErrCode.SUCCESS;
};

exports.pushMailToClient = function(inArgs, onResponse, current) {
	// 定义变量
	var outArgs;

	// 处理逻辑
	tiny.log.debug("pushMailToClient", JSON.stringify(inArgs));

	// 设置输出参数
	outArgs = {};
	outArgs.sender = inArgs.msg.sender;
	outArgs.title = inArgs.msg.title;
	outArgs.attach = inArgs.msg.attach;
	outArgs.id = inArgs.msg.id;
	// 回复调用
	// onResponse(retCode, current, inArgs, outArgs);

	// 回消息客户端
	clientCommunicator.getEmail(outArgs, inArgs.yourSessionId);

	//返回
	return ErrCode.SUCCESS;
};

exports.pushMsgToClientChannel = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, i;

	// 处理逻辑
	tiny.log.debug("pushMsgToClientChannel", JSON.stringify(inArgs));

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = inArgs.uuid;
	outArgs.area = inArgs.area;
	outArgs.type = inArgs.type;
	outArgs.msg  = inArgs.msg;
	outArgs.state  = Const.LOGIN_ON;

	// 回复调用
	onResponse(retCode, current, inArgs, outArgs);

	// 回消息客户端
	for (i = 0; i < inArgs.sessionIdList.length; i++) {
		clientCommunicator.recvMsgFromServer(outArgs, inArgs.sessionIdList[i]);
	}

	//返回
	return ErrCode.SUCCESS;
};

exports.pushMsgToClientArea = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, sessionIdList, id;

	// 处理逻辑
	tiny.log.debug("pushMsgToClientArea", JSON.stringify(inArgs));

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = inArgs.uuid;
	outArgs.area = inArgs.area;
	outArgs.type = inArgs.type;
	outArgs.msg  = inArgs.msg;
	outArgs.state  = Const.LOGIN_ON;

	// 回复调用
	onResponse(retCode, current, inArgs, outArgs);

	// 回消息客户端
	sessionIdList = getSessionData();
	for (id in sessionIdList) {
		if (sessionIdList.hasOwnProperty(id)) {
			tiny.log.error("...........", sessionIdList[id], inArgs.area, inArgs.uuid);
			if (sessionIdList[id].hasOwnProperty("area")
				&& sessionIdList[id].area === inArgs.area) {
				clientCommunicator.recvMsgFromServer(outArgs, sessionIdList[id].sessionId);
			}
		}
	}

	//返回
	return ErrCode.SUCCESS;
};

exports.pushMsgToClientAnnounce = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, sessionIdList, id;

	// 处理逻辑
	tiny.log.debug("pushMsgToClientAnnounce", JSON.stringify(inArgs));

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.uuid = inArgs.uuid;
	outArgs.area = inArgs.area;
	outArgs.type = inArgs.type;
	outArgs.msg  = inArgs.msg;
	outArgs.state  = Const.LOGIN_ON;

	// 回复调用
	onResponse(retCode, current, inArgs, outArgs);

	// 回消息客户端
	sessionIdList = getSessionData();
	for (id in sessionIdList) {
		if (sessionIdList.hasOwnProperty(id)) {
			tiny.log.error("...........", sessionIdList[id], inArgs.area, inArgs.uuid);
			clientCommunicator.recvMsgFromServer(outArgs, sessionIdList[id].sessionId);
		}
	}

	//返回
	return ErrCode.SUCCESS;
};

