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
var health = 50
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
		player.health -= 10  # Reduce health
		damage_timer = 0.0

		
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 50:
		healthbar.visible = false
	else: 
		healthbar.visible = true

func die():
	if health <= 0 and not is_dead:
		is_dead = true
		queue_free()
			
# Modified update_animation function
func update_animation(direction, swooping=false):
	if is_dead or is_attacking:  # Skip animation update if the enemy is dead or attacking
		return  
		
	if player_in_range and swooping:
		animated_sprite.play("fight")
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.flip_v = direction.y > 0
		is_attacking = true  # Set the flag to true
		return

	is_attacking = false  # Reset the flag

	animated_sprite.flip_h = false
	animated_sprite.flip_v = false

	if direction.x != 0:
		animated_sprite.play("fly_right")
		animated_sprite.flip_h = direction.x < 0
	elif direction.y < 0:
		animated_sprite.play("fly_up")
	elif direction.y > 0:
		animated_sprite.play("fly_up")
		animated_sprite.flip_v = true

func pick_random_direction():
	var new_direction = Vector2.ZERO
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction


func _on_territory_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		swoop = true

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
		animated_sprite.flip_v = position.y > body.position.y
		animated_sprite.flip_h = position.x > body.position.x
		
		
func _on_magpie_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player exited the hitbox!")
		pick_random_direction()
		update_animation(last_direction)
		swoop_speed = 75
