extends PointLight2D

func _process(_delta):
	if Global.has_stick:
		var time_of_day = fmod(GlobalTime.global_time, 24.0)
		if time_of_day >= 21.0 or time_of_day < 6.0:
			visible = true
		else:
			visible = false
	else:
			visible = false
