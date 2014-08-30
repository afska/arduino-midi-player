Song = include "music/song"
MelodyBuilder = include "music/builders/melodyBuilder"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *songs*.
class SongBuilder extends Song
	constructor: -> super []
	
	#add a empty melody.
	add: =>
		melody = new MelodyBuilder @tempo, []
		@melodies.push melody
		melody

	#get the first *melody* that its ending time is older than the current *time*.
	#if it doesn't exist, it will be created.
	getIddleMelody: (time) =>
		melody = @melodies.find((melody) =>
			melody.trimmedDuration() <= time
		) || @add time

		melody.enlargeTo time
		melody

	#remove the melodies that are composed only by silences.
	clean: =>
		@melodies = @melodies.filter (melody) =>
			melody.notes.some (noteInfo) => !noteInfo.isRest()
#------------------------------------------------------------------------------------------