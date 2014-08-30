include "utils/arrayUtils"
module.exports = new #singleton

#------------------------------------------------------------------------------------------
#A dictionary for finding all the playable notes with each frequency.
#"c#5" is c sharp at the 5th octave, "r" is a rest.
class NoteDictionary
	constructor: ->
		@notes =
			@noteNames().map (note) =>
				note: note
				frequency: @_frequencyOf note
				highTime: @_highTimeOf note


	#all available note names.
	noteNames: =>
		names = [0 .. 10]
			.map (octave) =>
				[
					"c", "c#", "d"
					"d#", "e", "f"
					"f#", "g", "g#"
					"a", "a#", "b"
				].map (note) => "#{note}#{octave}"
			.flatten()
			.concat "r"

	#get all the info of a note.
	get: (note) =>
		@notes.find (noteInfo) => noteInfo.note is note

	#position of a *note* in the notes array.
	# e.g. "d#0" is 3
	positionOf: (note) => @noteNames().indexOf note

	#frequency of a *note*.
	# 440 * (2^(1/12))^semitonesFromA4
	_frequencyOf: (note) =>
		if note is "r" then return 0

		twelthRootOf2 = Math.pow 2, 1/12
		a4 = 440

		distanceToA4 = @positionOf(note) - @positionOf("a4")
		a4 * Math.pow twelthRootOf2, distanceToA4

	#high time of a wave in a *note*: one half
	#of the period is HIGH, the other one is LOW.
	# (period / 2) * 1000000 [s -> us]
	_highTimeOf: (note) =>
		period = 1 / @_frequencyOf note
		(period / 2) * 1000000
#------------------------------------------------------------------------------------------