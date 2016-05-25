var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var playerHandle = require('./player_handle');
var bag = require('../bag/bag');
var item = require('../item/item');
var eqStar = require('../config/equip/eqStar');
var Item = require('../config/pick/item');
var Make = require('../config/equip/make');
var Unlock = require('../config/pick/unlock');
var Init = require('../config/other/initialization');
/*
bagList
{
	max : 20
	"itemList" : {
		id ：{
			num
		}
	}
	//装备
	"equipList" : {
		index ： {
			num
			id
			star
			a1              -1 代表没有 0 代表有坑
			n1
			a2
			n2
			a3
			n3
			a4
			n4
			sa
			sn
		}
	}
}
*/

exports.createRobotBagList = function() {
	var bagList = {};
	bagList = {
		"max" : 100,
		"itemList" : {

		},
		"equipList" : {

		}
	};
	return bagList;
};

// 创建默认背包列表
exports.createBagList = function(area, uuid, callback) {
	var bagList = exports.createRobotBagList(), i, itemId, itemNum;
	for (i in Init[Const.INIT_ITEM].Value) {
		if (Init[Const.INIT_ITEM].Value.hasOwnProperty(i)) {
			itemId = Init[Const.INIT_ITEM].Value[i][1];
			itemNum = Init[Const.INIT_ITEM].Value[i][2];
			bag.addItem(itemId, itemNum, bagList);
		}
	}
	exports.setBagList(area, uuid, bagList, callback);
};

// 获取背包
exports.getBagList = function(area, uuid, callback) {
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'bag'), function(err, bagList) {
		if (err) {
			callback(err);
		} else {
			if (bagList) {
				callback(null, bagList);
			} else {
				callback("bagList is null", {});
			}
		}
	});
};

// 设置背包列表
exports.setBagList = function(area, uuid, bagList, callback) {
	tiny.redis.set(utils.redisKeyGen(area, uuid, 'bag'), bagList, callback);
};

// 修改背包列表
exports.modBagList = function(area, uuid, func, callback) {
	exports.getBagList(area, uuid, function(err, bagList) {
		var result;
		if (err) {
			callback(err);
		} else {
			// 执行bind函数
			result = func(bagList);
			if (!result) {
				callback("get the result error");
				return;
			}
			exports.setBagList(area, uuid, bagList, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, result);
				}
			});
		}
	});
};

// 检查装备是否已经穿上
var checkEquipOn = function(posList, pos, id, equipId) {
	if (posList.hasOwnProperty(pos)) {
		if (posList[pos].equipIdList.hasOwnProperty(id) &&
			posList[pos].equipIdList[id] === equipId) {
			return true;
		}
	}
	return false;
};

// 卸下除了pos位置之外的其他位置的装备
// pos     布阵位置
// id      装备位置
// equipId 装备ID
var offEquipOtherPosition = function(posList, pos, id, equipId) {
	var i;
	for (i in posList) {
		if (posList.hasOwnProperty(i) && i !== pos) {
			if (posList[i].equipIdList.hasOwnProperty(id) &&
				posList[i].equipIdList[id] === equipId) {
				posList[i].equipIdList[id] = 0;
			}
		}
	}
	return posList;
};

// 更换具体位置装备
exports.changeEquipInPosition = function(posList, seq, sign, equipIds, bagList) {
	var idName, equipId;
	// 检查背包并保存上阵装备
	for (idName in equipIds) {
		// id标识的合法性
		if (equipIds.hasOwnProperty(idName)) {
			// 获取装备id
			equipId = equipIds[idName];
			// 判断是否对此部位id进行处理
			if (equipId && bagList.equipList.hasOwnProperty(equipId) &&
				posList.hasOwnProperty(seq)) {
				if (sign === Const.EQUIP_SET_ON) {
					// 卸装其他位置
					posList = offEquipOtherPosition(posList, seq, idName, equipId);
					// 上装
					posList[seq].equipIdList[idName] = equipId;
				} else if (sign === Const.EQUIP_SET_OFF &&
					checkEquipOn(posList, seq, idName, equipId)) {
					// 卸装
					posList[seq].equipIdList[idName] = 0;
				}
			}
		}
	}
	return posList;
};

// 卸下装备
exports.offEquip = function(baseInfo, equipId) {
	var i;
	for (i = 1; i <= 6; i++) {
		offEquipOtherPosition(baseInfo.posList, -1, i, equipId);
	}
};

// 上装 卸下
exports.changeEquip = function(area, uuid, sign, seq, equipIds, callback) {
	// 取玩家数据
	playerHandle.getBaseInfo(area, uuid, function(err, playerInfo) {
		if (err) {
			callback(err);
		} else {
			// 取背包数据
			exports.getBagList(area, uuid, function(err, bagList) {
				if (err) {
					callback(err);
				} else {
					// 更换具体位置装备
					playerInfo.posList = exports.changeEquipInPosition(playerInfo.posList, seq, sign, equipIds, bagList);
					// 保存playerinfo
					playerHandle.setBaseInfo(area, uuid, playerInfo, function(err) {
						var equipList;
						if (err) {
							callback(err);
						} else {
							// 生成装备列表
							equipList = playerHandle.transPosListToEquipList(playerInfo.posList, bagList.equipList);
							// 生成客户端装备列表
							callback(null, equipList);
						}
					});
				}
			});
		}
	});
};

// 获取升星后的装备
var dealUpgradeEquipStar = function(equip, ids) {
	if (ids) {
		equip.star= equip.star + 1;
		return equip;
	}
	return null;
};

// 升星
exports.upgradeEquipStar = function(area, uuid, equipId, ids, callback) {
	// 取玩家数据 扣金钱
	// 取背包数据 检查装备和道具 扣强化石
	// 计算成功率
	// 升级
	// 保存数据 背包数据

	//取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		var i, result, gold, equip;
		if (err) {
			callback(err);
		} else {
			// 检查强化石是否在背包中并且删除强化石
			for (i in ids) {
				if (ids.hasOwnProperty(i)) {
					if (ids[i] && !bag.delItem(ids[i], 1, bagList)) {
						callback("ids:" + ids[i] + " is not in bagList");
						return;
					}
					if (ids[i] && !bag.isStone(ids[i])) {
						callback("ids:" + ids[i] + " is not stone");
						return;
					}
				}
			}
			// 检查装备是否在背包中
			if (bag.getItemNum(equipId, bagList) === 0) {
				callback("equipId:" + equipId + " is not in bagList");
				return;
			}
			// 取装备信息
			equip = bagList.equipList[equipId];
			// 判断装备星级
			if (equip.star >= Const.EQUIP_STAR_LEVEL_LIMIT) {
				callback("equipId:" + equipId + " is level limit");
				return;
			}
			// 取配置表信息
			if (!eqStar[equip.star + 1] || !eqStar[equip.star + 1].cost) {
				callback("equipId:" + equipId + " config is error");
				return;
			}
			// 取扣费金钱
			gold = eqStar[equip.star + 1].cost;
			gold = Number.parseInt(gold, 10) * -1;
			// 扣费
			playerHandle.modPlayerGold(area, uuid, gold, function(err) {
				var equipReult;
				if (err) {
					// 扣费失败
					callback(err);
				} else {
					// 获取升星后的装备
					result = dealUpgradeEquipStar(bagList.equipList[equipId], ids);
					if (result) {
						// 升星成功
						bagList.equipList[equipId] = result;
						equipReult = {};
						equipReult.index = equipId;
						equipReult.star = result.star;
					}
					// 保存数据
					exports.setBagList(area, uuid, bagList, function(err) {
						if (err) {
							callback(err);
						} else {
							callback(null, equipReult);
						}
					});
				}
			});
		}
	});
};

// 拆分装备处理背包数据
exports.dealSplitEquipInBagList = function(bagList, splitConfig, equipId, result) {
	var i, itemId, num;
	// 删除装备
	if (!bag.delItem(equipId, 1, bagList)) {
		return null;
	}
	// 增加道具
	if (splitConfig) {
		for (i in splitConfig) {
			if (splitConfig.hasOwnProperty(i)) {
				if (splitConfig[i][1] !== "gold") {
					itemId = splitConfig[i][1];
					num = splitConfig[i][2];
					// 添加
					if (!item.getItemAward(itemId, num, bagList, result)) {
						return null;
					}
				}
			}
		}
	}
};

// 获取金币
exports.getGoldFromSplitConfig = function(splitConfig) {
	var i;
	for (i in splitConfig) {
		if (splitConfig.hasOwnProperty(i)) {
			if (splitConfig[i][1] === "gold") {
				return splitConfig[i][2];
			}
		}
	}
	return 0;
};

// 拆分
exports.splitEquip = function(area, uuid, equipIdList, callback) {
	// 取背包数据 检查装备
	// 扣装备
	// 取玩家数据 +金钱
	// 生成强化石
	// 保存数据 背包数据
	//取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		var result, gold, equip, i, equipId;
		if (err) {
			callback(err);
		} else {
			gold = 0;
			result = {};
			result.itemList = {};
			for (i = 0; i < equipIdList.length; i++) {
				equipId = equipIdList[i];
				// 检查装备是否在背包中
				if (bag.getItemNum(equipId, bagList) === 0) {
					callback("equipId:" + equipId + " is not in bagList");
					return;
				}
				// 取装备信息
				equip = bagList.equipList[equipId];
				// 取拆分结构
				if (equip.star !== 0) {
					// 取配置表信息
					if (!eqStar[equip.star] || !eqStar[equip.star].splitReturn) {
						callback("equipId:" + equipId + " config is error");
						return;
					}
					// 取金钱
					gold += exports.getGoldFromSplitConfig(eqStar[equip.star].splitReturn);
					// 获取拆分道具,删除装备
					exports.dealSplitEquipInBagList(bagList, eqStar[equip.star].splitReturn, equipId, result);
					if (!result) {
						callback("equipId:" + equipId + " is not in bagList");
						return;
					}
				} else {
					exports.dealSplitEquipInBagList(bagList, null, equipId, result);
					if (!result) {
						callback("equipId:" + equipId + " is not in bagList");
						return;
					}
					gold += 100;
				}
			}
			// 增加金钱
			playerHandle.modPlayerGold(area, uuid, gold, function(err) {
				if (err) {
					// 增加金钱失败
					callback(err);
				} else {
					// 保存数据
					exports.setBagList(area, uuid, bagList, function(err) {
						if (err) {
							callback(err);
						} else {
							callback(null, result.itemList, gold);
						}
					});
				}
			});
		}
	});
};

// 取装备战斗力
exports.getEquipPower = function(equip) {
	//item
	tiny.log.debug("getEquipPower", equip.id);
	return Item[equip.id].auNo + equip.n1 + equip.n2 + equip.n3 + equip.n4;
};

//var aaa = 1600000;
// 创建装备
exports.createEquip = function(equipId) {
	// 取玩家数据
	var index, a = true;

	//index = (Date.now() - 1436339037041) * 10000 + utils.randomInt(1,10000) * 100 + tiny.get('id');
	//                      14380644371856100
	// 时间戳 + 随机码 + 服务器标识
	index = Date.now() * 10000 + utils.randomInt(1,100) * 100 + parseInt(tiny.get('seq'), 10);
	//aaa++;
	//index = aaa * 1000 + utils.randomInt(1,10000);
                        //1436224027 00000 00
                        //1436861668422
    if (Item[equipId].itemQuality === Const.EQUIP_QUALITY_WHITE) {
		return {"index" : index,
			"equipInfo" : {
				id : equipId,
				num : 1,
				star : 0,
				a1 : 0, n1 : 0,
				a2 : 0, n2 : 0,
				a3 : 0, n3 : 0,
				a4 : 0, n4 : 0,
				sa : 0,
				sn : 0,
				ss : 0}
			};
    } if (Item[equipId].itemQuality === Const.EQUIP_QUALITY_GREE) {
		if (a) {
			a = false;
			return {"index" : index,
				"equipInfo" : {
					id : equipId,
					num : 1,
					star : 0,
					a1 : 6, n1 : 20,
					a2 : 0, n2 : 0,
					a3 : 0, n3 : 0,
					a4 : 0, n4 : 0,
					sa : 0,
					sn : 0,
					ss : 0}
				};
		}
		a = true;
		return {"index" : index,
			"equipInfo" : {
				id : equipId,
				num : 1,
				star : 0,
				a1 : 6, n1 : 20,
				a2 : 0, n2 : 0,
				a3 : 0, n3 : 0,
				a4 : 0, n4 : 0,
				sa : 0,
				sn : 0,
				ss : 0}
			};
    } if (Item[equipId].itemQuality === Const.EQUIP_QUALITY_BLUE) {
		return {"index" : index,
			"equipInfo" : {
				id : equipId,
				num : 1,
				star : 0,
				//a1 : 5, n1 : 70,
				//a2 : 6, n2 : 25,
				a1 : 6, n1 : 25,
				a2 : 5, n2 : 40,
				a3 : 0, n3 : 0,
				a4 : 0, n4 : 0,
				sa : 0,
				sn : 0,
				ss : 0}
			};
    } if (Item[equipId].itemQuality === Const.EQUIP_QUALITY_PURPLE) {
		return {"index" : index,
			"equipInfo" : {
				id : equipId,
				num : 1,
				star : 0,
				a1 : 6, n1 : 40,
				a2 : 5, n2 : 20,
				a3 : 5, n3 : 40,
				a4 : 0, n4 : 0,
				sa : 0,
				sn : 0,
				ss : 0}
			};
    } if (Item[equipId].itemQuality === Const.EQUIP_QUALITY_ORANGE) {
		return {"index" : index,
			"equipInfo" : {
				id : equipId,
				num : 1,
				star : 0,
				a1 : 6, n1 : 40,
				a2 : 6, n2 : 30,
				a3 : 5, n3 : 30,
				a4 : 5, n4 : 50,
				sa : 0,
				sn : 0,
				ss : 0}
			};
    }
	return {"index" : index,
	"equipInfo" : {
		id : equipId,
		num : 1,
		star : 0,
		a1 : 0, n1 : 0,
		a2 : 0, n2 : 0,
		a3 : 0, n3 : 0,
		a4 : 0, n4 : 0,
		sa : 0,
		sn : 0,
		ss : 0}
	};
};

// 为左侧装备添加属性
exports.dealAttrInEquip = function(bagList, lequipId, requipId, attr) {
	var lequip, requip, j, i, vTmp = [];
	lequip = bagList.equipList[lequipId];
	requip = bagList.equipList[requipId];
	// 取随机数
	for (j = 1; j <= Const.EQUIP_ATTR_MAX; j++) {
		if (requip['a' + j] !== -1) {
			vTmp.push(j);
		}
	}
	if (vTmp.length !== 0) {
		i = vTmp[utils.randomInt(0, vTmp.length - 1)];
	} else {
		tiny.log.error(".............don't have attr");
		return lequip;
	}
	// 保存替换属性
	if (attr < Const.EQUIP_ATTR_MIN || attr > Const.EQUIP_ATTR_MAX) {
		return null;
	}
	lequip.sa = lequip['a' + attr];
	lequip.sn = lequip['n' + attr];
	lequip.ss = attr;
	lequip['a' + attr] = requip['a' + i];
	lequip['n' + attr] = requip['n' + i];

	return lequip;
};

// 淬炼装备
exports.meltingEquip = function(area, uuid, lequipId, requipId, attr, callback) {
	// 取背包数据 检查装备
	// 取玩家数据 +金钱
	// 生成强化石
	// 淬炼属性
	// 保存数据 背包数据
	// 取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		var result, splitReturn, gold, equip;
		if (err) {
			callback(err);
		} else {
			result = {};
			result.itemList = {};
			// 检查装备是否在背包中
			if (bag.getItemNum(lequipId, bagList) === 0) {
				callback("lequipId:" + lequipId + " is not in bagList");
				return;
			}
			if (bag.getItemNum(requipId, bagList) === 0) {
				callback("requipId:" + requipId + " is not in bagList");
				return;
			}
			// 取拆分结构
			if (bagList.equipList[requipId].star === 0) {
				splitReturn = {};
				gold = 100;
			} else {
				splitReturn = eqStar[bagList.equipList[requipId].star].splitReturn;
				// 取金钱
				gold = exports.getGoldFromSplitConfig(splitReturn);
			}
			// 增加金钱
			playerHandle.modPlayerGold(area, uuid, gold, function(err) {
				if (err) {
					// 增加金钱失败
					callback(err);
				} else {
					// 淬炼装备属性
					equip = exports.dealAttrInEquip(bagList, lequipId, requipId, attr);
					if (!equip) {
						callback("get equip attr fail");
					}
					equip.index = lequipId;
					// 获取拆分道具,删除装备
					exports.dealSplitEquipInBagList(bagList, splitReturn, requipId, result);
					if (!result) {
						callback("requipId:" + requipId + " is not in bagList");
						return;
					}
					// 保存背包数据
					exports.setBagList(area, uuid, bagList, function(err) {
						if (err) {
							callback(err);
						} else {
							callback(null, equip, result.itemList, gold);
						}
					});
				}
			});
		}
	});
};

// 为装备反转属性
exports.rvdealAttrInEquip = function(bagList, equipId) {
	var equip;
	equip = bagList.equipList[equipId];
	if (!equip.hasOwnProperty("sa") || !equip.hasOwnProperty("sn") || !equip.hasOwnProperty("ss")) {
		return null;
	}
	equip['a' + equip.ss] = equip.sa;
	equip['n' + equip.ss] = equip.sn;
	return equip;
};

// 反转淬炼装备
exports.rvmeltingEquip = function(area, uuid, equipId, callback) {
	// 取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		var equip;
		if (err) {
			callback(err);
		} else {
			// 检查装备是否在背包中
			if (bag.getItemNum(equipId, bagList) === 0) {
				callback("equipId:" + equipId + " is not in bagList");
				return;
			}
			// 为装备反转属性
			equip = exports.rvdealAttrInEquip(bagList, equipId);
			if (!equip) {
				callback(equipId + " rvmelting fail!");
				return;
			}
			// 保存背包数据
			exports.setBagList(area, uuid, bagList, function(err) {
				if (err) {
					callback(err);
				} else {
					equip.index = equipId;
					callback(null, equip);
				}
			});
		}
	});
};

// 检查配置背包
exports.checkMakeConfig = function(bagList, scrollId) {
	var i, itemId, itemNum, weightScope = [], indexScope = [];
	// 检查配置表
	if (!Make[scrollId] || !Make[scrollId].data1 || !Make[scrollId].eqScroll) {
		return null;
	}
	// 检查道具数量是否足够
	for  (i in Make[scrollId].data1) {
		if (Make[scrollId].data1.hasOwnProperty(i)) {
			itemId = Make[scrollId].data1[i][1];
			itemNum = Make[scrollId].data1[i][2];
			// 删除道具
			if (!bag.delItem(itemId, itemNum, bagList)) {
				return null;
			}
		}
	}
	// 删除道具
	if (!bag.delItem(scrollId, 1, bagList)) {
		return null;
	}
	// 获取装备itemId
	// 随机等待数值计算
	for (i in Make[scrollId].eqScroll) {
		if (Make[scrollId].eqScroll.hasOwnProperty(i)) {
			indexScope.push(Make[scrollId].eqScroll[i][1]);
			weightScope.push(Make[scrollId].eqScroll[i][2]);
		}
	}
	return utils.randomScope(indexScope, weightScope);
};

// 批量打造装备
var makeEquips = function(scrollList, bagList) {
	var equipData, itemId, i, equipList = {};
	for (i = 0; i < scrollList.length; i++) {
		if (scrollList.hasOwnProperty(i)) {
			// 检查配置背包
			itemId = exports.checkMakeConfig(bagList, scrollList[i]);
			if (!itemId) {
				return null;
			}
			// 创建装备
			equipData = exports.createEquip(itemId);
			// 添加到背包
			if (!bag.addEquip(equipData.index, equipData.equipInfo, bagList)) {
				return null;
			}
			equipList[equipData.index] = equipData.equipInfo;
		}
	}
	return equipList;
};

// 打造装备
exports.makeEquip = function(area, uuid, scrollList, callback) {
	var equipList;
	// 获取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		if (err) {
			callback(err);
		} else {
			// 批量打造装备
			equipList = makeEquips(scrollList, bagList);
			if (!equipList) {
				callback(scrollList + '|makeEquips fails');
				return;
			}
			// 保存背包数据
			exports.setBagList(area, uuid, bagList, function(err) {
				if (err) {
					callback(err);
				} else {
					callback(null, equipList);
				}
			});
		}
	});
};

// 保存道具列表
exports.saveItemToBagList = function(area, uuid, splitList, callback) {
	var bagAdd = {}, isEnough = true, isSet = false;
	// 获取背包数据
	exports.getBagList(area, uuid, function(err, bagList) {
		var itemId;
		if (err) {
			callback(err);
		} else {
			// 把道具添加到背包里面
			for (itemId in splitList) {
				if (splitList.hasOwnProperty(itemId)) {
					if (splitList[itemId].num !== 0 && !bag.tryAddItem(splitList[itemId].id, splitList[itemId].num, bagList)) {
						// 背包空间不足 删除道具
						delete splitList[itemId];
						isEnough = false;
						tiny.log.debug("itemId", itemId, ' tryAddItem to BagList fail');
						//callback(null, {itemList : {}, equipList : {}}, false);
						//return;
					} else {
						if (splitList[itemId].num !== 0 && !item.getItemAward(splitList[itemId].id, splitList[itemId].num, bagList, bagAdd)) {
							tiny.log.debug("itemId", itemId, ' save item to BagList fail');
							isEnough = false;
							//callback(null, {itemList : {}, equipList : {}}, false);
							//return;
						} else {
							isSet = true;
						}
					}
				}
			}
			if (isSet) {
				// 保存背包数据
				exports.setBagList(area, uuid, bagList, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, bagAdd, isEnough);
					}
				});
			} else {
				callback(null, {itemList : {}, equipList : {}}, false);
			}
		}
	});
};

// 扩充背包容量
var expandBagCapacity = function(itemId, itemNo, bagList) {
	if (itemNo > 0) {
		if (!bag.delItem(itemId, itemNo, bagList)) {
			return null;
		}
	}
	bagList.max =  parseInt(bagList.max * 2, 10);
	return bagList.max;
};

// 解锁背包格子
exports.unlockBag = function(bagList) {
	var id, itemId, itemNo, diamond, bagItemNum;
	// 计算扩充级数
	id = parseInt(bagList.max / 1000, 10);
	// 判断配置表
	if (Unlock[id]) {
		itemId = Unlock[id].itemId;
		itemNo = Unlock[id].itemNo;
		// 检查背包里面道具数量
		bagItemNum = bag.getItemNum(itemId, bagList);
		if (bagItemNum >= itemNo) {
			// 背包扩容
			diamond = 0;
			// 背包扩容
			if (!expandBagCapacity(itemId, itemNo, bagList)) {
				return null;
			}
		} else {
			// 不够使用钻石币
			diamond = parseInt((itemNo - bagItemNum) * Unlock[id].price * -1, 10);
			// 背包扩容
			if (!expandBagCapacity(itemId, bagItemNum, bagList)) {
				return null;
			}
		}
		return diamond;
	}
	tiny.log.error(id + " is not in unlock config");
	return null;
};
