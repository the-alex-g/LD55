@tool
extends Area2D

@export var radius := 100.0 : set = set_radius

@onready var _collision_shape : CollisionShape2D = $CollisionShape2D


func set_radius(value:float)->void:
	radius = value
	if is_inside_tree():
		var shape := CircleShape2D.new()
		shape.radius = radius
		_collision_shape.shape = shape
	else:
		await ready
		set_radius(value)
