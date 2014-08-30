require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "music/melody"
MidiReader = include "music/midi/midiReader"

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
		@_playInBuzzer new Melody([
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
		], 120), 3

	playMidi: =>
		pin = 3
		new MidiReader("/home/rodri/Desktop/asa.mid") #todo: deshardcodear
			.toSong()
			.forEachMelody (melody) =>
				@_playInBuzzer melody, pin++

	_playInBuzzer: (melody, pin) =>
		buzzer = new Buzzer pin

		melody.events
			.on "start", -> console.log "start!"

		melody.events.on "note", (noteInfo) ->
			console.log "[buzzer #{pin}] playing a #{noteInfo.note} for #{noteInfo.duration} ms"

		melody.events
			.on "end", -> console.log "end!"

		melody.playWith buzzer

board.on "ready", -> new Example()
#------------------------------------------------------------------------------------------