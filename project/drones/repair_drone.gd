extends Drone

@export var heal_amount := 5

@onready var _timer : Timer = $Timer


func _ready()->void:
	super._ready()
	_timer.start(1.0 + randf())
	await _timer.timeout
	always_orbit_controller = false


func apply_effect(to:Object)->void:
	if not always_orbit_controller:
		to.health += heal_amount + randi_range(-1, 1)
		queue_free()
