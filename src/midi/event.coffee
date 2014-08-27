extend = require "extend"
noteDictionary = include "midi/converters/noteDictionary"
module.exports =

#------------------------------------------------------------------------------------------
#A MIDI event.
class Event
	@Types:
		note: 8
		subTypes:
			on: 9, off: 8

	constructor: (json) ->
		extend true, @, json

	#if it's a note event.
	isNote: =>
		@type is Event.Types.note and
		(@isNoteOn() or @isNoteOff())

	#if it's a note on event.
	isNoteOn: =>
		@subtype is Event.Types.subTypes.on

	#if it's a note off event.
	isNoteOff: =>
		@subtype is Event.Types.subTypes.off

	#name of the note.
	note: => noteDictionary.noteNames()[@param1]

	#convert the event to a "note on" event with a rest.
	convertToRest: =>
		@subtype = Event.Types.subTypes.on
		@param1 = noteDictionary.positionOf "r"

	#delta time (in ms) with another next event.
	deltaWith: (next) =>
		if !next? then return 0
		next.playTime - @playTime

	#duration of the note based on the *nextEvents*.
	durationIn: (nextEvents) =>
		next = nextEvents
			.find (it) => @deltaWith(it) isnt 0

		@deltaWith next
#------------------------------------------------------------------------------------------