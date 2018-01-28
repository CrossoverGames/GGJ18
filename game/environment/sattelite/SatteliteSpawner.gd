extends Spatial

export(PackedScene) var sattelite_scene
export var interval = 15.0

func setup():
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = interval
	timer.autostart = true
	timer.connect("timeout", self, "spawn_sattelite")
	add_child(timer)

func spawn_sattelite():
	var sat = sattelite_scene.instance()
	add_child(sat)
