Song = include "music/song"
MelodyWithBuilder = include "music/builders/melodyWithBuilder"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *songs*.
class SongWithBuilder extends Song
	constructor: -> super []
	
	#add a empty melody.
	add: =>
		melody = new MelodyWithBuilder @tempo, []
		@melodies.push melody
		melody

	#get a melody for a specific note.
	#the *allocator* is the algorithm for selecting melodies.
	#the *request* is composed by a time and a note.
	getMelodyFor: (allocator, request) =>
		melody = allocator.alloc(@, request) || @add()

		melody.fixTo request.time
		melody

	#remove the melodies that are composed only by silences.
	#returns the song.
	clean: =>
		@melodies = @melodies.filter (melody) =>
			melody.notes.some (noteInfo) => !noteInfo.isRest()
		@
#------------------------------------------------------------------------------------------