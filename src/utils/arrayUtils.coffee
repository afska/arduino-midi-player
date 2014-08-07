_ = require "lodash"

[
	"compact"
	"difference"
	"findIndex"
	"findLastIndex"
	"first"
	"flatten"
	"initial"
	"intersection"
	"last"
	"lastIndexOf"
	"pull"
	"range"
	"remove"
	"rest"
	"sortedIndex"
	"union"
	"uniq"
	"without"
	"xor"
	"zip"
	"zipObject"
].forEach (functionName) ->
	Array::[functionName] = ->
		args = Array::slice.call arguments
		_[functionName].apply @, [@].concat args