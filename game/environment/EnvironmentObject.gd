extends KinematicBody

export var active = true
export var delay_time = 0

var ship

var time = -1

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
	
	if active:
		var speed = direction.y - ship.get_speed()
		move_and_collide(Vector3(0, speed, 0) * delta)
	elif time > -1:
		time -= delta
		if time <= 0:
			time = 0
			active = true

func _physics_process(delta):
	move_and_collide(direction * delta)

func set_active(set):
	active = set

func set_time():
	time = delay_time
