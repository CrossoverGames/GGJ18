extends "action.gd"

export(NodePath) var speed_attribute
onready var speed_attr = get_node(speed_attribute)

var direction
var duration
var timer

func _ready():
	set_process(false)

func _execute(args):
	timer = 0.0
	direction = args[0]
	duration = args[1]
	
	set_process(true)

func _process(delta):
	if timer >= duration:
		set_process(false)
		return
	
	timer += delta
	ship.move_and_slide(direction * speed_attr.value)
