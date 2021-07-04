class_name HUD_cls
extends Node

enum ICONS {BLASTER_ICON, RAILER_ICON}


func change_weapon_icon(id: int) -> void:
	if id == ICONS.BLASTER_ICON:
		$Base/WeaponIcon.texture.region = Rect2(0, 16, 16, 16)
	if id == ICONS.RAILER_ICON:
		$Base/WeaponIcon.texture.region = Rect2(16, 16, 16, 16)


func set_weapon_cooldown_percent(percent: float) -> void:
	$Panel/WeaponCooldown.value = percent * 100


func set_ability_cooldown_percent(percent: float) -> void:
	$Panel/AbilityCooldown.value = percent * 100
