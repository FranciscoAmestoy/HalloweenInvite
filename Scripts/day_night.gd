extends CanvasModulate

func _process(_delta):
	var time_of_day = fmod(GlobalTime.global_time, 24.0)
	
	if time_of_day >= 6.0 and time_of_day < 21.0:
		visible = false
	else:
		visible = true
