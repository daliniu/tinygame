var rpc = require('../module/net/mdp/remote_proxy');
var locImp = require('./server_imp/loc_imp');
var tiny = require('../tiny');

exports.start = function() {
	// 启动rpc连接
	rpc.start(locImp);

	tiny.log.debug("|start|" + tiny.host);
};

exports.stop = function() {
	rpc.stop();

	tiny.log.debug("|stop|");
};

