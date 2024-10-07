#player
# Extending the CharacterBody2D class to create a custom player character
extends CharacterBody2D

# Declare variables for movement speed, last direction, animated sprite, and enemy detection
var speed = 100 # Movement speed of the player
var last_direction = Vector2.RIGHT # Default direction the player is facing (right)
var animated_sprite # Reference to the animated sprite node
var enemy_in_range = false # Flag to track if an enemy is within range
var is_dead = false # Flag to track if the player is dead
var is_attacking = false
var attack_timer = 0.0
var attack_duration = 0.5 # Time in seconds
var current_target: Node = null

# _ready function is called when the node is added to the scene
func _ready():
	animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
	add_to_group("Player") # Add the player to the "Player" group

	
func _physics_process(delta):
	update_health()
	die()
	update_animation()
	move_and_slide()
	
	
	if is_attacking:
		attack_timer += delta
		if attack_timer >= attack_duration:
			is_attacking = false
			attack_timer = 0.0
			if current_target and current_target.is_in_group("Enemy"):
				attack_target(current_target)  # Call attack_target function

func take_damage(amount):
	Global.health -= amount
	# Any other logic when the player takes damage

					
func attack_target(target: Node):
	if target and target.is_in_group("Enemy"):
		target.take_damage(Global.player_level * 20)

	
func update_health():
	var healthbar = $healthbar
	healthbar.value = Global.health
	if Global.health >= 100:
		healthbar.visible = false
	else: 
		healthbar.visible = true

func update_target(new_target: Node):
	current_target = new_target


func update_animation():
	if is_dead:
		return # If the player is dead, exit the function and don't change the animation
	
	var animation_prefix = Global.character + "_"
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

	if direction != Vector2.ZERO:
		last_direction = direction.normalized()

	var anim = ""
	if is_attacking:
		if last_direction.y < 0:
			anim = "attack_up"
		elif last_direction.y > 0:
			anim = "attack_down"
		elif last_direction.x != 0:
			anim = "attack_right"		
	elif direction.x != 0:
		anim = "walk_right"
	elif direction.y < 0:
		anim = "walk_up"
	elif direction.y > 0:
		anim = "walk_down"
	elif direction == Vector2.ZERO:
		anim = "idle_" + ("right" if last_direction.x != 0 else "up" if last_direction.y < 0 else "down")

	animated_sprite.play(animation_prefix + anim)
	animated_sprite.flip_h = last_direction.x < 0


func _input(event):
	if event.is_action_pressed("ui_select"): 
		is_attacking = true
		attack_timer = 0.0
		# Check which character is selected and play the corresponding attack sound
		if Global.character == "bazza":
			$bazza_attack.play()
		else:
			$shazza_attack.play()



func die():
	if Global.health <= 0 and not is_dead:
		is_dead = true
		animated_sprite.play(Global.character + "_die")



func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = true 
		update_target(body)
		
# Function called when a body exits the player's hitbox (e.g., enemy leaves detection range)
func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = false
		if body == current_target:
			current_target = null


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation.ends_with("die"):
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
