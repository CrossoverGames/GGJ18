extends "action.gd"

export(NodePath) var speed_attribute
onready var speed_attr = get_node(speed_attribute)

func _execute(direction):
	ship.move_and_slide(direction * speed_attr.value)
