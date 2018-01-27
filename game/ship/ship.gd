extends KinematicBody

signal destroyed

func has_shield():
	return $attributes/shield.value > 0

func damage():
	if has_shield():
		$attributes/shield.raw_value -= 1
		return
	
	death()

func death():
	emit_signal("destroyed")

func receive_move(direction, duration):
	$actions/move.execute([direction, duration])
