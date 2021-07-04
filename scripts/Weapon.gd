class_name Weapon
extends Node

export(PackedScene) var _projectileScene

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
enum {DAMAGE_ENEMIES = 1, DAMAGE_PLAYERS = 2}
var damage_mask: int = 0

const DAMAGE_ENEMIES_COLOR: Color = Color(0, 0.337255, 1, 0.5)
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
	var projectile = self._projectileScene.instance()
	projectile._init_projectile(base, self)	
	GameScope.add_child(projectile)
	base.spatial_velocity -= (Vector2.UP.rotated(base.rotation) * impulse *
		base.size_effect_on_impulse.interpolate(base.size))
