extends Spatial

func _ready():
	$Area.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("ship"):
		ship.heal()
