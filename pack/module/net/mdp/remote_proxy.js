var Const = require("../../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var LimitMap = require('../../utils').LimitMap;
var Request = require('./request');
var Worker = require('./worker');
var Parse = require('../socket/parse');
var tiny = require('../../../tiny');
//var domainServer = require('domain').create();
var domain = require('domain');
/*

*/

var request, worker, impHandler, tcpCommunicator;

// 保存请求回调函数缓存
var callbackCache = new LimitMap(100);

function errorHandle(err) {
	tiny.log.error("|errorHandle|" + err);
}

//RPC回调
function onResponse(retCode, current, inArgs, outArgs) {
    // 调用完成后回包

    var msg = {};
    // 打包数据,设置参数
    msg.funcName = current.callbackFunc;
    msg.outArgs = outArgs;
    msg.retCode = retCode;
    msg.current = current;


    if (msg.current.clientRequest === true && tcpCommunicator) {
		// 设置返回码
		outArgs.retCode = retCode;
		tiny.log.info(retCode, current.clientCallFunc, "in:", JSON.stringify(inArgs), "out:", JSON.stringify(outArgs));

		if (current.hasOwnProperty("funcId")) {
    		tcpCommunicator.replyEx(current.sessionId, {"funcId"     : current.funcId,
    												    "args"       : outArgs,
    												    "retCode"    : retCode,
    												    "funcName"   : current.clientCallFunc,
    												    "serverName" : current.serverName});
		} else {
			tiny.log.error('found no function id');
		}
    } else {
		tiny.log.info(retCode, current.funcName, "in:", JSON.stringify(inArgs), "out:", JSON.stringify(outArgs));
    	worker.reply(msg.current.rid, msg);
    }
}

// RPC分发调用
function onDispatch(msg) {
   	// 解包数据,获取参数
   	var domainServer,
   		errorRsp,
   		funcName = msg.funcName,
		inArgs = msg.inArgs,
		outArgs = msg.outArgs,
		retCode = msg.retCode,
		// 保存调用状态
		// rid, serverName, sessionId
		current = msg.current,
		callback;
   		current.funcName = funcName;
   		current.callbackFunc = msg.callbackFunc;

	try {
		// 设置返回码
		if (retCode !== undefined) {
			// 针对回调情况设置
			outArgs.retCode = retCode;
		}

		// 没有设置函数名
		callback = callbackCache.get(current.rid);
		if (!funcName && !callback) {
			tiny.log.error("|onDispatch|ErrorCode:" + ErrCode.UNDEFINED_FUNCTION);
			onResponse(ErrCode.UNDEFINED_FUNCTION, current, {}, {});
			return ErrCode.UNDEFINED_FUNCTION;
		}

		// 创建domain对象
   		domainServer = domain.create();

   		// 异常处理函数
		errorRsp = function(err) {
			var curr;
			tiny.log.error('onDispatch', err.stack);
			if (callback) {
				curr = callback.curr;
			} else {
				curr = current;
			}
			// 回包调用函数名错误
			if (err instanceof TypeError) {
				onResponse(ErrCode.ERROR_FUNCTION_NAME, curr, {}, {});
				return ErrCode.ERROR_FUNCTION_NAME;
			}
			onResponse(ErrCode.ERROR_UNEXCEPT, curr, {}, {});
			return ErrCode.ERROR_UNEXCEPT;
		};

		// 异常逻辑
		domainServer.on('error', errorRsp);

		// 正常业务逻辑
		domainServer.run(function() {
			// 回调函数处理流程
			if (retCode !== undefined && retCode === ErrCode.SUCCESS) {
				if (callback) {
					callback.func(outArgs, onResponse, current);
				} else {
					impHandler[funcName](outArgs, onResponse, current);
				}
			} else if (retCode !== undefined && retCode !== ErrCode.SUCCESS) {
				tiny.log.error("|onDispatch|ErrorCode:" + retCode);
				if (callback) {
					callback.func(outArgs, onResponse, current);
				} else {
					impHandler[funcName](outArgs, onResponse, current);
				}
			} else {
    			// 报文格式 json
    			// 报文格式 返回调用方 funcName 输入参数(json格式) callbackId 返回码 输出参数(json格式)
    			tiny.log.trace('onDispatch, funcName', funcName);
				impHandler[funcName](inArgs, onResponse, current);
			}
		});

	} catch (err) {
		errorRsp(err);
	}

	// 成功返回
	return ErrCode.SUCCESS;
}

exports.start = function(Imp, tcp) {
	// 开启请求连接
	request = new Request(tiny.router, tiny.id, tiny.host);
	request.on('error', errorHandle);
	request.on('data', onDispatch);
	// request.on('done', donetHandle);
	// request.on('disconnect', disconnectHandle);
	request.open();

	//开启工作连接
	worker = new Worker(tiny.router, tiny.host, tiny.id, tiny.type);
	worker.on('data', onDispatch);
	worker.on('error', errorHandle);
	worker.open();

	tcpCommunicator = tcp;
	impHandler = Imp;
	if (!impHandler) {
		impHandler = {};
	}
	impHandler.clientResponse = function(outArgs, onResponse, current) {
		current.clientRequest = true;
		onResponse(outArgs.retCode, current, {}, outArgs);
		/*
		// 远程调用回复客户端
		var rspMsgId = Parse.getRspMsgId(current.msgId);
		// test begin
		if (current.hasOwnProperty("funcId")) {
			tiny.log.error("re...............");
    		tcpCommunicator.replyEx(current.sessionId, {"funcId" : current.funcId,
    												  "args"   : outArgs,
    												  "retCode" : outArgs.retCode,
    												  "funcName" : current.funcName,
    												  "serverName" : current.serverName});
    		return;
		}
		// test end
		if (current.sessionId && rspMsgId && tcpCommunicator) {
    		tiny.log.debug("|" + current.funcName + "|" + JSON.stringify(outArgs));
    		//tiny.log.debug("|onResponse.tcp|sessionid:" + current.sessionId + "|rspMsgId:" + rspMsgId + "|" + JSON.stringify(outArgs));
    		tcpCommunicator.reply(current.sessionId, rspMsgId, outArgs);
		} else {
    		tiny.log.info("|onResponse.tcp|can't send back RspMsg|current:" + JSON.stringify(current));
		}
		*/
	};
};

exports.stop = function() {
	request.close();
	worker.close();
};

//RPC调用
exports.callRemoteFunc = function(serverName, funcName, inArgs, callbackFunc, current) {
    // 调用完成后回包
    // tiny.log.debug("|callRemoteFunc|" + serverName + "|" + funcName + "|" + tiny.log.display(inArgs) + "|" + callbackFunc);

    var msg = {}, rid;
    msg.serverName = serverName;
    msg.funcName = funcName;
    msg.inArgs = inArgs;
    msg.callbackFunc = callbackFunc;

    if (request) {
    	rid = request.send(serverName, msg);
    	if (typeof callbackFunc  === 'function') {
    		callbackCache.set(rid, {"curr" : current, "func" : callbackFunc});
    	}
    }
};

// RPC调用广播
exports.callRemoteFuncAll = function(serverName, funcName, inArgs, callbackFunc, current) {
    // 调用完成后回包
    // tiny.log.debug("|callRemoteFuncAll|" + serverName + "|" + funcName + "|" + tiny.log.display(inArgs) + "|" + callbackFunc);

    var msg = {}, rid;
    msg.serverName = serverName;
    msg.funcName = funcName;
    msg.inArgs = inArgs;
    msg.callbackFunc = callbackFunc;

    if (request) {
    	rid = request.broadcast(serverName, msg);
    	if (typeof callbackFunc  === 'function') {
    		callbackCache.set(rid, {"curr" : current, "func" : callbackFunc});
    	}
    }
};

// 处理客户端消息
module.exports.processClient = function(msg) {
	request.emit('data', msg);
};

// 处理客户端消息调用其他的server
module.exports.processClientToOtherServer = function(serverName, msg) {
	if (request) {
    	request.send(serverName, msg);
    }
};

// 处理客户端消息调用其他的server
module.exports.initServer = function(serverName) {
	/*
	var serverImp = require('../../../server/server_imp/' + serverName + '_imp'),
	func, ret, rpcCallback, rpcCallbackAll, msgId, current, i;

	ret = {};
	ret.broadcast = {};

	rpcCallback = function() {
		var that = this, inArgs = {}, callbackFunc = '';
		tiny.log.debug('|....|' + JSON.stringify(that) + '|');

		for (i = 0; i < that.inArgs.length; i++) {
			inArgs[that.inArgs[i]] = arguments[i];
		}

		if (arguments[that.inArgs.length-1] !== undefined) {
			callbackFunc = arguments[that.inArgs.length-1];
		}

		tiny.log.debug('|....|' + JSON.stringify(inArgs) + '|' + callbackFunc);

		exports.callRemoteFunc(serverName, that.funcName, inArgs, callbackFunc);
	};

	rpcCallbackAll = function(inArgs, callbackFunc) {
		var funcName = this;
		exports.callRemoteFuncAll(serverName, funcName, inArgs, callbackFunc);
	};

	for (func in serverImp) {
		if (serverImp.hasOwnProperty(func)) {

			tiny.log.debug('|initServer|' + func + '|');
			current = {};
			current.inArgs = [];

			for (msgId in proto) {
				if (proto.hasOwnProperty(msgId) && proto[msgId].func !== undefined && proto[msgId].func[0] === func) {
					tiny.log.debug('.......' + JSON.stringify(proto[msgId].keys));
					for (i = 0; i < proto[msgId].keys.length; i++) {
						current.inArgs[i] = proto[msgId].keys[i];
					}
					break;
				}
			}
			current.funcName = func;
			ret[func] = rpcCallback.bind(current);
			ret.broadcast[func] = rpcCallbackAll.bind(func);
		}
	}

	tiny.log.debug('|initServer|' + JSON.stringify(ret) + '|');
*/
	var serverImp, serialProto,
	func, ret, rpcCallback, rpcCallbackAll, clientCallback;

	ret = {};
	ret.serverName = serverName;
	ret.defaultServer = serverName;
	ret.broadcast = {};

	if (serverName === "client") {

		serialProto = require('../../dataprocess/serialize/serial_proto');

		clientCallback = function(outArgs, sessionId) {
			var funcName = this;
			tiny.log.info(ErrCode.SUCCESS, funcName, "in:", "{}", "out:", JSON.stringify(outArgs));
			tcpCommunicator.sendEx(sessionId, {"funcId"     : 0,
	    										"args"       : outArgs,
	    										"retCode"    : ErrCode.SUCCESS,
	    										"funcName"   : funcName,
	    										"serverName" : "client"});
		};

		if (serialProto && serialProto.interface && serialProto.interface.client) {
			for (func in serialProto.interface.client) {
				if (serialProto.interface.client.hasOwnProperty(func)
					&& serialProto.interface.client[func].hasOwnProperty("outArgs")) {
					ret[func] = clientCallback.bind(func);
					tiny.log.debug('initServer', func);
				}
			}
		}

		ret.closeClient = function(sessionId)
		{
			// 将玩家踢下线
			tcpCommunicator.closeClient(sessionId);
		};

		tiny.log.debug('initServer', JSON.stringify(ret));

		return ret;
	}

	serverImp = require('../../../server/server_imp/' + serverName + '_imp');

	rpcCallback = function(inArgs, current, callbackFunc) {
		var funcName = this;
		//tiny.log.debug(ret.serverName, funcName);
		exports.callRemoteFunc(ret.serverName, funcName, inArgs, callbackFunc, current);
	};

	rpcCallbackAll = function(inArgs, current, callbackFunc) {
		var funcName = this;
		exports.callRemoteFuncAll(ret.defaultServer, funcName, inArgs, callbackFunc, current);
	};

	ret.hashServer = function(num) {
		ret.serverName = serverName + "-" + num;
		return ret;
	};

	ret.setServer = function(serverName) {
		ret.serverName = serverName;
		return ret;
	};

	ret.getServer = function() {
		return ret.serverName;
	};

	for (func in serverImp) {
		if (serverImp.hasOwnProperty(func)) {

			tiny.log.debug('initServer', func);

			ret[func] = rpcCallback.bind(func);
			ret.broadcast[func] = rpcCallbackAll.bind(func);
		}
	}

	if (serverName === "conn") {
		ret.kickClientOffline = rpcCallback.bind("kickClientOffline");
		ret.broadcast.kickClientOffline = rpcCallbackAll.bind("kickClientOffline");
	}

	tiny.log.debug('initServer', JSON.stringify(ret));

	return ret;
/*
*/

};
