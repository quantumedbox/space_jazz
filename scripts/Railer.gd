extends Weapon

func _ready() -> void:
	impulse = 50.0
	attack_speed = 0.5

#func fire():
#	var base: Node2D = get_parent()
#	var bullet = self._bulletScene.instance()
#	bullet.position = base.position
#	bullet.rotation = rotation
#	bullet.initial_velocity = base.spatial_velocity
#	bullet.velocity = Vector2.UP.rotated(rotation) * starting_velocity
#	bullet.lifespan = bullet_lifespan
#	base.spatial_velocity -= Vector2.UP.rotated(base.rotation) * impulse
#	GameScope.add_child(bullet)
#
#	if damage_mask & DAMAGE_PLAYERS:
#		bullet.get_node('Backlight').self_modulate = DAMAGE_PLAYERS_COLOR
