extends SpaceObj

var lifespan: float = 10.0

const HEAL: float = 2.0


func _init() -> void:
	if randf() > 0.5:
		get('texture').region = Rect2(80.0, 0.0, 16.0, 16.0)


func _process(delta: float) -> void:
	lifespan -= delta
	if lifespan < 0:
		queue_free()
	self_modulate.a = lifespan
