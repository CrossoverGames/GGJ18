extends "../EnvironmentObject.gd"

export var angular_speed = 30

func _ready():
	$Area.connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if not body.is_in_group("ship"): return
	body.elapsed_time = 0.0

func _process(delta):
	#$mesh.rotation_degrees.y += deg2rad(180) * delta
	$mesh.rotate_y(deg2rad(angular_speed) * delta)
