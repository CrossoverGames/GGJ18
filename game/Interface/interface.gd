extends CanvasLayer

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2
}

onready var launch_btn = get_node("actions/launch")
onready var separate_btn = get_node("actions/separate")
onready var left_btn = get_node("left")
onready var right_btn = get_node("right")
onready var minimap = get_node("minimap")

onready var separate_timer = get_node("actions/separate_on")

export(float) var separate_time = 10

signal btn_pressed

var launch_pressed = false
var separate_pressed = false

func _ready():
	launch_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.action])
	separate_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.action])
	left_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_left])
	right_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_right])
	
	separate_timer.connect("timeout", self, "activate_separate")
	
	separate_timer.wait_time = separate_time
	
func activate_separate():
	separate_btn.show()
	separate_timer.stop()
	
func btn_pressed(type):
	print(type)
	
	var send = false
	
	if type == BTN_TYPE.action:
		if not launch_pressed:
			launch_pressed = true
			launch_btn.hide()
			launch_btn.disabled = true
			separate_timer.start()
			send = true
		if separate_btn.visible:
			separate_pressed = true
			separate_btn.hide()
			send = true
	else:
		send = true
		
	if send:
		emit_signal("btn_pressed", type)
	
func add_signal_to_minimap(speed):
	minimap.create_signal(speed)