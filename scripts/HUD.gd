class_name HUD_cls
extends CanvasLayer

enum ICONS {BLASTER_ICON, RAILER_ICON}

const HEALTH_FULL_COLOR = Color(0.0, 1.0, 0.0)
const HEALTH_NONE_COLOR = Color(1.0, 0.0, 0.0)

const SHAKE_LIMIT = 10.0
const SHAKE_MAX_OFFSET = 12.0
const SHAKE_DECLINE = 1.0
const SHAKE_RATE = 10.0
var _shake: float = 0.0
var _rate: float = 0.0


func _ready() -> void:
	$GameOver/Restart.connect('pressed', Player, 'revive')


func _process(delta: float) -> void:
	$RadiusHint.position = get_viewport().get_mouse_position()
	_rate -= delta
	if _rate < 0:
		_rate = 1 / SHAKE_RATE
		if _shake > 0:
			offset = (((0.5 - randf()) * 2) * Vector2(randf(), randf()) *
				(_shake / SHAKE_LIMIT) * SHAKE_MAX_OFFSET)
		_shake -= SHAKE_DECLINE
		if _shake < 0.0:
			_shake = 0.0
			offset = Vector2.ZERO
		Player.get_node('Camera').position = -offset			


func change_weapon_icon(id: int) -> void:
	if id == ICONS.BLASTER_ICON:
		$WeaponName.text = "BLASTER"
		$AbilityName.text = "DASH"
		$Base/WeaponIcon.texture.region = Rect2(0, 16, 16, 16)
	if id == ICONS.RAILER_ICON:
		$WeaponName.text = "RAILER"
		$AbilityName.text = "MAGNET"
		$Base/WeaponIcon.texture.region = Rect2(16, 16, 16, 16)


func set_weapon_cooldown_percent(percent: float) -> void:
	$Panel/WeaponCooldown.value = percent * 100


func set_ability_cooldown_percent(percent: float) -> void:
	$Panel/AbilityCooldown.value = percent * 100
	

func set_health_percent(percent: float) -> void:
	$HealthBar.value = percent * 100
	$HealthBarB.value = percent * 100
	$HealthBar.self_modulate = HEALTH_NONE_COLOR.linear_interpolate(HEALTH_FULL_COLOR, percent)
	$HealthBarB.self_modulate = HEALTH_NONE_COLOR.linear_interpolate(HEALTH_FULL_COLOR, percent)


func add_shake(amount: float) -> void:
	_shake += amount
	if _shake > SHAKE_LIMIT:
		_shake = SHAKE_LIMIT


func show_game_over() -> void:
	$GameOver.show()


func hide_game_over() -> void:
	$GameOver.hide()
