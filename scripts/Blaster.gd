extends Weapon

var base_attack_speed: float = 5.0
const rotation_effect: float = 15.0
const rotation_effect_max: float = 7.0

onready var base: Ship = get_parent()

func _ready() -> void:
	bullet_lifespan = 2.0
	impulse = 15.0
	starting_velocity = 550.0
	spread = 3.0


func _process(delta: float) -> void:
	attack_speed = base_attack_speed + (rotation_effect *
		clamp((base.angular_velocity * sign(base.angular_velocity)) / rotation_effect_max, 0.0, 1.0))
	._process(delta)
