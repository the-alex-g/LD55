class_name Player
extends CharacterBody2D

@export var speed := 150.0
@export var health := 50

var team := 0


func _physics_process(delta:float)->void:
	if Input.is_action_just_pressed("repair_drone"):
		spawn_drone("repair_drone")
	if Input.is_action_just_pressed("attack_drone"):
		spawn_drone("attack_drone")
	if Input.is_action_just_pressed("defense_drone"):
		pass
	
	var movement_vector := Input.get_vector("left", "right", "up", "down")
	move_and_collide(movement_vector * delta * speed)


func spawn_drone(dronetype:String)->void:
	var drone : Drone = load("res://drones/" + dronetype + ".tscn").instantiate()
	drone.controller = self
	drone.global_position = global_position
	drone.set_rings(1, Color.WHITE)
	get_parent().add_child(drone)
