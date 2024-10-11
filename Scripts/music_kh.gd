extends Area2D

var fade_duration = 1.5 # Duration of fade in/out in seconds
var is_fading_out = false
var fade_timer = 0.0
var player_in_area = false
var audio_player: AudioStreamPlayer2D

func _ready():
	audio_player = $CollisionShape1/Music1
	audio_player.volume_db = -80 # Start with volume muted

func _process(delta: float) -> void:
	if player_in_area:
		fade_in(delta)
	elif is_fading_out:
		fade_out(delta)

func fade_in(delta: float) -> void:
	if audio_player.volume_db < 0:
		fade_timer += delta
		audio_player.volume_db = lerp(-80, 0, fade_timer / fade_duration)
		if audio_player.volume_db >= 0:
			audio_player.volume_db = 0 # Ensure it caps at 0

func fade_out(delta: float) -> void:
	if audio_player.volume_db > -80:
		fade_timer += delta
		audio_player.volume_db = lerp(0, -80, fade_timer / fade_duration)
		if audio_player.volume_db <= -80:
			audio_player.volume_db = -80
			is_fading_out = false
			audio_player.stop() # Stop the audio once fully faded out

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		audio_player.stop() # Ensure the track restarts
		audio_player.play() # Start the track
		player_in_area = true
		is_fading_out = false
		fade_timer = 0.0 # Reset fade timer for fade in


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
		is_fading_out = true
		fade_timer = 0.0 # Reset fade timer for fade out
