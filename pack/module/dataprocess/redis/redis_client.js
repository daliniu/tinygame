/*
存储使用msgpack压缩
经过测试序列化速度上： JSON.stringify > msgpack-js > msgpack > msgpack5
其中 msgpack-js 和 msgpack 对于字符串速度相当，对于 buffer 可能 msgpack 要快一些
对于易用程度，msgpack-js 和官网的 msgpack5 相当，msgpack 在压缩buffer的时候解压需要特殊处理，JSON.stringify 对buffer也需要特殊处理
综上 msgpack-js 最佳，如果发现性能存在问题，那么对于字符串压缩可使用 JSON.stringify
*/
var redis = require('redis');
var msgpack = require('msgpack-js');
var tiny = require('../../../tiny');
var utils = require('../../utils');

var config = require('../../../schema/db.json');

var client = redis.createClient(config["redis-master"].port, config["redis-master"].host,
	{ auth_pass: config["redis-master"].auth, return_buffers: false });
client.on('error', function(e) {
	tiny.log.error(e);
});
client.on('end', function() {
	tiny.log.error('masterredis server shutdown');
	client.quit();
});

var session = redis.createClient(config["redis-session"].port, config["redis-session"].host,
	{ auth_pass: config["redis-session"].auth, return_buffers: false });
session.on('error', function(e) {
	tiny.log.error(e);
});
session.on('end', function() {
	tiny.log.error('session redis server shutdown');
	session.quit();
});

module.exports.get = function(key, cb) {
	client.get(key, function(err, res) {
		if (cb) {
			if (res) {
				// res = msgpack.decode(res);
				res = JSON.parse(res);
			}
			cb(err, res);
		}
	});
};

module.exports.mget = function(keyList, cb) {
	client.mget(keyList, function(err, res) {
		if (cb) {
			if (res) {
				res.forEach(function(value, index, array) {
					array[index] = JSON.parse(value);
				});
			}
			cb(err, res);
		}
	});
};

module.exports.set = function(key, value, cb) {
	// var data = msgpack.encode(value);
	var data = JSON.stringify(value);
	client.set(key, data, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

module.exports.setnx = function(key, value, cb) {
	// var data = msgpack.encode(value);
	var data = JSON.stringify(value);
	client.setnx(key, data, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

module.exports.setex = function(key, value, second, cb) {
	// var data = msgpack.encode(value);
	var data = JSON.stringify(value);
	client.setex(key, second, data, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

module.exports.hset = function(key, field, value, cb) {
	client.hset(key, field, value, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

module.exports.hsetnx = function(key, field, value, cb) {
	client.hsetnx(key, field, value, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

module.exports.hget = function(key, field, cb) {
	client.hget(key, field, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.hdel = function(key, field, cb) {
	client.hdel(key, field, function(err) {
		if (cb) {
			cb(err);
		}
	});
};

//
// redis.hmset("ci", {'123': JSON.stringify(v), '234':JSON.stringify(v)}, p);
//
module.exports.hmset = function(key, value, cb) {
	client.hmset(key, value, function(err) {
		if (cb) {
			cb(err, value);
		}
	});
};

//
// redis.hmget("ci", ['123','sss','234'], pp);
//
module.exports.hmget = function(key, arrayFld, cb) {
	client.hmget(key, arrayFld, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.hgetall = function(key, cb) {
	client.hgetall(key, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.hexists = function(key, field, cb) {
	client.hexists(key, field, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.incr = function(key, cb) {
	client.incr(key, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.sadd = function(set, value, cb) {
	client.sadd(set, value, function(err) {
		if (cb) {
			cb(err);
		}
	});
};

module.exports.sinter = function(set1, set2, cb) {
	client.sinter(set1, set2, function(err, list) {
		if (cb) {
			cb(err, list);
		}
	});
};

module.exports.sdiff = function(set1, set2, cb) {
	client.sdiff(set1, set2, function(err, diff) {
		if (cb) {
			cb(err, diff);
		}
	});
};

module.exports.sunion = function(set1, set2, cb) {
	client.sunion(set1, set2, function(err, union) {
		if (cb) {
			cb(err, union);
		}
	});
};

module.exports.smove = function(source, dest, key, cb) {
	client.smove(source, dest, key, function(err) {
		if (cb) {
			cb(err);
		}
	});
};

module.exports.sismember = function(set, key, cb) {
	client.sismember(set, key, function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.smembers = function(set, cb) {
	client.smembers(set, function(err, values) {
		if (cb) {
			cb(err, values);
		}
	});
};

module.exports.sunionstore = function(dest, set1, set2, cb) {
	client.sunionstore(dest, set1, set2, function(err) {
		if (cb) {
			cb(err);
		}
	});
};

module.exports.multi = function(commandArr) {
	client.multi(commandArr).exec(function(err) {
		if (err) {
			tiny.log.error(err);
		}
	});
};

module.exports.bgrewriteaof = function() {
	client.bgrewriteaof();
};

module.exports.close = function() {
	client.quit();
	session.quit();
};

module.exports.createSId = function(cb) {
	session.incr('sessionid', function(err, res) {
		if (cb) {
			cb(err, res);
		}
	});
};

module.exports.addSession = function(sid, content, cb) {
	session.setex(sid, 12 * 60 * 60, JSON.stringify(content), function(err) {
		if (cb) {
			cb(err);
		}
	});
};

module.exports.delSession = function(sid) {
	session.del(sid);
};

module.exports.getSession = function(sid, cb) {
	session.get(sid, function(err, res) {
		if (cb) {
			if (res) {
				res = JSON.parse(res);
				cb(err, res);
			} else {
				cb("Session is null");
			}
		}
	});
};

module.exports.addOnlineInfo = function(area, uuid, content, cb) {
	session.hset(area, uuid, JSON.stringify(content), function(err) {
		if (cb) {
			cb(err);
		}
	});
};

module.exports.delOnlineInfo = function(area, uuid, cb) {
	session.hdel(area, uuid, cb);
};

module.exports.getOnlineInfo = function(area, uuid, cb) {
	session.hget(area, uuid, function(err, res) {
		if (cb) {
			if (res) {
				res = JSON.parse(res);
				cb(err, res);
			} else {
				cb("OnlineInfo is null");
			}
		}
	});
};

module.exports.createNamePool = function() {
	client.setnx("namePool", 1, function(err) {
		if (err) {
			tiny.log.info('createNamePool', err);
		} else {
			var namePool = {};
			tiny.log.trace('createNamePool ###################  = ', JSON.stringify(namePool));
			tiny.redis.hmset(utils.redisKeyGen("", "", "namePool"), namePool);
		}
	});
};

module.exports.getUUIDfromName = function(key, cb) {
	tiny.log.trace('getUUIDfromName', key);
	client.hget(utils.redisKeyGen("", "", "namePool"), key, function(err, data) {
		tiny.log.trace('getUUIDfromName 1');
		if (cb) {
			tiny.log.trace('getUUIDfromName 2');
			if (err) {
				tiny.log.trace('getUUIDfromName 3');
				cb(err);
			} else {
				tiny.log.trace('getUUIDfromName 4');
				cb(err, data);
			}
		}
	});
};

module.exports.setNameUUIDPair = function(key, uuid, cb) {
	client.hset(utils.redisKeyGen("", "", "namePool"), key, uuid, function(err, data) {
		if (cb) {
			if (err) {
				cb(err);
			} else {
				cb(err, data);
			}
		}
	});
};
