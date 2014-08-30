module.exports =

#------------------------------------------------------------------------------------------
#A 4/4 song, composed by many *melodies* sounding together.
class Song
	constructor: (@melodies) ->

	#invoke *fn* for each melody of the song.
	forEachMelody: (fn) => @melodies.forEach fn
#------------------------------------------------------------------------------------------