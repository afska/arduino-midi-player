include "utils/arrayUtils"
module.exports = #---

#A monotrack 4/4 melody that
#can be played in a buzzer.
class Melody
	constructor: ->
		@notes = [
			{ note: "c4", duration: 1/8 }
			{ note: null, duration: 1/16 }
			{ note: "c4", duration: 1/16 }
			{ note: "d4", duration: 1/4 }
			{ note: "c4", duration: 1/4 }
			{ note: "f4", duration: 1/4 }
			{ note: "e4", duration: 1/4 }
			{ note: null, duration: 1/4 }
			{ note: "c4", duration: 1/8 }
			{ note: null, duration: 1/16 }
			{ note: "c4", duration: 1/16 }
			{ note: "d4", duration: 1/4 }
			{ note: "c4", duration: 1/4 }
			{ note: "g4", duration: 1/4 }
			{ note: "f4", duration: 1/4 }
			{ note: null, duration: 1/4 }
		]

		@beat = 1/4
		@tempo = 120 #bpm

		@beatDuration = #s -> ms
			(60 / @tempo) * 1000

	#play the song with a *player*.
	#a player is an object that understands
	# playNote(note, duration).
	playWith: (player) =>
		timeElapsed = 0

		@notes.forEach (noteInfo) =>
			duration = (noteInfo.duration / @beat) * @beatDuration
			playNote = => if noteInfo.note?
				player.playNote noteInfo.note, duration

			setTimeout playNote, timeElapsed
			timeElapsed += duration