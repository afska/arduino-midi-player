require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"
board = include "board"
module.exports = #---

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	led = new Led(13)
	led.blink 200

	buzz = new Buzzer(12)

	new Melody().playWith buzz

	setTimeout (() -> led.stopBlink()), 1000