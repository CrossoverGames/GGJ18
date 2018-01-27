extends CanvasLayer

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2
}

onready var action_btn = get_node("action")
onready var left_btn = get_node("left")
onready var right_btn = get_node("right")
onready var minimap = get_node("minimap")

signal btn_pressed

func _ready():
	action_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.action])
	left_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_left])
	right_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_right])
	
func btn_pressed(type):
	print(type)
	emit_signal("btn_pressed", type)
	
func add_signal_to_minimap(speed):
	minimap.create_signal(speed)