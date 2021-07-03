class_name Ship
extends Node2D

# impact of stabilization
var angular_stability_change: float = 3.0
var angular_velocity_change: float = 7.0
var acceleration_change: float = 200.0
var deacceleration_change: float = 0.08

const SIZE_CHANGE: float = 1.25
const SIZE_LERP: float = 6.0
const MAX_SIZE: float = 3.0
const MIN_SIZE: float = 1.5

# constant change of angle
var angular_velocity: float = 0.0
var max_velocity: float = 500.0
var spatial_velocity: Vector2 = Vector2(0, 0)

var size: float = 2.0
var target_size: float = 2.0

export(PackedScene) var weapon_scene
var weapon: Weapon = null

var trace: Line2D = null
const TRACE_POINT_TIMING: float = 50.0
const POINT_COUNT: int = 48
var _point_timing: float = 0.0
export var trace_gradient: Gradient
export var trace_width: float = 16.0

enum {
	ROTATE_CLOCKWISE = 1,
	ROTATE_ANTICLOCKWISE = 2,
	ACCELERATE = 4,
	ATTACK = 8,
	SIZE_UP = 16,
	SIZE_DOWN = 32,
}

# bit mask of control intents
var intent: int = 0


func _ready() -> void:
	weapon = weapon_scene.instance()
	add_child(weapon)

	trace = Line2D.new()
	for _x in range(POINT_COUNT):
		trace.add_point(Vector2.ZERO)
	trace.width = trace_width
	trace.set_gradient(trace_gradient)
	GameScope.add_child(trace)


func _process(delta: float) -> void:
	if angular_velocity > 0:
		angular_velocity -= min(angular_velocity, angular_stability_change) * delta		
	else:
		angular_velocity += min(-angular_velocity, angular_stability_change) * delta

	if intent & ROTATE_CLOCKWISE:
		angular_velocity += angular_velocity_change * delta
	if intent & ROTATE_ANTICLOCKWISE:
		angular_velocity -= angular_velocity_change * delta
	if intent & ACCELERATE:
		spatial_velocity += Vector2.UP.rotated(rotation) * acceleration_change * delta
		if spatial_velocity.length() > max_velocity:
			spatial_velocity -= spatial_velocity / (spatial_velocity.length() /
				(spatial_velocity.length() - max_velocity))

	position += spatial_velocity * delta
	spatial_velocity -= (spatial_velocity *
		clamp((spatial_velocity / deacceleration_change).length(), 0.0, 1.0)
		* deacceleration_change * delta)
	rotation += angular_velocity * delta

	if intent & SIZE_UP:
		target_size += SIZE_CHANGE * delta
		if target_size > MAX_SIZE:
			target_size = MAX_SIZE
	if intent & SIZE_DOWN:
		target_size -= SIZE_CHANGE * delta
		if target_size < MIN_SIZE:
			target_size = MIN_SIZE

	var size_change = lerp(size, target_size, SIZE_LERP * delta) - size
	size += size_change
	scale += Vector2(size_change, size_change)

	_point_timing -= delta
	if _point_timing <= 0.0:
		_point_timing += 1 / TRACE_POINT_TIMING
		trace.remove_point(trace.get_point_count()-1)
		trace.add_point(position, 0)

	weapon.toggle_fire(intent & ATTACK)
