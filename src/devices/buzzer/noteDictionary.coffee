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
		[0..8]
			.map (octave) =>
				[
					"c", "c#", "d"
					"d#", "e", "f"
					"f#", "g", "g#"
					"a", "a#", "b"
				].map (note) => "#{note}#{octave}"
			.flatten()

	#frequency of a *note*.
	# 440 * (2^(1/12))^semitonesFromA4
	frequencyOf: (note) =>
		twelthRootOf2 = Math.pow 2, 1/12
		a4 = 440

		positionOf = (note) => @noteNames().indexOf note
		distanceToA4 = positionOf(note) - positionOf("a4")
		a4 * Math.pow twelthRootOf2, distanceToA4

	#time high of a wave in a *note*.
	# ((1 / (2 * frequency))
	# * 1000000 [s -> ns]
	timeHighOf: (note) =>
		1000000 / (2 * @frequencyOf note)