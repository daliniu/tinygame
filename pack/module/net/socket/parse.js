var utils = require('../../utils');
var tiny = require('../../../tiny');
var StringMaxLength = require('../../const').MAX_PROTO_STRING_LENGTH;
var ErrCode = require('../../const').CLIENT_ERROR_CODE;
var SERIAL_DATA_TYPE = require('../../const').SERIAL_DATA_TYPE;
var Serialize = require('../../dataprocess/serialize/serialize');
var SerialProto = require('../../dataprocess/serialize/serial_proto');

module.exports.pack = function(data) {
	/*
	var buffer, len, s;
	s = JSON.stringify(data);
	len = s.length;
	if (len > StringMaxLength) {
		tiny.log.error('packBytes stirng too long');
		return null;
	}
	buffer = new Buffer(len + 2);
	buffer.writeUInt16BE(len, 0);
	buffer.write(s, 0);
	return buffer;
	*/
/*
0       serverName
1       funcName
2       args
3       funcId
4       retCode
*/
	try {
	var buffer,str, packData = [];
	try {
	packData[SERIAL_DATA_TYPE.SERVER_NAME] = 0;
	packData[SERIAL_DATA_TYPE.FUNC_NAME] = SerialProto.interface[data.serverName][data.funcName].seq;
	if (data.retCode === ErrCode.SUCCESS || data.retCode > ErrCode.RETCODE_NEED_UNPACK) {
		packData[SERIAL_DATA_TYPE.ARGS] = Serialize.serialize(SerialProto.interface[data.serverName][data.funcName].outArgs, data.args);
	} else {
		packData[SERIAL_DATA_TYPE.ARGS] = [];
	}
	packData[SERIAL_DATA_TYPE.FUNCID] = data.funcId;
	packData[SERIAL_DATA_TYPE.RET_CODE] = data.retCode;
	tiny.log.trace("....................sss", JSON.stringify(packData));
	} catch(e) {
		tiny.log.error("..........test..........p", data.serverName, data.funcName, SerialProto.interface[data.serverName][data.funcName].outArgs, JSON.stringify(packData[SERIAL_DATA_TYPE.ARGS]), e);
		return null;
	}
	// console.log('(((((((((((((((((((((((');
	str = JSON.stringify(packData);
	// buffer = new Buffer(str.length);
	// buffer.write(str, 0);
	buffer = new Buffer(str);
	// console.log(str, str.length);
	// console.log(buffer);
	// console.log(buffer.toString());
	// console.log(buffer.toJSON());
	return buffer;
	} catch(e) {
		tiny.log.error("..........test..........p")	;
	}
	return null;
};

module.exports.unpack = function(buffer) {
	/*
	var data,
		offset = 0,
		len = 0;
	len = buffer.readInt16BE(offset);
	offset += 2;
	data = buffer.toString('utf8', offset, offset + len);
	return JSON.parse(data);
	*/
	try {
	tiny.log.trace("....", buffer);
	var data = {}, unpackData;
	unpackData  = JSON.parse(buffer);
	try {
	data.serverName = SerialProto.interface[unpackData[SERIAL_DATA_TYPE.SERVER_NAME]].serverName;
	data.funcName   = SerialProto.interface[unpackData[SERIAL_DATA_TYPE.SERVER_NAME]][unpackData[SERIAL_DATA_TYPE.FUNC_NAME]].funcName;
	data.args       = unpackData[SERIAL_DATA_TYPE.ARGS];
	data.funcId     = unpackData[SERIAL_DATA_TYPE.FUNCID];
	tiny.log.trace("....................uuu", JSON.stringify(data.args));
	if (utils.jsonIsEmpty(data.args)) {
		data.args = {};
	} else {
		data.args = Serialize.unserialize(SerialProto.interface[data.serverName][data.funcName].inArgs, data.args);
	}
	} catch(e) {
		//tiny.log.error("..........test..........up", data.serverName, data.funcName, e);
		return null;
	}
	return data;
	} catch(e) {
		//tiny.log.error("..........test..........up", e);
	}
	return null;
};
