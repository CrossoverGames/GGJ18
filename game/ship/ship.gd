extends KinematicBody

signal destroyed
signal in_danger
signal separated

var dead = false
var elapsed_time = 0.0
var flying = false
var separated = false

export(NodePath) var ui_path = @"../interface"
onready var ui = get_node(ui_path)

export(NodePath) var tracks_path = @"../tracks"
onready var tracks = get_node(tracks_path)

export(NodePath) var storm_path = @"../solar_storm"
onready var storm = get_node(storm_path)

export(float) var shield_duration = 15.0
onready var shield_timer = get_node("shield/timer")

onready var shield = get_node("shield")

onready var sound_takeoff = get_node("takeoff")
onready var sound_engine = get_node("engine")

var track_number = 0
var shield_active = false
var end = false

func get_speed():  return $attributes/speed.value
func has_shield(): return $attributes/shield.value > 0

func _ready():
	shield.hide()
	shield_timer.connect("timeout", self, "end_shield")
	$actions/turn.connect("finished", self, "check_track")

enum BTN_TYPE {
	action = 0,
	move_left = 1,
	move_right = 2,
	boost = 3,
	brk = 4,
	shield = 5
}

func damage():
	if has_shield():
		$attributes/shield.raw_value -= 1
		ui.set_health($attributes/shield.value + 1)
		return
	
	ui.set_health(0)
	death()
	
func storm():
	if not shield_active:
		ui.storm_affected()
	
func activate_shield():
	shield_active = true
	shield_timer.wait_time = shield_duration
	shield_timer.start()
	shield.show()
	
func end_shield():
	shield_timer.stop()
	shield_active = false
	shield.hide()
	
func land():
	end = true
	if track_number < 0:
		$anim.play("tilt_right")
	elif track_number > 0:
		$anim.play("tilt_left")
	if track_number != 0:
		track_number = 0
		move_side()
		yield($anim, "animation_finished")
	$anim.play("land")
	yield($anim, "animation_finished")
	$attributes/speed.value = 0

func death():
	dead = true
	emit_signal("destroyed")
	hide()

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
	var speed = 0
	if duration != 0:
		speed = distance / duration
	$actions/turn.execute([Vector3(speed, 0, 0), duration])

func mod_speed(speed_multiplier, duration):
	$attributes/speed.add_percent_modifier(speed_multiplier, duration)
	
func mod_shield(shield_multiplier, duration):
	shield.show()
	$attributes/shield.add_percent_modifier(shield_multiplier, duration)

func check_track():
	if tracks.is_in_danger(track_number):
		emit_signal("in_danger")
	elif tracks.is_outside(track_number):
		death()

func _process(delta):
	if flying:
		elapsed_time += delta
		
func launch():
	$attributes/speed.value = 10
	#$rockets/Particles.emitting = true
	get_parent().get_node("KinematicBody/launch platform/AnimationPlayer").play("launch")
	sound_takeoff.play()
	sound_engine.play()
	
func signal_arrived(type):
	if end:
		return
	
	if type == BTN_TYPE.action:
		if not flying:
			flying = true
			launch()
			# particles, anim, etc
		elif not separated:
			separated = true
			$KinematicBody/rockets/AnimationPlayer.play("decouple")
			$KinematicBody.set_time()
			$mesh/Particles.emitting = true
			$mesh/Particles2.emitting = true
			$mesh/Particles3.emitting = true
			$mesh/Particles4.emitting = true
			yield($KinematicBody/rockets/AnimationPlayer, "animation_finished")
			emit_signal("separated")
			$KinematicBody.queue_free()
			get_parent().get_node("camera_control").play("menu_to_decouple")
	
	if not separated: return
	
	if type == BTN_TYPE.move_left:
		print("received signal move left")
		move_left()
	elif type == BTN_TYPE.move_right:
		print("received signal move right")
		move_right()
	elif type == BTN_TYPE.boost:
		print("received signal boost")
		mod_speed(1.0, 1.0)
	elif type == BTN_TYPE.brk:
		print("received signal break")
		mod_speed(-0.5, 1.0)
	elif type == BTN_TYPE.shield:
		print("received signal shield")
		activate_shield()

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
