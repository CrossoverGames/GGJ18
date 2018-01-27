extends "action.gd"

var velocity
var duration
var timer

func _ready():
	set_process(false)

func _execute(args):
	timer = 0.0
	velocity = args[0]
	duration = args[1]
	set_process(true)

func _process(delta):
	if timer >= duration:
		set_process(false)
		return
	
	timer += delta
	ship.move_and_slide(velocity)
