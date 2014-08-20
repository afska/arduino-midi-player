board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
#A device that can receive as output a 16 bits value.
class VirtualDevice
	constructor: (@logicPort) ->
		board.setPinAsOutput @logicPort

	#send values to the device.
	send: (values) =>
		values.forEach (value) =>
			board.analogWrite @logicPort, value
#------------------------------------------------------------------------------------------