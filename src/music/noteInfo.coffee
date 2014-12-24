extend = require "extend"
module.exports =

#------------------------------------------------------------------------------------------
#Information of a note (note, length, duration).
class NoteInfo
	constructor: (json) ->
		extend true, @, json
		@duration = Math.round @duration

	isRest: => @note is "r"
#------------------------------------------------------------------------------------------