extends Node2D
class_name SpaceObj

enum Type {
	ANY 	= 0b001,
	PLAYER 	= 0b011,
	ENEMY 	= 0b101,
}

export(Type) var type = Type.ANY

# constant change of angle
var angular_velocity: float = 0.0
var max_velocity: float = 500.0
var spatial_velocity: Vector2 = Vector2(0, 0)

var deacceleration: float = 0.08


func _process(delta: float) -> void:
	position += spatial_velocity * delta
	spatial_velocity -= (spatial_velocity *
		clamp((spatial_velocity / deacceleration).length(), 0.0, 1.0)
		* deacceleration * delta)
	rotation += angular_velocity * delta


func collide_with(obj: Object) -> void:
	pass
