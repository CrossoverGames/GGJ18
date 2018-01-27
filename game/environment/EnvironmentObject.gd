extends KinematicBody

var ship

export var direction = Vector2()

func _ready():
	ship = get_tree().get_nodes_in_group("ship")[0]

func _process(delta):
	var speed = direction.y - ship.get_speed()
	move_and_collide(Vector3(0, speed, 0) * delta)
