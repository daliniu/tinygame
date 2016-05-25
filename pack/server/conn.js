var Websocket = require('../module/net/socket/websocket');
var rpc = require('../module/net/mdp/remote_proxy');
var connImp = require('./server_imp/conn_imp');
var msgProcess = require('../module/net/socket/protocol').process;
var tiny = require('../tiny');

var ws;

function destroyHandle(sessionid) {
	tiny.log.debug("|destroyHandle|" + sessionid);
}

function listenTcpMsg() {
	ws.on('data', msgProcess);
	ws.on('destroy', destroyHandle);
}

// function test() {
// 	rpc.callRemoteFunc('gate', 'getAvgConnServerLoadNums', {uuid:1001, area:'fly'}, 'testRsponse');
// }

exports.start = function() {
	// 客户端连接
	ws = new Websocket(tiny.host, tiny.port);
	listenTcpMsg();
	ws.start();

	// 启动rpc连接
	rpc.start(connImp, ws);

	tiny.log.info("|start|" + tiny.id + "|" + tiny.host +"|" + tiny.port);

	//test
	//setTimeout(test, 3000);
	//setTimeout(test, 6000);
};

exports.stop = function() {
	ws.stop();
	rpc.stop();

	tiny.log.debug("|stop|");
};

