Melody = include "midi/melody"
BeatConverter = include "midi/converters/beatConverter"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A 4/4 song, composed by many *melodies* sounding together.
class Song
	constructor: (@tempo, @melodies) ->
		@melodies = @melodies || []
		@converter = new BeatConverter @tempo #seguro no lo necesitemos...

	#add a empty melody.
	add: =>
		melody = new Melody @tempo, []
		@melodies.push melody
		melody

	#get the first *melody* that its ending time is older than the current *time*.
	#if it doesn't exist, it will be created.
	getIddleMelody: (time) =>
		melody = @melodies.find(
			(melody) => melody.duration() <= time
		) || @add time

		melody.enlargeTo time
		melody

	#play the track with a *player*.
	#a player is an object that understands:
	# playNote(note, duration)
	playWith: (player) => #todo
#------------------------------------------------------------------------------------------