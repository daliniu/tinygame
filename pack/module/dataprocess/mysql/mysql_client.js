var utils = require('../../utils');
var tiny = require('../../../tiny');

var _pool;

var _mysql = {};

_mysql.init = function() {
	if (!_pool) {
		_pool = require('./mysql_pool').createMysqlPool();
	}
};

_mysql.query = function(sql, args, callback) {
	_pool.getConnection(function (err, handler) {
		if (!!err) {
			tiny.log.error('[mysql err]');
			tiny.log.error(err.code);
			tiny.log.error(err.fatal);
			tiny.log.error(err.stack);
			return;
		}
		handler.query(sql, args, function (err, result, fields) {
			_pool.releaseConnection(handler);
			utils.invokeCallback(callback, err, result, fields);
		});
	});
};

_mysql.shutdown = function() {
	if (_pool) {
		_pool.end();
	}
};


exports.init = function() {
	if (!!_pool) {
		return module.exports;
	}
	_mysql.init();
	module.exports.query = _mysql.query;
	return module.exports;
};

exports.shutdown = function() {
	_mysql.shutdown();
};
