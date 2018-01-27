extends Spatial

export(PackedScene) var asteroid_scene
export(NodePath) var tracks_path = @"../tracks"
export var rate = 1.0
export var speed = 5.0
export var start_active = true

onready var tracks = get_node(tracks_path)

func _ready():
	if start_active: setup()

func setup():
	$cleaner.connect("area_entered", self, "enter_cleaner")
	
	var pos_count = tracks.track_amount
	var it = -floor(pos_count * 0.5)
	for i in range(pos_count):
		var x = tracks.track_x(it + i)
		var position = Position3D.new()
		position.translation.x = x
		position.name = "position-" + str(i)
		$positions.add_child(position)
	
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = rate
	timer.connect("timeout", self, "spawn_asteroid")
	add_child(timer)

func spawn_asteroid():
	var positions = $positions.get_children()
	var index = randi() % positions.size()
	var asteroid = asteroid_scene.instance()
	positions[index].add_child(asteroid)
	
	asteroid.direction = Vector3(randf(), -randf(), 0).normalized() * speed
	if randf() > 0.5: asteroid.direction.x *= -1.0

func enter_cleaner(body):
	if body.is_in_group("obstacle"):
		body.queue_free()
