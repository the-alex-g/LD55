class_name TargetingBody
extends CharacterBody2D

enum TargetType {ENEMY}
enum MoveMode {ORBIT, CHASE}

const ORBIT_DISTANCE := 50

@export var speed := 200.0
@export var target_type : TargetType = TargetType.ENEMY

var targeting_area : Area2D
var move_mode : MoveMode = MoveMode.ORBIT
var target : Node2D
var controller : Node2D : set = set_controller


func _ready()->void:
	if has_node("TargetingArea"):
		targeting_area = $TargetingArea
	else:
		targeting_area = preload("res://targeting_body/targeting_area.tscn").instantiate()
		add_child(targeting_area)


func _physics_process(delta:float)->void:
	if is_instance_valid(target):
		var direction := get_angle_to(target.global_position)
		
		if move_mode == MoveMode.ORBIT:
			if distance_sqrd_to(target) < pow(ORBIT_DISTANCE, 2) / 4:
				direction += PI
			elif distance_sqrd_to(target) < pow(ORBIT_DISTANCE, 2):
				direction += PI / 2
		
		$PolygonGenerator.rotation = direction
		move_and_collide(Vector2.RIGHT.rotated(direction) * speed * delta)
	
	get_closest_target()


func get_closest_target()->void:
	for node in targeting_area.get_overlapping_bodies():
		if is_possible_target(node):
			if distance_sqrd_to(node) < distance_sqrd_to(target):
				target = node
				move_mode = MoveMode.CHASE
	
	if not is_instance_valid(target) or target == controller:
		target = controller
		move_mode = MoveMode.ORBIT


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


func set_controller(value:Node2D)->void:
	controller = value
