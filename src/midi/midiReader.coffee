MidiFile = include "midi/midiFile"
SongBuilder = include "midi/builders/songBuilder"
Song = include "midi/song"
BeatConverter = include "midi/converters/beatConverter"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *songs* by parsing the file.
class MidiReader
	constructor: (filePath) ->
		@file = new MidiFile filePath
		
	#convert the file to a *song*.
	toSong: =>
		tempo = @file.tempo()
		converter = new BeatConverter tempo

		addNotes = (melodies, track) =>
			song = new SongBuilder tempo
			events = @getNotesOf track

			events.forEach (event, i) =>
				melody = song.getIddleMelody Math.round(event.playTime)

				melody.add
					note: event.note()
					length: converter.toBeats event.durationIn(events.slice(i))
			
			melodies.concat song.melodies

		new Song [0 ... @file.totalTracks()].reduce(addNotes, []), tempo

	#convert all the "note off" events to rests.
	#the ones that have no duration will be removed.
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