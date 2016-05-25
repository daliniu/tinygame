/*
一个无id的请求端，
req自检，超时返回不再处理，
dealer异步发送，
消息超时不用通知worker
发送消息：[REQUEST, server, rid, data]
接收消息：[REPLY, rid, data] [DISCONNECT, rid] [DONE, rid] [NOEXISTS, rid]
*/
var uuid = require('node-uuid');
var zmq = require('zmq');
var util = require('util');
var EventEmitter = require('events').EventEmitter;

var tiny = require('../../../tiny');
var MDP = require('../../const').MDP;
var REQUEST = require('../../const').REQUEST_TYPE;
var utils = require('../../utils');

var DEFAULT_LIVENESS = 3;
var REQ_CHECKTIME = 2500;

var Request = function(type, timeout) {
	var liveness = DEFAULT_LIVENESS;
	this.type = type;

	if (timeout && (timeout >= 0)) {
		liveness = Math.floor(timeout / REQ_CHECKTIME);
	}
	this.liveness = liveness;

	EventEmitter.call(this);
};

util.inherits(Request, EventEmitter);

function checkReq() {
	var rid;
	for (rid in this.reqs) {
		if (this.reqs.hasOwnProperty(rid)) {
			--this.reqs[rid].liveness;
			if (this.reqs[rid].liveness < 0) {
				//this.reqs[rid].emit('timeout', rid);
				// tiny.log.info("|request.timeout and reconnect|rid:" + rid);
				delete this.reqs[rid];
			}
		}
	}
}

function _removeReq(rid) {
	if (this.reqs.hasOwnProperty(rid)) {
		delete this.reqs[rid];
	}
}

function addRequest(type, rid, timeout) {
	var req = new Request(type, timeout);
	this.reqs[rid] = req;
}

function sendMsg(server, msg, uniqueId) {
	if (!this.socket) {
		tiny.log.info("|sendMsg|socket is null");
		return null;
	}

	if (!server || !msg) {
		tiny.log.info("|sendMsg|can't find msg server or buffer is null");
		return null;
	}

	var rid;
	if (uniqueId === undefined) {
		rid = uuid.v4() + this.id;
	} else {
		rid = uniqueId;
	}

	if (msg.current === undefined) {
		msg.current = {};
	}
	msg.current.rid = rid;
	msg.current.serverName = server;

	this.socket.send([MDP.REQUEST, server, rid, JSON.stringify(msg)]);
	return rid;
}

var _request = function(router, id, host) {
	this.id = id;
	this.router = router;
	this.host = host;

	this.reqs = {};

	EventEmitter.call(this);
};

util.inherits(_request, EventEmitter);

module.exports = _request;

_request.prototype.open = function() {
	var that = this;

	this.socket = zmq.socket('dealer');
	this.socket.identity = 'request-' + this.id;
	this.socket.on('message', function(type, workid, rid, msg) {
		var data, typeId;
		typeId = parseInt(type, 10);
		//tiny.log.debug("|request.message|rid:" + rid + "|" + that.reqs[rid].liveness + "|" + type);
		// tiny.log.debug("|request.message|rid:" + rid + "|" + type);
		if (typeId === MDP.DISCONNECT) {
			tiny.log.info("|request.message|DISCONNECT|rid:" + rid + "|");
			that.emit('disconnect', "diconnect", rid, workid);
		} else if (typeId === MDP.DONE) {
			tiny.log.info("|request.message|DONE|rid:" + rid + "|");
			that.emit('done', rid);
		} else if (typeId === MDP.REPLY) {
			data = JSON.parse(msg);
			if (data) {
				data.current.rid = rid;
				// tiny.log.debug("|request.message|REPLY|rid:" + rid + "|" );
				that.emit('data', data);
			} else {
				tiny.log.error("|request.message|error msg|rid:" + rid + "|");
			}
		} else if (typeId === MDP.NOEXISTS) {
			tiny.log.error("|request.message|NOEXISTS|rid:" + rid + "|" + workid + "|");
		} else {
			// 报文格式错误
			tiny.log.error("|request.message|error type|rid:" + rid + "|");
		}
		// 清除保存的request状态
		if (rid) {
			_removeReq.call(that, rid);
		}
	});
	this.socket.on('error', function(e) {
		that.emit('error', e);
	});
	tiny.log.debug("host", this.host, "router", this.router);
	this.socket.connect('tcp://' + this.host + ':' + this.router);

	this.reqCheck = setInterval(checkReq.bind(this), REQ_CHECKTIME);
};

_request.prototype.close = function() {
	// tiny.log.info("|request.close" );
	var rid;
	clearInterval(this.reqCheck);
	if (this.socket) {
		this.socket.close();
		delete this.socket;
	}
	for (rid in this.reqs) {
		if (this.reqs.hasOwnProperty(rid)) {
			delete this.reqs[rid];
		}
	}
};

_request.prototype.send = function(server, msg, uniqueId, timeout) {
	var rid = sendMsg.call(this, server, msg, uniqueId);
	if (!rid) {
		return;
	}
	addRequest.call(this, REQUEST.POINT, rid, timeout);
	return rid;
};

_request.prototype.broadcast = function(server, msg) {
	var rid = sendMsg.call(this, 'all-' + server, msg);
	return rid;
};

