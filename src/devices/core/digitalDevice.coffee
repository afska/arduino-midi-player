board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
#A device that can be pulsed with current (on) or not (off).
class DigitalDevice
	constructor: (@pin) ->
		@isOn = false
		board.setPinAsOutput @pin

	#turn on the device.
	on: => @_update true

	#turn off the device.
	off: => @_update false

	#turn on/off the device.
	toggle: => @_update not @isOn

	#turn the device to *isOn*.
	_update: (isOn) =>
		board.digitalWrite @pin, @isOn = isOn
#------------------------------------------------------------------------------------------