var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var UseType = Const.ITEM.USE_TYPE;
var ItemMainType = Const.ITEM.MAIN_TYPE;
var ItemDrop = Const.ITEM_DROP;
var tiny = require('../../tiny');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle = require('../dataprocess/equip_handle');
var Item = require('../config/pick/item');
var Compose = require('../config/equip/compose');
var Drop = require('../config/pick/drop');
var bag = require('../bag/bag');
var async = require('async');
var utils = require('../utils');

exports.getItemAward = function(itemID, itemNum, bagList, record) {
	var num,
		equip;
	if (Item.hasOwnProperty(itemID)) {
		if (parseInt(Item[itemID].itemTepy, 10) === ItemMainType.EQUIP) {
			// 创建装备
			for (num = 0; num < itemNum; ++num) {
				equip = equipHandle.createEquip(itemID);
				if (!bag.addEquip(equip.index, equip.equipInfo, bagList)) {
					return false;
				}
				if (!record.equipList) {
					record.equipList = {};
				}
				record.equipList[equip.index] = equip.equipInfo;
				record.equipList[equip.index].num = 1;
			}
		} else {
			if (!bag.addItem(itemID, itemNum, bagList)) {
				return false;
			}
			if (!record.itemList) {
				record.itemList = {};
			}
			if (!record.itemList.hasOwnProperty(itemID)) {
				record.itemList[itemID] = {};
				record.itemList[itemID].num = 0;
			}
			record.itemList[itemID].num = record.itemList[itemID].num + itemNum;
		}
		return true;
	}
	tiny.log.error('getItemAward', 'item id error', itemID);
	return false;
};

function getPoolThing(valueType, value, baseInfo, bagList, nodeInfo, record) {
	var temp;
	if (valueType === ItemDrop.GOLD) {
		temp = utils.addValue(baseInfo.gold + value);
		if (!record.gold) {
			record.gold = 0;
		}
		record.gold = record.gold + (temp - baseInfo.gold);
		baseInfo.gold = temp;
	} else if (valueType === ItemDrop.DIAMOND) {
		temp = utils.addValue(baseInfo.diamond + value);
		if (!record.diamond) {
			record.diamond = 0;
		}
		record.diamond = record.diamond + (temp - baseInfo.diamond);
		baseInfo.diamond = temp;
	} else if (valueType === ItemDrop.TEAM_EXP) {	// 经验奖励直接返回客户端等客户端请求再加
		if (!record.team_exp) {
			record.team_exp = 0;
		}
		playerHandle.addPlayerExp(value, baseInfo);
		record.team_exp = record.team_exp + value;
	} else if (valueType === ItemDrop.JJC_GOLD) {
		// 什么玩意
	} else if (valueType === ItemDrop.MAGIC_GOLD) {
		// 什么玩意
	} else if (valueType === ItemDrop.SIGN) {
		if (nodeInfo.sign) {	// 存在才证明在地图里，才有意义
			nodeInfo.sign[value] = 1;
			if (!record.sign) {
				record.sign = {};
			}
			record.sign[value] = 1;
		}
	} else if (valueType === ItemDrop.HEROEXP) {
		// 什么玩意
	} else if (valueType === ItemDrop.AP) {
		// 什么玩意
	} else {	// 道具
		exports.getItemAward(valueType, value, bagList, record);
	}
}

exports.dropPool = function(id, baseInfo, bagList, nodeInfo) {
	var retPack = [], indexScope = [], weightScope = [], i, valueType, value, j,
	itemNum, q, p, ret;
	retPack[1] = {};

	if (!Drop.hasOwnProperty(id)) {
		retPack[0] = ErrCode.DROP_ID_NOT_FOUND;
		tiny.log.error('dropPool id wrong', id);
		return retPack;
	}

	// 处理必出掉落
	if (Drop[id].hasOwnProperty("foreverDrop")) {
		for (i in Drop[id].foreverDrop) {
			if (Drop[id].foreverDrop.hasOwnProperty(i)) {
				valueType = Drop[id].foreverDrop[i][1];
				value = Drop[id].foreverDrop[i][2];
				tiny.log.trace('dropPool', id, i, valueType, value);
				getPoolThing(valueType, value, baseInfo, bagList, nodeInfo, retPack[1]);
			}
		}
	}

	if (!Drop[id].number) {
		return retPack;
	}

	// 计算出多少个道具
	for (j in Drop[id].number) {
		if (Drop[id].number.hasOwnProperty(j)) {
			indexScope.push(Drop[id].number[j][1]);
			weightScope.push(Drop[id].number[j][2]);
		}
	}
	itemNum = utils.randomScope(indexScope, weightScope);
	tiny.log.trace("dropPool random itemnum", itemNum);
	// 随机出掉落
	indexScope = [];
	weightScope = [];
	for (q = 1; q <= ItemDrop.DROP_MAX_NUM; ++q) {
		if (Drop[id].hasOwnProperty(['tepy' + q])) {
			indexScope.push([Drop[id]['tepy' + q][1], Drop[id]['tepy' + q][2]]);
			weightScope.push(Drop[id]['tepy' + q][3]);
		}
	}

	for (p = 0; p < itemNum; ++p) {
		ret = utils.randomScope(indexScope, weightScope);
		tiny.log.trace("dropPool random", JSON.stringify(ret));

		valueType = indexScope[ret][0];
		value = utils.checkValue(indexScope[ret][1]);
		getPoolThing(ret[0], ret[1], baseInfo, bagList, nodeInfo, retPack[1]);
	}
	return retPack;
};
