class_name Bullet
extends Node2D

# todo: separate 'projectile' class ?

var initial_velocity: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# specifies velocity vector length that should be accelerated
var speeding_up_threshold: float = 0.0
var speeding_up_speed: float = 100.0

# time in seconds
var lifespan: float = 1.0

export var size_effect_on_bullet_size: Curve


func _init_projectile(base, weapon) -> void:
	var spreaded: float = base.rotation + deg2rad((randf()-0.5)*2 * weapon.spread)
	position = base.position
	rotation = spreaded
	initial_velocity = base.spatial_velocity
	velocity = Vector2.UP.rotated(spreaded) * weapon.starting_velocity
	lifespan = weapon.bullet_lifespan

	scale *= size_effect_on_bullet_size.interpolate(base.size)

	if weapon.damage_mask & weapon.DAMAGE_PLAYERS:
		$Backlight.self_modulate = weapon.DAMAGE_PLAYERS_COLOR
	if weapon.damage_mask & weapon.DAMAGE_ENEMIES:
		$Backlight.self_modulate = weapon.DAMAGE_ENEMIES_COLOR	


func _process(delta: float) -> void:
	if (velocity + initial_velocity).distance_to(Vector2.ZERO) < speeding_up_threshold:
		velocity += velocity.normalized() * speeding_up_speed * delta
	position += (velocity + initial_velocity) * delta
	lifespan -= delta
	if lifespan <= 0.0:
		queue_free()
	modulate.a = clamp(lifespan, 0.6, 1.0)
