require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"
fs = require "fs"
MIDIFile = require "midifile"
board = include "board"
module.exports = #---

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	new Led(13).blink 200

	buzz = new Buzzer(12)
	new Melody().playWith buzz

	buffer = fs.readFileSync "test.mid"

	toArrayBuffer = (buffer) ->
		ab = new ArrayBuffer buffer.length
		view = new Uint8Array ab

		for i in [0..buffer.length]
			view[i] = buffer[i]

		ab

	midiFile = new MIDIFile toArrayBuffer(buffer)

	#Headers
	console.log "format: #{midiFile.header.getFormat()}"
	console.log "tracks: #{midiFile.header.getTracksCount()}"

	midiFile.getTrackEvents 0 #eventos del midi a reproducir