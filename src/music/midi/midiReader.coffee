MidiFile = include "music/midi/midiFile"
SongWithBuilder = include "music/builders/songWithBuilder"
FirstIddle = include "music/builders/allocators/firstIddle"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI reader that generates *songs* by parsing the file.
class MidiReader
	constructor: (filePath) ->
		@file = new MidiFile filePath
		
	#convert the file to a *song*.
	toSong: (melodyAllocator = new FirstIddle()) =>
		song = new SongWithBuilder()
		@allEvents().forEach (event) =>
			request =
				time: Math.round event.playTime
				note: event.note()

			melody = song.getMelodyFor melodyAllocator, request
			melody.add
				note: request.note, duration: event.duration

		song

	#all events of all tracks processed.
	allEvents: =>
		[0 ... @file.totalTracks()]
			.map(@processTrack)
			.flatten()
			.sort((one, another) =>
				if one.playTime <= another.playTime then -1 else 1
			)

	#apply some transformations to the track events.
	processTrack: (track) =>
		process = (result, func) => func result
		notes = @file.noteEventsIn(track).cloneDeep()
		[@_addSilences, @_addDurations].reduce process, notes

	#convert all the "note off" events to silences.
	#the ones that have no duration will be removed.
	_addSilences: (events) =>
		convertSilences = (events, next) =>
			current = events.last()

			if current.isNoteOff()
				current.convertToRest()
				if current.deltaWith(next) is 0
					events.pop()

			events.concat [next]

		events = events.reduce convertSilences, [events.shift()]
		events.last().convertToRest() ; events

	#add to each event its duration.
	_addDurations: (events) =>
		events.map (event, i) =>
			event.duration = event.durationIn events.slice(i)
			event
#------------------------------------------------------------------------------------------