five = require "johnny-five"
board = include "board"
module.exports = #---

class Buzzer
	constructor: (@pin) ->
		@buzzer = new five.Piezo @pin
		board.repl.inject piezo: @buzzer

		@playA()

	playA: =>
		@buzzer.play
			song: [
				["C4", 1/8]
				[null, 1/16]
				["C4", 1/8]
				["D4", 1/4]
				["C4", 1/4]
				["F4", 1/4]
				["E4", 1/4]
				[null, 1/4]
				[null, 1]
			]
			tempo: 40
		@buzzer.off()