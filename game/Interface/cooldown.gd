extends TextureButton

export var time = 2.0

func _ready():
	pass

func activate_cooldown():
	self.disabled = true
	
