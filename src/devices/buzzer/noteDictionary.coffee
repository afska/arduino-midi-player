include "utils/arrayUtils"
module.exports = #---

#A dictionary for finding all the
#playable notes with each frequency. 
class NoteDictionary
	constructor: ->
		@notes = 
			@noteNames().map (note) =>
				note: note
				frequency: @frequencyOf note
				timeHigh: @timeHighOf note

	#all available note names.
	noteNames: =>
		[0..10]
			.map (octave) =>
				[
					"c", "c#", "d"
					"d#", "e", "f"
					"f#", "g", "g#"
					"a", "a#", "b"
				].map (note) => "#{note}#{octave}"
			.flatten()

	#position of a *note* in the notes array.
	# e.g. d#0 is 3
	positionOf: (note) =>
		@noteNames().indexOf note

	#frequency of a *note*.
	# 440 * (2^(1/12))^semitonesFromA4
	frequencyOf: (note) =>
		twelthRootOf2 = Math.pow 2, 1/12
		a4 = 440

		distanceToA4 = @positionOf(note) - @positionOf("a4")
		a4 * Math.pow twelthRootOf2, distanceToA4

	#time high of a wave in a *note*: one half
	#of the period is HIGH, the other one is LOW.
	# (period / 2) * 1000000 [s -> ns]
	timeHighOf: (note) =>
		period = 1 / @frequencyOf note
		(period / 2) * 1000000