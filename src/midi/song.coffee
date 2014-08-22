include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A 4/4 song, composed by many *melodies* sounding together.
class Song
	constructor: (@melodies) ->
		@melodies = @melodies || []

	#add a *melody*.
	add: (melody) => @melodies.add melody

	#play the track with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) =>
#------------------------------------------------------------------------------------------