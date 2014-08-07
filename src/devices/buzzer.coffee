Timer = require "nanotimer"
board = include "board"
module.exports = #---

class Buzzer
	constructor: (@pin) ->
		@value = LOW
		board.setPinAsOutput @pin

		@play 1136, 1000

	play: (timeHigh, duration) =>
		new Timer()


		timer.setInterval ->

	on: => @_update HIGH

	off: => @_update LOW

	toggle: =>
		@value = if @value then LOW else HIGH
		@_update @value

	blink: (interval) =>
		setInterval @toggle, interval

	_update: (newValue) =>
		board.digitalWrite @pin, @value = newValue