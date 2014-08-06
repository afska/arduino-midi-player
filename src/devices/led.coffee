board = include "board"
module.exports = #---

class Led
	constructor: (@pin) ->
		@value = LOW
		board.setPinAsOutput @pin

	on: => @_update HIGH

	off: => @_update LOW

	toggle: =>
		@value = if @value then LOW else HIGH
		@_update @value

	blink: (interval) =>
		setInterval @toggle, interval

	_update: (newValue) =>
		board.digitalWrite @pin, @value = newValue