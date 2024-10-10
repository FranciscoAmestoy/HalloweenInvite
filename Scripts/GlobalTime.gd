extends Node

var global_time = 5.0
var full_cycle_duration_seconds = 120  # Duration of a full 24-hour cycle in real seconds

# Simple rain control variables
var is_raining = false
var rain_duration = 7200  # Fixed duration for rain in seconds
var rain_timer = 0.0  # Timer to keep track of rain duration
var check_interval = 5  # How often to check for rain in seconds
var chance_of_rain = 1/1.5  # Chance to start raining on each check

# Timer node to control rain checks
var rain_check_timer: Timer

func _ready():
	randomize()
	rain_check_timer = Timer.new()
	rain_check_timer.wait_time = check_interval
	rain_check_timer.autostart = true
	rain_check_timer.one_shot = false
	add_child(rain_check_timer)
	rain_check_timer.connect("timeout", Callable(self, "_on_RainCheckTimer_timeout"))

func _process(_delta):
	var time_scale = 24.0 / full_cycle_duration_seconds
	global_time += _delta * time_scale
	if global_time >= 24.0:
		global_time = 0.0  # Reset after completing a cycle

	if is_raining:
		rain_timer += _delta
		if rain_timer >= rain_duration:
			is_raining = false
			rain_timer = 0.0  # Reset the timer for the next rain event

# Handler for the rain check timer's timeout signal
func _on_RainCheckTimer_timeout():
	if not is_raining and randf() < chance_of_rain:
		# Not raining, so start the rain
		is_raining = true
		rain_timer = 0.0  # Reset rain timer
