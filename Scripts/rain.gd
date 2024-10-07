extends Node2D

func _process(_delta):
	if GlobalTime.is_raining:
		visible = true
	else:
		visible = false
