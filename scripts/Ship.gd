extends SpaceObj
class_name Ship

const debrisScene = preload('res://scenes/Debris.tscn')

# impact of stabilization
var angular_stability_change: float = 3.0
var angular_velocity_change: float = 9.5
var acceleration: float = 260.0

# size is always clamped to [0.1, 1]
var size: float = 0.5
var target_size: float = 0.5
# how much 'size' effects the actual size
var size_effect: float = 4.0
const SIZE_CHANGE: float = 0.5
const SIZE_LERP: float = 6.0

export(PackedScene) var weapon_scene
var weapon: Weapon = null

var max_health: float = 10.0
var health: float = max_health

var trace: Line2D = null
const TRACE_POINT_TIMING: float = 50.0
const POINT_COUNT: int = 48
var _point_timing: float = 0.0
export var trace_gradient: Gradient
export var trace_width: float = 16.0

export var size_effect_on_impulse: Curve
export var size_effect_on_acceleration: Curve
export var size_effect_on_rotation: Curve

enum {
	ROTATE_CLOCKWISE = 1,
	ROTATE_ANTICLOCKWISE = 2,
	ACCELERATE = 4,
	ATTACK = 8,
	ABILITY = 16,
	SIZE_UP = 32,
	SIZE_DOWN = 64,
}

# bit mask of control intents
var intent: int = 0


func _ready() -> void:
#	$Area.collision_layer = type
	# for some reason sometimes curves are not instanced from parent scene, i dunno
	for curve in ['size_effect_on_impulse',
				  'size_effect_on_acceleration',
				  'size_effect_on_rotation']:
		if get(curve) == null:
			set(curve, Curve.new())
			get(curve).add_point(Vector2(0.0, 1.0))

	if weapon_scene != null:
		weapon = weapon_scene.instance()
		add_child(weapon)

	trace = Line2D.new()
#	trace.points = PoolVector2Array([Vector2.ZERO] * POINT_COUNT)
	for _i in range(POINT_COUNT):
		trace.add_point(Vector2.ZERO)
	trace.width = trace_width
	trace.width_curve = load('res://resources/tracecurve.tres')
	trace.set_gradient(trace_gradient)
	GameScope.add_child(trace)


func _process(delta: float) -> void:
	var collisions = $Area.get_overlapping_areas()
	for case in collisions:
		var case_base = case.get_parent()
		if case.collision_layer & type and case_base is SpaceObj:
			case_base.collide_with(self)

	if angular_velocity > 0:
		angular_velocity -= min(angular_velocity, angular_stability_change) * delta		
	else:
		angular_velocity += min(-angular_velocity, angular_stability_change) * delta

	if intent & ROTATE_CLOCKWISE:
		angular_velocity += (angular_velocity_change * delta *
			size_effect_on_rotation.interpolate(size))
	if intent & ROTATE_ANTICLOCKWISE:
		angular_velocity -= (angular_velocity_change * delta *
			size_effect_on_rotation.interpolate(size))
	if intent & ACCELERATE:
		spatial_velocity += (Vector2.UP.rotated(rotation) * acceleration * delta *
			size_effect_on_acceleration.interpolate(size))
	if spatial_velocity.length() > max_velocity:
		spatial_velocity -= spatial_velocity / (spatial_velocity.length() /
			(spatial_velocity.length() - max_velocity))

	if intent & SIZE_UP:
		target_size += SIZE_CHANGE * delta
		if target_size > 1.0:
			target_size = 1.0
	if intent & SIZE_DOWN:
		target_size -= SIZE_CHANGE * delta
		if target_size < 0.1:
			target_size = 0.1

	var size_change = lerp(size, target_size, SIZE_LERP * delta) - size
	size += size_change
	scale += Vector2(size_change * size_effect, size_change * size_effect)

#	._process(delta)

	_point_timing -= delta
	if _point_timing <= 0.0:
		_point_timing += 1 / TRACE_POINT_TIMING
		trace.remove_point(trace.get_point_count()-1)
		trace.add_point(position, 0)

	if weapon != null:
		weapon.toggle_fire(intent & ATTACK)
		weapon.toggle_ability(intent & ABILITY)


func death() -> void:
	for _i in range(3):
		var debris = debrisScene.instance()
		debris.spatial_velocity = (
			spatial_velocity.normalized().rotated((0.5 - randf() * 2 * deg2rad(15))) *
				spatial_velocity)
		GameScope.add_child(debris)
	queue_free()


func receive_damage(dmg: float) -> void:
	health -= dmg
	if health < 0:
		death()


func _exit_tree() -> void:
	trace.queue_free()
