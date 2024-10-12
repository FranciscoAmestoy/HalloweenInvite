extends PointLight2D

func _process(_delta):
	if Global.has_stick == true:
		visible = true
	else:
		visible = false
