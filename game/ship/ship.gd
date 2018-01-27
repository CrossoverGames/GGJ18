extends RigidBody

signal destroyed

func has_shield():
	return $shield.value > 0

func damage():
	if has_shield():
		$shield.raw_value -= 1
		return
	
	death()

func death():
	emit_signal("destroyed")

func receive_move(velocity):
	linear_velocity += velocity
