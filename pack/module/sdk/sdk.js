var http = require("http");
var moment = require('moment');
var tiny = require('../../tiny');
//var moment = require('/home/tinygame/server/tinygame/node_modules/moment/moment');
var crypto = require('crypto');
var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;

var appKey = "3c51dc8612a340acb127c96c19c8f299";
var svrKey = "57d5216ed78542c3afda1b9b6d6e39d5";
var sdkUrl = "http://a2.xgsdk.com/account/verify-session/2111";

// 获取签名
var getSign = function(str, key) {
	var hmac = crypto.createHmac('sha1', key);
	hmac.update(str);
	return hmac.digest('hex');
};

// sdk 登录验证token
exports.sdk_checkToken = function(inArgs, callback) {
	var authInfo = {}, ts = moment().format("YYYYMMDDhhmmss"), srcAuthInfo, b64AuthInfo, srcLogin, sign, args;

	// authInfo 太长则认为是手机平台
	if (inArgs.plat === Const.LoginPlat.WINDOWS) {

		authInfo.xgAppId   = "2111";
		authInfo.planId    = "102";
		authInfo.channelId = "xgtest";         // 渠道ID
		authInfo.deviceId  = "deviceId";
		authInfo.ts        = ts;
		authInfo.authToken = "authToken";
		authInfo.uId       = inArgs.authInfo;
		authInfo.name      = inArgs.authInfo;
		// authInfo = inArgs.authInfo;
		// authInfo生成签名前的源串
		srcAuthInfo = 'authToken=' + authInfo.authToken + '&channelId=' + authInfo.channelId +
					  '&deviceId=' + authInfo.deviceId + '&name=' +authInfo.name +
					  '&planId=' + authInfo.planId + '&ts=' + ts +
					  '&uid=' + authInfo.uId + '&xgAppId=' + authInfo.xgAppId;

		tiny.log.info("srcAuthInfo:", srcAuthInfo);

	    // 获取签名
		authInfo.sign      = getSign(srcAuthInfo, appKey);

		tiny.log.info("authInfo.sign:", authInfo.sign);

		b64AuthInfo = new Buffer(JSON.stringify(authInfo)).toString('base64');

		tiny.log.info("b64AuthInfo:", b64AuthInfo);

		// 登录验证参数签名前的源串
		srcLogin = 'authInfo=' + b64AuthInfo + '&ts=' + ts + '&type=verify-session';

	} else {
		// 登录验证参数签名前的源串
		srcLogin = 'authInfo=' + inArgs.authInfo + '&ts=' + ts + '&type=verify-session';
	}

	tiny.log.info("srcLogin:", srcLogin);

	// 获取签名
	sign = getSign(srcLogin, svrKey);

	tiny.log.info("sign:", sign);

	// 组织参数
	args = '?' + srcLogin + '&sign=' + sign;

	tiny.log.trace('$$$$$$$$$$$$$$$$$$sdk request = ', sdkUrl + args);

	// http请求
	http.get(sdkUrl + args, function(res) {
		var rspText = [], size = 0;
		tiny.log.info('STATUS: ' + res.statusCode);
		if (res.statusCode !== 200) {
			callback('STATUS: ' + res.statusCode);
			return;
		}
		tiny.log.info('HEADERS: ' + JSON.stringify(res.headers));
		res.setEncoding('utf8');
		res.on('data', function (chunk) {
			tiny.log.info('BODY: ' + chunk);
			rspText.push(chunk);
			size += chunk.length;
		});
		res.on('end', function() {
			rspText = Buffer.concat(rspText, size);
			tiny.log.info('JSON: ' + rspText);
			rspText = JSON.parse(rspText);
			if (rspText.hasOwnProperty("code")
				&& parseInt(rspText.code, 10) === ErrCode.SUCCESS) {
				callback(null, rspText.data);
			} else {
				callback("check token fail", rspText.data);
			}
		});
	}).on('error', function(e) {
		tiny.log.info("Got error: " + e.message);
		callback(e.message);
	});
};

