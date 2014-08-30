Melody = include "music/melody"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *melodies*.
class MelodyBuilder extends Melody
	constructor: -> super []

	#duration of the melody in ms, without a final rest.
	trimmedDuration: => @_duration() - @_excess()

	#fill the melody with rests until it's *duration* ms long.
	enlargeTo: (duration) =>
		delta = duration - @trimmedDuration()

		if @_excess() > 0 then @notes.pop()
		if delta > 0
			@add note: "r", duration: delta

	#the last note.
	_lastNote: => @notes.last()

	#duration of the melody in ms.
	_duration: =>
		@notes.sum (noteInfo) => noteInfo.duration

	#excess of duration (if the last note is a rest).
	_excess: =>
		last = @_lastNote()
		if last?.isRest() then last.duration else 0
#------------------------------------------------------------------------------------------