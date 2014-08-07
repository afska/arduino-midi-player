DigitalDevice = include "devices/digitalDevice"
Timer = require "nanotimer"
board = include "board"
module.exports = #---

#A piezo that can play sounds by
#clicking at the right frequency.
class Buzzer extends DigitalDevice
	#play a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	playTone: (high, duration) =>
		timer = new Timer()
		timer.elapsedTime = ->
			#ns -> ms
			timer.difTime / 1000000

		makeWave = =>
			@toggle()

			if timer.elapsedTime() >= duration
				@off()
				timer.clearInterval()

		timer.setInterval makeWave, null, "#{high}u"