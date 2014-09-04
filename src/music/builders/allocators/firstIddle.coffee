include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#Algorithm that gets the first melody that its ending time is older than the current time.
class FirstIddle
	@Tolerance: 10 #tolerance for floating point errors.

	alloc: (song, request) =>
		song.melodies.find((melody) =>
			melody.trimmedDuration() - FirstIddle.Tolerance <= request.time
		)
#------------------------------------------------------------------------------------------