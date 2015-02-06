var method = ClientConnection.prototype;
var Record = require("./Record.js");

function ClientConnection(address) {
    this._address = address;
    this._records = new Array();
}

method.getAddress = function() {
    return this._address;
};

method.addRecord = function(Record){
	this._records.push(Record);
}

module.exports = ClientConnection;