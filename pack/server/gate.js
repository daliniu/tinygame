var Websocket = require('../module/net/socket/websocket');
var rpc = require('../module/net/mdp/remote_proxy');
var gateImp = require('./server_imp/gate_imp');
var msgProcess = require('../module/net/socket/protocol').process;
var tiny = require('../tiny');
var redis = require('../module/dataprocess/redis/redis_client');
var equipHandle = require('../module/dataprocess/equip_handle');
var serial = require('../module/dataprocess/serialize/serialize');
var ws;


// setTimeout(function() {
// 	throw new Error('asdfasdf');
// }, 5000);

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
/*
function p(err, res) {
	if (err) {
		console.log("..........error:"+err);
	} else {
		//console.log("..........data:"+JSON.stringify(res));
		//console.log("..........data:"+JSON.stringify(res) );
		//console.log("........", JSON.stringify(res));
		console.log("........", res.toString());
		//for (var i in res) {
			//console.log(i, JSON.parse(res[i].toString()));
			//console.log(i, res[i].toString());
			//console.log(i, res[i]);
		//}
		//console.dir(res);
	}
}
function pp(err, res) {
	if (err) {
		console.log("..........error:"+err);
	} else {
		//console.log("..........data:"+JSON.stringify(res));
		//console.log("..........data:"+JSON.stringify(res) );
		//console.log("........", JSON.stringify(res));
		//console.log("........", res.toString());
		for (var i in res) {
			if (res[i] == null) {
				console.log('........null');
			} else {

			var tmp = JSON.parse(res[i].toString());
			console.log(i, JSON.parse(res[i].toString()));
			console.log(tmp['sss']);
			console.log(tmp['aaaa']);
			}
			//console.log(i, res[i].toString());
			//console.log(i, res[i]);
		}
		//console.dir(res);
	}
}
function ppp(err, res) {
	if (err) {
		console.log("..........error:"+err);
	} else {
		//console.log("..........data:"+JSON.stringify(res));
		//console.log("..........data:"+JSON.stringify(res) );
		//console.log("........", JSON.stringify(res));
		//console.log("........", res.toString());
			var tmp = JSON.parse(res.toString());
			console.log(tmp);
			console.log(tmp['sss']);
			console.log(tmp['aaaa']);
		//console.dir(res);
	}
}
*/

exports.start = function() {
	// 客户端连接
	ws = new Websocket(tiny.host, tiny.port);
	listenTcpMsg();
	ws.start();

	// 启动rpc连接
	rpc.start(gateImp, ws);

	tiny.log.info("|start|" + tiny.id + "|" + tiny.host +"|" + tiny.port);

/*
	//test
	//setTimeout(test, 3000);

	console.log(".......................");
	var v = {'sss':'aaa', 'aaaa':'bbbb'};

	//redis.hset("s", "111", JSON.stringify(v), p);
	//redis.hset("s", "222", JSON.stringify(v), p);
	//redis.hset("a", "test 1", v, p);
	//redis.hset("bbb", "3", "test 3 value", p);
	//redis.hvals("abcd", p);
	redis.hmset("ci", {'123': JSON.stringify(v), '234':JSON.stringify(v)}, p);
	//redis.hgetall("bbb", p);
	//redis.hgetall("c", pp);
	//redis.hget("c", "123", ppp);
	redis.hmget("ci", ['123','sss','234'], pp);
	redis.hvals("abc", function(err, replies) {
		replies.forEach(function (reply, i) {
            		console.log("    " + i + ": " + reply);
		});
    });
	var bagList = {
		"max" : 100,
		"itemList" : {
			19201 : {
				num : 2
			},
			15001 : {
				num : 30
			},
			15002 : {
				num : 30
			},
			16001 : {
				num : 4
			},
			16002 : {
				num : 1
			},
			16010 : {
				num : 1
			},
			17001 : {
				num : 1
			},
			17002 : {
				num : 1
			},
			17003 : {
				num : 1
			},
			17901 : {
				num : 500
			}
		},
		"equipList" : {
			// 装备
			10103 : {
				id : 10103,
				num : 1,
				star : 0,
				a1 : 2, n1 : 999,
				a2 : 5, n2 : 20,
				a3 : 6, n3 : 111,
				a4 : -1, n4 : 0,
				sa : 0, sn : 0
			},
			10102 : {
				id : 10102,
				num : 1,
				star : 1,
				a1 : 1, n1 : 20,
				a2 : 0, n2 : 0,
				a3 : 0, n3 : 0,
				a4 : -1, n4 : 0,
				sa : 0, sn : 0
			},
			10101 : {
				id : 10102,
				num : 1,
				star : 0,
				a1 : 1, n1 : 20,
				a2 : 1, n2 : 20,
				a3 : 1, n3 : 20,
				a4 : 1, n4 : 20,
				sa : 0, sn : 0
			}
		}
	};
	var ss = serial.serialize('bagList', bagList);
	var sss = serial.unserialize('bagList', ss);
	console.log('serial.......................', ss);
	console.log('unserial.......................', sss);

	var playerInfo = {}, teamList = {};

	playerInfo.uuid = 'sss';
	playerInfo.area = 1;
	playerInfo.userName = "ssdfw";
	playerInfo.level = 1;
	playerInfo.curExp = 0;
	playerInfo.action = 100;
	playerInfo.gold = 99999999;
	playerInfo.vip = 0;
	playerInfo.diamond = 100;
	playerInfo.posList = {
		1 : {
			"heroId" : 10004,
			"pos"    : 4,
			"equipIdList" : {1 : 10103, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		},
		2 : {
			"heroId" : 10005,
			"pos"    : 5,
			"equipIdList" : {1 : 0, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		},
		3 : {
			"heroId" : 10006,
			"pos"    : 6,
			"equipIdList" : {1 : 0, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		}
	};

	var aa = serial.serialize('playerInfo', playerInfo);
	var bb = serial.unserialize('playerInfo', aa);
	console.log('serial.......................', JSON.stringify(aa));
	console.log('unserial.......................', JSON.stringify(bb));

	console.log("..........................", Date.now());

	console.log("equip id ......................", equipHandle.createEquip(111));
*/
};

exports.stop = function() {
	ws.stop();
	rpc.stop();

	tiny.log.info("|stop|");
};

