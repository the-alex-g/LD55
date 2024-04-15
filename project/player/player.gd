class_name Player
extends CharacterBody2D

@export var speed := 150.0

var team := 0


func _physics_process(delta:float)->void:
	if Input.is_action_just_pressed("spawn_drone"):
		spawn_drone()
	
	var movement_vector := Input.get_vector("left", "right", "up", "down")
	move_and_collide(movement_vector * delta * speed)


func spawn_drone()->void:
	var drone := preload("res://drones/drone.tscn").instantiate()
	drone.controller = self
	drone.global_position = global_position
	get_parent().add_child(drone)
