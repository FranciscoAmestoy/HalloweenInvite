extends Node

var global_time = 6.0
var full_cycle_duration_seconds = 10

func _process(_delta):
	var time_scale = 24.0 / full_cycle_duration_seconds
	global_time += _delta * time_scale
	if global_time >= 24.0:
		global_time = 0.0
