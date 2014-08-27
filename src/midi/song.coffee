module.exports =

#------------------------------------------------------------------------------------------
#A 4/4 song, composed by many *melodies* sounding together.
class Song
	constructor: (@melodies, @tempo) ->

	#play the song with an array of *players*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (players) =>
		@melodies.forEach (melody, i) =>
			player = players[i]
			if player?
				melody.playWith player
#------------------------------------------------------------------------------------------