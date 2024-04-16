class_name Drone
extends TargetingBody

const KNOCKBACK_MAGNITUDE := 10

@export var health := 5 : set = set_health

@onready var _polygon_generator : PolygonGenerator = $PolygonGenerator


func _ready()->void:
	health += randi_range(-1, 1)
	super._ready()


func apply_effect(to:Object)->void:
	knockback(to.global_position)


func knockback(from:Vector2)->void:
	var knockback_direction := get_angle_to(from) + PI
	global_position += Vector2.RIGHT.rotated(knockback_direction) * KNOCKBACK_MAGNITUDE
	freezetime = 0.1


func set_health(value:int)->void:
	health = value
	if health <= 0:
		queue_free()


func set_rings(count:int, color:Color)->void:
	if is_inside_tree():
		_polygon_generator.rings = count
		_polygon_generator.ring_color = color
	else:
		await ready
		set_rings(count, color)
