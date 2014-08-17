require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"

fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "devices/buzzer/noteDictionary"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
blinkTheLed = -> new Led(13).blink 200

playHappyBirthday = ->
	buzz = new Buzzer 3

	happyBirthday = new Melody [
		{ note: "c5", length: 1/8 }
		{ note: null, length: 1/16 }
		{ note: "c5", length: 1/16 }
		{ note: "d5", length: 1/4 }
		{ note: "c5", length: 1/4 }
		{ note: "f5", length: 1/4 }
		{ note: "e5", length: 1/4 }
		{ note: null, length: 1/4 }
		{ note: "c5", length: 1/8 }
		{ note: null, length: 1/16 }
		{ note: "c5", length: 1/16 }
		{ note: "d5", length: 1/4 }
		{ note: "c5", length: 1/4 }
		{ note: "g5", length: 1/4 }
		{ note: "f5", length: 1/4 }
		{ note: null, length: 1/4 }
	], 120

	happyBirthday.events
		.on "start", -> console.log "start!"

	happyBirthday.events.on "note", (noteInfo) ->
		console.log "i'm playing a #{noteInfo.note} of #{noteInfo.length}"

	happyBirthday.events
		.on "end", -> console.log "end!"

	happyBirthday.playWith buzz

openMidi = ->
	#esto está recontra cabeza, pero son pruebas ^.^

	buffer = fs.readFileSync "/home/rodri/Desktop/asa.mid"

	toArrayBuffer = (buffer) ->
		ab = new ArrayBuffer buffer.length
		view = new Uint8Array ab

		for i in [0..buffer.length]
			view[i] = buffer[i]

		ab

	midiFile = new MIDIFile toArrayBuffer(buffer)

	#tempo = midiFile.getEvents()
	#	.find (event) -> event.channel is 0 and event.tempoBPM?
	tempo = 107
	#60s----------160
	#0.001 -------- x

	notes = midiFile.getEvents()
		.filter((event) -> event.channel is 0)
		.filter((event) -> event.type is 8 and event.subtype is 9);

	beatDuration = #s -> ms
		(60 / tempo) * 1000

	dict = new NoteDictionary()
	notes = notes
		.map (event, i) ->
			duration =
				if notes[i+1]?
					(notes[i+1].playTime - event.playTime) / (beatDuration * 4)
				else
					event.playTime / beatDuration

			{ note: dict.noteNames()[event.param1], length: duration }

	buzz = new Buzzer 3
	midiMelody = new Melody notes, tempo

	midiMelody.events
		.on "start", -> console.log "start!"

	midiMelody.events.on "note", (noteInfo) ->
		console.log "i'm playing a #{noteInfo.note} of #{noteInfo.length}"

	midiMelody.events
		.on "end", -> console.log "end!"

	midiMelody.playWith buzz

	#Headers
	#console.log "format: #{midiFile.header.getFormat()}"
	#console.log "tracks: #{midiFile.header.getTracksCount()}"

	midiFile.getTrackEvents 0 #eventos del midi a reproducir

board.on "ready", ->
	console.log "Hello f*ckin' world :D"; debugger

	blinkTheLed()
	#playHappyBirthday()
	openMidi()
#------------------------------------------------------------------------------------------
