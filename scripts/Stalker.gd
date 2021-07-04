extends Ship

# target velocity length
const TARGETING_SPEED: float = 150.0
# prevent collisions with other objects
const BAIL_DISTANCE: float = 60.0
const FIRE_DISTANCE: float = 560.0

const RANDOM_SIZE_MAX_CHANGE: float = 1.0

func _ready() -> void:
	._ready()
	size += (0.5 - randf()) * RANDOM_SIZE_MAX_CHANGE
	acceleration_change = 120.0
	angular_velocity_change = 1.2
	weapon.damage_mask |= Weapon.DAMAGE_PLAYERS

func _process(delta: float) -> void:
	var target = Player.position - position

	$Sight.cast_to = -(spatial_velocity.normalized().rotated(-rotation)) * BAIL_DISTANCE

	var dot: float = spatial_velocity.normalized().dot(Vector2.UP.rotated(rotation))

#	if spatial_velocity.length() - (TARGETING_SPEED * dot) < TARGETING_SPEED:
	if spatial_velocity.length() < TARGETING_SPEED + (dot * sign(dot)) * TARGETING_SPEED:
		intent |= ACCELERATE
	elif intent & ACCELERATE:
		intent ^= ACCELERATE

	var target_dot = Vector2.UP.rotated(rotation).angle_to(target)

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

	._process(delta)
