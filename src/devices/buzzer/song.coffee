include "utils/arrayUtils"
module.exports = #---

#A monotrack 4/4 song that
#can be played in a buzzer.
class Song
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
		@tempo = 120

		@blackDuration = #s -> ms
			(60 / @tempo) * 1000
		console.log "una negra dura #{@blackDuration}"

	#play the song with a *player*.
	#a player is an object that understands
	# playNote(note, duration).
	playWith: (player) =>
		timeElapsed = 0

		@notes.forEach (noteInfo) =>
			# 1/4 ------------------- @blackDuration
			# noteInfo.duration ----- x

			duration = noteInfo.duration * @blackDuration / (1/4)
			playNote = => player.playNote noteInfo.note, duration
			if !noteInfo.note? then playNote = =>

			setTimeout playNote, timeElapsed
			timeElapsed += duration