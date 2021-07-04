class_name Bullet
extends SpaceObj

# todo: separate 'projectile' class ?

# time in seconds
var lifespan: float = 1.0

export var size_effect_on_bullet_size: Curve


func _init_projectile(base, weapon) -> void:
	var spreaded: float = base.rotation + deg2rad((randf()-0.5)*2 * weapon.spread)
	position = base.position
	rotation = spreaded
	spatial_velocity = (base.spatial_velocity +
		Vector2.UP.rotated(spreaded) * weapon.starting_velocity)
	lifespan = weapon.bullet_lifespan

	scale *= size_effect_on_bullet_size.interpolate(base.size)

	if weapon.damage_mask & weapon.DAMAGE_PLAYERS:
		$Backlight.self_modulate = weapon.DAMAGE_PLAYERS_COLOR
	if weapon.damage_mask & weapon.DAMAGE_ENEMIES:
		$Backlight.self_modulate = weapon.DAMAGE_ENEMIES_COLOR	


func _process(delta: float) -> void:
	._process(delta)
	lifespan -= delta
	if lifespan <= 0.0:
		queue_free()
	modulate.a = clamp(lifespan, 0.6, 1.0)
