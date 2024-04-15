class_name Drone
extends TargetingBody

const KNOCKBACK_MAGNITUDE := 10

@export var health := 5 : set = set_health


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
