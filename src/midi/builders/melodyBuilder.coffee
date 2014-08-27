Melody = include "midi/melody"
BeatConverter = include "midi/converters/beatConverter"
include "utils/arrayUtils"
module.exports =

#------------------------------------------------------------------------------------------
#A builder for quickly making *melodies*.
class MelodyBuilder extends Melody
	constructor: (tempo) ->
		super [], tempo
		@converter = new BeatConverter tempo

	#append the duration in ms to the notes.
	notesWithDuration: =>
		@notes.map (noteInfo) =>
			noteInfo.duration = @converter.toMs noteInfo.length
			noteInfo

	#duration of the melody in ms.
	duration: =>
		@notesWithDuration().sum (noteInfo) => noteInfo.duration

	#add a *noteInfo*.
	add: (noteInfo) => @notes.push noteInfo

	#fill the melody with rests until it's *duration* ms long
	enlargeTo: (duration) =>
		delta = duration - @duration()
		if delta > 0
			@add note: "r", length: @converter.toBeats delta
#------------------------------------------------------------------------------------------