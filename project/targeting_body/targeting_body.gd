class_name TargetingBody
extends CharacterBody2D

enum TargetType {ENEMY, CONTROLLER}
enum MoveMode {ORBIT, CHASE}

const ORBIT_DISTANCE := 50

@export var speed := 200.0
@export var target_type : TargetType = TargetType.ENEMY
@export var always_orbit_controller := false

var targeting_area : Area2D
var move_mode : MoveMode = MoveMode.ORBIT
var target : Node2D
var controller : Node2D : set = set_controller
var team : int : get = get_team
var freezetime := 0.0


func _ready()->void:
	if has_node("TargetingArea"):
		targeting_area = $TargetingArea
	else:
		targeting_area = preload("res://targeting_body/targeting_area.tscn").instantiate()
		add_child(targeting_area)


func _physics_process(delta:float)->void:
	if freezetime > 0:
		freezetime -= delta
		return
	
	if is_instance_valid(target):
		if always_orbit_controller:
			move_and_collide(
				Vector2.RIGHT.rotated(get_orbit_angle(controller)) * speed * delta / 2
			)
		elif move_mode == MoveMode.ORBIT:
			move_and_collide(
				Vector2.RIGHT.rotated(get_orbit_angle(target)) * speed * delta / 2
			)
		elif move_mode == MoveMode.CHASE:
			if distance_sqrd_to(target) > 9:
				move_and_collide(
					Vector2.RIGHT.rotated(
						get_angle_to(target.global_position)
					) * speed * delta
				)
			else:
				resolve_collision()
		
		$PolygonGenerator.rotation = get_angle_to(target.global_position)
	
	get_closest_target()


func get_orbit_angle(to:Node2D)->float:
	var direction := get_angle_to(to.global_position)
	if distance_sqrd_to(to) < pow(ORBIT_DISTANCE, 2) / 4:
		direction += PI
	elif distance_sqrd_to(to) < pow(ORBIT_DISTANCE, 2):
		direction += PI / 2
	return direction


func resolve_collision()->void:
	apply_effect(target)
	if target.has_method("apply_effect"):
		target.apply_effect(self)


func apply_effect(_to:Object)->void:
	pass


func get_closest_target()->void:
	for node in targeting_area.get_overlapping_bodies():
		if is_possible_target(node):
			if is_instance_valid(target):
				if distance_sqrd_to(node) < distance_sqrd_to(target):
					target = node
					move_mode = MoveMode.CHASE
			else:
				target = node
				move_mode = MoveMode.CHASE
	
	if not is_instance_valid(target):
		target = controller
		move_mode = MoveMode.ORBIT


func is_possible_target(node:Node)->bool:
	if node == self or not is_instance_valid(node):
		return false
	match target_type:
		TargetType.ENEMY:
			if node.team != get_team():
				return true
			return false
		TargetType.CONTROLLER:
			if node == controller:
				return true
			return false
		_:
			return true


func distance_sqrd_to(object:Node2D)->float:
	if is_instance_valid(object):
		return global_position.distance_squared_to(object.global_position)
	return INF


func set_controller(value:Node2D)->void:
	controller = value


func get_team()->int:
	return controller.team
