five = require "johnny-five"
module.exports = #---

board = new five.Board()

global.LOW = 0
global.HIGH = 1

board.setPinAsInput = (pin) ->
	board.pinMode pin, LOW

board.setPinAsOutput = (pin) ->
	board.pinMode pin, HIGH

board