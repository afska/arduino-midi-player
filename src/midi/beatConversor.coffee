module.exports =

#------------------------------------------------------------------------------------------
#A conversor between beats and milliseconds.
class BeatConversor
	@Beat: 1/4
	constructor: (@tempo) ->

	#to milliseconds.
	toMs: (beats) =>
		(beats / @constructor.Beat) * @_beatDuration()

	#to beats.
	toBeats: (ms) =>
		ms * @constructor.Beat / @_beatDuration()

	#duration of a beat in milliseconds.
	_beatDuration: => (60 / @tempo) * 1000
#------------------------------------------------------------------------------------------