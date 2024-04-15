extends Node2D

var team := 1


func _on_timer_timeout():
	spawn_drone()


func spawn_drone()->void:
	var drone := preload("res://drones/drone.tscn").instantiate()
	drone.controller = self
	drone.global_position = global_position
	get_parent().add_child(drone)
