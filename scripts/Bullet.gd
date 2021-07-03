class_name Bullet
extends Node2D

var initial_velocity: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# specifies velocity vector length that should be accelerated
var speeding_up_threshold: float = 0.0
var speeding_up_speed: float = 100.0

# time in seconds
var lifespan: float = 1.0


func _process(delta: float) -> void:
	if (velocity + initial_velocity).distance_to(Vector2.ZERO) < speeding_up_threshold:
		velocity += velocity.normalized() * speeding_up_speed * delta
	position += (velocity + initial_velocity) * delta
	lifespan -= delta
	if lifespan <= 0.0:
		queue_free()
	self_modulate.a = lifespan
