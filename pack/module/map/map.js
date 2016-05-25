var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var ConstMap = Const.MAP;
var MapElement = ConstMap.ELEMENT_STATE;
var tiny = require('../../tiny');
var mapHandle = require('../dataprocess/map_handle');
var playerHandle = require('../dataprocess/player_handle');
var heroHandle = require('../dataprocess/hero_handle');
var equipHandle = require('../dataprocess/equip_handle');
var utils = require('../utils');
var fight = require('../fight/fight');
var bag = require('../bag/bag');
var moment = require('moment');

// 配置表
var MapInfo = require('../config/map/mapinfo');
var WorldMap = require('../config/map/worldmap');
var Exploration = require('../config/map/exploration');

var BuffExp = require('../config/map/buffexp');
var ElementType = require('../config/map/elementtype');
var Chest = require('../config/map/building/chest');
var Monsterchal = require('../config/map/building/monsterchal');
var Unknow = require('../config/map/building/unknow');
var BuffStation = require('../config/map/building/buffstation');
// var Shop = require('../config/exploration/shop');
var WatchTower = require('../config/map/building/watchtower');
var MapNpc = require('../config/map/building/npc');
// var Exit = require('../config/exploration/exit');
var LObstacle = require('../config/map/building/lobstacle');
var ChestChoo = require('../config/map/building/chestchoo');
// var GuaJi = require('../config/exploration/guaji');
var Mission = require('../config/map/building/mission');
// var BattleResult = require('../config/battle/battleresult');
// var Supply = require('../config/exploration/supply');
var LSurface = require('../config/map/building/lsurface');

var itemfunc = require('../item/item');


// function getFormatSellgroup(sellgroup) {
// 	var i, group, pro;
// 	sellgroup.formatGroup = {};
// 	for (i in sellgroup) {
// 		if (sellgroup.hasOwnProperty(i)) {
// 			group = sellgroup[i].Group;
// 			pro = sellgroup[i].Pro;
// 			tiny.log.trace("getFormatSellgroup = ", group, pro);
// 			if (!sellgroup.formatGroup.hasOwnProperty(group)) {
// 				sellgroup.formatGroup[group] = {};
// 				sellgroup.formatGroup[group].index = [];
// 				sellgroup.formatGroup[group].weight = [];
// 			}
// 			sellgroup.formatGroup[group].index.push(i);
// 			sellgroup.formatGroup[group].weight.push(pro);
// 		}
// 	}
// 	tiny.log.trace("getFormatSellgroup = ", JSON.stringify(sellgroup.formatGroup));
// }

// exports.getSellGroup = function() {
// 	try {
// 		var sellgroup = require('../config/map/common/sellgroup');
// 		// 对地图json文件的预处理
// 		getFormatSellgroup(sellgroup);
// 		return sellgroup;
// 	} catch(e) {
// 		tiny.log.error('getSellGroup not found');
// 		return undefined;
// 	}
// };

// var Sellgroup = exports.getSellGroup();



// function getReward(rewardid, mapInfo, baseInfo, bagList, bagAdd) {
// 	var gold,
// 		exp,
// 		action,
// 		drop,
// 		sign;

	// if (Reward.hasOwnProperty(rewardid)) {
	// 	// 给奖励
	// 	gold = parseInt(Reward[rewardid].Money, 10);
	// 	exp = parseInt(Reward[rewardid].Experience, 10);
	// 	action = parseInt(Reward[rewardid].AP, 10);
	// 	drop = Reward[rewardid].Drop;
	// 	sign = Reward[rewardid].Sign;
	// 	if (exp) {
	// 		playerHandle.addPlayerExp(exp, baseInfo);
	// 		// 增加英雄经验
	// 		// 升级英雄经验
	// 		heroHandle.updateHerosExpInHeroList(baseInfo.area, baseInfo.uuid, playerHandle.getHeroIdsFromPosList(baseInfo.posList), exp, function(err) {
	// 			if (err) {
	// 				tiny.log.debug('updateHerosExpInHeroList error', err);
	// 			}
	// 		});
	// 	}
	// 	if (gold) {
	// 		playerHandle.addPlayerGold(gold, baseInfo);
	// 	}
	// 	if (action) {
	// 		playerHandle.addPlayerAction(action, baseInfo);
	// 	}
	// 	tiny.log.trace("mapInfo.sign = ", JSON.stringify(mapInfo.sign), sign, mapInfo.sign.hasOwnProperty(sign));
	// 	if (mapInfo.sign.hasOwnProperty(sign)) {
	// 		mapInfo.sign[sign] = 1;
	// 	}
	// 	if (Drop.hasOwnProperty(drop)) {
	// 		if (!itemfunc.dropPool(drop, baseInfo, bagList, bagAdd)) {
	// 			return false;
	// 		}
	// 	}
	// }

// 	return true;
// }


// function getRelStep(bufflist, pos, step) {
// 	var relStep;
// 	if (bufflist[pos].value > step) {
// 		relStep = step;
// 		bufflist[pos].value = bufflist[pos].value - step;
// 	} else {
// 		relStep = bufflist[pos].value;
// 		bufflist.splice(pos, 1);
// 	}
// 	return relStep;
// }

// exports.calcBuffAction = function(costObj, bufflist) {
// 	tiny.log.trace("calcBuffAction start", bufflist, JSON.stringify(bufflist), costObj);
// 	var step = costObj.length,
// 		i, j, k, buffStep, arg, newCost = 0, buffid;
// 	for (i = 0; i < bufflist.length; ++i) {
// 		buffid = bufflist[i].id;
// 		tiny.log.trace("calcBuffAction bufflist.length = ", bufflist.length);
// 		if (BuffExp.hasOwnProperty(buffid)) {
// 			if (BuffExp[buffid].hasOwnProperty("Effecttype")) {
// 				if (BuffExp[buffid].Effecttype === ConstMap.BUFFTYPE.WALK_COST_PERCENT_MINUS) {
// 					tiny.log.trace("calcBuffAction clac = ", step);
// 					arg = BuffExp[buffid].EffectArg;
// 					buffStep = getRelStep(bufflist, i, step);
// 					for (j = 0; j < buffStep; ++j) {
// 						costObj[j] = costObj[j] - Math.ceil(arg * costObj[j] / 100);
// 					}
// 					// newCost = costObj[0] - Math.ceil(buffStep * arg * walkPerCost / 100);
// 					tiny.log.trace("calcBuffAction clac end = ", step, buffStep, arg);
// 				}
// 				if (BuffExp[buffid].Effecttype === ConstMap.BUFFTYPE.WALK_COST_EVERY_MINUS) {
// 					tiny.log.trace("calcBuffAction clac = ", step);
// 					arg = BuffExp[buffid].EffectArg;
// 					buffStep = getRelStep(bufflist, i, step);
// 					for (j = 0; j < buffStep; ++j) {
// 						costObj[j] = costObj[j] - arg;
// 					}
// 					// newCost = costObj[0] - Math.floor(buffStep * arg);
// 					tiny.log.trace("calcBuffAction clac end = ", step, buffStep, arg);
// 				}
// 				if (BuffExp[buffid].Effecttype === ConstMap.BUFFTYPE.WALK_COST_PERCENT_ADD) {
// 					tiny.log.trace("calcBuffAction clac = ", step);
// 					arg = BuffExp[buffid].EffectArg;
// 					buffStep = getRelStep(bufflist, i, step);
// 					for (j = 0; j < buffStep; ++j) {
// 						costObj[j] = costObj[j] + Math.floor(arg * costObj[j] / 100);
// 					}
// 					// newCost = costObj[0] + Math.floor(buffStep * arg * walkPerCost / 100);
// 					tiny.log.trace("calcBuffAction clac end = ", step, buffStep, arg);
// 				}
// 			}
// 		}
// 	}
// 	for (k = 0; k < costObj.length; ++k) {
// 		if (costObj[k] > 0) {
// 			newCost = newCost + costObj[k];
// 		}
// 	}
// 	tiny.log.trace("calcBuffAction end", newCost);
// 	return newCost;
// };



function formatMapJson(mapJson) {
	var build, surface, i, j, id, name, type, x, y, sx, sy;
	if (utils.isObject(mapJson)) {
		mapJson.element = {};
		mapJson.surface = {};
		mapJson.obsMap = {};
		mapJson.obsMap.width = 0;
		mapJson.obsMap.data = {};
		if (mapJson.hasOwnProperty("layers")) {
			for (i = 0; i < mapJson.layers.length; ++i) {
				if (mapJson.layers[i].name === ConstMap.MAP_LAYER_NAME.BUILDING_LAYER) {
					build = mapJson.layers[i].objects;
					if (utils.isArray(build)) {
						for (j = 0; j < build.length; ++j) {
							if (utils.isObject(build[j]) &&
								build[j].hasOwnProperty("id")) {
								id = build[j].id;
								name = build[j].name;
								type = build[j].type;
								x = build[j].gridx;
								y = build[j].gridy;
								mapJson.element[id] = {};
								mapJson.element[id].name = name;
								mapJson.element[id].type = type;
								mapJson.element[id].x = x;
								mapJson.element[id].y = y;
							}
						}
					}
				}
				if (mapJson.layers[i].name === ConstMap.MAP_LAYER_NAME.SURFACE) {
					surface = mapJson.layers[i].objects;
					if (utils.isArray(surface)) {
						for (j = 0; j < surface.length; ++j) {
							if (utils.isObject(surface[j]) &&
								surface[j].hasOwnProperty("id")) {
								name = surface[j].name;
								id = surface[j].id;
								type = surface[j].type;
								tiny.log.trace('sx, sy 1', name, id, type, LSurface.hasOwnProperty(name));
								if (LSurface.hasOwnProperty(name) && LSurface[name].hasOwnProperty('Area')) {
									tiny.log.trace('sx, sy2', sx, sy, surface[j].gridx + LSurface[name].Area[1], surface[j].gridy + LSurface[name].Area[2]);
									for (sx = surface[j].gridx; sx < (surface[j].gridx + LSurface[name].Area[1]); ++sx) {
										for (sy = surface[j].gridy; sy < (surface[j].gridy + LSurface[name].Area[2]); ++sy) {
											if (!mapJson.surface.hasOwnProperty(sx)) {
												mapJson.surface[sx] = {};
											}
											mapJson.surface[sx][sy] = {};
											mapJson.surface[sx][sy].id = id;
											mapJson.surface[sx][sy].name = name;
											mapJson.surface[sx][sy].type = type;
											tiny.log.trace('sx, sy', name);
										}
									}
								}
							}
						}
					}
					tiny.log.trace('sx, sy', JSON.stringify(mapJson.surface));
				}
				if (mapJson.layers[i].name === ConstMap.MAP_LAYER_NAME.OBS_LAYER) {
					mapJson.obsMap.data = mapJson.layers[i].data;
					mapJson.obsMap.width = mapJson.layers[i].width;
				}
			}
		}
	}
}

function checkPosInArea(posX, posY, x, y, area) {
	if (posX >= x && (posX < x + area[1]) &&
		posY >= y && (posY <= y + area[2])) {
		return true;
	}
	return false;
}

function checkPosAroundArea(posX, posY, x, y, area) {
	if ((posY >= y && (posY < y + area[2]) &&
		(x - posX === 1 || posX - x === area[1])) ||
		(posX >= x && (posX < x + area[1]) &&
		(y - posY === 1 || posY - y === area[2]))) {
		return true;
	}
	return false;
}

// 验证两点是否紧邻
function checkNearPoint(x1, y1, x2, y2) {
	if ((Math.abs(x1 - x2) === 1 && y1 === y2) ||
		((Math.abs(y1 - y2) === 1) && x1 === x2)) {
		return true;
	}
	return false;
}

function getElementSheet(type) {
	var sheetName, sheet;
	if (ElementType.hasOwnProperty(type)) {
		sheetName = ElementType[type].SheetName;
		if (sheetName) {
			tiny.log.trace('getElementSheet', sheetName);
			try {
				sheet = require('../config/map/building/' + sheetName);
			} catch (e) {
				tiny.log.error('getElementSheet', sheetName);
				return null;
			}
		}
	}
	return sheet;
}

function checkUidEffectArea(uidObject, px, py) {
	var name = uidObject.name,
		type = uidObject.type,
		x = uidObject.x,
		y = uidObject.y,
		sheet, area, obstacle;

	tiny.log.trace('checkUidEffectArea', name, type, x, y, px, py);
	if (!name || !type) {
		tiny.log.trace('checkUidEffectArea', 1);
		return false;
	}

	sheet = getElementSheet(type);
	if (sheet) {
		if (!sheet.hasOwnProperty(name)) {
			tiny.log.trace('checkUidEffectArea', 3, name, sheet.hasOwnProperty(name), sheet.hasOwnProperty(name));
			return false;
		}
		area = sheet[name].Area;
		obstacle = sheet[name].Obstacle;
		tiny.log.trace('checkUidEffectArea', JSON.stringify(area), obstacle);
		if (parseInt(obstacle, 10) === ConstMap.OBSTACLE.AROUND) {
			return checkPosAroundArea(px, py, x, y, area);
		}
		if (parseInt(obstacle, 10) === ConstMap.OBSTACLE.IN) {
			return checkPosInArea(px, py, x, y, area);
		}
		if (parseInt(obstacle, 10) === ConstMap.OBSTACLE.DIS) {
			return true;
		}
	}

	tiny.log.trace('checkUidEffectArea', 4);
	return false;
}

// 修正地形影响消耗
function updateTerrain(x, y, surface) {
	return 1;
}

function getUidPreCondition(type, name) {
	if (type === ConstMap.MAP_UID_TYPE.CHEST) {	// 资源宝箱
		return Chest[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.MONSTERCHAL) { // 挑战怪
		return Monsterchal[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.UNKNOW) { // 未知建筑
		return Unknow[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.BUFFSTATION) { // buff点
		return BuffStation[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.WATCHTOWER) { // 瞭望塔
		return WatchTower[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.LOBSTACLE) { // 可移除障碍
		return LObstacle[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.LOBSTACLE) { // 选择资源
		return ChestChoo[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.MISSION) { // 选择资源
		return Mission[name].Precondition;
	}
	if (type === ConstMap.MAP_UID_TYPE.NPC) {
		return MapNpc[name].Precondition;
	}
	return undefined;
}

function getUidInitState(type) {
	type = parseInt(type, 10);
	if (type === ConstMap.MAP_UID_TYPE.CHEST) {
		return MapElement.CHEST.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.MONSTERCHAL) {
		return MapElement.MONSTERCHAL.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.UNKNOW) {
		return MapElement.UNKNOW.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.BUFFSTATION) {
		return MapElement.BUFFSTATION.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.WATCHTOWER) {
		return MapElement.WATCHTOWER.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.LOBSTACLE) {
		return MapElement.LOBSTACLE.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.CHESTCHOO) {
		return MapElement.CHESTCHOO.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.MISSION) {
		return MapElement.MISSION.INIT;
	}
	if (type === ConstMap.MAP_UID_TYPE.NPC) {
		return MapElement.NPC.INIT;
	}
	return 0;
}

function checkFinalState(type, state) {
	type = parseInt(type, 10);
	if (type === ConstMap.MAP_UID_TYPE.CHEST) {
		return state === MapElement.CHEST.PICKED;
	}
	if (type === ConstMap.MAP_UID_TYPE.MONSTERCHAL) {
		return state === MapElement.MONSTERCHAL.FIGHTED;
	}
	if (type === ConstMap.MAP_UID_TYPE.UNKNOW) {
		return state === MapElement.UNKNOW.GOT;
	}
	if (type === ConstMap.MAP_UID_TYPE.BUFFSTATION) {
		return state === MapElement.BUFFSTATION.PICKED;
	}
	if (type === ConstMap.MAP_UID_TYPE.WATCHTOWER) {
		return state === MapElement.WATCHTOWER.PICKED;
	}
	if (type === ConstMap.MAP_UID_TYPE.LOBSTACLE) {
		return state === MapElement.LOBSTACLE.REMOVE;
	}
	if (type === ConstMap.MAP_UID_TYPE.CHESTCHOO) {
		return state === MapElement.CHESTCHOO.CHOOD;
	}
	if (type === ConstMap.MAP_UID_TYPE.MISSION) {
		return state === MapElement.MISSION.END;
	}
	if (type === ConstMap.MAP_UID_TYPE.NPC) {
		return state === MapElement.NPC.CLICKED;
	}
	return false;
}

function fightProc(monsterid, playerInfo, cb) {
	fight.fightEnemy(monsterid, playerInfo, function(err, result, seed) {
		if (!err) {
			cb([result, seed]);
			return;
		}
		tiny.log.error('fightProc error', err);
		cb([err]);
	});
}

function checkUidPos(mapid, x, y, uid, uidList, out) {
	var sheet, file;
	// 取对应地图的element
	if (MapInfo.hasOwnProperty(mapid)) {
		if (MapInfo[mapid].hasOwnProperty("InfoFile")) {
			sheet = MapInfo[mapid].InfoFile;
		}
	}
	tiny.log.trace('checkUidPos', sheet, mapid, x, y, uid, uidList, out);
	file = exports.getMapJson(sheet);
	if (file && file.hasOwnProperty("element")) {
		if (file.element.hasOwnProperty(uid)) {
			// 检查玩家是否在uid有效范围内
			// if (checkUidEffectArea(file.element[uid], x, y)) {
				out.type = file.element[uid].type;
				out.name = file.element[uid].name;
				tiny.log.trace('checkUidPos', uid, sheet, out.type, out.name);
				if (uidList.hasOwnProperty(uid)) {
					out.uidState = uidList[uid];
				} else {
					out.uidState = getUidInitState(out.type);
				}
				return true;
			// }
		}
	}
	tiny.log.trace('checkUidPos fail');
	return false;
}

function checkPreContion(type, name, mapInfo) {
	var condition = getUidPreCondition(type, name);
	if (condition) {
		condition = parseInt(condition, 10);
		tiny.log.trace("checkPreContion", condition);

		if (!mapInfo.sign.hasOwnProperty(condition)) {
			return false;
		}
	}
	return true;
}

function addExplore(mapid, uid, info) {
	var i;
	for (i in Exploration) {
		if (Exploration.hasOwnProperty(i)) {
			if (Exploration[i].MapId === mapid && Exploration[i].UId === uid) {
				info.process = info.process + Exploration[i].Exploration;
				tiny.log.trace('探索度增加', Exploration[i].Exploration);
			}
		}
	}
	if (info.process >= MapInfo[mapid].Exploration) {
		tiny.log.trace('开新地图');
		return true;
	}
	return false;
}

function processChest(uidState, uid, name, nodeInfo, baseInfo, bagList, outArgs) {
	var rewardPack;
	if (parseInt(uidState, 10) === MapElement.CHEST.INIT) {
		if (Chest.hasOwnProperty(name) && Chest[name].hasOwnProperty('Reward')) {
			rewardPack = itemfunc.dropPool(Chest[name].Reward, baseInfo, bagList, nodeInfo);
			if (rewardPack[0]) {
				tiny.log.error('processChest', '宝箱奖励领取失败');
				outArgs.retCode = rewardPack[0];
			} else {
				outArgs.state = MapElement.CHEST.PICKED;
				outArgs.args.reward = rewardPack[1];
				nodeInfo.uidList[uid] = MapElement.CHEST.PICKED;
				tiny.log.trace('processChest', JSON.stringify(outArgs));
			}
		} else {
			outArgs.retCode = ErrCode.MAP_UID_ID_FAIL;
			tiny.log.error('找不到对应的宝箱id', name);
		}
	} else {
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		tiny.log.error('宝箱已经开过了', name);
	}
}

function processMonsterchal(uidState, uid, name, nodeInfo, baseInfo, bagList, fightInfo, outArgs) {
	var monsterid, rewardid, rewardPack;
	if (parseInt(uidState, 10) === MapElement.MONSTERCHAL.INIT) {
		if (Monsterchal.hasOwnProperty(name) &&
			Monsterchal[name].hasOwnProperty('Monster') &&
			Monsterchal[name].hasOwnProperty('Reward')) {
			monsterid = Monsterchal[name].Monster;
			rewardid = Monsterchal[name].Reward;
			// 开始战斗
			fightProc(monsterid, fightInfo, function(ret) {
				if (ret[0] === Const.FIGHT_RESULT.SUCCESS) {
					nodeInfo.uidList[uid] = MapElement.MONSTERCHAL.FIGHTED;
					outArgs.state = MapElement.MONSTERCHAL.FIGHTED;
					// 战斗胜利获得奖励
					rewardPack = itemfunc.dropPool(rewardid, baseInfo, bagList, nodeInfo);
					if (rewardPack[0]) {
						tiny.log.error('processMonsterchal', '战斗奖励获取失败', rewardPack[0]);
					}
					outArgs.args.reward = rewardPack[1];
				} else {
					outArgs.state = MapElement.MONSTERCHAL.INIT;
				}
				outArgs.args.monsterid = monsterid;
				outArgs.args.result = ret[0];
				outArgs.args.seed = ret[1];
			});
		} else {
			outArgs.retCode = ErrCode.MAP_UID_ID_FAIL;
			tiny.log.error('找不到对应的怪物id', name);
		}
	} else {
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		tiny.log.error('已经打过了', name);
	}
}

function processUnknow(uidState, uid, name, nodeInfo, baseInfo, bagList, fightInfo, outArgs) {
	var sum = 0, ret, pro1, pro2, monster, reward, rewardPack;

	if (parseInt(uidState, 10) === MapElement.UNKNOW.INIT) {
		if (Unknow.hasOwnProperty(name)) {
			pro1 = Unknow[name].Probability1;	// 奖励概率
			pro2 = Unknow[name].Probability2;	// 打怪概率
			monster = Unknow[name].Monster;
			reward = Unknow[name].Reward;

			if (utils.isNumber(pro1) && utils.isNumber(pro2) &&
				pro1 >= 0 && pro2 >= 0) {
				sum = pro1 + pro2;
				ret = utils.randomInt(1, sum);

				if (ret <= pro1) { // 给奖励
					outArgs.args.randRet = MapElement.UNKNOW.REWARD;
					outArgs.state = MapElement.UNKNOW.REWARD;
					nodeInfo.uidList[uid] = MapElement.UNKNOW.REWARD;
				} else { // 打怪
					outArgs.args.randRet = MapElement.UNKNOW.MONSTER;
					outArgs.state = MapElement.UNKNOW.MONSTER;
					nodeInfo.uidList[uid] = MapElement.UNKNOW.MONSTER;
				}
			} else {
				outArgs.retCode = ErrCode.MAP_UID_ENDED;
				tiny.log.error('processUnknow 概率错误', pro1, pro2);
			}
		} else {
			outArgs.retCode = ErrCode.MAP_UID_ENDED;
			tiny.log.error('processUnknow Unknow找不到name', name);
		}
	} else if (parseInt(uidState, 10) === MapElement.UNKNOW.MONSTER) {
		monster = Unknow[name].Monster;
		reward = Unknow[name].Reward;
		// 开始战斗
		fightProc(monster, fightInfo, function(ret) {
			if (ret[0] === Const.FIGHT_RESULT.SUCCESS) {
				nodeInfo.uidList[uid] = MapElement.UNKNOW.GOT;
				outArgs.state = MapElement.UNKNOW.GOT;
				// 战斗胜利获得奖励
				rewardPack = itemfunc.dropPool(reward, baseInfo, bagList, nodeInfo);
				if (rewardPack[0]) {
					tiny.log.error('processUnknow', '战斗奖励获取失败', rewardPack[0]);
				}
				outArgs.args.rewardid = rewardPack[1];
			} else {
				outArgs.state = MapElement.UNKNOW.MONSTER;
			}
			outArgs.args.monsterid = monster;
			outArgs.args.result = ret[0];
			outArgs.args.seed = ret[1];
		});
	} else if (parseInt(uidState, 10) === MapElement.UNKNOW.REWARD) {
		reward = Unknow[name].Reward;
		rewardPack = itemfunc.dropPool(reward, baseInfo, bagList, nodeInfo);
		if (rewardPack[0]) {
			tiny.log.error('processUnknow', '奖励获取失败', rewardPack[0]);
		}
		outArgs.state = MapElement.UNKNOW.GOT;
		outArgs.args.rewardid = rewardPack[1];
		nodeInfo.uidList[uid] = MapElement.UNKNOW.GOT;
	} else {
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		tiny.log.error('未知建筑已经领取过了', name);
	}
}

function processBuffStation(uidState, uid, name, nodeInfo, outArgs) {
	var buffid, value, newBuff = {};

	if (parseInt(uidState, 10) === MapElement.BUFFSTATION.INIT) {
		if (BuffStation.hasOwnProperty(name)) {
			buffid = BuffStation[name].Buff;
			if (BuffExp.hasOwnProperty(buffid)) {
				value = BuffExp[buffid].TimeArg;

				nodeInfo.buff[buffid] = value;

				tiny.log.trace('processBuffStation', JSON.stringify(nodeInfo));

				outArgs.state = MapElement.BUFFSTATION.PICKED;
				outArgs.args.buffid = buffid;

				nodeInfo.uidList[uid] = MapElement.BUFFSTATION.PICKED;
			} else {
				outArgs.retCode = ErrCode.MAP_UID_ENDED;
				tiny.log.error('BuffExp找不到buffid', buffid);
			}
		} else {
			outArgs.retCode = ErrCode.MAP_UID_ENDED;
			tiny.log.error('BuffStation找不到buffname', name);
		}
	} else {
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		tiny.log.error('buff已经领取过了', name);
	}
}

function processWatchTower(uid, name, nodeInfo, outArgs) {
	if (WatchTower.hasOwnProperty(name)) {
		outArgs.state = MapElement.WATCHTOWER.PICKED;
		nodeInfo.uidList[uid] = MapElement.WATCHTOWER.PICKED;
	} else {
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		tiny.log.error('找不到瞭望塔id', name);
	}
}

function processLObstacle(uidContent, uid, name, mapInfo, bagList, out, nextstate) {
	/*
	var item;
	tiny.log.trace('processLObstacle name=', name, utils.getValueType(name), nextstate);
	if (!LObstacle.hasOwnProperty(name)) {
		tiny.log.trace('processLObstacle name=', name);
		return;
	}
	item = LObstacle[name].ToItem;
	tiny.log.trace('processLObstacle = ', item, uidContent.state, parseInt(uidContent.state, 10), MapElement.LOBSTACLE.EXIST);
	if (parseInt(uidContent.state, 10) === MapElement.LOBSTACLE.EXIST &&
		nextstate === MapElement.LOBSTACLE.REMOVE) {
		out.args.ok = 0;
		out.args.costItem = item;
		if (!bag.delItem(item, 1, bagList)) {
			out.state = uidContent.state;
			tiny.log.trace('processLObstacle', 'del item fail', item, JSON.stringify(bagList));
			return;
		}

		out.state = MapElement.LOBSTACLE.REMOVE;
		out.args.ok = 1;
		uidContent.state = MapElement.LOBSTACLE.REMOVE;
		mapInfo.uidList[uid] = uidContent;
		tiny.log.trace("processLObstacle", JSON.stringify(out));
	}
	*/
}

function processChestChoo(uidState, uid, name, nodeInfo, baseInfo, bagList, in_args, outArgs) {
	var choo = parseInt(in_args.choo, 10), reward, prop, propStr, rewardStr, rand, rewardPack;
	if (!ChestChoo.hasOwnProperty(name)) {
		tiny.log.error('ChestChoo找不到name', name);
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
		return;
	}

	if (choo && (parseInt(uidState, 10) === MapElement.CHESTCHOO.INIT)) {
		propStr = 'Probability' + choo;
		rewardStr = 'Reward' + choo;
		tiny.log.trace('processChestChoo 选择=', propStr);
		if (ChestChoo[name].hasOwnProperty(propStr)) {
			prop = parseInt(ChestChoo[name][propStr], 10);
			reward = ChestChoo[name][rewardStr];
			rand = utils.randomInt(1, 100);
			tiny.log.trace('processChestChoo rand', prop, reward, rand);
			if (rand <= prop) {
				rewardPack = itemfunc.dropPool(reward, baseInfo, bagList, nodeInfo);
				if (rewardPack[0]) {
					tiny.log.error('processChestChoo', '选择奖励获取失败', rewardPack[0]);
				}
				outArgs.args.reward = rewardPack[1];
			}
			outArgs.state = MapElement.CHESTCHOO.CHOOD;
			outArgs.args.choo = choo;
			nodeInfo.uidList[uid] = MapElement.CHESTCHOO.CHOOD;
		} else {
			tiny.log.error('ChestChoo 没有此选择列', name, propStr);
			outArgs.retCode = ErrCode.MAP_UID_ENDED;
		}
	} else {
		tiny.log.error('ChestChoo已经领取过了', name);
		outArgs.retCode = ErrCode.MAP_UID_ENDED;
	}
}

function processMission() {
	/*
	tiny.log.trace('processMission =', uid, name, JSON.stringify(in_args));
	var floor = parseInt(in_args.floor, 10), maxFloor, monster, monsterList,
		reward = 0, nextstate = MapElement.MISSION.OPEN;
	if (!Mission.hasOwnProperty(name)) {
		tiny.log.trace('processMission name=', name);
		return;
	}

	if (parseInt(uidContent.state, 10) === MapElement.MISSION.OPEN) {

		monsterList = Mission[name].Monster;
		maxFloor = parseInt(Mission[name].Floors, 10);
		if (!maxFloor || floor > maxFloor ||
			!monsterList || !monsterList.hasOwnProperty(floor)) {
			tiny.log.trace('processMission floor=', floor, maxFloor, monsterList);
			return;
		}
		monster = monsterList[floor];
		if (floor === maxFloor) {
			reward = Mission[name].Reward;
			nextstate = MapElement.MISSION.END;
		}
		fightProc(mapid, monster, playerInfo, reward,
				uid, mapInfo, baseInfo, bagList, {},
				out, nextstate, uidContent, type, ap, afklist);
		if (out.state > 0 &&
			out.args.result === Const.FIGHT_RESULT.SUCCESS) { // 成功了记录层数
			mapInfo.uidList[uid].args.floor = floor;
		}
	}
	*/
}

function processNpc(uidState, uid, name, nodeInfo, outArgs) {
	if (parseInt(uidState, 10) === MapElement.NPC.INIT) {	// 第一次点击NPC
		if (MapNpc.hasOwnProperty(name)) {
			outArgs.state = MapElement.NPC.CLICKED;
			nodeInfo.uidList[uid] = MapElement.NPC.CLICKED;
		}
	}
	if (parseInt(uidState, 10) === MapElement.NPC.CLICKED) {	// 重复点击NPC
		if (MapNpc.hasOwnProperty(name)) {
			outArgs.state = MapElement.NPC.CLICKED;
			nodeInfo.uidList[uid] = MapElement.NPC.CLICKED;
		}
	}
}

// ===================================================以下为导出函数===================================================

// 处理uid事件
exports.processUid = function(outArgs, nodeid, mapInfo, nodeInfo, uid, nextstate, args, baseInfo, bagList, fightInfo) {
	var checkState = false, check = {}, uidState, type, name, mapid, noderet = {};

	mapid = WorldMap[nodeid].ResourceID;

	// 检查玩家当前位置是否在uid的有效范围内
	if (!checkUidPos(mapid, nodeInfo.x, nodeInfo.y, uid, nodeInfo.uidList, check)) {
		tiny.log.error('玩家不在此建筑有效范围内', uid, nodeInfo.x, nodeInfo.y);
		outArgs.retCode = ErrCode.MAP_UID_NOT_IN_AREA;
		return;
	}
	uidState = check.uidState;
	type = parseInt(check.type, 10);
	name = check.name;
	tiny.log.trace('processUid', uidState, nextstate, type);
	if (!ElementType.hasOwnProperty(type)) {
		tiny.log.error('没有找到对应的类型', type);
		outArgs.retCode = ErrCode.MAP_UID_TYPE_NOT_FOUND;
		return;
	}

	// 检查前置条件
	if (!checkPreContion(type, name, nodeInfo, baseInfo)) {
		tiny.log.error('前置条件不满足', type, name, JSON.stringify(nodeInfo));
		outArgs.retCode = ErrCode.MAP_UID_PRECHECK_FAIL;
		return;
	}

	outArgs.args = {};
	if (type === ConstMap.MAP_UID_TYPE.CHEST) {	// 资源宝箱
		processChest(uidState, uid, name, nodeInfo, baseInfo, bagList, outArgs);
	} else if (type === ConstMap.MAP_UID_TYPE.MONSTERCHAL) { // 挑战怪
		processMonsterchal(uidState, uid, name, nodeInfo, baseInfo, bagList, fightInfo, outArgs);
	} else if (type === ConstMap.MAP_UID_TYPE.UNKNOW) { // 未知建筑
		processUnknow(uidState, uid, name, nodeInfo, baseInfo, bagList, fightInfo, outArgs);
	} else if (type === ConstMap.MAP_UID_TYPE.BUFFSTATION) { // buff点
		processBuffStation(uidState, uid, name, nodeInfo, outArgs);
	} else if (type === ConstMap.MAP_UID_TYPE.WATCHTOWER) { // 瞭望塔
		processWatchTower(uid, name, nodeInfo, outArgs);
	// } else if (type === ConstMap.MAP_UID_TYPE.LOBSTACLE) { // 可除障碍
	// 	processLObstacle(uidContent, uid, name, mapInfo, bagList, out, nextstate);
	} else if (type === ConstMap.MAP_UID_TYPE.CHESTCHOO) { // 选择资源
		processChestChoo(uidState, uid, name, nodeInfo, baseInfo, bagList, args, outArgs);
	// } else if (type === ConstMap.MAP_UID_TYPE.MISSION) { // 连续挑战
	// 	processMission();
	} else if (type === ConstMap.MAP_UID_TYPE.NPC) { // NPC
		processNpc(uidState, uid, name, nodeInfo, outArgs);
	} else {
		tiny.log.error("processUid", "not support", type);
		outArgs.retCode = ErrCode.MAP_UID_TYPE_ERROR;
		return;
	}
	// 获取探索度并计算是否通关
	if (!outArgs.retCode) {
		if (addExplore(mapid, uid, mapInfo.openNode[nodeid])) {
			if (!nodeInfo.pass) {
				outArgs.args.pass = true;
				exports.addTimeNode(WorldMap[nodeid].Next, mapInfo, nodeid, mapid, nodeInfo.ap);
				// 如果通关了打上标记
				nodeInfo.pass = true;
			}
		}
		outArgs.args.process = mapInfo.openNode[nodeid].process;
	}
};

// 计算路径消耗
exports.calcPathCost = function(mapInfo, mapJson, path, uid) {
	var cost = 0, j = 0, pos, x = mapInfo.x, y = mapInfo.y;

	tiny.log.info('walk1111111111', path.length);

	while (j < path.length) {
		if (path[j].hasOwnProperty('x') && path[j].hasOwnProperty('y')) {
			tiny.log.info('walk22222222', path[j].x, path[j].y);
			// if (checkNearPoint(x, y, path[j].x, path[j].y)) {
				pos = path[j].x + path[j].y * mapJson.obsMap.width;
				if (mapJson.obsMap.data.hasOwnProperty(pos) && mapJson.obsMap.data[pos] === 0) {
					x = path[j].x;
					y = path[j].y;
					cost = cost + updateTerrain(x, y, mapJson.surface);
					++j;
				} else {
					tiny.log.error('obsMap not pos', pos);
					break;
				}
			// } else {
				// tiny.log.error('checkNearPoint', x, y, path[j].x, path[j].y);
				// break;
			// }
		} else {
			tiny.log.error('path', j, path[j]);
			break;
		}
	}

	tiny.log.info('walk enddddddddddddddd', x, y, cost, j, path.length);
	mapInfo.x = x;
	mapInfo.y = y;
	mapInfo.ap = mapInfo.ap + cost;
};

/*
uidObject = {
	name = 配置表key
	type = 配置表类型
	x =
	y =
}
px,py 为玩家起点坐标
start = { 为开始走的起点
	x =
	y =
}
验证玩家是否在建筑内，验证起点坐标是否紧贴建筑
*/
exports.checkPathUID = function(uidObject, px, py, start) {
	var name = uidObject.name,
		type = uidObject.type,
		x = uidObject.x,
		y = uidObject.y,
		sheet, area;

	tiny.log.trace('checkPathUID', name, type, x, y, px, py);
	if (!name || !type) {
		tiny.log.trace('checkPathUID', 1);
		return false;
	}

	sheet = getElementSheet(type);
	if (sheet) {
		if (!sheet.hasOwnProperty(name)) {
			tiny.log.trace('checkPathUID', 3);
			return false;
		}
		area = sheet[name].Area;
		tiny.log.trace('checkPathUID', JSON.stringify(area));
		if (checkPosInArea(px, py, x, y, area)) {
			return checkPosAroundArea(start.x, start.y, x, y, area);
		}
	}

	tiny.log.trace('checkPathUID', 4);
	return false;
};

exports.moveNode = function(timeNode, openNode, nodeid, now) {
	var time = now.diff(timeNode[nodeid].timeStamp, 'second'),
	leftTime = timeNode[nodeid].waitSec - time;
	tiny.log.trace('moveNode', timeNode[nodeid].waitSec, time, leftTime);
	if (leftTime <= 0) {
		openNode[nodeid] = {};
		if (WorldMap[nodeid].Type2 === ConstMap.NODE_TYPE.AFK) {
			openNode[nodeid].process = 100;
		} else {
			openNode[nodeid].process = 0;
		}
		openNode[nodeid].compAward = 0;
		delete timeNode[nodeid];
		return true;
	}
	timeNode[nodeid].waitSec = leftTime;
	return false;
};

exports.createNode = function(nodeid) {
	var info = {}, mapid;
	if (WorldMap[nodeid].Type2 === ConstMap.NODE_TYPE.MAP) {
		info.x = 0;
		info.y = 0;
		info.uidList = {};
		info.sign = {};
		info.buff = {};
		info.ap = 0;
		info.pass = false;
		mapid = WorldMap[nodeid].ResourceID;
		if (MapInfo.hasOwnProperty(mapid)) {
			if (MapInfo[mapid].hasOwnProperty("InitPos")) {
				info.x = MapInfo[mapid].InitPos['1'];
				info.y = MapInfo[mapid].InitPos['2'];
			}
		}
	} else {
		info.proAfkTime = moment().format();
		info.victoryTime = 0;
		info.fightTime = 0;
		info.rewardTime = 0;
	}
	return info;
};

exports.addTimeNode = function(nodes, map, nodeid, mapid, ap) {
	var com_ap = MapInfo[mapid].AP, time = MapInfo[mapid].Time, i,
	gap = 0, waitSec, waitLimit = WorldMap[nodeid].waitlimit,
	timestamp = moment().format();
	gap = (ap - com_ap) * time;
	waitSec = WorldMap[nodeid].wait;
	if (gap > 0) {
		waitSec = waitSec + gap;
	}
	if (waitSec > waitLimit) {
		waitSec = waitLimit;
	}
	if (utils.isObject(nodes)) {
		for (i in nodes) {
			if (nodes.hasOwnProperty(i)) {
				map.timeNode[nodes[i]] = {};
				map.timeNode[nodes[i]].timeStamp = timestamp;
				map.timeNode[nodes[i]].waitSec = waitSec;
				tiny.log.trace('addTimeNode', '添加计时节点1', nodes[i], waitSec, JSON.stringify(map));
			}
		}
	}
	if (utils.isNumber(nodes) && nodes !== 0) {
		map.timeNode[nodes] = {};
		map.timeNode[nodes].timeStamp = timestamp;
		map.timeNode[nodes].waitSec = waitSec;
		tiny.log.trace('addTimeNode', '添加计时节点2', nodes, waitSec, JSON.stringify(map));
	}
};

exports.addOpenNode = function(nodes, map) {
	var i, ret = {};
	if (utils.isObject(nodes)) {
		for (i in nodes) {
			if (nodes.hasOwnProperty(i)) {
				map.openNode[nodes[i]] = {};
				map.openNode[nodes[i]].process = 0;
				map.openNode[nodes[i]].compAward = 0;
				ret[nodes[i]] = exports.createNode(nodes[i]);
			}
		}
	}
	if (utils.isNumber(nodes) && nodes !== 0) {
		map.openNode[nodes] = {};
		map.openNode[nodes].process = 0;
		map.openNode[nodes].compAward = 0;
		ret[nodes] = exports.createNode(nodes);
	}
	return ret;
};

exports.getMapJson = function(name) {
	try {
		var map = require('../config/map/mapjson/' + name);
		// 对地图json文件的预处理
		formatMapJson(map);
		return map;
	} catch(e) {
		tiny.log.error('getMapJson', 'no this map', name);
		return undefined;
	}
};

//==============================================
