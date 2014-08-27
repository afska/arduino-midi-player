NoteDictionary = include "midi/converters/noteDictionary"
extend = require "extend"
include "utils/arrayUtils"
include "utils/bufferUtils"
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
		@noteDictionary = new NoteDictionary()

	isNote: =>
		@type is Event.Types.note and
		(@isNoteOn() or @isNoteOff())

	isNoteOn: =>
		@subtype is Event.Types.subTypes.on

	isNoteOff: =>
		@subtype is Event.Types.subTypes.off

	note: => @noteDictionary.noteNames()[@param1]

	convertToRest: =>
		@subtype = Event.Types.subTypes.on
		@param1 = @noteDictionary.positionOf "r"

	deltaWith: (next) =>
		if !next? then return 0
		next.playTime - @playTime
#------------------------------------------------------------------------------------------