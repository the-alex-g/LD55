extends Drone

@export var damage := 1


func apply_effect(to:Object)->void:
	if to.has_method("set_health"):
		to.health -= damage
	super.apply_effect(to)
