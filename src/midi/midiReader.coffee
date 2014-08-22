fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "midi/converters/noteDictionary"
BeatConverter = include "midi/converters/beatConverter"
Melody = include "midi/melody"
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
		tempo = @tempo()
		converter = new BeatConverter tempo
		#for now, only 1 melody. todo: song

		#song = new Song()
		notes = @noteEventsIn 0
		notes = notes
			.map (event, i) =>
				note: @noteDictionary.noteNames()[event.param1]
				length: converter.toBeats @deltaEvents(event, notes[i + 1])

		new Melody tempo, notes

	events: => @file.getEvents()

	eventsIn: (track) =>
		@events().filter (event) =>
			event.channel is track and
			event.type is @eventTypes.types.note and
			event.subtype in [
				@eventTypes.subTypes.on
				@eventTypes.subTypes.off
			]

	noteEventsIn: (track) =>
		events = @eventsIn track

		convertRests = (events, next) =>
			current = events.last()
			if current.subtype is @eventTypes.subTypes.off
				current.subtype = @eventTypes.subTypes.on
				current.param1 = @noteDictionary.positionOf "r"

				if @deltaEvents(current, next) is 0
					events.pop()
			events.concat [next]

		events.reduce convertRests, [events.shift()]

	deltaEvents: (current, next) =>
		currentTime = current.playTime
		if !next? then return currentTime
		next.playTime - currentTime

	tempo: => @events().findProperty "tempoBPM"

	totalTracks: => @file.tracks.length
#------------------------------------------------------------------------------------------