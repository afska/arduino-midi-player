EventEmitter = require("events").EventEmitter
Q = require "q"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A monophonic 4/4 melody that can be played in a *player*.
#*tempo* is in bpm
#*notes* is, for example: [
#    { note: "c#5", length: 1/4 }
#    { note: "r", length: 1/8 }
#]
class Melody
	constructor: (@notes, @tempo) ->
		@playing = false
		@events = new EventEmitter()

	#play the melody with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) =>
		if @playing then return
		@_start()

		playAllNotes = (previousPromise, noteInfo) =>
			previousPromise.then =>
				@events.emit "note", noteInfo
				player.playNote noteInfo.note, noteInfo.duration

		seed = Q.defer() ; seed.resolve()
		@notesWithDuration()
			.reduce(playAllNotes, seed.promise)
			.then @_end

		@events

	#emit the events for the start.
	_start: =>
		@playing = true
		@events.emit "start"

	#emit the events for the end.
	_end: =>
		@playing = false
		@events.emit "end"
#------------------------------------------------------------------------------------------