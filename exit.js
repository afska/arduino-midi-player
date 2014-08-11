//hack for completely disconnect the arduino

var five = require("johnny-five");
new five.Board().on("ready", function() {
	process.kill();
});