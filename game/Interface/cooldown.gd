extends TextureButton

export var time = 2.0
var timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.connect("timeout", self, "set_disabled", [false])
	add_child(timer)
	connect("pressed", self, "activate_cooldown")

func activate_cooldown():
	self.disabled = true
	timer.wait_time = time
	timer.start()
