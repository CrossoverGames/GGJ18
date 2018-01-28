extends Spatial

export(float) var chance = 0.02
export(NodePath) var ship_path
export(int) var alert_time = 2
export(float) var duration = 5.0

onready var incoming_timer = get_node("incoming")
onready var active_timer = get_node("active")

var ship
var active = false

signal solar_storm_incoming
signal solar_storm_started
signal solar_storm_ended

func _ready():
	hide()
	
	if ship_path:
		ship = get_node(ship_path)
	
	incoming_timer.connect("timeout", self, "start_solar_storm")
	active_timer.connect("timeout", self, "end_solar_storm")

func _process(delta):
	var rnd = randf()
	
	if rnd < chance and not active and ship.flying:
		active = true
		incoming_timer.wait_time = alert_time
		incoming_timer.start()
		emit_signal("solar_storm_incoming")
		
func start_solar_storm():
	incoming_timer.stop()
	active_timer.wait_time = duration
	emit_signal("solar_storm_started")
	active_timer.start()
	show()
	
func end_solar_storm():
	active_timer.stop()
	emit_signal("solar_storm_ended")
	hide()
	active = false		