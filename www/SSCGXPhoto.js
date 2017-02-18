var exec = require('cordova/exec');

var SSCGXPhoto = {
	start: function(parameters, success, error){
		exec(success, error, "SSCGXPhoto","startTakePhoto",[parameters]);
	}
};

module.exports = SSCGXPhoto;

