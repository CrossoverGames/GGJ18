extends KinematicBody

var ship

export var direction = Vector3()

func _ready():
	var ships = get_tree().get_nodes_in_group("ship")
	if ships.empty():
		ship = null
		return
	
	ship = ships[0]
	ship.connect("destroyed", self, "set_process", [false])

func _process(delta):
	if ship == null: return
	
	var speed = direction.y - ship.get_speed()
	move_and_collide(Vector3(0, speed, 0) * delta)

func _physics_process(delta):
	move_and_collide(direction * delta)
