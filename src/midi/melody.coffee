BeatConverter = include "midi/converters/beatConverter"
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
	constructor: (@tempo, notes) ->
		@notes = notes || []

		@converter = new BeatConverter @tempo

		@playing = false
		@events = new EventEmitter()

	#todo: extraer estos métodos en un Builder...

	#add a *noteInfo*.
	add: (noteInfo) => @notes.push noteInfo

	#fill the melody with rests until it's *duration* ms long
	enlargeTo: (duration) =>
		delta = duration - @duration()
		if delta > 0
			@add note: "r", length: @converter.toBeats delta

	#append the duration in ms to the notes.
	notesWithDuration: =>
		@notes.map (noteInfo) =>
			noteInfo.duration = @converter.toMs noteInfo.length
			noteInfo

	#duration of the melody in ms.
	duration: =>
		@notesWithDuration().sum (noteInfo) => noteInfo.duration

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