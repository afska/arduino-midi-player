MidiFile = include "midi/midiFile"
SongBuilder = include "midi/builders/songBuilder"
BeatConverter = include "midi/converters/beatConverter"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *songs* by parsing the file
#todo: finish, make docs
class MidiReader
	constructor: (filePath) ->
		@file = new MidiFile filePath
		
	toMelody: =>
		#monotempo for now.
		#monotrack for now, but 1 midi track can be N MidiReader's tracks.
		tempo = @file.tempo()
		converter = new BeatConverter tempo

		todas = []
		for track in [0 ... @file.totalTracks()]
			song = new SongBuilder tempo

			debugger
			notes = @getNotesOf track
			notes.forEach (event, i) =>
				melody = song.getIddleMelody Math.round(event.playTime)
				
				getDuration = => #dónde va esto
					next = null
					for offset in [0 .. notes.length - 1 - i]
						if event.deltaWith(notes[i + offset]) isnt 0
							next = notes[i + offset]
							break
					event.deltaWith next

				melody.add
					note: event.note()
					length: converter.toBeats getDuration()

			song.melodies
			todas = todas.concat song.melodies #el encapsulamiento es de puto

		todas

	getNotesOf: (track) =>
		convertRests = (events, next) =>
			current = events.last()

			if current.isNoteOff()
				current.convertToRest()
				if current.deltaWith(next) is 0
					events.pop()

			events.concat [next]

		events = @file.noteEventsIn track
		events = events.reduce convertRests, [events.shift()]
		events.last().convertToRest() ; events
#------------------------------------------------------------------------------------------