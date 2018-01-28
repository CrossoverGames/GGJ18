extends Node

export(int) var draw_chance = 3

var moon1 = preload("res://environment/background/moon1.tscn")
var moon2 = preload("res://environment/background/moon2.tscn")
var moon3 = preload("res://environment/background/moon3.tscn")
var belt = preload("res://environment/background/belt.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var chance = randi()%100
	
	if chance > (100 - draw_chance):
		var rnd = randi()%4
		var x_rnd = (randi()%20 - 10)
		
		print(x_rnd)
		
		if rnd == 0:
			var mn1 = moon1.instance()
			add_child(mn1)
			mn1.set_translation(Vector3(x_rnd, 0, 0))
		elif rnd == 1:
			var mn2 = moon2.instance()
			add_child(mn2)
			mn2.set_translation(Vector3(x_rnd, 0, 0))
		elif rnd == 2:
			var mn3 = moon3.instance()
			add_child(mn3)
			mn3.set_translation(Vector3(x_rnd, 0, 0))
		elif rnd == 3:
			var blt = belt.instance()
			add_child(blt)
			blt.set_translation(Vector3(x_rnd, 0, 0))