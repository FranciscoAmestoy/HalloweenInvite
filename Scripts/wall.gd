extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var point_light = $PointLight2D
@onready var numbers_label = $Numbers  # Assuming this is the RichTextLabel node

func _ready():
	# Check the state of Global.letter when the scene is loaded
	update_wall_visibility()

func _process(delta):
	# Continuously check if the wall should be visible/collidable
	update_wall_visibility()

func update_wall_visibility():
	if Global.letter < 4:
		# Make everything visible
		sprite.visible = true
		collision_shape.disabled = false
		point_light.visible = true
		numbers_label.visible = true
	else:
		# Hide everything and disable the collision
		sprite.visible = false
		collision_shape.disabled = true
		point_light.visible = false
		numbers_label.visible = false
