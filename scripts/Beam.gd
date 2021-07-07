extends Line2D

# it's only visual for beam, in seconds
var lifespan: float = 1.0
# how much each collision affects the damage of next hit
const DAMAGE_MULTIPLIER: float = 2.25
var damage: float = 3.0
# after initializing beam awaits the physics update with all collisions updated
var _processed: bool = false


func _init_projectile(base, weapon) -> void:
	position = base.position
	rotation = base.rotation
	points[1] = Vector2(0, -(weapon.BEAM_LENGTH))
	width = weapon.BEAM_WIDTH - (weapon.BEAM_WIDTH * (0.5 - base.size))
	damage = weapon.damage

	$RaycastLeft.collision_mask = weapon.damage_mask
	$RaycastRight.collision_mask = weapon.damage_mask
	$RaycastLeft.cast_to = Vector2(0, -(weapon.BEAM_LENGTH))
	$RaycastRight.cast_to = Vector2(0, -(weapon.BEAM_LENGTH))
	$RaycastLeft.position = Vector2(-(weapon.BEAM_WIDTH/2), 0)
	$RaycastRight.position = Vector2(weapon.BEAM_WIDTH/2, 0)

	if weapon.damage_mask & Weapon.Damage.PLAYER:
		self_modulate = weapon.DAMAGE_PLAYERS_COLOR
	if weapon.damage_mask & Weapon.Damage.ENEMY:
		self_modulate = weapon.DAMAGE_ENEMIES_COLOR


func _physics_process(delta: float) -> void:
	if not _processed:
		var collided = []
		for ray in get_children():
			var next = ray.get_collider()
			while next != null:
				var collided_already: bool = false
				for collided_check in collided:
					if next == collided_check:
						collided_already = true
						break
				if not collided_already:
					collided.push_back(next)
				ray.add_exception(next)
				ray.force_raycast_update()
				next = ray.get_collider()
		collided.sort_custom(self, "_distance_sort")
		for c in collided:
			var base = c.get_parent()
			if base is Ship:
				base.receive_damage(damage)
			if base is Bullet:
				base.queue_free()
			damage *= DAMAGE_MULTIPLIER
		_processed = true


func _distance_sort(a, b) -> bool:
	return (position.distance_to(a.get_global_position()) <
		position.distance_to(b.get_global_position()))


func _process(delta: float) -> void:
	lifespan -= delta
	if lifespan < 0.0:
		queue_free()
	self_modulate.a = lifespan
