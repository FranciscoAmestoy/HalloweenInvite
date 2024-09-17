# Extending the CharacterBody2D class to create a custom player character
extends CharacterBody2D

# Declare variables for movement speed, last direction, animated sprite, and enemy detection
var speed = 100 # Movement speed of the player
var last_direction = Vector2.RIGHT # Default direction the player is facing (right)
var animated_sprite # Reference to the animated sprite node
var enemy_in_range = false # Flag to track if an enemy is within range

# _ready function is called when the node is added to the scene
func _ready():
	animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
	add_to_group("Player") # Add the player to the "Player" group

# _physics_process function is called every physics frame (typically 60 times per second)
func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Get player input for movement
	velocity = direction * speed # Calculate velocity based on input and speed
	
	# Update the last direction if the player is moving
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
		
	# Animation handling based on movement direction
	if direction.x != 0:
		animated_sprite.play("Testchar_walk_right") # Play walking right animation
	elif direction.y < 0:
		animated_sprite.play("Testchar_walk_up") # Play walking up animation
	elif direction.y > 0:
		animated_sprite.play("Testchar_walk_down") # Play walking down animation
	elif direction == Vector2.ZERO:
		# Play idle animations based on the last direction the player was facing
		if last_direction.x != 0:
			animated_sprite.play("Testchar_idle_right")
		elif last_direction.y < 0:
			animated_sprite.play("Testchar_idle_up")
		elif last_direction.y > 0:
			animated_sprite.play("Testchar_idle_down")
	
	# Flip the sprite horizontally if the player is facing left
	animated_sprite.flip_h = last_direction.x < 0
	
	# Move the character using the calculated velocity
	move_and_slide()

# Function called when a body exits the player's hitbox (e.g., enemy leaves detection range)
func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = false # Set enemy detection flag to false
		print("Enemy exited the hitbox!") # Debug message for when the enemy exits

# Function called when a body enters the player's hitbox (e.g., enemy detected)
func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = true # Set enemy detection flag to true
		print("Getting Swooped!") # Debug message for when the enemy enters
