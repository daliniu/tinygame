var rpc = require('../module/net/mdp/remote_proxy');
var pvpImp = require('./server_imp/pvp_imp');
var tiny = require('../tiny');

exports.start = function() {
	// 启动rpc连接
	tiny.log.debug("pvp", tiny.router, tiny.id, tiny.host);
	rpc.start(pvpImp);

	tiny.log.debug("|start|" + tiny.host);
};

exports.stop = function() {
	rpc.stop();

	tiny.log.debug("|stop|");
};

