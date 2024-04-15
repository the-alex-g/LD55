class_name TargetingBody
extends CharacterBody2D

enum TargetType {ENEMY}

@export var speed := 200.0
@export var target_type : TargetType = TargetType.ENEMY

var targeting_area : Area2D
var target : Node2D
var controller : Node


func _ready()->void:
	if has_node("TargetingArea"):
		targeting_area = $TargetingArea
	else:
		targeting_area = preload("res://targeting_body/targeting_area.tscn").instantiate()
		add_child(targeting_area)


func _physics_process(delta:float)->void:
	if is_instance_valid(target):
		var direction := get_angle_to(target.global_position)
		$PolygonGenerator.rotation = direction
		move_and_collide(Vector2.RIGHT.rotated(direction) * speed * delta)
	get_closest_target()


func get_closest_target()->void:
	for node in targeting_area.get_overlapping_bodies():
		if is_possible_target(node):
			if distance_sqrd_to(node) < distance_sqrd_to(target):
				target = node


func is_possible_target(node:PhysicsBody2D)->bool:
	if node == self:
		return false
	match target_type:
		_:
			return true


func distance_sqrd_to(object:Node2D)->float:
	if is_instance_valid(object):
		return global_position.distance_squared_to(object.global_position)
	return INF
