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
				time: event.playTime
				note: event.note()

			melody = song.getMelodyFor melodyAllocator, request
			melody.add
				note: request.note, duration: event.duration

		song.clean()

	#all events of all tracks processed.
	allEvents: =>
		[0 ... @file.totalTracks()]
			.map(@processTrack)
			.flatten()
			.sortBy "playTime"

	#apply some transformations to the track events.
	processTrack: (track) =>
		process = (result, func) => func result
		notes = @file.noteEventsIn(track).cloneDeep()
		[@_addDurations, @_removeNoteOffs].reduce process, notes

	#add to each event its duration.
	_addDurations: (events) =>
		events.map (event, i) =>
			event.duration = event.durationIn events.slice(i)
			event

	#remove all the "note off" events.
	_removeNoteOffs: (events) =>
		events.filter (event) => event.isNoteOn()
#------------------------------------------------------------------------------------------