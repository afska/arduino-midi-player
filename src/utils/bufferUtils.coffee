Buffer::toArrayBuffer = ->
	arrayBuffer = new ArrayBuffer @length
	view = new Uint8Array arrayBuffer

	for i in [0 .. @length]
		view[i] = @[i]

	arrayBuffer