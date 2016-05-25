var Logger = require('./module/log/logHelper');
var utils = require('./module/utils');
var cmd = require('./module/cmd/cmd_process');
var mysqlClient = require('./module/dataprocess/mysql/mysql_client').init();
var redisClient = require('./module/dataprocess/redis/redis_client');

var server, cmd, myType;

exports.init = function(type) {
	myType = type;
	module.exports.type = type;
};

exports.start = function(id) {
	module.exports.id = id;
	module.exports.log = new Logger(id, myType);
	module.exports.mysql = mysqlClient;
	module.exports.redis = redisClient;
	server = require('./server/' + myType);
	if (server) {
		server.start();
		cmd.start();
	}
};

exports.set = function(setting, val) {
	module.exports[setting] = val;
};

exports.get = function(setting) {
	return module.exports[setting];
};

exports.configure = function(svrType, fn) {
	// if (utils.contains(svrType, myType, '|')) {
		fn();
	// }
};

exports.stop = function() {
	if (server) {
		server.stop();
	}
	if (cmd) {
		cmd.stop();
	}
	mysqlClient.shutdown();
	redisClient.close();
};
