var moment = require('moment');
var schedule = require('node-schedule');
var tiny = require('../../tiny');
var taskHandle = require('../dataprocess/task_handle');

/*
执行无数次：{ hour: 20[0,23], minute: 30[0,59], second: 2[0,59], dayofMonth: 2[1,31], month: 12[1,12], dayofWeek: 3[0Sun,6Sat] }
执行特定次自己在函数里判断时间

*/
var tbTime = {
	// 执行无数次
	ever: [
		{
			id: 1,	// 刷新日常任务
			time: { hour: 23, minute: 0 }
		},
		{
			id: 2,
			time: { hour: 23, minute: 30 }
		},
		{
			id: 3,
			time: { hour: 0, minute: 0 }
		},
		{
			id: 4,
			time: { hour: 1, minute: 0 }
		},
		{
			id: 5,
			time: { hour: 0, minute: 30 }
		},
		{
			id: 6,
			time: { hour: 4, minute: 0 }
		},
		{
			id: 7,
			time: { hour: 4, minute: 12 }
		},
		{
			id: 8,
			time: { hour: 12, minute: 59 }
		}
		// { 格式写错了也不会报错，有点坑
		// 	id: 9,
		// 	time: { hour: 0, minute: 60 }
		// },
		// {
		// 	id: 10,
		// 	time: { hour: 0, minute: 65 }
		// },
		// {
		// 	id: 11,
		// 	time: { hour: 1, minute: -1 }
		// }
	],
	once: [
		{
			id: 1,
			date: new Date(2015, 9, 14, 17, 0, 0)	// 需要注意，月份是 0-11
		}
	]
};

var handler = [];

function everTrigger(id) {
	if (id === 1) {
		// redis.bgrewriteaof();
		console.log("everTrigger", id, Date());
	}
}

function onceTrigger(id) {
	if (id === 1) {
		// redis.bgrewriteaof();
		// 首先判断任务完成标记
		// taskHandle.setScheduleMark(id, 1);
		// 设置任务完成标记
		console.log("onceTrigger",id, Date());
	}
}

module.exports.start = function() {
	var i, j, job;
	for (i = 0; i < tbTime.ever.length; ++i) {
		job = schedule.scheduleJob(tbTime.ever[i].time, everTrigger.bind(null, tbTime.ever[i].id));
		handler.push(job);
	}
	for (j = 0; j < tbTime.once.length; ++j) {
		job = schedule.scheduleJob(tbTime.once[j].date, onceTrigger.bind(null, tbTime.once[j].id));
		handler.push(job);
	}
};

module.exports.stop = function() {
	var i;
	for (i = 0; i < handler.length; ++i) {
		schedule.cancelJob(handler[i]);
	}
};
