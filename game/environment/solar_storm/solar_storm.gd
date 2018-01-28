extends Spatial

export(float) var chance = 0.001
export(NodePath) var ship_path
export(NodePath) var ui_path
export(int) var alert_time = 2
export(float) var duration = 15.0

onready var incoming_timer = get_node("incoming")
onready var active_timer = get_node("active")
onready var alert = get_node("alert")

var ship
var active = false

signal solar_storm_incoming
signal solar_storm_started
signal solar_storm_ended

func _ready():
	hide()
	alert.hide()
	
	if ship_path:
		ship = get_node(ship_path)
	
	incoming_timer.connect("timeout", self, "start_solar_storm")
	active_timer.connect("timeout", self, "end_solar_storm")

func _process(delta):
	var rnd = randf()
	
	if rnd < chance and not active and ship.separated:
		active = true
		#alert.show()
		get_node(ui_path).print_message("Solar storm incoming!\nUse your shield!", 3.0)
		incoming_timer.wait_time = alert_time
		incoming_timer.start()
		emit_signal("solar_storm_incoming")
		
func start_solar_storm():
	alert.hide()
	incoming_timer.stop()
	active_timer.wait_time = duration
	emit_signal("solar_storm_started")
	active_timer.start()
	ship.storm()
	show()
	
func end_solar_storm():
	active_timer.stop()
	emit_signal("solar_storm_ended")
	hide()
	active = false		