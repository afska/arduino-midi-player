fs = require "fs"
MIDIFile = require "midifile"
Event = include "midi/event"
include "utils/arrayUtils"
include "utils/bufferUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A set of extension methods of the MIDIFile
class MidiFile extends MIDIFile
	constructor: (filePath) ->
		buffer = fs
			.readFileSync(filePath)
			.toArrayBuffer()

		super buffer #supeeeeeeeeeer buffer!!!

		@events = @getEvents().map (json) => new Event json
		
	noteEvents: =>
		@events.filter (event) => event.isNote()

	noteEventsIn: (track) =>
		events = @noteEvents()
		if @totalTracks() > 1
			events = events.filter (event) => event.track is track
		events

	tempo: => @events.findProperty "tempoBPM"

	totalTracks: =>
		tracks = @tracks.length
		if tracks is 0 then 1 else tracks
#------------------------------------------------------------------------------------------