class_name Weapon
extends Node

const _bulletScene = preload('res://scenes/weapons/Bullet.tscn')

var _cooldown: float = 0
var _firing: bool = false

# velocity modificator on fire
var impulse: float = 0.0
# spread in degrees
var spread: float = 0.0
var starting_velocity: float = 500
# seconds of bullet life
var bullet_lifespan: float = 2.0
# bullets per second
var attack_speed: float = 1.0
# each types of targets should recieve the damage
enum {DAMAGE_ENEMIES, DAMAGE_PLAYERS}
var damage_mask: int = 0

const DAMAGE_PLAYERS_COLOR: Color = Color(0.7, 0.2, 0.1, 0.5)


func toggle_fire(state: bool) -> void:
	_firing = state


func _process(delta: float) -> void:
	# advanced all time related metrics
	if _firing:
		_cooldown -= delta
		if _cooldown <= 0.0:
			fire()
			_cooldown += 1 / attack_speed
	else:
		_cooldown = max(_cooldown - delta, 0)


func fire():
	var base: Node2D = get_parent()
	var bullet = self._bulletScene.instance()
	var rotation: float = base.rotation + deg2rad((randf()-0.5)*2 * spread)
	bullet.position = base.position
	bullet.rotation = rotation
	bullet.initial_velocity = base.spatial_velocity
	bullet.velocity = Vector2.UP.rotated(rotation) * starting_velocity
	bullet.lifespan = bullet_lifespan
	base.spatial_velocity -= Vector2.UP.rotated(base.rotation) * impulse
	GameScope.add_child(bullet)

	if damage_mask & DAMAGE_PLAYERS:
		bullet.get_node('Backlight').self_modulate = DAMAGE_PLAYERS_COLOR
