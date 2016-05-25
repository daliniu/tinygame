var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');

exports.getRoleInfo = function(area, uuid, cb) {
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'roleinfo'), cb);
};

exports.createPlayer = function(area, uuid) {
	var player = [], key;
	player[0] = 1;	// lvl
	player[1] = 1000;	// coin
	player[2] = 0;	// gold
	player[3] = 0;	// vip

	tiny.redis.set(utils.redisKeyGen(area, uuid, 'baseinfo'), player);

	return player;
};

exports.updateRole = function(area, uuid, roles) {
	var roleProto = [], i, skill;
	roleProto[0] = role.id;
	roleProto[1] = role.lvl;
	roleProto[2] = role.modelid;
	roleProto[3] = role.exp;
	roleProto[4] = role.pos;
	roleProto[5] = [];
	for (i = 0; i < role.skill.length; ++i) {
		skill = [role.skill[i].id, role.skill[i].lvl, role.skill[i].pos];
		roleProto[5].push(skill);
	}

	tiny.redis.set(utils.redisKeyGen(area, uuid, 'baseinfo'), player);
}

