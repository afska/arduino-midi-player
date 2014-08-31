module.exports =

#------------------------------------------------------------------------------------------
#A converter between beats and milliseconds.
class BeatConverter
	@Beat: 1/4 #length of a beat.
	constructor: (@tempo) ->

	#to milliseconds.
	toMs: (beats) =>
		(beats / BeatConverter.Beat) * @_beatDuration()

	#to beats.
	toBeats: (ms) =>
		ms * BeatConverter.Beat / @_beatDuration()

	#duration of a beat in milliseconds.
	_beatDuration: => (60 / @tempo) * 1000
#------------------------------------------------------------------------------------------