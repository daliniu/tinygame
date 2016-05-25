var Item = require('../config/pick/item');
var Const = require("../const");
var utils = require("../utils");
var ItemMainType = Const.ITEM.MAIN_TYPE;
var ItemDetailType = Const.ITEM.DETAIL_TYPE;
var tiny = require('../../tiny');

exports.getLeftRoom = function(bagList) {
	var maxRoom = bagList.max,
		itemList = bagList.itemList,
		equipList = bagList.equipList,
		leftRoom = maxRoom,
		index,
		itemNum,
		id,
		stackMax;

	if (!maxRoom) {
		return 0;
	}
	// 计算道具占用空间
	for (index in itemList) {
		if (itemList.hasOwnProperty(index)) {
			itemNum = itemList[index].num;
			if (!Item[index]) {
				tiny.log.error('getLeftRoom', index, 'Do not have this item!');
				return 0;
			}
			if (itemNum <= 0) {
				tiny.log.error('getLeftRoom', 'item num error');
				return 0;
			}
			stackMax = Item[index].stackMax;
			if (isNaN(stackMax) || stackMax <= 0) {
				tiny.log.error('getLeftRoom', 'stackmax error');
				return 0;
			}
			leftRoom = leftRoom - Math.ceil(itemNum / stackMax);
		}
	}
	// 计算装备占用空间
	for (index in equipList) {
		if (equipList.hasOwnProperty(index)) {
			id = equipList[index].id;
			if (!id) {
				tiny.log.error('getLeftRoom', 'equip id error');
				return 0;
			}
			if (!Item[id]) {
				tiny.log.error('getLeftRoom', 'Do not have this equip!');
				return 0;
			}
			leftRoom = leftRoom - 1;
		}
	}

	if (leftRoom < 0) {
		leftRoom = 0;
	}
	return leftRoom;
};

// index是索引
exports.getItemNum = function(index, bagList) {
	var itemList = bagList.itemList,
		equipList = bagList.equipList;

	tiny.log.debug('1111111111', index);
	if (itemList.hasOwnProperty(index)) {
		if (itemList[index].num <= 0) {
			tiny.log.error('getLeftRoom', 'item num error', index);
			return 0;
		}
		return itemList[index].num;
	}

	tiny.log.debug('222222', index);
	if (equipList.hasOwnProperty(index)) {
		if (equipList[index].num <= 0) {
			tiny.log.error('getLeftRoom', 'equip num error', index);
			return 0;
		}
		return equipList[index].num;
	}
	tiny.log.info('getItemNum', 'no this item or equip in bag', index);
	return 0;
};

// index是索引
exports.delItem = function(index, num, bagList) {
	var itemList = bagList.itemList,
		equipList = bagList.equipList;

	if (num < 0) {
		tiny.log.error('delItem', 'item num error');
		return false;
	}

	if (itemList.hasOwnProperty(index)) {
		if (itemList[index].num < num) {
			tiny.log.error('delItem', 'have not this much item', index);
			return false;
		}
		itemList[index].num = itemList[index].num - num;
		if (itemList[index].num <= 0) {
			delete itemList[index];
		}
		tiny.log.info('delItem', 'del item success', index, num, JSON.stringify(itemList));
		return true;
	}

	if (equipList.hasOwnProperty(index)) {
		if (equipList[index].num < num) {
			tiny.log.error('delItem', 'have not this much item', index);
			return false;
		}
		equipList[index].num = equipList[index].num - num;
		if (equipList[index].num <= 0) {
			delete equipList[index];
		}
		tiny.log.info('delItem', 'del equip success', index, num, JSON.stringify(equipList));
		return true;
	}

	tiny.log.error('delItem', 'have not found this item or equip', index);
	return false;
};

exports.tryAddItem = function(itemID, num, bagList) {
	var room,
		needRoom,
		stackMax;

	if (num <= 0) {
		tiny.log.error('tryAddItem', 'item num error', itemID, num);
		return false;
	}
	if (!Item.hasOwnProperty(itemID)) {
		tiny.log.error('tryAddItem', 'item id error', itemID, num);
		return false;
	}

	// 检查背包空间
	room = module.exports.getLeftRoom(bagList);
	stackMax = Item[itemID].stackMax;
	if (isNaN(stackMax) || stackMax <= 0) {
		tiny.log.error('tryAddItem', 'stackmax error');
		return false;
	}
	needRoom = Math.ceil(num / stackMax);
	if (room < needRoom) {
		tiny.log.error('tryAddItem', 'no enough room', room, needRoom);
		return false;
	}

	return true;
};

exports.addItem = function(itemID, num, bagList) {
	var itemList = bagList.itemList;

	if (exports.tryAddItem(itemID, num, bagList)) {
		if (itemList.hasOwnProperty(itemID)) {
			itemList[itemID].num = itemList[itemID].num + num;
		} else {
			itemList[itemID] = {};
			itemList[itemID].num = num;
		}

		tiny.log.info('addItem', 'add item success', itemID, num);
		return true;
	}

	return false;
};

exports.addEquip = function(index, info, bagList) {
	var equipList = bagList.equipList,
		room;

	if (!info.hasOwnProperty('id')) {
		tiny.log.error('addEquip', 'info has no id');
		return false;
	}

	if (!Item.hasOwnProperty(info.id)) {
		tiny.log.error('addEquip', 'equip id error', info.id);
		return false;
	}

	if (Item[info.id].itemTepy != ItemMainType.EQUIP) {
		tiny.log.error('addEquip', 'this item is not equip', info.id);
		return false;
	}

	// 检查背包空间
	room = module.exports.getLeftRoom(bagList);
	if (room < 1) {
		tiny.log.error('addEquip', 'no enough room', room);
		return false;
	}

	// 检查装备索引
	if (equipList.hasOwnProperty(index)) {
		tiny.log.error('addEquip', 'index the same', index);
		return false;
	}

	equipList[index] = info;

	tiny.log.info('addEquip', 'add equip success', index, info.id);

	return true;
};

// 判断道具类型
exports.checkItemType = function(itemID, type) {
	if (!Item[itemID] || !Item[itemID].itemTepy2) {
		return false;
	}
	if (Item[itemID].itemTepy2 === type) {
		return true;
	}
	return false;
};

// 判断是否强化石
exports.isStone = function(itemID) {
	return exports.checkItemType(itemID, ItemDetailType.Q_STONE);
};

// 判断是否装备
exports.isEquip = function(itemID) {
	if (!Item[itemID] || !Item[itemID].itemTepy) {
		return false;
	}
	if (Item[itemID].itemTepy === ItemMainType.EQUIP) {
		return true;
	}
	return false;
};
