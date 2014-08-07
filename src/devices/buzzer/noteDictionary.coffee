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
	frequencyOf: (note) =>
		twelthRootOf2 = Math.pow 2, 1/12
		a4 = 440

		positionOf = (note) => @noteNames().indexOf note
		distanceToA4 = positionOf(note) - positionOf("a4")
		a4 * Math.pow twelthRootOf2, distanceToA4