extends Ship

# target velocity length
const TARGETING_SPEED: float = 270.0
# prevent collisions with other objects
const BAIL_DISTANCE: float = 4.0
const FIRE_DISTANCE: float = 560.0

const RANDOM_SIZE_MAX_CHANGE: float = 0.5


func _ready() -> void:
	size += (0.5 - randf()) * RANDOM_SIZE_MAX_CHANGE
	acceleration = 330.0
	angular_velocity_change = 4.6
	if weapon != null:
		weapon.damage_mask = Weapon.Damage.PLAYER


func _process(_delta: float) -> void:
	if not Player.alive:
		intent = ACCELERATE
		return

	$Sight.cast_to = -(spatial_velocity.normalized().rotated(-rotation)) * BAIL_DISTANCE

	var dot: float = spatial_velocity.normalized().dot(Vector2.UP.rotated(rotation))

	if spatial_velocity.length() < TARGETING_SPEED + (dot * sign(dot)) * TARGETING_SPEED:
		intent |= ACCELERATE
	elif intent & ACCELERATE:
		intent ^= ACCELERATE

	var target_dot = Vector2.UP.rotated(rotation).angle_to(Player.position - position)

	if target_dot > 0.0:
		intent |= ROTATE_CLOCKWISE
		intent ^= ROTATE_ANTICLOCKWISE
	else:
		intent ^= ROTATE_CLOCKWISE
		intent |= ROTATE_ANTICLOCKWISE

	if (target_dot < 0.1 and target_dot > -0.1 and
			position.distance_to(Player.position) < FIRE_DISTANCE):
		intent |= ATTACK
	elif intent & ATTACK:
		intent ^= ATTACK

	if $Sight.is_colliding():
		intent |= ROTATE_ANTICLOCKWISE
		intent ^= ACCELERATE
		intent |= ABILITY
	elif intent & ABILITY:
		intent ^= ABILITY


func receive_damage(dmg: float) -> void:
	SoundSystem.play_ping()
	.receive_damage(dmg)
