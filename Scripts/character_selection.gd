extends Node2D


func _on_yan_pressed() -> void:
	Global.character = "Yan"
	get_tree().change_scene_to_file("res://Scenes/world.tscn") # Replace with function body.


func _on_lore_pressed() -> void:
	Global.character = "Lore"
	get_tree().change_scene_to_file("res://Scenes/world.tscn") # Replace with function body.


func _on_agus_pressed() -> void:
	Global.character = "Agus"
	get_tree().change_scene_to_file("res://Scenes/world.tscn") # Replace with function body.
