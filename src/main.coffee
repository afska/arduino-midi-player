require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Song = include "devices/buzzer/song"
board = include "board"
module.exports = #---

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	new Led(13).blink 200

	buzz = new Buzzer(12)

	new Song().playWith buzz