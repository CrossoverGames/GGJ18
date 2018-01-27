extends Spatial

export(float) var delay = 0

onready var arrive_timer = get_node("Timer")

var type = 0
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_arrive_timer(time):
	delay = time
	arrive_timer.wait_time = time
	
func set_type(value):
	type = value
	
func start_timer():
	arrive_timer.start()