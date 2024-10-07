extends Node2D


func _on_bazza_pressed() -> void:
	Global.character = "bazza"
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_shazza_pressed() -> void:
	Global.character = "shazza"
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
