var zmq = require('zmq');
var moment = require('moment');

// var schedule = require('../module/schedule/schedule');
var Broker = require('../module/net/mdp/broker');
var mysql = require('../module/dataprocess/mysql/mysql_client').init();
var commandConfig = require('../schema/command.json');
var tiny = require('../tiny');

var broker, cmdPub, receiver, cmd;

function errorHandle(e) {
	tiny.log.error('error:' + e);
}

exports.start = function() {
	broker = new Broker(tiny.id, tiny.router, tiny.host);
	broker.open();
	broker.on('error', errorHandle);

	//cmdPub = zmq.socket('pub');
	//cmdPub.bindSync("tcp://" + commandConfig.routePub.host + ":" + commandConfig.routePub.port);

	//cmd = zmq.socket('dealer');
	//cmd.bindSync("tcp://" + commandConfig.cmdDealer.host + ":" + commandConfig.cmdDealer.port);
	//cmd.on('message', function(data) {
	//	cmdPub.send(data);
	//});

	//receiver = zmq.socket('sub');
	//receiver.subscribe("");
	//receiver.bindSync("tcp://" + commandConfig.routeSub.host + ":" + commandConfig.routeSub.port);
	//receiver.on('message', function(data) {
	//	cmd.send(data);
	//});

	// schedule.start();
};

exports.stop = function() {
	broker.close();
	cmd.close();
	cmdPub.close();
	// schedule.stop();
	// redis.close();
	delete this.broker;
};
