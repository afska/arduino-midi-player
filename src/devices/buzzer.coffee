VirtualDevice = include "devices/core/virtualDevice"
noteDictionary = include "music/converters/noteDictionary"
NanoTimer = require "nanotimer"
q = require "q"
board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
#A piezo that can play sounds by clicking at the right frequency.
class Buzzer extends VirtualDevice
	@LogicPort: 3 #pin for sending notes.
	@MaxNote: "b4" #max note of the normal speakers.

	constructor: (@pin) ->
		super Buzzer.LogicPort

	#play a *note* (e.g. "a#4") for *duration* ms.
	playNote: (noteInfo) =>
		high = noteDictionary.get(noteInfo.note).highTime
		@_playTone high, noteInfo.duration

	#play a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	_playTone: (high, duration) =>
		if @timer then @timer.clearInterval()

		high = Math.round high
		@send [@pin, high]

		deferred = q.defer()
		stop = => @send [@pin, 0] ; deferred.resolve()
		@timer = new NanoTimer()
			.setTimeout stop, "", "#{duration}m"
		deferred.promise
#------------------------------------------------------------------------------------------