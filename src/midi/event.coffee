extend = require "extend"
noteDictionary = include "midi/converters/noteDictionary"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI event
class Event
	@Types:
		note: 8
		subTypes:
			on: 9, off: 8

	constructor: (json) ->
		extend true, @, json

	isNote: =>
		@type is Event.Types.note and
		(@isNoteOn() or @isNoteOff())

	isNoteOn: =>
		@subtype is Event.Types.subTypes.on

	isNoteOff: =>
		@subtype is Event.Types.subTypes.off

	note: => noteDictionary.noteNames()[@param1]

	convertToRest: =>
		@subtype = Event.Types.subTypes.on
		@param1 = noteDictionary.positionOf "r"

	deltaWith: (next) =>
		if !next? then return 0
		next.playTime - @playTime
#------------------------------------------------------------------------------------------