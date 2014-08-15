VirtualDevice = include "devices/core/virtualDevice"
NoteDictionary = include "devices/buzzer/noteDictionary"
Q = require "q"
board = include "board"
module.exports = #---

#A piezo that can play sounds by
#clicking at the right frequency.
class Buzzer extends VirtualDevice
	@LogicPort: 3 #pin for sending notes

	constructor: (@pin) ->
		super Buzzer.LogicPort
		@notes = new NoteDictionary().notes

	#play a *note* (e.g. "a#4") for *duration* ms.
	# (a null is a rest)
	playNote: (note, duration) =>
		if !note? then return @_playRest duration

		high = @notes
			.find((noteInfo) => noteInfo.note == note)
			.highTime

		@_playTone high, duration

	#play a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	_playTone: (high, duration) =>
		@send [@pin, high]

		deferred = Q.defer()
		stop = =>
			@send [@pin, 0]
			deferred.resolve()

		setTimeout stop, duration
		deferred.promise

	#play a rest of *duration* ms long.
	_playRest: (duration) =>
		deferred = Q.defer()
		setTimeout deferred.resolve, duration
		deferred.promise