extends Weapon

var base_attack_speed: float = 5.0
const ROTATION_EFFECT: float = 19.0
const ROTATION_EFFECT_MAX_AT: float = 7.5

const DASH_IMPULSE: float = 270.0


func _ready() -> void:
	damage = 0.6
	bullet_lifespan = 1.6
	impulse = 16.0
	starting_velocity = 680.0
	spread = 3.6
	ability_speed = 0.5


func _process(delta: float) -> void:
	attack_speed = base_attack_speed + (ROTATION_EFFECT *
		clamp((base.angular_velocity * sign(base.angular_velocity)) /
			ROTATION_EFFECT_MAX_AT, 0.0, 1.0))
	._process(delta)


func activate_ability(at: Vector2) -> void:
	base.spatial_velocity += (
		-at.normalized() *
		DASH_IMPULSE *
		base.size_effect_on_impulse.interpolate(base.size))
