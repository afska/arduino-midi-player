include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A 4/4 track, composed by many *melodies* that can be played in a buzzer.
class Track
	constructor: (@melodies) ->

	#play the track with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) =>
#------------------------------------------------------------------------------------------