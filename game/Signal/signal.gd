extends Spatial

export(float) var delay = 0

onready var arrive_timer = get_node("Timer")

var type = 0
var ship
	
func _ready():
	arrive_timer.connect("timeout", self, "signal_arrived")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func signal_arrived():
	if ship:
		ship.signal_arrived(type)
		stop_timer()

func set_arrive_timer_and_start(time):
	delay = time
	arrive_timer.wait_time = time
	start_timer()
	
func set_type(value):
	type = value
	
func start_timer():
	arrive_timer.start()
	
func stop_timer():
	arrive_timer.stop()