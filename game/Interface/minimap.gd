extends TextureRect

export(String) var signal_interface_path = "res://"

func _ready():
	pass
	
func create_signal(speed):
	var new_signal = load(signal_interface_path).instance()
	add_child(animation)
	
	var animation = new_signal.get_child()
	new_signal.show()
	
	animation.playback_speed = 0.5

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
