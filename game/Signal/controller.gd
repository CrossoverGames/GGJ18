extends Node

export(NodePath) var canvas_path
export(NodePath) var rocket_path
export(String) var signal_path = "res://"
export(float) var softener = 0.2

var canvas
var rocket
var new_signal
var tookoff = false

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2,
	boost = 3,
	brk = 4,
	shield = 5
}

func _ready():
	if canvas_path:
		canvas = get_node(canvas_path)
		canvas.connect("btn_pressed", self, "create_signal")
	if rocket_path:
		rocket = get_node(rocket_path)
		
func find_delay():
	if not rocket: return
	
	var time
	
	if not tookoff:
		tookoff = true
		time = 0.1
	else:
		time = rocket.elapsed_time * softener
	
	print("Using delay " + String(time))
	return time
		
func create_signal(type):
	print("created signal type" + String(type))
	new_signal = load(signal_path).instance()
	add_child(new_signal)
	
	new_signal.set_type(type)
	new_signal.ship = rocket
	
	var delay = find_delay() + 0.001
	new_signal.set_arrive_timer_and_start(delay)
	
	canvas.add_signal_to_minimap(1 / delay)

func on_ship_destroyed():
	for sig in get_children(): sig.ship = null
	
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()
	
