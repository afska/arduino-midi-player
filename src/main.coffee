require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
board = include "board"
module.exports = #---

board.on "ready", ->
	console.log "Hello f*ckin' world :D"

	new Led(13).blink 200

	buzz = new Buzzer(12)
	buzz.playNote "c4", 1000
	setTimeout (() => buzz.playNote("d4", 1000)), 1000
	setTimeout (() => buzz.playNote("e4", 1000)), 2000
	setTimeout (() => buzz.playNote("f4", 1000)), 3000
	setTimeout (() => buzz.playNote("g4", 1000)), 4000
	setTimeout (() => buzz.playNote("a4", 1000)), 5000
	setTimeout (() => buzz.playNote("b4", 1000)), 6000
	setTimeout (() => buzz.playNote("c5", 1000)), 7000