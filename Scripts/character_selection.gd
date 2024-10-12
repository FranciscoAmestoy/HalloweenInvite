extends Node2D

var dark_modulate = Color(0.5, 0.5, 0.5) # Darkened color for default state
var hover_modulate = Color(1, 1, 1) # Bright color for hover
var hover_sound = preload("res://Assets/SFX/charHover.mp3")
var select_sound = preload("res://Assets/SFX/charSelect.mp3")
var sfx_player = null
var background_music_player = null

func _ready() -> void:
	# Initialize AudioStreamPlayers
	background_music_player = $BackgroundMusic
	sfx_player = $SFXPlayer
	
	# Darken characters by default
	$TextureRect/Yan.modulate = dark_modulate
	$TextureRect/Lore.modulate = dark_modulate
	$TextureRect/Agus.modulate = dark_modulate

# Yan hover event
func _on_yan_focus_entered() -> void:
	$TextureRect/Yan.modulate = hover_modulate # Brighten Yan
	sfx_player.stream = hover_sound
	sfx_player.play() # Play hover sound

# Yan hover exit event
func _on_yan_focus_exited() -> void:
	$TextureRect/Yan.modulate = dark_modulate # Darken Yan

# Yan select event
func _on_yan_pressed() -> void:
	Global.character = "Yan"
	sfx_player.stream = select_sound
	sfx_player.play() # Play select sound
	await get_tree().create_timer(0.3).timeout # Wait for sound to finish
	get_tree().change_scene_to_file("res://Scenes/world.tscn") # Change scene

# Lore hover event
func _on_lore_focus_entered() -> void:
	$TextureRect/Lore.modulate = hover_modulate
	sfx_player.stream = hover_sound
	sfx_player.play()

# Lore hover exit event
func _on_lore_focus_exited() -> void:
	$TextureRect/Lore.modulate = dark_modulate

# Lore select event
func _on_lore_pressed() -> void:
	Global.character = "Lore"
	sfx_player.stream = select_sound
	sfx_player.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

# Agus hover event
func _on_agus_focus_entered() -> void:
	$TextureRect/Agus.modulate = hover_modulate
	sfx_player.stream = hover_sound
	sfx_player.play()

# Agus hover exit event
func _on_agus_focus_exited() -> void:
	$TextureRect/Agus.modulate = dark_modulate

# Agus select event
func _on_agus_pressed() -> void:
	Global.character = "Agus"
	sfx_player.stream = select_sound
	sfx_player.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
