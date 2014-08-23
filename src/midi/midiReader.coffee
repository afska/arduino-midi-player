fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "midi/converters/noteDictionary"
BeatConverter = include "midi/converters/beatConverter"
Melody = include "midi/melody"
Song = include "midi/song"
include "utils/arrayUtils"
include "utils/bufferUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *song*s by parsing the file
#todo: finish, make docs
class MidiReader
	constructor: (filePath) ->
		buffer = fs
			.readFileSync(filePath)
			.toArrayBuffer()

		@eventTypes =
			types:
				note: 8
			subTypes:
				on: 9, off: 8
		@noteDictionary = new NoteDictionary()
		@file = new MIDIFile buffer
		
	toMelody: =>
		#monotempo for now.
		#monotrack for now, but 1 midi track can be N MidiReader's tracks.
		tempo = @tempo()
		converter = new BeatConverter tempo

		todas = []
		for track in [0 ... @totalTracks()]
			song = new Song tempo

			debugger
			notes = @noteEventsIn track
			notes.forEach (event, i) =>
				melody = song.getIddleMelody Math.round(event.playTime)
				
				getDuration = =>
					next = null
					for offset in [0 .. notes.length - 1 - i]
						if @deltaEvents(event, notes[i + offset]) isnt 0
							next = notes[i + offset]
							break
					@deltaEvents(event, next)

				melody.add
					note: @noteDictionary.noteNames()[event.param1]
					length: converter.toBeats getDuration()

			song.melodies
			todas = todas.concat song.melodies #el encapsulamiento es de puto

		todas

	events: => @file.getEvents()

	noteEvents: =>
		@events().filter (event) =>
			event.type is @eventTypes.types.note and
			event.subtype in [
				@eventTypes.subTypes.on
				@eventTypes.subTypes.off
			]

	noteEventsIn: (track) =>
		events = @noteEvents().filter (event) => event.track is track

		convertRests = (events, next) =>
			current = events.last()

			if current.subtype is @eventTypes.subTypes.off
				current.subtype = @eventTypes.subTypes.on
				current.param1 = @noteDictionary.positionOf "r"

				if @deltaEvents(current, next) is 0
					events.pop()

			events.concat [next]

		events
			.reduce(convertRests, [events.shift()])
			.withoutLast() #ojo con esto, necesita un silencio al final eh! nop.

	deltaEvents: (current, next) =>
		currentTime = current.playTime
		if !next? then return currentTime #la diferencia de tiempo con el último evento es el tiempo actual. BIEN LÓGICO (?)
		next.playTime - currentTime

	tempo: => @events().findProperty "tempoBPM"

	totalTracks: => @file.tracks.length
#------------------------------------------------------------------------------------------