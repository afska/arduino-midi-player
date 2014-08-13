EventEmitter = require("events").EventEmitter
include "utils/arrayUtils"
module.exports = #---

#A monotrack 4/4 melody that
#can be played in a buzzer.
#*notes* is, for example: [
#    { note: "c#5", length: 1/4 }
#    { note: null, length: 1/8 }
#]
#*tempo* is in bpm
class Melody
	constructor: (@notes, @tempo) ->
		@beat = 1/4
		@beatDuration = #s -> ms
			(60 / @tempo) * 1000

		@playing = false
		@events = new EventEmitter()

	#play the melody with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) =>
		if @playing then return

		@_start()
		elapsedTime = 0

		@notes.forEach (noteInfo) =>
			duration = (noteInfo.length / @beat) * @beatDuration
			playNote = =>
				@events.emit "note", noteInfo

				if noteInfo.note?
					player.playNote noteInfo.note, duration

			setTimeout playNote, elapsedTime
			elapsedTime += duration

		setTimeout @_end, elapsedTime
		@events

	#emit the events for the start.
	_start: =>
		@playing = true
		@events.emit "start"

	#emit the events for the end.
	_end: =>
		@playing = false
		@events.emit "end"