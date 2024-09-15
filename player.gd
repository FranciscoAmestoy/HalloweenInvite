extends CharacterBody2D

var speed = 100
var last_direction = Vector2.ZERO
var animated_sprite

func _ready():
	animated_sprite = $AnimatedSprite2D
	
func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		last_direction = direction
	if direction.x != 0:
		animated_sprite.play("Testchar_walk_right")
	elif direction.y < 0:
		animated_sprite.play("Testchar_walk_up")
	elif direction.y > 0:
		animated_sprite.play("Testchar_walk_down")
	else:
		if last_direction.x != 0:
			animated_sprite.play("Testchar_idle_right")
		elif last_direction.y < 0:
			animated_sprite.play("Testchar_idle_up")
		elif last_direction.y > 0:
			animated_sprite.play("Testchar_idle_down")
	
	animated_sprite.flip_h = last_direction.x <0
	
	move_and_slide()
