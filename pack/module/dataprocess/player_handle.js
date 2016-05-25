var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var heroHandle = require('./hero_handle');
var equipHandle = require('./equip_handle');
var skillHandle = require('./skill_handle');
var mapHandle = require('./map_handle');
var afkHandle = require('./afk_handle');
var mailHandle = require('./mail_handle');
var pvpHandle = require('./pvp_handle');
var Init = require('../config/other/initialization');
/*
//玩家信息
PlayerInfo
{
	uuid                  // 用户id
	area                  // 区服
	userName              // 用户名
	level                 // 等级
	curExp                // 当前经验
	action                // 行动力
	gold                  // 金币
	vip                   // vip
	diamond               // 钻石
	posList               // 英雄队伍列表 位置信息
	{
		1 : {
			heroId : 10001,
			pos : 4,
			equipIdList : {
				1 : 0,
				2 : 111,
				3 : 0,
				4 : 10021,
				5 : 12132,
				6 : 0
			}
		}
	}

--------------------这是一条分割线-------------------------------
--------------------以下数据不存数据库-------------------------------

	teamList              // 此数据不存 从英雄列表取
	{
		heroId : heroInfo
	}
	equipList           //上阵英雄装备列表 此数据不存数据库
	{
		1 : {
			id1 : {

			},
			id2 : {

			},
			id3 : {

			},
			id4 : {

			},
			id5 : {

			},
			id6 : {

			}
		}
	}
	bagList              // 不存数据库,另外保存
	{

	}
}
*/
exports.createRobotBaseInfo = function(area, uuid, userName) {
	var baseInfo = {};
	baseInfo.uuid = uuid;
	baseInfo.area = area;
	baseInfo.userName = userName;
	baseInfo.level = 1;
	baseInfo.curExp = 0;
	// baseInfo.action = Init[Const.INIT_ACTION].Value;
	baseInfo.gold = Init[Const.INIT_GOLD].Value;
	baseInfo.vip = 0;
	baseInfo.diamond = Init[Const.INIT_DIAMOND].Value;
	baseInfo.power = 500;
	baseInfo.posList = {
		1 : {
			"heroId" : 10013,
			"pos"    : 4,
			"equipIdList" : {1 : 10103, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		},
		2 : {
			"heroId" : 10003,
			"pos"    : 5,
			"equipIdList" : {1 : 0, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		},
		3 : {
			"heroId" : 10004,
			"pos"    : 6,
			"equipIdList" : {1 : 0, 2 : 0, 3 : 0, 4 : 0, 5 : 0, 6 : 0 }
		}
	};
	return baseInfo;
};
// 创建玩家基本数据
exports.createBaseInfo = function(area, uuid, userName, callback) {
	exports.setBaseInfo(area, uuid, exports.createRobotBaseInfo(area, uuid, userName), callback);
};

// 获取玩家基本数据
exports.getBaseInfo = function(area, uuid, callback) {
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'player'), function(err, baseInfo) {
		if (err) {
			callback(err);
		} else {
			if (baseInfo) {
				callback(null, baseInfo);
			} else {
				callback("baseInfo is null", {});
			}
		}
	});
};

// 保存玩家基本数据
exports.setBaseInfo = function(area, uuid, baseInfo, callback) {
	tiny.redis.set(utils.redisKeyGen(area, uuid, 'player'), baseInfo, callback);
};

// 修改玩家基本数据
exports.modBaseInfo = function(area, uuid, func, callback) {
	exports.getBaseInfo(area, uuid, function(err, baseInfo) {
		var result;
		if (err) {
			callback(err);
		} else {
			// 执行bind函数
			result = func(baseInfo);
			if (!result) {
				callback("get the result error");
				return;
			}
			exports.setBaseInfo(area, uuid, baseInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, result);
				}
			});
		}
	});
};

// 取上阵英雄列表
exports.getHeroIdsFromPosList = function(posList) {
	var heroIds = [], i;
	for (i in posList) {
		if (posList.hasOwnProperty(i)
			&&  parseInt(posList[i].heroId, 10) !== 0
			&&  parseInt(posList[i].heroId, 10) !== -1) {
			heroIds.push(posList[i].heroId);
		}
	}
	return heroIds;
};

// 取上阵装备列表
var getEquipIdsFromPosList = function(posList) {
	var equipIds = [], i, id;
	for (i in posList) {
		if (posList.hasOwnProperty(i)) {
			for (id in posList[i].equipIdList) {
				if (posList[i].equipIdList.hasOwnProperty(id) &&
					posList[i].equipList[id] !== 0) {
					equipIds.push(posList[i].equipList[id]);
				}
			}
		}
	}
	return equipIds;
};

// 转换pos信息到装备列表
exports.transPosListToEquipList = function(posList, equips) {
	var equipList = {}, i,id;
	for (i in posList) {
		if (posList.hasOwnProperty(i)) {
			equipList[i] = {};
			for (id in posList[i].equipIdList) {
				if (posList[i].equipIdList.hasOwnProperty(id) &&
					equips.hasOwnProperty(posList[i].equipIdList[id])) {
					equipList[i][posList[i].equipIdList[id]] = equips[posList[i].equipIdList[id]];
				}
			}
		}
	}
	return equipList;
};

// 转换pos信息到团队列表
exports.transPosListToTeamList = function(posList, heroList) {
	var i, teamList = {};
	for (i in posList) {
		if (posList.hasOwnProperty(i) &&
			heroList.hasOwnProperty(posList[i].heroId)) {
			teamList[posList[i].heroId] = heroList[posList[i].heroId];
			teamList[posList[i].heroId].pos = posList[i].pos;
		}
	}
	return teamList;
};

// 将基础数据转换为玩家数据
exports.transBaseInfoToPlayerInfo = function(baseInfo, teamHeroList, bagList) {
	baseInfo.teamList = teamHeroList;
	baseInfo.equipList = exports.transPosListToEquipList(baseInfo.posList, bagList.equipList);
	return baseInfo;
};

exports.getPlayerInfoEx = function(baseInfo, teamHeroList, bagList) {
	// 设置teamList数据position
	baseInfo.teamList = exports.transPosListToTeamList(baseInfo.posList, teamHeroList);
	// 设置上阵装备列表
	baseInfo.equipList = exports.transPosListToEquipList(baseInfo.posList, bagList.equipList);
	return baseInfo;
};

exports.getPlayerInfo = function(area, uuid, callback) {
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'player'), function(err, playerInfo) {
		var heroIds;
		if (err) {
			callback(err);
		} else {
			if (playerInfo) {
				// 转换上阵英雄列表
				heroIds = exports.getHeroIdsFromPosList(playerInfo.posList);
				// 取上阵英雄列表
				heroHandle.getTeamHeroList(area, uuid, heroIds, function(err, teamHeroList) {
					if (err) {
						// 取不到团队列表报错但不中断
						tiny.log.error('getTeamHeroList', area, uuid, err);
						playerInfo.teamList = {};
					}
					if (teamHeroList) {
						// 设置teamList数据position
						playerInfo.teamList = exports.transPosListToTeamList(playerInfo.posList, teamHeroList);
					}
					// 取背包列表
					equipHandle.getBagList(area, uuid, function(err, bagList) {
						if (err) {
							// 取不到装备列表报错但不中断
							tiny.log.error('getBagList', area, uuid, err);
							playerInfo.equipList = {};
							playerInfo.bagList = {};
						}
						if (bagList) {
							// 设置上阵装备列表
							playerInfo.bagList = bagList;
							if (bagList.hasOwnProperty("equipList")) {
								playerInfo.equipList = exports.transPosListToEquipList(playerInfo.posList, bagList.equipList);
							}
						}
						// 设置pvpSng
						pvpHandle.setPvpSng(playerInfo, function(err) {
							if (err) {
								tiny.log.error("setPvpSng error", err);
							}
						});
						callback(null, playerInfo);
					});
				});
			} else {
				callback(null, null);
			}
		}
	});
};

// 获取玩家上阵英雄列表
exports.getTeamHeroList = function(area, uuid, baseInfo, callback) {
	var heroIds, teamList;
	// 转换上阵英雄列表
	heroIds = exports.getHeroIdsFromPosList(baseInfo.posList);
	// 取上阵英雄列表
	heroHandle.getTeamHeroList(area, uuid, heroIds, function(err, teamHeroList) {
		if (err) {
			callback(err, null);
		}
		teamList = exports.transPosListToTeamList(baseInfo.posList, teamHeroList);
		callback(null, teamList);
	});
};

// 获取玩家战斗力
exports.getPlayerPower = function(baseInfo, teamList, bagList) {
	var heroId, playerPower = 0, equipList, i, equipId;
	equipList = exports.transPosListToEquipList(baseInfo.posList, bagList.equipList);
	for (heroId in teamList) {
		if (teamList.hasOwnProperty(heroId)) {
			playerPower += heroHandle.getHeroPower(teamList[heroId]);
		}
	}
	for (i in equipList) {
		if (equipList.hasOwnProperty(i)) {
			for (equipId in equipList[i]) {
				if (equipList[i].hasOwnProperty(equipId)) {
					playerPower += equipHandle.getEquipPower(equipList[i][equipId]);
				}
			}
		}
	}
	return playerPower;
};

// 创建玩家数据
exports.createPlayerInfo = function(area, uuid, userName, callback) {
	var playerInfo;
	// 创建玩家基本数据
	exports.createBaseInfo(area, uuid, userName, function(err, baseInfo) {
		if (err) {
			callback(err);
		} else {
			// 玩家基本数据
			playerInfo = baseInfo;
			// 创建英雄列表
			heroHandle.createHeroList(area, uuid, function(err, teamHeroList) {
				if (err) {
					callback(err);
				} else {
					// 创建背包
					equipHandle.createBagList(area, uuid, function(err, bagList) {
						if (err) {
							callback(err);
						} else {
							// 创建地图
							mapHandle.createGlobalMapInfo(area, uuid, function(err) {
								var i;
								if (err) {
									callback(err);
								} else {
									// 设置pvpSng
									// 计算战斗力
									for (i in teamHeroList) {
										if (teamHeroList.hasOwnProperty(i)) {
											playerInfo.power += heroHandle.getHeroPower(teamHeroList[i]);
										}
									}
									pvpHandle.setPvpSng(playerInfo, function(err) {
										if (err) {
											tiny.log.error("setPvpSng error", err);
										}
									});
									// 创建pvp信息
									pvpHandle.createPvpInfo(area, uuid, function(err) {
										if (err) {
											callback(err);
										} else {
											// 创建团队装备
											playerInfo.equipList = exports.transPosListToEquipList(baseInfo.posList, bagList.equipList);
											playerInfo.teamList  = exports.transPosListToTeamList(baseInfo.posList, teamHeroList);
											playerInfo.bagList   = bagList;
											// 生成上阵英雄装备
											callback(null, playerInfo);
										}
									});
								}
							});
						}
					});
				}
			});
		}
	});
};

// 增加经验值
exports.addPlayerExp = function(exp, playerInfo) {
	// 升级团队经验
	var upgradeLevel = 0;
	// 增加经验
	playerInfo.curExp = playerInfo.curExp + exp;
	// 计算是否升级以及升级等级
	upgradeLevel = heroHandle.calExpAndLevel(playerInfo);
	// 计算超过等级上限情况
	playerInfo.level = heroHandle.limitLevel(upgradeLevel);
	return true;
};

// 提升团队经验，等级
exports.updatePlayerExp= function(area, uuid, exp, callback) {
	exports.getBaseInfo(area, uuid, function(err, playerInfo) {
		if (err) {
			callback(err);
		} else {
			if (!exp) {
				callback(null, playerInfo);
				return;
			}
			// 增加经验值
			exports.addPlayerExp(exp, playerInfo);
			// 保存玩家数据
			exports.setBaseInfo(area, uuid, playerInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, playerInfo);
				}
			});
		}
	});
};

// 增加玩家的行动力
// exports.addPlayerAction = function(action, playerInfo) {
// 	var tmp = 0;
// 	// 判断金钱合法值
// 	tmp = playerInfo.action + action;
// 	if (tmp >= Const.PLAYER_ACTION_MIN &&
// 		tmp <= Const.PLAYER_ACTION_MAX) {
// 		playerInfo.action = tmp;
// 		return tmp;
// 	}
// 	return null;
// };

// 增加玩家金钱
exports.addPlayerGold = function(gold, playerInfo) {
	var tmp = 0;
	// 判断金钱合法值
	tmp = playerInfo.gold + gold;
	if (tmp >= Const.COMMON_VALUE_MIN &&
		tmp <= Const.COMMON_VALUE_MAX) {
		playerInfo.gold = tmp;
		return tmp;
	}
	return null;
};

// 增加玩家钻石
exports.addPlayerDiamond = function(diamond, playerInfo) {
	var tmp = 0;
	// 判断钻石合法值
	tmp = playerInfo.diamond + diamond;
	if (tmp >= Const.COMMON_VALUE_MIN &&
		tmp <= Const.COMMON_VALUE_MAX) {
		playerInfo.diamond = tmp;
		return tmp;
	}
	return null;
};

// 修改玩家金钱数量
exports.modPlayerGold = function(area, uuid, gold, callback) {
	exports.getBaseInfo(area, uuid, function(err, playerInfo) {
		if (err) {
			callback(err);
		} else {
			// 修改玩家金钱
			if (exports.addPlayerGold(gold, playerInfo) === 0) {
				callback(null, playerInfo);
				return;
			}
			// 合法则保存数据
			exports.setBaseInfo(area, uuid, playerInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, playerInfo);
				}
			});
		}
	});
};

// 修改玩家钻石数量
exports.modPlayerDiamond = function(area, uuid, diamond, callback) {
	exports.getBaseInfo(area, uuid, function(err, playerInfo) {
		if (err) {
			callback(err);
		} else {
			if (playerInfo) {
				// 修改玩家钻石
				if (exports.addPlayerDiamond(diamond, playerInfo) === 0) {
					callback(null, playerInfo);
					return;
				}
				// 合法则保存数据
				exports.setBaseInfo(area, uuid, playerInfo, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, playerInfo);
					}
				});
			} else {
				callback("playerInfo is null");
			}
		}
	});
};


// 增加经验和金钱
// exports.updatePlayerInfo = function(area, uuid, gold, exp, action, callback) {
// 	var heroIds;
// 	exports.getBaseInfo(area, uuid, function(err, playerInfo) {
// 		if (err) {
// 			callback(err);
// 		} else {
// 			if (playerInfo) {
// 				// 修改玩家金钱
// 				exports.addPlayerGold(gold, playerInfo);
// 				// 增加经验值
// 				exports.addPlayerExp(exp, playerInfo);
// 				// 增加行动力
// 				exports.addPlayerAction(action, playerInfo);
// 				// 取团队英雄id
// 				heroIds = exports.getHeroIdsFromPosList(playerInfo.posList);
// 				// 升级英雄经验
// 				heroHandle.updateHerosExpInHeroList(area, uuid, heroIds, exp, function(err, teamList) {
// 					if (err) {
// 						callback(err);
// 					} else {
// 						// 保存玩家数据
// 						exports.setBaseInfo(area, uuid, playerInfo, function(err) {
// 							if (err) {
// 								callback(err);
// 							} else {
// 								// 转换团队英雄列表
// 								playerInfo.teamList = exports.transPosListToTeamList(playerInfo.posList, teamList);
// 								callback(null, playerInfo);
// 							}
// 						});
// 					}
// 				});
// 			} else {
// 				callback("playerInfo is null");
// 			}
// 		}
// 	});
// };

// 向队伍列表添加英雄
exports.addHeroToTeamList = function(area, uuid, teamId, heroId, callback) {
	exports.getPlayerInfo(area, uuid, function(err, playerInfo) {
		if (err) {
			callback(err);
		} else {
			if (playerInfo) {
				playerInfo.teamList[teamId] = heroId;
				tiny.redis.set(utils.redisKeyGen(area, uuid, 'player'), playerInfo, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, playerInfo);
					}
				});
			} else {
				callback('playerInfo is null');
			}
		}
	});
};
/*
*/

var getPosition = function(pos) {
	return parseInt(pos, 10) - Const.LINEUP_MAX_POS;
};

var setPosition = function(pos) {
	return parseInt(pos, 10) + Const.LINEUP_MAX_POS;
};

// 英雄布阵
exports.makeHeroLineup = function(area, uuid, posDst, heroId, callback) {
	var tmp, checkHero = true;
	exports.getBaseInfo(area, uuid, function(err, baseInfo) {
		var i;
		if (err) {
			callback(err);
		} else {
			tiny.log.debug("before lineup", JSON.stringify(baseInfo));
			posDst = getPosition(posDst);
			if (posDst < Const.LINEUP_MIN_POS
				|| posDst > Const.LINEUP_MAX_POS) {
				callback("dst pos don't match " + posDst);
				return;
			}

			// 布阵
			for (i in baseInfo.posList) {
				if (baseInfo.posList.hasOwnProperty(i)) {
					if (baseInfo.posList[i].heroId === heroId) {
						tmp = baseInfo.posList[posDst];
						baseInfo.posList[posDst] = baseInfo.posList[i];
						baseInfo.posList[i] = tmp;
						baseInfo.posList[posDst].pos = setPosition(posDst);
						baseInfo.posList[i].pos = setPosition(i);
						checkHero = false;
						break;
					}
				}
			}

			// 换将
			if (checkHero) {
				heroHandle.getHeroInfo(area, uuid, heroId, function(err) {
					if (err) {
						callback(err);
					} else {
						baseInfo.posList[posDst].heroId = heroId;
						exports.setBaseInfo(area, uuid, baseInfo, function(err) {
							if (err) {
								callback(err);
							} else {
								tiny.log.debug("after lineup", JSON.stringify(baseInfo));
								callback(null, baseInfo);
							}
						});
					}
				});
				return;
			}

			exports.setBaseInfo(area, uuid, baseInfo, function(err) {
				if (err) {
					callback(err);
				} else {
					tiny.log.debug("after lineup", JSON.stringify(baseInfo));
					callback(null, baseInfo);
				}
			});
		}
	});
};

// 换英雄
exports.changeHero = function(area, uuid, pos, heroId, callback) {
	exports.getBaseInfo(area, uuid, function(err, baseInfo) {
		if (err) {
			callback(err);
		} else {
			if (pos < Const.LINEUP_MIN_POS
				&& pos > Const.LINEUP_MAX_POS) {
				pos("pos don't match " + pos);
				return;
			}
			heroHandle.getHeroInfo(area, uuid, heroId, function(err) {
				if (err) {
					callback(err);
				} else {
					baseInfo.posList[pos].heroId = heroId;
					exports.setBaseInfo(area, uuid, baseInfo, function(err) {
						if (err) {
							callback(err);
						} else {
							callback(null, baseInfo);
						}
					});
				}
			});
		}
	});
};

exports.getUUIDfromName = function() {

};
