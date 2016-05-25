var Const = require("../../module/const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var LimitMap = require('../../module/utils').LimitMap;
var Const = require('../../module/const');
var rpc = require('../../module/net/mdp/remote_proxy');
var tiny = require('../../tiny');

var limitMap = new LimitMap(Const.CONN_SERVER_NUMS_LIMIT);
var expireTime = 0;
// 设置默认cache
var initConnServerCache = function() {
	limitMap.reset(Const.CONN_SERVER_NUMS_LIMIT);
	limitMap.set(tiny.DEFAULT_CONN_SERVER, {
											loadNums: Const.CONNECT_SERVER_LIMIT,
											connName: tiny.DEFAULT_CONN_SERVER,
											host: tiny.DEFAULT_CONN_IP,
											port: tiny.DEFAULT_CONN_PORT
										});
};

initConnServerCache();

// 初始化rpc调用器
var	communicator = rpc.initServer('conn');

// 初始化默认数据
// 本远程调用为广播调用, 获取ConnServer的玩家数量
//	callbackFunc = "adjustLoadNums";
// 	outArgs.uuid = uuid;
//	outArgs.loadNums = 100;
exports.getAvgConnServerLoadNums = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, chnlId, now, minServer = {}, connName;

	// 获取输入参数
	chnlId = inArgs.chnlId;

	// 处理逻辑
	tiny.log.debug("getAvgConnServerLoadNums", chnlId);

	// 远程调用获取各个conn负载量
	now = Date.now() / 1000;
	if (now - expireTime > Const.CACHE_EXPIRE_TIME) {
		//因为conn的数据需要非常实时所以这里把cache删除,并且重新设置默认值
		initConnServerCache();
		expireTime = now;
		// 广播调用各个conn
		//communicator.broadcast.getConnServerLoadNums(inArgs, 'adjustLoadNums');
		communicator.broadcast.getConnServerLoadNums(inArgs, current, function(outArgs) {
			// 定义变量
			var server = {}, loadNums, host, port;

			// 获取输入参数
			loadNums = outArgs.loadNums;
			connName = outArgs.connName;
			host = outArgs.host;
			port = outArgs.port;

			// 处理逻辑
			tiny.log.debug("getConnServerLoadNums", loadNums, connName, host, port);

			// 保存connServer负载量
			server.loadNums = loadNums;
			server.connName = connName;
			server.host = host;
			server.port = port;
			limitMap.set(connName, server);
		});
	}

	// 取最小值
	minServer.loadNums = Number.MAX_VALUE;
	for (connName in limitMap.map) {
		if (limitMap.map.hasOwnProperty(connName)
			&& limitMap.get(connName).loadNums < minServer.loadNums) {
			minServer = limitMap.get(connName);
		}
	}

	// 设置输出参数
	retCode = ErrCode.SUCCESS;
	outArgs = {};
	outArgs.host = minServer.host;
	outArgs.port = minServer.port;
	outArgs.loadNums = minServer.loadNums;
	minServer.loadNums += 1;
	onResponse(retCode, current, inArgs, outArgs);

	//返回
	return ErrCode.SUCCESS;
};


/*
// 以下由服务器调用
exports.adjustLoadNums = function(inArgs, onResponse, current) {
	// 定义变量
	var server = {}, loadNums, connName, host, port;

	// 获取输入参数
	loadNums = inArgs.loadNums;
	connName = inArgs.connName;
	host = inArgs.host;
	port = inArgs.port;

	// 处理逻辑
	tiny.log.debug("|adjustLoadNums|loadnums:" + loadNums + "|connName:" + connName + "|host:" + host + "|port:" + port);

	// 保存connServer负载量
	server.loadNums = loadNums;
	server.connName = connName;
	server.host = host;
	server.port = port;
	limitMap.set(connName, server);

	//返回
	return ErrCode.SUCCESS;
};
*/


// 以下由服务器调用

// exports.testRsponse = function(inArgs, onResponse, current) {

// 	// 处理逻辑
// 	tiny.log.debug("|testRsponse|inArgs:" + tiny.log.display(inArgs));

// 	//返回
// 	return ErrCode.SUCCESS;
// };
