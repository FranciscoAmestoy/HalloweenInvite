extends Node2D

var current_scene = "world"
var change_scene = false

func _ready():
	if Global.last_world_position != Vector2(0,0):
		$TileMapGrass/TileMapTreesFiller2/player.position = Global.last_world_position + Vector2(0,5)

func _on_cave_body_entered(body):
	if body.is_in_group("Player"):
		Global.last_world_position = $TileMapGrass/TileMapTreesFiller2/player.position
		change_scene = true
		change_scenes()

func change_scenes():
	if change_scene == true:
		if current_scene == "world":
			get_tree().change_scene_to_file("res://Scenes/cave.tscn")
