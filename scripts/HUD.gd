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

const MUSIC_BUS_ID = 1
const SOUNDS_BUS_ID = 2

const MAX_MUSIC_VOLUME = 6.0
const MIN_MUSIC_VOLUME = -100.0

const MAX_SOUND_VOLUME = 6.0
const MIN_SOUND_VOLUME = -100.0


func _ready() -> void:
	if $GameScreen/PanelContainer/VBoxContainer/HBoxContainer/Music.connect('value_changed', self, '_on_music_volume_change') != OK:
		push_error('cannot initialize music valume callback')
	if $GameScreen/PanelContainer/VBoxContainer/VBoxContainer/Sounds.connect('value_changed', self, '_on_sounds_volume_change') != OK:
		push_error('cannot initialize sound valume callback')
	if $GameOver/Restart.connect('pressed', Player, 'revive') != OK:
		push_error('cannot initialize player ship')


func _process(delta: float) -> void:
	$GamePlay/RadiusHint.position = get_viewport().get_mouse_position()
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


func _on_music_volume_change(value: float) -> void:
	AudioServer.set_bus_volume_db(
		MUSIC_BUS_ID, MIN_MUSIC_VOLUME +
		(MAX_MUSIC_VOLUME - MIN_MUSIC_VOLUME) * (value / 100))


func _on_sounds_volume_change(value: float) -> void:
	AudioServer.set_bus_volume_db(
		SOUNDS_BUS_ID, MIN_SOUND_VOLUME +
		(MAX_SOUND_VOLUME - MIN_SOUND_VOLUME) * (value / 100))


func change_weapon_icon(id: int) -> void:
	if id == ICONS.BLASTER_ICON:
		$GamePlay/WeaponName.text = "BLASTER"
		$GamePlay/AbilityName.text = "DASH"
		$GamePlay/WeaponIcon.texture.region = Rect2(0, 16, 16, 16)
	if id == ICONS.RAILER_ICON:
		$GamePlay/WeaponName.text = "RAILER"
		$GamePlay/AbilityName.text = "MAGNET"
		$GamePlay/WeaponIcon.texture.region = Rect2(16, 16, 16, 16)


func set_weapon_cooldown_percent(percent: float) -> void:
	$GamePlay/Panel/WeaponCooldown.value = percent * 100


func set_ability_cooldown_percent(percent: float) -> void:
	$GamePlay/Panel/AbilityCooldown.value = percent * 100
	

func set_health_percent(percent: float) -> void:
	$GamePlay/HealthBar.value = percent * 100
	$GamePlay/HealthBarB.value = percent * 100
	$GamePlay/HealthBar.self_modulate = HEALTH_NONE_COLOR.linear_interpolate(HEALTH_FULL_COLOR, percent)
	$GamePlay/HealthBarB.self_modulate = HEALTH_NONE_COLOR.linear_interpolate(HEALTH_FULL_COLOR, percent)


func add_shake(amount: float) -> void:
	_shake += amount
	if _shake > SHAKE_LIMIT:
		_shake = SHAKE_LIMIT


func show_game_over() -> void:
	$GameOver.show()


func hide_game_over() -> void:
	$GameOver.hide()
