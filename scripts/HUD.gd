class_name HUD_cls
extends Node

enum ICONS {BLASTER_ICON, RAILER_ICON}

const HEALTH_FULL_COLOR = Color(0.0, 1.0, 0.0)
const HEALTH_NONE_COLOR = Color(1.0, 0.0, 0.0)


func change_weapon_icon(id: int) -> void:
	if id == ICONS.BLASTER_ICON:
		$Base/WeaponIcon.texture.region = Rect2(0, 16, 16, 16)
	if id == ICONS.RAILER_ICON:
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


func game_over() -> void:
	$GameOver.show()
