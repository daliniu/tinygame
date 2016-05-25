local _p = {
["TestAddItem"] = {
    [1] = {
        ["value"] = "itemid",
        ["type"] = "string",
    },
},
["UnlockBagReq"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
},
["PvpDayRankList"] = {
    [1] = {
        ["value"] = "dayRankList",
        ["type"] = "vector",
        ["type2"] = "PvpRankInfo",
    },
},
["GetBoxRewardReq"] = {
    [1] = {
        ["value"] = "boxCount",
        ["type"] = "string",
    },
},
["EnrollPvpDayRsp"] = {
    [1] = {
        ["value"] = "pvpDay",
        ["type"] = "struct",
        ["type1"] = "PvpDay",
    },
},
["TestAddValue"] = {
    [1] = {
        ["value"] = "type",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "value",
        ["type"] = "string",
    },
},
["WashHeroRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["UpgradeLevelRsp"] = {
    [1] = {
        ["value"] = "playerInfo",
        ["type"] = "struct",
        ["type1"] = "PlayerInfo",
    },
    [2] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["ShopHeroRsp"] = {
    [1] = {
        ["value"] = "bagItem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
},
["EquipResult"] = {
    [1] = {
        ["value"] = "index",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "id",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "star",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "num",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "a1",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "n1",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "a2",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "n2",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "a3",
        ["type"] = "string",
    },
    [10] = {
        ["value"] = "n3",
        ["type"] = "string",
    },
    [11] = {
        ["value"] = "a4",
        ["type"] = "string",
    },
    [12] = {
        ["value"] = "n4",
        ["type"] = "string",
    },
    [13] = {
        ["value"] = "sa",
        ["type"] = "string",
    },
    [14] = {
        ["value"] = "sn",
        ["type"] = "string",
    },
    [15] = {
        ["value"] = "ss",
        ["type"] = "string",
    },
},
["UpgradeHeroQualityReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["PvpF8ResultRsp"] = {
    [1] = {
        ["value"] = "pos",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "pvpF8Result",
        ["type"] = "struct",
        ["type1"] = "PvpF8Result",
    },
    [3] = {
        ["value"] = "fightReward",
        ["type"] = "struct",
        ["type1"] = "FightReward",
    },
},
["PvpRankListRsp"] = {
    [1] = {
        ["value"] = "rankList",
        ["type"] = "vector",
        ["type2"] = "PvpRankInfo",
    },
    [2] = {
        ["value"] = "myRank",
        ["type"] = "struct",
        ["type1"] = "PvpRankInfo",
    },
},
["SendMsgReq"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "type",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "msg",
        ["type"] = "string",
    },
},
["SkillSlotValue"] = {
    [1] = {
        ["value"] = "level",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "skillId",
        ["type"] = "string",
    },
},
["RollHeroReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["RvMeltingReq"] = {
    [1] = {
        ["value"] = "equipId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "diamond",
        ["type"] = "string",
    },
},
["RvMeltingRsp"] = {
    [1] = {
        ["value"] = "equip",
        ["type"] = "struct",
        ["type1"] = "EquipResult",
    },
},
["SetGuideLineReq"] = {
    [1] = {
        ["value"] = "step",
        ["type"] = "string",
    },
},
["MeltingEquipRsp"] = {
    [1] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "equip",
        ["type"] = "struct",
        ["type1"] = "EquipResult",
    },
    [3] = {
        ["value"] = "splitList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "ItemListValue",
    },
},
["UseItemRsp"] = {
    [1] = {
        ["value"] = "baseInfo",
        ["type"] = "struct",
        ["type1"] = "BaseInfo",
    },
    [2] = {
        ["value"] = "bagItem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
    [3] = {
        ["value"] = "heroInfoList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "HeroInfo",
    },
},
["ItemListValue"] = {
    [1] = {
        ["value"] = "num",
        ["type"] = "string",
    },
},
["TestDataRsp"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
},
["BaseInfo"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "userName",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "level",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "curExp",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "vip",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "diamond",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "posList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "PosListValue",
    },
    [10] = {
        ["value"] = "teamList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "HeroInfo",
    },
},
["WalkMapRsp"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "x",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "y",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "ap",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "buff",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["GlobalMapInfo"] = {
    [1] = {
        ["value"] = "curNode",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "openNode",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "OpenNode",
    },
    [3] = {
        ["value"] = "timeNode",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["TestDataReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["MakeHeroLineupRsp"] = {
    [1] = {
        ["value"] = "isOk",
        ["type"] = "string",
    },
},
["UpgradeSlotRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["OnlineProfitRsp"] = {
    [1] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "exp",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "action",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "bagitem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
    [5] = {
        ["value"] = "playerInfo",
        ["type"] = "struct",
        ["type1"] = "BaseInfo",
    },
},
["MakeHeroLineupReq"] = {
    [1] = {
        ["value"] = "posDst",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["HeartBeatInfo"] = {
    [1] = {
        ["value"] = "time",
        ["type"] = "string",
    },
},
["AvgLoadNumsRsp"] = {
    [1] = {
        ["value"] = "host",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "port",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "loadNums",
        ["type"] = "string",
    },
},
["LoginGameRsp"] = {
    [1] = {
        ["value"] = "loginState",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "playerInfo",
        ["type"] = "struct",
        ["type1"] = "PlayerInfo",
    },
},
["GetPvpMainListRsp"] = {
    [1] = {
        ["value"] = "pvpInfo",
        ["type"] = "struct",
        ["type1"] = "PvpInfo",
    },
    [2] = {
        ["value"] = "pvpDay",
        ["type"] = "struct",
        ["type1"] = "PvpDay",
    },
    [3] = {
        ["value"] = "pvpWeek",
        ["type"] = "struct",
        ["type1"] = "PvpWeek",
    },
    [4] = {
        ["value"] = "curTime",
        ["type"] = "string",
    },
},
["RefreshHeroShopReq"] = {
    [1] = {
        ["value"] = "isRefresh",
        ["type"] = "string",
    },
},
["GetPresentRsp"] = {
    [1] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "exp",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "action",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "bagitem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
    [5] = {
        ["value"] = "playerInfo",
        ["type"] = "struct",
        ["type1"] = "BaseInfo",
    },
    [6] = {
        ["value"] = "rewardCount",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "step",
        ["type"] = "string",
    },
},
["FightInfo"] = {
    [1] = {
        ["value"] = "player1",
        ["type"] = "struct",
        ["type1"] = "UserArea",
    },
    [2] = {
        ["value"] = "player2",
        ["type"] = "struct",
        ["type1"] = "UserArea",
    },
    [3] = {
        ["value"] = "seed",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "winner",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "fightReward",
        ["type"] = "struct",
        ["type1"] = "FightReward",
    },
},
["SellItemReq"] = {
    [1] = {
        ["value"] = "sellgroup",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["UnlockBagRsp"] = {
    [1] = {
        ["value"] = "max",
        ["type"] = "string",
    },
},
["EnterMapReq"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
},
["interface"] = {
    ["38325136"] = {
        ["getAvgConnServerLoadNums"] = {
            ["funcName"] = "getAvgConnServerLoadNums",
            ["outArgs"] = "AvgLoadNumsRsp",
            ["seq"] = "3836510533824645451836495336491146323513524450",
            ["inArgs"] = "AvgLoadNumsReq",
        },
        ["serverName"] = "gate",
        ["seq"] = "38325136",
        ["3836510533824645451836495336491146323513524450"] = {
            ["funcName"] = "getAvgConnServerLoadNums",
            ["outArgs"] = "AvgLoadNumsRsp",
            ["seq"] = "3836510533824645451836495336491146323513524450",
            ["inArgs"] = "AvgLoadNumsReq",
        },
    },
    ["34393251"] = {
        ["sendMsgToServer"] = {
            ["funcName"] = "sendMsgToServer",
            ["outArgs"] = "SendMsgRsp",
            ["seq"] = "503645351250381946183649533649",
            ["inArgs"] = "SendMsgReq",
        },
        ["serverName"] = "chat",
        ["seq"] = "34393251",
        ["503645351250381946183649533649"] = {
            ["funcName"] = "sendMsgToServer",
            ["outArgs"] = "SendMsgRsp",
            ["seq"] = "503645351250381946183649533649",
            ["inArgs"] = "SendMsgReq",
        },
    },
    ["chat"] = {
        ["sendMsgToServer"] = {
            ["funcName"] = "sendMsgToServer",
            ["outArgs"] = "SendMsgRsp",
            ["seq"] = "503645351250381946183649533649",
            ["inArgs"] = "SendMsgReq",
        },
        ["serverName"] = "chat",
        ["seq"] = "34393251",
        ["503645351250381946183649533649"] = {
            ["funcName"] = "sendMsgToServer",
            ["outArgs"] = "SendMsgRsp",
            ["seq"] = "503645351250381946183649533649",
            ["inArgs"] = "SendMsgReq",
        },
    },
    ["34464545"] = {
        ["43463840456324436"] = {
            ["funcName"] = "loginGame",
            ["outArgs"] = "LoginGameRsp",
            ["seq"] = "43463840456324436",
            ["inArgs"] = "LoginGameReq",
        },
        ["39363249511363251"] = {
            ["funcName"] = "heartBeat",
            ["outArgs"] = "HeartBeatInfo",
            ["seq"] = "39363249511363251",
            ["inArgs"] = "HeartBeatInfo",
        },
        ["365540516324436"] = {
            ["funcName"] = "exitGame",
            ["outArgs"] = "ExitGameRsp",
            ["seq"] = "365540516324436",
        },
        ["heartBeat"] = {
            ["funcName"] = "heartBeat",
            ["outArgs"] = "HeartBeatInfo",
            ["seq"] = "39363249511363251",
            ["inArgs"] = "HeartBeatInfo",
        },
        ["exitGame"] = {
            ["funcName"] = "exitGame",
            ["outArgs"] = "ExitGameRsp",
            ["seq"] = "365540516324436",
        },
        ["loginGame"] = {
            ["funcName"] = "loginGame",
            ["outArgs"] = "LoginGameRsp",
            ["seq"] = "43463840456324436",
            ["inArgs"] = "LoginGameReq",
        },
        ["seq"] = "34464545",
        ["serverName"] = "conn",
    },
    ["434634"] = {
        ["5047434051448524047"] = {
            ["funcName"] = "splitEquip",
            ["outArgs"] = "SplitEquipRsp",
            ["seq"] = "5047434051448524047",
            ["inArgs"] = "SplitEquipReq",
        },
        ["getPvpMainList"] = {
            ["funcName"] = "getPvpMainList",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "3836511553471232404511405051",
        },
        ["rvmeltingEquip"] = {
            ["funcName"] = "rvmeltingEquip",
            ["outArgs"] = "RvMeltingRsp",
            ["seq"] = "495344364351404538448524047",
            ["inArgs"] = "RvMeltingReq",
        },
        ["sellItemGroup"] = {
            ["funcName"] = "sellItemGroup",
            ["outArgs"] = "SellItemRsp",
            ["seq"] = "503643438513644649465247",
            ["inArgs"] = "SellItemReq",
        },
        ["38365115534722363642173650524351"] = {
            ["funcName"] = "getPvpWeekResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534722363642173650524351",
        },
        ["52454346344213238"] = {
            ["funcName"] = "unlockBag",
            ["outArgs"] = "UnlockBagRsp",
            ["seq"] = "52454346344213238",
            ["inArgs"] = "UnlockBagReq",
        },
        ["getHeroInfoList"] = {
            ["funcName"] = "getHeroInfoList",
            ["outArgs"] = "HeroListRsp",
            ["seq"] = "3836517364946845374611405051",
        },
        ["3439324538361851325136"] = {
            ["funcName"] = "changeState",
            ["outArgs"] = "ChangeStateRsp",
            ["seq"] = "3439324538361851325136",
            ["inArgs"] = "ChangeStateReq",
        },
        ["setMaxPower"] = {
            ["funcName"] = "setMaxPower",
            ["outArgs"] = "MaxPowerRsp",
            ["seq"] = "5036511232551546543649",
            ["inArgs"] = "MaxPowerReq",
        },
        ["shopHero"] = {
            ["funcName"] = "shopHero",
            ["outArgs"] = "ShopHeroRsp",
            ["seq"] = "503946477364946",
            ["inArgs"] = "ShopHeroReq",
        },
        ["34464447465036"] = {
            ["funcName"] = "compose",
            ["outArgs"] = "ComposeRsp",
            ["seq"] = "34464447465036",
            ["inArgs"] = "ComposeReq",
        },
        ["getPvpDayResult"] = {
            ["funcName"] = "getPvpDayResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534733256173650524351",
        },
        ["splitEquip"] = {
            ["funcName"] = "splitEquip",
            ["outArgs"] = "SplitEquipRsp",
            ["seq"] = "5047434051448524047",
            ["inArgs"] = "SplitEquipReq",
        },
        ["383651155347223636421732454211405051"] = {
            ["funcName"] = "getPvpWeekRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347223636421732454211405051",
        },
        ["unlockBag"] = {
            ["funcName"] = "unlockBag",
            ["outArgs"] = "UnlockBagRsp",
            ["seq"] = "52454346344213238",
            ["inArgs"] = "UnlockBagReq",
        },
        ["enterMap"] = {
            ["funcName"] = "enterMap",
            ["outArgs"] = "EnterMapRsp",
            ["seq"] = "3645513649123247",
            ["inArgs"] = "EnterMapReq",
        },
        ["upgradeHeroQuality"] = {
            ["funcName"] = "upgradeHeroQuality",
            ["outArgs"] = "UpgradeHeroQualityRsp",
            ["seq"] = "52473849323536736494616523243405156",
            ["inArgs"] = "UpgradeHeroQualityReq",
        },
        ["32353247513649184240434318434651"] = {
            ["funcName"] = "adapterSkillSlot",
            ["outArgs"] = "AdapterSkillSlotRsp",
            ["seq"] = "32353247513649184240434318434651",
            ["inArgs"] = "AdapterSkillSlotReq",
        },
        ["52473849323536736494616523243405156"] = {
            ["funcName"] = "upgradeHeroQuality",
            ["outArgs"] = "UpgradeHeroQualityRsp",
            ["seq"] = "52473849323536736494616523243405156",
            ["inArgs"] = "UpgradeHeroQualityReq",
        },
        ["52473849323536184240434318434651"] = {
            ["funcName"] = "upgradeSkillSlot",
            ["outArgs"] = "UpgradeSlotRsp",
            ["seq"] = "52473849323536184240434318434651",
            ["inArgs"] = "UpgradeSlotReq",
        },
        ["getPresent"] = {
            ["funcName"] = "getPresent",
            ["outArgs"] = "GetPresentRsp",
            ["seq"] = "38365115493650364551",
        },
        ["443242367364946114045365247"] = {
            ["funcName"] = "makeHeroLineup",
            ["outArgs"] = "MakeHeroLineupRsp",
            ["seq"] = "443242367364946114045365247",
            ["inArgs"] = "MakeHeroLineupReq",
        },
        ["3836511553471232404511405051"] = {
            ["funcName"] = "getPvpMainList",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "3836511553471232404511405051",
        },
        ["38365115534733256173650524351"] = {
            ["funcName"] = "getPvpDayResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534733256173650524351",
        },
        ["38365165240353611404536"] = {
            ["funcName"] = "getGuideLine",
            ["outArgs"] = "GetGuideLineRsp",
            ["seq"] = "38365165240353611404536",
        },
        ["3836511232404305151323439"] = {
            ["funcName"] = "getMailAttach",
            ["outArgs"] = "MailAttachRsp",
            ["seq"] = "3836511232404305151323439",
            ["inArgs"] = "MailAttachReq",
        },
        ["rollHero"] = {
            ["funcName"] = "rollHero",
            ["outArgs"] = "RollHeroRsp",
            ["seq"] = "494643437364946",
            ["inArgs"] = "RollHeroReq",
        },
        ["494643437364946"] = {
            ["funcName"] = "rollHero",
            ["outArgs"] = "RollHeroRsp",
            ["seq"] = "494643437364946",
            ["inArgs"] = "RollHeroReq",
        },
        ["5247384932353644852404718513249"] = {
            ["funcName"] = "upgradeEquipStar",
            ["outArgs"] = "UpgradeEquipRsp",
            ["seq"] = "5247384932353644852404718513249",
            ["inArgs"] = "UpgradeEquipReq",
        },
        ["5247384932353673649461136533643"] = {
            ["funcName"] = "upgradeHeroLevel",
            ["outArgs"] = "UpgradeLevelRsp",
            ["seq"] = "5247384932353673649461136533643",
            ["inArgs"] = "UpgradeLevelReq",
        },
        ["44364351404538448524047"] = {
            ["funcName"] = "meltingEquip",
            ["outArgs"] = "MeltingEquipRsp",
            ["seq"] = "44364351404538448524047",
            ["inArgs"] = "MeltingEquipReq",
        },
        ["3836517364946845374611405051"] = {
            ["funcName"] = "getHeroInfoList",
            ["outArgs"] = "HeroListRsp",
            ["seq"] = "3836517364946845374611405051",
        },
        ["getPvpDayF8Result"] = {
            ["funcName"] = "getPvpDayF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347332565-9173650524351",
        },
        ["543250397364946"] = {
            ["funcName"] = "washHero",
            ["outArgs"] = "WashHeroRsp",
            ["seq"] = "543250397364946",
            ["inArgs"] = "WashHeroReq",
        },
        ["getSngBoxReward"] = {
            ["funcName"] = "getSngBoxReward",
            ["outArgs"] = "GetBoxRewardRsp",
            ["seq"] = "38365118453814655173654324935",
            ["inArgs"] = "GetBoxRewardReq",
        },
        ["adapterSkillSlot"] = {
            ["funcName"] = "adapterSkillSlot",
            ["outArgs"] = "AdapterSkillSlotRsp",
            ["seq"] = "32353247513649184240434318434651",
            ["inArgs"] = "AdapterSkillSlotReq",
        },
        ["513650513325132"] = {
            ["funcName"] = "testData",
            ["outArgs"] = "TestDataRsp",
            ["seq"] = "513650513325132",
            ["inArgs"] = "TestDataReq",
        },
        ["383651155347332565-9173650524351"] = {
            ["funcName"] = "getPvpDayF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347332565-9173650524351",
        },
        ["3836511232404319365551"] = {
            ["funcName"] = "getMailText",
            ["outArgs"] = "MailTextBody",
            ["seq"] = "3836511232404319365551",
            ["inArgs"] = "MailTextReq",
        },
        ["testData"] = {
            ["funcName"] = "testData",
            ["outArgs"] = "TestDataRsp",
            ["seq"] = "513650513325132",
            ["inArgs"] = "TestDataReq",
        },
        ["50365165240353611404536"] = {
            ["funcName"] = "setGuideLine",
            ["outArgs"] = "SetGuideLineRsp",
            ["seq"] = "50365165240353611404536",
            ["inArgs"] = "SetGuideLineReq",
        },
        ["383651155347332561732454211405051"] = {
            ["funcName"] = "getPvpDayRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347332561732454211405051",
        },
        ["setGuideLine"] = {
            ["funcName"] = "setGuideLine",
            ["outArgs"] = "SetGuideLineRsp",
            ["seq"] = "50365165240353611404536",
            ["inArgs"] = "SetGuideLineReq",
        },
        ["1736343640533612324043"] = {
            ["funcName"] = "ReceiveMail",
            ["outArgs"] = "MailListRsp",
            ["seq"] = "1736343640533612324043",
        },
        ["getSngReward"] = {
            ["funcName"] = "getSngReward",
            ["outArgs"] = "GetSngRewardRsp",
            ["seq"] = "383651184538173654324935",
            ["inArgs"] = "GetSngRewardReq",
        },
        ["getGuideLine"] = {
            ["funcName"] = "getGuideLine",
            ["outArgs"] = "GetGuideLineRsp",
            ["seq"] = "38365165240353611404536",
        },
        ["49363749365039736494618394647"] = {
            ["funcName"] = "refreshHeroShop",
            ["outArgs"] = "RefreshHeroShopRsp",
            ["seq"] = "49363749365039736494618394647",
            ["inArgs"] = "RefreshHeroShopReq",
        },
        ["38365117365432493519404436"] = {
            ["funcName"] = "getRewardTime",
            ["outArgs"] = "GetRewardTimeRsp",
            ["seq"] = "38365117365432493519404436",
        },
        ["503946477364946"] = {
            ["funcName"] = "shopHero",
            ["outArgs"] = "ShopHeroRsp",
            ["seq"] = "503946477364946",
            ["inArgs"] = "ShopHeroReq",
        },
        ["38365115493650364551"] = {
            ["funcName"] = "getPresent",
            ["outArgs"] = "GetPresentRsp",
            ["seq"] = "38365115493650364551",
        },
        ["upgradeHeroStar"] = {
            ["funcName"] = "upgradeHeroStar",
            ["outArgs"] = "UpgradeHeroStarRsp",
            ["seq"] = "52473849323536736494618513249",
            ["inArgs"] = "UpgradeHeroStarReq",
        },
        ["34393245383603742"] = {
            ["funcName"] = "changeAfk",
            ["outArgs"] = "AfkRsp",
            ["seq"] = "34393245383603742",
            ["inArgs"] = "AfkReq",
        },
        ["46373743404536154946374051"] = {
            ["funcName"] = "offlineProfit",
            ["outArgs"] = "OfflineProfitRsp",
            ["seq"] = "46373743404536154946374051",
        },
        ["offlineProfit"] = {
            ["funcName"] = "offlineProfit",
            ["outArgs"] = "OfflineProfitRsp",
            ["seq"] = "46373743404536154946374051",
        },
        ["464543404536154946374051"] = {
            ["funcName"] = "onlineProfit",
            ["outArgs"] = "OnlineProfitRsp",
            ["seq"] = "464543404536154946374051",
            ["inArgs"] = "OnlineProfitReq",
        },
        ["upgradeSkillSlot"] = {
            ["funcName"] = "upgradeSkillSlot",
            ["outArgs"] = "UpgradeSlotRsp",
            ["seq"] = "52473849323536184240434318434651",
            ["inArgs"] = "UpgradeSlotReq",
        },
        ["getMailText"] = {
            ["funcName"] = "getMailText",
            ["outArgs"] = "MailTextBody",
            ["seq"] = "3836511232404319365551",
            ["inArgs"] = "MailTextReq",
        },
        ["52473849323536736494618513249"] = {
            ["funcName"] = "upgradeHeroStar",
            ["outArgs"] = "UpgradeHeroStarRsp",
            ["seq"] = "52473849323536736494618513249",
            ["inArgs"] = "UpgradeHeroStarReq",
        },
        ["getRewardTime"] = {
            ["funcName"] = "getRewardTime",
            ["outArgs"] = "GetRewardTimeRsp",
            ["seq"] = "38365117365432493519404436",
        },
        ["5036511232551546543649"] = {
            ["funcName"] = "setMaxPower",
            ["outArgs"] = "MaxPowerRsp",
            ["seq"] = "5036511232551546543649",
            ["inArgs"] = "MaxPowerReq",
        },
        ["getPvpWeekRankList"] = {
            ["funcName"] = "getPvpWeekRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347223636421732454211405051",
        },
        ["enrollPvpWeek"] = {
            ["funcName"] = "enrollPvpWeek",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "36454946434315534722363642",
        },
        ["getPvpWeekF8Result"] = {
            ["funcName"] = "getPvpWeekF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347223636425-9173650524351",
        },
        ["ReceiveMail"] = {
            ["funcName"] = "ReceiveMail",
            ["outArgs"] = "MailListRsp",
            ["seq"] = "1736343640533612324043",
        },
        ["getPvpWeekResult"] = {
            ["funcName"] = "getPvpWeekResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534722363642173650524351",
        },
        ["upgradeHeroLevel"] = {
            ["funcName"] = "upgradeHeroLevel",
            ["outArgs"] = "UpgradeLevelRsp",
            ["seq"] = "5247384932353673649461136533643",
            ["inArgs"] = "UpgradeLevelReq",
        },
        ["383651155347223636425-9173650524351"] = {
            ["funcName"] = "getPvpWeekF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347223636425-9173650524351",
        },
        ["getPvpDayRankList"] = {
            ["funcName"] = "getPvpDayRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347332561732454211405051",
        },
        ["seq"] = "434634",
        ["36454946434315534733256"] = {
            ["funcName"] = "enrollPvpDay",
            ["outArgs"] = "EnrollPvpDayRsp",
            ["seq"] = "36454946434315534733256",
        },
        ["364549464343155347184538"] = {
            ["funcName"] = "enrollPvpSng",
            ["outArgs"] = "EnrollPvpSngRsp",
            ["seq"] = "364549464343155347184538",
        },
        ["compose"] = {
            ["funcName"] = "compose",
            ["outArgs"] = "ComposeRsp",
            ["seq"] = "34464447465036",
            ["inArgs"] = "ComposeReq",
        },
        ["enrollPvpDay"] = {
            ["funcName"] = "enrollPvpDay",
            ["outArgs"] = "EnrollPvpDayRsp",
            ["seq"] = "36454946434315534733256",
        },
        ["upgradeEquipStar"] = {
            ["funcName"] = "upgradeEquipStar",
            ["outArgs"] = "UpgradeEquipRsp",
            ["seq"] = "5247384932353644852404718513249",
            ["inArgs"] = "UpgradeEquipReq",
        },
        ["exitPvpSng"] = {
            ["funcName"] = "exitPvpSng",
            ["outArgs"] = "ExitPvpSngRsp",
            ["seq"] = "36554051155347184538",
        },
        ["343932453836448524047"] = {
            ["funcName"] = "changeEquip",
            ["outArgs"] = "ChangeEquipRsp",
            ["seq"] = "343932453836448524047",
            ["inArgs"] = "ChangeEquipReq",
        },
        ["washHero"] = {
            ["funcName"] = "washHero",
            ["outArgs"] = "WashHeroRsp",
            ["seq"] = "543250397364946",
            ["inArgs"] = "WashHeroReq",
        },
        ["38365118453814655173654324935"] = {
            ["funcName"] = "getSngBoxReward",
            ["outArgs"] = "GetBoxRewardRsp",
            ["seq"] = "38365118453814655173654324935",
            ["inArgs"] = "GetBoxRewardReq",
        },
        ["changeState"] = {
            ["funcName"] = "changeState",
            ["outArgs"] = "ChangeStateRsp",
            ["seq"] = "3439324538361851325136",
            ["inArgs"] = "ChangeStateReq",
        },
        ["changeAfk"] = {
            ["funcName"] = "changeAfk",
            ["outArgs"] = "AfkRsp",
            ["seq"] = "34393245383603742",
            ["inArgs"] = "AfkReq",
        },
        ["44324236448524047"] = {
            ["funcName"] = "makeEquip",
            ["outArgs"] = "MakeEquipRsp",
            ["seq"] = "44324236448524047",
            ["inArgs"] = "MakeEquipReq",
        },
        ["onlineProfit"] = {
            ["funcName"] = "onlineProfit",
            ["outArgs"] = "OnlineProfitRsp",
            ["seq"] = "464543404536154946374051",
            ["inArgs"] = "OnlineProfitReq",
        },
        ["enrollPvpSng"] = {
            ["funcName"] = "enrollPvpSng",
            ["outArgs"] = "EnrollPvpSngRsp",
            ["seq"] = "364549464343155347184538",
        },
        ["495344364351404538448524047"] = {
            ["funcName"] = "rvmeltingEquip",
            ["outArgs"] = "RvMeltingRsp",
            ["seq"] = "495344364351404538448524047",
            ["inArgs"] = "RvMeltingReq",
        },
        ["makeHeroLineup"] = {
            ["funcName"] = "makeHeroLineup",
            ["outArgs"] = "MakeHeroLineupRsp",
            ["seq"] = "443242367364946114045365247",
            ["inArgs"] = "MakeHeroLineupReq",
        },
        ["383651184538173654324935"] = {
            ["funcName"] = "getSngReward",
            ["outArgs"] = "GetSngRewardRsp",
            ["seq"] = "383651184538173654324935",
            ["inArgs"] = "GetSngRewardReq",
        },
        ["36454946434315534722363642"] = {
            ["funcName"] = "enrollPvpWeek",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "36454946434315534722363642",
        },
        ["5432434215325139"] = {
            ["funcName"] = "walkPath",
            ["outArgs"] = "WalkMapRsp",
            ["seq"] = "5432434215325139",
            ["inArgs"] = "WalkMapReq",
        },
        ["walkPath"] = {
            ["funcName"] = "walkPath",
            ["outArgs"] = "WalkMapRsp",
            ["seq"] = "5432434215325139",
            ["inArgs"] = "WalkMapReq",
        },
        ["refreshHeroShop"] = {
            ["funcName"] = "refreshHeroShop",
            ["outArgs"] = "RefreshHeroShopRsp",
            ["seq"] = "49363749365039736494618394647",
            ["inArgs"] = "RefreshHeroShopReq",
        },
        ["3645513649123247"] = {
            ["funcName"] = "enterMap",
            ["outArgs"] = "EnterMapRsp",
            ["seq"] = "3645513649123247",
            ["inArgs"] = "EnterMapReq",
        },
        ["getGlobalMapInfo"] = {
            ["funcName"] = "getGlobalMapInfo",
            ["outArgs"] = "GlobalMapInfo",
            ["seq"] = "383651643463332431232478453746",
        },
        ["383651643463332431232478453746"] = {
            ["funcName"] = "getGlobalMapInfo",
            ["outArgs"] = "GlobalMapInfo",
            ["seq"] = "383651643463332431232478453746",
        },
        ["36554051155347184538"] = {
            ["funcName"] = "exitPvpSng",
            ["outArgs"] = "ExitPvpSngRsp",
            ["seq"] = "36554051155347184538",
        },
        ["makeEquip"] = {
            ["funcName"] = "makeEquip",
            ["outArgs"] = "MakeEquipRsp",
            ["seq"] = "44324236448524047",
            ["inArgs"] = "MakeEquipReq",
        },
        ["useItem"] = {
            ["funcName"] = "useItem",
            ["outArgs"] = "UseItemRsp",
            ["seq"] = "5250368513644",
            ["inArgs"] = "UseItemReq",
        },
        ["changeEquip"] = {
            ["funcName"] = "changeEquip",
            ["outArgs"] = "ChangeEquipRsp",
            ["seq"] = "343932453836448524047",
            ["inArgs"] = "ChangeEquipReq",
        },
        ["getMailAttach"] = {
            ["funcName"] = "getMailAttach",
            ["outArgs"] = "MailAttachRsp",
            ["seq"] = "3836511232404305151323439",
            ["inArgs"] = "MailAttachReq",
        },
        ["meltingEquip"] = {
            ["funcName"] = "meltingEquip",
            ["outArgs"] = "MeltingEquipRsp",
            ["seq"] = "44364351404538448524047",
            ["inArgs"] = "MeltingEquipReq",
        },
        ["serverName"] = "loc",
        ["5250368513644"] = {
            ["funcName"] = "useItem",
            ["outArgs"] = "UseItemRsp",
            ["seq"] = "5250368513644",
            ["inArgs"] = "UseItemReq",
        },
        ["503643438513644649465247"] = {
            ["funcName"] = "sellItemGroup",
            ["outArgs"] = "SellItemRsp",
            ["seq"] = "503643438513644649465247",
            ["inArgs"] = "SellItemReq",
        },
    },
    ["gate"] = {
        ["getAvgConnServerLoadNums"] = {
            ["funcName"] = "getAvgConnServerLoadNums",
            ["outArgs"] = "AvgLoadNumsRsp",
            ["seq"] = "3836510533824645451836495336491146323513524450",
            ["inArgs"] = "AvgLoadNumsReq",
        },
        ["serverName"] = "gate",
        ["seq"] = "38325136",
        ["3836510533824645451836495336491146323513524450"] = {
            ["funcName"] = "getAvgConnServerLoadNums",
            ["outArgs"] = "AvgLoadNumsRsp",
            ["seq"] = "3836510533824645451836495336491146323513524450",
            ["inArgs"] = "AvgLoadNumsReq",
        },
    },
    ["loc"] = {
        ["5047434051448524047"] = {
            ["funcName"] = "splitEquip",
            ["outArgs"] = "SplitEquipRsp",
            ["seq"] = "5047434051448524047",
            ["inArgs"] = "SplitEquipReq",
        },
        ["getPvpMainList"] = {
            ["funcName"] = "getPvpMainList",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "3836511553471232404511405051",
        },
        ["rvmeltingEquip"] = {
            ["funcName"] = "rvmeltingEquip",
            ["outArgs"] = "RvMeltingRsp",
            ["seq"] = "495344364351404538448524047",
            ["inArgs"] = "RvMeltingReq",
        },
        ["sellItemGroup"] = {
            ["funcName"] = "sellItemGroup",
            ["outArgs"] = "SellItemRsp",
            ["seq"] = "503643438513644649465247",
            ["inArgs"] = "SellItemReq",
        },
        ["38365115534722363642173650524351"] = {
            ["funcName"] = "getPvpWeekResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534722363642173650524351",
        },
        ["52454346344213238"] = {
            ["funcName"] = "unlockBag",
            ["outArgs"] = "UnlockBagRsp",
            ["seq"] = "52454346344213238",
            ["inArgs"] = "UnlockBagReq",
        },
        ["getHeroInfoList"] = {
            ["funcName"] = "getHeroInfoList",
            ["outArgs"] = "HeroListRsp",
            ["seq"] = "3836517364946845374611405051",
        },
        ["3439324538361851325136"] = {
            ["funcName"] = "changeState",
            ["outArgs"] = "ChangeStateRsp",
            ["seq"] = "3439324538361851325136",
            ["inArgs"] = "ChangeStateReq",
        },
        ["setMaxPower"] = {
            ["funcName"] = "setMaxPower",
            ["outArgs"] = "MaxPowerRsp",
            ["seq"] = "5036511232551546543649",
            ["inArgs"] = "MaxPowerReq",
        },
        ["shopHero"] = {
            ["funcName"] = "shopHero",
            ["outArgs"] = "ShopHeroRsp",
            ["seq"] = "503946477364946",
            ["inArgs"] = "ShopHeroReq",
        },
        ["34464447465036"] = {
            ["funcName"] = "compose",
            ["outArgs"] = "ComposeRsp",
            ["seq"] = "34464447465036",
            ["inArgs"] = "ComposeReq",
        },
        ["getPvpDayResult"] = {
            ["funcName"] = "getPvpDayResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534733256173650524351",
        },
        ["splitEquip"] = {
            ["funcName"] = "splitEquip",
            ["outArgs"] = "SplitEquipRsp",
            ["seq"] = "5047434051448524047",
            ["inArgs"] = "SplitEquipReq",
        },
        ["383651155347223636421732454211405051"] = {
            ["funcName"] = "getPvpWeekRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347223636421732454211405051",
        },
        ["unlockBag"] = {
            ["funcName"] = "unlockBag",
            ["outArgs"] = "UnlockBagRsp",
            ["seq"] = "52454346344213238",
            ["inArgs"] = "UnlockBagReq",
        },
        ["enterMap"] = {
            ["funcName"] = "enterMap",
            ["outArgs"] = "EnterMapRsp",
            ["seq"] = "3645513649123247",
            ["inArgs"] = "EnterMapReq",
        },
        ["upgradeHeroQuality"] = {
            ["funcName"] = "upgradeHeroQuality",
            ["outArgs"] = "UpgradeHeroQualityRsp",
            ["seq"] = "52473849323536736494616523243405156",
            ["inArgs"] = "UpgradeHeroQualityReq",
        },
        ["32353247513649184240434318434651"] = {
            ["funcName"] = "adapterSkillSlot",
            ["outArgs"] = "AdapterSkillSlotRsp",
            ["seq"] = "32353247513649184240434318434651",
            ["inArgs"] = "AdapterSkillSlotReq",
        },
        ["52473849323536736494616523243405156"] = {
            ["funcName"] = "upgradeHeroQuality",
            ["outArgs"] = "UpgradeHeroQualityRsp",
            ["seq"] = "52473849323536736494616523243405156",
            ["inArgs"] = "UpgradeHeroQualityReq",
        },
        ["52473849323536184240434318434651"] = {
            ["funcName"] = "upgradeSkillSlot",
            ["outArgs"] = "UpgradeSlotRsp",
            ["seq"] = "52473849323536184240434318434651",
            ["inArgs"] = "UpgradeSlotReq",
        },
        ["getPresent"] = {
            ["funcName"] = "getPresent",
            ["outArgs"] = "GetPresentRsp",
            ["seq"] = "38365115493650364551",
        },
        ["443242367364946114045365247"] = {
            ["funcName"] = "makeHeroLineup",
            ["outArgs"] = "MakeHeroLineupRsp",
            ["seq"] = "443242367364946114045365247",
            ["inArgs"] = "MakeHeroLineupReq",
        },
        ["3836511553471232404511405051"] = {
            ["funcName"] = "getPvpMainList",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "3836511553471232404511405051",
        },
        ["38365115534733256173650524351"] = {
            ["funcName"] = "getPvpDayResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534733256173650524351",
        },
        ["38365165240353611404536"] = {
            ["funcName"] = "getGuideLine",
            ["outArgs"] = "GetGuideLineRsp",
            ["seq"] = "38365165240353611404536",
        },
        ["3836511232404305151323439"] = {
            ["funcName"] = "getMailAttach",
            ["outArgs"] = "MailAttachRsp",
            ["seq"] = "3836511232404305151323439",
            ["inArgs"] = "MailAttachReq",
        },
        ["rollHero"] = {
            ["funcName"] = "rollHero",
            ["outArgs"] = "RollHeroRsp",
            ["seq"] = "494643437364946",
            ["inArgs"] = "RollHeroReq",
        },
        ["494643437364946"] = {
            ["funcName"] = "rollHero",
            ["outArgs"] = "RollHeroRsp",
            ["seq"] = "494643437364946",
            ["inArgs"] = "RollHeroReq",
        },
        ["5247384932353644852404718513249"] = {
            ["funcName"] = "upgradeEquipStar",
            ["outArgs"] = "UpgradeEquipRsp",
            ["seq"] = "5247384932353644852404718513249",
            ["inArgs"] = "UpgradeEquipReq",
        },
        ["5247384932353673649461136533643"] = {
            ["funcName"] = "upgradeHeroLevel",
            ["outArgs"] = "UpgradeLevelRsp",
            ["seq"] = "5247384932353673649461136533643",
            ["inArgs"] = "UpgradeLevelReq",
        },
        ["44364351404538448524047"] = {
            ["funcName"] = "meltingEquip",
            ["outArgs"] = "MeltingEquipRsp",
            ["seq"] = "44364351404538448524047",
            ["inArgs"] = "MeltingEquipReq",
        },
        ["3836517364946845374611405051"] = {
            ["funcName"] = "getHeroInfoList",
            ["outArgs"] = "HeroListRsp",
            ["seq"] = "3836517364946845374611405051",
        },
        ["getPvpDayF8Result"] = {
            ["funcName"] = "getPvpDayF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347332565-9173650524351",
        },
        ["543250397364946"] = {
            ["funcName"] = "washHero",
            ["outArgs"] = "WashHeroRsp",
            ["seq"] = "543250397364946",
            ["inArgs"] = "WashHeroReq",
        },
        ["getSngBoxReward"] = {
            ["funcName"] = "getSngBoxReward",
            ["outArgs"] = "GetBoxRewardRsp",
            ["seq"] = "38365118453814655173654324935",
            ["inArgs"] = "GetBoxRewardReq",
        },
        ["adapterSkillSlot"] = {
            ["funcName"] = "adapterSkillSlot",
            ["outArgs"] = "AdapterSkillSlotRsp",
            ["seq"] = "32353247513649184240434318434651",
            ["inArgs"] = "AdapterSkillSlotReq",
        },
        ["513650513325132"] = {
            ["funcName"] = "testData",
            ["outArgs"] = "TestDataRsp",
            ["seq"] = "513650513325132",
            ["inArgs"] = "TestDataReq",
        },
        ["383651155347332565-9173650524351"] = {
            ["funcName"] = "getPvpDayF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347332565-9173650524351",
        },
        ["3836511232404319365551"] = {
            ["funcName"] = "getMailText",
            ["outArgs"] = "MailTextBody",
            ["seq"] = "3836511232404319365551",
            ["inArgs"] = "MailTextReq",
        },
        ["testData"] = {
            ["funcName"] = "testData",
            ["outArgs"] = "TestDataRsp",
            ["seq"] = "513650513325132",
            ["inArgs"] = "TestDataReq",
        },
        ["50365165240353611404536"] = {
            ["funcName"] = "setGuideLine",
            ["outArgs"] = "SetGuideLineRsp",
            ["seq"] = "50365165240353611404536",
            ["inArgs"] = "SetGuideLineReq",
        },
        ["383651155347332561732454211405051"] = {
            ["funcName"] = "getPvpDayRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347332561732454211405051",
        },
        ["setGuideLine"] = {
            ["funcName"] = "setGuideLine",
            ["outArgs"] = "SetGuideLineRsp",
            ["seq"] = "50365165240353611404536",
            ["inArgs"] = "SetGuideLineReq",
        },
        ["1736343640533612324043"] = {
            ["funcName"] = "ReceiveMail",
            ["outArgs"] = "MailListRsp",
            ["seq"] = "1736343640533612324043",
        },
        ["getSngReward"] = {
            ["funcName"] = "getSngReward",
            ["outArgs"] = "GetSngRewardRsp",
            ["seq"] = "383651184538173654324935",
            ["inArgs"] = "GetSngRewardReq",
        },
        ["getGuideLine"] = {
            ["funcName"] = "getGuideLine",
            ["outArgs"] = "GetGuideLineRsp",
            ["seq"] = "38365165240353611404536",
        },
        ["49363749365039736494618394647"] = {
            ["funcName"] = "refreshHeroShop",
            ["outArgs"] = "RefreshHeroShopRsp",
            ["seq"] = "49363749365039736494618394647",
            ["inArgs"] = "RefreshHeroShopReq",
        },
        ["38365117365432493519404436"] = {
            ["funcName"] = "getRewardTime",
            ["outArgs"] = "GetRewardTimeRsp",
            ["seq"] = "38365117365432493519404436",
        },
        ["503946477364946"] = {
            ["funcName"] = "shopHero",
            ["outArgs"] = "ShopHeroRsp",
            ["seq"] = "503946477364946",
            ["inArgs"] = "ShopHeroReq",
        },
        ["38365115493650364551"] = {
            ["funcName"] = "getPresent",
            ["outArgs"] = "GetPresentRsp",
            ["seq"] = "38365115493650364551",
        },
        ["upgradeHeroStar"] = {
            ["funcName"] = "upgradeHeroStar",
            ["outArgs"] = "UpgradeHeroStarRsp",
            ["seq"] = "52473849323536736494618513249",
            ["inArgs"] = "UpgradeHeroStarReq",
        },
        ["34393245383603742"] = {
            ["funcName"] = "changeAfk",
            ["outArgs"] = "AfkRsp",
            ["seq"] = "34393245383603742",
            ["inArgs"] = "AfkReq",
        },
        ["46373743404536154946374051"] = {
            ["funcName"] = "offlineProfit",
            ["outArgs"] = "OfflineProfitRsp",
            ["seq"] = "46373743404536154946374051",
        },
        ["offlineProfit"] = {
            ["funcName"] = "offlineProfit",
            ["outArgs"] = "OfflineProfitRsp",
            ["seq"] = "46373743404536154946374051",
        },
        ["464543404536154946374051"] = {
            ["funcName"] = "onlineProfit",
            ["outArgs"] = "OnlineProfitRsp",
            ["seq"] = "464543404536154946374051",
            ["inArgs"] = "OnlineProfitReq",
        },
        ["upgradeSkillSlot"] = {
            ["funcName"] = "upgradeSkillSlot",
            ["outArgs"] = "UpgradeSlotRsp",
            ["seq"] = "52473849323536184240434318434651",
            ["inArgs"] = "UpgradeSlotReq",
        },
        ["getMailText"] = {
            ["funcName"] = "getMailText",
            ["outArgs"] = "MailTextBody",
            ["seq"] = "3836511232404319365551",
            ["inArgs"] = "MailTextReq",
        },
        ["52473849323536736494618513249"] = {
            ["funcName"] = "upgradeHeroStar",
            ["outArgs"] = "UpgradeHeroStarRsp",
            ["seq"] = "52473849323536736494618513249",
            ["inArgs"] = "UpgradeHeroStarReq",
        },
        ["getRewardTime"] = {
            ["funcName"] = "getRewardTime",
            ["outArgs"] = "GetRewardTimeRsp",
            ["seq"] = "38365117365432493519404436",
        },
        ["5036511232551546543649"] = {
            ["funcName"] = "setMaxPower",
            ["outArgs"] = "MaxPowerRsp",
            ["seq"] = "5036511232551546543649",
            ["inArgs"] = "MaxPowerReq",
        },
        ["getPvpWeekRankList"] = {
            ["funcName"] = "getPvpWeekRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347223636421732454211405051",
        },
        ["enrollPvpWeek"] = {
            ["funcName"] = "enrollPvpWeek",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "36454946434315534722363642",
        },
        ["getPvpWeekF8Result"] = {
            ["funcName"] = "getPvpWeekF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347223636425-9173650524351",
        },
        ["ReceiveMail"] = {
            ["funcName"] = "ReceiveMail",
            ["outArgs"] = "MailListRsp",
            ["seq"] = "1736343640533612324043",
        },
        ["getPvpWeekResult"] = {
            ["funcName"] = "getPvpWeekResult",
            ["outArgs"] = "PvpResultRsp",
            ["seq"] = "38365115534722363642173650524351",
        },
        ["upgradeHeroLevel"] = {
            ["funcName"] = "upgradeHeroLevel",
            ["outArgs"] = "UpgradeLevelRsp",
            ["seq"] = "5247384932353673649461136533643",
            ["inArgs"] = "UpgradeLevelReq",
        },
        ["383651155347223636425-9173650524351"] = {
            ["funcName"] = "getPvpWeekF8Result",
            ["outArgs"] = "PvpF8ResultRsp",
            ["seq"] = "383651155347223636425-9173650524351",
        },
        ["getPvpDayRankList"] = {
            ["funcName"] = "getPvpDayRankList",
            ["outArgs"] = "PvpRankListRsp",
            ["seq"] = "383651155347332561732454211405051",
        },
        ["seq"] = "434634",
        ["36454946434315534733256"] = {
            ["funcName"] = "enrollPvpDay",
            ["outArgs"] = "EnrollPvpDayRsp",
            ["seq"] = "36454946434315534733256",
        },
        ["364549464343155347184538"] = {
            ["funcName"] = "enrollPvpSng",
            ["outArgs"] = "EnrollPvpSngRsp",
            ["seq"] = "364549464343155347184538",
        },
        ["compose"] = {
            ["funcName"] = "compose",
            ["outArgs"] = "ComposeRsp",
            ["seq"] = "34464447465036",
            ["inArgs"] = "ComposeReq",
        },
        ["enrollPvpDay"] = {
            ["funcName"] = "enrollPvpDay",
            ["outArgs"] = "EnrollPvpDayRsp",
            ["seq"] = "36454946434315534733256",
        },
        ["upgradeEquipStar"] = {
            ["funcName"] = "upgradeEquipStar",
            ["outArgs"] = "UpgradeEquipRsp",
            ["seq"] = "5247384932353644852404718513249",
            ["inArgs"] = "UpgradeEquipReq",
        },
        ["exitPvpSng"] = {
            ["funcName"] = "exitPvpSng",
            ["outArgs"] = "ExitPvpSngRsp",
            ["seq"] = "36554051155347184538",
        },
        ["343932453836448524047"] = {
            ["funcName"] = "changeEquip",
            ["outArgs"] = "ChangeEquipRsp",
            ["seq"] = "343932453836448524047",
            ["inArgs"] = "ChangeEquipReq",
        },
        ["washHero"] = {
            ["funcName"] = "washHero",
            ["outArgs"] = "WashHeroRsp",
            ["seq"] = "543250397364946",
            ["inArgs"] = "WashHeroReq",
        },
        ["38365118453814655173654324935"] = {
            ["funcName"] = "getSngBoxReward",
            ["outArgs"] = "GetBoxRewardRsp",
            ["seq"] = "38365118453814655173654324935",
            ["inArgs"] = "GetBoxRewardReq",
        },
        ["changeState"] = {
            ["funcName"] = "changeState",
            ["outArgs"] = "ChangeStateRsp",
            ["seq"] = "3439324538361851325136",
            ["inArgs"] = "ChangeStateReq",
        },
        ["changeAfk"] = {
            ["funcName"] = "changeAfk",
            ["outArgs"] = "AfkRsp",
            ["seq"] = "34393245383603742",
            ["inArgs"] = "AfkReq",
        },
        ["44324236448524047"] = {
            ["funcName"] = "makeEquip",
            ["outArgs"] = "MakeEquipRsp",
            ["seq"] = "44324236448524047",
            ["inArgs"] = "MakeEquipReq",
        },
        ["onlineProfit"] = {
            ["funcName"] = "onlineProfit",
            ["outArgs"] = "OnlineProfitRsp",
            ["seq"] = "464543404536154946374051",
            ["inArgs"] = "OnlineProfitReq",
        },
        ["enrollPvpSng"] = {
            ["funcName"] = "enrollPvpSng",
            ["outArgs"] = "EnrollPvpSngRsp",
            ["seq"] = "364549464343155347184538",
        },
        ["495344364351404538448524047"] = {
            ["funcName"] = "rvmeltingEquip",
            ["outArgs"] = "RvMeltingRsp",
            ["seq"] = "495344364351404538448524047",
            ["inArgs"] = "RvMeltingReq",
        },
        ["makeHeroLineup"] = {
            ["funcName"] = "makeHeroLineup",
            ["outArgs"] = "MakeHeroLineupRsp",
            ["seq"] = "443242367364946114045365247",
            ["inArgs"] = "MakeHeroLineupReq",
        },
        ["383651184538173654324935"] = {
            ["funcName"] = "getSngReward",
            ["outArgs"] = "GetSngRewardRsp",
            ["seq"] = "383651184538173654324935",
            ["inArgs"] = "GetSngRewardReq",
        },
        ["36454946434315534722363642"] = {
            ["funcName"] = "enrollPvpWeek",
            ["outArgs"] = "GetPvpMainListRsp",
            ["seq"] = "36454946434315534722363642",
        },
        ["5432434215325139"] = {
            ["funcName"] = "walkPath",
            ["outArgs"] = "WalkMapRsp",
            ["seq"] = "5432434215325139",
            ["inArgs"] = "WalkMapReq",
        },
        ["walkPath"] = {
            ["funcName"] = "walkPath",
            ["outArgs"] = "WalkMapRsp",
            ["seq"] = "5432434215325139",
            ["inArgs"] = "WalkMapReq",
        },
        ["refreshHeroShop"] = {
            ["funcName"] = "refreshHeroShop",
            ["outArgs"] = "RefreshHeroShopRsp",
            ["seq"] = "49363749365039736494618394647",
            ["inArgs"] = "RefreshHeroShopReq",
        },
        ["3645513649123247"] = {
            ["funcName"] = "enterMap",
            ["outArgs"] = "EnterMapRsp",
            ["seq"] = "3645513649123247",
            ["inArgs"] = "EnterMapReq",
        },
        ["getGlobalMapInfo"] = {
            ["funcName"] = "getGlobalMapInfo",
            ["outArgs"] = "GlobalMapInfo",
            ["seq"] = "383651643463332431232478453746",
        },
        ["383651643463332431232478453746"] = {
            ["funcName"] = "getGlobalMapInfo",
            ["outArgs"] = "GlobalMapInfo",
            ["seq"] = "383651643463332431232478453746",
        },
        ["36554051155347184538"] = {
            ["funcName"] = "exitPvpSng",
            ["outArgs"] = "ExitPvpSngRsp",
            ["seq"] = "36554051155347184538",
        },
        ["makeEquip"] = {
            ["funcName"] = "makeEquip",
            ["outArgs"] = "MakeEquipRsp",
            ["seq"] = "44324236448524047",
            ["inArgs"] = "MakeEquipReq",
        },
        ["useItem"] = {
            ["funcName"] = "useItem",
            ["outArgs"] = "UseItemRsp",
            ["seq"] = "5250368513644",
            ["inArgs"] = "UseItemReq",
        },
        ["changeEquip"] = {
            ["funcName"] = "changeEquip",
            ["outArgs"] = "ChangeEquipRsp",
            ["seq"] = "343932453836448524047",
            ["inArgs"] = "ChangeEquipReq",
        },
        ["getMailAttach"] = {
            ["funcName"] = "getMailAttach",
            ["outArgs"] = "MailAttachRsp",
            ["seq"] = "3836511232404305151323439",
            ["inArgs"] = "MailAttachReq",
        },
        ["meltingEquip"] = {
            ["funcName"] = "meltingEquip",
            ["outArgs"] = "MeltingEquipRsp",
            ["seq"] = "44364351404538448524047",
            ["inArgs"] = "MeltingEquipReq",
        },
        ["serverName"] = "loc",
        ["5250368513644"] = {
            ["funcName"] = "useItem",
            ["outArgs"] = "UseItemRsp",
            ["seq"] = "5250368513644",
            ["inArgs"] = "UseItemReq",
        },
        ["503643438513644649465247"] = {
            ["funcName"] = "sellItemGroup",
            ["outArgs"] = "SellItemRsp",
            ["seq"] = "503643438513644649465247",
            ["inArgs"] = "SellItemReq",
        },
    },
    ["client"] = {
        ["383651444324043"] = {
            ["funcName"] = "getEmail",
            ["outArgs"] = "RecvMailInfoRsp",
            ["seq"] = "383651444324043",
        },
        ["493634531250385494644183649533649"] = {
            ["funcName"] = "recvMsgFromServer",
            ["outArgs"] = "RecvMsgRsp",
            ["seq"] = "493634531250385494644183649533649",
        },
        ["kickClientOffline"] = {
            ["funcName"] = "kickClientOffline",
            ["outArgs"] = "KickClientRsp",
            ["seq"] = "424034422434036455114373743404536",
        },
        ["serverName"] = "client",
        ["getEmail"] = {
            ["funcName"] = "getEmail",
            ["outArgs"] = "RecvMailInfoRsp",
            ["seq"] = "383651444324043",
        },
        ["recvMsgFromServer"] = {
            ["funcName"] = "recvMsgFromServer",
            ["outArgs"] = "RecvMsgRsp",
            ["seq"] = "493634531250385494644183649533649",
        },
        ["seq"] = "344340364551",
        ["424034422434036455114373743404536"] = {
            ["funcName"] = "kickClientOffline",
            ["outArgs"] = "KickClientRsp",
            ["seq"] = "424034422434036455114373743404536",
        },
    },
    ["conn"] = {
        ["43463840456324436"] = {
            ["funcName"] = "loginGame",
            ["outArgs"] = "LoginGameRsp",
            ["seq"] = "43463840456324436",
            ["inArgs"] = "LoginGameReq",
        },
        ["39363249511363251"] = {
            ["funcName"] = "heartBeat",
            ["outArgs"] = "HeartBeatInfo",
            ["seq"] = "39363249511363251",
            ["inArgs"] = "HeartBeatInfo",
        },
        ["365540516324436"] = {
            ["funcName"] = "exitGame",
            ["outArgs"] = "ExitGameRsp",
            ["seq"] = "365540516324436",
        },
        ["heartBeat"] = {
            ["funcName"] = "heartBeat",
            ["outArgs"] = "HeartBeatInfo",
            ["seq"] = "39363249511363251",
            ["inArgs"] = "HeartBeatInfo",
        },
        ["exitGame"] = {
            ["funcName"] = "exitGame",
            ["outArgs"] = "ExitGameRsp",
            ["seq"] = "365540516324436",
        },
        ["loginGame"] = {
            ["funcName"] = "loginGame",
            ["outArgs"] = "LoginGameRsp",
            ["seq"] = "43463840456324436",
            ["inArgs"] = "LoginGameReq",
        },
        ["seq"] = "34464545",
        ["serverName"] = "conn",
    },
    ["344340364551"] = {
        ["383651444324043"] = {
            ["funcName"] = "getEmail",
            ["outArgs"] = "RecvMailInfoRsp",
            ["seq"] = "383651444324043",
        },
        ["493634531250385494644183649533649"] = {
            ["funcName"] = "recvMsgFromServer",
            ["outArgs"] = "RecvMsgRsp",
            ["seq"] = "493634531250385494644183649533649",
        },
        ["kickClientOffline"] = {
            ["funcName"] = "kickClientOffline",
            ["outArgs"] = "KickClientRsp",
            ["seq"] = "424034422434036455114373743404536",
        },
        ["serverName"] = "client",
        ["getEmail"] = {
            ["funcName"] = "getEmail",
            ["outArgs"] = "RecvMailInfoRsp",
            ["seq"] = "383651444324043",
        },
        ["recvMsgFromServer"] = {
            ["funcName"] = "recvMsgFromServer",
            ["outArgs"] = "RecvMsgRsp",
            ["seq"] = "493634531250385494644183649533649",
        },
        ["seq"] = "344340364551",
        ["424034422434036455114373743404536"] = {
            ["funcName"] = "kickClientOffline",
            ["outArgs"] = "KickClientRsp",
            ["seq"] = "424034422434036455114373743404536",
        },
    },
},
["OfflineProfitRsp"] = {
    [1] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "exp",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "action",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "offTime",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "bagitem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
    [6] = {
        ["value"] = "playerInfo",
        ["type"] = "struct",
        ["type1"] = "BaseInfo",
    },
},
["map<string, EquipListValue>"] = {
    [1] = {
        ["type2"] = "EquipListValue",
        ["type"] = "map",
        ["type1"] = "map2",
    },
},
["ChangeStateRsp"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "uid",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "state",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "args",
        ["type"] = "string",
    },
},
["OnlineProfitReq"] = {
    [1] = {
        ["value"] = "isWin",
        ["type"] = "string",
    },
},
["PvpDay"] = {
    [1] = {
        ["value"] = "uuids",
        ["type"] = "vector",
        ["type2"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "rewardPool",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "nums",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "updateTime",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "maxCount",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "pvpF8Result",
        ["type"] = "struct",
        ["type1"] = "PvpF8Result",
    },
    [8] = {
        ["value"] = "finalSort",
        ["type"] = "vector",
        ["type2"] = "UserArea",
    },
},
["MaxPowerRsp"] = {
    [1] = {
        ["value"] = "maxPower",
        ["type"] = "string",
    },
},
["ShopHeroReq"] = {
    [1] = {
        ["value"] = "shopId",
        ["type"] = "string",
    },
},
["SetGuideLineRsp"] = {
    [1] = {
        ["value"] = "isSave",
        ["type"] = "string",
    },
},
["GetSngRewardRsp"] = {
    [1] = {
        ["value"] = "result",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "seed",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "fightReward",
        ["type"] = "struct",
        ["type1"] = "FightReward",
    },
},
["UpgradeHeroStarReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["BagList"] = {
    [1] = {
        ["value"] = "max",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "itemList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "ItemListValue",
    },
    [3] = {
        ["value"] = "equipList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "EquipListValue",
    },
},
["GetGuideLineRsp"] = {
    [1] = {
        ["value"] = "stepLine",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["PvpResultRsp"] = {
    [1] = {
        ["value"] = "maxCount",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "fightInfoList",
        ["type"] = "vector",
        ["type2"] = "DFightInfo",
    },
},
["ExitGameRsp"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
},
["ExitPvpSngRsp"] = {
    [1] = {
        ["value"] = "startMark",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "ticketDay",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "bagItem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
},
["AfkReq"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
},
["MailAttachReq"] = {
    [1] = {
        ["value"] = "mailID",
        ["type"] = "string",
    },
},
["UpgradeLevelReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "expPlayer",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "exp",
        ["type"] = "string",
    },
},
["RecvMailInfoRsp"] = {
    [1] = {
        ["value"] = "sender",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "title",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "attach",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
    [4] = {
        ["value"] = "id",
        ["type"] = "string",
    },
},
["MailTextBody"] = {
    [1] = {
        ["value"] = "text",
        ["type"] = "string",
    },
},
["MailListRsp"] = {
    [1] = {
        ["value"] = "mailList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "mailHead",
    },
},
["LoginGameReq"] = {
    [1] = {
        ["value"] = "authInfo",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "code",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "plat",
        ["type"] = "string",
    },
},
["PvpWeekRankList"] = {
    [1] = {
        ["value"] = "weekRankList",
        ["type"] = "vector",
        ["type2"] = "PvpRankInfo",
    },
},
["PvpRankInfo"] = {
    [1] = {
        ["value"] = "pos",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
},
["EquipListValue"] = {
    [1] = {
        ["value"] = "id",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "star",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "num",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "a1",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "n1",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "a2",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "n2",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "a3",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "n3",
        ["type"] = "string",
    },
    [10] = {
        ["value"] = "a4",
        ["type"] = "string",
    },
    [11] = {
        ["value"] = "n4",
        ["type"] = "string",
    },
    [12] = {
        ["value"] = "sa",
        ["type"] = "string",
    },
    [13] = {
        ["value"] = "sn",
        ["type"] = "string",
    },
    [14] = {
        ["value"] = "ss",
        ["type"] = "string",
    },
},
["mailHead"] = {
    [1] = {
        ["value"] = "sender",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "title",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "attach",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
    [4] = {
        ["value"] = "id",
        ["type"] = "string",
    },
},
["ComposeRsp"] = {
    [1] = {
        ["value"] = "target",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "num",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "costings",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["ChangeStateReq"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "uid",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "nextstate",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "args",
        ["type"] = "string",
    },
},
["RecvMsgRsp"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "type",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "msg",
        ["type"] = "string",
    },
},
["AdapterSkillSlotReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "skillId1",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "skillId2",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "skillId3",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "skillId4",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "skillId5",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "skillId6",
        ["type"] = "string",
    },
},
["UseItemReq"] = {
    [1] = {
        ["value"] = "item",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
},
["PvpSng"] = {
    [1] = {
        ["value"] = "id",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "keys",
        ["type"] = "vector",
        ["type2"] = "UserArea",
    },
},
["ChangeEquipReq"] = {
    [1] = {
        ["value"] = "sign",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "seq",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "id1",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "id2",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "id3",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "id4",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "id5",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "id6",
        ["type"] = "string",
    },
},
["UpgradeSlotReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "slotId",
        ["type"] = "string",
    },
},
["DFightInfo"] = {
    [1] = {
        ["value"] = "player1",
        ["type"] = "struct",
        ["type1"] = "PlayerInfo",
    },
    [2] = {
        ["value"] = "player2",
        ["type"] = "struct",
        ["type1"] = "PlayerInfo",
    },
    [3] = {
        ["value"] = "seed",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "winner",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "fightReward",
        ["type"] = "struct",
        ["type1"] = "FightReward",
    },
},
["SFightInfo"] = {
    [1] = {
        ["value"] = "enemy",
        ["type"] = "struct",
        ["type1"] = "PlayerInfo",
    },
    [2] = {
        ["value"] = "result",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "seed",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "ticketDay",
        ["type"] = "string",
    },
},
["FightReward"] = {
    [1] = {
        ["value"] = "diamand",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "ticketDay",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "ticketWeek",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "bagItem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
},
["MailTextReq"] = {
    [1] = {
        ["value"] = "mailID",
        ["type"] = "string",
    },
},
["MaxPowerReq"] = {
    [1] = {
        ["value"] = "maxPower",
        ["type"] = "string",
    },
},
["GetSngRewardReq"] = {
    [1] = {
        ["value"] = "enemyType",
        ["type"] = "string",
    },
},
["SellItemRsp"] = {
    [1] = {
        ["value"] = "cost",
        ["type"] = "string",
    },
},
["GlobalInfo"] = {
    [1] = {
        ["value"] = "pvpDay",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "PvpDay",
    },
    [2] = {
        ["value"] = "pvpWeek",
        ["type"] = "struct",
        ["type1"] = "PvpWeek",
    },
},
["HeroListRsp"] = {
    [1] = {
        ["value"] = "heroInfoList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "HeroInfo",
    },
    [2] = {
        ["value"] = "heroBookInfo",
        ["type"] = "struct",
        ["type1"] = "HeroBookInfo",
    },
},
["PosListValue"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "pos",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "equipIdList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["WalkMapReq"] = {
    [1] = {
        ["value"] = "nodeid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "uid",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "path",
        ["type"] = "vector",
        ["type2"] = "PosInfo",
    },
},
["PosInfo"] = {
    [1] = {
        ["value"] = "x",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "y",
        ["type"] = "string",
    },
},
["EnterMapRsp"] = {
    [1] = {
        ["value"] = "x",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "y",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "ap",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "uidList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
    [5] = {
        ["value"] = "sign",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
    [6] = {
        ["value"] = "buff",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
    [7] = {
        ["value"] = "process",
        ["type"] = "string",
    },
},
["HeroInfo"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "curExp",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "level",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "star",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "quality",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "pos",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "skillSlotList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "SkillSlotValue",
    },
    [8] = {
        ["value"] = "suitId1",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "suitId2",
        ["type"] = "string",
    },
    [10] = {
        ["value"] = "suitId3",
        ["type"] = "string",
    },
    [11] = {
        ["value"] = "suitId4",
        ["type"] = "string",
    },
    [12] = {
        ["value"] = "suitId5",
        ["type"] = "string",
    },
},
["EnrollPvpSngRsp"] = {
    [1] = {
        ["value"] = "pvpInfo",
        ["type"] = "struct",
        ["type1"] = "PvpInfo",
    },
},
["KickClientRsp"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
},
["BagItem"] = {
    [1] = {
        ["value"] = "itemList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "ItemListValue",
    },
    [2] = {
        ["value"] = "equipList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "EquipListValue",
    },
},
["MakeEquipRsp"] = {
    [1] = {
        ["value"] = "equipList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "EquipListValue",
    },
},
["SendMsgRsp"] = {
    [1] = {
        ["value"] = "state",
        ["type"] = "string",
    },
},
["MailAttachRsp"] = {
    [1] = {
        ["value"] = "isOK",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "attach",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["UpgradeHeroStarRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["SplitEquipRsp"] = {
    [1] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "splitList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "ItemListValue",
    },
},
["ChangeEquipRsp"] = {
    [1] = {
        ["value"] = "equipList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "map<string, EquipListValue>",
    },
},
["UserArea"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
},
["GetBoxRewardRsp"] = {
    [1] = {
        ["value"] = "ticketDay",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "bagItem",
        ["type"] = "struct",
        ["type1"] = "BagItem",
    },
},
["UpgradeEquipReq"] = {
    [1] = {
        ["value"] = "equipId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "id1",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "id2",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "id3",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "id4",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "id5",
        ["type"] = "string",
    },
},
["TestAddItemOut"] = {
    [1] = {
        ["value"] = "item",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["ComposeReq"] = {
    [1] = {
        ["value"] = "item",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "num",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "composeid",
        ["type"] = "string",
    },
},
["OpenNode"] = {
    [1] = {
        ["value"] = "process",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "compAward",
        ["type"] = "string",
    },
},
["GetRewardTimeRsp"] = {
    [1] = {
        ["value"] = "rewardCount",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "step",
        ["type"] = "string",
    },
},
["UpgradeEquipRsp"] = {
    [1] = {
        ["value"] = "equip",
        ["type"] = "struct",
        ["type1"] = "EquipResult",
    },
},
["PlayerInfo"] = {
    [1] = {
        ["value"] = "uuid",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "area",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "userName",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "level",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "curExp",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "gold",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "vip",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "diamond",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "teamList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "HeroInfo",
    },
    [10] = {
        ["value"] = "equipList",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "map<string, EquipListValue>",
    },
    [11] = {
        ["value"] = "bagList",
        ["type"] = "struct",
        ["type1"] = "BagList",
    },
},
["SplitEquipReq"] = {
    [1] = {
        ["value"] = "equipIdList",
        ["type"] = "vector",
        ["type2"] = "string",
    },
},
["WashHeroReq"] = {
    [1] = {
        ["value"] = "heroId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "lock1",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "lock2",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "lock3",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "lock4",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "lock5",
        ["type"] = "string",
    },
},
["MakeEquipReq"] = {
    [1] = {
        ["value"] = "scrollList",
        ["type"] = "vector",
        ["type2"] = "string",
    },
},
["MeltingEquipReq"] = {
    [1] = {
        ["value"] = "lequipId",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "requipId",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "attr",
        ["type"] = "string",
    },
},
["PvpWeek"] = {
    [1] = {
        ["value"] = "userArea",
        ["type"] = "vector",
        ["type2"] = "UserArea",
    },
    [2] = {
        ["value"] = "rewardPool",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "nums",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "maxCount",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "pvpF8Result",
        ["type"] = "struct",
        ["type1"] = "PvpF8Result",
    },
    [6] = {
        ["value"] = "finalSort",
        ["type"] = "vector",
        ["type2"] = "UserArea",
    },
},
["PvpF8Result"] = {
    [1] = {
        ["value"] = "playerInfoList",
        ["type"] = "vector",
        ["type2"] = "PlayerInfo",
    },
    [2] = {
        ["value"] = "fightInfoList8",
        ["type"] = "vector",
        ["type2"] = "FightInfo",
    },
    [3] = {
        ["value"] = "fightInfoList4",
        ["type"] = "vector",
        ["type2"] = "FightInfo",
    },
    [4] = {
        ["value"] = "fightInfoList2",
        ["type"] = "vector",
        ["type2"] = "FightInfo",
    },
    [5] = {
        ["value"] = "fightInfoList1",
        ["type"] = "vector",
        ["type2"] = "FightInfo",
    },
},
["RollHeroRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
    [2] = {
        ["value"] = "heroBookInfo",
        ["type"] = "struct",
        ["type1"] = "HeroBookInfo",
    },
},
["AvgLoadNumsReq"] = {
    [1] = {
        ["value"] = "chnlId",
        ["type"] = "string",
    },
},
["AdapterSkillSlotRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["AfkRsp"] = {
    [1] = {
        ["value"] = "newNode",
        ["type"] = "map",
        ["type1"] = "string",
        ["type2"] = "string",
    },
},
["UpgradeHeroQualityRsp"] = {
    [1] = {
        ["value"] = "heroInfo",
        ["type"] = "struct",
        ["type1"] = "HeroInfo",
    },
},
["RefreshHeroShopRsp"] = {
    [1] = {
        ["value"] = "shop1",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "shop2",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "shop3",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "shop4",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "shop5",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "refreshNums",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "time",
        ["type"] = "string",
    },
},
["PvpInfo"] = {
    [1] = {
        ["value"] = "ticketN",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "ticketDay",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "ticketWeek",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "fightCount",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "startMark",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "box1",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "box2",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "box3",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "myTime",
        ["type"] = "string",
    },
    [10] = {
        ["value"] = "refreshTime",
        ["type"] = "string",
    },
    [11] = {
        ["value"] = "dayMark",
        ["type"] = "string",
    },
    [12] = {
        ["value"] = "weekMark",
        ["type"] = "string",
    },
    [13] = {
        ["value"] = "fightInfoListSng",
        ["type"] = "vector",
        ["type2"] = "SFightInfo",
    },
    [14] = {
        ["value"] = "fightInfoListDay",
        ["type"] = "vector",
        ["type2"] = "DFightInfo",
    },
    [15] = {
        ["value"] = "fightInfoListWeek",
        ["type"] = "vector",
        ["type2"] = "DFightInfo",
    },
},
["HeroBookInfo"] = {
    [1] = {
        ["value"] = "heroId1",
        ["type"] = "string",
    },
    [2] = {
        ["value"] = "heroId2",
        ["type"] = "string",
    },
    [3] = {
        ["value"] = "heroId3",
        ["type"] = "string",
    },
    [4] = {
        ["value"] = "summomNums",
        ["type"] = "string",
    },
    [5] = {
        ["value"] = "shop1",
        ["type"] = "string",
    },
    [6] = {
        ["value"] = "shop2",
        ["type"] = "string",
    },
    [7] = {
        ["value"] = "shop3",
        ["type"] = "string",
    },
    [8] = {
        ["value"] = "shop4",
        ["type"] = "string",
    },
    [9] = {
        ["value"] = "shop5",
        ["type"] = "string",
    },
    [10] = {
        ["value"] = "refreshNums",
        ["type"] = "string",
    },
    [11] = {
        ["value"] = "time",
        ["type"] = "string",
    },
},
}
 return _p
