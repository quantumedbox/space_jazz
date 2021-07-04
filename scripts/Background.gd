extends Node

# current viewport size
var size: Vector2 = Vector2.ZERO

export var noise: NoiseTexture

func _ready() -> void:
	_compose()
	if get_tree().root.connect("size_changed", self, "_compose") != OK:
		push_error("Cannot connect 'size_changed signal to root'")
	for node in get_children():
		node.texture = noise

func _process(_delta: float) -> void:
	if not get_node('/root/Game').player_alive:
		return

	var pos = Player.position

	var quad_x_correction: float
	var quad_y_correction: float

	if pos.x > 0.0:
		quad_x_correction = size.x / 2
	else:
		quad_x_correction = -(size.x / 2)
	if pos.y > 0.0:
		quad_y_correction = size.y / 2
	else:
		quad_y_correction = -(size.y / 2)

	var quad_pos = Vector2(
		(int(pos.x + quad_x_correction) / int(size.x)) * size.x,
		(int(pos.y + quad_y_correction) / int(size.y)) * size.y
	)
	$Upperleft.position  = quad_pos + Vector2(-size.x, -size.y) / 2
	$Upperright.position = quad_pos + Vector2(+size.x, -size.y) / 2
	$Bottomleft.position = quad_pos + Vector2(-size.x, +size.y) / 2
	$Bottomright.position = quad_pos + Vector2(+size.x, +size.y) / 2

func _compose() -> void:
	size = (get_viewport().size + Vector2(128, 128)) * Player.get_node('Camera').zoom.x
	noise.width = int(size.x)
	noise.height = int(size.y)
