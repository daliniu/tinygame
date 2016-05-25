// session管理
/*
设计原则是尽量把session模块独立化出来
使得任何需要session相关功能的模块都可以引用session然后自己管理
抛出消息：destroy、data
*/
var State = require('../../const').SESSION_STATE;
var EventEmitter = require('events').EventEmitter;
var util = require('util');
var zlib = require('zlib');
var tiny = require('../../../tiny');
var utils = require('../../utils');
var Queue = require('./queue');
var hangImp = require('../../fight/hangup_imp');

function destroy(sessionid) {
	if (this._sessionHandler.hasOwnProperty(sessionid) &&
		this._sessionHandler[sessionid].hasOwnProperty("_client")) {
		this._sessionHandler[sessionid]._client.close();
		delete this._sessionHandler[sessionid];
		this._connectNum = this._connectNum - 1;
		// 如果清除了socket，需要发出清除消息让外界知道，外界可以捕获信号
		this.emit('destroy', sessionid);
		// 清除OnlineInfo
		tiny.redis.getSession(sessionid, function(err, session) {
			if (!err) {
				//tiny.redis.delOnlineInfo(session.area, session.uuid);
				//设置离线挂机时间
				hangImp.setProAfkTime(session.area, session.uuid, function(err) {
					if (err) {
						tiny.log.debug("session setProAfkTime error");
					}
				});
			}
			// 清redis的session
			tiny.redis.delSession(sessionid);
		});
	}
}

/* 服务端心跳包维护
心跳包由客户端发送，客户端有两种实现选择，可以直接每隔1min发送一个，
也可以距离上一次正常数据发送后1min才开始发。两种实现对服务端都一样。

服务端在收到心跳包或者正常数据时，都去更新socket列表的lasthealth时间戳，
这个时间使用服务器上的时间，因为不信任客户端的时间，然后服务器上设置定时器，
每隔5min（时间可调）检查一下所有的socket列表lasthealth，如果发现lasthealth距离当前时间超过3min（时间可调），
则认为客户端断线了。同时服务器对客户端的每条协议包括心跳包都需要立刻回复。

客户端无论是发送正常数据还是心跳包，都开启个定时器检查，超时即认为和服务器断开连接，走重连处理
*/
// 据说这个版本的nodejs的interval不稳定，时间有差池而且会积累，待观察
function checkHealth() {
	var id,
		curTime = Date.now();
	for (id in this._sessionHandler) {
		if (this._sessionHandler.hasOwnProperty(id)) {
			if ((this._sessionHandler[id]._state === State.SESSION_NEED_CLEAR) ||
				((curTime - this._sessionHandler[id]._lasthealth) > this._HealthTime)) {
				destroy.call(this, id);
			}
		}
	}
}

// 使用方法是当作构造函数用
/*
healthTime:设置session的心跳超时时间
checkTime:心跳检查间隔
*/
var Session = function(healthTime, checkTime) {
	this._sessionHandler = {};
	this.maxConnections = 20000;
	// this._sessionid = 0;	// 递增，之后思考一种sessionid维护规则，可以回收淘汰的id
	this._connectNum = 0;
	this._HealthTime = 3 * 60 * 1000;	// 心跳超时时间
	if (healthTime && !isNaN(healthTime)) {
		this._HealthTime = healthTime;
	}
	if (checkTime && !isNaN(checkTime)) {
		this.checkTime = checkTime;
	} else {
		this.checkTime = 5 * 60 * 1000;	// 检查心跳时间
	}

	EventEmitter.call(this);
};

util.inherits(Session, EventEmitter);

module.exports = Session;

Session.prototype.start = function() {
	this.heartbeat = setInterval(checkHealth.bind(this), this.checkTime);
};

// session的清除有三处
// 一处是心跳检查（心跳超时，标记清除）
// 一处是客户端主动断开连接直接destroy
// 一处是用户手动调close直接destroy了
function listenEvent(sessionid) {
	if (this._sessionHandler[sessionid]) {
		var session = this._sessionHandler[sessionid],
			that = this,
			client = this._sessionHandler[sessionid]._client;

		if (client) {
			client.addEventListener('message', function(message) {
				session._queue.push(message.data);
				tiny.log.trace('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
				if (session._queue.getLength() === 1) {
					tiny.log.trace('listenEvent', 'emit a message', message.data, session._queue.first());
					that.emit('data', sessionid, session._queue.first());
				}

				session._lasthealth = Date.now();
			});

			client.addEventListener('error', function(e) {
				tiny.log.error('client error: ' + e);
			});

			client.addEventListener('close', function() {
				// 比较奇怪的是好像ws把close消息吞掉了
				tiny.log.info('服务器断开了一个客户端');
				destroy.call(that, sessionid);
			});
		}
	}
}

Session.prototype.createSession = function(client, sid) {
	// sessionid重复
	if (this._sessionHandler.hasOwnProperty(sid)) {
		// 由于无法创建正确的session，则拒绝客户端连接
		tiny.log.info('无法创建正确的session id，拒绝客户端连接');
		client.close();
		return;
	}
	if (this._connectNum >= this.maxConnections) {
		tiny.log.info('当前连接数目达到' + this._connectNum + '，拒绝客户端连接');
		client.close();
		return;
	}

	this._sessionHandler[sid] = {
		_state : State.SESSION_STATE_READY,
		_client : client,
		_lasthealth : Date.now(),
		_queue : new Queue()
	};

	this._connectNum = this._connectNum + 1;
	tiny.log.trace('创建了一个新的连接：', client._socket.remoteAddress, client._socket.remotePort, sid);
	tiny.log.info('当前连接数：' + this._connectNum);

	listenEvent.call(this, sid);
};

Session.prototype.getSessionState = function(sessionid) {
	if (this._sessionHandler[sessionid]) {
		return this._sessionHandler[sessionid]._state;
	}
	return null;
};

Session.prototype.send = function(sessionid, msg) {
	var session;
	if (this._sessionHandler.hasOwnProperty(sessionid)) {
		session = this._sessionHandler[sessionid];
		if (session.hasOwnProperty('_client') && (session._state === State.SESSION_STATE_READY)) {
			// 加密，压缩，计算长度
			session._client.send(msg);
		}
	}
};

Session.prototype.reply = function(sessionid, msg) {
	var session;
	if (this._sessionHandler.hasOwnProperty(sessionid)) {
		session = this._sessionHandler[sessionid];
		if (session.hasOwnProperty('_client') && (session._state === State.SESSION_STATE_READY)) {
			// 加密，压缩，计算长度
			session._client.send(msg);
		}
		// 检查下一条消息
		session._queue.shift();
		tiny.log.trace("reply", sessionid, session._queue.getLength(), session._queue.first());
		if (session._queue.getLength() > 0) {
			tiny.log.trace('reply', 'emit a message', sessionid, session._queue.first());
			this.emit('data', sessionid, session._queue.first());
		}
	}
};

Session.prototype.kick = function(sessionid) {
	destroy.call(this, sessionid);
};

Session.prototype.stop = function() {
	var id;
	clearInterval(this.heartbeat);
	for (id in this._sessionHandler) {
		if (this._sessionHandler.hasOwnProperty(id)) {
			destroy.call(this, id);
		}
	}
};
