require "./utils/include"

Buzzer = include "devices/buzzer"
Melody = include "music/melody"
MidiReader = include "music/midi/midiReader"
HighChannel = include "music/builders/allocators/highChannel"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
class Example
	constructor: ->
		console.log "Hello f*ckin' world :D" ; debugger

		@playMidi
			filePath: process.argv[2]
			useFirstIdle: process.argv[3]

	playMidi: (opt) =>
		allocator = new HighChannel(Buzzer.MaxNote) if not opt.useFirstIdle

		pin = 3
		new MidiReader(opt.filePath)
			.toSong allocator
			.forEachMelody (melody) =>
				@_playInBuzzer melody, pin++

	_playInBuzzer: (melody, pin) =>
		buzzer = new Buzzer pin

		melody.events
			.on "start", -> console.log "start!"

		melody.events.on "note", (info) ->
			console.log "[buzzer #{pin}] playing a #{info.note} for #{info.duration} ms"

		melody.events
			.on "end", -> console.log "end!"

		melody.playWith buzzer

board.on "ready", -> new Example()
#------------------------------------------------------------------------------------------