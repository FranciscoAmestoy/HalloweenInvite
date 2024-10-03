extends CanvasLayer  # or Control, depending on your root node

func _ready():
	pass

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/startscreen.tscn")
