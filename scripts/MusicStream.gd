extends AudioStreamPlayer

export(Array, AudioStreamMP3) var _tracks
var _current_track: int = -1


func _ready() -> void:
	_current_track = randi() % (len(_tracks) + 1)
	switch()
	if connect('finished', self, 'switch') != OK:
		push_error("cannot initialize music stream")
	for track in _tracks:
		track.loop = false


func switch(n: int = -1) -> void:
	if n == -1:
		n = _current_track + 1
		if n >= len(_tracks):
			n = 0
	stream = _tracks[n]
	_current_track = n
	play()
