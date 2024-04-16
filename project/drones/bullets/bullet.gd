class_name Bullet
extends CharacterBody2D

@export var damage := 1
@export var speed := 400.0

var angle := 0.0
var ring_color : Color : set = set_ring_color
var team := -1

@onready var _polygon_generator : PolygonGenerator = $PolygonGenerator


func _physics_process(delta:float)->void:
	move_and_collide(Vector2.RIGHT.rotated(angle) * speed * delta)


func apply_effect(to:Object)->void:
	if to.team == team:
		return
	if to.has_method("set_health"):
		to.health -= damage
	queue_free()


func set_ring_color(value:Color)->void:
	if is_inside_tree():
		_polygon_generator.ring_color = value
	else:
		await ready
		set_ring_color(value)


func _on_hit_area_body_entered(body:PhysicsBody2D)->void:
	apply_effect(body)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
