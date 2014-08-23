require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "midi/melody"
MidiReader = include "midi/midiReader"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
blinkTheLed = -> new Led(13).blink 200

playInBuzzer = (melody, pin) ->
	buzzer = new Buzzer pin

	melody.events
		.on "start", -> console.log "start!"

	melody.events.on "note", (noteInfo) ->
		console.log "[buzzer #{pin}] playing a #{noteInfo.note} of #{noteInfo.length}"

	melody.events
		.on "end", -> console.log "end!"

	melody.playWith buzzer

playHappyBirthday = ->
	melo = new Melody 120, [
		{ note: "c8", length: 1/8 }
		{ note: "r", length: 1/16 }
		{ note: "c8", length: 1/16 }
		{ note: "d8", length: 1/4 }
		{ note: "c8", length: 1/4 }
		{ note: "f8", length: 1/4 }
		{ note: "e8", length: 1/4 }
		{ note: "r", length: 1/4 }
		{ note: "c8", length: 1/8 }
		{ note: "r", length: 1/16 }
		{ note: "c8", length: 1/16 }
		{ note: "d8", length: 1/4 }
		{ note: "c8", length: 1/4 }
		{ note: "g8", length: 1/4 }
		{ note: "f8", length: 1/4 }
	]

	playInBuzzer melo, 11

openMidi = ->
	#pin = 4
	melodies = new MidiReader("/home/rodri/Desktop/asa.mid").toMelody()
	#for m in melodies
	#	playInBuzzer m, pin
	#	pin++
	# ver cómo solucionar lo del let ring: la distancia no es 0 pero ponele

	#playInBuzzer melodies[2], 4
	#playInBuzzer melodies[3], 5
	#playInBuzzer melodies[5], 6
	#playInBuzzer melodies[7], 7

	playInBuzzer melodies[0], 11
	playInBuzzer melodies[1], 5
	playInBuzzer melodies[2], 6
	playInBuzzer melodies[3], 7

board.on "ready", ->
	console.log "Hello f*ckin' world :D"; debugger

	blinkTheLed()
	playHappyBirthday()
	#openMidi()
#------------------------------------------------------------------------------------------