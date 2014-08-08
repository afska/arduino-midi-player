DigitalDevice = include "devices/digitalDevice"
NoteDictionary = include "devices/buzzer/noteDictionary"
Timer = require "nanotimer"
board = include "board"
module.exports = #---

#A piezo that can play sounds by
#clicking at the right frequency.
class Buzzer extends DigitalDevice
	constructor: (pin) ->
		super pin
		@notes = new NoteDictionary().notes

	#play a note (e.g. a#4) for *duration* ns.
	playNote: (note, duration) =>
		high = @notes
			.find((noteInfo) => noteInfo.note == note)
			.timeHigh

		@_playTone high, duration

	#play a tone creating a wave with *high* ns
	#of time high, with *duration* ms long.
	_playTone: (high, duration) =>
		timer = new Timer()
		timer.elapsedTime = => #ns -> ms
			timer.difTime / 1000000

		makeWave = =>
			@toggle()

			if timer.elapsedTime() >= duration
				@off()
				timer.clearInterval()

		timer.setInterval makeWave, null, "#{high}u", =>