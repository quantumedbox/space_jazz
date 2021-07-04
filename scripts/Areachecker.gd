extends Area2D


func _init() -> void:
	position = Vector2(10000000, 10000000)


func get_bodies(pos: Vector2, radius: float, mask: int) -> Array:
	position = pos
	collision_layer = mask
	$Collider.shape.radius = radius
	var bodies = get_overlapping_bodies()
#	position = Vector2(10000000, 10000000)
	return bodies
