extends Node


func _ready() -> void:
	get_viewport().audio_listener_enable_2d = true
	

func play_explosion() -> void:
	$Explosion.play()


func play_ping() -> void:
	$Ping.play()


func play_heal() -> void:
	$Heal.play()
