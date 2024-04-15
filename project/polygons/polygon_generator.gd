@tool
class_name PolygonGenerator
extends Node2D

@export var points := 3 : set = set_points
@export var radius := 10.0 : set = set_radius
@export var rings := 0 : set = set_rings
@export var ring_color := Color.BLACK : set = set_ring_color
@export var color := Color.RED : set = set_color

var polygon : PackedVector2Array = []
var ring_polygons := []


func _ready()->void:
	update_polygon()


func update_polygon()->void:
	_update_central_polygon()
	_update_rings()


func _update_central_polygon()->void:
	polygon = []
	for p in points:
		polygon.append(Vector2.RIGHT.rotated(float(p) * TAU / float(points)) * radius)
	queue_redraw()


func _update_rings()->void:
	ring_polygons = []
	for i in rings:
		var ring_polygon : PackedVector2Array = []
		for p in points + 1:
			ring_polygon.append(Vector2.RIGHT.rotated(p * TAU / points) * (radius + 4 + 5 * i))
		ring_polygons.append(ring_polygon)
	queue_redraw()


func set_points(value:int)->void:
	if value < 3:
		points = 3
	else:
		points = value
	update_polygon()


func set_radius(value:float)->void:
	radius = value
	update_polygon()


func set_color(value:Color)->void:
	color = value
	queue_redraw()


func set_rings(value:int)->void:
	if value < 0:
		rings = 0
	else:
		rings = value
	_update_rings()


func set_ring_color(value:Color)->void:
	ring_color = value
	queue_redraw()


func _draw()->void:
	draw_colored_polygon(polygon, color)
	
	for ring in ring_polygons:
		draw_polyline(ring, ring_color, 2)
