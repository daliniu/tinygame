var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');

/*
//技能槽
SlotInfo
{
	skillList           //技能列表
	{
		skillId
		heroId
	}
	cost                 //费用
}

//技能槽列表
SkillSlotList
{
	slotInfo1,             //技能槽
	slotInfo2
}
*/

// 创建技能槽列表
function createSkillSlotList() {
	var skillSlotList = [], i, j;
	for (i=0; i < 6; i++) {
		skillSlotList[i] = {};
		skillSlotList[i].level = 1;
		skillSlotList[i].cost = i+1;
		for (j = 0; j < 3; j++) {
			skillSlotList[i].skillList[j] = {};
			skillSlotList[i].skillList[j].skillId = 0;
			skillSlotList[i].skillList[j].heroId  = 0;
		}
	}
	return skillSlotList;
}

// 获取技能槽列表
exports.getSkillSlotList = function(area, uuid, callback) {
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'skill'), callback);
};

// 创建技能槽列表
exports.setSkillSlotList = function(area, uuid, callback) {
	var skillSlotList = createSkillSlotList();
	tiny.redis.set(utils.redisKeyGen(area, uuid, 'skill'), skillSlotList, callback);
};

// 升级技能槽
exports.upgradeSkillSlot = function(area, uuid, slotId, callback) {
	var slotInfo;
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'skill'), function(err, skillSlotList) {
		if (err) {
			callback(err);
		} else {
			// 查找技能槽
			if (skillSlotList !== undefined && skillSlotList.hasOwnProperty(slotId)) {
				slotInfo = skillSlotList[slotId];
				// 修改技能槽等级
				if (slotInfo.level < Const.SKILL_SLOT_LEVEL_LIMIT) {
					slotInfo.level = slotInfo.level + 1;
				}
				// 保存数据
				tiny.redis.set(utils.redisKeyGen(area, uuid, 'skill'), skillSlotList, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, skillSlotList);
					}
				});
			} else {
				callback("don't have skillSlotList");
			}
		}
	});
};
/*
// 修改技能槽技能配置
exports.adapterSkillSlotList = function(area, uuid, adapter, callback) {
	var i, item, slotInfo, skill;
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'skill'), function(err, skillSlotList) {
		if (err) {
			callback(err);
		} else {
			if (skillSlotList !== undefined) {
				// 根据配置数组修改技能槽列表
				for (i = 0; i < adapter.length; i++) {
					item = adapter[i];
					if (skillSlotList.hasOwnProperty(item.slotId)) {
						slotInfo = skillSlotList[item.slotId];
						skill = slotInfo.skillList[item.pos];
						skill.skillId = item.skillId;
						skill.heroId = item.heroId;
					}
				}
				// 保存技能槽列表
				tiny.redis.set(utils.redisKeyGen(area, uuid, 'skill'), skillSlotList, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, skillSlotList);
					}
				});
			} else {
				callback("don't have skillSlotList");
			}
		}
	});
};
*/
// 修改技能槽技能配置
exports.adapterSkillSlotList = function(area, uuid, adapter, callback) {
	var i, item, slotInfo, skill;
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'skill'), function(err, skillSlotList) {
		if (err) {
			callback(err);
		} else {
			if (skillSlotList !== undefined) {
				// 根据配置数组修改技能槽列表
				for (i = 0; i < adapter.length; i++) {
					item = adapter[i];
					if (skillSlotList.hasOwnProperty(item.slotId)) {
						slotInfo = skillSlotList[item.slotId];
						skill = slotInfo.skillList[item.pos];
						skill.skillId = item.skillId;
						skill.heroId = item.heroId;
					}
				}
				// 保存技能槽列表
				tiny.redis.set(utils.redisKeyGen(area, uuid, 'skill'), skillSlotList, function(err) {
					if (err) {
						callback(err);
					} else {
						callback(null, skillSlotList);
					}
				});
			} else {
				callback("don't have skillSlotList");
			}
		}
	});
};
/*
*/
