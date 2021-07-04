extends Line2D

# it's only visual for beam, in seconds
var lifespan: float = 1.0


func _init_projectile(base, weapon) -> void:
	points[0] = Vector2(base.position)
	points[1] = Vector2(base.position + Vector2.UP.rotated(base.rotation) * weapon.BEAM_LENGTH)
	width = weapon.BEAM_WIDTH - (weapon.BEAM_WIDTH * (0.5 - base.size))

	if weapon.damage_mask & Weapon.Damage.PLAYER:
		self_modulate = weapon.DAMAGE_PLAYERS_COLOR
	if weapon.damage_mask & Weapon.Damage.ENEMY:
		self_modulate = weapon.DAMAGE_ENEMIES_COLOR	

func _process(delta: float) -> void:
	lifespan -= delta
	if lifespan < 0.0:
		queue_free()
	self_modulate.a = lifespan
