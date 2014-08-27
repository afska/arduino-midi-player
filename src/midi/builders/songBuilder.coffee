Song = include "midi/song"
MelodyBuilder = include "midi/builders/melodyBuilder"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *songs*.
class SongBuilder extends Song
	constructor: (tempo) -> super [], tempo

	#add a empty melody.
	add: =>
		melody = new MelodyBuilder @tempo, []
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
#------------------------------------------------------------------------------------------