extends Node

########################################

signal changed
signal modifier_applied(modifier)

export(NodePath) var max_path = @"max"
export(NodePath) var min_path = @"min"
var attr_max
var attr_min

export(bool) var must_be_positive = true
export(float) var raw_value = 100.0 setget set_raw_value

var value setget set_raw_value, get_value

########################################

func _ready():
	if has_node(max_path):
		attr_max = get_node(max_path)
		attr_max.connect("changed", self, "emit_signal", ["changed"])
	if has_node(min_path):
		attr_min = get_node(min_path)
		attr_min.connect("changed", self, "emit_signal", ["changed"])

func set_raw_value(raw):
	if raw_value == raw: return
	raw_value = raw
	emit_signal("changed")

func get_value():
	var bonus = 0.0
	var multiplier = 1.0
	
	for child in get_children():
		if child is Modifier:
			bonus += child.bonus
			multiplier += child.percent
	
	value = raw_value * multiplier + bonus
	if attr_max: value = min(value, attr_max.value)
	if attr_min: value = max(value, attr_min.value)
	if must_be_positive: value = max(0.0, value)
	
	return value

################################################################################
################################################################################

class Modifier extends Node:
	var bonus   = 0.0 setget set_bonus
	var percent = 0.0 setget set_percent
	var timeout = 0.0
	
	func _enter_tree():
		if timeout <= 0: set_process(false)
		else: set_process(true)
		connect("tree_exited", get_parent(), "emit_signal", ["changed"])
	
	func _process(delta):
		timeout -= delta
		if timeout <= 0:
			queue_free()
	
	func set_bonus(value):
		if bonus == value: return
		bonus = value
		if is_inside_tree(): get_parent().emit_signal("changed")
	
	func set_percent(value):
		if percent == value: return
		percent = value
		if is_inside_tree(): get_parent().emit_signal("changed")

########################################

func add_bonus_modifier(bonus, timeout = 0.0):
	return add_modifier(bonus, 0.0, timeout)

func add_percent_modifier(percent, timeout = 0.0):
	return add_modifier(0.0, percent, timeout)

func add_modifier(bonus, percent, timeout = 0.0):
	var modifier = Modifier.new()
	modifier.bonus = bonus
	modifier.percent = percent
	modifier.timeout = timeout
	add_child(modifier)
	
	emit_signal("modifier_applied", modifier)
	emit_signal("changed")
	return modifier

func remove_modifier(modifier):
	if modifier in get_children():
		modifier.queue_free()

################################################################################
################################################################################
