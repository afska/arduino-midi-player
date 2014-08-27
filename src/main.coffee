require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "midi/melody"
MidiReader = include "midi/midiReader"
NoteDictionary = include "midi/converters/noteDictionary"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
class Example
	constructor: ->
		console.log "Hello f*ckin' world :D"; debugger

		@blinkTheLed()
		#@playHappyBirthday()
		@playMidi()

	blinkTheLed: => new Led(13).blink 200

	playHappyBirthday: =>
		@_playInBuzzer new Melody(120, [
			{ note: "c4", length: 1/8 }
			{ note: "r", length: 1/16 }
			{ note: "c4", length: 1/16 }
			{ note: "d4", length: 1/4 }
			{ note: "c4", length: 1/4 }
			{ note: "f4", length: 1/4 }
			{ note: "e4", length: 1/4 }
			{ note: "r", length: 1/4 }
			{ note: "c4", length: 1/8 }
			{ note: "r", length: 1/16 }
			{ note: "c4", length: 1/16 }
			{ note: "d4", length: 1/4 }
			{ note: "c4", length: 1/4 }
			{ note: "g4", length: 1/4 }
			{ note: "f4", length: 1/4 }
		]), 3

	playMidi: =>
			#pin = 4
			melodies = new MidiReader("/home/rodri/Desktop/asa.mid").toMelody()
			#for m in melodies
			#	playInBuzzer m, pin
			#	pin++
			# ver cómo solucionar lo del let ring: la distancia no es 0 pero ponele

			@_playInBuzzer melodies[0], 3
			@_playInBuzzer melodies[1], 4
			@_playInBuzzer melodies[2], 5
			@_playInBuzzer melodies[3], 6

	_playInBuzzer: (melody, pin) =>
		buzzer = new Buzzer pin

		melody.events
			.on "start", -> console.log "start!"

		melody.events.on "note", (noteInfo) ->
			console.log "[buzzer #{pin}] playing a #{noteInfo.note} of #{noteInfo.length}"

		melody.events
			.on "end", -> console.log "end!"

		melody.playWith buzzer

board.on "ready", -> new Example()
#------------------------------------------------------------------------------------------