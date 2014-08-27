fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "midi/converters/noteDictionary"
BeatConverter = include "midi/converters/beatConverter"
SongBuilder = include "midi/builders/songBuilder"
include "utils/arrayUtils"
include "utils/bufferUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *songs* by parsing the file
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
			song = new SongBuilder tempo

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
		events = @noteEvents()
		if @totalTracks() > 1
			events = events.filter (event) => event.track is track

		makeRest = (event) =>
			event.subtype = @eventTypes.subTypes.on
			event.param1 = @noteDictionary.positionOf "r"

		convertRests = (events, next) =>
			current = events.last()

			if current.subtype is @eventTypes.subTypes.off
				makeRest current
				if @deltaEvents(current, next) is 0
					events.pop()

			events.concat [next]

		converted = events.reduce convertRests, [events.shift()]
		makeRest converted.last()
		converted

	deltaEvents: (current, next) =>
		currentTime = current.playTime
		if !next? then return 0
		next.playTime - currentTime

	tempo: => @events().findProperty "tempoBPM"

	totalTracks: =>
		tracks = @file.tracks.length
		if tracks is 0 then 1 else tracks
#------------------------------------------------------------------------------------------