extends Node

export(int) var draw_chance = 3

var moon1 = preload("res://environment/background/moon1.tscn")
var moon2 = preload("res://environment/background/moon2.tscn")
var moon3 = preload("res://environment/background/moon3.tscn")
var belt = preload("res://environment/background/belt.tscn")

onready var delete_area = get_node("Area")

export(NodePath) var ship_path

var ship

func _ready():
	if ship_path:
		ship = get_node(ship_path)
		
	delete_area.connect("body_entered", self, "delete_body")
	
func delete_body(body):
	if body.is_in_group("background"):
		body.queue_free()

func _process(delta):
	var chance = randi()%100
	
	if (chance > (100 - draw_chance)) and ship.flying:
		var rnd = randi()%4
		var x_rnd = (randi()%200 - 100)
		var z_rnd = (randi()%30 - 45)
		var scale_rnd = (randi()%20 + 1)
		
		print(x_rnd)
		
		if rnd == 0:
			var mn1 = moon1.instance()
			add_child(mn1)
			mn1.set_translation(Vector3(x_rnd, 120, z_rnd))
			mn1.set_scale(Vector3(scale_rnd, scale_rnd, scale_rnd))
		elif rnd == 1:
			var mn2 = moon2.instance()
			add_child(mn2)
			mn2.set_translation(Vector3(x_rnd, 120, z_rnd))
			mn2.set_scale(Vector3(scale_rnd, scale_rnd, scale_rnd))
		elif rnd == 2:
			var mn3 = moon3.instance()
			add_child(mn3)
			mn3.set_translation(Vector3(x_rnd, 120, z_rnd))
			mn3.set_scale(Vector3(scale_rnd, scale_rnd, scale_rnd))
		elif rnd == 3:
			var blt = belt.instance()
			add_child(blt)
			blt.set_translation(Vector3(x_rnd, 120, z_rnd))
			blt.set_scale(Vector3(scale_rnd, scale_rnd, scale_rnd))