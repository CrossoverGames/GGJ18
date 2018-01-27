extends Node

export(float) var track_size = 5.0
export(int, 3, 25, 2) var track_amount = 9
export(int, 25) var danger_zone = 2

func track_x(n):
	return n * track_size

func is_in_danger(n):
	var side = floor(track_amount * 0.5)
	
	if abs(n) > side:
		return null
	
	return abs(n) > side - danger_zone

func is_outside(n):
	return abs(n) > floor(track_amount * 0.5)
