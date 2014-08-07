DigitalDevice = include "devices/digitalDevice"
board = include "board"
module.exports = #---

#a simple led.
class Led extends DigitalDevice
	#make the led to blink every *interval* ms.
	blink: (interval) =>
		@blinking = setInterval @toggle, interval

	#stop blinking the led.
	stopBlink: =>
		if @blinking?
			clearInterval @blinking
			delete @blinking