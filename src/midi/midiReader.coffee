fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "midi/noteDictionary"
Melody = include "devices/buzzer/melody"
include "utils/arrayUtils"
include "utils/bufferUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *song*s by parsing the file
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

		#notes = @eventsIn(0) #for now, only 1 melody. todo: song
			#.filter (event) -> event.type is 8 and (event.subtype is 8 or event.subtype is 9)
		debugger
		notes = @noteEventsIn 0

		beatDuration = #s -> ms
			(60 / tempo) * 1000

		notes = notes
			.map (event, i) =>
				duration =
					if notes[i+1]?
						(notes[i+1].playTime - event.playTime) / (beatDuration * 4)
					else
						event.playTime / beatDuration

				note: @noteDictionary.noteNames()[event.param1]
				length: duration

		new Melody notes, tempo

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

		events = events
			.map (event, i) =>
				if event.subtype is @eventTypes.subTypes.off
					event.subtype = @eventTypes.subTypes.on
					event.param1 = @noteDictionary.positionOf "r"

					if @deltaEvents(event, events[i + 1]) is 0
						event = null

				event
		events.filter (event) => event?

	deltaEvents: (current, next) =>
		currentTime = current.playTime
		if !next? then return currentTime
		next.playTime - currentTime

	tempo: => @events().findProperty "tempoBPM"

	totalTracks: => @file.tracks.length
#------------------------------------------------------------------------------------------