extends Node

export(bool) var disabled = false

export(NodePath) var ship_path = @"../.."
onready var ship = get_node(ship_path)

func execute(params = null):
	if disabled: return
	_execute(params)

func _execute(params = null):
	pass
