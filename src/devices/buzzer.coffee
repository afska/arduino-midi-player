Timer = require "nanotimer"
board = include "board"
module.exports = #---

class Buzzer
	constructor: (@pin) ->
		@isOn = false
		board.setPinAsOutput @pin

		@play 1136, 3000

	#plays a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	play: (high, duration) =>
		timer = new Timer()
		nsToMs = (ns) -> ns / 1000000

		makeWave = =>
			@toggle()

			if nsToMs(timer.difTime) > duration
				@off()
				timer.clearInterval()

		timer.setInterval makeWave, null, "#{high}u"

	on: => @_update true

	off: => @_update false

	toggle: => @_update !@isOn

	_update: (isOn) =>
		board.digitalWrite @pin, @isOn = isOn