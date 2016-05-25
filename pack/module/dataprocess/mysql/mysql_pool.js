// 单独把pool写成模块是为了防止创建了多个pool
var mysql = require('mysql');

var config = require('../../../schema/db.json');

exports.createMysqlPool = function() {
	return mysql.createPool({
		host : config.mysql.host,
		user : config.mysql.user,
		password : config.mysql.auth,
		database : config.mysql.dbname,
		connectionLimit : 10
	});
};
