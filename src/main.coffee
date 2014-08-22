require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"
MidiReader = include "midi/midiReader"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
blinkTheLed = -> new Led(13).blink 200

playInBuzzer = (melody) ->
	buzzer = new Buzzer 3

	melody.events
		.on "start", -> console.log "start!"

	melody.events.on "note", (noteInfo) ->
		console.log "i'm playing a #{noteInfo.note} of #{noteInfo.length}"

	melody.events
		.on "end", -> console.log "end!"

	melody.playWith buzzer

playHappyBirthday = ->
	playInBuzzer new Melody [
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

openMidi = ->
	playInBuzzer new MidiReader("/home/rodri/Desktop/asa.mid").toMelody()

board.on "ready", ->
	console.log "Hello f*ckin' world :D"; debugger

	blinkTheLed()
	#playHappyBirthday()
	openMidi()
#------------------------------------------------------------------------------------------