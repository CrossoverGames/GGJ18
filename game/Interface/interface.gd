extends CanvasLayer

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2,
	boost = 3,
	brk = 4,
	shield = 5
}

onready var launch_btn = get_node("actions/launch")
onready var separate_btn = get_node("actions/separate")
onready var left_btn = get_node("left")
onready var right_btn = get_node("right")
onready var minimap = get_node("minimap")
onready var boost_btn = get_node("boost")
onready var break_btn = get_node("break")
onready var shield_btn = get_node("shield")

onready var separate_timer = get_node("actions/separate_on")

export(float) var separate_time = 10
export(float) var storm_time = 20

signal btn_pressed

var launch_pressed = false
var separate_pressed = false

func _ready():
	launch_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.action])
	separate_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.action])
	left_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_left])
	right_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.move_right])
	boost_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.boost])
	break_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.brk])
	shield_btn.connect("pressed", self, "btn_pressed", [BTN_TYPE.shield])
	
	separate_timer.connect("timeout", self, "activate_separate")
	
	separate_timer.wait_time = separate_time
	
func storm_affected():
	left_btn.cooldown_with_time(storm_time)
	right_btn.cooldown_with_time(storm_time)
	boost_btn.cooldown_with_time(storm_time)
	break_btn.cooldown_with_time(storm_time)
	shield_btn.cooldown_with_time(storm_time)
	
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

func print_message(message, duration = 0):
	$"actions/text-box/label".text = message
	if duration > 0:
		yield(get_tree().create_timer(duration), "timeout")
		$"actions/text-box/label".text = ""

func set_health(hp):
	$"health/hp-1".visible = false
	$"health/hp-2".visible = false
	$"health/hp-3".visible = false
	$"health/hp-4".visible = false
	
	if hp >= 1:
		$"health/hp-1".visible = true
	if hp >= 2:
		$"health/hp-2".visible = true
	if hp >= 3:
		$"health/hp-3".visible = true
	if hp >= 4:
		$"health/hp-4".visible = true

func _on_ship_separated():
	$logo.hide()
