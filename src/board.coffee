five = require "johnny-five"
module.exports = #---

board = new five.Board()

#sets a pin to input.
board.setPinAsInput = (pin) ->
	board.pinMode pin, false

#sets a pin to output.
board.setPinAsOutput = (pin) ->
	board.pinMode pin, true

board