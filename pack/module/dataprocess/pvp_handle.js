var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var Lru = require('../lru');
var PowerMatch = require('../config/pvp/powermatch');
var playerHandle = require('./player_handle');
var equipHandle = require('./equip_handle');
var Robot = require('../robot/robot');
var lru = require('../lru');
var Sequence;
/*
MyPvp = {
	ticketN;                         // sng门票
	ticketDay;                       // 积分
	ticketWeek;                      // 周赛门票
	fightCount;                      // 战斗次数
	startMark;                       // 开始战斗标志
	boxRewardCount;                  // 宝箱奖励进度
	fightInfoListSng;                // sng数据
	fightInfoListDay;                // 日赛数据
	fightInfoListWeek;               // 周赛数据
}
PvpSng = {
	id : 0,
	data1 : {
		keys : [],
		map : {},
	},
	data2 : {
		keys : [],
		map : {},
	},
	data3 : {
		keys : [],
		map : {},
	},
}
*/

var convertSequence = function(_seq) {
	var i, seq = {};
	for (i in _seq) {
		if (_seq.hasOwnProperty(i)) {
			if (!seq.hasOwnProperty(_seq[i].Teams)) {
				seq[_seq[i].Teams] = {};
				seq[_seq[i].Teams].weight = [];
				seq[_seq[i].Teams].index = [];
			}
			seq[_seq[i].Teams].weight.push(_seq[i].Odds);
			seq[_seq[i].Teams].index.push([_seq[i].Pep1, _seq[i].Pep2, _seq[i].Pep3]);
		}
	}
	//tiny.log.debug("convertSequence", JSON.stringify(seq));
	return seq;
};

var getSequence = function(_seq) {
	var seq;
	if (!Sequence) {
		Sequence = convertSequence(require('../config/pvp/sequence'));
	}
	seq = utils.randomScope(Sequence[_seq].index, Sequence[_seq].weight);
	tiny.log.debug("getSequence", Sequence[_seq], JSON.stringify(seq), _seq);
	return seq;
};

var robotPvpInfoCache = {};

var getPowerId = function(power) {
	/*
	var id, p = parseInt(power, 10);
	for (id in PowerMatch) {
		if (PowerMatch.hasOwnProperty(id)) {
			if (PowerMatch[id].MyPower[1] <= p
				&& p <= PowerMatch[id].MyPower[2]) {
				return id;
			}
		}
	}
	tiny.log.error("PowerMatch don't match", p);
	return 1;
	*/
	return parseInt(parseInt(power, 10) * 0.01, 10);
};

var checkJsonValue = function(_json, value) {
	var i;
	for (i in _json) {
		if (_json.hasOwnProperty(i)
			&& _json[i] === value) {
			return true;
		}
	}
	return false;
};

var getPowerIds = function(power, floor, ceil) {
	var f, c, pIds = {};
	f = getPowerId(parseInt(power * (100 + floor) * 0.01, 10));
	c = getPowerId(parseInt(power * (100 + ceil) * 0.01, 10));

	tiny.log.debug("getPowerIds", power, floor, ceil, f, c);

	while (f < c) {
		pIds[f] = f;
		f++;
	}

	return pIds;
};

var getSumPowerIds = function(power) {
	var id, p = parseInt(power, 10), pvpSng = {};
	for (id in PowerMatch) {
		if (PowerMatch.hasOwnProperty(id)) {
			if (parseInt(PowerMatch[id].MyPower[1],10) <= p
				&& p <= parseInt(PowerMatch[id].MyPower[2],10)) {
				pvpSng.power = p;
				pvpSng.id = id;
				pvpSng.seq = getSequence(PowerMatch[id].SequenceID);
				pvpSng.data1 = {
					reward : PowerMatch[id].Reward1,
					uuids : [],
				};
				pvpSng.data2 = {
					reward : PowerMatch[id].Reward2,
					uuids : [],
				};
				pvpSng.data3 = {
					reward : PowerMatch[id].Reward3,
					uuids : [],
				};
				pvpSng.data1.ids = getPowerIds(p, PowerMatch[id].Power1[1], PowerMatch[id].Power1[2]);
				pvpSng.data2.ids = getPowerIds(p, PowerMatch[id].Power2[1], PowerMatch[id].Power2[2]);
				pvpSng.data3.ids = getPowerIds(p, PowerMatch[id].Power3[1], PowerMatch[id].Power3[2]);
			}
		}
	}
	return pvpSng;
};

/*
*/

var getSearchPowerIdArray = function(pvpSng) {
	var j, i, ids = [];
	for (j = 1; j < 4; j++) {
		for (i in pvpSng["data"+j].ids) {
			if (pvpSng["data"+j].ids.hasOwnProperty(i)) {
				ids.push(pvpSng["data"+j].ids[i]);
			}
		}
	}
	return ids;
};

// 获取PvpSng
exports.getPvpSng = function(baseInfo, callback) {
	var i, ids = [], pvpSng = {}, ua = {area : baseInfo.area, uuid : baseInfo.uuid};
	pvpSng = getSumPowerIds(baseInfo.power);
	// 根据配置表生成搜索战斗力索引
	ids = getSearchPowerIdArray(pvpSng);
	tiny.log.debug("power index", JSON.stringify(ids));
	tiny.redis.hmget(utils.redisKeyGen("all", "power", "global"), ids, function(err, pvpSngList) {
		var pvpPower, count;
		if (err) {
			callback(err);
		} else {
			for (i = 0; i < pvpSngList.length; i++) {
				pvpPower = utils.getObject(pvpSngList[i]);
				if (pvpPower) {
					if (pvpPower.keys.length > 0) {
						tiny.log.debug("pvpPower", JSON.stringify(pvpPower));
						// 把自己的排除掉
						lru.aRemove(ua, pvpPower.keys);
						// 组成3个队列
						if (pvpSng.data1.ids.hasOwnProperty(pvpPower.id)) {
							pvpSng.data1.uuids.push(pvpPower.keys);
						}
						if (pvpSng.data2.ids.hasOwnProperty(pvpPower.id)) {
							pvpSng.data2.uuids.push(pvpPower.keys);
						}
						if (pvpSng.data3.ids.hasOwnProperty(pvpPower.id)) {
							pvpSng.data3.uuids.push(pvpPower.keys);
						}
					}
				}
			}
			tiny.log.error("pvpSngb:", JSON.stringify(ua), JSON.stringify(pvpSng));
			pvpSng.uuids1 = utils.randomArraySets(pvpSng.data1.uuids, pvpSng.seq[0]);
			pvpSng.uuids2 = utils.randomArraySets(pvpSng.data2.uuids, pvpSng.seq[1]);
			pvpSng.uuids3 = utils.randomArraySets(pvpSng.data3.uuids, pvpSng.seq[2]);

			count = pvpSng.uuids1.length;
			while (count < pvpSng.seq[0])  {
				pvpSng.uuids1.push({area : baseInfo.area, uuid : count+10, id : pvpSng.power * 0.8});
				count++;
			}
			count = pvpSng.uuids2.length;
			while (count < pvpSng.seq[1])  {
				pvpSng.uuids2.push({area : baseInfo.area, uuid : count+20, id : pvpSng.power});
				count++;
			}
			count = pvpSng.uuids3.length;
			while (count < pvpSng.seq[2])  {
				pvpSng.uuids3.push({area : baseInfo.area, uuid : count+30, id : pvpSng.power * 1.2});
				count++;
			}
			tiny.log.error("pvpSnga:", JSON.stringify(ua), JSON.stringify(pvpSng));
			// 取玩家数据
			exports.getPlayerPvpSng(pvpSng, function(err, newPvpSng) {
				if (err) {
					callback(err);
				} else {
					callback(null, newPvpSng);
				}
			});
		}
	});
};
/*
exports.getPvpSng = function(baseInfo, callback) {
	var id = getPowerId(baseInfo.power), i, ids = [], pvpSng = {}, tmp = {}, ids2 =[], ua = {area : baseInfo.area, uuid : baseInfo.uuid};
	for (i in PowerMatch[id].Power1) {
		if (PowerMatch[id].Power1.hasOwnProperty(i)) {
			ids.push(PowerMatch[id].Power1[i]);
		}
	}
	tiny.log.debug("power1", JSON.stringify(ids));
	for (i in PowerMatch[id].Power2) {
		if (PowerMatch[id].Power2.hasOwnProperty(i)) {
			ids.push(PowerMatch[id].Power2[i]);
		}
	}
	tiny.log.debug("power2", JSON.stringify(ids));
	for (i in PowerMatch[id].Power3) {
		if (PowerMatch[id].Power3.hasOwnProperty(i)) {
			ids.push(PowerMatch[id].Power3[i]);
		}
	}
	// 去重
	for (i = 0; i < ids.length; i++) {
		if (!tmp.hasOwnProperty(ids[i])){
			tmp[ids[i]] = ids[i];
			ids2.push(ids[i]);
		}
	}
	ids = ids2;
	tiny.log.debug("power3", JSON.stringify(ids));
	tiny.redis.hmget(utils.redisKeyGen("all", "power", "global"), ids, function(err, pvpSngList) {
		var pvpPower;
		if (err) {
			callback(err);
		} else {
			pvpSng.id = id;
			pvpSng.data1 = {
				id : PowerMatch[id].Power1[1],
				reward : PowerMatch[id].Reward1,
				uuids : [],
			};
			pvpSng.data2 = {
				id : PowerMatch[id].Power2[1],
				reward : PowerMatch[id].Reward2,
				uuids : [],
			};
			pvpSng.data3 = {
				id : PowerMatch[id].Power3[1],
				reward : PowerMatch[id].Reward3,
				uuids : [],
			};
			pvpSng.uuids1 = [];
			pvpSng.uuids2 = [];
			pvpSng.uuids3 = [];
			for (i = 0; i < pvpSngList.length; i++) {
				pvpPower = utils.getObject(pvpSngList[i]);
				if (pvpPower) {
					tiny.log.error("pvpPower", JSON.stringify(pvpPower));
					if (pvpPower.keys.length > 0) {
						if (checkJsonValue(PowerMatch[id].Power1, pvpPower.id)) {
							pvpSng.data1.uuids = pvpSng.data1.uuids.concat(pvpPower.keys);
						}
						if (checkJsonValue(PowerMatch[id].Power2, pvpPower.id)) {
							pvpSng.data2.uuids = pvpSng.data2.uuids.concat(pvpPower.keys);
						}
						if (checkJsonValue(PowerMatch[id].Power3, pvpPower.id)) {
							pvpSng.data3.uuids = pvpSng.data3.uuids.concat(pvpPower.keys);
						}
					}
				}
			}
			// 把自己的排除掉
			lru.aRemove(ua, pvpSng.data1.uuids);
			lru.aRemove(ua, pvpSng.data2.uuids);
			lru.aRemove(ua, pvpSng.data3.uuids);
			tiny.log.error("pvpSngb:", JSON.stringify(ua), JSON.stringify(pvpSng));
			// 1个1
			if (pvpSng.data1.uuids.length >= 1) {
				pvpSng.uuids1.push(utils.randomArray(pvpSng.data1.uuids));
			} else {
				// 机器人
				pvpSng.uuids1.push({area : baseInfo.area, uuid : 1, id : pvpSng.data1.id});
			}
			// 2个2
			if (pvpSng.data2.uuids.length >= 2) {
				pvpSng.uuids2 = utils.randomArrayN(pvpSng.data2.uuids, 2);
			} else {
				// 机器人
				pvpSng.uuids2.push({area : baseInfo.area, uuid : 2, id : pvpSng.data2.id});
				pvpSng.uuids2.push({area : baseInfo.area, uuid : 3, id : pvpSng.data2.id});
			}
			// 3个3
			if (pvpSng.data3.uuids.length >= 3) {
				pvpSng.uuids3 = utils.randomArrayN(pvpSng.data3.uuids, 3);
			} else {
				// 机器人
				pvpSng.uuids3.push({area : baseInfo.area, uuid : 4, id : pvpSng.data3.id});
				pvpSng.uuids3.push({area : baseInfo.area, uuid : 5, id : pvpSng.data3.id});
				pvpSng.uuids3.push({area : baseInfo.area, uuid : 6, id : pvpSng.data3.id});
			}
			tiny.log.error("pvpSnga:", JSON.stringify(ua), JSON.stringify(pvpSng));
			// 取玩家数据
			exports.getPlayerPvpSng(pvpSng, function(err, newPvpSng) {
				if (err) {
					callback(err);
				} else {
					callback(null, newPvpSng);
				}
			});
		}
	});
};
*/

var newFighter = function(playerInfo, reward) {
	var t = {};
	t.enemy = playerInfo;
	t.result = 0;
	t.seed = 0;
	t.ticketDay = reward;
	return t;
};

var getPlayerInfoN = function(newPvpSng, pvpSng, seq, i, end, callback) {
	// 1个1
	// 2个2
	// 3个3
	if (i < end) {
		tiny.log.debug("getPlayerInfoN", seq, i, end);
		exports.getPvpPlayerInfo(pvpSng["uuids" + seq][i], function(err, playerInfo) {
			if (err) {
				callback(err);
			} else {
				newPvpSng["fighterList" + seq].push(newFighter(playerInfo, PowerMatch[pvpSng.id]["Reward" + seq]));
				i = i + 1;
				getPlayerInfoN(newPvpSng, pvpSng, seq, i, end, callback);
			}
		});
	} else {
		tiny.log.debug("getPlayerInfoN end");
		callback(null);
	}
};

exports.getPlayerPvpSng = function(pvpSng, callback) {
	// 1个1
	// 2个2
	// 3个3
	var newPvpSng = {};
	newPvpSng.id = pvpSng.id;
	newPvpSng.fighterList1 = [];
	newPvpSng.fighterList2 = [];
	newPvpSng.fighterList3 = [];
	getPlayerInfoN(newPvpSng, pvpSng, 1, 0, pvpSng.seq[0], function(err) {
		if (err) {
			callback(err);
		} else {
			getPlayerInfoN(newPvpSng, pvpSng, 2, 0, pvpSng.seq[1], function(err) {
				if (err) {
					callback(err);
				} else {
					getPlayerInfoN(newPvpSng, pvpSng, 3, 0, pvpSng.seq[2], function(err) {
						if (err) {
							callback(err);
						} else {
							callback(null, newPvpSng);
						}
					});
				}
			});
		}
	});
};

// 设置PvpSng
exports.setPvpSng = function(baseInfo, callback) {
	var id = getPowerId(baseInfo.power), dataMap;
	tiny.log.debug("setPvpSng", id, baseInfo.power);
	tiny.redis.hget(utils.redisKeyGen("all", "power", "global"), id, function(err, data) {
		if (err) {
			callback(err);
		} else {
			if (data) {
				dataMap = utils.getObject(data);
			} else {
				dataMap = Lru.lruCreate(id);
			}
			Lru.lruSet({area : baseInfo.area, uuid : baseInfo.uuid}, dataMap);
			tiny.redis.hset(utils.redisKeyGen("all", "power", "global"), id, utils.setObject(dataMap), function(err) {
				if (err) {
					callback(err);
				} else {
					if (callback) {
						callback(null, dataMap);
					}
				}
			});
		}
	});
};

// 移除pvpSng
exports.removePvpSng = function(baseInfo, callback) {
	var id = getPowerId(baseInfo.power), dataMap, tmp;
	tiny.redis.hget(utils.redisKeyGen("all", "power", "global"), id, function(err, data) {
		if (err) {
			callback(err);
		} else {
			if (data) {
				dataMap = utils.getObject(data);
			} else {
				dataMap = Lru.lruCreate(id);
			}
			tiny.log.debug("removePvpSng", id, JSON.stringify(dataMap));
			tmp = {area : baseInfo.area, uuid : baseInfo.uuid};
			Lru.lruRemove(tmp, dataMap);
			tiny.redis.hset(utils.redisKeyGen("all", "power", "global"), id, utils.setObject(dataMap), function(err) {
				if (err) {
					callback(err);
				} else {
					if (callback) {
						callback(null, dataMap);
					}
				}
			});
		}
	});
};

// 获取pvpday
exports.getPvpDay = function(area, callback) {
	tiny.redis.get(utils.redisKeyGen(area, "pvpday", "area"), function(err, pvpDay) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpDay);
		}
	});
};

// 获取pvpWeek
exports.getPvpWeek = function(callback) {
	tiny.redis.get(utils.redisKeyGen("all", "pvpweek", "global"), function(err, pvpWeek) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpWeek);
		}
	});
};

// 获取globalInfo
exports.getGlobalInfo = function(callback) {
	tiny.redis.get(utils.redisKeyGen("all", "all", "global"), function(err, globalInfo) {
		if (err) {
			callback(err);
		} else {
			callback(null, globalInfo);
		}
	});
};

// 获取PvpInfo
exports.getPvpInfo = function(area, uuid, callback) {
	var key = utils.userAreaKey2(area, uuid);
	if (Robot.checkIsRobot(uuid)) {
		if (robotPvpInfoCache.hasOwnProperty(key)) {
			callback(null, robotPvpInfoCache[key]);
		} else {
			callback(null, exports.createRobotPvpInfo());
		}
	} else {
		tiny.redis.get(utils.redisKeyGen(area, uuid, "pvp"), function(err, pvpInfo) {
			if (err) {
				callback(err);
			} else {
				callback(null, pvpInfo);
			}
		});
	}
};

// 设置pvpday
exports.setPvpDay = function(area, pvpDay, callback) {
	tiny.redis.set(utils.redisKeyGen(area, "pvpday", "area"), pvpDay, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpDay);
		}
	});
};

// 设置pvpWeek
exports.setPvpWeek = function(pvpWeek, callback) {
	tiny.redis.set(utils.redisKeyGen("all", "pvpweek", "global"), pvpWeek, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpWeek);
		}
	});
};

// 设置PvpInfo
exports.setPvpInfo = function(area, uuid, pvpInfo, callback) {
	var key = utils.userAreaKey2(area, uuid);
	if (Robot.checkIsRobot(uuid)) {
		// 保存到缓存里面
		robotPvpInfoCache[key] = pvpInfo;
		callback(null, pvpInfo);
	} else {
		tiny.redis.set(utils.redisKeyGen(area, uuid, "pvp"),  pvpInfo, function(err) {
			if (err) {
				callback(err);
			} else {
				callback(null, pvpInfo);
			}
		});
	}
};

// 设置globalInfo
exports.setGlobalInfo = function(globalInfo, callback) {
	tiny.redis.set(utils.redisKeyGen("all", "all", "global"), globalInfo, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, globalInfo);
		}
	});
};

// 设置pvpdayNx
exports.setPvpDayNx = function(area, pvpDay, callback) {
	tiny.redis.setnx(utils.redisKeyGen(area, "pvpday", "area"), pvpDay, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpDay);
		}
	});
};

// 设置pvpWeekNx
exports.setPvpWeekNx = function(pvpWeek, callback) {
	tiny.redis.setnx(utils.redisKeyGen("all", "pvpweek", "global"), pvpWeek, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, pvpWeek);
		}
	});
};

// 设置globalInfoNx
exports.setGlobalInfoNx = function(globalInfo, callback) {
	tiny.redis.setnx(utils.redisKeyGen("all", "all", "global"), globalInfo, function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, globalInfo);
		}
	});
};

// 玩家数据转换成战斗数据
exports.getFightPlayerInfo = function(playerInfo) {
	var _playerInfo = playerInfo;
	_playerInfo.posList = null;
	_playerInfo.bagList = equipHandle.createRobotBagList();
	return _playerInfo;
};

// 添加取机器人步骤
exports.getPvpPlayerInfo = function(ua, callback) {
	var robot;
	if (Robot.checkIsRobot(ua.uuid)) {
		robot = Robot.getRobotPlayerInfo(ua);
		robot.userName = "robot";
		//tiny.log.debug("get Robot", robot.area, robot.uuid, robot.userName, JSON.stringify(robot));
		tiny.log.debug("get Robot", robot.area, robot.uuid, robot.userName);
		callback(null, exports.getFightPlayerInfo(robot));
	} else {
		playerHandle.getPlayerInfo(ua.area, ua.uuid, function(err, playerInfo) {
			if (err) {
				callback(err);
			} else {
				callback(null, exports.getFightPlayerInfo(playerInfo));
			}
		});
	}
};

exports.get1V1PlayerInfoS = function(ua1, ua2, callback) {
	exports.getPvpPlayerInfo(ua1, function(err, playerInfo1) {
		if (err) {
			callback(err);
		} else {
			exports.getPvpPlayerInfo(ua2, function(err, playerInfo2) {
				if (err) {
					callback(err);
				} else {
					callback(null, playerInfo1, playerInfo2);
				}
			});
		}
	});
};

exports.get1V1PlayerInfo = function(ua1, ua2, callback) {
	exports.getPvpPlayerInfo(ua1, function(err, playerInfo1) {
		if (err) {
			callback(err);
		} else {
			exports.getPvpInfo(ua1.area, ua1.uuid, function(err, pvpInfo1) {
				if (err) {
					callback(err);
				} else {
					exports.getPvpPlayerInfo(ua2, function(err, playerInfo2) {
						if (err) {
							callback(err);
						} else {
							exports.getPvpInfo(ua2.area, ua2.uuid, function(err, pvpInfo2) {
								if (err) {
									callback(err);
								} else {
									//tiny.log.debug("...", JSON.stringify(ua1), JSON.stringify(ua2), JSON.stringify(playerInfo1), JSON.stringify(playerInfo2));
									callback(null, playerInfo1, pvpInfo1, playerInfo2, pvpInfo2);
								}
							});
						}
					});
				}
			});
		}
	});
};

exports.set1V1PlayerInfo = function(ua1, ua2, pvpInfo1, pvpInfo2, callback) {
	exports.setPvpInfo(ua1.area, ua1.uuid, pvpInfo1, function(err) {
		if (err) {
			callback(err);
		} else {
			exports.setPvpInfo(ua2.area, ua2.uuid, pvpInfo2, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null);
				}
			});
		}
	});
};

// 创建机器人pvpInfo
exports.createRobotPvpInfo = function() {
	var pvpInfo = {};
	pvpInfo.ticketN = 5;
 	pvpInfo.ticketDay = 100;
	pvpInfo.ticketWeek = 0;
	pvpInfo.fightCount = 0;
	pvpInfo.startMark = Const.PVP_SNG_END;
	pvpInfo.box1 = 0;
	pvpInfo.box2 = 0;
	pvpInfo.box3 = 0;
	pvpInfo.myTime = 0;
	pvpInfo.refreshTime = 0;
	pvpInfo.dayMark = 0;
	pvpInfo.weekMark = 0;
	pvpInfo.fightInfoListSng = [];
	pvpInfo.fightInfoListDay = [];
	pvpInfo.fightInfoListWeek = [];
	return pvpInfo;
};

// 创建PvpInfo
exports.createPvpInfo = function(area, uuid, callback) {
	var pvpInfo = exports.createRobotPvpInfo();
	pvpInfo.ticketN = 5;
	pvpInfo.ticketDay = 0;
	exports.setPvpInfo(area, uuid, pvpInfo, callback);
};

// 创建PvpDay
exports.createPvpDay = function(area, callback) {
	var pvpDay = {};

	pvpDay.uuids = [];
	pvpDay.area = area;
	//pvpDay.rewardPool = 0;
	//pvpDay.nums = 0;
	//pvpDay.updateTime = utils.getDate();
 	pvpDay.pvpF8Result = {
 		playerInfoList : [],
 		fightList8     : [],
 		fightList4     : [],
 		fightList2     : [],
 		fightList1     : [],
 	};
	pvpDay.finalSort = [];
	exports.setPvpDayNx(area, pvpDay, callback);
};

// 创建PvpWeek
exports.createPvpWeek = function(callback) {
	var pvpWeek = {};

	pvpWeek.userArea = [];
	//pvpWeek.rewardPool = 0;
	//pvpWeek.nums = 0;
 	pvpWeek.pvpF8Result = {
 		playerInfoList : [],
 		fightList8     : [],
 		fightList4     : [],
 		fightList2     : [],
 		fightList1     : [],
 	};
	pvpWeek.finalSort = [];
	exports.setPvpWeekNx(pvpWeek, callback);
};

// 创建GlobalInfo
exports.createGlobalInfo = function(areas, callback) {
	var globalInfo = {}, i;

	globalInfo.pvpDay = {};
	for (i = 0; i < areas.length; i++) {
		globalInfo.pvpDay[areas[i]] = {
			rewardPool : 0,
			nums : 0,
			area : areas[i],
			maxCount : 0,
			updateTime : utils.getDate(),
		};
	}
	globalInfo.pvpWeek = {};
	globalInfo.pvpWeek.rewardPool = 0;
	globalInfo.pvpWeek.nums = 0;
	globalInfo.pvpWeek.maxCount = 0;
	exports.setGlobalInfoNx(globalInfo, callback);
};
