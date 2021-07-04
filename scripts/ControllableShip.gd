class_name ControllableShip
extends Ship


func _ready() -> void:
	weapon.damage_mask |= Weapon.DAMAGE_ENEMIES


func process_intent(event: InputEvent, action: String, bit: int) -> void:
	if event.is_action(action):
		if event.is_pressed():
			intent |= bit		
		else:
			intent ^= bit


func _input(event: InputEvent) -> void:
	process_intent(event, 'rotate_clockwise', ROTATE_CLOCKWISE)
	process_intent(event, 'rotate_anticlockwise', ROTATE_ANTICLOCKWISE)
	process_intent(event, 'accelerate', ACCELERATE)
	process_intent(event, 'attack', ATTACK)
	process_intent(event, 'size_up', SIZE_UP)
	process_intent(event, 'size_down', SIZE_DOWN)
