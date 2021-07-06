class_name Weapon
extends Node

export(PackedScene) var _projectileScene

var _firing: bool = false
var _firing_cooldown: float = 0
var _abiliting: bool = false
var _abiliting_cooldown: float = 0

# velocity modificator on fire
var impulse: float = 0.0
# spread in degrees
var spread: float = 0.0
var starting_velocity: float = 500
# seconds of bullet life
var bullet_lifespan: float = 2.0
# bullets per second
var attack_speed: float = 1.0
# activations per second
var ability_speed: float = 0.5
var damage: float = 0.5
# each types of targets should recieve the damage
enum Damage {
	NO 		= 0b000,
	ANY 	= 0b001,
	PLAYER 	= 0b010,
	ENEMY 	= 0b100,
}
export(Damage) var damage_mask = Damage.NO

const DAMAGE_ENEMIES_COLOR: Color = Color(0, 0.337255, 1, 0.5)
const DAMAGE_PLAYERS_COLOR: Color = Color(0.7, 0.2, 0.1, 0.5)

onready var base = get_parent()

export(HUD_cls.ICONS) var icon = HUD_cls.ICONS.BLASTER_ICON


func toggle_fire(state: bool) -> void:
	_firing = state


func toggle_ability(state: bool) -> void:
	_abiliting = state


func _process(delta: float) -> void:
	# advanced all time related metrics
	if _firing:
		_firing_cooldown -= delta
		if _firing_cooldown <= 0.0:
			fire()
			_firing_cooldown += 1 / attack_speed
	else:
		_firing_cooldown = max(_firing_cooldown - delta, 0)

	if _abiliting:
		_abiliting_cooldown -= delta
		if _abiliting_cooldown <= 0.0:
			activate_ability((base.get_viewport().size / 2) - base.get_viewport().get_mouse_position())
			_abiliting_cooldown += 1 / ability_speed
	else:
		_abiliting_cooldown = max(_abiliting_cooldown - delta, 0)


func fire() -> void:
	$Player.play()
	var projectile = _projectileScene.instance()
	projectile._init_projectile(base, self)	
	GameScope.add_child(projectile)
	base.spatial_velocity -= (Vector2.UP.rotated(base.rotation) * impulse *
		base.size_effect_on_impulse.interpolate(base.size))


func activate_ability(_at: Vector2) -> void:
	pass
