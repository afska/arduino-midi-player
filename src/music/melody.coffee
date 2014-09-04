NoteInfo = include "music/noteInfo"
EventEmitter = require("events").EventEmitter
q = require "q"
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
	constructor: (notes, @tempo) ->
		@notes = []
		@events = new EventEmitter()
		notes.map(@_lengthToMs).forEach @add

	#play the melody with a *player*.
	#a player is an object that understands:
	# playNote(noteInfo)
	playWith: (player) =>
		@_start()

		playAllNotes = (previousPromise, noteInfo) =>
			previousPromise.then =>
				@events.emit "note", noteInfo
				player.playNote noteInfo

		seed = q.defer() ; seed.resolve()
		@notes
			.reduce(playAllNotes, seed.promise)
			.then @_end

		@events

	#add a *noteInfo*.
	add: (noteInfo) => @notes.push new NoteInfo(noteInfo)

	#calculate the duration of a *noteInfo* in ms.
	_lengthToMs: (noteInfo) =>
		noteInfo.duration = new BeatConverter(@tempo).toMs json.length
		noteInfo

	#emit the event for the start.
	_start: => @events.emit "start"

	#emit the event for the end.
	_end: => @events.emit "end"
#------------------------------------------------------------------------------------------