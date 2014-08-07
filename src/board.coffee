five = require "johnny-five"
module.exports = #---

board = new five.Board()

board.setPinAsInput = (pin) ->
	board.pinMode pin, LOW

board.setPinAsOutput = (pin) ->
	board.pinMode pin, HIGH

board