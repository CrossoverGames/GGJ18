extends "res://environment/EnvironmentObject.gd"

func _ready():
	$Area.connect("body_entered", self, "on_body_enter_area")

func on_body_enter_area(body):
	if body.is_in_group("ship"):
		body.damage()
