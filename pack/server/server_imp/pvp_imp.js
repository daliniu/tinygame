var Const = require("../../module/const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var agentHandle = require('../../module/dataprocess/agent_handle');
var pvpImp = require('../../module/pvp/pvp_imp');
var async = require('async');
var utils = require('../../module/utils');

agentHandle.bindImp(exports, pvpImp.test);
