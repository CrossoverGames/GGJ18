extends "action.gd"

export(NodePath) var signal_particle_path
export(int) var signal_speed = 10

var signal_particle
var initial_pos
var active = false

func _ready():
	if signal_particle_path:
		signal_particle = get_node(signal_particle_path)
		initial_pos = signal_particle.get_translation()
		signal_particle.hide()
	set_process(false)

func _execute(args):
	signal_particle.show()
	active = true
	set_process(true)

func _process(delta):
	var ship_pos = ship.get_translation()
	var move_dir = ship_pos - signal_particle.get_translation()
	var dir = move_dir.normalized()
	
	signal_particle.set_translation(delta * signal_speed * dir)
	
	if signal_particle.get_translation() == ship_pos:
		signal_particle.hide()
		signal_particle.set_translation(initial_pos)
		active = false
		set_process(false)