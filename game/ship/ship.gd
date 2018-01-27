extends KinematicBody

signal destroyed
var dead = false

export var track_distance = 5.0

func get_speed():  return $attributes/speed.value
func has_shield(): return $attributes/shield.value > 0

func damage():
	if has_shield():
		$attributes/shield.raw_value -= 1
		return
	
	death()

func death():
	dead = true
	emit_signal("destroyed")

func move_left():
	if $anim.is_playing(): return
	$anim.play("tilt_left")
	
	var duration = $anim.current_animation_length / $anim.playback_speed
	var speed = track_distance / duration
	
	$actions/turn.execute([Vector3(-speed, 0, 0), duration])

func move_right():
	if $anim.is_playing(): return
	$anim.play("tilt_right")
	
	var duration = $anim.current_animation_length / $anim.playback_speed
	var speed = track_distance / duration
	
	$actions/turn.execute([Vector3(speed, 0, 0), duration])

func mod_speed(speed_multiplier, duration):
	$attributes/speed.add_percent_modifier(speed_multiplier, duration)


## DEBUG
#
#func _ready():
#	pass#$attributes/speed.connect("changed", self, "print_speed")
#
#func print_speed():
#	print(str($attributes/speed.value))
#
#func _input(event):
#	if event.is_action_pressed("ui_left"):
#		move_left()
#	elif event.is_action_pressed("ui_right"):
#		move_right()
#	elif event.is_action_pressed("ui_up"):
#		mod_speed(1.0, 1.0)
#	elif event.is_action_pressed("ui_down"):
#		mod_speed(-0.5, 1.0)
#	elif event.is_action_pressed("ui_cancel"):
#		print_speed()