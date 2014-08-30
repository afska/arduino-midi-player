extend = require "extend"
module.exports =

#------------------------------------------------------------------------------------------
#Information of a note (note, length, duration).
class Note
	constructor: (json) ->
		extend true, @, json
		@duration = Math.round @duration

	isRest: => @note is "r"
#------------------------------------------------------------------------------------------