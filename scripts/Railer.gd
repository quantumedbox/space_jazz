extends Weapon

const BEAM_LENGTH: float = 900.0
const BEAM_WIDTH: float = 24.0

func _ready() -> void:
	impulse = 200.0
	attack_speed = 0.7
