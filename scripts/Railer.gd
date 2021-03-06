extends Weapon

const BEAM_LENGTH: float = 900.0
const BEAM_WIDTH: float = 24.0

const AREA_RADIUS: float = 200.0
const MAGNIFICATION: float = 1.5
# what types of object should be affected
const MAGNIFICATION_MASK: int = SpaceObj.Type.ANY

var area: Area2D = null


func _ready() -> void:
	area = Area2D.new()
	area.collision_layer = MAGNIFICATION_MASK	
	var collider = CollisionShape2D.new()
	area.add_child(collider)
	collider.shape = CircleShape2D.new()
	collider.shape.radius = AREA_RADIUS
	GameScope.add_child(area)
	impulse = 200.0
	attack_speed = 0.5
	ability_speed = 0.3
	damage = 4.0


func _process(delta: float) -> void:
	._process(delta)
	area.position = (Player.position + Player.get_node('Camera').position -
		((base.get_viewport().size / 2) - base.get_viewport().get_mouse_position()) * 2)


func _exit_tree() -> void:
	area.queue_free()


func activate_ability(_at) -> void:
	var bodies = area.get_overlapping_areas()
	for body in bodies:
		var body_base = body.get_parent()
		if body_base is SpaceObj:
			body_base.spatial_velocity = -(body_base.position - area.position) / 1.8
