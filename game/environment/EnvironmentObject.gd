extends KinematicBody

var ship

export var direction = Vector3()

func _ready():
	ship = get_tree().get_nodes_in_group("ship")[0]
	ship.connect("destroyed", self, "set_process", [false])

func _process(delta):
	var speed = direction.y - ship.get_speed()
	move_and_collide(Vector3(0, speed, 0) * delta)

func _physics_process(delta):
	move_and_collide(direction * delta)
