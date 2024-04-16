extends RangedDrone

@export var damage := 1


func _fire_at(object:Node2D)->void:
	if object.team == team:
		return
	var bullet := preload("res://drones/bullets/bullet.tscn").instantiate()
	bullet.team = get_team()
	bullet.angle = get_angle_to(object.global_position)
	bullet.damage = 1
	bullet.ring_color = _polygon_generator.ring_color
	bullet.global_position = global_position
	get_parent().add_child(bullet)
	super._fire_at(object)
