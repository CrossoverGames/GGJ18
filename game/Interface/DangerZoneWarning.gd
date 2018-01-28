extends Control

export(NodePath) var ui_path
export var time_to_disappear = 3.0

func appear():
	$anim.play("appear")
	get_node(ui_path).print_message("Attention! Signal is weak if you deviate from your route!\nDon't get too far!", 3.0)
	
	yield(get_tree().create_timer(time_to_disappear), "timeout")
	disappear()

func disappear():
	$anim.play("disappear")
