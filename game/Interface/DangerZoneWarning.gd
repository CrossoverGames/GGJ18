extends Control

export var time_to_disappear = 3.0

func appear():
	$anim.play("appear")
	yield(get_tree().create_timer(time_to_disappear), "timeout")
	disappear()

func disappear():
	$anim.play("disappear")
