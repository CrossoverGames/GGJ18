extends KinematicBody

signal destroyed
signal in_danger

var dead = false
var elapsed_time = 0.0
var flying = false

export(NodePath) var tracks_path = @"../tracks"
onready var tracks = get_node(tracks_path)

var track_number = 0

func get_speed():  return $attributes/speed.value
func has_shield(): return $attributes/shield.value > 0

func _ready():
	$actions/turn.connect("finished", self, "check_track")

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2
}

func damage():
	if has_shield():
		$attributes/shield.raw_value -= 1
		return
	
	death()

func death():
	dead = true
	emit_signal("destroyed")
	queue_free()

func move_left():
	if $anim.is_playing(): return
	$anim.play("tilt_left")
	
	track_number -= 1
	move_side()

func move_right():
	if $anim.is_playing(): return
	$anim.play("tilt_right")
	
	track_number += 1
	move_side()

func move_side():
	var distance = (tracks.track_x(track_number) - self.translation.x)
	var duration = $anim.current_animation_length / $anim.playback_speed
	var speed = distance / duration
	$actions/turn.execute([Vector3(speed, 0, 0), duration])

func mod_speed(speed_multiplier, duration):
	$attributes/speed.add_percent_modifier(speed_multiplier, duration)

func check_track():
	if tracks.is_in_danger(track_number):
		emit_signal("in_danger")
	elif tracks.is_outside(track_number):
		death()

func _process(delta):
	if flying:
		elapsed_time += delta
	
func signal_arrived(type):
	if type == BTN_TYPE.action:
		if not flying:
			flying = true
	elif type == BTN_TYPE.move_left:
		print("received signal move left")
		move_left()
	elif type == BTN_TYPE.move_right:
		print("received signal move right")
		move_right()
# DEBUG

func print_speed():
	print(str($attributes/speed.value))

# DEBUG
func _input(event):
	if event.is_action_pressed("ui_left"):
		move_left()
	elif event.is_action_pressed("ui_right"):
		move_right()
	elif event.is_action_pressed("ui_up"):
		mod_speed(1.0, 1.0)
	elif event.is_action_pressed("ui_down"):
		mod_speed(-0.5, 1.0)
