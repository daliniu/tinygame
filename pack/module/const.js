module.exports = {
	SESSION_STATE: {
		SESSION_NEED_CLEAR: 0,
		SESSION_STATE_READY: 1,
		SESSION_STATE_CLIENT_END: 2
	},
	CONN_PLAYER_STATE: {
		READY_FOR_CLIENT: 1,
		CLIENT_CONNECTED: 2
	},
	PROCESS_NAME_TABLE: {
		1: 'gate',
		2: 'conn',
		3: 'loc',
		4: 'chat',
		5: 'mail',
		6: 'db',
		7: 'route'
	},
	MDP: {
		REQUEST: 1,
		REPLY: 2,
		HEARTBEAT: 3,
		DISCONNECT: 4,
		DONE: 5,
		NOEXISTS: 6
	},
	REQUEST_TYPE: {
		POINT: 1,
		BROADCAST: 2
	},
	CACHE_EXPIRE_TIME : 60,
	MAX_PROTO_STRING_LENGTH : 65535,
	// redis name hash
	REDIS_NAME: {
		"baseinfo": 1,
		"roleinfo": 2,
		"map": 3,
		"player" : 4,
		"hero"   : 5,
		"skill"   : 6,
		"equip"   : 7,
		"bag" : 8,
		"hang" : 9,
		"afk" : 10,
		"namePool" : 11,
		"mailID" : 12,
		"mailHead" : 13,
		"mailText" : 14,
		"globalMailPool" : 15,
		"mailPool" : 16,
		"mailGetList" : 17,
		"taskPool" : 18,
		"taskDonePool" : 19,
		"scheduleTask" : 20,
		"node" : 21
	},
	// 业务逻辑错误码
	CLIENT_ERROR_CODE: {
		SUCCESS: 0,
		FAILURE : 400,
		OK      : 1,
		NOT_OK  : 2,

		UNDEFINED_FUNCTION : 401,
		ERROR_FUNCTION_NAME : 402,
		ERROR_UNEXCEPT : 403,
		DATA_CONFIG_ERROR : 404,
		ADD_SESSION_ERROR : 500,
		GET_SESSION_ERROR : 501,
		GET_ONLINEINFO_ERROR : 502,

		NEVER_CREATE_PLAYER : 805,
		CREATE_PLAYER_FAILURE : 806,
		NEVER_CREATE_HERO_INFO_LIST : 808,
		UPGRADE_HERO_LEVEL_FAILURE : 809,
		CREATE_HERO_INFO_FAILURE : 810,
		WASH_HERO_ERROR : 811,
		SHOP_HERO_ERROR : 812,

		GET_MAPINFO_FAILURE : 900,
		MAPID_ERROR : 901,
		CREATE_MAPINFO_FAILURE : 902,
		CHANGE_MAP_FAILURE : 903,
		GET_CUR_MAPID_FAILURE : 904,
		CURRENT_MAP_WRONG : 905,
		GET_MAP_BUFF_FAILURE : 906,
		SAVE_MAP_INFO_ERROR : 907,
		MAP_POS_ERROR : 908,
		CHEST_ID_ERROR : 909,
		MAP_REWARD_ERROR : 910,
		UNKNOW_ID_ERROR : 911,
		TARGET_MAP_NOT_EXIST : 912,
		CAN_NOT_OPEN_MAP_FILE : 913,
		GET_OBS_LAYER_ERROR : 914,
		WALK_PATH_ERROR : 915,
		WALK_NO_THIS_MAP : 916,
		CHECK_MAPINFO_ERROR : 917,
		BEFORE_MAP_NOT_UNLOCK : 918,
		TEAM_LEVEL_LOW : 919,
		WALK_UID_ERROR : 920,
		MAP_UID_ERROR : 921,
		MAP_UID_PROCESS_ERROR : 922,
		MAP_BUY_ERROR : 923,
		MAP_BUY_NO_MONEY : 924,
		MAP_BUY_NO_BAG_ROOM : 925,
		MAP_GET_AP_ERROR : 926,
		SAVE_MAP_BUFF_ERROR : 927,
		SAVE_MAP_AP_ERROR : 928,
		CALC_AP_ERROR : 929,
		GET_AFK_LIST_ERROR: 930,
		GET_CUR_AFK_ERROR : 931,
		ACTION_POINT_LESS : 932,
		SAVE_AFK_ERROR : 933,
		NOT_BEGIN_AFK_ERROR : 934,
		AFK_GET_REWARD_ERROR : 935,
		NODE_TIME_NOT_OPEN : 936,
		NODE_NOT_FOUND : 937,
		NODE_ENTER_LVL_ERROR : 938,
		NODE_IS_NOT_AFK : 939,
		MAP_UID_NOT_IN_AREA : 940,
		MAP_UID_TYPE_NOT_FOUND : 941,
		MAP_UID_PRECHECK_FAIL : 942,
		MAP_UID_ID_FAIL : 943,
		MAP_UID_ENDED : 944,
		OPEN_NODE_MISSING : 945,
		MAP_UID_TYPE_ERROR : 946,
		DROP_ID_NOT_FOUND : 947,


		ITEM_CANNOT_SELL : 1000,
		ITEM_SELL_PRICE_WRONG : 1001,
		ITEM_SELL_NUM_ERROR : 1002,
		ITEM_NUM_NOT_ENOUGH : 1003,
		ITEM_DEL_ERROR : 1004,
		ITEM_COMPOSE_ID_ERROR : 1005,
		ITEM_NO_THIS_ITEM : 1006,
		ITEM_COMPOSE_FAIL : 1007,
		ITEM_COMPOSE_DEMAND_LESS : 1008,
		ITEM_COMPOSE_NOT_IN_BAG : 1009,
		ITEM_USE_NO_EFFECT : 1010,

		GET_BAG_ERROR : 1100,
		SAVE_BAG_ERROR : 1101,
		BAG_FREE_ROOM_LIMIT : 1102,
		BAG_ADD_ERROR : 1103,
		BAG_UNLOCK_ERROR : 1104,
		GET_BASEINFO_ERROR : 1105,
		SAVE_BASEINFO_ERROR : 1106,
		DROP_POLL_ERROR : 1107,

		SAVE_GOLD_ERROR : 1200,

		EQUIP_UPGRADE_STAR_ERROR  : 1501,
		EQUIP_CREATE_ERROR  : 1502,
		HANGUP_OFFLINE_ERROR : 1601,
		HANGUP_ONLINE_ERROR : 1602,
		HANGUP_SWITCH_POINT_ERROR : 1603,


		MAIL_NOT_FOUND : 1800,
		MAIL_HEAD_NOT_FOUND : 1801,

		// PVP
		PVP_EROLL_SNG_ERROR : 1901,
		PVP_GET_BOX_REWARD_ERROR : 1902,
		PVP_GET_SNG_REWARD_ERROR : 1903,
		PVP_EROLL_DAY_ERROR : 1904,

		// 数据处理错误码
		DATA_GET_BASEINFO_ERROR : 2001,
		DATA_GET_BAGLIST_ERROR  : 2003,
		DATA_GET_HEROINFO_ERROR : 2002,
		DATA_GET_AFKINFO_ERROR  : 2005,
		DATA_GET_MAPINFO_ERROR  : 2004,
		DATA_GET_TEAMHEROLIST_ERROR : 2005,
		DATA_GET_PVPINFO_ERROR   : 2006,
		DATA_GET_PVPSNG_ERROR    : 2007,
		DATA_GET_PVPDAY_ERROR    : 2008,
		DATA_GET_PVPWEEK_ERROR   : 2009,
		DATA_GET_GLOBALINFO_ERROR : 2010,
		DATA_GET_HEROINFOLIST_ERROR : 2011,
		DATA_GET_HEROBOOKINFO_ERROR : 2012,

		DATA_SET_BASEINFO_ERROR : 2101,
		DATA_SET_BAGLIST_ERROR  : 2103,
		DATA_SET_HEROINFO_ERROR : 2102,
		DATA_SET_AFKINFO_ERROR  : 2105,
		DATA_SET_MAPINFO_ERROR  : 2104,
		DATA_SET_PVPINFO_ERROR  : 2105,
		DATA_SET_PVPSNG_ERROR   : 2106,
		DATA_SET_PVPDAY_ERROR   : 2107,
		DATA_SET_PVPWEEK_ERROR  : 2108,
		DATA_SET_GLOBALINFO_ERROR : 2109,
		DATA_SET_HEROBOOKINFO_ERROR : 2112,


		NO_NEED_TIPS : 10000,               // 此返回码表示不需要提示信息
		LOGIN_FAILURE : 10001,              // 登录失败
		LOGIN_SDK_FAILURE : 10002,          // 登录SDK验证失败
		RETCODE_NEED_UNPACK : 15000,		// 大于15000的错误码会解包
		FIGHT_BAG_FREE_ROOM_LIMIT : 15002,  // 战斗背包空间已满
		PVP_DAY_IS_ENROLL : 16001          // pvp日赛已经报名
	},

	MAP : {
		DEFAULT_NODE : 101201,
		NODE_TYPE : {
			MAP : 1,
			AFK : 2
		},
		AFK_TYPE : {
			NORMAL : 1,
			TIME : 2
		},
		WALK_PER_COST : 10,
		BUFFTYPE : {
			WALK_COST_PERCENT_MINUS : 1,
			WALK_COST_EVERY_MINUS : 2,
			WALK_COST_PERCENT_ADD : 3
		},
		MAP_LAYER_NAME : {
			OBS_LAYER : "pobstacle",
			BUILDING_LAYER : "building",
			SURFACE : "surface"
		},
		MAP_UID_TYPE : {
			CHEST : 1,
			CHESTCHOO : 2,
			MONSTERCHAL : 6,
			MISSION : 8,
			UNKNOW : 9,
			BUFFSTATION : 12,
			WATCHTOWER : 16,
			LOBSTACLE : 32,
			NPC : 19
		},
		ELEMENT_STATE : {
			CHEST : {
				INIT : 1,
				PICKED : 2
			},
			MONSTERCHAL : {
				INIT : 1,
				FIGHTED : 2
			},
			UNKNOW : {
				INIT : 1,
				MONSTER : 2,
				REWARD : 3,
				GOT : 4
			},
			BUFFSTATION : {
				NO_PICKING : 1,
				PICKED : 2
			},
			WATCHTOWER : {
				INIT : 1,
				PICKED : 2
			},
			LOBSTACLE : {
				EXIST : 1,
				REMOVE : 2
			},
			CHESTCHOO : {
				INIT : 1,
				CHOOD : 2
			},
			MISSION : {
				INIT : 1,
				END : 2
			},
			NPC : {
				INIT : 1,
				CLICKED : 2
			}
		},
		OBSTACLE : {
			IN : 0,
			AROUND : 1,
			DIS : 2
		}
	},

	ITEM : {
		USE_TYPE : {
			ADD_ACTION : 1,
			ADD_TEAM_EXP : 2,
			ADD_HERO_EXP : 4,
			ADD_GOLD : 5,
			ADD_DIAMOND : 6,
			OPEN_BOX : 7,
			ADD_HERO : 11
		},
		MAIN_TYPE : {
			EQUIP : 1,
			SUPPLY : 2,
			MATERIAL : 3,
			COMPOSE : 4
		},
		DETAIL_TYPE : {
			WEAPON : 1, // 武器
			HEAD : 2, // 头
			CLOTH : 3, // 衣服
			SHOE : 4, // 鞋
			RING : 5, // 戒指
			NECKLACE : 6, // 项链
			G_BOX : 7, // 游戏币宝箱
			D_BOX : 8, // 钻石宝箱
			TICKET : 9, // 门票
			ACTION_ITEM : 10, // 体力道具
			EXP_ITEM : 11, // 经验道具
			BUFF_ITEM : 12, // Buff道具
			SKILL_ITEM : 13, // 技能道具
			BOX : 14, // 宝箱
			MAP_ITEM : 16, // 场景物品
			Q_STONE : 17, // 强化石
			TEAM_EXP_ITEM : 18 // 团队经验物品
		}
	},

	FIGHT_RESULT : {
		SUCCESS : 1,
		FAILURE : 2
	},

	MAIL : {
		TYPE_PERSON : 1,
		TYPE_GLOBAL : 2
	},

	LoginPlat : {
		WINDOWS : 0,
		LINUX   : 1,
		MAC     : 2,
		ANDROID : 3,
		IPHONE  : 4,
		IPAD    : 5,
		BLACKBERRY : 6,
		NACL    : 7,
		EMSCRIPTEN : 8,
		TIZEN   : 9
	},

	ITEM_DROP : {
		GOLD : "gold",
		DIAMOND : "rmb",
		TEAM_EXP : "teamexp",
		JJC_GOLD : "jjcgold",
		MAGIC_GOLD : "magicgold",
		SIGN : "sign",
		HEROEXP : "heroexp",
		AP : "ap",
		DROP_MAX_NUM : 10
	},
	// 登录状态
	LOGIN_ON  :  "1",
	LOGIN_OFF :  "0",
	// 等级上限
	PLAYER_LEVEL_LIMIT : 100,
	SKILL_SLOT_LEVEL_LIMIT : 6,
	HERO_STAR_LEVEL_LIMIT : 5,
	HERO_QUALITY_LEVEL_LIMIT : 13,
	HERO_BOOK_INFO_INDEX : 0,
	HERO_REFRESH_TIME_INTERVAL : 2 * 60 * 60,
	HERO_REFRESH_TIME_LIMIT : 3,
	HERO_REFRESH_TIME_DAILY_LIMIT : 3,
	EQUIP_STAR_LEVEL_LIMIT : 10,
	EXP_LEVEL_LIMIT : 10000000,
	HERO_LEVEL_LIMIT : 100,
	// 装备是否安装
	EQUIP_SET_ON :  1,
	EQUIP_SET_OFF : 0,
	// 金币边界值
	COMMON_VALUE_MIN : 0,
	COMMON_VALUE_MAX : 999999999,

	EQUIP_ATTR_MIN : 1,
	EQUIP_ATTR_MAX : 4,
	SERIAL_DATA_TYPE : {
		SERVER_NAME : 0,
		FUNC_NAME   : 1,
		ARGS        : 2,
		FUNCID      : 3,
		RET_CODE    : 4
	},
	// 最较大单进程连接数
	CONNECT_SERVER_LIMIT : 2000,
	CONN_SERVER_NUMS_LIMIT : 100,
	IM_MY_MSG_TO_YOU : 1,
	IM_MY_MSG_IN_MY_TEAM : 2,
	IM_MY_MSG_IN_AREA : 4,
	IM_ANNOUNCE : 6,
	// 最大挂机时间
	AFK_MAX_TIME : 12 * 60 * 60 * 1000,
	AFK_MIN_TIME : 10 * 1000,
	// 布阵最大最小位置
	LINEUP_MAX_POS : 3,
	LINEUP_MIN_POS : 1,
	// 补给值范围
	SUPPLY_AP_MAX : 100,
	SUPPLY_AP_MIN : 0,
	//装备品质
	EQUIP_QUALITY_WHITE : 1,
	EQUIP_QUALITY_GREE : 2,
	EQUIP_QUALITY_BLUE : 3,
	EQUIP_QUALITY_PURPLE : 4,
	EQUIP_QUALITY_ORANGE : 5,
	// 初始化配置
	INIT_GOLD : 1,
	INIT_DIAMOND : 2,
	INIT_ACTION : 3,
	INIT_ITEM : 4,
	// 容器map容量
	LRU_MAP_LIMIT : 5000,
	// PVP相关宏定义
	PVP_SNG_START : 1,
	PVP_SNG_END   : 0,
	PVP_DAY_GET   : 2,      // 领取
	PVP_DAY_START : 1,
	PVP_DAY_END   : 0,
	// 报名大师积分限制
	PVP_ENROLL_DAY_TICKET_LIMIT : 10,
	PVP_ENROLL_DAY_NUMS_LIMIT : 5000,
	PVP_WINNER : 1,
	PVP_LOSER  : 2
};
