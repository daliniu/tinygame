// ws
/*
抛出消息：data、destroy、end
*/
// var http = require('http').createServer();
var Ws = require('ws').Server;
var EventEmitter = require('events').EventEmitter;
var util = require('util');

var Parse = require('./parse');
var Session = require('./session');
var tiny = require('../../../tiny');

var _Websocket = function(host, port) {
	this.session = new Session();
	this.host = host;
	this.port = port;

	EventEmitter.call(this);
};

util.inherits(_Websocket, EventEmitter);

module.exports = _Websocket;

_Websocket.prototype.start = function() {
	var that = this;
	this.ws = new Ws({ port: this.port, host: this.host }, function() {
		tiny.log.info('服务器开始监听了：' + that.port);
	});

	this.ws.on('connection', function(client) {
		tiny.redis.createSId(function(err, sid) {
			if (err) {
				tiny.log.error('sid error: ' + err);
			} else {
				that.session.createSession(client, sid);
			}
		});
	});

	this.ws.on('error', function(e) {
		tiny.log.error('sio error: ' + e + e.stack);
	});

	this.session.on('destroy', function(sessionid) {
		that.emit('destroy', sessionid);
	});

	this.session.on('data', function(id, msgbuffer) {
		var pack = Parse.unpack(msgbuffer);
		if (pack) {
			tiny.log.trace('_Websocket', 'on data 2 = ', id, pack.msgid, pack.data);
			that.emit('data', id, pack);
		} else {
			tiny.log.error('protocol parse failed!');
		}
	});
	this.session.start();
};

// 用于游戏逻辑主动踢客户端下线
_Websocket.prototype.closeClient = function(id) {
	this.session.kick(id);
};

_Websocket.prototype.sendEx = function(id, msg) {
	var data = Parse.pack(msg);
	if (data) {
		this.session.send(id, data);
	} else {
		tiny.log.error('pack msg error');
	}
};

_Websocket.prototype.replyEx = function(id, msg) {
	var data = Parse.pack(msg);
	if (data) {
		this.session.reply(id, data);
	} else {
		tiny.log.error('pack msg error');
	}
};

_Websocket.prototype.stop = function() {
	this.ws.close();
	this.session.stop();
};
