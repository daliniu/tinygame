var tiny = require('../../tiny');
var Const = require("../const");
var ConstMap = Const.MAP;
var MapElement = ConstMap.ELEMENT_STATE;
var moment = require('moment');
// 配置表
// var GuaJi = require('../config/exploration/guaji');
var WorldMap = require('../config/map/worldmap');
var MapInfo = require('../config/map/mapinfo');
var utils = require('../utils');
var Afkreward = require('../config/map/afkreward');
var Map = require('../map/map');
var Item = require('../config/pick/item');

// var convertItemBox = function(box) {
// 	var i;
// 	for (i in box) {
// 		if (box.hasOwnProperty(i)) {
// 			box[i].itemid = utils.jsonToArray(box[i].itemid);
// 		}
// 	}
// 	//tiny.log.error('box..................', JSON.stringify(box));
// 	return box;
// };
// var Itembox = convertItemBox(require('../config/pick/itembox'));

// // 判断挂机点是否是限时挂机点4，5，如果是则设置上一挂机点状态
// exports.changeAfk = function(afkObj, mapid, uid, name, curAkfMapInfo) {
// 	var curAfk = afkObj.curAfker, type;
// 	tiny.log.trace('changeAfk = ', JSON.stringify(afkObj), mapid, uid, name, JSON.stringify(curAkfMapInfo));

// 	if (!curAfk) {
// 		return false;
// 	}

// 	// 相同挂机点迁移不做处理
// 	if (curAfk.mapid === mapid && curAfk.uid === uid && curAfk.guajiid === name) {
// 		return true;
// 	}

// 	// 设置当前挂机点状态
// 	if (GuaJi.hasOwnProperty(curAfk.guajiid)) {
// 		type = GuaJi[curAfk.guajiid].ElementType;
// 		if (parseInt(type, 10) === ConstMap.MAP_UID_TYPE.TIME_AFK) {
// 			if (curAkfMapInfo.uidList.hasOwnProperty(curAfk.uid)) {
// 				curAkfMapInfo.uidList[curAfk.uid].state = MapElement.TIME_AFK.CLOSE;
// 			}
// 		}
// 		if (parseInt(type, 10) === ConstMap.MAP_UID_TYPE.TIME_BOSS_AFK) {
// 			if (curAkfMapInfo.uidList.hasOwnProperty(curAfk.uid)) {
// 				curAkfMapInfo.uidList[curAfk.uid].state = MapElement.TIME_BOSS_AFK.CLOSE;
// 			}
// 		}

// 		if (parseInt(type, 10) === ConstMap.MAP_UID_TYPE.NOR_AFK) {
// 			afkObj.lastNorAfk = afkObj.curAfker;
// 		}
// 	}
// 	afkObj.curAfker = {};
// 	afkObj.curAfker.mapid = mapid;
// 	afkObj.curAfker.uid = uid;
// 	afkObj.curAfker.guajiid = name;
// 	afkObj.beginAfkTime = Date.now();
// 	afkObj.proAfkTime = afkObj.beginAfkTime;
// 	if (!afkObj.afkList.hasOwnProperty(mapid)) {
// 		afkObj.afkList[mapid] = {};
// 	}
// 	afkObj.afkList[mapid][uid] = 1;
// 	return true;
// };

// exports.backLastNormalAfk = function(afkObj, curAkfMapInfo) {
// 	var curAfk = afkObj.curAfker, type;
// 	if (GuaJi.hasOwnProperty(curAfk.guajiid)) {
// 		type = GuaJi[curAfk.guajiid].ElementType;
// 		if (parseInt(type, 10) === ConstMap.MAP_UID_TYPE.TIME_AFK) {
// 			if (curAkfMapInfo.uidList.hasOwnProperty(curAfk.uid)) {
// 				curAkfMapInfo.uidList[curAfk.uid].state = MapElement.TIME_AFK.CLOSE;
// 			}
// 		}
// 		if (parseInt(type, 10) === ConstMap.MAP_UID_TYPE.TIME_BOSS_AFK) {
// 			if (curAkfMapInfo.uidList.hasOwnProperty(curAfk.uid)) {
// 				curAkfMapInfo.uidList[curAfk.uid].state = MapElement.TIME_BOSS_AFK.CLOSE;
// 			}
// 		}
// 		afkObj.curAfker = afkObj.lastNorAfk;
// 		afkObj.beginAfkTime = Date.now();
// 		afkObj.proAfkTime = afkObj.beginAfkTime;
// 	}
// };

// exports.proAfkTimeChange = function(afkObj, time) {
// 	var curAfk = afkObj.curAfker;
// 	if (GuaJi.hasOwnProperty(curAfk.guajiid)) {
// 		afkObj.proAfkTime = time;
// 	}
// };

exports.calOfflineProfit = function(akfrewardid, offTime, result) {
	// 判断当前挂机点是否限时挂机点
	// 计算时间
	// 判断时间 是否需要2段计算
	// 限时只能打一次，以后再也不能打
	//
	var gold, exp, action, num, count, itemScope, itemId, splitList = {}, i, bon = 1;

	// 计算逻辑
	num = Math.floor(offTime / (Afkreward[akfrewardid].offlineinterval));

	// 额外数值加成
	// if (isAdd)
	// {
	// 	bon += Afkreward[pointId].bonuses / 100;
	// 	tiny.log.debug("..............bon", bon);
	// }
	gold   =  parseInt(num * Afkreward[akfrewardid].offlinegold, 10);
	exp    = parseInt(num * Afkreward[akfrewardid].offlineexp, 10);
	// action = parseInt(num * Afkreward[pointId].offlineap * bon, 10);

	// 随机道具盒子ID
	// for (i in Afkreward[pointId].offlineitem) {
	// 	if (Afkreward[pointId].offlineitem.hasOwnProperty(i)) {
	// 		// 奖励次数
	// 		count = Math.floor(Afkreward[pointId].offlineitem[i][2] * num / 100);
	// 		// 道具盒子数组
	// 		itemScope = Itembox[Afkreward[pointId].offlineitem[i][1]].itemid;
	// 		// 检查道具盒子长度
	// 		if (itemScope.length > 0) {
	// 			// 随机道具ID
	// 			i = utils.randomInt(0, itemScope.length - 1);
	// 			itemId = itemScope[i];
	// 			splitList[itemId] = {};
	// 			splitList[itemId].num = count;
	// 			splitList[itemId].id = itemId;
	// 		}
	// 	}
	// }

	result.gold = gold;
	result.exp = exp;
	// result.action = action;
	result.offTime = offTime;
	// result.splitList = splitList;

	return result;
};

exports.calOnlineProfit = function(akfrewardid, result) {
	var pointId, gold, exp, action, indexScope = [], weightScope = [],
		itemScope, itemId, splitList = {}, i, bon = 1, index;

	// if (newPointId) {
	// 	tiny.log.debug(" new guideline ", newPointId);
	// 	pointId = newPointId;
	// } else {
	// 	pointId = norPointId;
	// }

	// if (isAdd)
	// {
	// 	bon += Afkreward[pointId].bonuses / 100;
	// 	tiny.log.debug("..............bon", bon);
	// }
	gold   = parseInt(Afkreward[akfrewardid].onlinegold, 10);
	exp    = parseInt(Afkreward[akfrewardid].onlineexp, 10);
	// action = parseInt(Afkreward[pointId].onlineap * bon, 10);

	// 随机道具盒子ID
	// for (i in Afkreward[pointId].onlineitem) {
	// 	if (Afkreward[pointId].onlineitem.hasOwnProperty(i)) {
	// 		indexScope.push(Afkreward[pointId].onlineitem[i][1]);
	// 		weightScope.push(Afkreward[pointId].onlineitem[i][2]);
	// 	}
	// }
	// 根据奖励次数随机道具，在线逻辑
	// 随机道具盒子ID
	// index = utils.randomScope(indexScope, weightScope);
	// itemScope = Itembox[index].itemid;
	// // 检查道具盒子长度
	// if (itemScope.length <= 0) {
	// 	// 该战斗获取不到奖励
	// 	splitList = null;
	// } else {
	// 	// 随机道具ID
	// 	itemId = utils.randomArrayN(itemScope, 1);
	// 	// 检查道具ID
	// 	if (!Item.hasOwnProperty(itemId)) {
	// 		return null;
	// 	}
	// 	// 生成道具列表
	// 	if (!splitList.hasOwnProperty(itemId)) {
	// 		splitList[itemId] = {};
	// 		splitList[itemId].num = 1;
	// 	} else {
	// 		splitList[itemId].num = splitList[itemId].num + 1;
	// 	}
	// 	splitList[itemId].id = itemId;
	// }

	result.gold = gold;
	result.exp = exp;
	// result.action = action;
	// result.splitList = splitList;

	return result;
};

exports.calProfit = function(isOffline, nodeinfo, mapinfo, win) {
	var normalTime = 0, result = {}, offTime, leftTime = 0, now = moment(),
	akfrewardid = WorldMap[mapinfo.curAfkNode].ResourceID;
	// //tiny.log.error("...........", JSON.stringify(afkInfo));
	// if (pointId) {
	// 	if (pointId === Const.DEFAULT_AFK_POINT) {
	// 		afkInfo.afkVictoryTime.rewardCount += 1;
	// 	}
	// 	exports.calOnlineProfit(afkInfo.curAfker.guajiid, result, isAdd, pointId);
	// 	return result;
	// }

	if (!isOffline) {	// 在线
		nodeinfo.fightTime = nodeinfo.fightTime + 1;
		if (win === 1) {
			nodeinfo.victoryTime = nodeinfo.victoryTime + 1;
			exports.calOnlineProfit(akfrewardid, result);
		}
	} else {
		// 计算离线时间
		offTime = now.diff(nodeinfo.proAfkTime, 'second');
		if (offTime >= Const.AFK_MAX_TIME) {
			offTime = Const.AFK_MAX_TIME;
		}
		exports.calOfflineProfit(akfrewardid, offTime, result);
	}
	nodeinfo.proAfkTime = now;
	return result;

	// if (afkInfo.curAfker.uid === 0
	// 	|| !curAkfMapInfo.uidList.hasOwnProperty(afkInfo.curAfker.uid)) {
	// 	tiny.log.debug("not begin afk");
	// 	return null;
	// }

	// if (Afkreward[afkInfo.curAfker.guajiid].ElementType === ConstMap.MAP_UID_TYPE.TIME_AFK
	// 	&& curAkfMapInfo.uidList[afkInfo.curAfker.uid].state === MapElement.TIME_AFK.CLOSE) {
	// 	tiny.log.debug(" time afk state error");
	// 	return null;
	// }

	// 计算是否数值奖励加成
	// if (Map.getAfkState(afkInfo, curAkfMapInfo) === MapElement.NOR_AFK.ADDITION)
	// {
	// 	tiny.log.debug(".............isAdd", Map.getAfkState(afkInfo, curAkfMapInfo));
	// 	isAdd = true;
	// }
	// tiny.log.debug(".............", Map.getAfkState(afkInfo, curAkfMapInfo));

	// 计算离线时间
	// offTime = now - afkInfo.proAfkTime;
	// if (offTime >= Const.AFK_MAX_TIME) {
	// 	offTime = Const.AFK_MAX_TIME;
	// }

	// 如果挂机时间小于最小间隔则不给奖励
	//if (offTime < Const.AFK_MIN_TIME) {
	//	tiny.log.debug(" time afk too small", offTime);
	//	return null;
	//}

	// 计算限时挂机点剩余时间
	// if (Afkreward[afkInfo.curAfker.guajiid].ElementType === ConstMap.MAP_UID_TYPE.TIME_AFK) {
	// 	tiny.log.debug(" time afk ", leftTime);
	// 	leftTime = Afkreward[afkInfo.curAfker.guajiid].Time - (afkInfo.proAfkTime - afkInfo.beginAfkTime);
	// }

	// if (isOffline) {
	// 	// 离线挂机
	// 	if (Afkreward[afkInfo.curAfker.guajiid].ElementType === ConstMap.MAP_UID_TYPE.TIME_AFK) {
	// 		// 限时挂机点
	// 		// 超过限时挂机点最大时间
	// 		if (offTime > leftTime) {
	// 			tiny.log.debug(" off time afk 2", offTime, leftTime);
	// 			// 分段计算
	// 			exports.calOfflineProfit(afkInfo.curAfker.guajiid, leftTime, result);
	// 			normalTime = offTime - leftTime;
	// 			// 迁移回永久挂机点
	// 			exports.backLastNormalAfk(afkInfo, curAkfMapInfo);
	// 			exports.calOfflineProfit(afkInfo.curAfker.guajiid, normalTime, result);
	// 		} else {
	// 			tiny.log.debug(" off time afk 1");
	// 			// 未超时不需要迁移回去
	// 			exports.calOfflineProfit(afkInfo.curAfker.guajiid, offTime, result);
	// 		}
	// 	} else {
	// 		tiny.log.debug(" off forever afk 1");
	// 		// 永久挂机点直接计算
	// 		exports.calOfflineProfit(afkInfo.curAfker.guajiid, offTime, result, isAdd);
	// 	}
	// } else {
	// 	// 在线宝箱奖励
	// 	if (!curAkfMapInfo.uidList[afkInfo.curAfker.uid].hasOwnProperty("afkVictoryTime")) {
	// 		curAkfMapInfo.uidList[afkInfo.curAfker.uid].afkVictoryTime = { rewardCount : 0, scoreTime : 1};
	// 	}
	// 	curAkfMapInfo.uidList[afkInfo.curAfker.uid].afkVictoryTime.rewardCount += 1;

	// 	// 在线挂机
	// 	if (Afkreward[afkInfo.curAfker.guajiid].ElementType === ConstMap.MAP_UID_TYPE.TIME_AFK) {
	// 		// 限时挂机点
	// 		if (offTime <= leftTime) {
	// 			tiny.log.debug(" on time afk cal", offTime, leftTime);
	// 			exports.calOnlineProfit(afkInfo.curAfker.guajiid, result);
	// 		} else {
	// 			tiny.log.debug(" on time afk close");
	// 			// 迁移回永久挂机点
	// 			exports.backLastNormalAfk(afkInfo, curAkfMapInfo);
	// 			exports.calOnlineProfit(afkInfo.curAfker.guajiid, result);
	// 		}
	// 	} else {
	// 		tiny.log.debug(" on forever afk 1");
	// 		// 永久挂机点直接计算
	// 		exports.calOnlineProfit(afkInfo.curAfker.guajiid, result, isAdd, pointId);
	// 	}
	// }

	// afkInfo.proAfkTime = now;

	// return result;
};
