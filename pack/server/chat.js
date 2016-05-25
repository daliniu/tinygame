var rpc = require('../module/net/mdp/remote_proxy');
var chatImp = require('./server_imp/chat_imp');
var tiny = require('../tiny');

exports.start = function() {
	// 启动rpc连接
	rpc.start(chatImp);

	tiny.log.debug("|start|" + tiny.host);
};

exports.stop = function() {
	rpc.stop();

	tiny.log.debug("|stop|");
};

