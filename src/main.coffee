require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"
fs = require "fs"
MIDIFile = require "midifile"
board = include "board"
module.exports = #---

blinkTheLed = -> new Led(13).blink 200

playHappyBirthday = ->
	buzz = new Buzzer 12
	happyBirthday = new Melody [
		{ note: "c4", duration: 1/8 }
		{ note: null, duration: 1/16 }
		{ note: "c4", duration: 1/16 }
		{ note: "d4", duration: 1/4 }
		{ note: "c4", duration: 1/4 }
		{ note: "f4", duration: 1/4 }
		{ note: "e4", duration: 1/4 }
		{ note: null, duration: 1/4 }
		{ note: "c4", duration: 1/8 }
		{ note: null, duration: 1/16 }
		{ note: "c4", duration: 1/16 }
		{ note: "d4", duration: 1/4 }
		{ note: "c4", duration: 1/4 }
		{ note: "g4", duration: 1/4 }
		{ note: "f4", duration: 1/4 }
		{ note: null, duration: 1/4 }
	], 120
	happyBirthday.playWith buzz

openMidi = ->
	buffer = fs.readFileSync "test.mid"

	toArrayBuffer = (buffer) ->
		ab = new ArrayBuffer buffer.length
		view = new Uint8Array ab

		for i in [0..buffer.length]
			view[i] = buffer[i]

		ab

	midiFile = new MIDIFile toArrayBuffer(buffer)

	#Headers
	#console.log "format: #{midiFile.header.getFormat()}"
	#console.log "tracks: #{midiFile.header.getTracksCount()}"

	midiFile.getTrackEvents 0 #eventos del midi a reproducir

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	blinkTheLed()
	playHappyBirthday()
	openMidi()