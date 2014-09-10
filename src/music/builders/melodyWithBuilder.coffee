Melody = include "music/melody"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *melodies*.
class MelodyWithBuilder extends Melody
	constructor: -> super []

	#duration of the melody in ms, without a final rest.
	trimmedDuration: => @_duration() - @_excess()

	#fix the time of the melody to *duration* ms.
	fixTo: (duration) =>
		if @_excess() > 0 then @notes.pop()

		getDelta = => duration - @trimmedDuration()
		if getDelta() > 0 then @_enlargeTo getDelta
		else @_cutTo getDelta

	#add silences until the melody is *duration* ms long.
	_enlargeTo: (getDelta) =>
		@add note: "r", duration: getDelta()

	#cut notes until the melody is *duration* ms long.
	_cutTo: (getDelta) =>
		while (delta = getDelta()) < 0
			last = @notes.last()
			last.duration += delta
			if last.duration <= 0 then @notes.pop()

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