extends Node2D

var change_scene = false
var current_scene = "cave"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_scenes():
	if change_scene == true:
		if current_scene == "cave":
			get_tree().change_scene_to_file("res://Scenes/world.tscn")
		


func _on_world_body_entered(body):
	if body.is_in_group("Player"):
		change_scene = true
		change_scenes()
		
