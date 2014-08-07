require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
board = include "board"
module.exports = #---

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	new Led(13).blink 200

	new Buzzer(12)