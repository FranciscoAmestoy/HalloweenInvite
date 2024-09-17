extends CharacterBody2D

var speed = 50
var swoop_speed = 75
var last_direction = Vector2.ZERO
var animated_sprite
var direction_change_timer = 0
var direction_change_interval = 3
var swoop = false
var player = null
var player_in_range = false

var min_position = Vector2(0, 0)
var max_position = Vector2(800, 430)

func _ready():
	animated_sprite = $AnimatedSprite2D
	pick_random_direction()
	add_to_group("Enemy")

func _physics_process(delta):
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

# Modified update_animation function
func update_animation(direction, swooping=false):
	if player_in_range and swooping:
		animated_sprite.play("magpie_fight")
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.flip_v = direction.y > 0
		return

	animated_sprite.flip_h = false
	animated_sprite.flip_v = false

	if direction.x != 0:
		animated_sprite.play("magpie_fly_right")
		animated_sprite.flip_h = direction.x < 0
	elif direction.y < 0:
		animated_sprite.play("magpie_fly_up")
	elif direction.y > 0:
		animated_sprite.play("magpie_fly_up")
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
		print("Swooping!")
		animated_sprite.flip_v = position.y > body.position.y
		animated_sprite.flip_h = position.x > body.position.x

func _on_magpie_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player exited the hitbox!")
		animated_sprite.flip_v = false
		animated_sprite.flip_h = false
