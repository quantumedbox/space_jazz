class_name ControllableShip
extends Ship


onready var _default_collision_layer = $Area.collision_layer
var alive: bool = true


func _ready() -> void:
#	._ready()
	randomize()
	if weapon != null:
		weapon.damage_mask = Weapon.Damage.ENEMY


func _process(_delta: float) -> void:
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
	if alive:
		process_intent(event, 'rotate_clockwise', ROTATE_CLOCKWISE)
		process_intent(event, 'rotate_anticlockwise', ROTATE_ANTICLOCKWISE)
		process_intent(event, 'accelerate', ACCELERATE)
		process_intent(event, 'attack', ATTACK)
		process_intent(event, 'size_up', SIZE_UP)
		process_intent(event, 'size_down', SIZE_DOWN)
		process_intent(event, 'ability', ABILITY)


func receive_damage(dmg: float) -> void:
	$DamagePlayer.play()
	if alive:
		.receive_damage(dmg)
		Hud.add_shake(dmg * 25)
		Hud.set_health_percent(health / max_health)


func death() -> void:
	_spawn_debris()
	intent = 0
	alive = false
	$Area.collision_layer = 0
	$Shadow.hide()
	$Ship.hide()
	SoundSystem.play_explosion()
	trace.hide()
	Hud.show_game_over()


func revive() -> void:
	position = Vector2.ZERO
	spatial_velocity = Vector2.ZERO
	angular_velocity = 0
	alive = true
	$Area.collision_layer = _default_collision_layer
	$Shadow.show()
	$Ship.show()
	trace.show()
	Hud.hide_game_over()
	health = max_health
	Hud.set_health_percent(health / max_health)


func heal(amount: float) -> void:
	SoundSystem.play_heal()
	Hud.set_health_percent(health / max_health)
	health = clamp(health + amount, 0.0, max_health)
