board = include "board"
module.exports = #---

class Led
	constructor: (@pin) ->
		@isOn = false
		board.setPinAsOutput @pin

	on: => @_update true

	off: => @_update false

	toggle: => @_update !@isOn

	blink: (interval) =>
		setInterval @toggle, interval

	_update: (isOn) =>
		board.digitalWrite @pin, @isOn = isOn