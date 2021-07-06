class_name ControllableShip
extends Ship


func _ready() -> void:
#	._ready()
	randomize()
	if weapon != null:
		weapon.damage_mask = Weapon.Damage.ENEMY


func _process(delta: float) -> void:
#	._process(delta)
	Hud.set_health_percent(health / max_health)
	if (max_velocity - spatial_velocity.length()) < 25.0:
		Hud.add_shake(1.0)


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
	process_intent(event, 'ability', ABILITY)


func receive_damage(dmg: float) -> void:
	.receive_damage(dmg)
	Hud.add_shake(dmg * 25)
	Hud.set_health_percent(health / max_health)


func death() -> void:
	.death()
	get_node('/root/Game').player_alive = false
	var cam = Camera2D.new()
	cam.current = true
	cam.position = position
	GameScope.add_child(cam)
	Hud.game_over()
