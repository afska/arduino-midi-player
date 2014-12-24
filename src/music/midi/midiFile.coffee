MIDIFile = require "midifile"
Event = include "music/midi/event"
fs = require "fs"
include "utils/arrayUtils"
include "utils/bufferUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A set of extension methods of the MIDIFile.
class MidiFile extends MIDIFile
	constructor: (filePath) ->
		buffer = fs
			.readFileSync filePath
			.toArrayBuffer()

		super buffer #supeeeeeeeeeer buffer!!!

		@events = @getEvents().map (json) => new Event json
	
	#note events in the file.
	noteEvents: =>
		@events.filter (event) => event.isNote()

	#note events in one *track*.
	noteEventsIn: (track) =>
		if @totalTracks() > 1
			@noteEvents().filter (event) => event.track is track
		else @noteEvents()

	#number of tracks.
	totalTracks: =>
		tracks = @tracks.length
		if tracks is 0 then 1 else tracks
#------------------------------------------------------------------------------------------