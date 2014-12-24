five = require "johnny-five"
module.exports =

#------------------------------------------------------------------------------------------
board = new five.Board()

board.setPinAsInput = (pin) ->
	board.pinMode pin, false

board.setPinAsOutput = (pin) ->
	board.pinMode pin, true
#------------------------------------------------------------------------------------------