extends Ship

const RANDOM_SIZE_MAX_CHANGE = 0.25

enum STATES {AWAITS_TELEPORT, PREPARES_TO_FIRE}
const AWAITS_TELEPORT_TIME = 5.0
const PREPARES_TO_FIRE_TIME = 2.0
const DISTANCE_TO_AFTER_TELEPORT = 360.0

var _state = STATES.AWAITS_TELEPORT
var _state_progress: float = AWAITS_TELEPORT_TIME


func _ready() -> void:
	size = 3.0
	size += (0.5 - randf()) * RANDOM_SIZE_MAX_CHANGE
	acceleration = 0.0
	angular_velocity_change = 3.8
	if weapon != null:
		weapon.damage_mask = Weapon.Damage.PLAYER


func _process(delta: float) -> void:
	if not Player.alive:
		return

	var target_dot = Vector2.UP.rotated(rotation).angle_to(Player.position - position)

	if target_dot > 0.0:
		intent |= ROTATE_CLOCKWISE
		intent ^= ROTATE_ANTICLOCKWISE
	else:
		intent ^= ROTATE_CLOCKWISE
		intent |= ROTATE_ANTICLOCKWISE

	if intent & ATTACK:
		intent ^= ATTACK

	_state_progress -= delta
	if _state_progress < 0.0:
		match _state:
			STATES.AWAITS_TELEPORT:
				teleport(Player)
				_state = STATES.PREPARES_TO_FIRE
				_state_progress = PREPARES_TO_FIRE_TIME
			STATES.PREPARES_TO_FIRE:
				intent |= ATTACK
				_state = STATES.AWAITS_TELEPORT
				_state_progress = AWAITS_TELEPORT_TIME


func teleport(to: SpaceObj) -> void:
	var angle = randf() * PI * 2
	position = to.position + Vector2.UP.rotated(angle) * DISTANCE_TO_AFTER_TELEPORT
	spatial_velocity = to.spatial_velocity
	rotation = to.position.angle_to(position)


func receive_damage(dmg: float) -> void:
	SoundSystem.play_ping()
	.receive_damage(dmg)
