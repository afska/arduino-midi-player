VirtualDevice = include "devices/core/virtualDevice"
noteDictionary = include "music/converters/noteDictionary"
q = require "q"
board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
#A piezo that can play sounds by clicking at the right frequency.
class Buzzer extends VirtualDevice
	@LogicPort: 3 #pin for sending notes

	constructor: (@pin) ->
		super Buzzer.LogicPort

	#play a *note* (e.g. "a#4") for *duration* ms.
	playNote: (note, duration) =>
		high = noteDictionary.get(note).highTime
		@_playTone high, duration

	#play a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	_playTone: (high, duration) =>
		high = Math.round high
		@send [@pin, high]

		deferred = q.defer()
		stop = =>
			@send [@pin, 0]
			deferred.resolve()

		setTimeout stop, duration
		deferred.promise
#------------------------------------------------------------------------------------------