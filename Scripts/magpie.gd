# Extending the CharacterBody2D class to create a custom enemy character
extends CharacterBody2D

# Declare variables for movement speed, last direction, animated sprite, and direction change timer
var speed = 50
var last_direction = Vector2.ZERO
var animated_sprite
var direction_change_timer = 0
var direction_change_interval = 3 # seconds
var swoop_speed = 75 # Speed when swooping towards the player
var swoop = false # Flag to determine if the magpie is swooping towards the player
var player = null # Reference to the player
var player_in_range = false # Flag to track if the player is within range
var health = 1
var is_dead = false
var damage_timer = 0.0
var damage_interval = 0.5 # Time in seconds to damage player
var damage_from_player_timer = 0.0
var damage_from_player_interval = 0.5 # Time in seconds to damage Magpie
var is_attacking = false
# Define the boundaries of the area where the magpie can fly (in pixels)
var min_position = Vector2(0, 0)
var max_position = Vector2(800, 430)

# _ready function is called when the node is added to the scene
# For arduino fans, think of the _ready function like ‘void setup’
func _ready():
	animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
	pick_random_direction() # Pick an initial random direction for the enemy
	add_to_group("Enemy")
# _physics_process function is called every physics frame (typically 60 times per second)
# For arduino fans, think of the _physics_process function like ‘void loop’
func _physics_process(delta):
	if player_in_range:
		damage_from_player_timer += delta
		if damage_from_player_timer >= damage_from_player_interval and player.is_attacking:
			health -= 10
			print("Magpie Health: ", health)
			damage_from_player_timer = 0.0
		
	update_health()
	die()
	
	if swoop:
		var direction_to_player = (player.position - position).normalized()
		velocity = direction_to_player * swoop_speed
		update_animation(direction_to_player, true) # Pass true for swoop
	else:
		direction_change_timer += delta
		if direction_change_timer >= direction_change_interval:
			pick_random_direction()
			direction_change_timer = 0
		
		velocity = last_direction * speed
		update_animation(last_direction)

	move_and_slide()

	var old_position = position
	position.x = clamp(position.x, min_position.x, max_position.x)
	position.y = clamp(position.y, min_position.y, max_position.y)

	if old_position != position:
		last_direction = -last_direction
		
	if player_in_range:
		damage_timer += delta
	if damage_timer >= damage_interval:
		Global.health -= 34  # Reduce health
		damage_timer = 0.0

		
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 1:
		healthbar.visible = false
	else: 
		healthbar.visible = false

func die():
	if health <= 0 and not is_dead:
		is_dead = true
		queue_free()
			
# Modified update_animation function
func update_animation(direction, swooping=false):
	if is_dead or is_attacking:
		return

	# Reset flips before setting new values
	animated_sprite.flip_h = false
	animated_sprite.flip_v = false

	# Handle horizontal movement (left/right)
	if direction.x != 0:
		animated_sprite.play("fly_right")
		animated_sprite.flip_h = direction.x < 0 # Flip horizontally for left

	# Handle vertical movement (up/down)
	elif direction.y < 0:
		animated_sprite.play("fly_up")
	elif direction.y > 0:
		animated_sprite.flip_v = true

	if player_in_range and swooping:
		is_attacking = true
	else:
		is_attacking = false


func pick_random_direction():
	var new_direction = Vector2.ZERO
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction


func _on_territory_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		if Global.has_stick:  # Check the flag
			swoop = false  # Fly away
		else:
			swoop = true  # Attack

func _on_territory_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		swoop = false
		pick_random_direction()
		update_animation(last_direction)

func _on_magpie_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		swoop_speed = 0
		print("Swooping!")
		
		
func _on_magpie_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player exited the hitbox!")
		pick_random_direction()
		update_animation(last_direction)
		swoop_speed = 75
