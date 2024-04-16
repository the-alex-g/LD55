class_name RangedDrone
extends Drone

@export var reload_time := 0.5

var can_shoot := true


func apply_effect(to:Object)->void:
	if can_shoot:
		_fire_at(to)


func _fire_at(_object:Node2D)->void:
	can_shoot = false
	await get_tree().create_timer(reload_time).timeout
	can_shoot = true
