extends "res://environment/EnvironmentObject.gd"

func _ready():
	$Area.connect("body_entered", self, "on_body_enter_area")

func on_body_enter_area(body):
	if body.is_in_group("ship"):
		body.damage()
		if not body.dead: body.mod_speed(0.3, 0.5)
		queue_free() # or play anim before freeing
