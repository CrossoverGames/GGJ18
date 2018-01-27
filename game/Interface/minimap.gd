extends TextureRect

export(String) var signal_interface_path = "res://"

func _ready():
	pass
	
func create_signal(speed):
	var new_signal = load(signal_interface_path).instance()
	add_child(new_signal)
	
	var animation = new_signal.get_node("AnimationPlayer")
	new_signal.show()
	
	animation.connect("animation_finished", self, "clear_signal", [new_signal])
	
	animation.playback_speed = speed
	
	animation.play("transmit")
	
func clear_signal(animation_name, node):
	node.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
