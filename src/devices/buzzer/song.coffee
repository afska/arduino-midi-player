include "utils/arrayUtils"
module.exports = #---

#A monotrack 4/4 song, composed by many
#*melodies* that can be played in a buzzer.
class Song
	constructor: (@melodies) ->

	#play the song with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) =>
