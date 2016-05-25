var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var ConstMap = Const.MAP;
var tiny = require('../../tiny');
var mapHandle = require('../dataprocess/map_handle');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle = require('../dataprocess/equip_handle');
var afkHandle = require('../dataprocess/afk_handle');
var async = require('async');
var moment = require('moment');
var utils = require('../utils');
var mapfunc = require('./map');
// 配置表
var WorldMap = require('../config/map/worldmap');
var AfkReward = require('../config/map/afkreward');
var MapInfo = require('../config/map/mapinfo');

// 获取世界地图信息
var getGlobalMapInfo = function(dataValue) {
	var outArgs = {}, timeNode = dataValue.mapInfo.timeNode, nodeid, now = moment();
	for (nodeid in timeNode) {
		if (timeNode.hasOwnProperty(nodeid) && WorldMap.hasOwnProperty(nodeid)) {
			mapfunc.moveNode(timeNode, dataValue.mapInfo.openNode, nodeid, now);
		} else {
			tiny.log.error('getGlobalMapInfo找不到世界地图节点', nodeid);
			delete timeNode[nodeid];
		}
	}
	outArgs.curNode = dataValue.mapInfo.curNode;
	outArgs.openNode = dataValue.mapInfo.openNode;
	outArgs.timeNode = dataValue.mapInfo.timeNode;
	return outArgs;
};

// 进入地图协议
var enterMap = function(dataValue, inArgs) {
	// 根据地图id返回此地图的信息
	var outArgs = {}, nodeid = inArgs.nodeid,
	mapInfo = dataValue.mapInfo,
	baseInfo = dataValue.baseInfo;

	// 检查是否满足进入条件
	if (mapInfo.timeNode[nodeid]) {
		if (!mapfunc.moveNode(mapInfo.timeNode, mapInfo.openNode, nodeid, moment())) {
			outArgs.retCode = ErrCode.NODE_TIME_NOT_OPEN;
			return outArgs;
		}
	}
	if (WorldMap.hasOwnProperty(nodeid)) {
		if (WorldMap[nodeid].Type2 !== ConstMap.NODE_TYPE.MAP) {
			outArgs.retCode = ErrCode.TARGET_MAP_NOT_EXIST;
			return outArgs;
		}
		if (baseInfo.level < WorldMap[nodeid].Openlevel) {
			outArgs.retCode = ErrCode.NODE_ENTER_LVL_ERROR;
			return outArgs;
		}
		if (!dataValue.nodeInfo) {	// 第一次，从正常逻辑上不会进入这个分支
			tiny.log.error('entermap的时候创建了地图，逻辑错误');
			dataValue.nodeInfo = mapfunc.createNode(nodeid);
		}
		mapInfo.curNode = nodeid;
		outArgs.x = dataValue.nodeInfo.x;
		outArgs.y = dataValue.nodeInfo.y;
		outArgs.ap = dataValue.nodeInfo.ap;
		outArgs.uidList = dataValue.nodeInfo.uidList;
		outArgs.sign = dataValue.nodeInfo.sign;
		outArgs.buff = dataValue.nodeInfo.buff;
		outArgs.process = mapInfo.openNode[nodeid].process;
	} else {
		outArgs.retCode = ErrCode.NODE_NOT_FOUND;
		return outArgs;
	}

	return outArgs;
};

// 切换挂机点
var changeAfk = function(dataValue, inArgs) {
	// 根据地图id返回此地图的信息
	var outArgs = {}, nodeid = inArgs.nodeid, noderet = {}, i,
	mapInfo = dataValue.mapInfo,
	baseInfo = dataValue.baseInfo;
	outArgs.newNode = {};

	// 检查是否满足进入条件
	if (mapInfo.timeNode[nodeid]) {
		if (!mapfunc.moveNode(mapInfo.timeNode, mapInfo.openNode, nodeid, moment())) {
			outArgs.retCode = ErrCode.NODE_TIME_NOT_OPEN;
			return outArgs;
		}
	}
	if (WorldMap.hasOwnProperty(nodeid)) {
		if (WorldMap[nodeid].Type2 !== ConstMap.NODE_TYPE.AFK) {
			outArgs.retCode = ErrCode.NODE_IS_NOT_AFK;
			return outArgs;
		}
		if (baseInfo.level < WorldMap[nodeid].Openlevel) {
			outArgs.retCode = ErrCode.NODE_ENTER_LVL_ERROR;
			return outArgs;
		}
		if (!dataValue.nodeInfo) {	// 第一次需要开next节点
			dataValue.nodeInfo = mapfunc.createNode(nodeid);
			noderet = mapfunc.addOpenNode(WorldMap[nodeid].Next, mapInfo);
			for (i in noderet) {
				if (noderet.hasOwnProperty(i)) {
					noderet[i] = JSON.stringify(noderet[i]);
				}
			}
			outArgs.newNode = noderet;
			// 异步保存，需要修改
			tiny.redis.hmset(utils.redisKeyGen(dataValue.area, dataValue.uuid, 'node'), noderet, function(e) {
				if (e) {
					tiny.log.error('changeAfk', 'node hmset fail', JSON.stringify(noderet));
				}
			});
		}
		// 记录上一个普通挂机点
		if (AfkReward.hasOwnProperty(WorldMap[mapInfo.curAfkNode].ResourceID)) {
			if (AfkReward[WorldMap[mapInfo.curAfkNode].ResourceID].type === ConstMap.AFK_TYPE.NORMAL) {
				mapInfo.lastNormalAfk = mapInfo.curAfkNode;
			}
		}
		mapInfo.curNode = nodeid;
		mapInfo.curAfkNode = nodeid;
		outArgs = dataValue.nodeInfo;
	} else {
		outArgs.retCode = ErrCode.NODE_NOT_FOUND;
		return outArgs;
	}

	return outArgs;
};

var walkPath = function(dataValue, inArgs) {
	var outArgs = {}, nodeid = inArgs.nodeid,
	uid = inArgs.uid, path = inArgs.path,
	mapInfo = dataValue.mapInfo, mapid, mapFileName, mapFileInfo,
	nodeInfo = dataValue.nodeInfo;

	// 检查path是否是数组
	if (!(utils.isArray(path) && path.length > 0)) {
		tiny.log.error('path错误');
		outArgs.retCode = ErrCode.WALK_PATH_ERROR;
		return outArgs;
	}

	// 检查地图是否是当前地图
	if (mapInfo.curNode !== nodeid) {
		tiny.log.error('当前地图id不正确');
		outArgs.retCode = ErrCode.CURRENT_MAP_WRONG;
		return outArgs;
	}

	// 检查地图信息是否存在
	if (!nodeInfo) {
		tiny.log.error('地图信息不存在');
		outArgs.retCode = ErrCode.CURRENT_MAP_WRONG;
		return outArgs;
	}

	// 检查是否是地图类型
	if (WorldMap[nodeid].Type2 !== ConstMap.NODE_TYPE.MAP) {
		outArgs.retCode = ErrCode.TARGET_MAP_NOT_EXIST;
		return outArgs;
	}

	mapid = WorldMap[nodeid].ResourceID;
	mapFileName = MapInfo[mapid].InfoFile;
	mapFileInfo = mapfunc.getMapJson(mapFileName);
	if (uid >= 0) {	// 验证玩家是否在建筑内，验证起点坐标是否紧贴建筑
		if (mapFileInfo && mapFileInfo.hasOwnProperty("element")) {
			if (mapFileInfo.element.hasOwnProperty(uid)) {
				if (mapfunc.checkPathUID(mapFileInfo.element[uid], nodeInfo.x, nodeInfo.y, path[0])) {
					mapfunc.calcPathCost(nodeInfo, mapFileInfo, path, uid);
					outArgs.nodeid = nodeid;
					outArgs.x = nodeInfo.x;
					outArgs.y = nodeInfo.y;
					outArgs.ap = nodeInfo.ap;
					outArgs.buff = nodeInfo.buff;
					return outArgs;
				}
				tiny.log.error('walkPath', 'UID验证失败');
				outArgs.retCode = ErrCode.MAP_UID_ERROR;
				return outArgs;
			}
			tiny.log.error('walkPath', '找不到uid');
			outArgs.retCode = ErrCode.MAP_UID_ERROR;
			return outArgs;
		}
		tiny.log.error('walkPath', '找不到建筑层');
		outArgs.retCode = ErrCode.MAP_UID_ERROR;
		return outArgs;
	}

	mapfunc.calcPathCost(nodeInfo, mapFileInfo, path, uid);
	outArgs.nodeid = nodeid;
	outArgs.x = nodeInfo.x;
	outArgs.y = nodeInfo.y;
	outArgs.ap = nodeInfo.ap;
	outArgs.buff = nodeInfo.buff;
	return outArgs;
};

var changeState = function(dataValue, inArgs) {
	var outArgs = {}, nodeid = inArgs.nodeid, args = inArgs.args,
	uid = inArgs.uid, nextstate = inArgs.nextstate,
	mapInfo = dataValue.mapInfo, info, fightInfo,
	baseInfo = dataValue.baseInfo,
	teamHeroList = dataValue.teamHeroList,
	bagList = dataValue.bagList,
	nodeInfo = dataValue.nodeInfo;

	// 检查地图是否是当前地图
	if (mapInfo.curNode !== nodeid) {
		tiny.log.error('当前地图id不正确');
		outArgs.retCode = ErrCode.CURRENT_MAP_WRONG;
		return outArgs;
	}

	// 检查地图信息是否存在
	if (!nodeInfo) {
		tiny.log.error('地图信息不存在');
		outArgs.retCode = ErrCode.CURRENT_MAP_WRONG;
		return outArgs;
	}

	// 检查是否是地图类型
	if (WorldMap[nodeid].Type2 !== ConstMap.NODE_TYPE.MAP) {
		outArgs.retCode = ErrCode.TARGET_MAP_NOT_EXIST;
		return outArgs;
	}

	info = mapInfo.openNode[nodeid];
	if (!info) {
		outArgs.retCode = ErrCode.OPEN_NODE_MISSING;
		return outArgs;
	}

	outArgs.args = {};
	outArgs.nodeid = nodeid;
	outArgs.uid = uid;
	outArgs.state = 0;
	fightInfo = playerHandle.getPlayerInfoEx(baseInfo, teamHeroList, bagList);
	tiny.log.trace('changeState', JSON.stringify(mapInfo));
	mapfunc.processUid(outArgs, nodeid, mapInfo, nodeInfo, uid, nextstate, args, baseInfo, bagList, fightInfo);

	return outArgs;
};

module.exports = {
"getGlobalMapInfo" : getGlobalMapInfo,
"enterMap" : enterMap,
"changeAfk" : changeAfk,
"walkPath" : walkPath,
"changeState" : changeState
};
